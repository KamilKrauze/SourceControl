#!/bin/bash

env | grep -q BLUE
env | grep -q CYAN
env | grep -q NC

echo -e "Here are your currently existing repositories: "

while IFS=';' read -r repoName repoPath
do
	echo -e "${BLUE}$repoName${NC}"
done < repository-index.txt
echo -e "${CYAN}----------<<<<< End of File >>>>>----------${NC}\n\n"