#!/usr/bin/env bash

set -e

PREFIX="$(basename $0): "

echo "$PREFIX Setting up git configuration to support .gitconfig in repo-root"
git config --local --get include.path | grep -e ../.gitconfig >/dev/null 2>&1 || git config --local --add include.path ../.gitconfig

if [ -f Pipfile ]; then
    echo "$PREFIX Installing Python --dev dependencies"
    pipenv install --dev
fi

if [ "$GITHUB_CLI_AUTH_REQUIRED" = "1" ]; then
    $(dirname $0)/gh-login.sh postcreate
fi

if [ "$GITHUB_CLI_AUTH_REQUIRED" = "1" ]; then
    $(dirname $0)/gh-login.sh postcreate
fi

if [ "$AZ_AUTH_REQUIRED" = "1" ]; then
    $(dirname $0)/az-login.sh $AZ_DEFAULT_ENV
fi


echo "$PREFIX SUCCESS"

