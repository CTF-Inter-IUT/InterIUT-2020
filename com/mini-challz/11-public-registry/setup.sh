#!/usr/bin/env bash

# Script de configuration automatique du challenge
# Il permet de générer le le fichier registry.tar.gz qui contient
# une image d'alpine LINUX avec un fichier FLAG à la racine

if [ -z "$1" ]
then
    echo 'Usage : ./setup.sh ENSIBS{abc}'
    exit
fi

FLAG=$1
REGISTRYCONTAINER="challenge_registry"
IMAGE="alpine"

# Clean up
docker rm --force $REGISTRYCONTAINER

# Build flag image
docker pull $IMAGE

docker build \
    -t localhost:5000/nyanflag:latest \
    --build-arg "FLAG=$FLAG" \
    -f Dockerfile-challenge .

# Start registry and push image
docker run -d -p 5000:5000 --rm --name $REGISTRYCONTAINER registry:2

docker push localhost:5000/nyanflag:latest

docker exec $REGISTRYCONTAINER tar -zcvf /registry.tar.gz /var/lib/registry

docker cp $REGISTRYCONTAINER:/registry.tar.gz ./registry.tar.gz

docker stop $REGISTRYCONTAINER

# docker rmi localhost:5000/nyanflag:latest

docker-compose build --no-cache
