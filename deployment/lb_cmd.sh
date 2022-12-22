# load balancing (youtube)
https://www.youtube.com/watch?v=xCsz9IOt-fs&t=235s
https://www.youtube.com/watch?v=zCW1TewkoOk


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


# Enter pod container
kubectl exec -it pod_name -- bash
kubectl exec -it nginx-deployment-8c64f777-6h76x -- bash
kubectl exec -it  nginx-deployment-8c64f777-f49z4 -c mynginx -- bash


# create service
# https://kubernetes.io/docs/concepts/services-networking/service/
# https://kubernetes.io/docs/reference/networking/virtual-ips/#session-affinity

# Pod to Service routing for load balancing
When a pod in your cluster does an http request to a Service within the cluster, 
the kube-proxy does routing in a round robin way by default.
kube-proxy in userspace mode chooses a backend via a round-robin algorithm.

If you want session affinity on pod-to-service routing, you can set the SessionAffinity: ClientIP field on a Service object.
If you want to make sure that connections from a particular client are passed to the same Pod each time, 
you can select the session affinity based on client’s IP addresses by setting service.spec.sessionAffinity 
to “ClientIP” (the default is “None”).



# load balancing using ingress (like api getway)
# https://kubernetes.io/docs/concepts/services-networking/ingress/
# https://kubernetes.github.io/ingress-nginx/examples/affinity/cookie/
# https://kubernetes.github.io/ingress-nginx/examples/affinity/cookie/ingress.yaml

Ingress to Service routing
When using Ingress, L7-proxy, the routing can be based on http request content, but this depends on what implementation of an IngressController you are using. E.g. Ingress-nginx has some support for sticky sessions and other implementations may have what you are looking for. E.g. Istio has support similar settings.

kubectl apply -f deployment/ingress.yaml
kubectl describe ing nginx-ing-test


https://github.com/thesandlord/nginx-kubernetes-lb
https://github.com/hpcloud/kubernetes-service-loadbalancer
https://github.com/TuxInvader/nginx-lb-operator



