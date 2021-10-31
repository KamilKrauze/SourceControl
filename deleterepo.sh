#!/bin/bash

env | grep -q BLUE
env | grep -q RED
env | grep -q CYAN
env | grep -q NC

read -p "Type in the name of the repository you'd like to delete: " repositoryName

#todo whole word
if ! grep -q $repositoryName repository-index.txt
then
	echo -e "\n\t${RED}- Repository name does not exist.\n\t- Please enter a repository that exists${NC}"
else
	echo "Deleting repo..."
	repositoryPath=$(grep -w $repositoryName repository-index.txt | cut -d ';' -f2)
	lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)
	repoDetails=$(grep -w $repositoryPath repository-index.txt)
	usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)
	if ! echo $usersWithWriteAccess | grep -q $UID
	then
		echo "You don't have the permission to delete this repository (no WRITE access)"
		exit 1  
	fi

	existingPasswordHash=$(echo $repoDetails | cut -d ';' -f5)
	if ! [ -z "$existingPasswordHash" ]
	then
    	echo "That repository is password-protected."
		read -p "Type in the password: " passwordInput
		hashedPasswordInput=$(echo -n $passwordInput | sha1sum | cut -d ' ' -f1)
		if ! [ "$existingPasswordHash" = "$hashedPasswordInput" ]
		then
			echo "Password is wrong, deletion cancelled."
			exit 1
		else
			echo "Correct password Deleting, remove exit 1"
			exit 1
		fi
	fi

	
	if [ "$(ls -A ${repositoryPath}/.vc/${lastCommitFolder})" ] 
	then
		cp -l -r ${repositoryPath}/.vc/${lastCommitFolder}/* ${repositoryPath}
	fi
	rm -d -r ${repositoryPath}/.vc
	grep -v -w $repositoryName repository-index.txt > temp.txt
	mv temp.txt repository-index.txt
fi