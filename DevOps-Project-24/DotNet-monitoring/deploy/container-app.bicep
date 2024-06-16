// ============================================================================
// Deploy a container app with app container environment and log analytics
// ============================================================================

@description('Name of container app')
param appName string = 'dotnet-demoapp'

@description('Region to deploy into')
param location string = resourceGroup().location

@description('Container image to deploy')
param image string = 'ghcr.io/benc-uk/dotnet-demoapp:latest'

@description('Optional feature: OpenWeather API Key')
param weatherApiKey string = ''

@description('Optional feature: Enable Azure App Insights')
param appInsightsInstrumentationKey string = ''

@description('Optional feature: Enable auth with Azure AD, client id')
param azureAdClientId string = ''
@description('Optional feature: Enable auth with Azure AD, client secret')
@secure()
param azureAdClientSecret string = ''
@description('Optional feature: Enable auth with Azure AD, tenant id')
param azureAdTenantId string = 'common'
@description('Optional feature: Enable auth with Azure AD, instance')
param azureAdInstance string = 'https://login.microsoftonline.com/'

// ===== Variables ============================================================

var logWorkspaceName = '${resourceGroup().name}-logs'
var environmentName = '${resourceGroup().name}-environment'

// ===== Modules & Resources ==================================================

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  location: location
  name: logWorkspaceName
  properties:{
    sku:{
      name: 'Free'
    }
  }
}

resource kubeEnv 'Microsoft.Web/kubeEnvironments@2021-02-01' = {
  location: location
  name: environmentName
  kind: 'containerenvironment'
  
  properties: {
    type: 'Managed'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logWorkspace.properties.customerId 
        sharedKey: logWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  location: location
  name: appName

  properties: {
    kubeEnvironmentId: kubeEnv.id
    template: {
      containers: [
        {
          image: image
          name: appName
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
          env: [
            {
              name: 'Weather__ApiKey'
              value: weatherApiKey
            }
            {
              name: 'ApplicationInsights__InstrumentationKey'
              value: appInsightsInstrumentationKey
            }
            {
              name: 'AzureAd__ClientId'
              value: azureAdClientId
            }
            {
              name: 'AzureAd__ClientSecret'
              secretRef: 'azure-ad-client-secret'
            }
            {
              name: 'AzureAd__Instance'
              value: azureAdInstance
            }
            {
              name: 'AzureAd__TenantId'
              value: azureAdTenantId
            }
          ]
        }
      ]
    }

    configuration: {
      secrets: [
        {
          name: 'azure-ad-client-secret'
          value: azureAdClientSecret
        }
      ]
      ingress: {
        allowInsecure: true
        external: true
        targetPort: 5000
      }
    }
  }
}

// ===== Outputs ==============================================================

output appURL string = 'https://${containerApp.properties.configuration.ingress.fqdn}'
