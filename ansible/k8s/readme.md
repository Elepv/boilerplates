# 新服务器操作

## 参数说明

配置参数读取顺序：当前文件夹、当前user的家目录、etc文件夹

### 命令行参数

- -i "ip,"  ：指定ip运行
- --limit ip：在仓库地址中指定ip的这一台主机
- gather_facts：收集服务器资料
- -i inventory：指定仓库为当前目录下inventory文件中的主机地址和域名的仓库
- --key-file <公钥地址>：指定使用公钥
- -k和-K：输入ssh密码和输入sudo密码
- update_cache：使用apt时先update升级
- --list-tags：列出所有的标签
- --tags tags_name：用标签过滤，多个标签用引号包含起来，逗号隔开

如果主机仓库中没有指定主机的主机名或ip，可以＋逗号来指定该主机

```bash
# Host and IP address
ansible all -i example.com,
ansible all -i 93.184.216.119,

# Requires 'hosts: all' in your playbook
ansible-playbook -i example.com, playbook.yml
```

### playbook中的参数

| 参数  | 说明  |
|---|---|
| become: true  | 获取sudo权限  |
| when:  | 条件语句  |
| when: ansible_distribution in ["Debian", "Ubuntu"]  | 系统为debian或ubuntu时  |
| 使用模块：gather_facts  | 可以收集系统所有的参数，用grep来筛选参数  |
| pre_tasks和tasks  | 预处理任务和任务  |
| tags  | 打标签，给之后的逻辑函数使用，可以使用多个标签，逗号隔开  |
| always 标签 | 该便签都会被包含 |
| copy模块中的权限mode: 0644  | 一般会用0644，即rw-r--r--；0755，即rwxr-xr-x |
| register: httpd  | 注册事件，在其他逻辑判断语句中使用该事件。如：when: httpd.changed，即该事件变化的时候  |
| handler目录  | 需要被引发的改动，即 notify: handler的名字。其他地方设置一些钩子，触发后就会调用这个统一的改动  |

## commands

ansible的命令

```bash

# 指定ssh的公钥访问当前目录下inventory中的所有服务器，进行ping
ansible all --key-file ~/.ssh/id_rsa.pub -i inventory -m ping

```

对指定主机执行playbook

```bash

ansible-playbook XXX.yml --limit ip
ansible 192.168.1.35 -a 'ls'

```

## 开启服务器ssh-server

```bash

sudo apt update
sudo apt install openssh-server

# 查看ssh是否打开
sudo systemctl status ssh

# 如果有防火墙
sudo ufw allow ssh

# 如果服务没打开
sudo systemctl enable --now ssh    # ubuntu
service ssh restart    # debian

# 打开ssh，root登陆权限
sudo vi /etc/ssh/sshd_config

# 修改一下内容
# 注释：     #PermitRootLogin prohibit-password
# 加一行：    PermitRootLogin yes


# 重启ssh服务
sudo systemctl ssh restart
/etc/init.d/networking restart    # debian重启网络

### debian 配置静态ip
vi /etc/network/interfaces

# 修改配置如下
auto enp0s3
iface enp0s3 inet static
address 192.168.1.43
netmask 255.255.255.0
gateway 192.168.1.231
#dns-nameservers 8.8.8.8 192.168.2.1  可以在  /etc/resolv.conf 里修改


```

## 开启root用户

```

sudo passwd root

```
