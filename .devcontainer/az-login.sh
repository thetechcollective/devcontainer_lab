#!/bin/bash

# This script logs in to Azure CLI with the correct scope and tenant for OMB
# Usage: ./az-omb-login.sh [dev|prod|qa]
# If no argument is provided, the script will be interactive, and prompt to select a subscription (DE|PR|QA)
# If an argument is provided, the script will log in to the specified subscription (DE|PR|QA)

#Assert everything is ok, Exit on any error
set -e 

# Context specific settings Tenant, Scope and Subscription settings 
# These are for ARLA OMB
SCOPE="api://arla.omb.com/de/api/.default"
TENANT="f10e34fe-8994-4b52-a7da-4f7aa9068ca0"
#Subscriptions
OMB_DEV="83d6c776-54f0-40f7-9a75-3aafd63cae09"    # AC-WEU-OneMilkBalance-DE-001
OMB_PROD="c43f8d48-1f93-4e88-89a2-6ca7dad4dfaf"   # AC-WEU-OneMilkBalance-PR-001
OMB_QA="ad17ece4-b3d1-4048-a221-49051be9f9e0"     # AC-WEU-OneMilkBalance-QA-001

# Disable the login experience v2 (do not prompt to select subscription)
# https://learn.microsoft.com/en-gb/cli/azure/azure-cli-configuration#cli-configuration-values-and-environment-variables
az config set core.login_experience_v2=off > /dev/null 2>&1

if [ "$1" == "dev" ]; then
    SUBSCRIPTION=$OMB_DEV
elif [ "$1" == "prod" ]; then
    SUBSCRIPTION=$OMB_PROD
elif [ "$1" == "qa" ]; then
    SUBSCRIPTION=$OMB_QA
fi

PREFIX="$(basename $0) $1: "

## Check if the users is already loggind in to the scope and tenant -if so - assume the this script is being re-run. Skip the login
if az account show > /dev/null 2>&1; then
    echo "$PREFIX Already logged in to Azure CLI!"
    # Set the subscription if provided
    [ -n "$SUBSCRIPTION" ] && az account set --subscription $SUBSCRIPTION
    exit 0
fi

echo "Logging in to Azure CLI..."
az login --scope $SCOPE --tenant $TENANT > /dev/null
[ -n "$SUBSCRIPTION" ] && az config set core.login_experience_v2=off > /dev/null 2>&1 && az account set --subscription $SUBSCRIPTION
echo "$PREFIX Logged in to Azure - account status:"
az account show 

echo "$PREFIX SUCCES"