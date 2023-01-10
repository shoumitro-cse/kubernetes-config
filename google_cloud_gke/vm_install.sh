# for ubuntu 20.04

# vm instance
# https://console.cloud.google.com/compute/instances?authuser=0&project=maximal-arcade-372908

# ssh master and worker
gcloud compute ssh --zone "us-west4-b" "master"  --project "maximal-arcade-372908"
gcloud compute ssh --zone "us-west4-b" "worker1"  --project "maximal-arcade-372908"
gcloud compute ssh --zone "us-west4-b" "worker2"  --project "maximal-arcade-372908"
gcloud compute ssh --zone "us-west4-b" "worker3"  --project "maximal-arcade-372908"



kubeadm token create --print-join-command

kubectl get componentstatuses
kubectl get pods --all-namespaces --watch
kubectl get pods -o wide


kubectl patch svc myservice -n default -p '{"spec": {"type": "LoadBalancer", "externalIPs":["34.125.246.160"]}}'














# create instance
#gcloud compute instances create worker1 --project=maximal-arcade-372908 --zone=us-west1-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=1081243036445-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=worker1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20221206,mode=rw,size=10,type=projects/maximal-arcade-372908/zones/us-west4-b/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any


# https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
# https://www.youtube.com/watch?v=lOd-0_DpYG8&list=PLMPZQTftRCS8Pp4wiiUruly5ODScvAwcQ&index=17
# https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04

sudo apt update
sudo apt -y full-upgrade
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


# sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
# sudo nano /etc/fstab
sudo swapoff -a
# sudo mount -a
# free -h


# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system



# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
# docker install
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce
# sudo systemctl status docker


# Create required directories
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create daemon json config file
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
################# common end###################



# for master
lsmod | grep br_netfilter
sudo systemctl enable kubelet
sudo systemctl restart kubelet
sudo kubeadm config images pull

### With Docker CE ###
# sudo kubeadm init --pod-network-cidr=10.240.0.0/16 

# https://www.tracston.com/index.php/forum/topic/kubadm-init-error-cri-container-runtime-is-not-running/
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm init --pod-network-cidr=10.240.0.0/16 
sudo kubeadm config images pull

sudo systemctl enable kubelet
sudo systemctl restart kubelet
sudo systemctl restart docker
sudo systemctl restart containerd
kubectl cluster-info

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml

        
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/kubelet.conf



# for worker node join cmd
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
kubeadm join 10.182.0.2:6443 --token 3rtb5x.w0csuo1rhtlfn7e6 \
        --discovery-token-ca-cert-hash sha256:980c89e3c16cdf4bcc7cacf2a3e951f3133e00b530249067e6f23626d9674cf1

    


















    
# options of kubeadm
kubeadm init --pod-network-cidr=10.240.0.0/16 
# --control-plane-endpoint :  set the shared endpoint for all control-plane nodes. Can be DNS/IP
# --pod-network-cidr : Used to set a Pod network add-on CIDR
# --cri-socket : Use if have more than one container runtime to set runtime socket path
# --apiserver-advertise-address : Set advertise address for this particular control-plane node's API server

# master nginx
# ip address
curl http://10.182.0.2
 

# https://discuss.kubernetes.io/t/the-connection-to-the-server-host-6443-was-refused-did-you-specify-the-right-host-or-port/552/45?page=3
sudo kubeadm reset # reset config
sudo apt install firewalld
sudo systemctl enable firewalld
sudo systemctl restart firewalld
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250-10255/tcp
sudo firewall-cmd --reload
sudo systemctl restart kubelet
sudo systemctl restart docker

# https://stackoverflow.com/questions/56169131/kubectl-cannot-connect-gke-failing-with-x509-certificate-signed-by-unknown-aut
# https://cloud.google.com/sdk/gcloud/reference/auth/login
# google login in master node
gcloud auth login
gcloud auth list


# check
echo $KUBECONFIG
env | grep -i kube
systemctl status docker
systemctl status kubelet
netstat -pnlt | grep 6443
firewall-cmd --list-all
journalctl -xeu kubelet



#################  kubeadm init output ###################
sudo kubeadm init
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.138.0.2:6443 --token unv81r.irwrl6rmrlrfhmq7 \
        --discovery-token-ca-cert-hash sha256:971d4fda84b799db93ac198d68fda05a0b2774a6808197af775f7f822a657859
        
#########################################


kubectl get componentstatuses

sudo netstat -lnpt|grep kube

sudo systemctl status firewalld
sudo systemctl stop firewalld
