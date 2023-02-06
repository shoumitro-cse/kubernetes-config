# https://helm.sh/docs/intro/install/


# https://helm.sh/docs/intro/quickstart/
# https://bitnami.com/stack/mysql/helm

# what is helm?
The Kubernetes package manager


curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


# cmd
helm list


# add repositories and mysql install
helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo
helm install my-db-mysql azure-marketplace/mysql
helm uninstall my-db-mysql
kubectl get pods

kubectl get secret
# get pw from my-db-mysql secret
MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace default my-db-mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d)
w6krGbu8by

#  Run a pod that you can use as a client:
kubectl run my-db-mysql-client --rm --tty -i --restart='Never' --image  marketplace.azurecr.io/bitnami/mysql:8.0.31-debian-11-r10 --namespace default --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash

# To connect to primary service (read/write)
mysql -h my-db-mysql.default.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD"

# Primary:
my-db-mysql.default.svc.cluster.local:3306



# for PostgreSQL, Nginx etc so on.
helm repo add stable https://charts.helm.sh/stable
helm repo update
# show repo list
helm search repo
helm search repo nginx


# it's good for PostgreSQL, Nginx and so on.
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm search repo postgres
helm search repo nginx
helm search repo bitnami/nginx

# nginx install
# https://www.eksworkshop.com/beginner/060_helm/helm_nginx/installnginx/
helm install --help
helm install bitnami/nginx --generate-name
helm list
helm uninstall mywebserver
kubectl get all
kubectl get deploy,po,svc,rs
kubectl get deploy,po,svc,rs -o wide
kubectl get svc -o wide
curl http://10.104.203.226 #(CLUSTER-IP)


# all repo list
helm repo list

# add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard
helm delete kubernetes-dashboard
kubectl get all

export POD_NAME=$(kubectl get pods -n default -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=kubernetes-dashboard" -o jsonpath="{.items[0].metadata.name}")
kubectl -n default port-forward $POD_NAME 8443:8443


root@feedback-db:/home/ubuntu/k8s# helm install bitnami/nginx --generate-name
NAME: nginx-1675707680
LAST DEPLOYED: Mon Feb  6 18:21:21 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: nginx
CHART VERSION: 13.2.23
APP VERSION: 1.23.3

** Please be patient while the chart is being deployed **
NGINX can be accessed through the following DNS name from within your cluster:

    nginx-1675707680.default.svc.cluster.local (port 80)

To access NGINX from outside the cluster, follow the steps below:

1. Get the NGINX URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w nginx-1675707680'

export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services nginx-1675707680)
export SERVICE_IP=$(kubectl get svc --namespace default nginx-1675707680 -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "http://${SERVICE_IP}:${SERVICE_PORT}"




helm install bitnami/postgresql --generate-name

export POSTGRES_PASSWORD=$(kubectl get secret --namespace default postgresql-1675708221 -o jsonpath="{.data.postgres-password}" | base64 -d)

kubectl run postgresql-1675708221-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:15.1.0-debian-11-r31 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgresql-1675708221 -U postgres -d postgres -p 5432

kubectl run postgresql-1675708221-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:15.1.0-debian-11-r31 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- bash

kubectl port-forward --namespace default svc/postgresql-1675708221 5432:5432 &
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
    

psql 'postgres://postgres:0I7RSbps6E@10.101.172.20:5432/postgres?sslmode=disable'

root@feedback-db:/home/ubuntu/k8s# helm install bitnami/postgresql --generate-name
NAME: postgresql-1675708221
LAST DEPLOYED: Mon Feb  6 18:30:22 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: postgresql
CHART VERSION: 12.1.14
APP VERSION: 15.1.0

** Please be patient while the chart is being deployed **

PostgreSQL can be accessed via port 5432 on the following DNS names from within your cluster:

    postgresql-1675708221.default.svc.cluster.local - Read/Write connection

To get the password for "postgres" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace default postgresql-1675708221 -o jsonpath="{.data.postgres-password}" | base64 -d)

To connect to your database run the following command:

    kubectl run postgresql-1675708221-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:15.1.0-debian-11-r31 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host postgresql-1675708221 -U postgres -d postgres -p 5432

    > NOTE: If you access the container using bash, make sure that you execute "/opt/bitnami/scripts/postgresql/entrypoint.sh /bin/bash" in order to avoid the error "psql: local user with ID 1001} does not exist"

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace default svc/postgresql-1675708221 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432

WARNING: The configured password will be ignored on new installation in case when previous Posgresql release was deleted through the helm command. In that case, old PVC will have an old password, and setting it through helm won't take effect. Deleting persistent volumes (PVs) will solve the issue.


