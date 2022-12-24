# https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
# https://kubebyexample.com/learning-paths/application-development-kubernetes/lesson-4-customize-deployments-application-0

# get node info like cpu, memory
kubectl describe node minikube

kubectl create quota dev-quota --hard services=10,cpu=1300,memory=1.5Gi
kubectl get resourcequota
kubectl describe dev-quota
kubectl delete resourcequota dev-quota

kubectl create --save-config -f resource-quota.yaml

# Specify compute resource requirements (CPU, memory) for any resource that defines a pod template
kubectl set resources --help


# Specify compute resource requirements (CPU, memory) for any resource that defines a pod template.  
# If a pod is successfully scheduled, it is guaranteed the amount of resource requested, but may burst up 
# to its specified limits. For each compute resource, if a limit is specified and a request is omitted, the request will default 
# to the limit. Possible resources include (case insensitive): Use "kubectl api-resources" for a complete 
# list of supported resources..

# Examples:
	  # Set a deployments nginx container cpu limits to "200m" and memory to "512Mi"
	  kubectl set resources deployment nginx -c=nginx --limits=cpu=200m,memory=512Mi
	  
	  # Set the resource request and limits for all containers in nginx
	  kubectl set resources deployment nginx --limits=cpu=200m,memory=512Mi --requests=cpu=100m,memory=256Mi
	  
	  # Remove the resource requests for resources on containers in nginx
	  kubectl set resources deployment nginx --limits=cpu=0,memory=0 --requests=cpu=0,memory=0
	  
	  # Print the result (in yaml format) of updating nginx container limits from a local, without hitting the server
	  kubectl set resources -f path/to/file.yaml --limits=cpu=200m,memory=512Mi --local -o yaml

