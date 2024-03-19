variable "environment" {
  description = "Environment of the web app"
  type        = string
  default     = "dev"
}

provider "azurerm" {
  features {}
}

locals {
  resourceGroupName  = "${random_string.rs.result}-rg"
  webAppName         = "${random_string.rs.result}-${var.environment}"
  appServicePlanName = "${random_string.rs.result}-plan"
  sqlServerName      = "${lower(random_string.rs.result)}-sql"
  sku                = "F1"
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

resource "azurerm_sql_database" "db" {
    name                = "AzureDB"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    server_name         = azurerm_sql_server.sql.name
    edition             = "Standard"
    collation           = "SQL_Latin1_General_CP1_CI_AS"
    max_size_bytes      = "1073741824"
    create_mode         = "Default"
}

output "application_name" {
  value = azurerm_app_service.app_service_app.name
}

output "application_url" {
  value = azurerm_app_service.app_service_app.default_site_hostname
}

output "sql_server_connection_string" {
    value = "Server=tcp:${azurerm_sql_server.sql.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.db.name};Persist Security Info=False;User ID=${azurerm_sql_server.sql.administrator_login};Password={administrator_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}
