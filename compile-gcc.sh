#!/bin/bash

gcc --version >/dev/null
if ! [ $? -eq 0 ]; then
	echo -e "GCC compiler not installed on this system. Please install to use this feature."
	exit
fi

repositoryPath=$(grep -w $1 repository-index.txt | cut -d ';' -f2)

# "\( ! -wholename $repositoryPath/.vc \)" tells the find command to ignore a specific directory - https://linuxconfig.org/how-to-explicitly-exclude-directory-from-find-command-s-search- 30/10/21 

coutput=($(find $repositoryPath -type f \( ! -wholename $repositoryPath/.vc \) -name "*.c")) # Store output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021
houtput=($(find $repositoryPath -type f \( ! -wholename $repositoryPath/.vc \) -name "*.h")) # Store output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021

if [ -z ${coutput[0]} ]; then
	echo "No source files found... exiting"
	exit
fi

read -p "Executable name: " execName

gcc -Werror -Wall -Wextra -o $repositoryPath/$execName ${coutput[@]} ${houtput[@]}