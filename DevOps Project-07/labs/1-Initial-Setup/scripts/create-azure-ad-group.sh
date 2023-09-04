#!/bin/sh

AZURE_AD_GROUP_NAME="devopsjourney-aks-group"
CURRENT_USER_OBJECTID=$(az ad signed-in-user show --query objectId -o tsv)

# Create Azure AD Group
az ad group create --display-name $AZURE_AD_GROUP_NAME --mail-nickname $AZURE_AD_GROUP_NAME

# Add Current az login user to Azure AD Group
az ad group member add --group $AZURE_AD_GROUP_NAME --member-id $CURRENT_USER_OBJECTID

AZURE_GROUP_ID=$(az ad group show --group "devopsjourney-aks-group" --query objectId -o tsv)

echo "AZURE AD GROUP ID IS: $AZURE_GROUP_ID"