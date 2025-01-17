#!/usr/bin/env bash

set -x
set -e

PREFIX="$(basename $0): "

$(dirname $0)/gh-login.sh initialize

echo "$PREFIX SUCCESS"

