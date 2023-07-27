# Using Uffizzi

This guide explains the basics of using Uffizzi to manage ephemeral environments. It assumes that you have already [installed](install.md) the Uffizzi client.

If just want to run a few quick commands, you may want to start with the [Quickstart Guide](quickstart.md). This guide covers specific Uffizzi commands, and explains the most common ways that teams use Uffizzi: via the command-line (client) or a continuous integration (CI) pipeline.

## Two Types of Ephemeral Environments

Uffizzi currently supports two types of ephemeral environments:

- **(In Beta) Virtual cluster environments** are Kubernetes-based environments built from a Kubernetes specification—typically Helm, kustomize, or standard manifests. You can read more about Uffizzi's virtual clusters [here](topics/virtual-clusters.md), but in short, these are fully functional Kubernetes clusters that run in isolation on top of a host cluster. Once you've created these clusters with the Uffizzi client or from your CI pipeline, you can use standard Kubernetes tools like `kubectl` and `helm` to manage them and their configurations.

- **Docker Compose environments** are container-based environments built from a Docker Compose specification. You can read more about Uffizzi's support for the Compose specification [here](references/compose-spec.md), as well as a tutorial on how to [write a Uffizzi Compose file](guides/docker-compose-template.md) and how to [upload and configure it](http://localhost:8000/guides/configure-credentials/).

## Managing Environments

Uffizzi has two primary functions: 

1. **Lifecycle Management** - Uffizzi creates, updates and deletes your environments based on triggers. These triggers can be initiated manually, for example from the [Uffizzi](install.md) client, or via automated workflow like a CI pipeline.
2. **Access Control** - Uffizzi limits how your environments can be accessed and by whom. For example, Uffizzi enforces [role-based access controls (RBAC)](topics/rbac.md) to limit who on your team can manage or update your environments, and allows you to password protect any environment's public URLs.

## From the Uffizzi Client

You use the Uffizzi client to create environments from a local directory. When you create an environment, the Uffizzi client will update the kubeconfig file you specify with a cluster hostname and certificate you can use to connect.

### Creating and managing clusters  

Here we create a cluster with the Uffizzi client and apply the manifests from a local directory with `kubectl`:
```
uffizzi cluster create -n my-cluster -k ~/.kube/config &&
kubectl apply -f manifests/
```

Alternately, we can create a cluster and apply the manifests in a single Uffizzi command:

```
uffizzi cluster create -n my-cluster -k ~/.kube/config -m manifests/
```

To connect to an existing Uffizzi cluster, you can run the `update-kubeconfig` command with the name of the cluster you're targeting and the location of your kubeconfig file:

```
uffizzi cluster update-kubeconfig my-cluster -k ~/.kube/config
```
See the [CLI Reference](references/cli.md#cluster-update-kubeconfig) for how Uffizzi handles kubeconfig updates.

### Creating and managing Docker Compose environments

**Support for Compose**

Use the `preview` command to create an ephemeral environment from a Docker Compose configuration. Note that Uffizzi supports a subset of the of the complete [Compose specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md). Uffizzi also requires some additional configuration that is not included in the Compose specification, most notably an `ingress` definition. See the [Uffizzi Compose File Reference](references/compose-spec.md) for more detail on what is required for your `docker-compose.uffizzi.yml` file. For help writing this file or for using it in CI pipelines to create pull request environments, see [this guide](docker-compose-environment.md).

In the following example, we pass a `docker-compose.uffizzi.yml` from our local development environment. This command will create a preview environment for this Compose file in the default account and project. 

!!! Important
    The Uffizzi client does not build containers from your local environment even if your environment includes a `DOCKERFILE`. Instead you should included pre-built images in your Docker Compose file (i.e. use the `image` directive instead of the `build` directive.) If you want Uffizzi to build container images for you, your code must hosted in a GitHub repository Uffizzi CI. (i.e. it will not build containers from your local workstation. 

```
uffizzi preview create docker-compose.uffizzi.yml
```


## From a CI Pipeline

In addition to creating environments from the Uffizzi client, you can configure a CI service to automatically deploy new environments for certain events, like pull or merge requests.

### GitHub Actions Example

In this example, we'll use the Uffizzi [GitHub Actions](https://docs.github.com/en/actions) and specifically a Uffizzi cluster action to create a virtual Kubernetes cluster and deploy an example application to it.

Start by forking the [quickstart](https://github.com/UffizziCloud/quickstart) repository on GitHub. Be sure to uncheck the option **Copy the `main` branch only**. This ensures that the `try-uffizzi` branch will be included in your fork.  

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191072997-94fdc9cc-2be2-4b44-900f-d4507c6df8a6.png" width="800">  
</details>

Enable GitHub Actions workflows for your fork by selecting **Actions**, then select **I understand my workflows, go ahead and enable them**. GitHub Actions is free for public repositories.   

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191074124-8ace8e9f-4970-46e5-9418-0f18d30bd08c.png" width="800">  
</details>

Open a pull request for `try-uffizzi` branch against `main` in your fork. Be sure that you're opening a PR on the branches of _your fork_ (i.e. `your-account/main` ← `your-account/try-uffizzi`). If you try to open a PR for `UffizziCloud/main` ← `your-account/try-uffizzi`, the Actions workflow will not run in this example.   

That's it! This will kick off a GitHub Actions workflow and post the ephemeral environment URL as a comment to your PR issue. 

<img alt="uffizzi-bot" src="https://user-images.githubusercontent.com/7218230/191825295-50422b35-23ac-47f6-8a22-c67f95c89d8c.png" width="800">

&nbsp;  
**What To Expect**

The PR will trigger a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-preview.yaml) that creates a Uffizzi Ephemeral Environment for the [microservices application](https://github.com/UffizziCloud/quickstart#architecture-of-this-example-app) defined by the repo. The environment URL will be posted as a comment in your PR issue when the workflow completes, along with a link to the Uffizzi Dashboard where you can view application logs. The environment and comment is deleted when the PR is merged/closed or after 1 hour (configurable).  

!!! Tip
    Each ephemeral environment is available at a predictable URL which consists of `https://app.uffizzi.com/` appended with the GitHub pull request domain. For example:  
    `https://app.uffizzi.com/github.com/{account}/{repo}/pull/{pull-request-number}`.  

    You can make requests to specific endpoints by appending a route to the end of the URL. For example:  
    `https://app.uffizzi.com/github.com/boxyhq/jackson/pull/661/api/health`  

&nbsp;  
**How It Works**

Previews are configured with a [Docker Compose template](https://github.com/UffizziCloud/quickstart/blob/main/docker-compose.uffizzi.yml) that describes the application configuration and a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-preview.yaml) that includes a series of jobs triggered by a `pull_request` event and subsequent `push` events:  

1. [Build and push images to a container registry](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L14-L116)  
2. [Render a Docker Compose file](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L118-L156) from the Docker Compose template and the built images  
3. [Deploy the application (per the Docker Compose file) to a Uffizzi Preview Environment](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L158-L171) and post a comment to the PR issue  
4. [Delete the Preview Environment](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L173-L184) when the PR is merged/closed or after `1h`      

Running this workflow will create a [Uffizzi Cloud](https://uffizzi.com) account and project from your GitHub user and repo information, respectively. If you sign in to the [Uffizzi Dashboard](https://app.uffizzi.com/sign_in) you can view logs, password protect your Preview Environments, manage projects and team members, set role-based access controls, and configure single-sign on (SSO).

The [Starter Plan](https://uffizzi.com/pricing) is free includes up to two concurrent preview environments. See [our pricing](https://uffizzi.com/pricing) for plan details. Alternatively, you can [install open-source Uffizzi](https://github.com/UffizziCloud/uffizzi_app/blob/develop/INSTALL.md) if you have your own Kubernetes cluster.

### GitLab CI Example

In this example, we'll open a merge request (MR) to kick off a GitLab CI pipeline. One of the jobs of this pipeline will create a virtual Kubernetes cluster on Uffizzi Cloud and deploy a sample microservices application from this repository. Once created, you can connect to the cluster with the Uffizzi CLI, then manage the cluster via kubectl, kustomize, helm, and other tools. You can clean up the cluster by closing the pull request or manually deleting it via the Uffizzi CLI.

&nbsp;  
**What To Expect**

&nbsp;  
**How It Works**