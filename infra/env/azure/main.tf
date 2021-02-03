module "cluster" {
    source = "./cluster"
    resource_name = var.resource_name
    cluster_name = var.cluster_name
    location = var.location
    dns_prefix = var.dns_prefix
    size = var.size
    node_count = var.node_count
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
}

module "k8s" {
    source = "./k8s"
    host = module.cluster.host
    client_certificate = base64decode(module.cluster.client_certificate)
    client_key = base64decode(module.cluster.client_key)
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
}
