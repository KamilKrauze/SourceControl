#!/bin/bash
# env | grep canCheckin
# env | grep canCheckout

# echo $canCheckin
# echo $canCheckout
echo "Grabbing from repo..."

repositoryPath=$1
fileNameToCheckOut=$2

touch ${repositoryPath}/.vc/.currently-checked-out-files.txt

if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
#TODO: shouldnt it be fileNameToCheckOut?
elif ! [ -z "$fileToCheckIn" ]
then
    echo "No file provided"
    exit 1
# TODO: what if a file is identical to an UID?
elif ! [ -z $(grep $UID ${repositoryPath}/.vc/.currently-checked-out-files.txt) ]
then
    echo "There is already a checked-out file. Check-in the file before checking-out another one"
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
cp -L $fileToCheckOut ${repositoryPath}

echo "${fileNameToCheckOut};$UID" >> ${repositoryPath}/.vc/.currently-checked-out-files.txt

./editfile.sh $repositoryPath $fileNameToCheckOut &