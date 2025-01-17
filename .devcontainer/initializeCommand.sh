#!/usr/bin/env bash

echo "Running $0"

gh auth status > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Your host is not authenticated with GitHub CLI."
  echo "NOTE:"
  echo "  In the future, make sure your host is authenticated with GitHub CLI at the time you start the devconatiner."
  echo "  And the devcontainer will log you in automatically."
else
  echo "Your host is authenticated with GitHub CLI."
  echo "GITHUB_TOKEN_BASE64=$(echo $(gh auth token) | base64 )" >> $(dirname $0)/devcontainer.env
fi
