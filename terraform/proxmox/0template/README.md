### 修改文件 `main.tf`

搜索 `!!!` ，修改该注释所在位置。

先执行 plan 命令，查看运行的情况
```
terraform plan
```

再运行 apply 命令，执行。加参数 `-auto-approve` 跳过 默认的先 plan，再 apply
```
terraform apply
```
