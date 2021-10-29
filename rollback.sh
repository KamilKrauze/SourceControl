repositoryPath=$1

#todo: maybe if a user has checked out files, prevent them from doing rollback
# what if another user a checked out file?

echo "Listing out the changes made in the repository:"
echo

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
    if [ -z $userComment ]
    then 
        userComment="[none]"
    fi

    echo "Name of change: $directoryBasename User comment: $userComment Files modified: $filesModified"
done

echo
# todo switch to a select menu
# add option to just see diff
read -p "Which change do you want to revert to?" changeToRevertTo

# todo: this could be more robust
if ! grep $changeToRevertTo $repositoryPath/.vc/.changes-log.txt
then
    echo "Not a valid name of change, cancelling rollback"
    exit
fi

echo

for directory in $repositoryPath/.vc/* ; do
    directoryBasename=$(basename $directory)
    # https://stackoverflow.com/questions/8980791/shell-scripting-which-word-is-first-alphabetically
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