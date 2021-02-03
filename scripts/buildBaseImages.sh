#!/usr/bin/env bash

for d in docker/*
do
    name=$(basename $d)
    imageName="interiut-base-$name"

    echo "=> Building $name"
    docker build -t registry.alfred.cafe/interiut/$imageName:latest $d
    docker push
done
