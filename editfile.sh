#!/bin/bash
repositoryPath=$1
checkedOutFileName=$2
checkedOutFile=$repositoryPath/$checkedOutFileName

backupFolder=${repositoryPath}/.vc/.BackupFolder

#checks if the backup folder exists
if ! [ -d $backupFolder ]
then
  mkdir ${backupFolder}
fi

#copies the initial file in the backup
cp $checkedOutFile $backupFolder

#todo look into this
#prints because the program does not run in the background without it for some reason
echo "Running the background backup..."

#main function
backupCheckOut () {
  #checks if the filename exists in the text file .currently-checked-out-files.txt
while ! [ -z $(grep $checkedOutFileName ${repositoryPath}/.vc/.currently-checked-out-files.txt) ]
do
  #todo: how to increase to 60? Maybe have the file name inside the backup folder name
  #sleeps every 1s because the folder will delete itself after 60 seconds even if something else has been checked in during that time
  sleep 1

  #https://stackoverflow.com/questions/3611846/bash-using-the-result-of-a-diff-in-a-if-statement
  DIFF=$(diff -q $checkedOutFile $backupFolder/$checkedOutFileName)

  # fixed "too many arguments" error with help of https://stackoverflow.com/questions/13781216/meaning-of-too-many-arguments-error-from-if-square-brackets/13781217#13781217
  if ! [ -z "$DIFF" ]
  then
    cp $checkedOutFile $backupFolder
  fi
done
}
#calls the function
backupCheckOut

#removes the function once the while loop is finished
rm -r $backupFolder
