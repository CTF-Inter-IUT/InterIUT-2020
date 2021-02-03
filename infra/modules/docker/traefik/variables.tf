variable "public_network" {
    type = string
    description = "The docker network where traefik can reach webservices"
}

variable "tcp_challenges" {
    type = map(object({
        path = string
        port = number
    }))
    description = "List of challenges which needs a dedicated entrypoint"
}
