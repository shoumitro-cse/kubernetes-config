kubectl apply -f replica_set/dev-quota.yaml
kubectl apply -f replica_set/pod-rs.yaml
kubectl apply -f replica_set/nginx-replica_set.yaml


# for quota resource
kubectl create quota dev-quota --hard services=10,cpu=1300,memory=1.5Gi
kubectl get resourcequota
kubectl delete resourcequota dev-quota
