#!/bin/bash

DIR=/entrypoint.d

if [[ -d "$DIR" ]]; then
  echo "Running run-parts ..."
  /bin/run-parts "$DIR"
fi

exit $?
