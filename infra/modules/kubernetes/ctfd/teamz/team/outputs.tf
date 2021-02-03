output "team_config" {
    value = {
        id = try(local.team_output.id, null)
        name = try(local.team_output.name, null)
        members = local.members
    }
}


