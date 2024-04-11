app_gateway_name = 'applicationgateway'
rg_name = 'devopsjourneyaks-node-rg'

describe azure_application_gateway(resource_group: rg_name, name: app_gateway_name) do
    it { should exist }
  end