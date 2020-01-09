#!/bin/bash

# sed 's/^.*\(title icon-title.*wp_rp_wrap\).*$/\1/' $1 > test.html

cat $1 | sed '1,/icon-title/d' | sed -n '/wp_rp_wrap/q;p' | sed 's|<p>||g' | sed 's|</p>||g' | sed 's|crayon-plain-wrap|CODESTART|g' | sed 's|</textarea></div>|\nCODEEND|g' | sed  '/CODESTART/c\```' | sed  '/CODEEND/c\```' | sed 's/<[^>]*>//g' | sed '/^$/d' |sed '1s/.*/# & \ /' | sed '2s/.*/*** & *** \ /' > test.html

cat $1 | sed '1,/icon-title/d' | sed -n '/wp_rp_wrap/q;p' | sed 's|<p>||g' | sed 's|</p>||g' | sed 's|crayon-plain-wrap|CODESTART|g' | sed 's|</textarea></div>|\nCODEEND|g' | sed  '/CODESTART/c\```' | sed  '/CODEEND/c\```' | sed 's/<[^>]*>//g' | sed '/^$/d' | sed '1s/.*/# & \ /' | sed '2s/.*/*** & *** \ /' > test.md

