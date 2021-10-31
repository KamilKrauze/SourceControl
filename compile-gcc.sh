#!/bin/bash

gcc --version >/dev/null 2>&1 # Command output suppression - \( ! -wholename $repositoryPath/.vc \)
if ! [ $? -eq 0 ]; then
	echo -e "GCC compiler not installed on this system. Please install to use this feature."
	exit
fi

repositoryPath=$1
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

coutput=($(find $repositoryPath/.vc/$lastCommitFolder -type f -name "*.c")) # Store output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021
houtput=($(find $repositoryPath/.vc/$lastCommitFolder -type f -name "*.h")) # Store output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021

if [ -z ${coutput[0]} ]; then
	echo "No source files found... exiting"
	exit
fi

read -p "Executable name: " execName

gcc -Werror -Wall -Wextra -o $repositoryPath/$execName ${coutput[@]} ${houtput[@]}