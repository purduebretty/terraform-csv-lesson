################################
# AZURE PROVIDER
################################
provider "azurerm" {
  features {}
  subscription_id = "2642b41d-bf31-4902-8aba-3dc76fa84368"
  tenant_id       = "0b89df11-aae9-4d55-b967-9242a64a6490"
}

provider "azuread" {
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      # Pinning the version so we know what version of the provider that this code works with
      source  = "hashicorp/azurerm"
      version = ">=4.3"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
  }
}
