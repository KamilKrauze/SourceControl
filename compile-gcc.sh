#!/bin/bash

# check if gcc is installed, redirect output to null
gcc --version >/dev/null 2>&1
if ! [ $? -eq 0 ]; then
	echo -e "GCC compiler not installed on this system. Please install to use this feature."
	exit
fi

repositoryPath=$1
# get files from the folder with the latest changes
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

# Find all .c and .h files
# Resource used to help with storing output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021
coutput=($(find $repositoryPath/.vc/$lastCommitFolder -type f -name "*.c"))
houtput=($(find $repositoryPath/.vc/$lastCommitFolder -type f -name "*.h")) 

if [ -z ${coutput[0]} ]; then
	echo "No source files found... exiting"
	exit
fi

# ask the user for the output filename
read -p "Executable name: " execName

# run the compilation
gcc -Werror -Wall -Wextra -o $repositoryPath/$execName ${coutput[@]} ${houtput[@]}

echo "Compilation done."