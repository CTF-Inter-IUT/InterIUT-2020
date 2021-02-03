provider "google" {
    credentials = file("credentials.json")
    project = "interiut"
    region = "europe-west1"
    zone = "europe-west1-b"
}

module "cluster" {
    source = "./cluster"
}

provider "kubernetes" {
    client_certificate = module.cluster.client_certificate
    client_key = module.cluster.client_key
    cluster_ca_certificate = module.cluster.cluster_ca_certificate
}

module "inputs" {
    source = "../../inputs"
}

# module "wireguard_config" {
#     source = "../../modules/wireguard_config"
# //    teams = module.inputs.teams
#     external_ip = var.external_ip
#     namespaces = module.inputs.grouped_teams
# }

module "k8s" {
    source = "../../modules/kubernetes"

    namespaces = local.namespaces
    external_ip = var.external_ip
    ctfd_ip = var.ctfd_ip
    challenges = module.inputs.challenges
    challz_folder = module.inputs.challz_folder
}
