# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "lab91" {
    
    # VM General Settings
    name = "lab91"
    vmid = "191"
    desc = "lab91 in Ubuntu 20.04.5 LTS"
    target_node = var.proxmox_host
 
    # VM Advanced General Settings
    onboot = true

    # VM OS Settings
    clone = var.template_name

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 8
    sockets = 2
    cpu = "host"    
    
    # VM Memory Settings
    memory = 8192

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Disk Settings
    disk {
      storage = "sn750wd2t"
      type = "virtio"
      size = "256G"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=10.0.9.91/24,gw=10.0.9.21"
    nameserver = "10.0.9.28"
    
    # (Optional) Default User
    ciuser = "cris"
    cipassword = "03220123"
    
    # (Optional) Add your SSH KEY
    sshkeys = <<EOF
    ${var.ssh_key}
    EOF
}
