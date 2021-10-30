#!/bin/bash

repositoryPath=$(grep -w $1 repository-index.txt | cut -d ';' -f2)

coutput=($(find $repositoryPath -type f -name "*.c")) # Store output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021

houtput=($(find $repositoryPath -type f -name "*.h")) # Store output from the find command into variable - https://stackoverflow.com/questions/2087001/how-can-i-process-the-results-of-find-in-a-bash-script/2087038 - 30/10/2021

read -p "Executable name: " execName

gcc -Werror -Wall -Wextra -o $repositoryPath/$execName ${coutput[@]} ${houtput[@]}