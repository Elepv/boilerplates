## packer使用



### 准备工作

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
