## 流程

### 复制模版

```
cp -r 0template project-name
```

### 如果不是第一次为pve平台使用。只需要完成该步骤即可。

```
terraform init

```
修改 `main.tf` 文件

搜索 `!!!` ，修改该注释所在位置。

先执行 plan 命令，查看运行的情况
```
terraform plan
```

再运行 apply 命令，执行。加参数 `-auto-approve` 跳过 默认的先 plan，再 apply
```
terraform apply
```


### 安装插件

如果没有安装 proxmox 的插件，需要首先安装插件。

To install this provider, copy and paste this code into your Terraform configuration (include a version tag).
```
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "<version tag>"
    }
  }
}

provider "proxmox" {
  # Configuration options
}
```

Then, run
```
terraform init
```


### 修改文件

1. `var.tf` 参数文件

```
# ssh-key 文件，登陆的时候，使用登陆主机的ssh来登陆。
# 所以需要将本机的ssh的公钥作为参数最后传递给新建的服务器中。
variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcF1A9VFjMc6UAHTV6oAjqoCl5T06bBWAFtxPeWvXpPGHHmGbm8uPWrBT+OshDykP0mrEri163Uc8iujVmzSxqNBQWBMSA5C6EzqyjvswQf0zy0nCOqpqt0R+gTRckHG0Q4P5wjd3aP6UGR3B1+4YtKT72Ynx9xV1cm7SHrD0DGOB2Au4459M6iF+gmUCrMHLopkfCnauzl/DL/tzTX2IaAOigMKhKzuF5kIxiRLnm9XQVxj3BmVNlfGh4/qSmRYje0pjkR5qklHU7A+VLivhDeifP0ff9RwnofsCM1RQ4Rg43AXMFp+pAB37RQLWwGZzVM/4xQUcpVq/v3jvJJRaIgQHXYmNunUiWwsfHvhRpT7tH1MgrCsy/vCFOXQFOiwcOdc4TtURGg2XcPRfXcvO71sCeTvTprPvc+Glz0UxKxTL/m1g3ssUWn7U8kk+nL96UX5yPOo4JleNGTEHxUB1OOLWeyWTJtunJK8spz6k22JYukdZvBXpod9s7IWThBFU= vivishadow@126.com"
}

# proxmox服务器的主机名
variable "proxmox_host" {
    default = "pve"
}

# pve中使用 packer 建立的服务器模版，该模版的名字。
variable "template_name" {
    default = "ubuntu-server-focal-docker-tmpl"
}
```

2. `credentails.auto.tfvars` 文件的参数

```
proxmox_api_url = "https://10.0.9.10:8006/api2/json"  # Your Proxmox IP Address
proxmox_api_token_id = "root@pam!terraform"  # API Token ID
proxmox_api_token_secret = "e5f721f2-6927-4279-be37-b23b847de9e7"  # pve 的 proxmox_api_token_secret
```

3. `provider.tf` 文件：是提供插件的文件


```
# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {

  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.3"
    }
  }
}

# 将定义在 credentails.auto.tfvars 中的服务器token 引用到proxmox的插件中。
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
  # pm_tls_insecure = true

}
```
