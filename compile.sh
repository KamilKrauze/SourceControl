#!/bin/bash

repositoryPath=$1

read -p "Type in gcc or javac to launch compiling process: " userInput

# If a condition is met from the following options, GCC or JAVAC then it run the compiler script for that repository.
# If input is false then no compiler script is ran

case $userInput in
"gcc")
	echo -e "Running gcc compiler"
	bash compile-gcc.sh $repositoryPath
	exit 0
	;;

"javac")
	echo -e "Running java compiler"
	bash compile-javac.sh $repositoryPath
	exit 0
	;;
*)
	echo -e "Sorry, compiler either does not exist, or is not supported in the current version of CMS"
	exit 1
	;;
esac