variable "environment" {
  description = "Environment of the web app"
  type        = string
  default     = "app"
}

provider "azurerm" {
  features {}
}

locals {
  resourceGroupName  = "${random_string.rs.result}-rg"
  webAppName         = "${random_string.rs.result}-${var.environment}"
  appServicePlanName = "${random_string.rs.result}-plan"
  sqlServerName      = "${lower(random_string.rs.result)}-sql"
  sku                = "S1"
  sql_administrator_username = "superadmin"
  sql_administrator_password = "${random_string.rs.result}123!"
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

resource "azurerm_sql_server" "sql" {
  name                         = local.sqlServerName
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  administrator_login          = local.sql_administrator_username
  administrator_login_password = local.sql_administrator_password
  version                      = "12.0"
  tags = {
      environment = "production"
  }
}

output "application_name" {
  value = azurerm_app_service.app_service_app.name
}

output "application_url" {
  value = azurerm_app_service.app_service_app.default_site_hostname
}
