#!/bin/bash

repositoryPath=$1

repoDetails=$(grep -w $repositoryPath repository-index.txt)
repoNameAndPath=$(echo $repoDetails | cut -d ';' -f 1-2)
usersWithReadAccess=$(echo $repoDetails | cut -d ';' -f3)
usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)

# https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
arrayOfUsersWithReadAccess=(${usersWithReadAccess//-/ })
arrayOfUsersWithWriteAccess=(${usersWithWriteAccess//-/ })

# todo can this be a function? due to repetition
usernamesWithReadAccess=""
for userId in "${arrayOfUsersWithReadAccess[@]}"
do
    # https://unix.stackexchange.com/questions/36580/how-can-i-look-up-a-username-by-id-in-linux
    username=$(getent passwd $userId | cut -d: -f1)
    usernamesWithReadAccess="$usernamesWithReadAccess $username"
done
usernamesWithWriteAccess=""
for userId in "${arrayOfUsersWithWriteAccess[@]}"
do
    # https://unix.stackexchange.com/questions/36580/how-can-i-look-up-a-username-by-id-in-linux
    username=$(getent passwd $userId | cut -d: -f1)
    usernamesWithWriteAccess="$usernamesWithWriteAccess $username"
done

# todo add readfile option so read permission makes some sense

echo "These users have READ access to the repository:$usernamesWithReadAccess"
echo "These users have WRITE access to the repository:$usernamesWithWriteAccess"

function readAndCheckUsername {
    read -p "Type in the username of the user: " usernameToModify 
    userIdToModify=$(id -u $usernameToModify 2> /dev/null) 

    if [ -z $userIdToModify ]
    then
        echo "There is no existing user with that username"
        exit 1
    elif [ "$userIdToModify" = "$UID" ]
    then
        echo "You cannot modify your own permissions"
        exit 1
    fi
}

function addReadPermissions {
    
    # function stores user id into userIdToModify
    readAndCheckUsername
    
    # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
    if [[ " ${arrayOfUsersWithReadAccess[*]} " =~ " ${userIdToModify} " ]]; then
        echo "That user already has read access"
        return 1
    fi

    usersWithReadAccess="$usersWithReadAccess-$userIdToModify"
    newRepoDetails="$repoNameAndPath;$usersWithReadAccess;$usersWithWriteAccess"

    # update repository-index.txt with new permissions
    # https://linuxhint.com/replace_string_in_file_bash/
    sed -i "s/$repoDetails/$newRepoDetails/" repository-index.txt
    echo "User $usernameToModify has been given READ access to the repository"
}

function addWriteAndReadPermission {
    
    # function stores user id into userIdToModify
    readAndCheckUsername

    # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
    if [[ " ${arrayOfUsersWithWriteAccess[*]} " =~ " ${userIdToModify} " ]]; then
        echo "That user already has write access"
        return 1
    fi

    # if user doesn't already have read permission, add it
    # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
    if [[ ! " ${arrayOfUsersWithReadAccess[*]} " =~ " ${userIdToModify} " ]]; then
        usersWithReadAccess="$usersWithReadAccess-$userIdToModify"
    fi

    usersWithWriteAccess="$usersWithWriteAccess-$userIdToModify"
    newRepoDetails="$repoNameAndPath;$usersWithReadAccess;$usersWithWriteAccess"
    
    # update repository-index.txt with new permissions
    # https://linuxhint.com/replace_string_in_file_bash/
    sed -i "s/$repoDetails/$newRepoDetails/" repository-index.txt
    echo "User $usernameToModify has been given READ & WRITE access to the repository"
} 

function removeWritePermission {
    # function stores user id into userIdToModify, username into usernameToModify
    readAndCheckUsername

    # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
    if [[ ! " ${arrayOfUsersWithWriteAccess[*]} " =~ " ${userIdToModify} " ]]; then
        echo "That user does not has write access"
    return 1
    fi

    # replace their user id with an empty string
    # two cases are needed here to make sure the delimiter (-) is removed too
    userIdToRemoveWithDelimiter="-$userIdToModify"
    usersWithWriteAccess=$(echo "${usersWithWriteAccess/${userIdToRemoveWithDelimiter}/""}")
    userIdToRemoveWithDelimiter="$userIdToModify-"
    usersWithWriteAccess=$(echo "${usersWithWriteAccess/${userIdToRemoveWithDelimiter}/""}")
    
    newRepoDetails="$repoNameAndPath;$usersWithReadAccess;$usersWithWriteAccess"

    # update repository-index.txt with new permissions
    # https://linuxhint.com/replace_string_in_file_bash/
    sed -i "s/$repoDetails/$newRepoDetails/" repository-index.txt
    echo "User $usernameToModify now only has READ access to the repository"
}

function removeWriteAndReadPermission {
    # function stores user id into userIdToModify, username into usernameToModify
    readAndCheckUsername

    # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
    if [[ ! " ${arrayOfUsersWithReadAccess[*]} " =~ " ${userIdToModify} " ]]; then
        echo "That user does not have read access"
    return 1
    fi

    # if user has write permission, remove it first
    # todo code duplication
    # https://stackoverflow.com/questions/3685970/check-if-a-bash-array-contains-a-value
    if [[ " ${arrayOfUsersWithWriteAccess[*]} " =~ " ${userIdToModify} " ]]; then
        # replace their user id with an empty string
        # two cases are needed here to make sure the delimiter (-) is removed too
        userIdToRemoveWithDelimiter="-$userIdToModify"
        usersWithWriteAccess=$(echo "${usersWithWriteAccess/${userIdToRemoveWithDelimiter}/""}")
        userIdToRemoveWithDelimiter="$userIdToModify-"
        usersWithWriteAccess=$(echo "${usersWithWriteAccess/${userIdToRemoveWithDelimiter}/""}")
    fi

    # replace their user id with an empty string
    # two cases are needed here to make sure the delimiter (-) is removed too
    userIdToRemoveWithDelimiter="-$userIdToModify"
    usersWithReadAccess=$(echo "${usersWithReadAccess/${userIdToRemoveWithDelimiter}/""}")
    userIdToRemoveWithDelimiter="$userIdToModify-"
    usersWithReadAccess=$(echo "${usersWithReadAccess/${userIdToRemoveWithDelimiter}/""}")
    
    echo $usersWithReadAccess
    newRepoDetails="$repoNameAndPath;$usersWithReadAccess;$usersWithWriteAccess"

    # update repository-index.txt with new permissions
    # https://linuxhint.com/replace_string_in_file_bash/
    sed -i "s/$repoDetails/$newRepoDetails/" repository-index.txt
    echo "User $usernameToModify now has no READ or WRITE access to the repository"
}

echo "Do you want to ADD or REMOVE permissions?"
select option in "Add read permissions" "Add write permission (adds read permission automatically)" "Remove write permission" "Remove read permission (removes write permission automatically)" 
do
    case $option in 
    "Add read permissions")
        addReadPermissions
        break
    ;;
    "Add write permission (adds read permission automatically)")
        addWriteAndReadPermission
        break
    ;;
    "Remove write permission")
        removeWritePermission
        break
    ;;
    "Remove read permission (removes write permission automatically)")
        removeWriteAndReadPermission
        break
    ;;
    esac
done