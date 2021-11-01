#!/bin/bash

# Zvony Delas 
# Matriculation Number: 2425681

repositoryPath=$1

# if this script is called from editfile.sh script (which automatically checks-out a file), it'll get the file to check-in as an argument
# otherwise, user is asked which file to check-out
fileNameToCheckOut=$2

if [ -z $fileNameToCheckOut ]
then
    read -p "Type in the filename of the file to check-out: " fileNameToCheckOut
fi

# create a file to keep track of checked-out files, preventing others from checking-out the same file
touch ${repositoryPath}/.vc/.currently-checked-out-files.txt

# input validation
if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
elif [ -z "$fileNameToCheckOut" ]
then
    echo "No file provided"
    exit 1
# check the current user doesn't already have a checked-out file
elif ! [ -z $(grep $UID ${repositoryPath}/.vc/.currently-checked-out-files.txt) ]
then
    echo "There is already a checked-out file. Check-in the file before checking-out another one"
    exit 1
elif ! [ -z $(grep $fileNameToCheckOut ${repositoryPath}/.vc/.currently-checked-out-files.txt) ]
then
    echo "The file was checked-out by someone else. You can only check it OUT after they check it IN."
    exit 1
fi

# check user permissions (WRITE access to repository)
repoDetails=$(grep -w $repositoryPath repository-index.txt)
usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)
if ! echo $usersWithWriteAccess | grep -q $UID
then
    echo "You don't have the permission to checkout files in this repository (no WRITE access)"
    exit 1  
fi

# get folder with latest changes
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)
# find the file in latest changes folder
fileToCheckOut="${repositoryPath}/.vc/$lastCommitFolder/$fileNameToCheckOut"

# check the file exists
if ! [ -e "$fileToCheckOut" ]
then
   echo "File to checkout does not exist"
   exit 1
fi

# copy the file to the working directory
# Resource used to resolve soft links: https://unix.stackexchange.com/questions/94714/cp-l-vs-cp-h
cp -L $fileToCheckOut ${repositoryPath}

# mark the file as checked-out 
echo "${fileNameToCheckOut};$UID" >> ${repositoryPath}/.vc/.currently-checked-out-files.txt

echo "File has been checked-out."

# start the script to backup the file automatically
./backup-checkedout-file.sh $repositoryPath $fileNameToCheckOut &