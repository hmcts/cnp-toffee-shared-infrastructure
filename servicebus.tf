locals {
  servicebus_namespace_name = "${var.product}-servicebus-${var.env}"
}

module "servicebus-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }
  source                  = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                    = local.servicebus_namespace_name
  location                = var.location
  sku                     = "Basic"
  resource_group_name     = azurerm_resource_group.shared_resource_group.name
  env                     = var.env
  common_tags             = var.common_tags
  project                 = var.project
}
	