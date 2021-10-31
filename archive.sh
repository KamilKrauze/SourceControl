#!/bin/bash

env | grep -q BLUE
env | grep -q RED
env | grep -q NC

function tarGZCompression()
{
	tar --create --file="$1.tar" ${@:1}
}

function tarBZ2Compression()
{
	tar -cjf "$1.tar.bz2" ${@:1}
}

function zipCompression()
{
	zip -q "$1.zip" ${@:1}
}

read -p "Type in the archive type (tar-gz, tar-bz2, zip): " archiveType
read -p "Type in the archive name: " archiveName

repositoryPath=$1
lastCommitFolder=$(ls ${repositoryPath}/.vc | sort -r | head -n 1)
fileList=($(find $repositoryPath/.vc/$lastCommitFolder -type f ))

case $archiveType in
	"tar-gz")
		tarGZCompression $archiveName $fileList
	;;
	"tar-bz2")
		tarBZ2Compression $archiveName $fileList
	;;
	"zip")
		zipCompression $archiveName $fileList
	;;
	*)
		echo -e "${RED}ERROR${NC}: Invalid archive type. Please enter a valid archive type from the list below:"
		echo -e "${BLUE}- tar-gz${NC}"
		echo -e "${BLUE}- tar-bz2${NC}"
		echo -e "${BLUE}- zip${NC}"
		exit 0
	;;
esac

