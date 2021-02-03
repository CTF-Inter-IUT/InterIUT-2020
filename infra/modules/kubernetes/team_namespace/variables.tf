variable "ctfd_config" {
    type = object({
        access_token = string
        hostname = string
        port = number
    })
    description = "The admin access_token to use to create teams"
}

variable "wg_conf" {
    type = string
}

variable "name" {
    type = string
    description = "Team's name"
}

variable "external_ip" {
    type = string
}

variable "external_port" {
    type = number
}

variable "challenges" {
    type = map(map(map(string)))
    description = "List of challenges to deploy"
}

variable "challz_folder" {
    type = string
}