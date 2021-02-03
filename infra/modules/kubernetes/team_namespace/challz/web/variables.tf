variable "name" {
    type = string
    description = "Name of the challenge"
}

variable "challz_folder" {
    type = string
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
    type = bool
    description = "If the challenge needs a mysql server."
    default = false
}

variable "mysql_user" {
    type = string
    default = "challenge"
}

variable "mysql_password" {
    type = string
    default = ""
}

variable "mysql_database" {
    type = string
    default = ""
}

variable "mysql_init_script" {
    type = string
    default = ""
    description = "An SQL script to execute after the creation of the container"
}

variable "require_mongo" {
    type = bool
    description = "If the challenge needs a MongoDb server."
    default = false
}

variable "mongo_user" {
    type = string
    default = "challenge"
}

variable "mongo_password" {
    type = string
    default = ""
}
