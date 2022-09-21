Uffizzi is usually added to the end of your CI pipeline after images have been built and pushed to a container registry. Alternatively, you can use Uffizzi CI if you want to let Uffizzi build and store images for you. In either case, Uffizzi will deploy your application images and manage the environments for you. This guide will walk you through the following steps:

1. [Create a Docker Compose template.](guides/docker-compose-template.md)
A template which defines your application configuration and is used as the basis for the Uffizzi Environment.

2. [Add a step to your CI Pipeline for integrating Uffizzi enviroments.](guides/integrate-with-ci.md)
This step defines the lifecycle of your Uffizzi Preview Environments.

3. [Configure credentials](guides/connect-to-uffizzi-cloud.md)
Offload your environment hosting and management to Uffizzi.

## Next article

[Create a Docker Compose template](guides/docker-compose-template.md)