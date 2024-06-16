# Deploy into Azure

To deploy as a Azure Container App, a Bicep template is provided

Set resource group and region vars:

```bash
RES_GRP=demoapps
REGION=northeurope
```

Create resource group:

```bash
az group create --name $RES_GRP --location $REGION -o table
```

Deploy Azure Container App

```bash
az deployment group create --template-file container-app.bicep --resource-group $RES_GRP
```

Optional deployment parameters, each one maps to an environment variable (see [main docs](../#configuration) for details):

- **weatherApiKey**
- **appInsightsInstrumentationKey**
- **azureAdClientId**
- **azureAdClientSecret**
- **azureAdTenantId**
- **azureAdInstance**
