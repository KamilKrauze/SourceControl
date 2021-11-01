#!/bin/bash

# Kamil Krauze
# Matriculation Number: 2414951

# get variables for text colours
env | grep -q BLUE
env | grep -q CYAN
env | grep -q NC

echo -e "Here are your currently existing repositories: "

# Read line by line from file and split line by delimeter - https://zaiste.net/posts/shell-split-string-reading-file/ - 31/10/2021
while IFS=';' read -r repoName repoPath
do
	echo -e "${BLUE}$repoName${NC} in path $repoPath"
done < repository-index.txt

echo -e "${CYAN}----------<<<<< End of File >>>>>----------${NC}\n\n"