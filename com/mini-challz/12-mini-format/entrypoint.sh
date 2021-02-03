#!/usr/bin/env bash

echo "Challenge minibuffer started on port 1337"

while true
do
    su -c "exec socat TCP-LISTEN:1338,reuseaddr,fork EXEC:/challenge/ENSIBS{tr0_f4c1l3_l35_f0rm4t_5tring5},stderr,pty" - interiut
done
