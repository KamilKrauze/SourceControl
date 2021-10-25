#!/bin/bash

env | grep -q BLUE
env | grep -q RED
env | grep -q CYAN
env | grep -q NC

arr=($@)

function checkIfRepoExists()
{
	if ! grep -q $1 repository-index.txt
	then
		echo -e "\n\t${RED}- Repository name does not exist.\n\t- Please enter a repository that exists${NC}"
	else
		echo "Deleting repo"
	fi
}

if [ ${#arr[@]} -eq 1 ]; then
	checkIfRepoExists ${arr[@]}
else
	echo -e "\n\t${RED}Too many or not enough arguments used.${NC}"
	echo -e "\n\tThe command should be used like this: ${BLUE}deleterepo${NC} ${CYAN}<repoName>${NC}"
fi