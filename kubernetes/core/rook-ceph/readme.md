# Install Rook-Ceph

```bash
# Operator Install
helm install rook-ceph \
--create-namespace --namespace rook-ceph \
rook-release/rook-ceph \
-f ../kubernetes/core/rook-ceph/operator.yaml

# Install the Cluster
helm install rook-ceph-cluster \
--namespace rook-ceph \
rook-release/rook-ceph-cluster \
-f ../kubernetes/core/rook-ceph/cluster.yaml
```
