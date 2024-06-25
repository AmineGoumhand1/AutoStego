#!/bin/bash

if [ $# -lt 2 ]; then
   echo "Usage: autostegano <image_file> <patternToLookFor> <steghidePassword>"
   exit 1
fi
highlight() {
    while IFS= read -r line; do
        echo -e "\033[1;34m${line}\033[0m"  # Change the color code as needed
    done
}
for image in "$1" ; do
    echo "
    Checking File Extension  #######################################################################################################################
    "
    file "$image" | highlight
    echo "
    Strings ( long significant strings )  ##########################################################################################################
    "
    strings "$image" | awk -v pattern="$2" 'length($0) > 10 {gsub(pattern, "\033[1;31m&\033[0m"); print}' | highlight
   

    echo "
    Exiftool #######################################################################################################################################
    "
    exiftool "$image"  | awk -v pattern="$2" '{gsub("Comment", "\033[1;31m&\033[0m"); print}' | highlight
    echo "
    Zsteg  #########################################################################################################################################
    "
    zsteg "$image"| awk -v pattern="$2" '{gsub("pattern", "\033[1;31m&\033[0m"); print}' | highlight
    echo "
    Outguess  ######################################################################################################################################
    "
    outguess_output=$(outguess -r "$image" info.txt 2>&1)
    seed=$(echo "$outguess_output" | grep -oP 'seed: \K\d+')
    length=$(echo "$outguess_output" | grep -oP 'len: \K\d+')
    echo "$outguess_output" | grep -v "Reading" | grep -v "Extracting usable bits" | grep -v "Steg retrieve" | awk -v pattern="$2" '{gsub(pattern, "\033[1;31m&\033[0m"); print}' | highlight

    if [ -s info.txt ]; then
   
        cat info.txt | awk -v pattern="$2" '{gsub(pattern, "\033[1;31m&\033[0m"); print}' | highlight
    else
        echo "No data found in info.txt" | highlight
    fi
    echo "
    Binwalk Extracting  ######################################################################################################################################
    "
    echo "    Go see the extracted things
    "
    binwalk -e "$image" | highlight
    echo "
    Steghide  ######################################################################################################################################
    "
    echo "    NOTE : You should specify a passphrase at the 3rd parameter
    "
    steghide --extract -sf "$image" -p "$3" | highlight
    
    echo "
    Stegsolve  ######################################################################################################################################
    "
    echo "NOTE1 : If you want to proceed with stegsolve , you need to install java"
        echo "NOTE2 : You will see a popup , export the image to it and start the analysis"
        read -p "Run stegsolve.jar? (Y/N): " a

# Check user input
if [ "$a" == "Y" ]; then
    /home/kali/bin/stegsolve.jar
    echo "END of analysis"
elif [ "$a" == "N" ]; then
    echo "END of analysis"
else
    echo "Invalid input. END of analysis"
fi


done

