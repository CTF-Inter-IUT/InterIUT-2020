variable "ctfd_config" {
    type = object({
        hostname = string
        port = number
        access_token = string
    })
}

variable "team" {
    type = object({
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
    })
}
