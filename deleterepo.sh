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
		echo "Deleting repo..."
		repositoryPath=$(grep -w $1 repository-index.txt | cut -d ';' -f2)
		lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

		repoDetails=$(grep -w $repositoryPath repository-index.txt)
		usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)
		if ! echo $usersWithWriteAccess | grep -q $UID
		then
    		echo "You don't have the permission to delete this repository (no WRITE access)"
    		exit 1  
		fi
		
		if [ "$(ls -A ${repositoryPath}/.vc/${lastCommitFolder})" ] 
		then
			cp -l -r ${repositoryPath}/.vc/${lastCommitFolder}/* ${repositoryPath}
		fi
		rm -d -r ${repositoryPath}/.vc
		grep -v -w $1 repository-index.txt > temp.txt
		mv temp.txt repository-index.txt
	fi
}

if [ ${#arr[@]} -eq 1 ]; then
	checkIfRepoExists ${arr[@]}
else
	echo -e "\n\t${RED}Too many or not enough arguments used.${NC}"
	echo -e "\n\tThe command should be used like this: ${BLUE}deleterepo${NC} ${CYAN}<repoName>${NC}"
fi