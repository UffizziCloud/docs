# Quickstart Guide

This guide covers how you can quickly get started using Uffizi to create virtual clusters. If you want to create Docker Compose-based environments instead, start with [this guide](docker-compose-environment.md).

!!! Important
    Uffizzi virtual clusters are currently in beta. Our team is actively working to improve reliability and developer experience. Please report any bugs to bugs@uffizzi.com

## Prerequisites

The following prerequisites are required for this guide:

1. A GitHub or GitLab account for creating a Uffizzi Cloud login
2. Installing and configuring the Uffizzi client
3. Deciding which continuous integration tool to configure, if any

## Install Uffizzi

Download a binary release of the Uffizzi client from the [official release page](https://github.com/UffizziCloud/uffizzi_cli/releases).  

For more details, see the [installation guide](install.md).

## Create an account

For this quickstart guide, we'll be creating an account on Uffizzi Cloud using your GitHub or GitLab login. The following command will provide you with a link to sign up via a browser. If you've already created an account at [uffizzi.com](https://uffizzi.com), this command will let you login to your existing account:

``` bash
uffizzi login
```

!!! Note
    If you'd rather have an email/password based login on Uffizzi Cloud, [submit a request](mailto:accounts@uffizzi.com).  
    If you're self-hosting Uffizzi, you should follow the [self-hosting guide](https://github.com/UffizziCloud/uffizzi/blob/develop/INSTALL.md) to create an account. 

### Account setup


1. **Select an account** -  In this step, you'll select your default account context. You can change this setting later with the [`uffizzi config`](references/cli.md#config) command.   

    ```
    $ uffizzi login
    Select an account: (Press ↑/↓ arrow to move and Enter to select)
    ‣ Acme Corp
      jdoe
    ```
    !!! Note 
        If you signed up with GitHub or GitLab, you'll see your personal account and any organizations or groups you belong to. Choose your organization/group account if you want to create ephemeral environments for your team applications. Otherwise, you can select your personal account to create clusters for personal projects. Note that Personal and Team accounts are billed separately. [Learn more >](topics/teams-and-accounts.md)

2. **Create a new project** - Select **Create a new project**. Enter a project name as "quickstart" or similar, then confirm the project slug. For project description, enter "Quickstart guide" or just leave it blank.

## Create a virtual cluster

Let's create a [virtual Kubernetes cluster](topics/virtual-clusters.md) to which we'll apply manifests in the next steps.  

In the command below, replace `~/.kube/config` with the path to your kubeconfig file, if different. Uffizzi will merge with an existing kubeconfig at the location you specify. If you don't have a kubeconfig file, you can omit this option and Uffizzi will create a new kubeconfig file at `~/.kube/config`.

``` bash
uffizzi cluster create --name quickstart --kubeconfig ~/.kube/config --update-current-context
```

The last option `--update-current-context` is equivalent to `kubectl config use-context`. It tells Uffizzi to set the default cluster context to the one that was just created.

## Download an example application

We'll be using an [example application](https://github.com/UffizziCloud/quickstart-k8s) to deploy onto our cluster. The following GitHub repository includes code for the applicaiton, along with Kubernetes manifests that describe its configuration.  

Clone the repository, then change to its directory:

``` bash
git clone https://github.com/UffizziCloud/quickstart-k8s.git && \
cd quickstart-k8s
```

## Apply the manifests to your cluster

From the `quickstart-k8s/` directory, run the following `kubectl` command to apply the manifests from the `manifests/` directory to your cluster:

``` bash
kubectl apply --kustomize .
```

The above will create deployments, services, and ingresses for `vote` and `result` applications. The hostnames on the ingresses are assigned dynamically so that users don't have to create their own and spend time sorting out possible hostname conflict issues.

If you query your created ingress with `kubectl get ingress -A`, you should see something like the following:
```
NAME     CLASS     HOSTS                                                             ADDRESS   PORTS     AGE
result   uffizzi   result-default-quickstart-cluster-320.uclusters.app.uffizzi.com             80, 443   14m 
vote     uffizzi   vote-default-quickstart-cluster-320.uclusters.app.uffizzi.com               80, 443   14m
```

## Understanding Ingress on Uffizzi

There are two ingress options on Uffizzi: default and custom. 

### Default IngressClass `uffizzi`

The default IngressClass for any ingress created in a virtual cluster is `uffizzi`. The hostnames will be overriden to the format below :

```
https://<ingress-name>-<virtual-namespace>-<ucluster-name>-<ucluster-id>.uclusters.app.uffizzi.com 
```

This allows users to quickly start testing their serivces and routing traffic from the outside world without having to configure hostnames manually or provisioning their own Ingress controller. Alternatively, you can define a custom IngressClass, as described below.

### Custom IngressClass

You can bring your own IngressClass, and install the necessary controller on your virtual cluster. Custom IngressClasses on Uffizzi virtual clusters work just like they do on a standard Kubernetes cluster.

Follow the official kubernetes documentation for understanding what an [IngressClass](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class) is and how you can back it up by deploying your own [Ingress controller of choice](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

## Verify everything works

You can verify that everything is working by opening both the ingress URLs in your browser. You can vote for cats or dogs from the vote service, then see the voting results in the result service.

## Clean up

Once your done with this environment, you can clean everything up—including all Kubernetes resources and data—by deleting the cluster:

```
uffizzi cluster delete quickstart --delete-config
```

The `--delete-config` flag tells Uffizzi to delete this cluster, user, and context for your kubeconfig file.

## What's next?

See advanced usage examples, like how to add Uffizzi to a continuous integration (CI) pipeline like GitHub Actions or GitLab CI, so you can create ephemeral environments on every pull request or merge request.

[Using Uffizzi →](using-uffizzi.md){ .md-button .md-button--primary }

&nbsp;
