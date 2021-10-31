#!/bin/bash
chmod 774 *.sh
#Create variables that give text color - https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux - Date Visted: 19.10.2021
export RED="\033[0;31m"
export BLUE="\033[0;34m"
export CYAN="\033[0;36m"
export NC="\033[0m" #NC - No Color

export re='\^[0-9]+$' #Check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021

canCheckin=true
canCheckout=true

echo -e "Enter ${CYAN}'help'${NC} to get a command list."
echo -e "Enter ${CYAN}'quit'${NC} to exit CMS.\n\n"

optionsWhenRepoIsNotOpen=( "Create a repository" "Open a repository" "Delete a repository" "Show help" "Quit")
optionsWhenRepoIsOpenAndNoCheckedOutFile=( "Check-out a file" "Check-in files" "Edit a file (automatic check-out/in)" "Create a new file" "Rollback to an earlier version of repo" "Exit current repository" "Manage repo permissions" "Archive current repo" "Compile files in repo" "Show help" "Quit")
optionsWhenRepoIsOpenAndAFileCheckedOut=( "Check-in files" "Exit current repository" "Show help" "Quit")

# userIn="."
# inputArr=($userIn) #Separate strings if there is a space between them and pass into array - https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in - Date Visited: 19.10.2021

function checkCurrentStateAndSetMenuOptions {
    if [ -s currently-open-repo.txt ]
    then
        currentlyOpenedRepoName=$(cut -d ';' -f2 currently-open-repo.txt)
        currentlyOpenedRepoPath=$(cut -d ';' -f1 currently-open-repo.txt)
        echo " CMS.sh: You are currently working in repository: $currentlyOpenedRepoName (PATH: $currentlyOpenedRepoPath)"
        
        touch ${currentlyOpenedRepoPath}/.vc/.currently-checked-out-files.txt
        currentlyCheckedOutFile=$(grep $UID ${currentlyOpenedRepoPath}/.vc/.currently-checked-out-files.txt | cut -d ';' -f1)
        if ! [ -z $currentlyCheckedOutFile ]
        then
            echo " CMS.sh: You have a checked-out file in $currentlyOpenedRepoName: $currentlyCheckedOutFile"
            #https://stackoverflow.com/questions/19417015/how-to-copy-an-array-in-bash/34733375
            currentOptions=("${optionsWhenRepoIsOpenAndAFileCheckedOut[@]}")
        else
            echo -e "${BLUE}$0${NC}: You have no currently checked-out file.\n"
            #https://stackoverflow.com/questions/19417015/how-to-copy-an-array-in-bash/34733375
            currentOptions=("${optionsWhenRepoIsOpenAndNoCheckedOutFile[@]}")
        fi
    else
        echo -e "${BLUE}$0${NC}: There is no repo that is currently opened.\n"
        #https://stackoverflow.com/questions/19417015/how-to-copy-an-array-in-bash/34733375
        currentOptions=("${optionsWhenRepoIsNotOpen[@]}")
    fi
}

checkCurrentStateAndSetMenuOptions
isQuitSelected=0
while [ $isQuitSelected -eq 0 ]
do
    select menuOption in "${currentOptions[@]}"; do

        case $menuOption in 
        "Create a repository")
            ./createrepo.sh
        ;;
        "Open a repository")
            ./openrepo.sh
        ;;
        "Delete a repository")
            ./deleterepo.sh
        ;;
        "Exit current repository")
            ./exitrepo.sh
        ;;
        "Create a new file")
            ./addfile.sh $currentlyOpenedRepoPath
        ;;
        "Check-in files")
            ./checkin.sh $currentlyOpenedRepoPath
        ;;
        "Check-out a file")
            ./checkout.sh $currentlyOpenedRepoPath
        ;;
        "Rollback to an earlier version of repo")
            ./rollback.sh $currentlyOpenedRepoPath
        ;;
        "Manage repo permissions")
            ./managepermissions.sh $currentlyOpenedRepoPath
        ;;
        "Edit a file (automatic check-out/in)")
			./editfile.sh $currentlyOpenedRepoPath
		;;
        "Compile files in repo")
            ./compile.sh $currentlyOpenedRepoPath
        ;;
        "Archive current repo")
            ./archive.sh $currentlyOpenedRepoPath
        ;;
        "Quit")
            echo -n "Quiting" #Quits the script
            echo -n "."
            sleep 0.333
            echo -n "."
            sleep 0.333
            echo -n "."
            sleep 0.333
            clear
            exit 0
        ;;
        esac
    # todo show help option
    # todo archive option

        checkCurrentStateAndSetMenuOptions
        break
    done
done

echo "exit all"
exit 1

while [ "${inputArr[0]}" != "quit" ]
do
    
    
    read -e -p ">" userIn
    # method of enabling history copied from https://stackoverflow.com/questions/30068081/how-to-use-up-arrow-key-in-shell-script-to-get-previous-command
    history -s "$userIn"
    inputArr=($userIn) #Separate strings if there is a space between them and pass into array - https://stackoverflow.com/questions/1469849/how-to-split-one-string-into-multiple-strings-separated-by-at-least-one-space-in - Date Visited: 19.10.2021
    
    case ${inputArr[0]} in
        "help")
            # requires <page number>
            ./help.sh ${inputArr[@]:1}
        ;;
        # "createrepo")
        #     # requires [path] [name]
        #     ./createrepo.sh ${inputArr[@]:1}
        # ;;
        # "deleterepo")
        #     # requries <repoName>
        #     ./deleterepo.sh ${inputArr[@]:1}
        # ;;
        # "openrepo")
        #     echo "Opens repo" #Runs open repo script
        #     # requires [name], must be in repository-index.txt
        #     ./openrepo.sh ${inputArr[@]:1}
        # ;;
        # "exitrepo")
        #     echo "Exiting current repo"
        #     ./exitrepo.sh
        # ;;
        # "addfiles")
        #     echo "Files have been added" #Add file script
        #     #"${inputArr[@]:1}" #Get every element within the array except the first - https://stackoverflow.com/questions/6287419/getting-all-elements-of-a-bash-array-except-the-first - Date Visited: 19.10.2021
        # # ;;
        # "checkin")
        #     echo "Pushing to repo..." #Runs check in script
        #     # requires [pathOfRepo] [filename], pathOfRepo is automatically provided
        #     ./checkin.sh $currentlyOpenedRepoPath ${inputArr[@]:1}
        # ;;
        
        # "checkout")
        #     echo "Pulling from repo..." #Runs check out script
        #     # requires [pathOfRepo] [filename], pathOfRepo is automatically provided
        #     ./checkout.sh $currentlyOpenedRepoPath ${inputArr[@]:1}
        # ;;
        
        # "rollback")
        #     ./rollback.sh $currentlyOpenedRepoPath
        # ;;

        # "managepermissions")
        #     ./managepermissions.sh $currentlyOpenedRepoPath
        # ;;
        
        # "editfile")
		# 	./editfile.sh $currentlyOpenedRepoPath ${inputArr[@]:1}
		# 	  ;;
        
        # "addfile")
        #     ./addfile.sh $currentlyOpenedRepoPath ${inputArr[@]:1}
        # ;;
        # "compile")
        #     ./compile.sh ${inputArr[@]:1}
        # ;;
        
        # "quit")
        #     echo -n "Quiting" #Quits the script
        #     echo -n "."
        #     sleep 0.333
        #     echo -n "."
        #     sleep 0.333
        #     echo -n "."
        #     sleep 0.333
        #     clear
        #     exit
        # ;;
        
        *)
            echo -e "\t${RED}Command '$userIn' does not exist...${NC}\n\t\v- Use the ${BLUE}'help'${NC} command to get a list of commands this script supports." #Outputs if user input in incorrect
            continue
        ;;
    esac
done