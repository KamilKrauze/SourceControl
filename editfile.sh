#!/bin/bash


repositoryPath=$1
checkOutFileName=$2
checkOutFile=$repositoryPath/$checkOutFileName




# automatically check-out the file
./checkout.sh $repositoryPath $checkOutFileName

if [ $? -eq 1 ]
then
    echo "File cannot be edited due to an error while checking-out, refer to above error messages"
    exit 1
fi

# starts the external nano editor
nano $repositoryPath/$checkOutFileName

# once user exits from nano, file is automatically checked-in
./checkin.sh $repositoryPath $checkOutFileName
