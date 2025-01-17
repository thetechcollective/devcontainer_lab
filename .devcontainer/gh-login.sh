#!/usr/bin/env bash

# Usage: ./gh-login.sh {initialize|postcreate}"
#
# Purpose: To allow the devcontainer to authenticate with GitHub CLI without user interaction
#
# Designed to run as an initializeCommand in a devcontainer.json file
# This script will check if the host is authenticated with GitHub CLI
# If so it will store the base64 encoded token in the devcontainer.env file
# for a later postCreateCommand to use to authenticate the devcontainer with GitHub CLI
# 
# To get the benefits of this script, you must have the following in your devcontainer.json file:
#
#   "initializeCommand": "./.devcontainer/gh-login.sh initialize",
#   "postCreateCommand": "./.devcontainer/gh-login.sh postcreate",
#   "runArgs": [
#   	"--env-file",
#   	"./.devcontainer/devcontainer.env"
#     ]

initialize() {  
  gh auth status > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "$PREFIX Your host is not authenticated with GitHub CLI."
    echo "$PREFIX NOTE:"
    echo "$PREFIX    In the future, make sure your host is authenticated with GitHub CLI" 
    echo "$PREFIX    at the time you start the devconatiner."
    echo "$PREFIX    And the devcontainer will be able to log you in without user intaraction."
  else
    echo "$PREFIX Your host is authenticated  with GitHub CLI."
    cp $(dirname $0)/devcontainer.env $(dirname $0)/devcontainer.env.bak
    # Check if the devcontainer.env has an empty line at the end if not add one
    if [ -n "$(tail -c 1 $(dirname $0)/devcontainer.env)" ]; then
      echo "" >> $(dirname $0)/devcontainer.env
    fi 
    echo "GITHUB_TOKEN_BASE64=$(echo $(gh auth token) | base64 )" >> $(dirname $0)/devcontainer.env
  fi
}

postcreate(){
  if [ -n "$GITHUB_TOKEN_BASE64" ]; then
      echo "$PREFIX ...using token from host"
      echo $GITHUB_TOKEN_BASE64 | base64 --decode | gh auth login --with-token
      echo "$PREFIX ...cleaning up after the initialize step"
      cp $(dirname $0)/devcontainer.env.bak $(dirname $0)/devcontainer.env 
      echo "$PREFIX Logged in to GitHub CLI - account status:"
      gh auth status
  else
      gh auth login -w -p https -h github.com
  fi
}


## MAIN

if [ "$1" = "initialize" ]; then
  PREFIX="$(basename $0) initialize: "
  initialize
elif [ "$1" = "postcreate" ]; then
  PREFIX="$(basename $0) postcreate: "
  postcreate
else
  echo "Usage: $(basename $0) {initialize|postcreate}"
  exit 1
fi
echo "$PREFIX SUCCES"

# Failure is not an option
set -e

