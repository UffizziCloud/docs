# Create a Uffizzi Compose  

This section highlights some of the key elements that you will likely want to include in your compose file. See the [Uffizzi Compose Specification v1](../../config/compose-spec) for the full list of supported keys and options. 

## File structure  

Uffizzi Compose files are YAML, so they should comply with the [YAML Specification](https://yaml.org). It is recommended to name your Uffizzi Compose file, `docker-compose.uffizzi.yml` (Note: You can use either the `.yml` or `.yaml` extension). At a minimum, a Uffizzi Compose file must container `services` and `ingress`. Services are the containers that make up your application, and ingress is the container that should receive incoming HTTPS traffic. Ingress requires a port number that the container is listening on.   

## Ingress configuration example  

This section contains of example configurations supported by a `ingress` definition in version 1. 

### **ingress**  

The service that should receive incoming HTTPS traffic. 

``` yaml
services:
  nginx-loadbalancer:
    image: nginx:latest

ingress:
  service: nginx-loadbalancer
  port: 8080
```

### **port**  

The port number the ingress service container is listening for traffic on  

``` yaml
services:
  nginx-loadbalancer:
    image: nginx:latest

ingress:
  service:
  port: 8080
```

## Continuous Previews configuration example  

This section contains of example configurations supported by a `continuous_previews` definition in version 1. 

### **deploy_preview_when_pull_request_is_opened**  

Boolean

Uffizzi will setup webhooks on your git repositories to watch for open pull requests (PR). If a PR is opened, Uffizzi will build the commit and deploy a new preview.  

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
```

### **delete_preview_when_pull_request_is_closed**  

Boolean. Should be used with `deploy_preview_when_pull_request_is_opened`.  

Uffizzi will setup webhooks on your git repositories to watch for closed pull requests (PR). If a PR is closed, Uffizzi will destroy the preview with the corresponding commit.  

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
```

### **deploy_preview_when_image_tag_is_created**  

Boolean

If you have webhooks setup on your container registry, Uffizzi will deploy previews of all new tags (Or optionally matching `tag_pattern`).    

``` yaml
continuous_previews:
  deploy_preview_when_image_tag_is_created: true
```

### **delete_after**  

Delete preview after a certain number of hours

Accepts values from `0-720h`, defaults to `72h`.

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_after: 24h
```

### **share_to_github**  

Boolean

After a preview is deployed, post the URL in a comment to the GitHub pull request issue.  

``` yaml
continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
  share_to_github: true
```

### **tag_pattern**  

Only deploy previews matching tag pattern. If tag_pattern matches `uffizzi_request_*`, where `*` is the merge/pull request number, Uffizzi will only deploy previews pull requests.  

Use this option when building and tagging your own images.  See [Bring your own build](../../set-up-previews/#bring-your-own-build-tag-based-trigger)

``` yaml
continuous_previews:
  deploy_preview_when_image_tag_is_created: true
  tag_pattern: uffizzi_request_*
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

### **secrets**  

The top-level secrets declaration defines or references secrets that can be granted to the services in this stack. The source of the secret must be added in the Uffizzi Dashboard and invoked with `external` and secret name. In the following example, `FOO` is the name of a secret that has been added in the Uffizzi Dashobard.

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