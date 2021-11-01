#!/bin/bash

# Kamil Krauze
# Matriculation Number: 2414951

# Zvony Delas 
# Matriculation Number: 2425681

# adjust permissions for all scripts
chmod 774 *.sh
#Create variables that give text color - https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux - Date Visted: 19.10.2021
export RED="\033[0;31m"
export BLUE="\033[0;34m"
export CYAN="\033[0;36m"
#NC - No Color
export NC="\033[0m" 

# Regex to check if variable is an integer - https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash/806923 - Date Visited: 19.10.2021
export re='\^[0-9]+$'

# create arrays of menu options:
# options to display if no repository is currently open
optionsWhenRepoIsNotOpen=( "Create a repository" "Open a repository" "List existing repositories" "Delete a repository" "Show help" "Quit")
# options to display if a repository is open, but there is no checked-out file
optionsWhenRepoIsOpenAndNoCheckedOutFile=( "Check-out a file" "Check-in files" "Edit a file (automatic check-out/in)" "Create a new file" "List files in current repo" "Rollback to an earlier version of repo" "Exit current repository" "Manage repo permissions" "Password protect repo from deletion" "Archive current repo" "Compile files in repo" "Show help" "Quit")
# options to display if a repository is open and a file currently checked-out
optionsWhenRepoIsOpenAndAFileCheckedOut=( "Check-in files" "List files in current repo" "Exit current repository" "Show help" "Quit")

# check the currently-open-repo.txt to see if a repo is open and display appropriate menu options array
# also sets currentlyOpenedRepoName and currentlyOpenedRepoPath variables which are automatically passed to scripts
function checkCurrentStateAndSetMenuOptions {

    # create visual separation from last command output
    echo
    echo "--------------------------------"
    
    repoThatCurrentUserHasOpen=$(grep $UID currently-open-repo.txt)
    if ! [ -z $repoThatCurrentUserHasOpen ]
    then
        currentlyOpenedRepoName=$(echo $repoThatCurrentUserHasOpen | cut -d ';' -f2)
        currentlyOpenedRepoPath=$(echo $repoThatCurrentUserHasOpen | cut -d ';' -f1)
        echo "CMS.sh: You are currently working in repository: $currentlyOpenedRepoName (PATH: $currentlyOpenedRepoPath)"
        
        touch ${currentlyOpenedRepoPath}/.vc/.currently-checked-out-files.txt
        currentlyCheckedOutFile=$(grep $UID ${currentlyOpenedRepoPath}/.vc/.currently-checked-out-files.txt | cut -d ';' -f1)
        if ! [ -z $currentlyCheckedOutFile ]
        then
            echo "CMS.sh: You have a checked-out file in $currentlyOpenedRepoName: $currentlyCheckedOutFile"
            # Resource used to help with copying an array: https://stackoverflow.com/questions/19417015/how-to-copy-an-array-in-bash/34733375
            currentOptions=("${optionsWhenRepoIsOpenAndAFileCheckedOut[@]}")
        else
            echo -e "CMS.sh: You have no currently checked-out file"
            currentOptions=("${optionsWhenRepoIsOpenAndNoCheckedOutFile[@]}")
        fi
    else
        echo -e "${BLUE}$0${NC}: There is no repository that is currently opened."
        currentOptions=("${optionsWhenRepoIsNotOpen[@]}")
    fi
}

checkCurrentStateAndSetMenuOptions
isQuitSelected=0
# display the user menu inside a while loop so the options can be dynamically changed to only display relevant ones
while [ $isQuitSelected -eq 0 ]
do
    echo
    echo "Your current options:"

    select menuOption in "${currentOptions[@]}"; do

        echo
        case $menuOption in 
        "Create a repository")
            ./createrepo.sh
        ;;
        "Open a repository")
            ./openrepo.sh
        ;;
        "List existing repositories")
            ./list-repos.sh
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
        "List files in current repo")
            ./listrepocontents.sh $currentlyOpenedRepoPath
        ;;
        "Password protect repo from deletion")
            ./passwordprotectrepo.sh $currentlyOpenedRepoPath
        ;;
        "Show help")
            ./help.sh
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

        checkCurrentStateAndSetMenuOptions
        break
    done
done