#!/bin/bash

userIn=($@)

case ${userIn[0]} in
"gcc")
	echo -e "Running gcc compiler" #run the equivalent of "make" script
	bash compile-gcc.sh ${userIn[@]:1}
	;;

"javac")
	echo -e "Running java compiler" # run the equivalent of "make script"
	;;
*)
	echo -e "Sorry, compiler either does not exist, or is not supported in the current version of CMS"
	exit 1
	;;
esac