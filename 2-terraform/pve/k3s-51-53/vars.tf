variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcF1A9VFjMc6UAHTV6oAjqoCl5T06bBWAFtxPeWvXpPGHHmGbm8uPWrBT+OshDykP0mrEri163Uc8iujVmzSxqNBQWBMSA5C6EzqyjvswQf0zy0nCOqpqt0R+gTRckHG0Q4P5wjd3aP6UGR3B1+4YtKT72Ynx9xV1cm7SHrD0DGOB2Au4459M6iF+gmUCrMHLopkfCnauzl/DL/tzTX2IaAOigMKhKzuF5kIxiRLnm9XQVxj3BmVNlfGh4/qSmRYje0pjkR5qklHU7A+VLivhDeifP0ff9RwnofsCM1RQ4Rg43AXMFp+pAB37RQLWwGZzVM/4xQUcpVq/v3jvJJRaIgQHXYmNunUiWwsfHvhRpT7tH1MgrCsy/vCFOXQFOiwcOdc4TtURGg2XcPRfXcvO71sCeTvTprPvc+Glz0UxKxTL/m1g3ssUWn7U8kk+nL96UX5yPOo4JleNGTEHxUB1OOLWeyWTJtunJK8spz6k22JYukdZvBXpod9s7IWThBFU= vivishadow@126.com"
}

variable "proxmox_host" {
    default = "pve"
}

variable "template_name" {
    default = "ubuntu-server-jammy"
}
