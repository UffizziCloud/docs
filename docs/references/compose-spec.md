# Uffizzi Compose Specification v1

This document specifies the Uffizzi Compose file format used to define and preview multi-container applications using Uffizzi. A Uffizzi Compose file is a structured YAML format, similar to Docker Compose. Uffizzi Compose is based on [Compose version 3.9](https://docs.docker.com/compose/compose-file/compose-file-v3/), but it also includes additional parameters relevant to Continuous Previews. This document describes the required and optional parameters of Uffizzi Compose.

### Uffizzi Compose file  
The Uffizzi Compose file is a YAML file defining `services` (required) `continuous_previews`, and `ingress`. Other Compose top-level elements such as `configs`, `networks`, `version`, `volumes` and `secrets` are not currently supported. For a full comparison between Compose 3.9 and Uffizzi Compose see [Compose Support](# Services (required)).

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

| Compose Element                        | Required               | Notes                          |
| -------------------------------------- | ---------------------- | ------------------------------ |
| **services (Top-level)**               | ✔︎                      |                                |
| build                                  |                        |                                |
| build: context                         | ✔︎                      | Required if **build** is specified; Expects a URL to a GitHub repository (e.g., `context: <repository_url>:<branch_name>`)  | 
| build: dockerfile                      |                        | If no Dockerfile is specified, Uffizzi will attempt to build with buildpacks |
| command                                |                        |                                |   
| configs                                |                        |                                |
| configs: source                        | ✔︎                      | Required if **configs** is specified; Name of the configuration file |
| configs: target                        | ✔︎                      | Required if **configs** is specified; Mount path within the container |
| deploy                                 |                        |                                |
| deploy: auto                           |                        | defaults to `true`; If true, Uffizzi will auto-deploy changes made to a git or image repository |
| deploy: resources: limits: memory      |                        | defaults to `125M`; possible values: `125M`, `250M`, `500M`, `1000M`, `2000M`, `4000M` |
| env_file                               |                        |                                |
| environment                            |                        |                                |
| image                                  |                        | Expects a URI to a container registry; Currently supports ACR, ECR, GCR, and Docker Hub; If no rve |
| **continuous_preview (Top-level)**     |                        |                                |
| deploy_preview_when_image_tag_is_created |                      | `true` or `false`; When `true`, all new tags created for each **image** defined in the compose file will be deployed           |
| deploy_preview_when_pull_request_is_opened |                    | `true` or `false`              |
| delete_preview_when_pull_request_is_closed |                    | `true` or `false`              |
| delete_preview_after                   |                        | Expects hours as an integer; Value is implicitly set to `72h` for previews triggered from new/updated image tag |
| share_to_github                        |                        | `true` or `false`              |

### Ingress (required)


### Continuous Preview (optional)


### Services (required)

As with Docker Compose, a Service is an abstract definition of a computing resource within an application which can be scaled/replaced independently from other components. Services are backed by a set of containers when deployed on Uffizzi.  See the following table for full support status of the Services sub-level elements:   

#### Compatibility Matrix

| Compose Element                        | Uffizzi Compose Support Status |
| -------------------------------------- | ------------------------------ |
| **Services (Top-level)**               | Supported                      |
| deploy                                 | Supported                      |
| blkio_config                           | Unsupported (not planned)      |
| device_read_bps, device_write_bps      | Unsupported (not planned)      |
| device_read_iops, device_write_iops    | Unsupported (not planned)      |
| weight                                 | Unsupported (not planned)      |
| weight_device                          | Unsupported (not planned)      |
| cpu_count                              | Unsupported (not planned)      |
| cpu_percent                            | Unsupported (not planned)      |
| cpu_shares                             | Unsupported (not planned)      |
| cpu_period                             | Unsupported (not planned)      |
| cpu_quota                              | Unsupported (not planned)      |
| cpu_rt_runtime                         | Unsupported (not planned)      |
| cpu_rt_period                          | Unsupported (not planned)      |
| cpus                                   | Unsupported (not planned)      |
| cpuset                                 | Unsupported (not planned)      |
| build                                  | Supported                      |
| cap_add                                | Unsupported (not planned)      |
| cap_drop                               | Unsupported (not planned)      |
| cgroup_parent                          | Unsupported (not planned)      |
| command                                | Supported                      |
| configs                                | Supported                      |
| container_name                         | Unsupported (not planned)      |
| credential_spec                        | Unsupported (not planned)      |
| depends_on                             | Unsupported (planned)          |
| device_cgroup_rules                    | Unsupported (not planned)      |
| devices                                | Unsupported (not planned)      |
| dns                                    | Unsupported (not planned)      |
| dns_opt                                | Unsupported (not planned)      |
| dns_search                             | Unsupported (not planned)      |
| domainname                             | Unsupported (not planned)      |
| entrypoint                             | Unsupported (planned)          |
| env_file                               | Supported                      |
| environment                            | Supported                      |
| expose                                 | Unsupported (planned)          |
| extends                                | Unsupported (not planned)      |
| external_links                         | Unsupported (planned)          |
| extra_hosts                            | Unsupported (not planned)      |
| group_add                              | Unsupported (not planned)      |
| healthcheck                            | Unsupported (planned)          |
| hostname                               | Unsupported (planned)          |
| image                                  | Supported                      |
| init                                   | Unsupported (planned)          |
| ipc                                    | Unsupported (not planned)      |
| isolation                              | Unsupported (not planned)      |
| labels                                 | Unsupported (planned)          |
| isolation                              | Unsupported (not planned)      |
| links                                  | Unsupported (planned)          |
| logging                                | Unsupported (not planned)      |
| network_mode                           | Unsupported (not planned)      |
| networks                               | Unsupported (not planned)      |
| mac_address                            | Unsupported (not planned)      |
| mem_limit                              | Unsupported (not planned)      |
| mem_reservation                        | Unsupported (not planned)      |
| mem_swappiness                         | Unsupported (not planned)      |
| memswap_limit                          | Unsupported (not planned)      |
| oom_kill_disable                       | Unsupported (not planned)      |
| oom_score_adj                          | Unsupported (not planned)      |
| pid                                    | Unsupported (not planned)      |
| pids_limit                             | Unsupported (not planned)      |
| platform                               | Unsupported (not planned)      |
| ports                                  | Supported                      |
| privileged                             | Unsupported (not planned)      |
| profiles                               | Unsupported (not planned)      |
| pull_policy                            | Unsupported (not planned)      |
| read_only                              | Unsupported (not planned)      |
| restart                                | Unsupported (planned)          |
| runtime                                | Unsupported (not planned)      |
| scale                                  | Unsupported (planned)          |
| secrets                                | Unsupported (planned)          |
| security_opt                           | Unsupported (not planned)      |
| shm_size                               | Unsupported (not planned)      |
| stdin_open                             | Unsupported (not planned)      |
| stop_grace_period                      | Unsupported (not planned)      |
| stop_signal                            | Unsupported (not planned)      |
| storage_opt                            | Unsupported (not planned)      |
| sysctls                                | Unsupported (not planned)      |
| tmpfs                                  | Unsupported (not planned)      |
| tty                                    | Unsupported (not planned)      |
| ulimits                                | Unsupported (not planned)      |
| user                                   | Unsupported (not planned)      |
| userns_mode                            | Unsupported (not planned)      |
| volumes                                | Unsupported (planned)          |


