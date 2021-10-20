repositoryName=$1

if [ -z "$repositoryName" ]
then
    echo "Invalid repository name provided"
    exit 1
fi

# TODO grep search only repository names, not whole line (which includes path)
repositoryPath=$(grep $repositoryName repository-index.txt | cut -d ';' -f2)
if ! [ -d "$repositoryPath" ]
then
    echo "The repository does not have a valid path associated with it"
    exit 1
fi

# get the repository path by command substitution in the main bash script
echo $repositoryPath