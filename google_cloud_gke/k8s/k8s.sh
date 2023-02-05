 # db-instance server (woker)
 ssh -i ~/.ssh/feedback_root root@34.168.46.197

# testing (master)
ssh -i ~/.ssh/feedback ubuntu@35.212.152.136

sudo nano /etc/nginx/sites-available/feedback
sudo systemctl restart nginx
sudo systemctl restart postgresql

sudo docker login
sudo docker tag social_backend_feedback:latest shoumitro26/social_backend_feedback:latest
sudo docker push shoumitro26/social_backend_feedback:latest
sudo docker pull shoumitro26/social_backend_feedback:latest 
 

sudo docker tag postgre_setup_feedback_db:latest shoumitro26/feedback_db:latest
sudo docker push shoumitro26/feedback_db:latest
sudo docker pull shoumitro26/feedback_db:latest 

# for database
kubectl apply -f feebback-rep-db-deploy.yaml
kubectl apply -f lb-fb-db-service.yaml
kubectl scale deployment/fb-database-deployment --replicas=5
kubectl get pods -o wide


# for private docker image
# Create a Secret based on existing credentials
# https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
cat ~/.docker/config.json

kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/root/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
    
kubectl get secret
# show username and password
kubectl get secret regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
echo "c2hvhdW1pfdHJvMfdjY6QdfdfmQxMjhM0NTY3OA==" | base64 --decode


# for pods & service
kubectl apply -f  feebback-deploy.yaml
kubectl apply -f lb-feedback-service.yaml


kubectl get pods -o wide
kubectl get pods --watch
kubectl logs pod/feedback-deployment-689f5df499-2hpdr -f
kubectl exec -it  feedback-deployment-689f5df499-2hpdr -c feedback-social -- bash

# for sevice
kubectl get svc -o wide
curl http://10.109.156.75

# scaling
kubectl scale deployment/feedback-deployment --replicas=8
kubectl scale deployment/feedback-deployment --replicas=5

# pods auto scaling
kubectl autoscale deployment/feedback-deployment --min=2 --max=8 --cpu-percent=10

# pods auto scaling delete
kubectl get hpa # to show Horizontal Pod Scaler.
kubectl delete hpa feedback-deployment # delete autoscale




psql 'postgres://postgres:1234@35.212.152.136:5432/postgres?sslmode=disable'
# Firewall TCP open for
6379
5432
5433
5434
5435




