#!/bin/bash
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

canCheckin=true
canCheckout=true

userIn="."
inputArr=($userIn)

while [ "${inputArr[0]}" != "quit" ]
do
	read -p "> " userIn
	inputArr=($userIn) #Separate strings if there is a space between them and pass into array - https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in - Date Visited: 19.10.2021

	if [ "$1" == "help" ]
	then
		echo "Help me!" #Run help script
		../Bash\ Scripts/functionTest.sh
	
	elif [ "${inputArr[0]}" == "mkrepo" ];
	then
		echo "Create new repo" #Runs Create repo script 
	
	elif [ "${inputArr[0]}" == "openrepo" ];
	then
		echo "Opens repo" #Runs open repo script
	
	elif [ "${inputArr[0]}" == "addfiles" ];
	then
		echo "Files have been added" #Add file script
		#"${inputArr[@]:1}" #Get every element within the array except the first - https://stackoverflow.com/questions/6287419/getting-all-elements-of-a-bash-array-except-the-first - Date Visited: 19.10.2021

	elif [ "${inputArr[0]}" == "checkin" ];
	then
		canCheckin=false
		export canCheckin
		export canCheckout

		echo "Pushing to repo..." #Runs check in script
		./checkin.sh

	elif [ "${inputArr[0]}" == "checkout" ];
	then
		canCheckout=false
		export canCheckin
		export canCheckout

		echo "Pulling from repo..." #Runs check out script
		./checkout.sh
	
	elif [ "${inputArr[0]}" == "quit" ];
	then
		echo -e "Quiting..." #Quits the script
		sleep .7
	
	else
		echo -e "\t${RED}Command '$userIn' does not exist...${NC}\n\t\v- Use the ${BLUE}'help'${NC} command to get a list of commands this script supports." #Outputs if user input in incorrect
		continue
	fi
done