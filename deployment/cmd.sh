# create deployment
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0

# port expose deployment and create hello-minikube service
kubectl expose deployment hello-minikube --type=NodePort --port=8080

# delete hello-minikube service
kubectl delete service hello-minikube

# run deployment
minikube service hello-minikube

# port forword to localhost
kubectl port-forward service/hello-minikube 7080:8080

# enter container
kubectl exec -it  pod_name -c container_name -- bash
kubectl exec -it  nginx-deployment-8c64f777-f49z4 -c mynginx -- bash

kubectl exec -it pod_name -- bash
kubectl exec -it nginx-deployment-8c64f777-6h76x -- bash

# delete deployment
kubectl delete -n default deployment hello-minikube

# replica increase 4 to 8. (old value replicas=4)
kubectl scale deployment/nginx-deployment --replicas=8

# show namespace
minikube service list
minikube service nginx-deployment -n <namespace>

# Then, shut down the minikube
minikube stop


******************** using yaml *********************************
# deployments create from yaml file 
kubectl apply -f deployment/nginx-deployment.yaml
kubectl apply -f deployment/nginx-service-lb.yaml


# get deployment list
kubectl get deployments
kubectl get nginx-deployment

# get replica list
kubectl get rs
kubectl describe rs nginx-deployment-7fb96c846b

# get pod list
kubectl get pods
kubectl get pods --show-labels
kubectl describe pods nginx-deployment-7fb96c846b-kwnxs

# get cluster service list
kubectl get service
minikube service list

# expose port and create service
kubectl expose deployment nginx-deployment --type=NodePort --port=8080

# syntaxt for service create(load balancing)
kubectl expose deployment example --port=8765 --target-port=9376 --name=example-service --type=LoadBalancer
kubectl expose deployment nginx-deployment --port=80 --target-port=80 --type=LoadBalancer

# service edit
kubectl -n default edit svc myservice

# generate external IP
# https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-tunnel
minikube tunnel
minikube tunnel --cleanup

# get service list
kubectl get service
kubectl get service -l app=nginx
minikube service -n default list

# dectails view a service
kubectl describe endpoints  nginx-deployment
kubectl describe services nginx-deployment
minikube service nginx-deployment --url

# service port forword
kubectl port-forward service/nginx-deployment 7080:8080
kubectl port-forward service/myservice 8001:80 --address=192.168.0.105
kubectl port-forward service/myservice 80:80 --address=192.168.0.105 # Error listen tcp4 192.168.0.105:80: bind: permission denied


# To delete the services, ReplicaSet 
kubectl delete service nginx-deployment
kubectl delete rs kubernetes-node-server-replicaset

# all pod name
pods=$(kubectl get pods --selector=app=nginx --output=jsonpath={.items..metadata.name})
echo $pods

# replica increase or decrease
kubectl scale deployment/nginx-deployment --replicas=1
kubectl scale deployment/nginx-deployment --replicas=3
kubectl get pods --show-labels


# api server
kubectl proxy --port=8002
http://127.0.0.1:8002/


# api resoure info (like kind of a ymal file)
kubectl api-resources
NAME                              SHORTNAMES   APIVERSION                             NAMESPACED   KIND
nodes                             no           v1                                     false        Node
pods                              po           v1                                     true         Pod
services                          svc          v1                                     true         Service
deployments                       deploy       apps/v1                                true         Deployment
replicasets                       rs           apps/v1                                true         ReplicaSet


# api version list
kubectl api-versions

# kubeconfig contains multiple cluster
kubectl config --help

kubectl config get-contexts
kubectl config current-context
kubectl config get-clusters  
kubectl config view

Available Commands:
  current-context   Display the current-context
  delete-cluster    Delete the specified cluster from the kubeconfig
  delete-context    Delete the specified context from the kubeconfig
  delete-user       Delete the specified user from the kubeconfig
  get-clusters      Display clusters defined in the kubeconfig
  get-contexts      Describe one or many contexts
  get-users         Display users defined in the kubeconfig
  rename-context    Rename a context from the kubeconfig file
  set               Set an individual value in a kubeconfig file
  set-cluster       Set a cluster entry in kubeconfig
  set-context       Set a context entry in kubeconfig
  set-credentials   Set a user entry in kubeconfig
  unset             Unset an individual value in a kubeconfig file
  use-context       Set the current-context in a kubeconfig file
  view              Display merged kubeconfig settings or a specified kubeconfig file


# logs pod, rs, deployments
kubectl logs pod/nginx-deployment-8c64f777-4x9gf
kubectl logs -f pod/nginx-deployment-8c64f777-997pc # live logs

kubectl logs rs/nginx-deployment-8c64f777
kubectl logs -f rs/nginx-deployment-8c64f777

kubectl logs  deploy/nginx-deployment
kubectl logs -f  deploy/nginx-deployment
