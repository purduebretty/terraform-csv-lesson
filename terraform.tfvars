vnets = {
  "from_var_1" = {
    location = "east us"
    address_space = ["10.0.0.0/16"]
    dns_servers   = ["10.0.0.1"]
  }
  "from_var_2" = {
    location = "east us2"
    address_space = ["10.0.1.0/16"]
    dns_servers   = ["10.0.0.1"]
  }
  "from_var_3" = {
    address_space = ["10.0.2.0/16"]
    dns_servers   = ["10.0.0.1"]
  }
  "from_var_4" = {
    location = "east us2"
    address_space = ["10.0.3.0/16"]
    dns_servers   = ["10.0.0.1"]
  }
}


subnets = {
  "from_var_1.default" = {
    name = "default"
    virtual_network_name = "from_var_1"
    address_prefixes = ["10.0.0.0/24"]
    default_outbound_access_enabled = true
    private_endpoint_network_policies = "Disabled"
    delegation = {
      name = "delegation"
      service_delegation = {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
      }
    }
  }
  "from_var_1.app_service" = {
    name = "app_service"
    virtual_network_name = "from_var_1"
    address_prefixes = ["10.0.0.1/24"]
    default_outbound_access_enabled = true
    private_endpoint_network_policies = "Disabled"
    delegation = {
      name = "delegation"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
      }
    }
  }  
  "from_var_2.default" = {
    name = "default"
    virtual_network_name = "from_var_2"
    address_prefixes = ["10.0.1.0/24"]
    default_outbound_access_enabled = true
    private_endpoint_network_policies = "Disabled"
  }
  "from_var_2.app_service" = {
    name = "app_service"
    virtual_network_name = "from_var_2"
    address_prefixes = ["10.0.1.1/24"]
    default_outbound_access_enabled = true
    private_endpoint_network_policies = "Disabled"
    delegation = {
      name = "delegation"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
      }
    }
  }
  "from_var_3.default" = {
    name = "default"
    virtual_network_name = "from_var_3"
    address_prefixes = ["10.0.2.0/24"]
    default_outbound_access_enabled = true
    private_endpoint_network_policies = "Disabled"
  }
}
