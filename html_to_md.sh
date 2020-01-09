#!/bin/bash

# This script convert ittraveler webpages to markdown format

# Example Usage

# find . -name "*.ht*" | while read i; do html_to_md.sh "$i" ; done

cat $1 | sed '1,/icon-title/d' | sed -n '/wp_rp_wrap/q;p' | sed 's|<p>||g' | sed 's|</p>||g' | sed 's|crayon-plain-wrap|CODESTART|g' | sed 's|</textarea></div>|\nCODEEND|g' | sed  '/CODESTART/c\```' | sed  '/CODEEND/c\```' | sed 's/<[^>]*>//g' | grep -v -E '^[0-9]+$' | sed '/^$/d' | sed '1s/.*/# & \ /' | sed '2s/.*/***&***\n/' | sed  '2s|  ||' | sed  '2s|  ||' > $( echo "$1" | sed 's|.html||g').md

