variable "ssh_public_key_path" {
    default = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
    default   = "~/.ssh/id_rsa"
    sensitive = true
}

variable "proxmox_host" {
    default = "pve"
}

variable "template_name" {
    default = "ubuntu-server-jammy"
}
