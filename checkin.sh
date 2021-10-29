#!/bin/bash

arr=($@)

if ! [ "$#" -ge 2 ]; then
    echo "Not enough arguments provided"
    exit 1
fi

repositoryPath=${arr[0]}

if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
fi

read -e -p "Commit Name: " nameOfCommit

# check all provided files are files that exist in the working directory
for file in ${arr[@]:1};
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

for file in ${arr[@]:1};
do
    # copy the checked-in files separately so they are not a soft link
    mv -f $repositoryPath/$file ./${repositoryPath}/.vc/${newCommitFolder}
done

echo "${newCommitFolder};${nameOfCommit}" >> ${repositoryPath}/.vc/.changes-log.txt

# remove the file from the list of currently checked-out files
# TODO: make it only match whole word
grep -vE "($UID)" ${repositoryPath}/.vc/.currently-checked-out-files.txt > ${repositoryPath}/.vc/.temp.txt
mv ${repositoryPath}/.vc/.temp.txt ${repositoryPath}/.vc/.currently-checked-out-files.txt