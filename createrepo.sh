# get variables for text colours
env | grep -q RED
env | grep -q CYAN
env | grep -q BLUE
env | grep -q NC

# create file with index of all created repositories
touch repository-index.txt

read -p "Type in the path of your repository:" repositoryPath
read -p "Type in a name for your repository:" repositoryName

# input validation
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

# create folder to store the initial state of the repository
# openSSL documentation was used in the following line
initialCommitFolder="$(date '+%Y-%m-%d-%H-%M')_$(openssl rand -hex 3)"
mkdir ${repositoryPath}/.vc/${initialCommitFolder}

# resource used to check if directory is empty: https://www.codexpedia.com/shell/check-if-a-directory-is-empty-or-not-in-shell-script/ - 25.10.2021
if [ "$(ls $repositoryPath)" ]; then 
     mv ${repositoryPath}/* ${repositoryPath}/.vc/${initialCommitFolder}
fi

# log the repo creation into the changes log
touch ${repositoryPath}/.vc/.changes-log.txt
echo "${initialCommitFolder};Initial-commit;${UID}" >> ${repositoryPath}/.vc/.changes-log.txt

# add the repository to the index of repositories
echo "${repositoryName};${repositoryPath};$UID;$UID;" >> repository-index.txt

echo "Repository created. Use the open repository option to open it."