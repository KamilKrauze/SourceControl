#!/bin/bash

repositoryPath=$1

# if this script is called from editfile.sh script (which automatically checks-in a file), it'll get the file to check-in as an argument
# otherwise, user is asked which files to check-in
fileNameToCheckIn=$2

if [ -z $fileNameToCheckIn ]
then
    # ask user for which files to check-in until they type in 'end'
    filesToCheckIn=()
    while ! [ "$userInput" = "end" ]
    do
        read -p "Type in a filename you would like to check-in or type 'end' if you have no more files to check-in :" userInput
        if ! [ "$userInput" = "end" ]
        then
            # Resource used for adding to array: https://stackoverflow.com/questions/1951506/add-a-new-element-to-an-array-without-specifying-the-index-in-bash
            filesToCheckIn+=("$userInput")
        fi
    done 
else
    filesToCheckIn=( $fileNameToCheckIn )
fi

# Make sure user provided at least one file
# Resource used for checking length of array: https://stackoverflow.com/questions/65957633/check-if-array-is-empty-in-bash
if (( ${#filesToCheckIn[@]} == 0 ))
then
    echo "No files provided for check-in"
    exit 0
fi

if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
fi

# check the user has permission to check-in a file (WRITE permission)
repoDetails=$(grep -w $repositoryPath repository-index.txt)
usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)
if ! echo $usersWithWriteAccess | grep -q $UID
then
    echo "You don't have the permission to checkout files in this repository (no WRITE access)"
    exit 1  
fi

# Ask the user for details of changes
read -e -p "Commit Name: " nameOfCommit

# check all provided files are files that actually exist in the working directory
for file in ${filesToCheckIn[@]};
do
    fileToCheckIn=$repositoryPath/$file
    if ! [ -f "$fileToCheckIn" ]
    then
        echo "File $fileToCheckIn does not exist. No files have been committed."
        exit 1
    fi
done

# get folder with latest changes in repository
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

# create a folder for new changes
newCommitFolder="$(date '+%Y-%m-%d-%H-%M')_$(openssl rand -hex 3)"
mkdir ${repositoryPath}/.vc/${newCommitFolder}

# create a soft link in new commit folder linking to all files in the previous commit folder
# since soft links are relative paths, the script first need to switch directories
# ln --relative option exists, but seems to be unsupported on some systems
currentShellPath=$(pwd)
cd ${repositoryPath}/.vc/${newCommitFolder}
ln -s ../${lastCommitFolder}/* .
cd "$currentShellPath"

for file in ${filesToCheckIn[@]};
do
    # copy the checked-in files separately. It overwrites the soft link for those files and creates a hard copy
    # the end result are hard copies of files which were edited (checked-in) an soft links of files which were not edited
    mv -f $repositoryPath/$file ./${repositoryPath}/.vc/${newCommitFolder}
done

# write details to the log file
echo "${newCommitFolder};${nameOfCommit}" >> ${repositoryPath}/.vc/.changes-log.txt

# remove the file from the list of currently checked-out files to allow others to check it out
# TODO: make it only match whole word
grep -vE "($UID)" ${repositoryPath}/.vc/.currently-checked-out-files.txt > ${repositoryPath}/.vc/.temp.txt
mv ${repositoryPath}/.vc/.temp.txt ${repositoryPath}/.vc/.currently-checked-out-files.txt

echo "File checked-in."