provider "azurerm" {
  features {}
}

# Crear un grupo de recursos
resource "azurerm_resource_group" "resource-group-health-app" {
  name     = "resource-group-health-app-no-borrar-jaime-mayor"
  location = "East US"
}

#Registro de contenedores
resource "azurerm_container_registry" "acr" {
  name                = "acrJaimeMayor"
  resource_group_name = azurerm_resource_group.resource-group-health-app.name
  location            = azurerm_resource_group.resource-group-health-app.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_user_assigned_identity" "testIdentity" {
  resource_group_name = azurerm_resource_group.resource-group-health-app.name
  location            = azurerm_resource_group.resource-group-health-app.location

  name = "identity1"
}

# Creación del clúster de AKS
resource "azurerm_kubernetes_cluster" "aks-health-app" {
  name                = "example-aks-cluster"
  location            = azurerm_resource_group.resource-group-health-app.location
  resource_group_name = azurerm_resource_group.resource-group-health-app.name
  dns_prefix          = "exampleaks1"
  # Configuración de la red de AKS
 default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}


