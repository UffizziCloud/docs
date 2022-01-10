# Uffizzi Compose Specification v1

This document specifies the Uffizzi Compose file format used to define and preview multi-container applications using Uffizzi. Based on Docker Compose, a Uffizzi Compose file is a structured YAML format that provides Uffizzi with configuration details for an application. Additionally, Uffizzi Compose utilizes the Docker Compose [custom extension format](https://github.com/docker/compose/issues/7200), `x-uffizzi`, to specify configuration options that are used by Uffizzi to deploy previews. This means that all Uffizzi Compose files are valid [Docker Compose v3.9](https://docs.docker.com/compose/compose-file/compose-file-v3/) files; however, the reverse is not necessarily true since Uffizzi only supports a subset of the full Docker Compose specification. This document describes all parameters that are supported by Uffizzi Compose and which are required or optional.

### Compose file structure   

The Uffizzi Compose file is a YAML file defining `services` (required), `configs`, `secrets` and `x-uffizzi` elements. Other Compose top-level elements such as `networks`, `version`, and `volumes` are not currently supported. As a YAML file, it should comply with the [YAML Specification](https://yaml.org). It is recommended to name your Uffizzi Compose file, `docker-compose.uffizzi.yml` (Note: You can use either the `.yml` or `.yaml` extension). At a minimum, a Uffizzi Compose file must container `services` and `ingress` (a sub-level element of `x-uffizzi`). Services are the containers that make up your application, and ingress tells Uffizzi which container should receive incoming HTTPS traffic. Ingress requires a service and port number that the service is listening on.   

### Services (required)
As with Docker Compose, a Service is an abstract definition of a computing resource within an application which can be scaled/replaced independently from other components. Services are backed by a set of containers when deployed on Uffizzi.

### Ingress (required)
Ingress exposes HTTPS routes from outside your preview environment to your application services. Ingress requires a `port` number.

### Configs (optional)  
Configs allow you to add configuration files to your applications. Files are expected to be in the same git repository as your compose file. All `file` paths are relative from the root of the current repository.  

You must explicitly grant access to configuration files per service using the `configs` element within the service definition. Uffizzi supports [Docker `config` long syntax](https://docs.docker.com/compose/compose-file/compose-file-v3/#configs).

### Secrets (optional)
Secrets provide a mechanism for securing and sharing environment variables across all previews in a project. The environment variables are defined as name/value pairs and are injected at runtime. Secrets can only be added from the Uffizzi Dashboard (UI). Once added, they cannot be viewed or edited. To update a secret, you should delete the old secret and create a new one.  


``` yaml title="docker-compose.uffizzi.yml
# Uffizzi extension
x-uffizzi:
  ingress:    # required
    service: loadbalancer
    port: 8080
  continuous_preview:
    deploy_preview_when_pull_request_is_opened: true
    delete_preview_when_pull_request_is_closed: true
    share_to_github: true

# Vote applicaiton
services:
  redis:
    image: redis:latest

  postgres:
    image: postgres:9.6
    secrets:
      - pg_user
      - pg_password

  worker:
    build: .  # defaults to ./Dockerfile
    deploy:
      resources:
        limits:
          memory: 250M

  result:
    build:
      context: https://github.com/UffizziCloud/example-voting-result#main
      dockerfile: Dockerfile
    environment:
      PORT: 8088

  vote:
    build:
      context: https://github.com/UffizziCloud/example-voting-vote  # defaults to "Default branch" as set in GitHub (usually main/master)
      dockerfile: Dockerfile
    deploy:
      resources:
        limits:
          memory: 250M
    environment:
      PORT: 8888

  loadbalancer:
    image: nginx:latest
    configs:
      - source: nginx-vote-conf
        target: /etc/nginx/conf.d/vote.conf

# Loadbalancer configuration
configs:
  nginx-vote-conf:
    file: ./vote.conf
    
# Postgres credentials
secrets:
  pg_user:
    external: true               # indicates value is external to this repository
    name: "POSTGRES_USER"        # i.e., value should be added in the Uffizzi Dashboard
  pg_password:
    external: true               # indicates value is external to this repository
    name: "POSTGRES_PASSWORD"    # i.e., value should be added in the Uffizzi Dashboard

```

## x-uffizzi configuration example

### **ingress** 

This section contains example configurations supported by a `ingress` definition in version 1. 

#### **service**  

The service that should receive incoming HTTPS traffic. 

``` yaml
services:
  nginx-loadbalancer:
    image: nginx:latest

ingress:
  service: nginx-loadbalancer
  port: 8080
```

#### **port**  

The port number the ingress service container is listening for traffic on  

``` yaml
services:
  nginx-loadbalancer:
    image: nginx:latest

ingress:
  service: nginx-loadbalancer
  port: 8080
```

### **continuous_previews** 

This section contains of example configurations supported by a `continuous_previews` definition in version 1. 

#### **deploy_preview_when_pull_request_is_opened**  

Boolean

Uffizzi will setup webhooks on your git repositories to watch for open pull requests (PR). If a PR is opened, Uffizzi will build the commit and deploy a new preview.  

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
```

#### **delete_preview_when_pull_request_is_closed**  

Boolean. Should be used with `deploy_preview_when_pull_request_is_opened`.  

Uffizzi will setup webhooks on your git repositories to watch for closed pull requests (PR). If a PR is closed, Uffizzi will destroy the preview with the corresponding commit.  

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
```

#### **deploy_preview_when_image_tag_is_created**  

Boolean

If you have webhooks setup on your container registry, Uffizzi will deploy previews of all new tags (Or optionally matching `tag_pattern`).    

``` yaml
continuous_previews:
  deploy_preview_when_image_tag_is_created: true
```

#### **delete_after**  

Delete preview after a certain number of hours

Accepts values from `0-720h`, defaults to `72h`.

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_after: 24h
```

#### **share_to_github**  

Boolean

After a preview is deployed, post the URL in a comment to the GitHub pull request issue.  

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
  share_to_github: true
```

## Service configuration examples
This section contains of example configurations supported by a `service` definition in version 1.  

### **build**  

Configuration options that are applied at build time.

`build` can be specified either as a string containing a path to the build context:  

``` yaml
services:
  webapp:
    build: ./dir
```

Or, as an object with the path specified under [`context`](create-a-compose.md#context).  

``` yaml
services:
  webapp:
    build:
      context: ./dir
      dockerfile: Dockerfile-alternate
```

### **context**  
Either a path to a directory containing a Dockerfile, or a url to a GitHub repository.  

When the value supplied is a relative path, it is interpreted as relative to the location of the Compose file.  

``` yaml
  build:
    context: ./dir
```

The GitHub repository URL must include `https://`. If no branch is specified, default is `main`/`master`.
``` yaml
  build:
    context: https://github.com/ACCOUNT/example-repo#main
```

You can tell Uffizzi which branch and build context to use by leveraging the `#` and `:`, respectively. For example:  

```
| Build Syntax Suffix                                       | Branch Used   | Build Context Used |
| --------------------------------------------------------- |---------------|--------------------|
| https://github.com/ACCOUNT/example-repo                   | master        | /                  |
| https://github.com/ACCOUNT/example-repo#mybranch          | mybranch      | /                  |
| https://github.com/ACCOUNT/example-repo#:myfolder         | master        | /myfolder          |
| https://github.com/ACCOUNT/example-repo#main:myfolder     | main          | /myfolder          |
```

### **dockerfile**  

Alternate Dockerfile.

Compose uses an alternate file to build with. A build path must also be specified. Default is `./Dockerfile`.  

``` yaml
  build:
    context: ./dir
    dockerfile: Dockerfile-alternate
```

### **command**  

Override the default command. Command and args should be used with [`entrypoint`](create-a-compose.md#entrypoint) and expressed in quotes as a list.

```  yaml
  entrypoint: /usr/bin/nginx-debug
  command: 
    - "-g"
    - "daemon off;"
```

### **configs**  

Grant access to configs on a per-service basis using the per-service `configs` configuration. Only the Docker Compose "Short Syntax" is supported.  

``` yaml
services:
  redis:
    image: redis:latest
    configs:
      - my_config
configs:
  my_config:
    file: ./my_config.txt
```  

### **deploy**  

Specify configuration related to the deployment and running of services. Currently, the only deploy option supported is `deploy: resources: limit: memory`.  

#### **resources: limits: memory**

``` yaml
services:
  myservice:
    image: example.azurecr.io/example-service:latest
    deploy:
      resources:
        limits:
          memory: 500M
```

`memory` defaults to 125 megabytes, but you can use the following increments: `125M`, `250M`, `500M`, `1000M`, `2000M`, `4000M`.

### **entrypoint**  

Override the default entrypoint.

``` yaml
  entrypoint: /code/entrypoint.sh
```

### **env_file**  

Add environment variables from a file. Can be a single value or a list.  

``` yaml
  env_file: .env
```

``` yaml
  env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/runtime_opts.env
```

Uffizzi expects each line in an env file to be in `NAME=VALUE` format.  

```
FOO=bar
```

### **environment**  

Add environment variables as an array. Any boolean values (true, false, yes, no) need to be enclosed in quotes to ensure they are not converted to True or False by the YML parser.

``` yaml
  environment:
    FOO: bar
    BAR: 'true'
```

### **image**  

Specify the image to start the container from, as  `repository:tag`. If no tag is specified, default is `latest`. Uffizzi currently integrates with Docker Hub, Amazon ECR, Azure Container Registry, and Google Container Registry. If no registry is specified, default is `hub.docker.com`.

``` yaml
  image: redis:latest  # Defaults to hub.docker.com
```

``` yaml
  image: example.azurecr.io/example-service:latest  # Credentials should be added in the Uffizzi UI (**Settings** > **Integrations**)
```

### **secrets**  

Specify the image to start the container from, as  `repository:tag`. If no tag is specified, default is `latest`. Uffizzi currently integrates with Docker Hub, Amazon ECR, Azure Container Registry, and Google Container Registry. If no registry is specified, default is `hub.docker.com`.

``` yaml
  image: redis:latest  # Defaults to hub.docker.com
```

``` yaml
  image: example.azurecr.io/example-service:latest  # Credentials should be added in the Uffizzi UI (**Settings** > **Integrations**)
```

## Secrets configuration examples
This section contains of example configurations supported by a `secrets` definition in version 1.  

### **external**  

A secret that is external to you compose context



### **secrets**  

The top-level secrets declaration defines or references secrets that can be granted to the services in this stack. The source of the secret must be added in the Uffizzi Dashboard and invoked with `external` and secret name. In the following example, `FOO` is the name of a secret that has been added in the Uffizzi Dashboard.

``` yaml
services:
  foo:
    image: foo:latest
    secrets:
      - my_secret

secrets:
  my_secret:
    external: true    
    name: "FOO"
```

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
