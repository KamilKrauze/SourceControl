repositoryPath=$1

repoDetails=$(grep -w $repositoryPath repository-index.txt)
repoNameAndPath=$(echo $repoDetails | cut -d ';' -f 1-2)
usersWithReadAccess=$(echo $repoDetails | cut -d ';' -f3)
usersWithWriteAccess=$(echo $repoDetails | cut -d ';' -f4)
existingPasswordHash=$(echo $repoDetails | cut -d ';' -f5)

if ! [ -z "$existingPasswordHash" ]
then
    echo "That repository already has a password"
    exit 1
fi

read -p "Type in the password: " password
read -p "Repeat the password: " passwordRepeated

if ! [ "$password" = "$passwordRepeated" ]
then
    echo "Passwords are not the same"
    exit 1
fi

# using sha1sum was helped by resource: https://stackoverflow.com/questions/15626073/sha1-password-hash-linux
hashedPassword=$(echo -n $password | sha1sum | cut -d ' ' -f1)

newRepoDetails="$repoNameAndPath;$usersWithReadAccess;$usersWithWriteAccess;$hashedPassword"

# update repository-index.txt with new permissions
# https://linuxhint.com/replace_string_in_file_bash/
sed -i "s/$repoDetails/$newRepoDetails/" repository-index.txt
echo "Repository is now password-protected from deletion"