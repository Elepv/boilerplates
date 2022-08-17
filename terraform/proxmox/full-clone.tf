# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "tf-ubt-test" {
    
    # VM General Settings
    name = "tf-ubt-test"
    vmid = "403"
    desc = "test terraform to automate ubuntu server"
    target_node = "pve"

    # VM Advanced General Settings
    onboot = true

    # VM OS Settings
    clone = "ubuntu-server-focal"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 2
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 4096

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Disk Settings
    disk {
      storage = "sn750wd2t"
      type = "virtio"
      size = "60G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=10.0.9.253/24,gw=10.0.9.21"
    nameserver = "10.0.9.28"
    
    # (Optional) Default User
    ciuser = "cris"
    
    # (Optional) Add your SSH KEY
    # sshkeys = <<EOF
    # #YOUR-PUBLIC-SSH-KEY
    # EOF
}
