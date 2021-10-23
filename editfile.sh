#!/bin/bash

#$1 is the repositoryPath and $2 is the fileNameToCheckOut from checkout.sh
backupCheckOut () {
  #checking if there is a backups folder
  if [ -d backup ]
  then
    echo "this directory exists"
  else
    mkdir backup
  fi
#  STRUGGLING TO MAKE THE CONDITION FOR THE WHILE
# I'm using the repositoryPath and fileNameToCheckOut from checkout.sh
#  while [  ]
#  do
#    sleep 5
#    cp "$2" backup
#  done
}