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
