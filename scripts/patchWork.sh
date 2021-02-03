#!/usr/bin/env bash

chall=$1
image=registry.alfred.cafe/interiut/$chall

docker build -t $image ./challz/$chall
docker push $image
for i in {0..13}
do
    kubectl -n interiut$i rollout restart deploy/$chall
done
