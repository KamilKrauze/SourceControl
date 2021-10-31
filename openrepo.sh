repositoryName=$1

if [ -s currently-open-repo.txt ]
then
    echo "There is already an opened repository. Close it before opening another one."
    exit 1
fi

if [ -z "$repositoryName" ]
then
    echo "Invalid repository name provided"
    exit 1
fi

# TODO grep search only repository names, not whole line (which includes path)
repositoryPath=$(grep -w $repositoryName repository-index.txt | cut -d ';' -f2)
if ! [ -d "$repositoryPath" ]
then
    echo "The repository does not exist or have a valid path associated with it"
    exit 1
fi

# check user permissions
repoDetails=$(grep -w $repositoryPath repository-index.txt)
usersWithReadAccess=$(echo $repoDetails | cut -d ';' -f3)
if ! echo $usersWithReadAccess | grep -q $UID
then
    echo "You don't have the permission to open this repository (no READ access)"
    exit 1
fi

# todo currently open repo should be linked to UID! so two users can have repo open at the same time
touch currently-open-repo.txt
echo "$repositoryPath;$repositoryName" >> currently-open-repo.txt

# get the repository path by command substitution in the main bash script
echo $repositoryPath