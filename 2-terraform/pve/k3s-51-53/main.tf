# Proxmox Full-Clone
# ---
# Create a new VM from a clone

# resource is formatted to be "[type]" "[entity_name]" so in this case
# we are looking to create a proxmox_vm_qemu entity named test_server
# !!! rancher-k8s can edit !!!
# resource "proxmox_vm_qemu" "control-plane" and "worker"
resource "proxmox_vm_qemu" "control-plane" {

  # !!! 需要改动 !!!
  # just want 1 for now, set to 0 and apply to destroy VM
  count = 3

  # !!! 需要改动 ！！！
  # vm-id
  vmid = "23${count.index + 1}"
 
  # !!! 需要改动 ！！！
  #count.index starts at 0, so + 1 means this VM will be named test-vm-1 in proxmox
  name = "k3s-control-3${count.index + 1}" 
  tags = "control"

  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url. target_node is which node hosts the template and thus also which node will host the new VM. it can be different than the host you use to communicate with the API. the variable contains the contents "prox-1u"
  target_node = var.proxmox_host

  # another variable with contents "ubuntu-2004-cloudinit-template"
  clone = var.template_name

  # basic VM settings here. agent refers to guest agent
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  # scsihw = "virtio-scsi-single"
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size = "20G"
    type = "scsi"
    storage = "nvme-lvm"
    # iothread = 1
  }
  
  # if you want two NICs, just copy this whole network section and duplicate it
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
  
  # !!! 需要改动 ！！！
  # the ${count.index + 1} thing appends text to the end of the ip address
  # in this case, since we are only adding a single VM, the IP will
  # be 10.0.9.51 since count.index starts at 0. this is how you can create
  # multiple VMs and have an IP assigned to each (.51, .52, .53, etc.)

  ipconfig0 = "ip=10.0.9.3${count.index + 1}/24,gw=10.0.9.24"
  
  # (Optional) Default User
  # ciuser = "cris"
  # cipassword = "03220123"

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = file("${var.ssh_public_key_path}")

  # connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file("${var.ssh_private_key_path}")
  #     host        = self.default_ipv4_address
  # }

  # provisioner "file" {
  #     destination = "/tmp/bootstrap_k3s.sh"
  #     content = templatefile("bootstrap_k3s.sh.tpl",
  #         {
  #             k3s_token = var.k3s_token,
  #             k3s_cluster_join_ip = proxmox_vm_qemu.control-plane[0].default_ipv4_address
  #         }
  #     )
  # }

  # provisioner "remote-exec" {
  #     inline = [
  #         "set -e",
  #         "chmod +x /tmp/bootstrap_k3s.sh",
  #         "sudo /tmp/bootstrap_k3s.sh"
  #     ]
  # }
}

resource "proxmox_vm_qemu" "worker" {
    # agent (worker) nodes
    count   = 2
    
    # !!! 需要改动 ！！！
    # vm-id
    vmid = "24${count.index + 1}"
  
    name    = "k3s-worker-4${count.index}"
    tags    = "worker"

    depends_on = [
      proxmox_vm_qemu.control-plane[0]
    ]

    target_node = var.proxmox_host

    clone = var.template_name

    agent    = 1
    os_type  = "cloud-init"
    cores    = 2
    sockets  = 1
    cpu      = "host"
    memory   = 4096
    scsihw   = "virtio-scsi-pci"
    bootdisk = "scsi0"

    disk {
        slot     = 0
        size     = "40G"
        type     = "scsi"
        storage  = "nvme-lvm"
        # iothread = 1
    }

    network {
        model  = "virtio"
        bridge = "vmbr0"
    }

    lifecycle {
        ignore_changes = [
            network,
        ]
    }
    
    ipconfig0 = "ip=10.0.9.4${count.index + 1}/24,gw=10.0.9.24"

    # nameserver = "${var.proxmox_dns}"

    sshkeys = file("${var.ssh_public_key_path}")

    # connection {
    #     type        = "ssh"
    #     user        = "cris"
    #     private_key = file("${var.ssh_private_key_path}")
    #     host        = self.default_ipv4_address
    # }

    # provisioner "file" {
    #     destination = "/tmp/bootstrap_k3s.sh"
    #     content = templatefile("bootstrap_k3s.sh.tpl",
    #         {
    #             k3s_token = var.k3s_token,
    #             k3s_cluster_join_ip = proxmox_vm_qemu.control-plane[0].default_ipv4_address
    #         }
    #     )
    # }

    # provisioner "remote-exec" {
    #     inline = [
    #         "set -e",
    #         "chmod +x /tmp/bootstrap_k3s.sh",
    #         "sudo /tmp/bootstrap_k3s.sh"
    #     ]
    # }
}