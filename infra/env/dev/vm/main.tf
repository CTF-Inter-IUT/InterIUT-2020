module "vm" {
    source = "../../../modules/vm"

    vsphere_server = ""
    
    vsphere_user = ""
    vsphere_password = ""
    
    vsphere_datacenter = "Datacenter"

    vsphere_datastore = "datastore1"

    vsphere_resource_pool = ""

    vsphere_host = ""

    vsphere_network = "interiut-network"

    vm_pubkey = ""
    vm_privkey = ""
}
