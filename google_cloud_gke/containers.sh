# https://platform9.com/docs/kubernetes/containerd-commands-and-info
# https://github.com/projectatomic/containerd/blob/master/docs/cli.md


sudo systemctl restart containerd

# show all container k8s (master & worker)
ctr -n k8s.io containers list


# inspect
ctr -n k8s.io containers info <container ID>
ctr -n k8s.io containers info 835914ec0822454f31777262aa3a60bc9e5e99899d5a40047a0d71e95a9b3aa4
ls  /var/lib/kubelet/pods/
cat /var/lib/kubelet/pods/75263d44-c93f-4b94-acee-71b43b283563/etc-hosts


# show all ns
ctr namespaces ls
ctr -n k8s.io containers ls
ctr -n k8s.io images ls
ctr -n k8s.io leases ls
ctr -n k8s.io tasks ls
ctr -n k8s.io content ls
ctr -n k8s.io snapshot ls
ctr -n k8s.io snapshot tree


# show all container k8s (master & worker)
crictl --help
crictl ps
crictl exec -it <container-id> bash
crictl exec -it 835914ec08224 bash
crictl logs 835914ec08224
crictl logs -f 835914ec08224

crictl pods
crictl pods --help

crictl pods --namespace default
crictl stats
crictl -r unix:///run/containerd/containerd.sock exec -ti <container ID> sh


root@worker-1:/home/meektecit# crictl --help
NAME:
   crictl - client for CRI

USAGE:
   crictl [global options] command [command options] [arguments...]

VERSION:
   v1.25.0

COMMANDS:
   attach              Attach to a running container
   create              Create a new container
   exec                Run a command in a running container
   version             Display runtime version information
   images, image, img  List images
   inspect             Display the status of one or more containers
   inspecti            Return the status of one or more images
   imagefsinfo         Return image filesystem info
   inspectp            Display the status of one or more pods
   logs                Fetch the logs of a container
   port-forward        Forward local port to a pod
   ps                  List containers
   pull                Pull an image from a registry
   run                 Run a new container inside a sandbox
   runp                Run a new pod
   rm                  Remove one or more containers
   rmi                 Remove one or more images
   rmp                 Remove one or more pods
   pods                List pods
   start               Start one or more created containers
   info                Display information of the container runtime
   stop                Stop one or more running containers
   stopp               Stop one or more running pods
   update              Update one or more running containers
   config              Get and set crictl client configuration options
   stats               List container(s) resource usage statistics
   statsp              List pod resource usage statistics
   completion          Output shell completion code
   checkpoint          Checkpoint one or more running containers
   help, h             Shows a list of commands or help for one command
GLOBAL OPTIONS:
   --config value, -c value            Location of the client config file. If not specified and the default does not exist, the program's directory is searched as well (default: "/etc/crictl.yaml") [$CRI_CONFIG_FILE]
   --debug, -D                         Enable debug mode (default: false)
   --help, -h                          show help (default: false)
   --image-endpoint value, -i value    Endpoint of CRI image manager service (default: uses 'runtime-endpoint' setting) [$IMAGE_SERVICE_ENDPOINT]
   --runtime-endpoint value, -r value  Endpoint of CRI container runtime service (default: uses in order the first successful one of [unix:///var/run/dockershim.sock unix:///run/containerd/containerd.sock unix:///run/crio/crio.sock unix:///var/run/cri-dockerd.sock]). Default is now deprecated and the endpoint should be set instead. [$CONTAINER_RUNTIME_ENDPOINT]
   --timeout value, -t value           Timeout of connecting to the server in seconds (e.g. 2s, 20s.). 0 or less is set to default (default: 2s)
   --version, -v                       print the version (default: false)
   
   
   
   
   
    
root@worker-1:/home/meektecit# ctr --help
NAME:
   ctr - 
        __
  _____/ /______
 / ___/ __/ ___/
/ /__/ /_/ /
\___/\__/_/

containerd CLI


USAGE:
   ctr [global options] command [command options] [arguments...]

VERSION:
   1.6.15

DESCRIPTION:
   
ctr is an unsupported debug and administrative client for interacting
with the containerd daemon. Because it is unsupported, the commands,
options, and operations are not guaranteed to be backward compatible or
stable from release to release of the containerd project.

COMMANDS:
   plugins, plugin            provides information about containerd plugins
   version                    print the client and server versions
   containers, c, container   manage containers
   content                    manage content
   events, event              display containerd events
   images, image, i           manage images
   leases                     manage leases
   namespaces, namespace, ns  manage namespaces
   pprof                      provide golang pprof outputs for containerd
   run                        run a container
   snapshots, snapshot        manage snapshots
   tasks, t, task             manage tasks
   install                    install a new package
   oci                        OCI tools
   shim                       interact with a shim directly
   help, h                    Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug                      enable debug output in logs
   --address value, -a value    address for containerd's GRPC server (default: "/run/containerd/containerd.sock") [$CONTAINERD_ADDRESS]
   --timeout value              total timeout for ctr commands (default: 0s)
   --connect-timeout value      timeout for connecting to containerd (default: 0s)
   --namespace value, -n value  namespace to use with commands (default: "default") [$CONTAINERD_NAMESPACE]
   --help, -h                   show help
   --version, -v                print the version
   
   
   
   
   
Difference between docker and containerd?
Docker is another popular container runtime that uses containerd as an internal runtime. But, the Docker container is easier to manage and run the same tasks as the containerd to get better and more efficient results. Docker has made it easier for developers to create, run, test, and deploy applications


1. Does containerd replace Docker?
It might not be possible as containerd cannot suffice your requirements to build images that you can do with Docker. If you want to use containerd, you still have to use Docker for some tasks, which is impossible with containerd. 

2. Is containerd required for Docker?
Docker uses containerd as its runtime, so it is required for Docker. 

3. Is Kubernetes dropping Docker?
Kubernetes can efficiently and quickly work with any container runtimes with a standard known as the Container Runtime Interface (CRI). It ensures standard communication between Kubernetes and the container runtime. 

But, Docker did not implement the CRI. earlier due to the shortage of genuine options Kubenernetes was using Docker. But, as the number of runtime options is increasing in implementing the CRI, Kubernetes is dropping support for Docker. 




   
