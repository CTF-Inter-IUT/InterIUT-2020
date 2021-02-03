variable "name" {
    type = string
    description = "Name of the challenge"
}

variable "namespace" {
    type = string
    description = "The namespace where the team is hosted"
}

variable "image_pull_secrets" {
    type = string
    description = "The secret containing docker registry credentials"
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

variable "mysql_init_script" {
    type = string
    default = ""
    description = "An SQL script to execute after the creation of the container"
}
