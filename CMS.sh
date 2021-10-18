#!/bin/bash
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

userIn="."
while [ "$userIn" != "quit" ]
do
	read -p "> " userIn

	if [ "$userIn" == "help" ]
	then
		echo "Help me!" #Run help script
		../Bash\ Scripts/functionTest.sh
	
	elif [ "$userIn" == "mkrepo" ];
	then
		echo "Create new repo" #Runs Create repo script 
	
	elif [ "$userIn" == "openrepo" ];
	then
		echo "Opens repo" #Runs open repo script
	
	elif [ "$userIn" == "addfiles" ];
	then
		echo "Files have been added" #Add file script

	elif [ "$userIn" == "checkin" ];
	then
		echo "Pushing to repo..." #Runs check in script

	elif [ "$userIn" == "checkout" ];
	then
		echo "Pulling from repo..." #Runs check out script
	
	elif [ "$userIn" == "quit" ];
	then
		echo -e "Quiting..." #Quits the script
		sleep .7
	
	else
		echo -e "\t${RED}Command '$userIn' does not exist...${NC}\n\t\v- Use the ${BLUE}'help'${NC} command to get a list of commands this script supports." #Outputs if user input in incorrect
		continue
	fi
done