read -p "Type in the name of the repository you want to open: " repositoryName

# input validation
repoThatCurrentUserHasOpen=$(grep $UID currently-open-repo.txt)
if ! [ -z $repoThatCurrentUserHasOpen ]
then
    echo "There is already an opened repository. Close it before opening another one."
    exit 1
fi
if [ -z "$repositoryName" ]
then
    echo "Invalid repository name provided"
    exit 1
fi

repositoryPath=$(grep -w $repositoryName repository-index.txt | cut -d ';' -f2)
if ! [ -d "$repositoryPath" ]
then
    echo "The repository does not exist or have a valid path associated with it"
    exit 1
fi

# check user permissions (READ access to repository)
repoDetails=$(grep -w $repositoryPath repository-index.txt)
usersWithReadAccess=$(echo $repoDetails | cut -d ';' -f3)
if ! echo $usersWithReadAccess | grep -q $UID
then
    echo "You don't have the permission to open this repository (no READ access)"
    exit 1
fi

# make note that the repository is currently open
touch currently-open-repo.txt
echo "$repositoryPath;$repositoryName;$UID" >> currently-open-repo.txt

echo "Repository opened."
# list contents of current repository automatically
./listrepocontents.sh $repositoryPath