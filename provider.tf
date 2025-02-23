terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.18.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "2179abbd-615b-45a1-bc02-48c9a711e004"
  tenant_id       = "080235e6-140b-47bd-b805-34a2b40eb303"
  client_id = "5b8e2650-4f64-46de-8893-5bada5bea331"
  client_secret = "5328b860-fedd-4738-94a0-bbee6c7d22a4"
  features {}
}
