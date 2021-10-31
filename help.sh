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
	case $1 in
		"1")
	printf "%s- ${BLUE}makerepo${NC} ${CYAN}<repoLocation>${NC} ${CYAN}<repoName>${NC} - Creates a repository with the user specified name. Or if the directory already exists then it links it to the repository." | fold -s
	printf "%s\n- ${BLUE}openrepo${NC} ${CYAN}<repoName>${NC} - Opens a repository, by specfying the repository's name." | fold -s
	printf "%s\n- ${BLUE}addfiles${NC} ${CYAN}<repoName>${NC} ${CYAN}<file(s)>${NC} - Adds file to the specified repository from the working directory." | fold -s
	printf "%s\n- ${BLUE}checkin${NC} ${CYAN}<repoName>${NC} ${CYAN}<file(s)>${NC} - Checks in the working directory's files to the repository and updates if files have been modified." | fold -s
	printf "%s\n- ${BLUE}checkout${NC} ${CYAN}<repoName>${NC} ${CYAN}<file(s)>${NC} - Replaces the current files within the working directory from the repo.\n\n" | fold -s
	;;
		"2")
	printf "%s\n- ${BLUE}backup${NC} ${CYAN}<repoName>${NC} - Creates a back up of the specified repository's working directory." | fold -s
	printf "%s\n- ${BLUE}editfile${NC} ${CYAN}<file(s)>${NC} - Gives the ability to edit the file within the terminal." | fold -s
	printf "%s\n- ${BLUE}deleterepo${NC} ${CYAN}<repoName>${NC} - Deletes the repository link from the specified directory and from the repository index, also copying the most recent commit to the working directory." | fold -s
	printf "%s\n- ${BLUE}compile${NC} ${CYAN}<compiler>${NC} ${CYAN}<repoName>${NC} - Compiles the working directory, specified by the repository name and compiler. If the compiler is not installed on the system, the script will be interupted.\n\n" | fold -s
	;;
		*)
	printf "%s\n${RED}ERROR: Page number input does not exist enter anything between 1-2${NC}" | fold -s
	;;
esac
}

arr=($@)

if [ ${#arr[@]} -eq 1 ]; #Checks if the array has 2 elements
then
	if ! [[ ${arr[@]} =~ $re ]]; #Check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021
	then
		page ${arr[@]}
		commandList ${arr[@]}
	else
		echo -e "Incorrect argument. Argument should be an integer.\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
	fi
else
	echo -e "Not enough or too many arguments for ${BLUE}'help'${NC}\n\t-Try ${BLUE}help${NC} ${CYAN}<pageNo>${NC}\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
fi

