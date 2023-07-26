# Set Up a Docker Compose Ephemeral Environment
!!! Tip
    If this is your first time using Uffizzi, we recommend following one of our quickstart guides ([GitHub Actions](quickstart-gha.md), [GitLab CI](quickstart-gitlab-ci.md), or [Uffizzi CI](quickstart-uffizzi-ci.md)) to see how Uffizzi is configured with an example application.

Uffizzi is usually added to the end of your CI pipeline after images have been built and pushed to a container registry. Alternatively, you can use Uffizzi CI if you want to let Uffizzi build and store images for you. In either case, Uffizzi will deploy your application images and manage the environments for you. This guide will walk you through the following steps:

1. [Create a Docker Compose template](guides/docker-compose-template.md) - 
A template which defines your application configuration and is used as the basis for the Uffizzi Preview Environment.

2. [Add a preview step to your CI pipeline](guides/integrate-with-ci.md) - 
This step defines the lifecycle of your Uffizzi Preview Environments.

3. [Configure credentials](guides/configure-credentials.md) - 
Add registry credentials to grant Uffizzi access to pull images.

## Next article

[Create a Docker Compose template](guides/docker-compose-template.md)