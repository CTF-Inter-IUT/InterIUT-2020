#!/bin/bash

set -e

if [ -t 0 ] ; then
    /usr/bin/nyancat
else
    echo "N'oubliez pas l'argument -it ;)"
fi
