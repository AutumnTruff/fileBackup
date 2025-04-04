#!/bin/bash
# Creating a log file if it dosent exsist 
if [ ! -f "logFile.txt" ]; then
    touch "logFile.txt"
fi  

# Checking arguments 
FileCheck() {
    fileName="$1"
    
    if [ ! -f "$fileName" ]; then
        echo "File doesn't exist, creating file"
        touch "$fileName"
        #opening the file
        nano "$fileName"
        exit
    elif [ -f "logFile.txt" ]; then
        lineCount=$(wc -l < logFile.txt)
        if [ "$lineCount" -eq 5 ]; then
            # removing the oldest entry
            tail -n +2 logFile.txt > tempLog.txt
            mv tempLog.txt "logFile.txt"
            echo "log file full, removing oldest entry"
        fi
        # creating  backup
        echo "File exists, backing up file"
        cp "$fileName" "${fileName%.*}BackUp.txt"

        # adding log entry
        timeStamp=$(date +"%d-%m-%Y %H:%M")
        echo "$timeStamp $fileName == ${fileName%.*}BackUp.txt" >> "logFile.txt"

        # Opening original file 
        nano "$fileName"
    fi
}

if [ $# -lt 1 ]; then
    read -r -p  "Enter the name of the file you wish to open:" fileName
    FileCheck "$fileName"
elif [ $# -eq 1 ]; then
    fileName=$1
    FileCheck "$fileName"
else
    echo "Error: Too many arguments"
    exit
fi