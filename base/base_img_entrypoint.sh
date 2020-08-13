#!/bin/bash

DIR=/entrypoint.d

if [[ -d "$DIR" ]]; then
  echo "Running run-parts ..."
  /bin/run-parts "$DIR"
fi

if [ -z "$1" ]; then
  echo "Specify command to run."
  exit 1
fi

exec "$*"