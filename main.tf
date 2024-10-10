data "azurerm_resource_group" "default" {
  name = "rg-playground-test-weu"
}

resource "azurerm_kubernetes_cluster" "demo" {
  name                = "aks-playground-test-weu"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "demo-aks"
  sku_tier            = "Standard"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "default" {
  name                  = "default"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.demo.id
  vm_size               = "Standard_B2ms"
  node_count            = 2
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.demo.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.demo.kube_config_raw
  sensitive = true
}

resource "helm_release" "demo_app" {
  name             = "demo-app"
  chart            = "./helmchart/demo-app"
  namespace        = "demo-app"
  create_namespace = true
  wait             = true

  depends_on = [
    azurerm_kubernetes_cluster_node_pool.default,
  ]
}