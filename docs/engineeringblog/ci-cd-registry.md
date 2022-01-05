# Continuous Previews with Bring Your Own Build 

If you're looking for a Full Stack Preview capability but want to bring your own CI/CD solution and Container Registry - keep reading.  In this blog I'll cover how Uffizzi gives users the ability to enable Tag-initiated Previews (aka Continuous Previews) by setting up a webhook in their registry and by using the Uffizzi tagging convention `uffizzi_request_*`. 

For this blog I'll be referencing GitLab + Azure's Container Registry (ACR) but the concepts apply to any CI/CD + Registry combination. We'll use an example Python application that fetches and renders weather forecasts from NOAA.

## Azure Container Registry

See our [ACR integration documentation](config/container-registry-integrations.md). You'll need the registry hostname, Application (client) ID, and Secret value for the next steps.

## GitLab CI/CD

You can see my example GitLab CI configuration file here: <https://gitlab.com/adam.d.vollrath/noaafetch/-/blob/d6f4874c96333632bd5d554e4fe2830e309bebb4/.gitlab-ci.yml>

Most of this is very standard. The `before_script` logs into Azure as a Service Principal before each Job. The `build` Job just builds a container image and pushes it to your ACR registry.

To integrate with Azure, you'll need to [define some CI/CD variables in your GitLab Project](https://docs.gitlab.com/ee/ci/variables/#add-a-cicd-variable-to-a-project). I used these:

- `AZURE_REGISTRY` - hostname of the Azure Container Registry, like `example.azurecr.io`
- `AZURE_SP` - UUID of an Azure Service Principal
- `AZURE_SP_PASSWORD` - password for the above Service Principal

Let's look at the last part of this file, the `Push merge_request` Job:

``` yaml hl_lines="10 11"
Push merge_request:
  variables:
    GIT_STRATEGY: none
  stage: push
  only:
    # We want this job to be run on Merge Requests only.
    - merge_requests
  script:
    - docker pull $AZURE_REGISTRY/$CI_PROJECT_NAME:$CI_COMMIT_SHA
    - docker tag $AZURE_REGISTRY/$CI_PROJECT_NAME:$CI_COMMIT_SHA $AZURE_REGISTRY/$CI_PROJECT_NAME:uffizzi_request_$CI_MERGE_REQUEST_IID
    - docker push $AZURE_REGISTRY/$CI_PROJECT_NAME:uffizzi_request_$CI_MERGE_REQUEST_IID
```

Notice the last two lines tag and push an image whose tag begins with `uffizzi_request_`. This is so Uffizzi can identify the new image is associated with a Merge Request.

## Uffizzi Continuous Previews

Lastly we'll add a `docker-compose.uffizzi.yml` file to our repository and configure Uffizzi to use it.
