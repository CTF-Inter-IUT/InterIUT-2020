module "ctfd_setup_team" {
    source = "matti/resource/shell"

    command = <<EOF
        curl -X POST \
            -H 'Content-Type: application/json' \
            -H 'Authorization: Token ${var.ctfd_config.access_token}' \
            --data '${jsonencode({
                name = var.team.name
            })}' \
            ${var.ctfd_config.hostname}:${var.ctfd_config.port}/api/v1/teams
    EOF
}

module "ctfd_setup_member" {
    source = "matti/resource/shell"
    for_each = { for member in var.team.members : member.name => member }

    command = <<EOF
        curl -X POST \
            -H 'Content-Type: application/json' \
            -H 'Authorization: Token ${var.ctfd_config.access_token}' \
            --data '${jsonencode({
                name = each.value.name
                email = each.value.email
                password = each.value.password
            })}' \
            ${var.ctfd_config.hostname}:${var.ctfd_config.port}/api/v1/users
    EOF
}

locals {
    team_output = try(jsondecode(module.ctfd_setup_team.stdout).data, null)

    members = [
        for member in [ for output in values(module.ctfd_setup_member)[*]["stdout"] : try(jsondecode(output).data, null) ] : try({
            id = member.id
            name = member.name
            email = member.email
        }, {})
    ]
}

resource "null_resource" "link_user" {
    # for_each = { for member in var.team.members : member.name => member }
    count = length(var.team.members)

    provisioner "local-exec" {
        command = <<EOF
            curl -X POST \
                -H 'Content-Type: application/json' \
                -H 'Authorization: Token ${var.ctfd_config.access_token}' \
                --data '${jsonencode({
                    user_id = local.members[count.index].id
                })}' \
                ${var.ctfd_config.hostname}:${var.ctfd_config.port}/api/v1/teams/${local.team_output.id}/members
        EOF
    }    
}



# module "ctfd_setup_link_member" {
#     source = "matti/resource/shell"
#     for_each = { for member in local.members : member.name => member }

#     command = <<EOF
#         curl -X POST \
#             -H 'Content-Type: application/json' \
#             -H 'Authorization: Token ${var.ctfd_config.access_token}' \
#             --data '${jsonencode({
#                 userId = each.value.id
#             })}' \
#             ${var.ctfd_config.hostname}:${var.ctfd_config.port}/api/v1/teams/${local.team_output.id}/members
#     EOF
# }
