aks_name = 'devopsjourneyaks'
rg_name = 'devopsjourneyaks-rg'

describe azure_aks_cluster(resource_group: rg_name, name: aks_name) do
    it { should exist }
  end