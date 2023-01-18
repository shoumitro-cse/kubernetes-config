# for ubuntu 20.04

# install kubelet kubeadm kubectl
sudo su
sudo apt update
sudo apt -y full-upgrade
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# disable swap memory
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


################# docker install start ###################
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt -y install docker-ce
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
sudo systemctl restart docker
################# docker install end ###################



################# master #####################
lsmod | grep br_netfilter
sudo systemctl enable kubelet
sudo systemctl restart kubelet

### cluster setup ###
# https://www.tracston.com/index.php/forum/topic/kubadm-init-error-cri-container-runtime-is-not-running/
# sudo kubeadm reset
# sudo su
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 # pod-network for flannel


# cluster tools restart
sudo systemctl enable kubelet
sudo systemctl restart kubelet
sudo systemctl restart docker
sudo systemctl restart containerd
kubectl cluster-info


# flannel network setup
# https://github.com/flannel-io/flannel#deploying-flannel-manually
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16  # this code is import for this netwok
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
# kubectl delete -f https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
kubectl get ns
kubectl get pods -n kube-flannel


# To start using your cluster, you need to run the following as a regular user: 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/kubelet.conf


kubeadm token create --print-join-command
kubeadm join 10.138.0.16:6443 --token gzi6ri.ym56k9e2z4hs8dl8 --discovery-token-ca-cert-hash sha256:c2cbc37d6726be1f778ecc237d9669414f67600fa129225adc856a1d9e279ef6 

kubectl get nodes
        
        
