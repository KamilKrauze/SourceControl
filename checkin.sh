#!/bin/bash

#TO-DO: make the file available to other users to edit

arr=($@)

repositoryPath=${arr[0]}

if ! [ -d "$repositoryPath" ]
then
    echo "The repository has an invalid path"
    exit 1
fi

read -e -p "Commit Name: " nameOfCommit

# get last commit folder
# NB: the log file must be a hidden file so it doesnt show up here
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

newCommitFolder="$(date '+%Y-%m-%d-%H-%M')_$(openssl rand -hex 3)"
mkdir ${repositoryPath}/.vc/${newCommitFolder}
# create soft link to all files from last commit folder, relative to the path of the original file
ln -s -r ${repositoryPath}/.vc/${lastCommitFolder}/* ./testRepo/.vc/${newCommitFolder}
# copy the checked-in file separately so it is not a soft link

for file in ${arr[@]:1};
do
    fileToCheckIn=$repositoryPath/$file
    if [ -f "$fileToCheckIn" ]
    then
       mv -f ${fileToCheckIn} $_ 
    fi
done

echo "${newCommitFolder};${nameOfCommit}" >> ${repositoryPath}/.vc/.changes-log.txt

# remove the file from the list of currently checked-out files
# TODO: make it only match whole word
grep -vE "($UID)" ${repositoryPath}/.vc/.currently-checked-out-files.txt > ${repositoryPath}/.vc/.temp.txt
mv ${repositoryPath}/.vc/.temp.txt ${repositoryPath}/.vc/.currently-checked-out-files.txt