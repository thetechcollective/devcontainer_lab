#!/usr/bin/env bash

set -e

PREFIX="$(basename $0): "

gh auth status > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "$PREFIX Your host is not authenticated with GitHub CLI."
  echo "$PREFIX NOTE:"
  echo "$PREFIX  In the future, make sure your host is authenticated with GitHub CLI" 
  echo "$PREFIX at the time you start the devconatiner."
  echo "$PREFIX  And the devcontainer will log you in automatically."
else
  echo "$PREFIX Your host is authenticated with GitHub CLI."
  echo "GITHUB_TOKEN_BASE64=$(echo $(gh auth token) | base64 )" >> $(dirname $0)/devcontainer.env
fi