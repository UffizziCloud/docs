# Quickstart Guide

This guide covers how you can quickly get started using Uffizzi.

## Prerequisites

The following prerequisites are required for this guide:

1. A GitHub or GitLab account for creating a Uffizzi Cloud login
2. Installing and configuring Uffizzi  
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

1. **Select an account** - If you have multiple GitHub/GitLab accounts, select which one you want to configure as your default account context. You can change this setting later with the [`uffizzi config`](references/cli.md#config) command.  

2. **Create a new project** - Select **Create a new project**. Enter a project name as "quickstart" or similar, then confirm the project slug. For project description, enter "Quickstart guide" or just leave it blank.

## Create a virtual cluster

Let's create a [virtual Kubernetes cluster](topics/virtual-clusters.md) to which we'll apply manifests in the next steps.  

In the command below, replace `~/.kube/config` with the path to your kubeconfig file, if different. Uffizzi will merge with an existing kubeconfig at the location you specify. If you don't have a kubeconfig file, you can omit this option and Uffizzi will create a new kubeconfig file at `~/.kube/config`.

``` bash
uffizzi cluster create --name quickstart --kubeconfig ~/.kube/config
```

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
kubectl apply -f manifests/
```

## Create ingresses

Next we'll create ingresses for two of the application components to allow these services to receive HTTP requests.  

!!! Note
    Notice the commands below use `openssl` (Mac or Linux) or `Guid` (Windows) to generate random 12-character strings for the subdomains. This is to prevent hostname collision on Uffizzi Cloud. Alternatively, you could use a domain you control and update your DNS accordingly.

### Create an ingress for the `vote` component

=== "Mac or Linux"

    ``` bash
    kubectl create ingress vote --class=nginx --rule="$(openssl rand -hex 6).app.uffizzi.com/*=vote:5000"
    ```

=== "Windows"  

    ``` powershell
    kubectl create ingress vote --class=nginx --rule="$((New-Guid).Guid.SubString(0,12)).app.uffizzi.com/*=vote:5000"

    ```

### Create an ingress for the `result` component

=== "Mac or Linux"

    ``` bash
    kubectl create ingress result --class=nginx --rule="$(openssl rand -hex 6)-result.app.uffizzi.com/*=result:5000"
    ```

=== "Windows"  

    ``` powershell
    kubectl create ingress result --class=nginx --rule="$((New-Guid).Guid.SubString(0,12))-result.app.uffizzi.com/*=result:5000"

    ```

## Verify everything works

You can verify that everything is working by copying the link for the `vote` component into your browser. Note that your randomly generated string will be different than the one below:

```
http://2966fe8c4e77.app.uffizzi.com
```

## Clean up

Once your done with this environment, you can clean everything up—including all Kubernetes resources and data—by deleting the cluster:

```
uffizzi cluster delete quickstart --delete-config
```

The `--delete-config` flag tells Uffizzi to delete this cluster, user, and context for your kubeconfig file.

## Set up Uffizzi for GitHub Actions

TODO

## Set up Uffizzi for GitLab CI

TODO