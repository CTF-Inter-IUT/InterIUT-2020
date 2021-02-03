terraform {
    backend "pg" {
        conn_str = "postgres://postgres@wireguard.interiut.ctf/terraform_backend?sslmode=disable"
    }
}

# module "vm" {
#     source = "./vm"
# }

module "ctfd" {
    source = "./ctfd"
}

module "challenges" {
    source = "./challz"
}
