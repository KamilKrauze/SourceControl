repositoryPath=$1

# check user permissions (WRITE access to repository)
repoDetails=$(grep -w $repositoryPath repository-index.txt)
usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)
if ! echo $usersWithWriteAccess | grep -q $UID
then
    echo "You don't have the permission to rollback files in this repository (no WRITE access)"
    exit 1  
fi

echo "Listing out the changes made in the repository:"
echo

# list out all the checked-in changes together with user comments
for directory in $repositoryPath/.vc/* ; do
    
    filesModified=""
    for file in $directory/* ; do
        # files which were edited are the ones that aren't a soft link to a previous version
        if ! [ -L $file ]
        then    
            filesModified="$filesModified $(basename $file)"
        fi
    done
    
    directoryBasename=$(basename $directory)
    userComment=$(grep "$directoryBasename" $repositoryPath/.vc/.changes-log.txt | cut -d ';' -f2)
    # replace empty string with [none]
    if [ -z $userComment ]
    then 
        userComment="[none]"
    fi

    printf "Name of change: %-10s User comment: %-20s Files modified: %s\n" $directoryBasename $userComment "$filesModified"
done

echo

read -p "Which change do you want to revert to? " changeToRevertTo

if ! grep $changeToRevertTo $repositoryPath/.vc/.changes-log.txt
then
    echo "Not a valid name of change, cancelling rollback"
    exit
fi

echo

# delete all folders with changes that happened after the folder user is rolling back to
for directory in $repositoryPath/.vc/* ; do
    directoryBasename=$(basename $directory)
    # Resource used to help alphabetical comparison: https://stackoverflow.com/questions/8980791/shell-scripting-which-word-is-first-alphabetically
    if [[ $directoryBasename > $changeToRevertTo ]]
    then
        rm -r $directory
    fi
done

# delete all lines in changes-log.txt after the line the user reverted to
touch .tmp.txt
while read line
do
   currentChangeName=$(echo $line | cut -d ';' -f1)
   if ! [[ $currentChangeName > $changeToRevertTo ]]
   then
        echo "preserving $line"
        echo $line >> .tmp.txt
    else
        echo "deleting line $line"
   fi
done < $repositoryPath/.vc/.changes-log.txt
mv .tmp.txt $repositoryPath/.vc/.changes-log.txt

echo "Rollback complete"