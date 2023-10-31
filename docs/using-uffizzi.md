# Using Uffizzi

This guide explains key concepts and methods of using Uffizzi to manage ephemeral environments. It assumes that you have already [installed](install.md) the Uffizzi client.

If just want to run a few quick commands, you may want to start with the [Quickstart Guide](quickstart.md). Otherwise, this guide covers specific Uffizzi commands, and explains the most common ways that teams use Uffizzi: via the command-line (client) or a continuous integration (CI) pipeline.

## Two Types of Ephemeral Environments

Uffizzi currently supports two types of ephemeral environments:

- **(In Beta) Virtual Cluster environments** are Kubernetes-based environments built from a Kubernetes specification—typically [Helm Charts](https://helm.sh), [kustomizations](https://kustomize.io), or standard manifests applied by [kubectl](https://kubernetes.io/docs/reference/kubectl/). You can read more about Uffizzi's virtual clusters [here](topics/virtual-clusters.md), but in short, these are fully functional Kubernetes clusters that run in isolation on top of a host cluster. Once you've created these clusters with the Uffizzi client or from your CI pipeline, you can use standard Kubernetes tools like `kubectl` and `helm` to manage them and their configurations.

- **Docker Compose environments** are container-based environments built from a Docker Compose specification. You can read more about Uffizzi's support for the Compose specification [here](references/compose-spec.md), as well as a tutorial on how to [configure a Uffizzi Compose file](docker-compose-environment.md#create-a-docker-compose-template).
## Managing Environments

Uffizzi has two primary functions: 

1. **Lifecycle Management** - Uffizzi creates, updates and deletes your environments based on triggers. These triggers can be initiated manually, for example from the Uffizzi [client](install.md), or via automated workflows like a CI pipeline.
2. **Access Control** - Uffizzi limits how your environments can be accessed and by whom. For example, Uffizzi enforces [role-based access controls (RBAC)](topics/rbac.md) to limit who on your team can manage or update your environments, and allows you to password protect any environment's public URLs.

## From the Uffizzi Client

### Configuring the client

You can configure the Uffizzi client using the `config` subcommand. The configuration is stored in `~/.config/uffizzi/config_default.json`. 

``` bash
uffizzi config
```

Use the `list` subcommand to view the current configuration:  

``` bash
uffizzi config list
```

Set the value of the specified property, like `username`:

```
uffizzi config set username jdoe
```

Get the value of the specified property, like `server`:

``` bash
uffizzi config get-value server
```

### Creating and managing clusters

#### Cluster creation and workload deployments

Use the Uffizzi client to create environments from a local directory (support for remote Chart repositories is coming soon). When you create an environment, the Uffizzi client will update the kubeconfig file you specify with a cluster hostname and certificate you can use to connect, as well as, update your current context. Here we create a cluster with the Uffizzi client:

``` bash
uffizzi cluster create -n my-cluster -k ~/.kube/config --update-current-context
```

Then apply the manifests from a local directory with `kubectl`:

``` bash
kubectl apply -f manifests/
```

Alternately, we can create a cluster and apply the manifests in a single Uffizzi command:

``` bash
uffizzi cluster create -n my-cluster -k ~/.kube/config -m manifests/
```

To connect to an existing Uffizzi cluster, you can run the `update-kubeconfig` command with the name of the cluster you're targeting and the location of your kubeconfig file:

``` bash
uffizzi cluster update-kubeconfig my-cluster -k ~/.kube/config
```
See the [CLI Reference](references/cli.md#cluster-update-kubeconfig) for how Uffizzi handles kubeconfig updates.

#### Acessing services created inside the cluster

If you are creating ingresses explicitly in your manifests without a specific IngressClass. Uffizzi will dynamically set a hostname for all such ingresses created inside the ephemeral cluster environment. The naming of the ingress follows the convention as follows

```
<ingress-name>-<virtual-namespace>-<virtual-cluster-name>.<host-namespace>.uclusters.app.uffizzi.com
```

This allows us to keep the let users have easy access to their services through the ingress while keeping a more deterministic naming convention for the hostname without any extra configuraiton required to set up the hostname.

### Creating and managing Docker Compose environments

Use the `preview` command to create an ephemeral environment from a Docker Compose configuration.

!!! Note
    Uffizzi supports a subset of the of the complete [Compose specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md). Uffizzi also requires some additional configuration that is not included in the Compose specification, most notably an `ingress` definition. See the [Uffizzi Compose File Reference](references/compose-spec.md) for more detail on what is required for your `docker-compose.uffizzi.yml` file. For help writing this file or for using it in CI pipelines to create pull request environments, see [this guide](docker-compose-environment.md).

&nbsp;  
**Create a Docker Compose preview environment**

In the following example, we pass a `docker-compose.uffizzi.yml` from our local development environment. This command will create a preview environment for this compose file in the default account and project. 

``` bash
uffizzi preview create docker-compose.uffizzi.yml
```

!!! Important
    The Uffizzi client **does not** build containers for you from your local environment even if your environment includes a `DOCKERFILE`. Instead, you should execute a build step first, and then add images in your Docker Compose configuration (i.e. use the `image` directive instead of the `build` directive). Uffizzi Cloud customers can use [Uffizzi CI](references/uffizzi-ci.md) if they want Uffizzi to build container images from source, or you can use another build service like GitHub Actions or GitLab CI. You can learn more about Uffizzi CI [here](references/uffizzi-ci.md).

&nbsp;  
**Add metadata labels**

You can add metadata labels to any preview using the `--set-labels` option:

``` bash
uffizzi preview create docker-compose.uffizzi.yml \
  --set-labels="github.repo=my_repo github.pull_request.number=23"
```

## From a CI Pipeline

In addition to creating environments from the Uffizzi client, you can configure a CI service to automatically deploy new environments for certain events, like pull or merge requests.

### GitHub Actions examples

#### Virtual cluster environment

Create a virtual cluster environment from a GitHub Actions workflow with the Uffizzi [Cluster Action](https://github.com/UffizziCloud/cluster-action). This action creates/updates/deletes a Uffizzi virtual cluster every time a pull request is opened, updated, or closed.

Start by forking the [quickstart-k8s](https://github.com/UffizziCloud/quickstart-k8s) repository on GitHub. Be sure to uncheck the option **Copy the `main` branch only**. This ensures that the `try-uffizzi` branch will be included in your fork.  

Enable GitHub Actions workflows for your fork by selecting **Actions**, then select **I understand my workflows, go ahead and enable them**. GitHub Actions is free for public repositories.   

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191074124-8ace8e9f-4970-46e5-9418-0f18d30bd08c.png" width="800">  
</details>

&nbsp;  
Open a pull request for `try-uffizzi` branch against `main` in your fork. Be sure that you're opening a PR on the branches of _your fork_ (i.e. `your-account/main` ← `your-account/try-uffizzi`). If you try to open a PR for `UffizziCloud/main` ← `your-account/try-uffizzi`, the Actions workflow will not run in this example.   

&nbsp;  
**What to expect**

The PR will trigger a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart-k8s/blob/main/.github/workflows/uffizzi.yml) that uses the Uffizzi client and Kubernetes manifests to create a Uffizzi ephemeral environment for the [microservices application](#architecture-of-this-example-app) defined by the repo. When the workflow completes, the ephemeral environment URL will be posted as a comment in your PR issue.

&nbsp;  
**How it works**

Ephemeral environments are configured with [Kubernetes manifests](manifests/) that describe the application components and a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart-k8s/blob/main/.github/workflows/uffizzi.yml) that includes a series of jobs triggered by a `pull_request` event and subsequent `push` events:

1. [Build and push the voting-app images](https://github.com/UffizziCloud/quickstart-k8s/blob/fc27d539d98fd602039a4259cafe9dd2ccf65dc5/.github/workflows/reusable.yml#L11C1-L90C28)
2. [Create the Uffizzi cluster using the uffizzi-cli](https://github.com/UffizziCloud/quickstart-k8s/blob/fc27d539d98fd602039a4259cafe9dd2ccf65dc5/.github/workflows/reusable.yml#L92C1-L102C22)
3. [Apply the Kubernetes manifests to deploy the application to the Uffizzi cluster](https://github.com/UffizziCloud/quickstart-k8s/blob/c6123e3510e69a9433398eeb59482d19b920fcee/.github/workflows/create-ucluster.yaml#L114C1-L125C73)
4. [Delete the Ephemeral Environment when the PR is merged/closed or after](https://github.com/UffizziCloud/quickstart-k8s/blob/fc27d539d98fd602039a4259cafe9dd2ccf65dc5/.github/workflows/uffizzi-cluster.yaml#L143C1-L153C54)

&nbsp;  
#### Docker Compose environment

Create a Docker Compose environment using the [Preview Environments Action](https://github.com/marketplace/actions/preview-environments). This action creates/updates/deletes an ephemeral Docker Compose environment every time a pull request is opened, updated, or closed.

Start by forking the [quickstart](https://github.com/UffizziCloud/quickstart) repository on GitHub. Be sure to uncheck the option **Copy the `main` branch only**. This ensures that the `try-uffizzi` branch will be included in your fork.  

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191072997-94fdc9cc-2be2-4b44-900f-d4507c6df8a6.png" width="800">  
</details>

&nbsp;  
Enable GitHub Actions workflows for your fork by selecting **Actions**, then select **I understand my workflows, go ahead and enable them**. GitHub Actions is free for public repositories.   

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191074124-8ace8e9f-4970-46e5-9418-0f18d30bd08c.png" width="800">  
</details>

&nbsp;  
Open a pull request for `try-uffizzi` branch against `main` in your fork. Be sure that you're opening a PR on the branches of _your fork_ (i.e. `your-account/main` ← `your-account/try-uffizzi`). If you try to open a PR for `UffizziCloud/main` ← `your-account/try-uffizzi`, the Actions workflow will not run in this example. 

<details><summary>Click to expand</summary>
<img alt="uffizzi-bot" src="https://user-images.githubusercontent.com/7218230/191825295-50422b35-23ac-47f6-8a22-c67f95c89d8c.png" width="800">  
</details>

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

Running this workflow will create a [Uffizzi Cloud](https://uffizzi.com) account and project from your GitHub user and repo information, respectively, if they do not already exits. If you sign in to the [Uffizzi Dashboard](https://app.uffizzi.com/sign_in) you can view logs, password protect your previews, manage projects and team members, set role-based access controls, and configure single-sign on (SSO).

### GitLab CI examples

#### Docker Compose environment

Create a Docker Compose environment from a GitLab CI pipleine.

Start by forking the the [quickstart](https://gitlab.com/uffizzicloud/quickstart-gitlab-ci) repository on GitLab. From the project home page, select **Fork**, then choose a namespace and project slug. Select **Fork project**.

<details><summary>Click to expand</summary>
<img src="../assets/images/quickstart-gitlab-fork-1.png" width="800">
<hr>
<img src="../assets/images/quickstart-gitlab-fork-2.png" width="800">  
</details>

&nbsp;  
Ensure GitLab CI/CD is enabled for your project. If you don't see the **Build > Pipelines** option in left sidebar, following [these steps](https://docs.gitlab.com/ee/ci/enable_or_disable_ci.html#enable-cicd-in-a-project) to enable it.

<details><summary>Click to expand</summary>
<img src="../assets/images/quickstart-gitlab-build-pipelines.png" width="800">
</details>

&nbsp;   
Open a merge request (MR) for `try-uffizzi` branch against `master` in your fork.

:warning: Be sure that you’re opening the MR on the branches of _your fork_ (i.e. `your-account/master` ← `your-account/try-uffizzi`).

If you try to open a MR for `uffizzi/quickstart/~/tree/master` ← `your-account/~/tree/try-uffizzi`, the pipeline will not run in this example.

<details><summary>Click to expand</summary>
<img src="../assets/images/quickstart-gitlab-create-mr.png" width="800">
</details>

&nbsp;  
This will kick off a GitLab pipeline and the ephemeral environment URL will be dumped to `stdout` of the pipeline job. 

&nbsp;   
**What to expect**

The MR will trigger a pipeline defined in [`.gitlab-ci.yml`](https://gitlab.com/uffizzicloud/quickstart-gitlab-ci/-/blob/master/.gitlab-ci.yml) that creates a Uffizzi ephemeral environment for the microservices application defined by the repo. The ephemeral environment URL will be echoed to `stdout` of the `deploy_environment` Job. Look for the following line in the Job logs:

```
$ echo "Uffizzi Environment deployment details at URI:${UFFIZZI_CONTAINERS_URI}"
Uffizzi Environment deployment details at URI:https://app.uffizzi.com//projects/8526/deployments/27720/containers
```

This link will take you to the Uffizzi Dashboard where you can view application logs and manage your environments and team. The environment will be deleted when the MR is merged/closed or after 1 hour ([configurable](https://gitlab.com/uffizzicloud/quickstart-gitlab-ci/-/blob/master/docker-compose.uffizzi.yml#L7)).

You might also want to configure a new Job to post the URL as a comment to your MR issue or send a notification to Slack, MS Teams, etc. See our Slack notification example [here](https://gitlab.com/uffizzi/environment-action/-/blob/main/Notifications/slack.yml).

&nbsp;   
**How it works**

Ephemeral environments are configured with a [Docker Compose template](https://gitlab.com/uffizzicloud/quickstart-gitlab-ci/-/blob/master/docker-compose.uffizzi.yml) that describes the application components and a [GitLab CI pipeline](https://gitlab.com/uffizzicloud/quickstart-gitlab-ci/-/blob/master/.gitlab-ci.yml) that includes a series of jobs triggered by a `merge_request_event`:

1. [Build and push images to a container registry](https://gitlab.com/uffizzicloud/quickstart-gitlab-ci/-/blob/master/.gitlab-ci.yml#L14)
2. [Render a Docker Compose file from the Docker Compose template and the built images](https://gitlab.com/uffizzicloud/quickstart-gitlab-ci/-/blob/master/.gitlab-ci.yml#L56-76)
3. [Deploy the application to a Uffizzi ephemeral environment and echo the environment URL to the Job logs](https://gitlab.com/uffizzi/environment-action/-/blob/main/environment.gitlab-ci.yml#L30-76)
4. [Delete the environment](https://gitlab.com/uffizzi/environment-action/-/blob/main/environment.gitlab-ci.yml#L98-115)

!!! Tip
    Each ephemeral environment is available at a predictable URL which consists of `https://app.uffizzi.com/` appended with the GitLab merge request domain. For example:  
    `https://app.uffizzi.com/gitlab.com/{account}/{repo}/merge_requests/{merge-request-number}`.  

    You can make requests to specific endpoints by appending a route to the end of the URL. For example:  
    `https://app.uffizzi.com/gitlab.com/acme/example-app/pull/661/api/health`  

Running this workflow will create a [Uffizzi Cloud](https://uffizzi.com) account and project from your GitLab user and repo information, respectively. If you sign in to the [Uffizzi Dashboard](https://app.uffizzi.com/sign_in) you can view logs, password protect your environments, manage projects and team members, set role-based access controls, and configure single-sign on (SSO).
