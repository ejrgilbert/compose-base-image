#!/bin/bash
set -e

echo "Starting sshd on $(hostname --ip-address)"
exec /usr/sbin/sshd