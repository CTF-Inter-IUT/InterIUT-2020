variable "ctfd_config" {
    type = object({
        access_token = string
        hostname = string
        port = number
    })
    description = "The admin access_token to use to create teams"
}

variable "wg_conf" {
    type = string
}

variable "name" {
    type = string
    description = "Team's name"
}

variable "index" {
    type = number
}

variable "external_ip" {
    type = string
}

variable "challenges" {
    type = map(map(map(string)))
    description = "List of challenges to deploy"
}

locals {
    id = terraform.workspace
    namespace_name = "team-${replace(lower(var.name), "/[^0-9a-z]/", "_")}"
}