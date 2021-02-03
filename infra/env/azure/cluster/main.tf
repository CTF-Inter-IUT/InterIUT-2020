provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "resources" {
    name = var.resource_name
    location = var.location
}

resource "azurerm_kubernetes_cluster" "cluster" {
    name = var.cluster_name
    location = azurerm_resource_group.resources.location
    resource_group_name = azurerm_resource_group.resources.name
    dns_prefix = var.dns_prefix

    default_node_pool {
        name = "default"
        node_count = var.node_count
        vm_size = var.size
        enable_auto_scaling = false
    }

    service_principal {
        client_id = var.client_id
        client_secret = var.client_secret
    }

    network_profile {
        network_plugin = "kubenet"
        load_balancer_sku = "Standard"
    }

    addon_profile {
        kube_dashboard {
            enabled = true
        }
    }
}
