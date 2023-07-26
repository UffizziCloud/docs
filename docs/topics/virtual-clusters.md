# What are Uffizzi virtual clusters?

Similar to the concept of virtual machines, Uffizzi virtual clusters are virtualized instances of Kubernetes clusters running on top of a host cluster. Uffizzi virtual clusters provide all the same functionality of real Kubernetes clusters, while being more convenient and efficient. Virtual Kubernetes clusters are one of the configuration options for Uffizzi ephemeral environments (the other being [Docker Compose environents](../guides/docker-compose-template.md)). You can create virtual clusters from Helm charts, kustomizations, or regular Kubernetes manifests. Once created, you can manage Uffizzi virtual clusters with kubectl.

You can let [Uffizzi Cloud](https://app.uffizzi.com) manage the host cluster for your team, or spin up virtual clusters on your own infrastructure by self-hosting Uffizzi.

## Easy provisioning
Using the `uffizzi` CLI, you can create a cluster and update your kubeconfig in a single command, then use standard Kubernetes tools like `kubectl` to manage the cluster:  

``` bash
$ uffizzi cluster create -n my-cluster -k ~/.kube/config -m manifest.yaml
...
$ kubectl get pods
```

Once you're done, clean everything up with a simple `uffizzi cluster delete` command.

## Bring your own tools
Uffizzi virtual clusters work with the most popular Kubernetes management tools including `kubectl`, `kustomize`, and `helm`.

## Increased productivity
With Uffizzi virtual clusters, developers no longer have to wait on cluster availability for testing, and if your team is self-hosting Uffizzi, operations teams only need to manage a single host cluster.

## Secure scaling
Uffizzi virtual clusters provide secure multi-tenant Kubernetes out of the box, so workloads can safely and efficiently share underlying compute resources. This means every developer on your team can test their code in dedicated and isolated clusters whenever they need them.

## Cost-effective testing
Whether you install Uffizzi on your own host cluster or are relying on Uffizzi Cloud, virtualization is the most cost-effective way to power your Kubernetes-based test environments. 

## Getting started
To get started with Uffizzi virtual clusters, follow the [quickstart guide](../quickstart.md).