resource "azurerm_resource_group" "rg_m360_generic" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_logic_app_workflow" "logic_m360_generic" {
  name                = var.logic_name
  location            = azurerm_resource_group.rg_m360_generic.location
  resource_group_name = azurerm_resource_group.rg_m360_generic.name

  #depends_on = [azurerm_resource_group.rg_m360_generic]
}

# de aqui a abajo solo se ejecuta una vez que tengamos el workflow.json
data "local_file" "logic_app" {
  filename = "workflow.json"
}

resource "azurerm_resource_group_template_deployment" "logic_app_deployment" {
  resource_group_name = azurerm_resource_group.rg_m360_generic.name
  deployment_mode     = "Incremental"
  name                = "logic-app-deployment"

  template_content = data.local_file.logic_app.content

  parameters_content = jsonencode({
    "logic_app_name" = { value = azurerm_logic_app_workflow.logic_m360_generic.name }
    "location"       = { value = azurerm_logic_app_workflow.logic_m360_generic.location }
  })

  depends_on = [azurerm_logic_app_workflow.logic_m360_generic]
}
