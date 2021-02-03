module "team" {
    source = "./team"
    for_each = { for team in var.teams : team.name => team }

    ctfd_config = var.ctfd_config
    team = each.value
}