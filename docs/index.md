# Getting Started

Uffizzi is a platform for managing lightweight, ephemeral test environments. It is designed to integrate with any CI/CD system as a step in your pipeline. Example use cases include rapidly creating pull request environments, preview environments, release candidate environments, demo environments, and staging environments. Uffizzi also handles clean up, so your environments last only as long as you need them.

## Add Uffizzi to your CI pipeline

Uffizzi is typically added to the end of your CI pipeline after images have been built and pushed to a container registry. Alternatively, you can use Uffizzi CI if you want to let Uffizzi build and store images for you. In either case, Uffizzi will deploy your application images and manage the environments for you. This guide will walk you through the following steps:

1. Create a [Docker Compose template](docker-compose-template.md) that defines your application configuration.
2. Add a step to your CI pipeline that defines when and how environments are created, updated, and deleted.
3. Connect your pipeline to Uffizzi Cloud platform which will host and manage your environments.

## Next article

[Create a Docker Compose template](docker-compose-template.md)

