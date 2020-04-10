#!/bin/bash
if pgrep -x redshift &> /dev/null; then
    redshift -x
    killall -q redshift
else
    redshift -l 52.09:5.11 -b 1.0:1.0 -t 6500:1900 -r -P &> /dev/null 
fi
