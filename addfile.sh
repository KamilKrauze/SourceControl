#!/bin/bash

repositoryPath=$1

read -p "Type in a filename for the new file: " filenameToAdd

if [ -z "$filenameToAdd" ]
then
    echo "Provided filename is empty"
    exit 1
fi

# get last commit folder
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)
fileWithSameNameInLastCommitFolder=$(ls "${repositoryPath}/.vc/$lastCommitFolder" | grep -w "$filenameToAdd")

if ! [ -z "$fileWithSameNameInLastCommitFolder" ]
then
    echo "A file with the same name already exists. Please specify a different name"
    exit 1
fi

# TODO: what if a file is identical to an UID?
if ! [ -z $(grep $UID ${repositoryPath}/.vc/.currently-checked-out-files.txt) ]
then
    echo "There is already a checked-out file. Check-in that file before adding a new file"
    exit 1
fi

touch ${repositoryPath}/$filenameToAdd

echo "New file $filenameToAdd created in the working directory. Use checkin to check it in the version control system"

# Mark the file as a checked-out file
echo "${filenameToAdd};$UID" >> ${repositoryPath}/.vc/.currently-checked-out-files.txt

# start backup process on the file
./backup-checkedout-file.sh $repositoryPath $filenameToAdd &