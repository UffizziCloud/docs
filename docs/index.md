# Getting Started

## Introduction

Uffizzi is a platform for managing lightweight, ephemeral test environments. 
It is designed to integrate with any CI/CD system. Each time a pull request, new commit, or any other event triggers your CI pipeline, Uffizzi will deploy your changes to an ephemeral environment. 

## Use Cases

Rapidly create
* pull request environments
* previews environments
* release candidates environments
* demo environments
* staging environments

which are short-lived and purpose built.

## Add Uffizzi Environments to your CI pipeline

Uffizzi is usually added to the end of your CI pipeline after images have been built and pushed to a container registry. Alternatively, you can use Uffizzi CI if you want to let Uffizzi build and store images for you. In either case, Uffizzi will deploy your application images and manage the environments for you. This guide will walk you through the following steps:

1. [Create a Docker Compose template.](docker-compose-template.md)
This template defines your application configuration and is used as the basis for the Uffizzi Environment.

2. [Add a step for integrating Uffizzi enviroments to your CI pipeline.](integrate-with-ci.md)
This step defines the lifecycle of the Uffizzi environment.

3. [Connect your pipeline to Uffizzi Cloud platform to host and manage your environments.](connect-to-uffizzi-cloud.md)

## Next article

[Create a Docker Compose template](docker-compose-template.md)

