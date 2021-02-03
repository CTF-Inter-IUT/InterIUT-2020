variable "resource_name" {
    default = "interiut-resource"
}
variable "cluster_name" {
    default = "interiut"
}
variable "location" {
    default = "westeurope"
}
variable "dns_prefix" {
    default = "kubecluster"
}
variable "size" {
    default = "Standard_D2_v2"
}
variable "node_count" {
    type = number
    default = 1
}
variable "subscription_id" {
    type = string
}
variable "client_id" {
    type = string
}
variable "client_secret" {
    type = string
}
variable "tenant_id" {
    type = string
}