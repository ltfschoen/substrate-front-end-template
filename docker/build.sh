#!/usr/bin/env bash
# Copyright 2017-2022 @polkadot/apps authors & contributors
# This software may be modified and distributed under the terms
# of the Apache-2.0 license. See the LICENSE file for details.

# fail fast on any non-zero exits
set -e

# the docker image name and dockerhub repo
WEBSERVER_DIR="substrate-front-end-template"

echo "*** Building $WEBSERVER_DIR"

if [[ $NODE_ENV = "production" ]]
then
  echo "*** Building production"
  docker build --build-arg NODE_ENV=$NODE_ENV -t $WEBSERVER_DIR -f docker/Dockerfile.prod .
else
  echo "*** Building development"
  docker build -t $WEBSERVER_DIR -f docker/Dockerfile.dev .
fi

echo "*** Finished building $WEBSERVER_DIR"

echo "*** Building $WEBSERVER_DIR"
