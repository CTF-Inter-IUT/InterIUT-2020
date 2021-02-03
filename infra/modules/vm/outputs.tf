output "vm_ip" {
    value = vsphere_virtual_machine.CTFd.guest_ip_addresses
}