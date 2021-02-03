variable "ctfd_config" {
    type = object({
        hostname = string
        port = number
        access_token = string
    })
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
    description = "A list of teams to manage"
}

locals {
    uri = var.ctfd_config.hostname == "test" ? "http://${try(var.ctfd_config.hostname, "localhost")}:${try(var.ctfd_config.port, 80)}/api/v1" : "http://localhost:80"
}
