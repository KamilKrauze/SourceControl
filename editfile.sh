#!/bin/bash

#argument is just the filename
backupEdit () {
  #checking if there is a backups folder
  if [ -d backup ]
  then
    echo "this directory exists"
  else
    mkdir backup
  fi
  cp $1 backup
  
}

edit () {
  nano $1
}

