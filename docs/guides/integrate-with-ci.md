**Section 2 of 3**
# Integrate with your CI pipeline

In this section, we'll discuss how to integrate the Docker Compose template you created in the [previous section](docker-compose-template.md) with your CI pipeline. If you're using Uffizzi CI, there is no extra configuration required. You can skip to the [next section](configure-credentials.md).

If you're using an external CI provider, such as GitHub Actions, GitLab, or CircleCI, you will need to add a step to the end of your pipeline that will use Uffizzi to deploy your application to an on-demand Preview Environment. Exact instructions will vary by provider, so the GitHub Actions guide shown below should be used as a general outline if you're using a different provider. 

You can see a complete example workflow using GitHub Actions [here](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-previews.yml).

## <a id="cache-tags"></a>Output tags from your build step
 In this step, we'll add a few lines to the build job of our workflow to output the tags of our container images. Later, we'll use these tags in our compose file. In GitHub Actions, this can be done with [`outputs`](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#outputs-for-docker-container-and-javascript-actions), as highlighted below.

=== "GitHub Actions"

    ``` yaml title=".github/workflows/ci.yml" hl_lines="18 19 36 37 38 39 40"
    name: Build images and deploy with Uffizzi

    on:
      push:
        branches:
          - main
          - master
          - staging
          - qa
      pull_request:
        types: [opened,reopened,synchronize,closed]

    jobs:
      # Build and push app image
      build-app:
        name: Build and Push `app`
      runs-on: ubuntu-latest
      outputs:
        tags: ${{ steps.meta.outputs.tags }}
      steps:
        - name: Login to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
        - name: Checkout git repo
          uses: actions/checkout@v3
        - name: Docker metadata
          id: meta
          uses: docker/metadata-action@v3
          with:
            images: ghcr.io/${{ github.repository_owner }}/example-app
        - name: Build and Push Image to GitHub Container Registry
          uses: docker/build-push-action@v2
          with:
            push: true
            tags: ${{ steps.meta.outputs.tags }}
            labels: ${{ steps.meta.outputs.labels }}
            context: ./app
    
      [...]

    ```

## <a id="render-compose-from-cache"></a>Render and cache a new compose file

Recall that in the [previous section](docker-compose-template.md), we created a Docker Compose template (`docker-compose.uffizzi.yml`) that replaced our static image name with a variable, denoted in the example as `image: "${APP_IMAGE}"`. In this step, we'll set and export that variable using the `outputs` of the previous job. Additionally, we'll set and export our database secrets that [we configured in the preview section](docker-compose-template.md#secrets). 

Next, we'll use the common utility `envsubst` and shell I/O redirection (`<`, `>`) to render a new compose file that includes the image name literal. Finally, we store this rendered compose file in the [GitHub Actions cache](https://github.com/marketplace/actions/cache).

=== "GitHub Actions"

    ``` yaml title=".github/workflows/ci.yml" hl_lines="42-70"
    name: Build images and deploy with Uffizzi

    on:
      push:
        branches:
          - main
          - master
          - staging
          - qa
      pull_request:
        types: [opened,reopened,synchronize]

    jobs:
      # Build and push app image
      build-app:
        name: Build and Push `app`
      runs-on: ubuntu-latest
      outputs:
        tags: ${{ steps.meta.outputs.tags }}
      steps:
        - name: Login to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
        - name: Checkout git repo
          uses: actions/checkout@v3
        - name: Docker metadata
          id: meta
          uses: docker/metadata-action@v3
          with:
            images: ghcr.io/${{ github.repository_owner }}/example-app
        - name: Build and Push Image to GitHub Container Registry
          uses: docker/build-push-action@v2
          with:
            push: true
            tags: ${{ steps.meta.outputs.tags }}
            labels: ${{ steps.meta.outputs.labels }}
            context: ./app
    
      render-compose-file:
        name: Render Docker Compose File
        runs-on: ubuntu-latest
        needs: 
          - build-app
        outputs:
          compose-file-cache-key: ${{ steps.hash.outputs.hash }}
        steps:
          - name: Checkout git repo
            uses: actions/checkout@v3
          - name: Render Compose File
            run: |
              APP_IMAGE=$(echo ${{ needs.build-app.outputs.tags }})
              export APP_IMAGE
              PGUSER=${{ secrets.PGUSER }}
              export PGUSER
              PGPASSWORD=${{ secrets.PGPASSWORD }}
              export PGPASSWORD
              # Render simple template from environment variables.
              envsubst < docker-compose.template.yml > docker-compose.rendered.yml
              cat docker-compose.rendered.yml
          - name: Hash Rendered Compose File
            id: hash
            run: echo "::set-output name=hash::$(md5sum docker-compose.rendered.yml | awk '{ print $1 }')"
          - name: Cache Rendered Compose File
            uses: actions/cache@v3
            with:
              path: docker-compose.rendered.yml
              key: ${{ steps.hash.outputs.hash }}

      [...]
    ```

## <a id="reusable-workflow"></a>Pass rendered compose file from cache to the reusable workflow

Uffizzi publishes a GitHub Actions [reusable workflow](https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml) that can be used to create, update, and delete on-demand test environments given a compose file. This reusable workflow will spin up the Uffizzi CLI on a GitHub Actions runner, which then opens a connection to the Uffizzi platform. 

In this final step, we'll pass the cached compose file from the previous step to this reusable workflow. In response, Uffizzi will create a test environment, and post the environment URL as a comment to your pull request issue. This URL will also be available in your environment's containers as the [`UFFIZZI_URL`](../references/uffizzi-environment-variables.md) environment variable.

This workflow takes as input the following **required** parameters:  

  * `compose-file-cache-key`  
  * `compose-file-cache-path`  
  * `username` - Your Uffizzi username (See [next section](configure-credentials.md))  
  * `server` - `https://app.uffizzi.com` or your own Uffizzi API endpoint if you are self-hosting (See [next section](configure-credentials.md))  
  * `project` - A Uffizzi project ID (See [next section](configure-credentials.md))  
  * `password` - Your Uffizzi account password stored as a GitHub Actions secret (See [next section](configure-credentials.md))

Additionally, this workflow has a few **optional** parameters if you have configured password protection for your Uffizzi test environments. For instructions on configuring passwords, follow [this guide](password-protected.md).  

  * `url-username` - An HTTP username  
  * `url-password` - An HTTP password stored as a GitHub Actions secret  
  * `personal-access-token` - [Github personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with access to the `read:packages` scope. This parameter is required only if you use GitHub Container Registry (ghcr.io) to store images.  

=== "GitHub Actions"

    ``` yaml title=".github/workflows/ci.yml" hl_lines="72-108"
    name: Build images and deploy with Uffizzi

    on:
      push:
        branches:
          - main
          - master
          - staging
          - qa
      pull_request:
        types: [opened,reopened,synchronize]

    jobs:
      # Build and push app image
      build-app:[](http://127.0.0.1:8000/guides/networking/)
        name: Build and Push `app`
      runs-on: ubuntu-latest
      outputs:
        tags: ${{ steps.meta.outputs.tags }}
      steps:
        - name: Login to Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
        - name: Checkout git repo
          uses: actions/checkout@v3
        - name: Docker metadata
          id: meta
          uses: docker/metadata-action@v3
          with:
            images: ghcr.io/${{ github.repository_owner }}/example-app
        - name: Build and Push Image to GitHub Container Registry
          uses: docker/build-push-action@v2
          with:
            push: true
            tags: ${{ steps.meta.outputs.tags }}
            labels: ${{ steps.meta.outputs.labels }}
            context: ./app
    
      render-compose-file:
        name: Render Docker Compose File
        runs-on: ubuntu-latest
        needs: 
          - build-app
        outputs:
          compose-file-cache-key: ${{ steps.hash.outputs.hash }}
        steps:
          - name: Checkout git repo
            uses: actions/checkout@v3
          - name: Render Compose File
            run: |
              APP_IMAGE=$(echo ${{ needs.build-app.outputs.tags }})
              export APP_IMAGE
              PGUSER=${{ secrets.PGUSER }}
              export PGUSER
              PGPASSWORD=${{ secrets.PGPASSWORD }}
              export PGPASSWORD
              # Render simple template from environment variables.
              envsubst < docker-compose.template.yml > docker-compose.rendered.yml
              cat docker-compose.rendered.yml
          - name: Hash Rendered Compose File
            id: hash
            run: echo "::set-output name=hash::$(md5sum docker-compose.rendered.yml | awk '{ print $1 }')"
          - name: Cache Rendered Compose File
            uses: actions/cache@v3
            with:
              path: docker-compose.rendered.yml
              key: ${{ steps.hash.outputs.hash }}

      # Create and update test environments with Uffizzi
      deploy-uffizzi-preview:
        name: Use Remote Workflow to Preview on Uffizzi
        needs: render-compose-file
        uses: UffizziCloud/preview-action/.github/workflows/reusable.yaml@v2.1.0
        if: ${{ github.event_name == 'pull_request' && github.event.action != 'closed' }}
        with:
          compose-file-cache-key: ${{ needs.render-compose-file.outputs.compose-file-cache-key }}
          compose-file-cache-path: docker-compose.rendered.yml
          username: foo@example.com
          server: https://app.uffizzi.com
          project: my-application
        secrets:
          password: ${{ secrets.UFFIZZI_PASSWORD }}
          personal-access-token: ${{ secrets.GHCR_ACCESS_TOKEN }}
          url-username: admin
          url-password: ${{ secrets.URL_PASSWORD }}
        permissions:
          contents: read
          pull-requests: write

      # Delete test environments with Uffizzi
      delete-uffizzi-preview:
        name: Use Remote Workflow to Delete an Existing Preview
        uses: UffizziCloud/preview-action/.github/workflows/reusable.yaml@v2.1.0
        if: ${{ github.event_name == 'pull_request' && github.event.action == 'closed' }}
        with:
          compose-file-cache-key: ''
          compose-file-cache-path: docker-compose.rendered.yml
          username: foo@example.com
          server: https://app.uffizzi.com
          project: my-application
        secrets:
          password: ${{ secrets.UFFIZZI_PASSWORD }}
    permissions:
      contents: read
      pull-requests: write
    ```

See [the full documentation for this reusable workflow](https://github.com/UffizziCloud/preview-action/blob/master/README.md#workflow-inputs).

## Next article

[Configure credentials](configure-credentials.md)
