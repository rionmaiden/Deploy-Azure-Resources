variable "environment" {
  description = "Environment of the web app"
  type        = string
  default     = "app"
}

provider "azurerm" {
  features {}
}

locals {
  resourceGroupName   = "${random_string.rs.result}-rg"
  webAppName         = "${random_string.rs.result}-${var.environment}"
  appServicePlanName = "${random_string.rs.result}-plan"
  sku                = "S1"
}

resource "random_string" "rs" {
  length  = 8
  special = false
}

resource "azurerm_resource_group" "rg" {
    name     = local.resourceGroupName
    location = "UK South"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = local.appServicePlanName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = local.sku
  }
}

resource "azurerm_app_service" "app_service_app" {
  name                = local.webAppName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
}

output "application_name" {
  value = azurerm_app_service.app_service_app.name
}

output "application_url" {
  value = azurerm_app_service.app_service_app.default_site_hostname
}
