# List of teams and challenges
# module "inputs" {
#     source = "../../inputs"
# }

# Private registry secret
resource "kubernetes_secret" "registry-auth" {
    metadata {
        name = "registry-auth"
        namespace = "default"
    }

    data = {
        ".dockerconfigjson" = <<DOCKER
{
	"auths": {
		"registry.alfred.cafe": {
			"auth": "aW50ZXJpdXQ6YWlmIWxlZUBMTzBzb3Vz"
		}
	}
}
DOCKER
    }

    type = "kubernetes.io/dockerconfigjson"
}

resource "random_id" "ctfd_secret_key" {
    byte_length = 64
}

resource "kubernetes_secret" "ctfd_secret_key" {
    metadata {
        name = "ctfd-secret-key"
    }

    data = {
        "secret_key" = random_id.ctfd_secret_key.b64_std
    }
}

module "ctfd" {
    source = "./ctfd"
    secret_key = kubernetes_secret.ctfd_secret_key.metadata.0.name
    external_ip = var.ctfd_ip

    teams = flatten([ for ns in var.namespaces : ns.teams ])

    challz_categories = var.challenges
    challz_folder = var.challz_folder
    flag_format = ""

    image_pull_secret = kubernetes_secret.registry-auth.metadata.0.name
}

module "team_namespace" {
    source = "./team_namespace"

    # for_each = { for index, team in module.inputs.grouped_teams : index => team }
    for_each = { for index, namespace in var.namespaces : index => namespace }

//    count = length(module.inputs.teams)
    # for_each = { for index, team in tolist(module.inputs.teams) : team.name => merge(team, { index = index }) }

    name = "interiut${each.key}"
    challz_folder = var.challz_folder
    wg_conf = each.value.wg.configFile
    ctfd_config = module.ctfd.ctfd_config
    external_ip = var.external_ip
    external_port = 51000 + each.key
    challenges = var.challenges
}
