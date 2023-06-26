**Section 2 of 3**
# Integrate with your CI pipeline

In this section, we'll discuss how to integrate the Docker Compose template you created in the [previous section](docker-compose-template.md) with your CI pipeline. If you're using Uffizzi CI, there is no extra configuration required. You can skip to the [next section](configure-credentials.md).

If you're using an external CI provider, such as GitHub Actions, GitLab, or CircleCI, you will need to add a step to the end of your pipeline that will use Uffizzi to deploy your application to an on-demand Preview Environment. Exact instructions will vary by provider, so the GitHub Actions guide shown below should be used as a general outline if you're using a different provider. 

You can see a complete example workflow using GitHub Actions [here](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-preview.yaml).

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

## <a id="reusable-workflow"></a>Pass rendered compose file from cache to the reusable workflow

### GitHub Actions
Uffizzi publishes a GitHub Actions [reusable workflow](https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml) that can be used to create, update, and delete on-demand test environments given a rendered compose file. This reusable workflow will spin up the Uffizzi CLI on a GitHub Actions runner, which then opens a connection to the Uffizzi platform. 

In this final step, we'll pass the cached compose file from the previous step to this reusable workflow. In response, Uffizzi will create a test environment, and post the environment URL as a comment to your pull request issue. This URL will also be available in your environment's containers as the [`UFFIZZI_URL`](../references/uffizzi-environment-variables.md) environment variable.

This workflow takes as input the following **required** parameters:  

  * `compose-file-cache-key`  
  * `compose-file-cache-path`  
  * `server` - `https://app.uffizzi.com` or your own Uffizzi API endpoint if you are self-hosting (See [next section](configure-credentials.md))  

Additionally, this workflow has a few **optional** parameters if you have configured password protection for your Uffizzi test environments. For instructions on configuring passwords, follow [this guide](password-protected.md).  

  * `url-username` - An HTTP username  
  * `url-password` - An HTTP password stored as a GitHub Actions secret  
  * `personal-access-token` - [Github personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with access to the `read:packages` scope. This parameter is required only if you use GitHub Container Registry (ghcr.io) to store images.  

### GitLab CI

Uffizzi publishes an [environment action](https://gitlab.com/uffizzi/environment-action/-/blob/main/environment.gitlab-ci.yml) that can be used to create, update, and delete ephemeral environments given a rendered compose file. This action will spin up the Uffizzi CLI on a GitLab runner, which then opens a connection to the Uffizzi platform. Be sure to `include` this environment action in your `gitlab-ci.yml` as shown above:

```
include: "https://gitlab.com/uffizzi/environment-action/raw/main/environment.gitlab-ci.yml"
```

In this final step, we'll pass the cached compose file from the previous step to this environment action via GitLab environment variables. In response, Uffizzi will create a test environment, and generate a environment URL for your merge requests. This URL will also be available in your environment's containers as the [`UFFIZZI_URL`](../references/uffizzi-environment-variables.md) environment variable.

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

## Next article

[Configure credentials](configure-credentials.md)
