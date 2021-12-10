# Uffizzi Compose Specification v1

This document specifies the Uffizzi Compose file format used to define and preview multi-container applications using Uffizzi. A Uffizzi Compose file is a structured YAML format, similar to Docker Compose. Uffizzi Compose is based on [Compose version 3.9](https://docs.docker.com/compose/compose-file/compose-file-v3/), but it also includes additional parameters relevant to Continuous Previews. This document describes the required and optional parameters of Uffizzi Compose.

### Uffizzi Compose file  
The Uffizzi Compose file is a YAML file defining `services` (required) `continuous_previews`, and `ingress`. Other Compose top-level elements such as `configs`, `networks`, `version`, `volumes` and `secrets` are not currently supported. For a full comparison between Compose 3.9 and Uffizzi Compose see [Compose Support](#services-required).

#### Example Uffizzi Compose file
``` 
services:
  worker:
    build:
      context: https://github.com/UffizziCloud/example-voting-worker:main
      dockerfile: Dockerfile
    deploy:
      resources:
        limits:
          memory: 250M
  vote:
    image: uffizziqa.azurecr.io/example-voting-vote:latest
    deploy:
      resources:
        limits:
          memory: 250M
  result:
    image: uffizziqa.azurecr.io/example-voting-result:latest
  redis:
    image: redis:latest
  postgres:
    image: postgres:9.6
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    deploy:
      resources:
        limits:
          memory: 250M
  nginx:
    image: nginx:latest
    configs:
      - source: vote.conf
        target: /etc/nginx/conf.d

continuous_preview:
  deploy_preview_when_image_tag_is_created: true
  tag_pattern: foo-bar-*
  share_to_github: true

ingress:
  service: nginx
  port: 8080
```

### Uffizzi Compose Elements

|Top-level Element | Sub-level Element     | Required           | Notes          |
| ---------------- | --------------------- | ------------------ | -------------- |
| **services**       |                       | ✔︎                  |                |
|         | build                                  |                        |                                |
| | build: context                         | ✔︎                      | Required if **build** is specified; Expects a URL to a GitHub repository (e.g., `context: <repository_url>:<branch_name>`)  | 
| | build: dockerfile                      |                        | defaults to `./Dockerfile` |
| | command                                |                        |                                |   
| | configs                                |                        |                                |
| | configs: source                        | ✔︎                      | Required if **configs** is specified; Name of the configuration file |
| | configs: target                        | ✔︎                      | Required if **configs** is specified; Mount path within the container |
| | deploy                                 |                        |                                |
| | deploy: auto                           |                        | defaults to `true`; If true, Uffizzi will auto-deploy changes made to a git or image repository |
| | deploy: resources: limits: memory      |                        | defaults to `125M`; possible values: `125M`, `250M`, `500M`, `1000M`, `2000M`, `4000M` |
| | env_file                               |                        |                                |
| | environment                            |                        |                                |
| | image                                  |                        | Expects a URI to a container registry; Currently supports ACR, ECR, GCR, and Docker Hub; If no rve |
| **ingress**                  |           | ✔︎                      |                                 |
| | service                                | ✔︎                      | The service that should receive incoming HTTP/S traffic |
| | port                                   | ✔︎                      | The port the containerized service is listening on                               |
| **continuous_preview**    |                |                        |                                |
| | deploy_preview_when_image_tag_is_created |                      | `true` or `false`; When `true`, all new tags created for each **image** defined in the compose file will be deployed           |
| | deploy_preview_when_pull_request_is_opened |                    | `true` or `false`              |
| | delete_preview_when_pull_request_is_closed |                    | `true` or `false`              |
| | delete_preview_after                   |                        | Expects hours as an integer; Value is implicitly set to `72h` for previews triggered from new/updated image tag |
| | share_to_github                        |                        | `true` or `false`; This options shares preview URL to the GitHub pull request as a comment |



### Ingress (required)
Ingress exposes HTTPS routes from outside your preview environment to your application services. Ingress requires a `port` number.

### Continuous Preview (optional)
Continuous Previews (CP) are an automation-enabled best practice that encourages cross-functional teams to continuously collaborate during the development process by providing feedback on features that are still in progress. With CP, git topic branches are previewed using on-demand test environments before they are merged into a downstream branch. Continuous Previews settings are optional for Uffizzi Compose.

### Services (required)

As with Docker Compose, a Service is an abstract definition of a computing resource within an application which can be scaled/replaced independently from other components. Services are backed by a set of containers when deployed on Uffizzi.  See the following table for full support status of the Services sub-level elements:   



