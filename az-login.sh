#!/bin/bash

SCOPE="api://arla.omb.com/de/api/.default"
TENANT="f10e34fe-8994-4b52-a7da-4f7aa9068ca0"

## Check if the users is already loggind in to the scope and tenant -if so - assume the this script is being re-run. Skip the login
if az account get-access-token --scope $SCOPE --tenant $TENANT > /dev/null 2>&1; then
    echo "Already logged in to Azure CLI!"
    exit 0
fi

echo "Logging in to Azure CLI..."
az login --scope $SCOPE --tenant $TENANT
az account get-access-token --scope $SCOPE --tenant $TENANT

echo "Authentication successful!"