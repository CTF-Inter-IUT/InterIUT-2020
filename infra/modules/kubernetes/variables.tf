variable "external_ip" {
    type = string
}

variable "ctfd_ip" {
    type = string
}

variable "namespaces" {
    type = list(object({
        wg = object({
            private = string
            public = string
            port = number
            configFile = string
        })
        teams = list(object({
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
    }))
}

variable "challenges" {
    type = any
}

variable "challz_folder" {
    type = string
}


# variable "wireguard_configs" {
#     type = list(object({
#         private_key = string
#         public_key = string
#         config_content = string
#         external_port = number

#         # teams = map(object({
#         #     name = string
#         #     members = map(object({
#         #         private_key = string
#         #         public_key = string
#         #         config_content = string
#         #     }))
#         # }))
#     }))
# }