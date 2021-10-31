#!/bin/bash

fileNameToCheckIn=$2

if [ -z $fileNameToCheckIn ]
then
    filesToCheckIn=()
    while ! [ "$userInput" = "end" ]
    do
        read -p "Type in a filename you would like to check-in or type 'end' if you have no more files to check-in :" userInput
        if ! [ "$userInput" = "end" ]
        then
            # https://stackoverflow.com/questions/1951506/add-a-new-element-to-an-array-without-specifying-the-index-in-bash
            filesToCheckIn+=("$userInput")
        fi
    done 
else
    filesToCheckIn=( $fileNameToCheckIn )
fi

# https://stackoverflow.com/questions/65957633/check-if-array-is-empty-in-bash
if (( ${#filesToCheckIn[@]} == 0 ))
then
    echo "No files provided for check-in"
    exit 0
fi

repositoryPath=$1

if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
fi

# check user permissions
repoDetails=$(grep -w $repositoryPath repository-index.txt)
usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)
if ! echo $usersWithWriteAccess | grep -q $UID
then
    echo "You don't have the permission to checkout files in this repository (no WRITE access)"
    exit 1  
fi

read -e -p "Commit Name: " nameOfCommit

# check all provided files are files that exist in the working directory
for file in ${filesToCheckIn[@]};
do
    fileToCheckIn=$repositoryPath/$file
    if ! [ -f "$fileToCheckIn" ]
    then
        echo "File $fileToCheckIn does not exist. No files have been committed."
        exit 1
    fi
done

# get last commit folder
# NB: the log file must be a hidden file so it doesnt show up here
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

newCommitFolder="$(date '+%Y-%m-%d-%H-%M')_$(openssl rand -hex 3)"
mkdir ${repositoryPath}/.vc/${newCommitFolder}

# TODO: delete this when ready
# create soft link to all files from last commit folder, relative to the path of the original file
# ln -s -r ${repositoryPath}/.vc/${lastCommitFolder}/* ./${repositoryPath}/.vc/${newCommitFolder}

# since soft links are relative paths, the script first need to switch directories
# ln --relative option exists, but seems to be unsupported on some systems
currentShellPath=$(pwd)
cd ${repositoryPath}/.vc/${newCommitFolder}
ln -s ../${lastCommitFolder}/* .
cd "$currentShellPath"

for file in ${filesToCheckIn[@]};
do
    # copy the checked-in files separately so they are not a soft link
    mv -f $repositoryPath/$file ./${repositoryPath}/.vc/${newCommitFolder}
done

echo "${newCommitFolder};${nameOfCommit}" >> ${repositoryPath}/.vc/.changes-log.txt

# remove the file from the list of currently checked-out files
# TODO: make it only match whole word
grep -vE "($UID)" ${repositoryPath}/.vc/.currently-checked-out-files.txt > ${repositoryPath}/.vc/.temp.txt
mv ${repositoryPath}/.vc/.temp.txt ${repositoryPath}/.vc/.currently-checked-out-files.txt