# https://k21academy.com/docker-kubernetes/kubernetes-dashboard/#:~:text=Ans%3A%20Create%20a%20Cluster%20Admin,covered%20in%20the%20above%20steps.
# https://github.com/kubernetes/dashboard


kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

kubectl get all -n kubernetes-dashboard
kubectl edit service/kubernetes-dashboard 

kubectl get svc -n kubernetes-dashboard
curl https://10.101.146.81


# best
# https://www.youtube.com/watch?v=bpZzV4GPLks
git clone https://github.com/irsols-devops/kubernetes-dashboard.git
kubectl apply -f ./kubernetes-dashboard/
# kubectl delete -f ./kubernetes-dashboard/
kubectl get pods -A -o wide





# https://www.learnitguide.net/2020/10/install-kubernetes-dashboard-deploy.html
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
# Find the service type and change from ClusterIP to LoadBalancer, save and exit, press insert key to write, shift+esc then :wq
kubectl -n kubernetes-dashboard edit svc kubernetes-dashboard
kubectl create serviceaccount dashboard -n default
kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:dashboard
kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 –decode







