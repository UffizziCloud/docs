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

## Create a new Uffizzi Workflow

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

## Define build jobs

For each of the application components define the various configurations required to build the application. For example, Replace build-foo and build-bar with your actual build job names and configurations:
   ```
   jobs:
     build-foo:
       ...
     build-bar:
       ...
   ```

## Deploy Uffizzi Cluster

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

If you're using GitLab CI, you can also integrate Uffizzi virtual cluster environments. Check out the [Example Configuration](https://gitlab.com/uffizzicloud/quickstart-k8s/-/blob/main/.gitlab-ci.yml) for GitLab CI integration details.

Now you're ready to harness the power of Uffizzi Virtual Cluster Environments within your CI/CD pipelines. If you have any questions or need assistance, feel free to reach out to our support team. Happy coding!