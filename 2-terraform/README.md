
## Vagrant 和 Terraform 的区别

Vagrant 和 Terraform 都是 HashiCorp 公司开发的基础设施管理工具，但它们的用途和适用场景有所不同：

1. Vagrant:
   - 主要用于管理开发环境
   - 专注于**本地虚拟机**的创建和管理
   - 适用于单机或小规模的开发环境
   - 配置文件：Vagrantfile

   示例配置可以参考：

2. Terraform:
   - 用于管理和部署大规模的基础设施
   - 支持多种云平台和服务提供商
   - 适用于生产环境和复杂的基础设施部署
   - 配置文件：.tf 文件

虽然它们的目标不同，但在某些情况下可以互补使用：

1. 开发到生产的过渡：可以使用 Vagrant 管理开发环境，然后使用 Terraform 部署到生产环境。

2. 本地测试 Terraform 配置：可以使用 Vagrant 创建本地环境来测试 Terraform 配置。

3. 混合环境：在某些复杂的场景中，可能需要同时使用 Vagrant 和 Terraform 来管理不同部分的基础设施。

总的来说，Vagrant 更适合开发者在本地快速搭建和管理开发环境，而 Terraform 则更适合管理大规模、跨平台的基础设施部署。选择使用哪个工具取决于具体的需求和使用场景。

## 在 PVE 上使用 Terraform 的基本步骤

1. 安装 Terraform：

首先需要在您的本地机器上安装 Terraform。

对于 macOS:

```shell
brew install terraform
```

对于 Linux:

```shell
sudo apt-get install terraform
```

2. 安装 Proxmox Provider：
   Terraform 需要 Proxmox Provider 来与 PVE 交互。在您的 Terraform 配置目录中创建一个 `versions.tf` 文件，内容如下：

```hcl
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}
```

3. 配置 Proxmox Provider：
   创建一个 `provider.tf` 文件，配置 Proxmox Provider：

```hcl
provider "proxmox" {
  pm_api_url = "https://your-proxmox-ip:8006/api2/json"
  pm_api_token_id = "your-api-token-id"
  pm_api_token_secret = "your-api-token-secret"
  pm_tls_insecure = true
}
```

4. 创建资源配置：
   创建一个 `main.tf` 文件，定义您要创建的资源。例如，创建一个虚拟机：

```hcl
resource "proxmox_vm_qemu" "test_server" {
  count = 1
  name = "test-vm-${count.index + 1}"
  target_node = "your-proxmox-node"
  clone = "your-template-name"
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    size = "10G"
    type = "scsi"
    storage = "local-lvm"
    iothread = 1
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
```

5. 初始化 Terraform：

```shell
terraform init
```

6. 规划部署：

```shell
terraform plan
```

7. 应用配置：

```shell
terraform apply
```

8. 管理和更新：

之后，您可以通过修改 Terraform 配置文件并再次运行 `terraform apply` 来管理和更新您的基础设施。

注意：在使用 Terraform 管理 PVE 资源时，建议先使用 Packer 创建虚拟机模板，然后在 Terraform 中引用这些模板来创建虚拟机。这样可以确保虚拟机的一致性和可重复性。
