data "azurerm_resource_group" "default" {
  name = "rg-playground-test-weu"
}

resource "azurerm_kubernetes_cluster" "demo" {
  name                = "aks-playground-test-weu"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "demo-aks"
  sku_tier            = "Standard"

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

resource "helm_release" "demo_app" {
  name             = "demo-app"
  chart            = "./helmchart/demo-app"
  namespace        = "demo-app"
  create_namespace = true
  wait             = true

  depends_on = [
    azurerm_kubernetes_cluster.demo,
    helm_release.demo_app,
  ]
}