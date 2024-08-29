data "azurerm_resource_group" "default" {
  name = "rg-playground-test-weu"
}

resource "azurerm_kubernetes_cluster" "demo" {
  name                = "aks-playground-test-weu"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "demo-aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2ms"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.demo.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.demo.kube_config_raw

  sensitive = true
}