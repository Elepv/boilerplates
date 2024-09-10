# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {

  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true  
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  
  # (Optional) Skip TLS Verification
  pm_tls_insecure = true

  # 其他配置...
  pm_debug = true
  pm_log_enable = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
  pm_log_file   = "/tmp/terraform-plugin-proxmox.log"
}
