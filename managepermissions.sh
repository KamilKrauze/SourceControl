#!/bin/bash

repositoryPath=$1

repoDetails=$(grep -w $repositoryPath repository-index.txt)
repoNameAndPath=$(echo $repoDetails | cut -d ';' -f 1-2)
usersWithReadAccess=$(echo $repoDetails repository-index.txt | cut -d ';' -f3)
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

# add permissions
read -p "Type in the username of the user who you want to grant read access to:" usernameToAdd
userIdToAdd=$(id -u $usernameToAdd 2> /dev/null)

if [ -z $userIdToAdd ]
then
    echo "There is no existing user with that username"
    exit 1
fi

usersWithReadAccess="$usersWithReadAccess-$userIdToAdd"

# repoName;testRepo;1000;1000
newRepoDetails="$repoNameAndPath;$usersWithReadAccess;$usersWithWriteAccess"

# update repository-index.txt with new permissions
# https://linuxhint.com/replace_string_in_file_bash/
sed -i "s/$repoDetails/$newRepoDetails/" repository-index.txt