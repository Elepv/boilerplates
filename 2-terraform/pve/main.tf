terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.proxmox_host}:8006/api2/json"
  pm_user = "root@pam"
  pm_password = var.SUPER_SECRET_PASSWORD
  pm_tls_insecure = "true"

  # Uncomment the below for debugging.
    # pm_log_enable = true
    # pm_log_file = "terraform-plugin-proxmox.log"
    # pm_debug = true
    # pm_log_levels = {
    # _default = "debug"
    # _capturelog = ""
    # }
}

resource "proxmox_vm_qemu" "test_server" {
  # for_each = var.virtual_machines

  # name = each.value.hostname
  name = "tf-ubt-a-01"
  desc = "Ubuntu develop environment"

  # node name
  target_node = "pvehome"

  # cloud-init template
  clone = "ubuntu-2004-cloudinit-template"

  # Activate QEMU Guest Agent for this VM.
  agent = 1
  # os_type = "ubuntu"
  os_type = "cloud-init"
  # onboot = true

  # CPU
  cores = 4
  sockets = 1
  cpu = "host"

  # memory
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  # storage
  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "local-lvm"
    iothread = 1
  }

  # network
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # IP CIDR
  # ipconfig0 = "ip=${each.value.ip_address}/24,gw=${var.gateway}"
  ipconfig0 = "ip=10.0.9.55/24,gw=${var.gateway}"

  # SSH key
  # ciuser = var.proxmox_user
  ciuser = "ubuntu"
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

# output "vm_ipv4_addresses" {
#   value       = {
#     for instance in proxmox_vm_qemu.proxmox_ubuntu:
#     instance.name => instance.default_ipv4_address
#   }
# }
