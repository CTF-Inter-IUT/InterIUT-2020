variable "chall_path" {
    type = string
    description = "The challenge root folder"

    validation {
        condition = can(regex("^\\d{2}-.+$", basename(var.chall_path)))
        error_message = "The challenge folder must be in the following format: 01-challenge-name."
    }
}

variable "require_mysql" {
    type = number
    description = "If the challenge needs a mysql server."
    default = 0

    validation {
        condition = contains([1, 0], var.require_mysql)
        error_message = "The require_mysql variable must be 1 or 0."
    }
}

variable "public_network" {
    type = string
    description = "The docker network to which traefik is connected"
}

variable "mysql_init_script" {
    type = string
    default = ""
    description = "An SQL script to execute after the creation of the container"
}
