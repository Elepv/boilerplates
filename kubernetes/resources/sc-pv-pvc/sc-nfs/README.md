
## 添加 helm 源
```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner

helm repo update

```

## 安装方式

首先创建命名空间
```
kubectl create ns nfs-sc-default
```

使用命令行 cli 安装
```
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set storageClass.name=nfs-sc-default\	#指定sc的名字
    --set nfs.server=10.0.9.11 \					#指定nfs地址
    --set nfs.path=/mnt/tnvhwd/kdata/nfs-sc-default \					#指定nfs的共享目录
    --set storageClass.defaultClass=true \	#指定为默认sc
    -n nfs-sc-default
```

使用 nfs-sc-values.yaml 参数文件安装
```
helm install nfs-subdir-external-provisioner \
    nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    -f nfs-sc-values.yaml \
    -n nfs-sc-default
```

安装多个 sc

It is possible to install more than one provisioner in your cluster to have access to multiple nfs servers and/or multiple exports from a single nfs server. Each provisioner must have a different storageClass.provisionerName and a different storageClass.name. For example:

```
helm install second-nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=y.y.y.y \
    --set nfs.path=/other/exported/path \
    --set storageClass.name=second-nfs-client \
    --set storageClass.provisionerName=k8s-sigs.io/second-nfs-subdir-external-provisioner
```

删除 helm 的安装
```
# del chart
helm delete nfs-subdir-external-provisioner

```

查看创建的 sc
```
kubectl get sc
```

## 测试

1. 创建 pvc 测试：

`test-pvc.yaml`

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-pvc
#  storageClassName: nfs-sc-default #指定sc名字，如果之前设定nfs-sc-default为默认sc可不用写这行指定
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
```

应用该 pvc

```
kubectl apply -f test-pvc.yaml -n test

kubectl get pvc -n test

```

创建 `test-pod.yaml`

```
kind: Pod
apiVersion: v1
metadata:
  name: test-pod
spec:
  containers:
  - name: test-pod
    image: busybox:latest
    command:
      - "/bin/sh"
    args:
      - "-c"
      - "touch /mnt/SUCCESS && exit 0 || exit 1"  
    volumeMounts:
      - name: nfs-pvc
        mountPath: "/mnt"
  restartPolicy: "Never"
  volumes:
    - name: nfs-pvc
      persistentVolumeClaim:
        claimName: test-pvc
```

应用测试 pod

```
kubectl apply -f test-pod.yaml -n test

kubectl get pod -n test
```

查看 nfs 目录里创建的文件

可以看见SUCCESS文件创建成功，并且可以看出命名目录的规则为namespace名称-pvc名称-pv名称，PV名称是随机字符串，所以 每次只要不删除PVC，那么Kubernetes中的与存储绑定将不会丢失，要是删除PVC也就意味着删除了绑定的文件夹，下次就算重新创建相同名称的PVC，生成的文件夹名称也不会一致，因为PV 名是随机生成的字符串，而文件夹命名又跟PV 有关,所以删除PVC需谨慎。

删除相关测试的资源：
```
kubectl delete -f test-pod.yaml  -n test
kubectl delete -f test-pvc.yaml  -n test

```
