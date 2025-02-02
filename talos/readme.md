# Setup Commands

```bash
helm upgrade --install cilium cilium/cilium \
--namespace=kube-system --version 1.16.5 \
-f ../kubernetes/core/kube-system/cilium/values.yaml

helm upgrade --install coredns coredns/coredns \
--namespace=kube-system
```
