#!/bin/sh
# author: Rajagopal Thirugnanasambandam
#
# EOPSY_lab_task 1:
# Write a script modify with the following syntax:
#
#   modify [-r] [-l|-u] <dir/file names...>
#   modify [-r] <sed pattern> <dir/file names...>
#   modify [-h]
#
#   modify_examples
#
# which will modify directory and file names. The script is
# dedicated to lowerizing (-l) directory and file names,
# uppercasing (-u) directory and file names or internally calling
# sed command with the given sed pattern which will operate on
#` directory or file names. Changes may be done either with
# recursion (-r) or without it.

#### Default values of variables ####
OPTION=""		# Option: l(lowerizing),  u(uppercasing), h(help)
RECURSIVE_MODE=0					# Recursive mode: RECURSIVE_MODE=0(off), RECURSIVE_MODE=1(on)
SED_PAT=""				#SED_PATTERNS
SEARCH="-maxdepth${IFS#??}0"	# Options for search command with no reccursion
SAVE_IFS=$IFS				# To save system value 
COUNT=0				

#### Help message Function ####
showHelp()
{
	echo "Options:\n\t-l,\tlowerizing directory and file names\n\t-u,\tuppercasing directory and file names\n\t-r,\trecursive mode\n\t-h\tthis help message."
	echo "Usage:\n\t$0 [-r] [-l|-u] <dir/file names...>\n\t$0 [-r] <sed pattern> <dir/file names...>\n\t$0 [-h]\n"
}

#### Info about options conflict ####
showConflict(){
	echo "\nERROR: lowerizing [-l] and uppercasing [-u] options cannot be shows at the same time!\n" 1>&2
}

#### Determine the selected options ####
if [ $# -lt 1 ]; then
	echo "\nERROR: No options selected!\n" 1>&2
	showHelp
	exit 1
fi
while [ "$1" != "" ]; do
		case "x$1" in			# 'x' -scan directories names are same as arguments name 
			"x-r") RECURSIVE_MODE=1;;
			"x-l")
				if [ -z "$OPTION" ]; then
					OPTION="l"
				else
					showConflict
					exit 1;
				fi;;
			"x-u")
				if [ -z "$OPTION" ]; then
					OPTION="u"
				else
					showConflict
					exit 1;
				fi;;
			"x-h") showHelp;exit 0;;
			* )break;;
		esac
		shift
done
if [ -n "$1" -a -z "$OPTION" ];  then
	SED_PAT=$1
	OPTION="r"
	shift
elif [ -z "$OPTION" ]; then
	echo "\nERROR: Option -l or -u or the sed pattern must be specified!\n" 1>&2
	showHelp
	exit 1;
fi
if [ $RECURSIVE_MODE != 0 ]; then
	echo "Changes applied in recursive mode."
	SEARCH=""
fi
case $OPTION in
	"l") echo "lowerizing option selected.\n";;
	"u") echo "Uppercasing option selected.\n";;
	* )
		if [ -n $SED_PAT ]; then
			echo "Operating the sed pattern: $SED_PAT\n"
		fi;;
esac

#### Operation files ####
while [ -e "$1" ] ; do
	IFS=${IFS#??} #  separator
	for F in `find $1 -depth $SEARCH`; do	# - depth - CWD's name is changed as the last one.
		Default_NAME=`basename "$F"`
		FILE_PATH=`dirname "$F"`
		if [ $OPTION = "l" ]; then
			NEW_NAME=`echo "${Default_NAME}" | tr "A-Z" "a-z"`
		elif [ $OPTION = "u" ]; then
			NEW_NAME=`echo "${Default_NAME}" | tr "a-z" "A-Z"`
		else
			NEW_NAME=`echo "${Default_NAME}" | sed -s "$SED_PAT"`
		fi
		if [ "${Default_NAME}" != "${NEW_NAME}" ] ; then	#  variable name is clearly delimited.
			if [ -e "$FILE_PATH/${NEW_NAME}" ]; then
				echo "WARNING: File '$FILE_PATH/$Default_NAME' not changed to '$NEW_NAME' to protect from override!"
			else
				mv "$F" "${FILE_PATH}/${NEW_NAME}"
				COUNT=$((COUNT+1))
			fi

	IFS=$SAVE_IFS
	if [ $# -gt 1 ]; then
		shift
	else
		if [ $COUNT -gt 0 ]; then
			echo "\n$COUNT files changed successfully."
		else
			echo "\nNo files are changed."
		fi
		exit 0
	fi
fi
echo "ERROR: Input file or directory '$1' doesnt exist!\n" 1>&2
exit 1
done
done
