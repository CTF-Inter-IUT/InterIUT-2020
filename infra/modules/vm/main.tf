provider "vsphere" {
    user = var.vsphere_user
    password = var.vsphere_password
    vsphere_server = var.vsphere_server
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
    name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
    name = var.vsphere_datastore
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
    name = var.vsphere_resource_pool
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
    name = var.vsphere_host
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
    name = var.vsphere_network
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
    name = "Alpine-interiut"
    datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "CTFd" {
    name = "Test"
    
    host_system_id = data.vsphere_host.host.id
    resource_pool_id = data.vsphere_resource_pool.pool.id
    datastore_id = data.vsphere_datastore.datastore.id
    
    num_cpus = 2
    memory = 2048
    guest_id = "other3xLinux64Guest"
    
    network_interface {
        network_id = data.vsphere_network.network.id
        adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
    disk {
        label = "disk0"
        size = data.vsphere_virtual_machine.template.disks.0.size
        eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
        thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    }

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id

    }
//    wait_for_guest_ip_timeout = 0
    wait_for_guest_net_routable = false
//    wait_for_guest_net_timeout = -1

    connection {
        type = "ssh"
        host = vsphere_virtual_machine.CTFd.guest_ip_addresses[0]
        user = "root"
        password = "interiut"
    }

    provisioner "remote-exec" {
        inline = ["mkdir /root/.ssh"]
    }

    provisioner "file" {
        source = var.vm_pubkey
        destination = "/root/.ssh/authorized_keys"
    }

    provisioner "remote-exec" {
        inline = [
            "echo -e 'ChallengeResponseAuthentication no\nPasswordAuthentication no' >> /etc/ssh/sshd_config",
            "service sshd restart"
        ]
    }
}

# resource "vsphere_virtual_machine" "Challenges" {
#     name = "Challenges"
#     resource_pool_id = data.vsphere_resource_pool.pool.id
#     datastore_id = data.vsphere_datastore.datastore.id
#     num_cpus = 4
#     memory = 2048
#     guest_id = "other3xLinux64Guest"
#     network_interface {
#         network_id = data.vsphere_network.network.id
#     }
#     disk {
#         label = "disk0"
#         size = data.vsphere_virtual_machine.template.disks.0.size
#         eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
#         thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
#     }
#     clone {
#         template_uuid = data.vsphere_virtual_machine.template.id
#         customize {
#             linux_options {
#                 domain = "interiut.ctf"
#                 host_name = "challz"
#             }

#             network_interface {}
#         }
#     }
# }
