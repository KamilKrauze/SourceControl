#!/bin/bash

repositoryPath=$1

read -p "Type in gcc or javac to launch compiling process: " userInput

case $userInput in
"gcc")
	echo -e "Running gcc compiler"
	bash compile-gcc.sh $repositoryPath
	;;

"javac")
	echo -e "Running java compiler"
	bash compile-javac.sh $repositoryPath
	;;
*)
	echo -e "Sorry, compiler either does not exist, or is not supported in the current version of CMS"
	exit 1
	;;
esac