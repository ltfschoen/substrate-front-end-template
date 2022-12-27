#!/usr/bin/env bash
# Copyright 2017-2022 @polkadot authors & contributors
# This software may be modified and distributed under the terms
# of the Apache-2.0 license. See the LICENSE file for details.

trap "echo; exit" INT
trap "echo; exit" HUP

source $(dirname "$0")/.env.example \
    && source $(dirname "$0")/.env \
    && export APP_NAME=$(jq '.name' package.json | sed 's/\"//g') \
    && export PORT_DEV \
    && if [ "$NODE_ENV" != "development" ]; \
        then printf "\nError: NODE_ENV should be set to development in .env\n"; \
        kill "$PPID"; exit 1; fi \
    && export PUBLIC_URL="http://localhost:${PORT_DEV}" \
    && printf "\n*** Building Docker container. Please wait... \n***" \
    && DOCKER_BUILDKIT=0 docker compose -f docker-compose-dev.yml up --build -d

printf "\n*** Finished building. Please open: http://localhost:${PORT_DEV}\n"
