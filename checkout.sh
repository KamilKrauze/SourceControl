#!/bin/bash

repositoryPath=$1
fileNameToCheckOut=$2

if [ -z $fileNameToCheckOut ]
then
    read -p "Type in the filename of the file to check-out: " fileNameToCheckOut
fi

touch ${repositoryPath}/.vc/.currently-checked-out-files.txt

if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
elif [ -z "$fileNameToCheckOut" ]
then
    echo "No file provided"
    exit 1
# TODO: what if a file is identical to an UID?
elif ! [ -z $(grep $UID ${repositoryPath}/.vc/.currently-checked-out-files.txt) ]
then
    echo "There is already a checked-out file. Check-in the file before checking-out another one"
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

# get last commit folder
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)
# find file in last commit folder
fileToCheckOut="${repositoryPath}/.vc/$lastCommitFolder/$fileNameToCheckOut"
echo $fileToCheckOut
if ! [ -e "$fileToCheckOut" ]
then
   echo "File to checkout does not exist"
   exit 1
fi

# https://unix.stackexchange.com/questions/94714/cp-l-vs-cp-h
cp -L $fileToCheckOut ${repositoryPath}

echo "${fileNameToCheckOut};$UID" >> ${repositoryPath}/.vc/.currently-checked-out-files.txt

./backup-checkedout-file.sh $repositoryPath $fileNameToCheckOut &