#!/usr/bin/env bash

set -e

PREFIX="$(basename $0): "

if [ "$GITHUB_CLI_AUTH_REQUIRED" = "1" ]; then
    $(dirname $0)/gh-login.sh initialize
fi 

