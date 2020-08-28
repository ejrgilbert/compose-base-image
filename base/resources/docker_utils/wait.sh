#!/bin/bash

function wait_for()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    (( i = 1 ))

    until nc -z "$service" "$port" >/dev/null 2>&1; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( i == max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi

      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      (( i++ ))
      sleep $retry_seconds
    done
    echo "[$i/$max_try] $service:${port} is available."
}

read -r -a to_check_status <<< "${SERVICE_PRECONDITION}"
echo "${to_check_status[*]}"
for i in "${to_check_status[@]}"
do
    wait_for "${i}"
done
