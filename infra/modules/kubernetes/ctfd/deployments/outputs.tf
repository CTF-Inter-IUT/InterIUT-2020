output "ctfd_config" {
    value = jsondecode(module.ctfd_setup.stdout)
    # value = ""
}
