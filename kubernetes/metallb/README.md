## 快速开始

安装metalLB

```bash
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb

# 如果有参数 value.yaml
helm install metallb metallb/metallb -f values.yaml
```

应用配置文件，ip池

```bash
kubectl apply -f metallb-config.yaml

```

## 详细介绍 

### 分配地址库

MetalLB 要为 Service 分配 IP 地址，但 IP 地址不是凭空来的，而是需要预先提供一个地址库。

这里我们使用 *Layer 2* 模式，通过 *Configmap* 为其提供一个 IP 段：

配置 `metallb-ip-pool.yaml`

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  # - 192.168.10.0/24
  - 10.0.9.151-10.0.9.159
  # - fc00:f853:0ccd:e799::/124
     
```

Layer2 configuration

```yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
```

应用 `kubectl apply -f metallb-ip-pool.yaml`

案例：
