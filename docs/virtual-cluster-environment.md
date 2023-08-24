# Create Virtual Cluster Environments from CI Pipelines

!!! Warning
    This page is under construction. We hope to provide detailed instructions for creating virtual clusters from CI pipelines soon. In the meantime, you might find the links below helpful. Thank you for your patience.

!!! Tip
    If this is your first time using Uffizzi, we recommend following the [Quickstart Guide](quickstart.md) and [Using Uffizzi](using-uffizzi.md) to see a preconfigured example of how Uffizzi is configured.

## GitHub Actions Instructions

Follow this example and our GitHub Actions:

[Example Configuration](https://github.com/UffizziCloud/quickstart-k8s)  
[Cluster Action](https://github.com/UffizziCloud/cluster-action)  
[Setup Action](https://github.com/UffizziCloud/setup-action)  

### Overview of the process
Adding the ability to create virtual cluster environments from you GitHub Actions workflow involves the following steps:

1. Create a file `.github/workflows/uffizzi.yaml`
2. Give your workflow a name, then define when it runs:
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
3. Create build jobs for each of your application components:
   ```
   jobs:
     build-foo:
       ...
     build-bar:
       ...
   ```
4. Create a cluster job that uses the Uffizzi cluster action:
   ```
   uffizzi-cluster:
     name: Deploy to Uffizzi Virtual Cluster
     needs:
     - build-foo
     - build-bar
     if: ${{ github.event_name == 'pull_request' && github.event.action != 'closed' }}
     runs-on: ubuntu-latest
     steps:
     - name: Checkout
       uses: actions/checkout@v3

     - name: Connect to Virtual Cluster
       uses: UffizziCloud/cluster-action@main
       with:
         cluster-name: pr-${{ github.event.pull_request.number }}
         server: https://app.uffizzi.com
     - name: Kustomize and Apply Manifests
       id: prev
       run: |
         # Change the image name to those just built and pushed.
         kustomize edit set image my-registry/image_name=${{ needs.build-vote.outputs.tags }}
         kustomize edit set image my-registry/image_name=${{ needs.build-vote.outputs.tags }}

         if [[ ${RUNNER_DEBUG} == 1 ]]; then
           cat kustomization.yaml
           echo "`pwd`"
           echo "`ls`"
         fi

         # Apply kustomized manifests to virtual cluster.
         kubectl apply --kustomize . --kubeconfig ./kubeconfig
   ```
5. See the [rest of this example](https://github.com/UffizziCloud/quickstart-k8s/blob/def540ce9b404851436e10529957162fbcc400fc/.github/workflows/uffizzi.yml#L143-L229) for details 

## GitLab CI Instructions

[Example Configuration](https://gitlab.com/uffizzi/quickstart-k8s/-/blob/main/.github/workflows/uffizzi.yml)
