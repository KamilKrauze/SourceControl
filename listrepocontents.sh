repositoryPath=$1
# get folder with latest checked-in changes
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

# get list of tiles as a single line
filesInWorkingDirectory=$(ls ${repositoryPath}/ | tr "\n" " ")
filesInLatestCommitFolder=$(ls ${repositoryPath}/.vc/${lastCommitFolder}/ | tr "\n" " ")

# replace empty strings with "[none]"
if [ -z "$filesInWorkingDirectory" ]
then    
    filesInWorkingDirectory="[none]"
fi
if [ -z "$filesInLatestCommitFolder" ]
then    
    filesInLatestCommitFolder="[none]"
fi

# print out lists of files
echo "Files present in the working directory (checked-out files): $filesInWorkingDirectory"
echo "Files present in the latest commit: $filesInLatestCommitFolder"