#Getting Started

## TL;DR  
1. Copy your `docker-compose.yml` file
2. Paste the contents into a new file `docker-compose.uffizzi.yml`
3. Add the following Uffizzi-specific parameters to create a [Uffizzi Compose file](setup/compose-spec.md) - this is the foundation of your Preview Set Up:  
``` yaml title="docker-compose.uffizzi.yml"
services:
  ...

continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
  share_to_github: true

ingress:
  service:   # The service that receives incoming HTTPS traffic
  port:      # The port number the container is listening on
```

See [Uffizzi Compose Reference](config/compose-spec.md) for more details on writing your configuration or check out our [Examples](examples/example-compose.md).  When you've completed your specification go to [Set Up Previews](set-up-previews.md) to connect it to Uffizzi.

## Popular Links

* [Continuous Previews](continuous-previews.md)
* [Uffizzi Compose Specification v1](config/compose-spec.md)
* [Compose Examples](examples/example-compose.md)
* [Source Code Integrations](config/source-code-integrations)
* [Container Registry Integrations](config/container-registry-integrations)

## Overview

Uffizzi provides an off-the-shelf Continuous Previews capability that can support your entire application eco-system and is highly configurable.  You can define your Previews by extending `docker-compose.yml` or by using a GUI-based template - in either case you have the ability to define trigger-based previews based on either pull requests or via image tag updates.

When a developer is ready for their feature branch to be previewed they `git push` to remote then open a `pull request` for their feature branch which then triggers a preview of the stack as defined in `docker-compose-uffizzi.yml`.  Users have the option for Uffizzi to build from source and deploy or to deploy directly from one of several integrated image registries (Docker Hub, ACR, ECR, GCR).  

## Bring Your Own Build (BYOB) 
Uffizzi also offers a [BYOB or Tag-initiated](https://docs.uffizzi.com/set-up-previews/#bring-your-own-build-tag-based-trigger) option that enables users to leverage their own build process to trigger previews.  In this scenario images tagged `uffizzi_request_<#>` will initiate new previews.  In addition to being compatible with custom build processes this allows for users on Gitlab, Bitbucket, or other Version Control Systems to benefit from Uffizzi.


