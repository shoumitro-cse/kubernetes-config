kubectl apply -f StatefulSets/nginx-statefulsets.yaml
kubectl get statefulset
kubectl get svc

kubectl describe statefulset.apps/web
kubectl describe sts web


# for volume Persistent Volume Claim
kubectl get pvc
kubectl delete pvc pvc-name
kubectl delete pvc www-web-0
kubectl describe pvc pvc-name

# delete volume
kubectl delete pvc www-web-0  www-web-1 www-web-2

# for Persistent Volume
kubectl get pv
kubectl describe pv pv-name
kubectl describe pv pv-name example-pv test-volume

# to list all api resource
kubectl api-resources

# show all storage class
kubectl get sc


echo -n "username" | base64