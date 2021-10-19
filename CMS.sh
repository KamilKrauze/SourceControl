#!/bin/bash
#Create variables that give text color - https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux - Date Visted: 19.10.2021
export RED="\033[0;31m"
export BLUE="\033[0;34m"
export CYAN="\033[0;36m"
export NC="\033[0m" #NC - No Color

export re='\^[0-9]+$' #Check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021

canCheckin=true
canCheckout=true

userIn="."
inputArr=($userIn) #Separate strings if there is a space between them and pass into array - https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in - Date Visited: 19.10.2021

while [ "${inputArr[0]}" != "quit" ]
do
	read -p ">" userIn
	inputArr=($userIn) #Separate strings if there is a space between them and pass into array - https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in - Date Visited: 19.10.2021

	case ${inputArr[0]} in
		"help")
			echo "Help me!" #Run help script
			./help.sh ${inputArr[@]:1}
		;;
		"makerepo")
			echo "Create new repo" #Runs Create repo script
			;;
		"openrepo")
			echo "Opens repo" #Runs open repo script
			;;
		"addfiles")
			echo "Files have been added" #Add file script
			#"${inputArr[@]:1}" #Get every element within the array except the first - https://stackoverflow.com/questions/6287419/getting-all-elements-of-a-bash-array-except-the-first - Date Visited: 19.10.2021
			;;
		"checkin")
			canCheckin=false
			export canCheckin
			export canCheckout

			echo "Pushing to repo..." #Runs check in script
			./checkin.sh
			;;

		"checkout")
			canCheckout=false
			export canCheckin
			export canCheckout

			echo "Pulling from repo..." #Runs check out script
			./checkout.sh
			;;
	
		"quit")
			echo -e "Quiting..." #Quits the script
			;;
	
		*)
		echo -e "\t${RED}Command '$userIn' does not exist...${NC}\n\t\v- Use the ${BLUE}'help'${NC} command to get a list of commands this script supports." #Outputs if user input in incorrect
		continue
		;;
	esac
done