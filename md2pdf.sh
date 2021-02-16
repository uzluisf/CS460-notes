#!/bin/bash

if [ $# == 0 ]; then
    # Take all the Markdown files under ./notes, combine them,
    # add some Pandoc's YAML metadata, and convert the final Markdown
    # file to a PDF in the current directory.

    FILES="$(pwd)/notes/*.md"
    TEMP="/tmp/lecture-notes.md"
    OUTPUT="lecture-notes.pdf"
    TEMPLATE="$(pwd)/templates/lecture.tex"

    truncate -s 0 "$TEMP"

    for f in $FILES
    do
        cat $f >> $TEMP
    done
    
    pandoc "$TEMP" \
    --pdf-engine=pdflatex \
    --resource-path="$(pwd)/notes" \
    --template="$TEMPLATE" \
    --metadata title="Advanced Programming Languages (CSci 460)" \
    --metadata subtitle="Lecture Notes" \
    --metadata documentclass="article" \
    --metadata geometry="left=3cm,right=3cm,top=3cm,bottom=3cm" \
    --metadata papersize="a4" \
    --metadata toc="true" \
    --metadata toc-depth="3" \
    --metadata numbersections="true" \
    -o "$(pwd)/$OUTPUT"

    if [ -f "$(pwd)/$OUTPUT" ]; then
        echo "$OUTPUT created successfully."
    fi
else
    # Convert a single MD file ($1) to PDF using template ($2).

    MDFILE=$1
    FILEPATH=${MDFILE%.*}
    TEMPLATE=$2
    OUTPUT="$FILEPATH.pdf"
    
    if [$TEMPLATE == '']; then
        TEMPLATE="$(pwd)/templates/homework.tex"
    fi

    pandoc $FILEPATH.md       \
    --pdf-engine=xelatex      \
    --template="$TEMPLATE"    \
    --resource-path="$(pwd)"  \
    -o "$OUTPUT"

    if [ -f "$OUTPUT" ]; then
        echo "$OUTPUT created successfully."
    fi
fi
