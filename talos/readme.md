# Setup Commands

```bash
helm upgrade --install cilium cilium/cilium \
--namespace=kube-system --version 1.16.6 -f ../kubernetes/core/kube-system/cilium/values.yaml

helm upgrade --install coredns coredns/coredns --namespace=kube-system --version 1.39.0
```
