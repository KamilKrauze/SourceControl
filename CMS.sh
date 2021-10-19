#!/bin/bash
#Create variables that give text color - https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux - Date Visted: 19.10.2021
export RED="\033[0;31m"
export BLUE="\033[0;34m"
export CYAN="\033[0;36m"
export NC="\033[0m" #NC - No Color

re='\^[0-9]+$' #Check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021

canCheckin=true
canCheckout=true

userIn="."
inputArr=($userIn) #Separate strings if there is a space between them and pass into array - https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in - Date Visited: 19.10.2021

while [ "${inputArr[0]}" != "quit" ]
do
	read -p ">" userIn
	inputArr=($userIn) #Separate strings if there is a space between them and pass into array - https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in - Date Visited: 19.10.2021

	if [ "${inputArr[0]}" == "help" ]
	then
		if [ ${#inputArr[@]} -eq 2 ]; #Checks if the array has 2 elements
		then
			if [[ ${inputArr[@]:1} =~ $re ]]; #Check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021
			then
				echo "Help me!" #Run help script
				echo "${inputArr[@]:1}"
			else
				echo -e "Incorrect argument. Argument is an integer.\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
			fi
		else
			echo -e "Not enough or too many arguments for ${BLUE}'help'${NC}\n\t-Try ${BLUE}help${NC} ${CYAN}<pageNo>${NC}\n\t-E.g - ${BLUE}help${NC} ${CYAN}3${NC}"
		fi
	
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
	
	else
		echo -e "\t${RED}Command '$userIn' does not exist...${NC}\n\t\v- Use the ${BLUE}'help'${NC} command to get a list of commands this script supports." #Outputs if user input in incorrect
		continue
	fi
done