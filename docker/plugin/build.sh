#!/bin/bash

plugin=$(<.plugin)

MONSTACHE_SOURCE_CODE_PATH=${MONSTACHE_SOURCE_CODE_PATH:-../..}

# # Build a docker image
docker build \
"$MONSTACHE_SOURCE_CODE_PATH" \
-f ./Dockerfile \
--build-arg PLUGIN="$plugin" \
-t monstache-plugin

# Start a container from the newly built docker image (the `tail -f` here is just a dummy process to keep the container running until stopped -tail with follow any file-)
docker run \
--rm \
-d \
monstache-plugin \
tail -f /go/src/app/monstache.go

# Get the container id of the last created container
CONTAINER_ID=$(docker ps -l -q)

# If the folder docker-build exists locally
# TODO add a step to confirm from the user before removing the existing folder
if [ -d docker-build ] ; then
 # Then remove it
 rm -r docker-build
fi

mkdir docker-build

docker cp "$CONTAINER_ID":/go/src/app/docker/plugin/$plugin.so ./docker-build/$plugin.so

# Stop the container (it'll be removed automatically once stopped, as we used `--rm`)
docker stop "$CONTAINER_ID"
