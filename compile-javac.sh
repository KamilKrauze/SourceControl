#!/bin/bash

javac --version >/dev/null 2>&1 # Command output suppression - \( ! -wholename $repositoryPath/.vc \)
if ! [ $? -eq 0 ]; then
	echo -e "JavaC compiler not installed on this system. Please install to use this feature."
	exit 1;
fi

repositoryPath=$1
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

coutput=($(find $repositoryPath/.vc/$lastCommitFolder -type f -name "*.java")) # Store output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021

if [ -z ${coutput[0]} ]; then
	echo "No source files found... exiting"
	exit 1;
fi

javac ${coutput[@]}