variable "external_ip" {
    type = string
    description = "The dedicated ip you created on the manager"
}

variable "ctfd_ip" {
    type = string
}

locals {
    namespaces = jsondecode(file("${path.module}/output_namespaces.json"))
}
