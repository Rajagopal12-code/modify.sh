#!/bin/sh
# author: Rajagopal Thirugnanasambandam
#
# EOPSY_lab_task 1:
# Write a second script, named
# modify_examples, which will lead the tester of the modify
# script through the typical, uncommon and even incorrect
# scenarios of usage of the modify script.
createExample(){
	if [ -e "EXAMPLE" ]; then
		rm -r EXAMPLE
	fi
	if [ -e "another\ example" ]; then
		rm -r example another\ example
	fi
	mkdir example  #making directory
	cd example    #change directory
	touch raja.txt saeiaNTby!.cvd      #create file
	mkdir folder1 folder2 folder3\ folder4 folder5
	cd folder1
	touch file file2 file3 file4 file6 file7
	cd ../..
	mkdir another\ example
	cd another\ example
	touch green blue red.!!blue.o OP\ yellow\ black.sa
	cd ..
}
clear
createExample
echo "\n\nOrginal structure of directories:"
find example
echo "\nUpperising option:"
sh modify.sh -u example
echo "\n\nChanged structure of directories:"
find example
echo "\nLowerising option:"
sh modify.sh -l example
echo "\n\nChanged structure of directories:"
find example
echo "\nUpperising option with recursion:"
sh modify.sh -u -r example
echo "\n\nChanged structure of directories:"
find example
echo "\nWith an exemplary SED pattern:"
sh modify.sh y/qwe3/QWEE/ EXAMPLE another\ example
echo "\n\nChanged structure of directories:"
find example another\ example
