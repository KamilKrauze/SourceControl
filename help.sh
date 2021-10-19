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

arr=($@)

# for i in "${arr[@]:i}"
# 	do
# 		echo $i
# 	done
if [ ${#arr[@]} -eq 1 ]; #Checks if the array has 2 elements
then
	if ! [[ ${arr[@]} =~ $re ]]; #Check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021
	then
		page ${arr[@]}	
	else
		echo -e "Incorrect argument. Argument should be an integer.\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
	fi
else
	echo -e "Not enough or too many arguments for ${BLUE}'help'${NC}\n\t-Try ${BLUE}help${NC} ${CYAN}<pageNo>${NC}\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
fi

