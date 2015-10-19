#!/bin/bash
apacheUser="dnewbold"
apacheGroup="wheel"
directory="."

echo "============================"
echo "|  Suspicious File Finder  |"
echo "|              by Dustin   |"
echo "============================"
echo
echo


echo "Recently edited files"
echo "---------------------"
find $directory -type f -iname '*.php*' -user $apacheUser -mtime -7
echo
echo

echo "Apache files with eval()"
echo "------------------------"
find $directory -type f -iname '*.php*' -user $apacheUser | xargs grep -l "eval *(" --color
echo
echo

echo "Apache files with base64_decode"
echo "------------------------"
find $directory -type f -iname '*.php*' -user $apacheUser | xargs grep -l "base64_decode *(" --color
echo
echo

echo "Apache files with gzinflate()"
echo "------------------------"
find $directory -type f -iname '*.php*' -user $apacheUser | xargs grep -l "gzinflate *(" --color
echo
echo


echo "All PHP files in a writable directory"
echo "------------------------"
writable_dirs=$(find . -type d \( -perm -o+w -or \( -perm -g+w -group $apacheGroup \) -or \( -perm -g+w -group $apacheGroup \) -or -user $apacheUser \))
 
for dir in $writable_dirs
do
    #echo $dir
    find $dir -type f -name '*.php'
done