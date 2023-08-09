# Create Docker Compose Environments from CI Pipelines

!!! Tip
    If this is your first time using Uffizzi, we recommend reading through [Using Uffizzi](using-uffizzi.md) to see examples of how Uffizzi is configured and managed.

## Overview of the process

Uffizzi is usually added to the end of your CI pipeline after images have been built and pushed to a container registry. Alternatively, you can use Uffizzi CI if you want to let Uffizzi build and store images for you. In either case, Uffizzi will deploy your application images and manage the environments for you. This guide will walk you through the following steps:

1. [Create a Docker Compose template](docker-compose-environment.md#create-a-docker-compose-template) - 
A template which defines your application configuration and is used as the basis for the Uffizzi Preview Environment.

2. [Add a preview step to your CI pipeline](docker-compose-environment.md#integrate-with-your-ci-pipeline) - 
This step defines the lifecycle of your Uffizzi Preview Environments.

3. [Configure credentials](docker-compose-environment.md#configure-credentials) - 
Add registry credentials to grant Uffizzi access to pull images.

## Create a Docker Compose template

In this section, we'll create a template using [Docker Compose](https://docs.docker.com/compose/compose-file/) that describes our application configuration.

!!! note
    Uffizzi supports a subset of the [Compose specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md). For a full list of supported keywords, see the [Uffizzi Compose file reference](references/compose-spec.md). 

### Configure your Compose to dynamically update image definitions
The Uffizzi environment creation step typically executes at the end of a CI pipeline after a series of steps that are triggered by an event, such as a pull request or new commit. If you don't have an existing CI solution, Uffizzi CI can build your application from source and store your container images for you (Note: Your source code must be stored in a GitHub repository to use Uffizzi CI). Alternatively, if you're using an external CI service, such as GitHub Actions or GitLab CI, you will need to tell Uffizzi where your images are stored and how to access them.

Each time your CI pipeline builds and pushes new images, Uffizzi needs access to them. This means that we need to dynamically update our compose file `service` definitions with the new image names and tags each time our pipeline runs. To do this, we'll follow one of two methods, depending on which CI solution you choose:

- **Uffizzi CI** - If you want to use Uffizzi CI, you can simply define a `build` context that points to your source code repository on GitHub and let Uffizzi handle building and tagging images and updating your Compose. See the [Uffizzi Compose file reference](references/compose-spec.md#build) for `build` and `context` details.

- **External CI** - If you're using an external CI provider such as GitHub Actions or GitLab CI, you can use variable substitution to pass the output from your CI build step, i.e. `image:tag`, to your Compose file `image` definition (See highlighted example below). This solution is discussed in detail in the [next section](#integrate-with-your-ci-pipeline).

=== "Uffizzi CI"

    ``` yaml hl_lines="3-5" title="docker-compose.uffizzi.yml"
    services:
      app:
        build:
          context: https://github.com/example/app
          dockerfile: Dockerfile
        environment:
          PGUSER: "postgres"
          PGPASSWORD: "postgres"
        deploy:
          resources:
            limits:
              memory: 250M

      db:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "postgres"
          POSTGRES_PASSWORD: "postgres"
    ```

=== "External CI (e.g. GitHub Action)"

    ``` yaml hl_lines="3" title="docker-compose.uffizzi.yml"
    services:
      app:
        image: "${APP_IMAGE}"    # Output of build step stored as environment variable
        environment:
          PGUSER: "${PGUSER}"
          PGPASSWORD: "${PGPASSWORD}"
        deploy:
          resources:
            limits:
              memory: 250M

      db:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "${PGUSER}"
          POSTGRES_PASSWORD: "${PGPASSWORD}"
    ```

### Define an Ingress for your application

Whether using Uffizzi CI or an external CI provider, Uffizzi needs to know which of your application services will receive incoming traffic. This "Ingress" is an HTTPS load balancer that will forward HTTP traffic to one of the defined `services`. Along with the service name, you must indicate on which port the target container is listening. The `ingress` must be defined within an `x-uffizzi` [extension field](https://docs.docker.com/compose/compose-file/compose-file-v3/#extension-fields) as shown in the example below:

``` yaml hl_lines="1-5" title="docker-compose.uffizzi.yml"
# This block tells Uffizzi which service should receive HTTP traffic.
x-uffizzi:
  ingress:
    service: app
    port: 80

# My application
services:
  app:
    image: "${APP_IMAGE}"    # Output of build step stored as environment variable
    environment:
      PGUSER: "${PGUSER}"
      PGPASSWORD: "${PGPASSWORD}"
    deploy:
      resources:
        limits:
          memory: 250M

  db:
    image: postgres:9.6
    environment:
      POSTGRES_USER: "${PGUSER}"
      POSTGRES_PASSWORD: "${PGPASSWORD}"
```
&nbsp;  

!!! Tip 
    If you need to expose multiple public routes for your application, see this article [Exposing multiple routes](guides/expose-multiple-routes.md).

### <a id="secrets"></a>Add secrets in your CI platform (optional)

You may also want to move sensitive information like credentials out of your Docker Compose file before commiting it to a remote repository. Most CI providers offer a way to store secrets and then reference them in the steps of your pipeline. To do this, we'll follow one of two methods, depending on which CI solution you choose:

- **Uffizzi CI** - If you want to use Uffizzi CI, you can create read-only secrets in the Uffizzi Dashboard web interface (this process is described in detail in the section [Configure Credentials](docker-compose-environment.md#configure-credentials.md)), then reference them using the `external` keyword, as shown below. For details on `secrets` and `external` configuration options, see the [Uffizzi Compose file reference](references/compose-spec.md#nested-secrets). 

- **External CI** - If you're using an external CI provider, you can store the secrets using your provider's interface and then reference them via variable substitution within an `environment` definition (See highlighted example below). This solution is discussed in detail in the [next section](#integrate-with-your-ci-pipeline).

<details><summary>GitHub Actions example</summary>
<p>In GitHub, navigate to your repository, then select <b>Settings</b> > <b>Secrets</b> > <b>Actions</b> > <b>New repository secret</b>. Alternatively, you can [use the GitHub CLI](https://cli.github.com/manual/gh_secret).</p>

<img src="../../assets/images/github-actions-secrets.png">
<hr>
<img src="../../assets/images/add-database-secrets.png">
<hr>
</details>

=== "Uffizzi CI"

    ``` yaml hl_lines="20-32" title="docker-compose.uffizzi.yml"
    # This block tells Uffizzi which service should receive HTTPS traffic
    x-uffizzi:
      ingress:
        service: app
        port: 80

    services:
      app:
        build:
          context: https://github.com/example/app
          dockerfile: Dockerfile
        secrets:
          - pg_user
          - pg_password
        deploy:
          resources:
            limits:
              memory: 250M

      db:
        image: postgres:9.6
        secrets:
          - pg_user
          - pg_password

      secrets:
        pg_user:
          external: true
          name: "POSTGRES_USER"
        pg_password:
          external: true
          name: "POSTGRES_PASSWORD"
    ```

=== "External CI (e.g. GitHub Actions)"

    ``` yaml hl_lines="20-22" title="docker-compose.uffizzi.yml"
    # This block tells Uffizzi which service should receive HTTPS traffic
    x-uffizzi:
      ingress:
        service: app
        port: 80

    services:
      app:
        image: "${APP_IMAGE}"    # Output of build step stored as environment variable
        environment:
          PGUSER: "${PGUSER}"
          PGPASSWORD: "${PGPASSWORD}"
        deploy:
          resources:
            limits:
              memory: 250M

      db:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "${PGUSER}"
          POSTGRES_PASSWORD: "${PGPASSWORD}"
    ```

### Commit your template to your repository

Once you're finished creating your Docker Compose template, commit it to your repository and push.

## Integrate with your CI pipeline

In this section, we'll discuss how to integrate the Docker Compose template you created in the previous section with your CI pipeline. If you're using Uffizzi CI, there is no extra configuration required. You can skip to the [next section](docker-compose-environment.md#configure-credentials).

If you're using an external CI provider, such as GitHub Actions, GitLab, or CircleCI, you will need to add a step to the end of your pipeline that will use Uffizzi to deploy your application to an on-demand Preview Environment. Exact instructions will vary by provider, so the GitHub Actions guide shown below should be used as a general outline if you're using a different provider. 

You can see a complete example workflow using GitHub Actions [here](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-preview.yaml).

### <a id="cache-tags"></a>Output tags from your build step
 In this step, we'll add a few lines to the build job of our workflow to output the tags of our container images. Later, we'll use these tags in our compose file. In GitHub Actions, this can be done with [`outputs`](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions#outputs-for-docker-container-and-javascript-actions), or in GitLab with `script`, as highlighted below.

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

=== "GitLab CI"

    ``` yaml hl_lines="20 21 36 42 48 54" title="docker-compose.uffizzi.yml"
    include:
      - "https://gitlab.com/uffizzi/environment-action/raw/main/environment.gitlab-ci.yml"
      - "https://gitlab.com/uffizzi/environment-action/raw/main/Notifications/slack.yml"
        
    variables:
      REGISTRY: registry.uffizzi.com/$CI_PIPELINE_ID
      TAG: latest
      VOTE_IMAGE: $REGISTRY/vote:$TAG
      WORKER_IMAGE: $REGISTRY/worker:$TAG
      RESULT_IMAGE: $REGISTRY/result:$TAG
      LOADBALANCER_IMAGE: $REGISTRY/loadbalancer:$TAG
      UFFIZZI_COMPOSE_FILE: docker-compose.rendered.yml
        
    .build_image: &build_image
      stage: build
      image: docker:latest
      rules:
        - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      script:
        - docker build -t $IMAGE $DOCKERFILE_PATH
        - docker push $IMAGE

    services:
      - docker:dind

    stages:
      - build
      - uffizzi_deploy
      - uffizzi_notification
      - uffizzi_delete

    build_vote:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./vote
      IMAGE: $VOTE_IMAGE

    build_worker:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./worker
      IMAGE: $WORKER_IMAGE

    build_result:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./result
      IMAGE: $RESULT_IMAGE

    build_loadbalancer:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./loadbalancer
      IMAGE: $LOADBALANCER_IMAGE
    ```

### <a id="render-compose-from-cache"></a>Render and cache a new compose file

Recall that in the previous section, we created a Docker Compose template (`docker-compose.uffizzi.yml`) that replaced our static image name with a variable, denoted in the example as `image: "${APP_IMAGE}"`. In this step, we'll set and export that variable using the `outputs` of the previous job. Additionally, we'll set and export our database secrets that [we configured in the preview section](docker-compose-environment.md#add-secrets-in-your-ci-platform-optional). 

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

=== "GitLab CI"

    ``` yaml hl_lines="56-77" title="gitlab-ci.yml"
    include:
      - "https://gitlab.com/uffizzi/environment-action/raw/main/environment.gitlab-ci.yml"
      - "https://gitlab.com/uffizzi/environment-action/raw/main/Notifications/slack.yml"
        
    variables:
      REGISTRY: registry.uffizzi.com/$CI_PIPELINE_ID
      TAG: latest
      VOTE_IMAGE: $REGISTRY/vote:$TAG
      WORKER_IMAGE: $REGISTRY/worker:$TAG
      RESULT_IMAGE: $REGISTRY/result:$TAG
      LOADBALANCER_IMAGE: $REGISTRY/loadbalancer:$TAG
      UFFIZZI_COMPOSE_FILE: docker-compose.rendered.yml
        
    .build_image: &build_image
      stage: build
      image: docker:latest
      rules:
        - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      script:
        - docker build -t $IMAGE $DOCKERFILE_PATH
        - docker push $IMAGE

    services:
      - docker:dind

    stages:
      - build
      - uffizzi_deploy
      - uffizzi_notification
      - uffizzi_delete

    build_vote:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./vote
      IMAGE: $VOTE_IMAGE

    build_worker:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./worker
      IMAGE: $WORKER_IMAGE

    build_result:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./result
      IMAGE: $RESULT_IMAGE

    build_loadbalancer:
    <<: *build_image
    variables:
      DOCKERFILE_PATH: ./loadbalancer
      IMAGE: $LOADBALANCER_IMAGE

    render_compose_file:
      stage: build
      image: alpine:latest
      rules:
        - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      before_script:
        - apk add --no-cache gettext
      script:
        - envsubst < ./docker-compose.uffizzi.yml > ./$UFFIZZI_COMPOSE_FILE
        - echo "$(md5sum $UFFIZZI_COMPOSE_FILE | awk '{ print $1 }')"
        - cat $UFFIZZI_COMPOSE_FILE
        - echo $CI_PIPELINE_SOURCE
        - echo $CI_COMMIT_BRANCH
        - echo $CI_MERGE_REQUEST_SOURCE_BRANCH_NAME
        - echo $CI_ENVIRONMENT_ACTION
        - echo $CI_COMMIT_REF_NAME
        - echo $CI_COMMIT_REF_SLUG
      artifacts:
        name: "$CI_JOB_NAME"
        paths:
          - ./$UFFIZZI_COMPOSE_FILE
    ```

### <a id="reusable-workflow"></a>Pass rendered compose file from cache to the reusable workflow

#### GitHub Actions
Uffizzi publishes a GitHub Actions [reusable workflow](https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml) that can be used to create, update, and delete on-demand test environments given a rendered compose file. This reusable workflow will spin up the Uffizzi CLI on a GitHub Actions runner, which then opens a connection to the Uffizzi platform. 

In this final step, we'll pass the cached compose file from the previous step to this reusable workflow. In response, Uffizzi will create a test environment, and post the environment URL as a comment to your pull request issue. This URL will also be available in your environment's containers as the [`UFFIZZI_URL`](references/uffizzi-environment-variables.md) environment variable.

This workflow takes as input the following **required** parameters:  

  * `compose-file-cache-key`  
  * `compose-file-cache-path`  
  * `server` - `https://app.uffizzi.com` or your own Uffizzi API endpoint if you are self-hosting (See [next section](docker-compose-environment.md#configure-credentials.md))  

Additionally, this workflow has a few **optional** parameters if you have configured password protection for your Uffizzi test environments. For instructions on configuring passwords, follow [this guide](guides/password-protected.md).  

  * `url-username` - An HTTP username  
  * `url-password` - An HTTP password stored as a GitHub Actions secret  
  * `personal-access-token` - [Github personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with access to the `read:packages` scope. This parameter is required only if you use GitHub Container Registry (ghcr.io) to store images.  

#### GitLab CI

Uffizzi publishes an [environment action](https://gitlab.com/uffizzi/environment-action/-/blob/main/environment.gitlab-ci.yml) that can be used to create, update, and delete ephemeral environments given a rendered compose file. This action will spin up the Uffizzi CLI on a GitLab runner, which then opens a connection to the Uffizzi platform. Be sure to `include` this environment action in your `gitlab-ci.yml` as shown above:

```
include: "https://gitlab.com/uffizzi/environment-action/raw/main/environment.gitlab-ci.yml"
```

In this final step, we'll pass the cached compose file from the previous step to this environment action via GitLab environment variables. In response, Uffizzi will create a test environment, and generate a environment URL for your merge requests. This URL will also be available in your environment's containers as the [`UFFIZZI_URL`](references/uffizzi-environment-variables.md) environment variable.

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

      # Create and update test environments with Uffizzi
      deploy-uffizzi-preview:
        name: Use Remote Workflow to Preview on Uffizzi
        needs: render-compose-file
        uses: UffizziCloud/preview-action/.github/workflows/reusable.yaml@v2.1.0
        if: ${{ github.event_name == 'pull_request' && github.event.action != 'closed' }}
        with:
          compose-file-cache-key: ${{ needs.render-compose-file.outputs.compose-file-cache-key }}
          compose-file-cache-path: docker-compose.rendered.yml
          server: https://app.uffizzi.com
        secrets:
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
          server: https://app.uffizzi.com
    permissions:
      contents: read
      pull-requests: write
    ```

=== "GitLab CI"

    ``` yaml hl_lines="47" title="https://gitlab.com/uffizzi/environment-action/-/blob/main/environment.gitlab-ci.yml"
    # Add the following variables to your project:
    # optional:
    #  - UFFIZZI_SERVER (Uffizzi server URL)
    #  - UFFIZZI_COMPOSE_FILE (Uffizzi compose file name)
    # Include this pipeline in your project
    # Add the following stages to your project:
    #  - uffizzi_deploy
    #  - uffizzi_delete

    variables:
      UFFIZZI_IMAGE: uffizzi/cli:v1
      UFFIZZI_CURL_IMAGE: apteno/alpine-jq:2022-09-04
      UFFIZZI_SERVER: https://app.uffizzi.com
      UFFIZZI_COMPOSE_FILE: docker-compose.yml
      UFFIZZI_DEPLOY_ENV_FILE: deploy.env
      CURL_RETRY: 5
      CURL_RETRY_DELAY: 0
      CURL_RETRY_MAX_TIME: 60
      OIDC_TOKEN: $CI_JOB_JWT
      ACCESS_TOKEN: $CI_JOB_TOKEN

    deploy_environment:
      stage: uffizzi_deploy
      image:
        name: $UFFIZZI_IMAGE
        entrypoint: [ "" ]
      rules:
        - if: $CI_MERGE_REQUEST_ID
      before_script: []
      script:
        - echo "Checking if environment exists"
        - | # Check if environment exists and update if it does
          export OIDC_TOKEN=$OIDC_TOKEN
          export ACCESS_TOKEN=$ACCESS_TOKEN
          if UFFIZZI_ENVIRONMENT_ID=$(/root/docker-entrypoint.sh preview list --filter "gitlab.repo=$CI_PROJECT_PATH gitlab.merge_request.number=$CI_MERGE_REQUEST_IID" | grep deployment-); then
            if test "$( wc -l <<< "$UFFIZZI_ENVIRONMENT_ID" )" -gt 1; then
              echo "More than one preview found"
              exit 1
            fi
            echo "Updating environment $UFFIZZI_ENVIRONMENT_ID"
            ACTION=updated
            OUTPUT=$(/root/docker-entrypoint.sh preview update $UFFIZZI_ENVIRONMENT_ID $UFFIZZI_COMPOSE_FILE --output=json --set-labels "gitlab.repo=$CI_PROJECT_PATH gitlab.merge_request.number=$CI_MERGE_REQUEST_IID" | tail -n 1)
          else
            echo "$UFFIZZI_ENVIRONMENT_ID"
            echo "Creating new preview"
            ACTION=deployed
            OUTPUT=$(/root/docker-entrypoint.sh preview create $UFFIZZI_COMPOSE_FILE --output=json --creation-source=gitlab_actions --set-labels "gitlab.repo=$CI_PROJECT_PATH gitlab.merge_request.number=$CI_MERGE_REQUEST_IID" | tail -n 1)
            UFFIZZI_ENVIRONMENT_ID=$(echo $OUTPUT | grep -Eo '"id"[^,]*' | cut -d '"' -f4)
          fi
        - UFFIZZI_ENVIRONMENT_URL=$(echo $OUTPUT | grep -Eo '"url"[^,]*' | cut -d '"' -f4)
        - UFFIZZI_PROXY_URL=$(echo $OUTPUT | grep -Eo '"proxy_url"[^,]*' | cut -d '"' -f4)
        - UFFIZZI_CONTAINERS_URI=$(echo $OUTPUT | grep -Eo '"containers_uri"[^,]*' | cut -d '"' -f4)
        - echo "ACTION=$ACTION" >> $UFFIZZI_DEPLOY_ENV_FILE
        - echo "UFFIZZI_CONTAINERS_URI=$UFFIZZI_CONTAINERS_URI" >> $UFFIZZI_DEPLOY_ENV_FILE
        - echo "UFFIZZI_ENVIRONMENT_ID=$UFFIZZI_ENVIRONMENT_ID" >> $UFFIZZI_DEPLOY_ENV_FILE
        - echo "UFFIZZI_ENVIRONMENT_URL=$UFFIZZI_ENVIRONMENT_URL" >> $UFFIZZI_DEPLOY_ENV_FILE
        - echo "UFFIZZI_PROXY_URL=$UFFIZZI_PROXY_URL" >> $UFFIZZI_DEPLOY_ENV_FILE
        - echo "Uffizzi Environment ID:${UFFIZZI_ENVIRONMENT_ID}"
        - echo "Uffizzi Environment ${ACTION} at URL:${UFFIZZI_PROXY_URL}"
        - echo "Uffizzi Environment deployment details at URI:${UFFIZZI_CONTAINERS_URI}"
      environment:
        name: "uffizzi/MR-${CI_MERGE_REQUEST_IID}"
        url: $UFFIZZI_PROXY_URL
        action: start
        on_stop: delete_environment
      artifacts:
        reports:
          dotenv: $UFFIZZI_DEPLOY_ENV_FILE

    healthcheck_environment:
      stage: uffizzi_deploy
      image: $UFFIZZI_CURL_IMAGE
      needs:
        - deploy_environment
      rules:
        - if: $CI_MERGE_REQUEST_ID
      before_script: []
      script:
        - echo "Healthchecking environment $UFFIZZI_ENVIRONMENT_ID"
        - | # Wait for the environment to be healthy. If URL_USERNAME are set, we will use basic auth.
          if test -z "$UFFIZZI_URL_USERNAME"; then
            curl --retry $CURL_RETRY --retry-delay $CURL_RETRY_DELAY --retry-max-time $CURL_RETRY_MAX_TIME --silent --show-error --fail $UFFIZZI_PROXY_URL > /dev/null
          else
            curl -u "$UFFIZZI_URL_USERNAME:$UFFIZZI_URL_PASSWORD" --retry $CURL_RETRY --retry-delay $CURL_RETRY_DELAY --retry-max-time $CURL_RETRY_MAX_TIME --silent --show-error --fail $UFFIZZI_PROXY_URL > /dev/null
          fi
      environment:
        name: "uffizzi/MR-${CI_MERGE_REQUEST_IID}"
        url: $UFFIZZI_PROXY_URL

    delete_environment:
      stage: uffizzi_delete
      image:
        name: $UFFIZZI_IMAGE
        entrypoint: [ "" ]
      needs:
        - deploy_environment
      rules:
        - if: $CI_MERGE_REQUEST_ID
          when: manual
        - if: $CI_MERGE_REQUEST_TARGET_BRANCH_NAME == $CI_DEFAULT_BRANCH
      before_script: []
      script:
        - echo "$UFFIZZI_ENVIRONMENT_ID deleted"
        - /root/docker-entrypoint.sh preview delete $UFFIZZI_ENVIRONMENT_ID
      environment:
        name: "uffizzi/MR-${CI_MERGE_REQUEST_IID}"
        action: stop
    ```

See [the full documentation for this reusable workflow](https://github.com/UffizziCloud/preview-action/blob/master/README.md#workflow-inputs).

## Configure credentials

In this section, we'll create a Uffizzi Cloud account and connect it with your CI provider.

### **Uffizzi CI**

If you're using Uffizzi CI, you will need to link to the Docker Compose template in your GitHub repository from the Uffizzi Dashboard. If you haven't already done so, sign up at [Uffizzi Cloud](https://app.uffizzi.com/sign_up), and then follow the steps to set up your account.

<details><summary>1. Connect the Uffizzi GitHub App</summary>
<p>In this step you will install the Uffizzi GitHub App and grant Uffizzi access to the repositories you want to deploy. Login to Uffizzi, then navigate to <b>Account</b> > <b>Settings</b> > <b>General</b>, then select <b>Configure</b> next to the GitHub option.
</p>
<img src="../../assets/images/configure-github-app.png">  
<hr>
<p>You'll be asked to Install Uffizzi Cloud, then grant access to your repositories.</p>
<hr>
<img src="../../assets/images/repos.png">
<hr>
<p>Similarly, you can manage the Uffizzi app installation from GitHub by navigating to <b>Settings</b> > <b>Applications</b> > <b>Uffizzi Cloud</b> > <b>Configure</b></p>
<img src="../../assets/images/github-apps-configure.png">
<hr>
</details>

If the Docker Compose template you created in <a href="../docker-compose-template">Section 1</a> references images stored in a private container registry, add those credentials in this step, as indicated in the screenshot below:

<details><summary>2. Add application secrets</summary>
<p>If your compose file includes [application secrets](https://docs.uffizzi.com/references/compose-spec/#secrets), such as database credentials, you can add them in the Uffizzi Dashboard. Navigate to your project, then select <b>Specs</b> > <b>Secrets</b> > <b>NEW SECRET</b>. This will open a modal, where you can input your secrets as <code>NAME=VALUE</code> pairs. Be sure to add one secret per line, separatedy by <code>=</code> with no white spaces.
</p>
<img src="../../assets/images/settings-secrets.png">  
<hr>
<img src="../../assets/images/add-secrets.png">  
<hr>
<p>Once the secrets are saved, you will not be able to view or edit their values. To make changes to a secret, first delete the old secret, then create a new one.
</details>

<details><summary>3. Link to your Docker Compose template</summary>
<p>In this final step, we'll link to our Docker Compose template that's stored in our GitHub repository. To do this, navigate to your project, then select <b>Specs</b> > <b>Compose</b> > <b>NEW COMPOSE</b>. Next, select the repository, branch (typically this is the branch you open pull requests against), and name of the compose file. Finally, select <b>VALIDATE & SAVE</b>.
</p>
<img src="../../assets/images/settings-compose-file.png"> 
<hr>
<p>Note, if you did not add your secrets as described in the previous step, you will see a validation error with a link to add your secretes.</p>
<img src="../../assets/images/settings-compose-resolve-errors.png">  
<hr>
<p>Once your compose file has been successfully added, you will see it in the Uffizzi Dashboard with a link to its source on GitHub. Any changes you make to this compose file on GitHub will be synced in the Uffizzi Dashboard.</p>
<img src="../../assets/images/settings-compose-synced.png">
<hr>
</details>

That's it! Uffizzi is now configured with your Docker Compose template. To test your setup, you can manually deploy your primary branch to an on-demand test environment using the **Test Compose** button in the Uffizzi Dashboard, or try opening a pull request on GitHub to deploy a feature branch.

### **Connect container registy credentials to Uffizzi**

Follow this section if you're using an external container registry, such as GHCR, ECR, or Docker Hub, to store your built images (i.e. You are not relying on Uffizz CI to storage images for you).

How you add container registry credentials to Uffizzi depends on your registry of choice.

#### GitHub Container Registry (ghcr.io)

<p>If you use GitHub Container Registry (ghcr.io), you will need to generate a <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token">GitHub personal access token</a> with access to the <code>read:packages</code> scope. Once this token is generated, <a href="https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository">add it as a GitHub repository secret</a>, then pass this value to the <a href="https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml">reusable workflow</a> using the <code>personal-access-token</code> parameter, as described in the <a href="#integrate-with-your-ci-pipeline">previous section</a>.</p>

``` yaml
    secrets:
      personal-access-token: ${{ secrets.GHCR_ACCESS_TOKEN }}
```

Once you've created a personal access token, you should add it in your Uffizzi Account Settings.

<details><summary>Add GHCR personal access token in Account Settings</summary>
Login to Uffizzi, then navigate to <b>Account</b> > <b>Settings</b> > <b>Registries</b>, then select <b>Configure</b> next to the GHCR option.</p>
<img src="../../assets/images/account-settings-registries.png">
<hr>
<img src="../../assets/images/ghcr-login.png">
<hr>
<p>Enter your GitHub username and personal access token, then select <b>Sign in to GitHub Container Registry</b>.
</details>

#### ECR, ACR, GCR, Docker Hub
If you use Amazon ECR, Azure Container Registry (ACR), Google Container Registry (GCR), or Docker Hub, you should add your credentials as [GitHub repository secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) or [GitLab masked CI/CD variables](https://docs.gitlab.com/ee/ci/variables/#mask-a-cicd-variable).

<details><summary>See this AWS ECR example</summary>
<p>If you use Amazon ECR, Azure Container Registry (ACR), Google Container Registry (GCR), or Docker Hub, you should add your credentials as <a href="https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository">GitHub repository secrets</a>. In the highlighted example below, <code>AWS_ACCESS_KEY_ID</code> and <code>AWS_SECRET_ACCESS_KEY</code> are used:</p>

    ``` yaml title=".github/workflows/ci.yml" hl_lines="15 16"
    [...]

    jobs:
      # Build and push app image
      build-app:
        name: Build and Push `app`
      runs-on: ubuntu-latest
      outputs:
        tags: ${{ steps.meta.outputs.tags }}
      steps:
        - name: Login to ECR
          uses: docker/login-action@v2
          with:
            registry: 263049488290.dkr.ecr.us-east-1.amazonaws.com
            username: ${{ secrets.AWS_ACCESS_KEY_ID }}
            password: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        - name: Checkout git repo
          uses: actions/checkout@v3
        - name: Docker metadata
          id: meta
          uses: docker/metadata-action@v3
          with:
            images: 263049488290.dkr.ecr.us-east-1.amazonaws.com/app
        - name: Build and Push Image to ECR
          uses: docker/build-push-action@v2
          with:
            push: true
            tags: ${{ steps.meta.outputs.tags }}
            labels: ${{ steps.meta.outputs.labels }}
            context: ./app
    
      [...]

    ```

<p>Now, we need to add these same credentials in the Uffizzi Dashboard. In <b>Step 3 of 4</b> of the account setup guide, you are asked to connect to various external services, as shown below. Select the <b>Sign in</b> option for your registry provider(s) of choice, then enter your credentials. For example, to add <code>AWS_ACCESS_KEY_ID</code> and <code>AWS_SECRET_ACCESS_KEY</code>, select <b>Sign in to Amazon Elastic Container Registry</b>.</p> 
<img src="../../assets/images/add-container-registry-credentials.png">
<hr>
<p>After account setup, you can make changes to your credentials by selecting <b>Menu</b> (three horizontal lines) > <b>Settings</b> > <b>Integrations</b> > <b>CONFIGURE/DISCONNECT</b>.</p>
<img src="../../assets/images/settings-integrations-container-registries.png">
<hr>
</details>

That's it! Your pipeline is now configured to use Uffizzi. To test your pipeline, try opening a new pull request.

### Suggested articles

* [Configure password-protected environments](guides/password-protected.md) 
* [`UFFIZZ_URL` environment variable](references/uffizzi-environment-variables.md)
* [Set up single sign-on (SSO)](guides/single-sign-on.md)
