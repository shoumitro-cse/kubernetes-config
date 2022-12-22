# deployments create from yaml file 
kubectl apply -f deployment/nginx-deployment.yaml
kubectl apply -f deployment/nginx-service-lb.yaml



# generate external IP
# https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-tunnel
minikube tunnel
minikube tunnel --cleanup


# service port forword
kubectl port-forward service/nginx-deployment 7080:8080
kubectl port-forward service/myservice 8001:80 --address=192.168.0.105
kubectl port-forward service/myservice 80:80 --address=192.168.0.105 # Error listen tcp4 192.168.0.105:80: bind: permission denied


