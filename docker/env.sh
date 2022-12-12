#!/bin/bash
# Copyright 2017-2022 @polkadot/apps authors & contributors
# SPDX-License-Identifier: Apache-2.0

# This script is used when the docker container starts and does the magic to
# bring the ENV variables to the generated static UI.

# https://www.freecodecamp.org/news/how-to-implement-runtime-environment-variables-with-create-react-app-docker-and-nginx-7f9d42a91d70/

# TARGET=./env-config.js

# # Recreate config file
# echo -n > $TARGET

# declare -a vars=(
#   "WATCHPACK_POLLING=true",
#   "WDS_SOCKET_PORT=0",
#   "WDS_SOCKET_HOST=127.0.0.1",
#   "PUBLIC_URL=http://localhost"
# )

# echo "window.process_env = {" >> $TARGET
# for VAR in ${vars[@]}; do
#   echo "  $VAR: \"${!VAR}\"," >> $TARGET
# done
# echo "}" >> $TARGET

# Recreate config file
rm -rf ./env-config.js
touch ./env-config.js

# Add assignment 
echo "window.process_env = {" >> ./env-config.js

# Read each line in .env file
# Each line represents key=value pairs
while read -r line || [[ -n "$line" ]];
do
  # Split env variables by character `=`
  if printf '%s\n' "$line" | grep -q -e '='; then
    varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
    varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
  fi

  # Read value of current variable if exists as Environment variable
  value=$(printf '%s\n' "${!varname}")
  # Otherwise use value from .env file
  [[ -z $value ]] && value=${varvalue}
  
  # Append configuration property to JS file
  echo "  $varname: \"$value\"," >> ./env-config.js
done < .env

echo "}" >> ./env-config.js
