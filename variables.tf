
variable "vnets" {
  type = map(object({
    location      = optional(string)
    address_space = list(string)
    dns_servers   = optional(list(string))
  }))
  default = {
    default = {
      location      = "east us2"
      address_space = ["10.0.0.0/16"]
      dns_servers   = ["10.0.0.1"]
    }
  }
}

variable "subnets" {
  type = map(object({
    name                                          = string
    virtual_network_name                          = string
    address_prefixes                              = list(string)
    default_outbound_access_enabled               = optional(bool)
    private_endpoint_network_policies             = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    }))
  }))
}
