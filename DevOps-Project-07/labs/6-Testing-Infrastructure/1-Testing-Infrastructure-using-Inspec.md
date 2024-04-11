# Using Inspec-Azure to test your Azure Resources

Inspec-Azure is a resource pack provided by Chef that uses the Azure REST API, to allow you to write tests for resources that you have deployed in Microsoft Azure. These tests can be used to validate the Azures resources that were deployed via code using Terraform or Azure RM templates. Inspec is an open source framework that is used for testing and auditing your infrastructure, in this blog post I will show how you can create tests against your Azure resources using Inspec-Azure.

# Why test my deployment?

When you deploy your Azure Resources whether via the Portal or code using a CI/CD pipeline; the deployment will follow some-sort of approval process and deployed with a specific set of requirements in mind. The deployment may deploy OK and look fine but the deployment has not been validated as what is expected to be deployed and the actual state the specific resources are in. This is where a validation stage is recommended; this stage will run tests you created to test and validate your Azure resources to confirm they are in the desired end-state.

There is where Inspec-Azure will come into play; as mentioned Inspec is an open source framework that is used for testing and auditing your infrastructure, Inspec-Azure sits on top of Inspec and uses the Azure REST API to query the resources that have been deployed.

# How does Inspec work?

The tests you create are self-explanatory, ruby-based and easy to read. Inspec-Azure works by comparing the actual state of your Azure resources with the desired state that you have expressed in your tests, if violations are detected between the comparing these are outputted in the form of a report, but you are in control of any remediation, can review the report and determine what to do next with the Azure resource to make it compliant again against the failed test.

So in theory, you create tests against your Azure Resources, these are ran against the current state of what is deployed and then an output is reviewed to determine if the Azure resources are in compliance and are the configurations are exactly in the state you want them to be.

Sounds awesome doesn’t it? I have gave theory behind why validating your deployments is recommended and how this can be done in Azure using Inspec-Azure, lets get to testing this out!

1. Install Inspec 
https://www.inspec.io/downloads/

2. Inspec needs a profile, this can be created using:

`inspec init profile --platform azure azure-inspec-tests`

Successful output:
`─────────────────────────── InSpec Code Generator ───────────────────────────
 
Creating new profile at C:/Users/thomast/Documents/blog/Inspec-Azure-Local-Example/azure-inspec-tests
 • Creating directory controls
 • Creating file controls/example.rb
 • Creating file inspec.yml
 • Creating file README.md`

It will result in a folder setup similar to [this](labs/6-Testing-Infrastructure/azure-inspec-tests)

3. Reviewing the tests created, notice the [controls folder](labs/6-Testing-Infrastructure/azure-inspec-tests/controls)? This is where you create the ruby tests to run against your Azure resources. 

I have created test examples for:
- [AKS](labs/6-Testing-Infrastructure/azure-inspec-tests/controls/azure_aks_cluster.rb)
- [Application Gateway](labs/6-Testing-Infrastructure/azure-inspec-tests/controls/azure_application_gateway.rb)
- [Azure Container Registry](labs/6-Testing-Infrastructure/azure-inspec-tests/controls/azure_container_registry.rb)
- [Key Vault](labs/6-Testing-Infrastructure/azure-inspec-tests/controls/azure_key_vault.rb)
- [Virtual Network](labs/6-Testing-Infrastructure/azure-inspec-tests/controls/azure_virtual_network.rb)

Review these tests and change variables where needed!

4. Running Inspec tests locally:
Ensure you are signed in to the correct Azure subscription
`inspec exec azure-inspec-tests -t azure://`

5. Confirm the tests are all successful, by reviewing output above!

`Profile: Azure InSpec Profile (azure-inspec-tests)
Version: 0.1.0
Target:  azure://***

  Azure Aks Cluster - api_version: 2021-10-01 latest: devopsjourneyaks-rg Microsoft.ContainerService/managedClusters devopsjourneyaks
     ✔  is expected to exist
  Azure Application Gateway - api_version: 2021-06-01 latest: devopsjourneyaks-node-rg Microsoft.Network/applicationGateways applicationgateway
     ✔  is expected to exist
  Azure Container Registries - api_version: 2019-05-01 latest Microsoft.ContainerRegistry/registries
     ✔  is expected to exist
     ✔  names is expected to include "devopsjourneyacr"
  Azure Key Vault - api_version: 2021-10-01 latest: devopsjourney-rg Microsoft.KeyVault/vaults devopsjourney-kv
     ✔  is expected to exist
     ✔  name is expected to cmp == "devopsjourney-kv"
  Azure Key Vault Secret - api_version: 7.1 latest: .vault.azure.net AIKEY https://devopsjourney-kv.vault.azure.net/secrets/AIKEY
     ✔  is expected to exist
  Azure Virtual Network - api_version: 2018-02-01 user_provided: devopsjourney-vnet-rg Microsoft.Network/virtualNetworks devopsjourney-vnet
     ✔  address_space is expected to eq ["192.168.0.0/16"]
     ✔  subnets is expected to eq ["aks", "appgw"]`




