# packer使用

## 准备工作

安装packer

```bash
# macos
brew install packer

# ubuntu
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install packer

```

下载系统iso镜像文件，并将iso文件上传到pve服务器：`pve-tns:iso`中。


## packer的用途

1. 预安装软件：Packer 可以在构建过程中安装和配置额外的软件包。
2. 系统配置：可以进行系统级别的配置，如网络设置、安全策略等。
3. 用户账户：可以预先创建用户账户和设置权限。
4. 文件和目录：可以添加自定义文件和目录结构。
5. 更新和补丁：可以应用最新的系统更新和安全补丁。
6. 自定义脚本：可以运行自定义脚本来执行特定的任务或配置。
7. 清理：可以删除不必要的文件和日志，减小镜像大小。
8. 元数据：可以添加自定义元数据，如版本信息、构建日期等。

### 自定义配置：

.pkr.hcl 的配置

```ubuntu-server-2210.pkr.hcl
VM ID: 321
VM Name: ubuntu-server-2210-tmpl
ISO File: ubuntu-22.10-live-server-amd64.iso
Disk Size: 80G
CPU Cores: 2
Memory: 8196 MB
```

.user-data 的配置

```user-data
#cloud-config
autoinstall:
  version: 1
  locale: en_US, zh_CN.UTF-8
  keyboard:
    layout: us
  ssh:
    install-server: true
    allow-pw: false
    disable_root: true
    ssh_quiet_keygen: true
    allow_public_ssh_keys: true
  packages:
    - qemu-guest-agent
    - sudo
    - language-pack-zh-hans
  storage:
    layout:
      name: direct
    swap:
      size: 0
  users-data:
    package_upgrade: false
    timezone: Asia/Shanghai
    users:  
      - name: cris
        groups: [adm, sudo]
        lock-passwd: true
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ~/.ssh/id_rsa.pub
```

帮我根据上面的配置，写一个.pkr.hcl 的配置文件，和.user-data 的配置文件。结合其它需要的文件和目录格式生成新的 packer 可以使用的目录： ubuntu-server-tmpl

帮我生成完成上面任务的 cli 命令。

## 实际使用

### 修改配置文件

主要使用的配置文件在
`ubuntu-server-focal目录中`
使用时，先复制出一个，改名，在复制到目录中修改配置文件使用。一般需要修改的都以 三个 !!! 注释。

pve服务器的登录信息，修改完后不需要再动了。
`credentials.pkr.hcl`

### 修改有关用户的配置文件：

`./ubuntu-server-focal/http/user-date`

注意修改：

1. 键盘布局 us
2. ssh的是否关闭root权限
3. 时区
4. 用户名、密码、密钥等

### 修改有关模版的配置文件

`ubuntu-server-focal.pkr.hcl`

这个是主要需要修改的地方。

注意修改：

1. source名称
2. proxmox的ip、tokenid和密钥，以便连接到proxmox服务器
3. 主机node、模版id、模版名称和描述
4. 有关建立模版的iso的信息
5. 主机信息
6. packer 启动后，连接到自定义http服务器，修改配置。
7. 启动后需要运行的shell命令，如：docker的安装命令，在最后的`provisioner "shell"`中配置。

### Packer部署命令

```bash
git clone https://github.com/TuSouth/boilerplates.git

cd boilerplates/packer/proxmox/ubuntu-server-focal/

# 验证是否有问题
packer valide -var-file='../credentials.pkr.hcl' ./ubuntu-server-focal.pkr.hcl

# 构建
packer build -var-file='../credentials.pkr.hcl' ./ubuntu-server-focal.pkr.hcl
```
