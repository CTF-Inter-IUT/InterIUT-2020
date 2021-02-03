variable "chall_path" {
    type = string
    description = "The challenge root folder"

    validation {
        condition = can(regex("^\\d{2}-.+$", basename(var.chall_path)))
        error_message = "The challenge folder must be in the following format: 01-challenge-name."
    }
}

variable "public_network" {
    type = string
    description = "The docker network to which traefik is connected"
}
