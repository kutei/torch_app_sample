#!/bin/bash -eu

root_path=$(readlink -f $(dirname $0)/..)

{
    echo "HOST_UID=$(id -u)"
    echo "HOST_GID=$(id -g)"
} > $root_path/.env
