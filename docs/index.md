# Getting Started

## TL;DR  
1. Copy your `docker-compose.yml` file
2. Paste the contents into a new file `docker-compose.uffizzi.yml`
3. Add the following Uffizzi-specific parameters to create a [Uffizzi Compose file](config/compose-spec.md) - this is the foundation of your Preview Set Up:
``` yaml title="docker-compose.uffizzi.yml"
# Uffizzi extension
x-uffizzi:
  ingress: # required
    service: # the service that should receive http traffic
    port: # the port this service listens on
  continuous_preview:
    deploy_preview_when_pull_request_is_opened: true
    delete_preview_when_pull_request_is_closed: true
    share_to_github: true

services: . . .
```

See [Uffizzi Compose Reference](config/compose-spec.md) for more details on writing your configuration or check out our [Examples](examples/example-compose.md).  When you've completed your specification go to [Set Up Previews](set-up-previews.md) to connect it to Uffizzi.

## Popular Links

* [Continuous Previews](continuous-previews.md)
* [Uffizzi Compose Specification v1](config/compose-spec.md)
* [Compose Examples](examples/example-compose.md)
* [Add Continuous Previews to your Existing CI/CD](engineeringblog/ci-cd-registry.md)
* [Source Code Integrations](config/source-code-integrations)
* [Container Registry Integrations](config/container-registry-integrations)

## Overview

Uffizzi is a stand-alone tool that provides an off-the-shelf Full-Stack Previews capability that can support your entire application eco-system - from static sites to micro-services applications - and is highly configurable.  Uffizzi automatically creates and destroys on-demand or ephemeral cloud hosting environments that support your Full-Stack Preview.  You can define your Previews by extending `docker-compose.yml` which will give you the ability to define trigger-based previews based on either pull requests or via image tag updates.

When a developer is ready for their feature branch to be previewed they `git push` to remote then open a `pull request` for their feature branch which then triggers a Preview of the stack as defined in `docker-compose-uffizzi.yml`.  

*Users have the option for Uffizzi to build from source and deploy or to deploy directly from one of several integrated image registries (Docker Hub, ACR, ECR, GCR).*  

## Bring Your Own Build (BYOB) 
Uffizzi also offers a [BYOB or Tag-initiated](set-up-previews/#bring-your-own-build-tag-based-trigger) option that enables users to leverage their own build process via their CI/CD provider to trigger previews.  In this scenario images tagged `uffizzi_request_<#>` will initiate new previews.  In addition to being compatible with custom build processes this allows for users on Gitlab, Bitbucket, or other Version Control Systems to immediately benefit from Uffizzi.  Check out our blog [CI/CD + CP](engineeringblog/ci-cd-registry.md) for more details on how to enable this advanced feature.


