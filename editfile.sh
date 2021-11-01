#!/bin/bash

repositoryPath=$1

read -p "Type in the filename of the file you wish to edit: " checkOutFileName

# automatically check-out the file
checkOutFile=$repositoryPath/$checkOutFileName
./checkout.sh $repositoryPath $checkOutFileName

# make sure checkout.sh exited with no errors
if [ $? -eq 1 ]
then
    echo "File cannot be edited due to an error while checking-out, refer to above error messages"
    exit 1
fi

# start the external nano editor
nano $repositoryPath/$checkOutFileName

# once user exits from nano, file is automatically checked-in
./checkin.sh $repositoryPath $checkOutFileName
