#!/bin/bash
repositoryPath=$1
checkedOutFileName=$2
checkedOutFile=$repositoryPath/$checkedOutFileName

backupFolder=${repositoryPath}/.vc/.tempBackupFolder

# checks if the backup folder exists
if ! [ -d $backupFolder ]
then
  mkdir ${backupFolder}
fi

# copies the initial file in the backup
cp $checkedOutFile $backupFolder

echo "Running the background backup..."

# main function
backupCheckOut () {
# checks if the file is still checked-out and needs to be backed-up
while ! [ -z $(grep $checkedOutFileName ${repositoryPath}/.vc/.currently-checked-out-files.txt) ]
do
  sleep 60

  # checks if the file exists still (in case user accidentally deletes it)
  if [ -f $checkedOutFile ]
  then
    # Resource used to help with comparing files: https://stackoverflow.com/questions/3611846/bash-using-the-result-of-a-diff-in-a-if-statement
    DIFF=$(diff -q $checkedOutFile $backupFolder/$checkedOutFileName)

    # if file has been changed, copy over the newest version to the backup folder
    # fixed "too many arguments" error with help of https://stackoverflow.com/questions/13781216/meaning-of-too-many-arguments-error-from-if-square-brackets/13781217#13781217
    if ! [ -z "$DIFF" ]
    then
      cp $checkedOutFile $backupFolder
    fi
  # if the file has been deleted (accidentally), copy it from the backup to the working directory (auto-restore)
  else
    cp $backupFolder/$checkedOutFileName $repositoryPath 
  fi
done
}

backupCheckOut

# removes the backup folder once the while loop is finished
rm -r $backupFolder/$checkedOutFileName
