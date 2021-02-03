variable "external_ip" {
    type = string
}

variable "flag_format" {
    type = string
}

variable "teams" {
    type = list(object({
        name = string
        members = list(object({
            name = string
            email = string
            password = string
            wg = object({
                private = string
                public = string
                internalIp = number
                configFile = string
            })
        }))
    }))
    description = "List of teams to create"
}

variable "challz_categories" {
    type = map(any)
}

variable "challz_folder" {
    type = string
}

variable "secret_key" {
    type = string
    description = "K8s secret which contains the CTFD secret key"
}

variable "image_pull_secret" {
    type = string
    description = "Kubernetes secret required for registry authentication"
}

locals {
    root_path = dirname(var.challz_folder)
    challz = flatten([
        for category, challz in var.challz_categories : [
            for id, chall in challz : {
                id = id
                name = chall.name
            }
        ]
    ])
    flat_challz = { for chall in local.challz : chall.id => chall.name }
}
