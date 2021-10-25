env | grep -q RED
env | grep -q CYAN
env | grep -q BLUE
env | grep -q NC

repositoryPath=$1
repositoryName=$2

touch repository-index.txt



if [ -z "$repositoryName" ]
then
    echo -e "\n\t${RED}- Invalid repository name provided${NC}\n"
    exit 1
elif grep -q $repositoryName repository-index.txt
then
    echo -e "\n\t${RED}- Repo with same name already exists.\n\t- Please enter a unique name for your repository.${NC}\n"
    exit 1
elif grep -q $repositoryPath repository-index.txt
then
    echo -e "\n\t${RED}- Existing repository found in specified path${NC}\n"
    exit 1
fi

if ! [ -d "$repositoryPath" ]
then
    mkdir ${repositoryPath}
    mkdir ${repositoryPath}/.vc
else
    mkdir ${repositoryPath}/.vc
fi

# openSSL documentation was used in the following line
initialCommitFolder="$(date '+%Y-%m-%d-%H-%M')_$(openssl rand -hex 3)"
mkdir ${repositoryPath}/.vc/${initialCommitFolder}

if ! [ "$(ls -A $repositoryPath)" ]; then #Check if directory path is empty - https://www.codexpedia.com/shell/check-if-a-directory-is-empty-or-not-in-shell-script/ - 25.10.2021
    mv ${repositoryPath}/* ${repositoryPath}/.vc/${initialCommitFolder}
fi

touch ${repositoryPath}/.vc/.changes-log.txt
echo "${initialCommitFolder};${BLUE}Initial-commit${NC}" >> ${repositoryPath}/.vc/.changes-log.txt

echo "${repositoryName};${repositoryPath}" >> repository-index.txt