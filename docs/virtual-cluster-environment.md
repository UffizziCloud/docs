# Create Virtual Cluster Environments from CI Pipelines

!!! Tip
    If this is your first time using Uffizzi, we recommend following the [Quickstart Guide](quickstart.md) and [Using Uffizzi](using-uffizzi.md) to see a preconfigured example of how Uffizzi is configured.

## GitHub Actions Instructions

Follow this example and our GitHub Actions:

- [Example Configuration](https://github.com/UffizziCloud/quickstart-k8s)  
- [Cluster Action](https://github.com/UffizziCloud/cluster-action)  
- [Setup Action](https://github.com/UffizziCloud/setup-action)  

### Overview of the process

This guide will walk you through the process of creating Uffizzi cluster (uCluster) environments using Continuous Integration (CI) pipelines with Uffizzi. uCluster environments provide an isolated and reproducible environment for your applications, allowing you to easily test and deploy your code in a controlled setting. We will leverage the power of Uffizzi to set up and manage these environments directly from your CI pipelines.

Adding the ability to create virtual cluster environments from you GitHub Actions workflow involves the following steps:

1. [Create a new Uffizzi Workflow](virtual-cluster-environment.md#create-a-new-uffizzi-workflow) - A file named `.github/workflows/uffizzi.yaml` in your repository and configure the workflow.

2. [Define build jobs](virtual-cluster-environment.md#define-build-jobs) - Build and push platform specific artifacts.

3. [Deploy Uffizzi Cluster](virtual-cluster-environment.md#deploy-uffizzi-cluster) - Create a uCluster with the application built in step 2.

For a more detailed example and additional configurations, refer to the [complete example](https://github.com/UffizziCloud/quickstart-k8s/blob/main/.github/workflows/uffizzi.yml) in the UffizziCloud repository.

### Create a new Uffizzi Workflow

In this section, we'll create a new GitHub workflow within the application repository -- Add a name, then define when it runs -- also provide the following permissions:
   ```
   name: Uffizzi Cluster Quickstart

   on:
     pull_request:
       types: [opened,reopened,synchronize,closed]

   permissions:
     contents: read
     pull-requests: write
     id-token: write
   ```

### Define build jobs

For each of the application components define the various configurations required to build the application. For example, Replace build-foo and build-bar with your actual build job names and configurations:
   ```
   jobs:
     build-foo:
       ...
     build-bar:
       ...
   ```

### Deploy Uffizzi Cluster

Create a cluster job within the workflow that utilizes the Uffizzi cluster-action. This job will deploy your application to the uCluster. Adjust the parameters as needed:
   ```
   uffizzi-cluster:
     name: Deploy to Uffizzi Virtual Cluster

     needs:
     - build-foo
     - build-bar

     if: ${{ github.event_name == 'pull_request' && github.event.action != 'closed' }}

     runs-on: ubuntu-latest

     steps:

     # Checkout the repository
     - name: Checkout
       uses: actions/checkout@v3

     # Create a uCluster with cluster-name as pr-number
     - name: Connect to Virtual Cluster
       uses: UffizziCloud/cluster-action@main
       with:
         cluster-name: pr-${{ github.event.pull_request.number }}

     # Edit manifests and Apply
     - name: Kustomize and Apply Manifests
       id: prev
       run: |
         # Change the image name to those just built and pushed.
         kustomize edit set image my-registry/image_name=${{ needs.build-vote.outputs.tags }}
         kustomize edit set image my-registry/image_name=${{ needs.build-vote.outputs.tags }}

         # Apply kustomized manifests to virtual cluster.
         kubectl apply --kustomize . --kubeconfig ./kubeconfig
   ```

## GitLab CI Instructions

### Introduction

This guide outlines how to integrate Uffizzi virtual cluster environments into your GitLab CI/CD pipelines. GitLab CI allows you to automate tasks triggered by events like pull requests, ensuring a smooth and consistent development and deployment process. Check out the [Example Configuration](https://gitlab.com/uffizzicloud/quickstart-k8s/-/blob/main/.gitlab-ci.yml) for GitLab CI integration details.

### Pipeline Stages

The GitLab pipeline consists of five main stages, each serving a specific purpose:
```yaml hl_lines="5-10" title=".gitlab-ci.yml"
...
services:
 ...

stages:
  - build
  - uffizzi_cluster_deploy
  - kustomize_apply
  - add_comment
  - uffizzi_cluster_delete
...
```

#### **Build**
The `build` stage handles the building and pushing of application images to a temporary Uffizzi registry. This stage ensures that your application components are packaged and ready for deployment.

#### **Uffizzi Cluster Deploy**
The `uffizzi_cluster_deploy` stage refers to the `deploy_cluster_environment` job, which is defined in the included `cluster.gitlab-ci.yml` file. This job is responsible for deploying a Uffizzi cluster environment for the merge request.

This job performs the following tasks:

- Checks if the environment already exists and updates it if necessary.
- Logs in to Uffizzi using identity tokens.
- Creates or updates the Uffizzi cluster environment for the merge request.
- Configures the Kubernetes cluster access.

```yaml hl_lines="1-2" title=".gitlab-ci.yml"
include:
  - "https://gitlab.com/uffizzicloud/cluster-action/raw/main/cluster.gitlab-ci.yml"
    
variables:
 ...
```

#### **Kustomize Apply** 
The `kustomize_apply` stage refers to the `kustomize_template` job within the `cluster.gitlab-ci.yml` file. This job applies Kubernetes customizations using kustomize and ensures that your application is configured correctly for the Uffizzi environment.

This job performs the following tasks:

- Downloads kubectl and kustomize.
- Repeats some of the steps from the uffizzi_cluster_deploy stage for authentication.
- Applies K8s manifests using kustomize.

```yaml title="cluster.gitlab-ci.yml"
.kustomize_template: &kustomize_template
  stage: kustomize_apply
  rules:
    - if: $CI_MERGE_REQUEST_ID
      ...
```

#### **Add Comment** 
The `add_comment` stage adds important Uffizzi cluster command details as comments to the merge request. This helps developers access and manage the Uffizzi cluster environment effectively.

#### **Uffizzi Cluster Delete** 
The `uffizzi_cluster_delete` stage deletes the Uffizzi cluster once the merge request is closed. This ensures that resources are cleaned up when they are no longer needed.

Now you're ready to harness the power of Uffizzi Virtual Cluster Environments within your CI/CD pipelines. If you have any questions or need assistance, feel free to reach out to our support team. Happy coding!