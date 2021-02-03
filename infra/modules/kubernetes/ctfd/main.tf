module "deployments" {
    source = "./deployments"

    secret_key = var.secret_key
    external_ip = var.external_ip
    image_pull_secret = var.image_pull_secret
}

resource "local_file" "configure_ctfcli" {
    filename = "${local.root_path}/.ctf/config"

    content = templatefile("${path.module}/ctfcli_config.tpl", {
        url = "http://${module.deployments.ctfd_config.hostname}:${module.deployments.ctfd_config.port}"
        access_token = module.deployments.ctfd_config.access_token
        challz = local.flat_challz
        challz_folder = var.challz_folder
    })

    provisioner "local-exec" {
        when = destroy
        command = "rm -rf ${dirname(self.filename)}"
    }
}

# module "teamz" {
#     depends_on = [ module.deployments ]
#     source = "./teamz"

#     ctfd_config = module.deployments.ctfd_config
#     teams = var.teams
# }

# module "teams" {
#     source = "./team"
#     providers = {
#       a = apirest.custom
#     }
#     for_each = var.teams

#     name = each.value.name
#     members = each.value.members
# }

# resource "restapi_object" "api_team" {
#     provider = apirest
#     for_each = { for team in var.teams : team.name => team }

#     path = "/teams"
#     data = jsonencode({
#         name = each.value.name
#     })
#     id_attribute = "data/id"
# }

# locals {
#     flat_members = flatten([ for team in var.teams : team.members])
# }
# resource "restapi_object" "api_member" {
#     provider = apirest
#     for_each = { for member in local.flat_members : member.name => member }

#     path = "/users"
#     data = jsonencode(merge(each.value, {
#         password = "123"
#     }))
#     id_attribute = "data/id"
# }

# module "challenges" {
#     depends_on = [
#         local_file.configure_ctfcli
#         # null_resource.generate_challenge_yml
#     ]

#     # for_each = toset(local.challz)
#     for_each = local.flat_challz

#     source = "./challenge"
#     chall_path = "${var.challz_folder}/${each.value}"
# }
