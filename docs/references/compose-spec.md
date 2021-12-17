# Uffizzi Compose Specification v1

This document specifies the Uffizzi Compose file format used to define and preview multi-container applications using Uffizzi. A Uffizzi Compose file is a structured YAML format, similar to Docker Compose. Uffizzi Compose is based on [Compose version 3.9](https://docs.docker.com/compose/compose-file/compose-file-v3/), but it also includes additional parameters relevant to Continuous Previews. This document describes the required and optional parameters of Uffizzi Compose.

### Uffizzi Compose file  
The Uffizzi Compose file is a YAML file defining `services` (required), `configs`, `continuous_previews`, and `ingress`. Other Compose top-level elements such as `networks`, `secrets`, `version`, and `volumes` are not currently supported. For a full comparison between Compose 3.9 and Uffizzi Compose see [Compose Support](#services-required).

``` yaml title="docker-compose.uffizzi.yml" 
services:

  worker:
    # Build an image from source
    build:
      context: https://github.com/example/example-voting-worker#main
      dockerfile: ./Dockerfile      # Relative path from root of remote repository

  vote:
    # Pull an image from ACR
    image: example.azurecr.io/example-voting-vote:latest
    deploy:
      resources:
        limits:
          memory: 250M              # Defaults to 125M

  result:
    # Pull an image from GCR
    image: gcr.io/example/example-result:latest

  redis:
    # If no registry is specified, defaults to hub.docker.com
    image: redis                    # Defaults to `latest` tag

  postgres:
    image: postgres:9.6
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres

  nginx:
    image: nginx:latest
    configs:
      - source: vote.conf
        target: /etc/nginx/conf.d/vote.conf

configs:
  vote-nginx-conf:
    file: ./configs/vote.conf       # Relative path from root of current repository

# Event-based triggers
continuous_preview:
  deploy_preview_when_image_tag_is_created: true
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
  share_to_github: true

# Defines which service should receive incoming HTTPS traffic
ingress:
  service: nginx
  port: 8080
```

### Services (required)
As with Docker Compose, a Service is an abstract definition of a computing resource within an application which can be scaled/replaced independently from other components. Services are backed by a set of containers when deployed on Uffizzi.

### Ingress (required)
Ingress exposes HTTPS routes from outside your preview environment to your application services. Ingress requires a `port` number.

### Configs (optional)  
Configs allow you to add configuration files to your applications. Files are expected to be in the same git repository as your compose file. All `file` paths are relative from the root of the current repository.  

You must explicitly grant access to configuration files per service using the `configs` element within the service definition. Uffizzi supports [Docker `config` short syntax](https://docs.docker.com/compose/compose-file/compose-file-v3/#configs) only.

### Continuous Preview (optional)
Continuous Previews (CP) are an automation-enabled best practice that encourages cross-functional teams to continuously collaborate during the development process by providing feedback on features that are still in progress. With CP, git topic branches are previewed using on-demand test environments before they are merged into a downstream branch. Continuous Previews settings are optional for Uffizzi Compose.

### Uffizzi Compose Elements
See the following table for full support status of the keys:


|Top-level Element       | Sub-level Element                            | Required | Notes                                                                                                                       |
| ---------------------- | -------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------- |
| **services**           |                                              | ✔︎        |                                                                                                                             |
|                        | build                                        |          |                                                                                                                             |
|                        | build: context                               | ✔︎        | Required if **build** is specified; Expects a URL to a GitHub repository (e.g., `context: <repository_url>:<branch_name>`) or a relative path in the current repository | 
|                        | build: dockerfile                            |          | defaults to `./Dockerfile`                                                                                                  |
|                        | command                                      |          |                                                                                                                             |   
|                        | configs                                      |          | Expects a list of sources with targets                                                                                      |
|                        | configs: source                              | ✔︎        | Required if **configs** is specified; A config name as defined in the top-level **config** definition                       |
|                        | configs: target                              | ✔︎        | Required if **configs** is specified; Mount path (including filename) within the container                                  |
|                        | deploy                                       |          |                                                                                                                             |
|                        | deploy: auto                                 |          | defaults to `true`; If true, Uffizzi will auto-deploy changes made to a git or image repository                             |
|                        | deploy: resources: limits: memory            |          | defaults to `125M`; possible values: `125M`, `250M`, `500M`, `1000M`, `2000M`, `4000M`                                      |
|                        | env_file                                     |          |                                                                                                                             |
|                        | environment                                  |          |                                                                                                                             |
|                        | image                                        |          | defaults to `latest` tag; Expects a URI to a container registry; Currently supports ACR, ECR, GCR, and Docker Hub                                     |
| **configs**            |                                              |          |                                                                                                                             |
|                        | file                                         | ✔︎        | Required if top-level `configs` is defined; The relative path to the config file                                            |
| **ingress**            |                                              | ✔︎        |                                                                                                                             |
|                        | service                                      | ✔︎        | The service that should receive incoming HTTP/S traffic                                                                     |
|                        | port                                         | ✔︎        | The port the containerized service is listening on                                                                          |
| **continuous_preview** |                                              |          |                                                                                                                             |
|                        | deploy_preview_when_image_tag_is_created     |          | `true` or `false`; When `true`, all new tags created for each **image** defined in the compose file will be deployed        |
|                        | deploy_preview_when_pull_request_is_opened   |          | `true` or `false`                                                                                                           |
|                        | delete_preview_when_pull_request_is_closed   |          | `true` or `false`                                                                                                           |
|                        | delete_preview_after                         |          | Expects hours as an integer; Value is implicitly set to `72h` for previews triggered from new/updated image tag             |
|                        | share_to_github                              |          | `true` or `false`; This options shares preview URL to the GitHub pull request as a comment                                  |
