#!/bin/bash
apacheUser="apache"
apacheGroup="apache"
directory="."

##### Set defaults #####
if [[ $# -gt 0 ]]; then
	# Directory
	if [[ ! -z "$1" ]]; then
		directory="$1"
	fi

	# Apache User
	if [[ ! -z "$2" ]]; then
		apacheUser="$2"
	fi

	# Apache Group
	if [[ ! -z "$3" ]]; then
		apacheGroup="$3"
	fi
fi

echo "============================"
echo "|  Suspicious File Finder  |"
echo "|              by Dustin   |"
echo "============================"
echo
echo "Using the following variables:"
echo "Directory: $directory"
echo "Apache User: $apacheUser"
echo "Apache Group: $apacheGroup"
echo
echo


echo "Recently edited files"
echo "---------------------"
find "$directory" -type f -iname '*.php*' -user $apacheUser -mtime -7
echo
echo

echo "Apache files with eval()"
echo "------------------------"
find "$directory" -type f -iname '*.php*' -user $apacheUser -print0 | xargs -0 grep -l "eval *(" --color
echo
echo

echo "Apache files with base64_decode()"
echo "------------------------"
find "$directory" -type f -iname '*.php*' -user $apacheUser -print0 | xargs -0 grep -l "base64_decode *(" --color
echo
echo

echo "Apache files with eval(base64_decode())"
echo "------------------------"
find "$directory" -type f -iname '*.php*' -user $apacheUser -print0 | xargs -0 grep -l "eval *( *base64_decode *(" --color
echo
echo

echo "Apache files with gzinflate()"
echo "------------------------"
find "$directory" -type f -iname '*.php*' -user $apacheUser -print0 | xargs -0 grep -l "gzinflate *(" --color
echo
echo

echo "Apache files with the phrase: hacked by"
echo "------------------------"
find "$directory" -type f -iname '*.php*' -user $apacheUser -print0 | xargs -0 grep -l "hacked by" --color
echo
echo



echo "All PHP files in a writable directory"
echo "------------------------"
writable_dirs=$(find $directory -type d \( -perm -o+w -or \( -perm -g+w -group $apacheGroup \) -or \( -perm -g+w -group $apacheGroup \) -or -user $apacheUser \))
 
for dir in $writable_dirs
do
	# echo "Checking directory: $dir"
	find "$dir" -maxdepth 1 -type f -iname '*.php*'
done
echo
echo


echo "Done checking all files! Review the list as there are likely many false positives."
echo