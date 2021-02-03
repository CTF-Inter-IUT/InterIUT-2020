variable "name" {
    type = string
    description = "Name of the challenge"
}

variable "port" {
    type = number
    default = 1337
}

variable "namespace" {
    type = string
    description = "The namespace where the team is hosted"
}

variable "image_pull_secrets" {
    type = string
    description = "The secret containing docker registry credentials"
}

variable "disable_checks" {
    type = bool
    default = false
}
