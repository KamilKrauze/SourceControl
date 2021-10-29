#!/bin/bash


repositoryPath=$1
checkOutFileName=$2
checkOutFile=$repositoryPath/$checkOutFileName
#Checks out the file and then immediately starts working on it with nano, once the user has quit nano they will be prompted with the commit message to check in
./checkout.sh $repositoryPath $checkOutFileName
nano $repositoryPath/$checkOutFileName
./checkin.sh $repositoryPath $checkOutFileName
