provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  #version         = "3.42"
  skip_provider_registration = true
  features {}
}

terraform {
  #required_version = "1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "< 3.90.0"
    }
  }
}
