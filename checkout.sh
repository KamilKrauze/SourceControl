#!/bin/bash
# env | grep canCheckin
# env | grep canCheckout

# echo $canCheckin
# echo $canCheckout
echo "Grabbing from repo..."

repositoryPath=$1
fileNameToCheckOut=$2

if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
elif ! [ -z "$fileToCheckIn" ]
then
    echo "No file provided"
    exit 1
fi

# get last commit folder
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)
# find file in last commit folder
fileToCheckOut="${repositoryPath}/.vc/$lastCommitFolder/$fileNameToCheckOut"
echo $fileToCheckOut
#if ! [ -e "$fileToCheckOut" ]
#then
#    echo "File to checkout does not exist"
#    exit 1
#fi

# https://unix.stackexchange.com/questions/94714/cp-l-vs-cp-h
cp -l $fileToCheckOut ${repositoryPath}

touch ${repositoryPath}/.vc/.currently-checked-out-files.txt
echo "${fileNameToCheckOut};$UID" >> ${repositoryPath}/.vc/.currently-checked-out-files.txt