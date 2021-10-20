#!/bin/bash
env | grep -q BLUE
env | grep -q RED
env | grep -q CYAN
env | grep -q NC
env | grep -q re

function page(){
	echo -e "\n\t\tPage -- $1 / 2 --"
	echo -e "\t#################################"
}

function commandList()
{
	echo -e "- ${BLUE}makerepo${NC} ${CYAN}<repoName>${NC} ${CYAN}<repoLocation>${NC} ${CYAN}<workingDirectory>${NC}\n - Creates a repository with a user specified name, the repository's location and working directory is specified by the user."
	echo -e "\n- ${BLUE}openrepo${NC} ${CYAN}<repoName>${NC} - Opens a repository, by specfying the repository's name."
	echo -e "\n- ${BLUE}addfiles${NC} ${CYAN}<filePath>${NC} - Adds file to the working directory's repository."
	echo -e "\n- ${BLUE}checkin${NC} - Checks in the working directory's files to the repository and updates if files have been modified."
	echo -e "\n- ${BLUE}checkout${NC} ${CYAN}<repoName>${NC}- Replaces the current files within the working directory from the repo."
}

arr=($@)

if [ ${#arr[@]} -eq 1 ]; #Checks if the array has 2 elements
then
	if ! [[ ${arr[@]} =~ $re ]]; #Check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021
	then
		page ${arr[@]}
		commandList
	else
		echo -e "Incorrect argument. Argument should be an integer.\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
	fi
else
	echo -e "Not enough or too many arguments for ${BLUE}'help'${NC}\n\t-Try ${BLUE}help${NC} ${CYAN}<pageNo>${NC}\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
fi

