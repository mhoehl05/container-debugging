provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.demo.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.demo.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.demo.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.demo.kube_config[0].cluster_ca_certificate)
  }
}