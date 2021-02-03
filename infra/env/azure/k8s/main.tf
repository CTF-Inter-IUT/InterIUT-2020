provider "kubernetes" {
    load_config_file = false
    host = var.host
    client_certificate = var.client_certificate
    client_key = var.client_key
    cluster_ca_certificate = var.cluster_ca_certificate
}

module "kubernetes" {
    source = "../../../modules/kubernetes"
}