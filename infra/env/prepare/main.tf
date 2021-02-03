module "inputs" {
    source = "../../new_inputs"
}

module "wireguard_config" {
    source = "../../modules/new_wireguard_config"
    external_ip = var.vpn_external_ip
    namespaces = module.inputs.grouped_teams
}

resource "local_file" "output" {
    filename = "./namespaces.json"
    content = jsonencode(module.wireguard_config.namespaces_config)
}
