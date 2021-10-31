repositoryPath=$1
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)

filesInWorkingDirectory=$(ls ${repositoryPath}/ | tr "\n" " ")
filesInLatestCommitFolder=$(ls ${repositoryPath}/.vc/${lastCommitFolder}/ | tr "\n" " ")

if [ -z "$filesInWorkingDirectory" ]
then    
    filesInWorkingDirectory="[none]"
fi
if [ -z "$filesInLatestCommitFolder" ]
then    
    filesInLatestCommitFolder="[none]"
fi

echo "Files present in the working directory (checked-out files): $filesInWorkingDirectory"
echo "Files present in the latest commit: $filesInLatestCommitFolder"