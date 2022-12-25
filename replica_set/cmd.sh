kubectl apply -f replica_set/dev-quota.yaml
kubectl apply -f replica_set/pod-rs.yaml
kubectl apply -f replica_set/nginx-replica_set.yaml


# delete replica set
kubectl delete -f replica_set/nginx-replica_set.yaml


# for quota resource
kubectl create quota dev-quota --hard services=10,cpu=1300,memory=1.5Gi
kubectl get resourcequota
kubectl delete resourcequota dev-quota


kubectl proxy --port=8080
# replicaset => nginx-server-replica delete using api
curl -X DELETE  'localhost:8080/apis/apps/v1/namespaces/default/replicasets/nginx-server-replica' \
-d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Foreground"}' \
-H "Content-Type: application/json"



# ReplicaSet as a Horizontal Pod Autoscaler Target
kubectl apply -f replica_set/hpa-rs.yaml
kubectl get hpa
kubectl delete -f replica_set/hpa-rs.yaml

kubectl describe hpa nginx-server-replica-scaler

kubectl autoscale rs nginx-server-replica --max=10 --min=3 --cpu-percent=50
kubectl delete hpa nginx-server-replica-scaler