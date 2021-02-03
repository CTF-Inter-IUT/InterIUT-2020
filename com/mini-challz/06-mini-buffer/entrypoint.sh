#!/usr/bin/env bash

echo "Challenge minibuffer started on port 1337"

while true
do
    su -c "exec socat TCP-LISTEN:1337,reuseaddr,fork EXEC:/challenge/chall,stderr,pty" - interiut
done
