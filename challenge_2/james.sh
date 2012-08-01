#!/bin/bash

# reverse.sh
# Description: Reverse all words and lines in a file.
# author: jamesp@teamddm.com
# date: 2012-07-31

FILE=$1

if [ ! -f $FILE ]; then
    echo 'ERROR: File does not exist.'
    exit;
fi

START=$(date +%s);

extime () { END=$(date +%s); echo "Time: $(( $END - $START )) seconds "; }
on_sig () { mv .${FILE}.orig $FILE; rm -rf .${FILE}.swp; exit; }
on_exit () { mv .${FILE}.swp $FILE >/dev/null 2>&1; rm -rf .${FILE}.orig; extime; exit; }

# Trap any signals to kill or terminate the script
trap "on_sig" SIGINT SIGTERM SIGTSTP 
# Trap and perform final action on file on exit
trap "on_exit" EXIT

# Copy original to swap file for temp storage.
cp $FILE ".${FILE}.orig"

# Cat the file into sed to reverse lines, run `rev` to reverse chars, then send output to file
cat $FILE | rev | perl -e 'print reverse <>' | sed -e 's///g' > ".${FILE}.swp"

