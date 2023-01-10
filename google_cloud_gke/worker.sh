# install kubelet kubeadm kubectl
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
sudo systemctl restart docker
################# docker install end ###################



# for worker node join cmd
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
kubeadm join 10.138.0.6:6443 --token o6r0ps.owwieceqclx0idkr \
        --discovery-token-ca-cert-hash sha256:0905141a53038a973f1d86c8fac340e17bfd06d524fbc3a12230fe194dfc34e4 
        
        
# kubeadm reset        
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
kubeadm join 10.138.0.15:6443 --token ifunaq.yks15abpv5vrg1yz \
        --discovery-token-ca-cert-hash sha256:b0b22d3aaf3ee7ee789638d30a366765cf0c0aa6da1ee8bff04f7b1b61fc2cec
