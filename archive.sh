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
	zip "$1.zip" ${@:1}
}

archiveType=$1

repositoryPath=$(grep -w $2 repository-index.txt | cut -d ';' -f2)
fileList=($(find $repositoryPath -type f \( ! -wholename $repositoryPath/.vc \) ))

archiveName=${@:3}

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

