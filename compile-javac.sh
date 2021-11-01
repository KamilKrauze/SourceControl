#!/bin/bash

# Kamil Krauze
# Matriculation Number: 2414951

# check if javac is installed, redirect output to null
javac --version >/dev/null 2>&1
if ! [ $? -eq 0 ]; then
	echo -e "JavaC compiler not installed on this system. Please install to use this feature."
	exit 1;
fi

repositoryPath=$1
# get files from the folder with the latest changes
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

# Find all .java files
# Resource used to help with storing output from the find command into a variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021
coutput=($(find $repositoryPath/.vc/$lastCommitFolder -type f -name "*.java"))

# Checks if .java source files exist for the compiler to use
if [ -z ${coutput[0]} ]; then
	echo "No source files found... exiting"
	exit 1;
fi

# run the compilation
javac ${coutput[@]}

echo "Compilation done."
