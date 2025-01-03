locals {
  vnets   = { for Row in csvdecode(file("./InputFiles/vnets.csv")) : Row.name => Row }
  subnets = { for Row in csvdecode(file("./InputFiles/subnets.csv")) : "${Row.vnet_name}.${Row.subnet_name}" => Row }
  nsgs    = { for Index, Row in csvdecode(file("./InputFiles/nsgs.csv")) : "${trimspace(lower(Row.name))}.${trimspace(lower(Row.security_rule_name))}" => merge(Row, { index = Index }) }
}

resource "azurerm_resource_group" "this" {
  name     = "brett-training"
  location = "East US2"
}

resource "azurerm_virtual_network" "this" {
  for_each            = local.vnets
  name                = each.value.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = split(",", each.value.address_space)
  dns_servers         = split(",", each.value.dns_servers)
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_name].name
  address_prefixes     = split(",", each.value.address_prefixes)
}

resource "azurerm_network_security_group" "this" {
  for_each            = toset([for nsg in local.nsgs : trimspace(lower(nsg.name))])
  name                = each.value
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

# ordering is alphabeitcal rather than csv order
resource "azurerm_network_security_rule" "this" {
  for_each = local.nsgs

  name                        = each.value.security_rule_name
  network_security_group_name = azurerm_network_security_group.this["${trimspace(lower(each.value.name))}"].name

  resource_group_name          = azurerm_resource_group.this.name
  description                  = each.value.description
  direction                    = each.value.direction
  priority                     = each.value.index + 100
  protocol                     = each.value.protocol
  access                       = each.value.access
  source_port_range            = each.value.source_port_ranges == "*" ? "*" : null
  source_port_ranges           = each.value.source_port_ranges == "*" ? null : split(",", each.value.source_port_ranges)
  destination_port_range       = each.value.destination_port_ranges == "*" ? "*" : null
  destination_port_ranges      = each.value.destination_port_ranges == "*" ? null : split(",", each.value.destination_port_ranges)
  source_address_prefix        = each.value.source_address_prefixes == "*" ? "*" : null
  source_address_prefixes      = each.value.source_address_prefixes == "*" ? null : split(",", each.value.source_address_prefixes)
  destination_address_prefix   = each.value.destination_address_prefixes == "*" ? "*" : null
  destination_address_prefixes = each.value.destination_address_prefixes == "*" ? null : split(",", each.value.destination_address_prefixes)

  source_application_security_group_ids      = length(each.value.source_application_security_group_ids) > 0 ? split(",", each.value.source_application_security_group_ids) : null
  destination_application_security_group_ids = length(each.value.destination_application_security_group_ids) > 0 ? split(",", each.value.destination_application_security_group_ids) : null
}

output "test" {
  value = csvdecode(file("./InputFiles/nsgs.csv"))
}


###################################
# From Variables
###################################

resource "azurerm_virtual_network" "variable" {
  for_each            = var.vnets
  name                = each.key
  location            = each.value.location == null ? azurerm_resource_group.this.location : each.value.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
}

resource "azurerm_subnet" "variable" {
  for_each             = var.subnets
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = azurerm_resource_group.this.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [{}] : []
    content {
      name = each.value.delegation.name

      dynamic "service_delegation" {
        for_each = [{}]
        content {
          name    = each.value.delegation.service_delegation.name
          actions = each.value.delegation.service_delegation.actions
        }
      }
    }
  }
}
