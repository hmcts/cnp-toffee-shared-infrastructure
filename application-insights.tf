locals {
  env = var.env == "sandbox" ? "sbox" : var.env
  business_area = strcontains(lower(data.azurerm_subscription.current.display_name), "cftapps") ? "cft" : "sds"
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
  subscription_id = data.azurerm_client_config.current.subscription_id
}

data "azurerm_windows_function_app" "alerts" {
  provider            = azurerm.private_endpoint
  name                = "${local.business_area}-alerts-slack-${local.env}"
  resource_group_name = "${local.business_area}-alerts-slack-${local.env}"
}

data "azurerm_function_app_host_keys" "host_keys" {
  provider            = azurerm.private_endpoint
  name                = data.azurerm_windows_function_app.alerts.name
  resource_group_name = "${local.business_area}-alerts-slack-${local.env}"
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "${title(var.product)}-${title(var.env)}-Warning-Alerts"
  resource_group_name = azurerm_resource_group.shared_resource_group.name
  short_name          = "${var.product}-${local.env}"

  azure_function_receiver {
    function_app_resource_id = data.azurerm_windows_function_app.alerts.id
    function_name            = "httpTrigger"
    http_trigger_url         = "https://${data.azurerm_windows_function_app.alerts.default_hostname}/api/httpTrigger?code=${data.azurerm_function_app_host_keys.host_keys.default_function_key}"
    name                     = "slack-alerts"
    use_common_alert_schema  = true
  }

  tags = var.common_tags
}

module "application_insights" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=alert"

  env     = var.env
  product = var.product
  name    = "${var.product}"

  resource_group_name = azurerm_resource_group.shared_resource_group.name
  action_group_id = azurerm_monitor_action_group.action_group.id

  common_tags = var.common_tags
}

moved {
  from = azurerm_application_insights.appinsights
  to   = module.application_insights.azurerm_application_insights.this
}

resource "azurerm_key_vault_secret" "appInsights-InstrumentationKey" {
  name         = "appInsights-InstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = module.vault.key_vault_id
}
