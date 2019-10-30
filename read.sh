#!/bin/bash
if [ -z "$1" ]
then
    echo "Please provide input file"
else
    if [ -f "$1" ]
    then
        input=$1
        while IFS= read -r line
        do
            declare -a linedata=( $( echo $line | cut -d' ' -f1- ) )
            echo "line - $line"
            echo "linedata - $linedata"
            echo "Arg0 - ${linedata[0]}"
            echo "Arg1 - ${linedata[1]}"
            # Note: First argument can be accessable by ${linedata[0]}
            # Note: Second argument can be accessable by ${linedata[1]}
            # Example:
            #
            # name=${linedata[0]}
            # value=${linedata[1]}
            #
        done < "$input"
    else
        echo "$1 not found. Please provide file location"
    fi
fi
