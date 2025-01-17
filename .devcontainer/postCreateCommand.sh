#!/usr/bin/env bash

set -e

PREFIX="$(basename $0): "


if [ "$GITHUB_CLI_AUTH_REQUIRED" = "1" ]; then
    echo "$PREFIX GitHub CLI authentication is required"
    if [ -n "$GITHUB_TOKEN_BASE64" ]; then
        echo "$PREFIX ...using token from host"
        echo $GITHUB_TOKEN_BASE64 | base64 --decode | gh auth login --with-token
        sed -i '/^GITHUB_TOKEN_BASE64/d' $(dirname $0)/devcontainer.env
    else
        gh auth login -w -p https -h github.com
    fi
fi

echo "$PREFIX Setting up git configuration to support .gitconfig in repo-root"
git config --local --get include.path | grep -e ../.gitconfig >/dev/null 2>&1 || git config --local --add include.path ../.gitconfig

if [ -f Pipfile ]; then
    echo "$PREFIX Installing Python --dev dependencies"
    pipenv install --dev
fi
