variable "proxmox_host" {
  default = "192.168.1.31"
}

variable "proxmox_user" {
  default = "cris"
}

variable "SUPER_SECRET_PASSWORD" {
  type = string
  description = "The password for the proxmox user"
  sensitive   = true
}


variable "ssh_key" {
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcF1A9VFjMc6UAHTV6oAjqoCl5T06bBWAFtxPeWvXpPGHHmGbm8uPWrBT+OshDykP0mrEri163Uc8iujVmzSxqNBQWBMSA5C6EzqyjvswQf0zy0nCOqpqt0R+gTRckHG0Q4P5wjd3aP6UGR3B1+4YtKT72Ynx9xV1cm7SHrD0DGOB2Au4459M6iF+gmUCrMHLopkfCnauzl/DL/tzTX2IaAOigMKhKzuF5kIxiRLnm9XQVxj3BmVNlfGh4/qSmRYje0pjkR5qklHU7A+VLivhDeifP0ff9RwnofsCM1RQ4Rg43AXMFp+pAB37RQLWwGZzVM/4xQUcpVq/v3jvJJRaIgQHXYmNunUiWwsfHvhRpT7tH1MgrCsy/vCFOXQFOiwcOdc4TtURGg2XcPRfXcvO71sCeTvTprPvc+Glz0UxKxTL/m1g3ssUWn7U8kk+nL96UX5yPOo4JleNGTEHxUB1OOLWeyWTJtunJK8spz6k22JYukdZvBXpod9s7IWThBFU= vivishadow@126.com"
}

variable "gateway" {
  default     = "192.168.1.231"
}

variable "hostname" {
  default     = "pvehome"
}



variable "virtual_machines" {
    default = {
        "tf-test-01" = {
            hostname = "tf-ubt-01"
            ip_address = "192.168.1.51/24"
        },
        "tf-test-02" = {
            hostname = "tf-ubt-02"
            ip_address = "192.168.1.52/24"
        },
    }
}