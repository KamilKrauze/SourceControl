repositoryPath=$1
repositoryName=$2

touch repository-index.txt

if ! [ -d "$repositoryPath" ]
then
    echo "Invalid directory path provided"
    exit 1
elif [ -z "$repositoryName" ]
then
    echo "Invalid repository name provided"
    exit 1
elif grep -q $repositoryName repository-index.txt
then
    echo "Repo with same name already exists"
    exit 1
elif grep -q $repositoryPath repository-index.txt
then
    echo "Existing repository found in specified path"
    exit 1
fi

mkdir ${repositoryPath}/.vc

# openSSL documentation was used in the following line
initialCommitFolder="$(date '+%Y-%m-%d-%H-%M')_$(openssl rand -hex 3)"
mkdir ${repositoryPath}/.vc/${initialCommitFolder}
mv ${repositoryPath}/* ${repositoryPath}/.vc/${initialCommitFolder}

touch ${repositoryPath}/.vc/.changes-log.txt
echo "${initialCommitFolder};Initial-commit" >> ${repositoryPath}/.vc/.changes-log.txt

echo "${repositoryName};${repositoryPath}" >> repository-index.txt