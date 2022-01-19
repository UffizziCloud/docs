# Uffizzi Compose file reference

This document describes the Uffizzi Compose file that is used to define and preview multi-container applications on the Uffizzi platform. Based on Docker Compose, a Uffizzi Compose file is a structured YAML format that provides Uffizzi with configuration details needed to preview an application. Uffizzi Compose utilizes the Docker Compose [custom extension format](https://github.com/docker/compose/issues/7200), `x-uffizzi`, to specify configuration options used by Uffizzi. This means that all Uffizzi Compose files are valid [Docker Compose v3.9](https://docs.docker.com/compose/compose-file/compose-file-v3/) files; however, the reverse is not necessarily true since Uffizzi only supports a subset of the full Docker Compose specification. This document describes all parameters that are supported by Uffizzi Compose and which are required or optional.

## Compose file structure   

The Uffizzi Compose file is a YAML file defining `services` (required), `configs`, `secrets`, and `x-uffizzi` elements such as `ingress` (required). Other Compose top-level elements such as `networks`, `version`, and `volumes` are not currently supported by Uffizzi. As a YAML file, a Uffizzi Compose should comply with the [YAML Specification](https://yaml.org). It is recommended to name your Uffizzi Compose file `docker-compose.uffizzi.yml` (Note: You can use either the `.yml` or `.yaml` extension). At a minimum, a Uffizzi Compose file must include `services` and `ingress` (a sub-level element of `x-uffizzi`). Services are the containers that make up your application, and ingress tells Uffizzi which container should receive incoming HTTPS traffic. Ingress requires a service and port number that the service is listening on.   

## Uffizzi extension  
Docker Compose supports [vendor-specific extensions](https://github.com/compose-spec/compose-spec/issues/17) for platforms like Uffizzi to supplement the Compose specification with parameters that are specific to that vendor's platform. For example, the Uffizzi extension, `x-uffizzi`, gives you the ability to add event triggers to your compose file. In the following example, a new preview will be deployed when a pull request is opened on GitHub:

```
x-uffizzi-continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
```

The example above is valid Docker Compose syntax because the `docker-compose` CLI ignores any field prefixed with `x-`. This allows users to still run `docker-compose config` on a Uffizzi Compose file to check for valid Docker Compose format.  

> **Note**: The `x-` extension prefix works for both top-level and sub-level definitions within a compose file. 


## Services  
As with Docker Compose, a Service is an abstract definition of a computing resource within an application that can be combined with other components. Services are deployed as containers on Uffizzi. A valid `services` definition is required for a Uffizzi Compose file.  

## Ingress  
Ingress exposes HTTPS routes from outside your preview environment to your application services. Ingress requires a `service` and `port` number as parameters. A valid `ingress` definition is required for a Uffizzi Compose file.

## Configs   
Configs allow you to add configuration files to your applications. Files are expected to be in the same git repository as your compose file. All `file` paths are relative from the root of the current repository.

You must explicitly grant access to configuration files per service using the `configs` element within the service definition. Configs are optional for Uffizzi Compose files.  

## Secrets  
Secrets provide a mechanism for securing and sharing environment variables across all previews in a project. The environment variables are defined as name/value pairs and are injected at runtime. Secrets can only be added from the Uffizzi Dashboard (UI). Once added, they cannot be viewed or edited. To update a secret, you should delete the old secret and create a new one.   

> **Note**: You will receive an error in the Uffizzi Dashboard if secrets have not been added in the UI but they are referenced in your compose file.   

Secrets are optional for Uffizzi Compose files. 

## Example Uffizzi Compose file  

``` yaml title="docker-compose.uffizzi.yml"
# Uffizzi extension
x-uffizzi:
  ingress:    # required
    service: loadbalancer
    port: 8080
  continuous_previews:
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

## Uffizzi extension configuration reference

### **x-uffizzi**  

The Uffizzi extension top-level element  

`x-uffizzi` defines an `ingress` and various `continuous_previews` options.  

``` yaml
services:
  foo:
    image: foo:latest
x-uffizzi:
  ingress:
    service: foo
    port: 8080
  continuous_previews: 
    deploy_preview_when_image_tag_is_created: true
    delete_after: 48h
    share_to_github: true
```

#### ingress (required)  

Ingress exposes HTTPS routes from outside your preview environment to your application services. Ingress requires a `service` and `port` number as parameters. A valid `ingress` definition is required for a Uffizzi Compose file.

This section contains example configurations supported by an `ingress` definition. 

##### service (required)  

The service that should receive incoming HTTPS traffic. The ingress service should be one of the services defined within the top-level `services`.  

``` yaml
services:
  foo:
    image: foo:latest
  nginx-loadbalancer:
    image: nginx:latest
x-uffizzi:
  ingress:
    service: nginx-loadbalancer
    port: 8080
```

##### port (required)  

The port number the ingress service container is listening for traffic on.   

``` yaml
services:
  foo:
    image: foo:latest
  nginx-loadbalancer:
    image: nginx:latest
x-uffizzi:
  ingress:
    service: nginx-loadbalancer
    port: 8080
```

#### **continuous_previews** 

Continuous Previews (CP) are an automation-enabled best practice that encourages cross-functional teams to continuously collaborate during the development process by providing feedback on features that are still in progress. With CP, git topic branches are previewed using on-demand test environments before they are merged into a downstream branch. Continuous Previews settings are optional for Uffizzi Compose.  

When specified, the continuous previews policies is globally scoped, i.e. the policies apply to all services in the compose file This behavior can be overrided with the [service-level `x-uffizzi-continuous-previews` option](#x-uffizzi-continuous-previews)).

This section contains example configurations supported by a `continuous_previews` definition. 

##### **deploy_preview_when_pull_request_is_opened**  

Possible values: `true`, `false`

Uffizzi will setup webhooks on your git repositories to watch for open pull requests (PR). If a PR is opened, Uffizzi will build the commit and deploy a new preview.  

``` yaml
x-uffizzi:
  continuous_previews:
    deploy_preview_when_pull_request_is_opened: true
```   

> **Note**: This option requires that you have first [connected to your git repository](../git-integrations). 

##### **delete_preview_when_pull_request_is_closed**  

Possible values: `true`, `false`  

Should be used with `deploy_preview_when_pull_request_is_opened`.  

Uffizzi will setup webhooks on your git repositories to watch for closed pull requests (PR). If a PR is closed, Uffizzi will destroy the preview associated with the corresponding commit.  

``` yaml
x-uffizzi:
  continuous_previews:
    deploy_preview_when_pull_request_is_opened: true
    delete_preview_when_pull_request_is_closed: true
```

> **Note**: This option requires that you have first [connected to your git repository](../git-integrations).  

##### **deploy_preview_when_image_tag_is_created**  

Possible values: `true`, `false`

Uffizzi will deploy a preview each time a new tag is created for one of the images defined in `services`. 

``` yaml
services:
  frontend:
    image: foo:latest
  backend:
    image: bar:latest 
x-uffizzi:
  continuous_previews:
    deploy_preview_when_image_tag_is_created: true
```  

> **Note**: This option requires that you have first [configured webhooks on your container registry](../container-registry-integrations).  

> **Tip**: Uffizzi will preview all images tagged with `uffizzi_request_#` where `#` is a pull request number. This is useful if you want Uffizzi to only preview images built from pull requests. To enable this behavior, set `deploy_preview_when_image_tag_is_created: false`, then configure your build system or CI/CD tool to tag images generated from pull requests with the `uffizzi_request_#` tag.  

##### **delete_after**  

Delete preview after a certain number of hours  

Accepts values from `0-720h`, defaults to `72h`.

``` yaml
x-uffizzi:
  continuous_previews:
    deploy_preview_when_pull_request_is_opened: true
    delete_after: 24h
```

##### **share_to_github**  

Possible values: `true`, `false`

After a preview is deployed, post the URL in a comment to the GitHub pull request issue.  This option requires that your GitHub credentials have been added in the Uffizzi Dashboard (UI).  

``` yaml
x-uffizzi:
  continuous_previews:
    deploy_preview_when_pull_request_is_opened: true
    delete_preview_when_pull_request_is_closed: true
    share_to_github: true
```  

> **Note**: This option requires that you have first [connected to your GitHub account](../git-integrations).  

### x-uffizzi-ingress

A top-level alternative to `ingress`  

Ingress exposes HTTPS routes from outside your preview environment to your application services. Just like the sub-level `ingress`, `x-uffizzi-ingress` requires a `service` and `port` number as parameters.  

``` yaml
services:
  foo:
    image: foo:latest
  nginx-loadbalancer:
    image: nginx:latest
x-uffizzi-ingress:
  service: nginx-loadbalancer
  port: 8080
```  

### x-uffizzi-continuous-previews  

A top-level alternative to [`continuous_previews`](#continuous_previews). 
>**Note**: Continuous Previews (CP) are an automation-enabled best practice that encourages cross-functional teams to continuously collaborate during the development process by providing feedback on features that are still in progress. With CP, git topic branches are previewed using on-demand test environments before they are merged into a downstream branch. Continuous Previews settings are optional for Uffizzi Compose.

Just like for `continuous_previews`, the top-level  `x-uffizzi-continuous-previews` is optional.  

``` yaml
x-uffizzi-continuous-previews:
  deploy_preview_when_image_tag_is_created: true
  delete_preview_when_image_tag_is_updated: true
  delete_preview_after: 10h
```

&nbsp;  

## `services` configuration reference  
This section contains example configurations supported by a `services` definition.  

### **build**  

Configuration options that are applied at build time.

`build` can be specified either as a string containing a path to the build context:  

``` yaml
services:
  webapp:
    build: ./dir
```

Or, as an object with the path specified under [`context`](#context). The path can local (i.e., within the same file system or repository as the Uffizzi Compose file):  

``` yaml
services:
  webapp:
    build:
      context: ./dir
      dockerfile: Dockerfile-alternate
```

Or, the path can reference a remote repository (expects a URL):  

``` yaml
services:
  webapp:
    build:
      context: https://github.com/ACCOUNT/example-repo#main
      dockerfile: Dockerfile
```

#### **context**  
Either a path to a directory containing a Dockerfile, or a URL to a GitHub repository.  

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

You can tell Uffizzi which branch and build context to use by leveraging the `#` and `:` symbols, respectively. For example:  

```
| Build Syntax Suffix                                       | Branch Used   | Build Context Used |
| --------------------------------------------------------- |---------------|--------------------|
| https://github.com/ACCOUNT/example-repo                   | master        | /                  |
| https://github.com/ACCOUNT/example-repo#mybranch          | mybranch      | /                  |
| https://github.com/ACCOUNT/example-repo#:myfolder         | master        | /myfolder          |
| https://github.com/ACCOUNT/example-repo#main:myfolder     | main          | /myfolder          |
```

#### **dockerfile**  

Alternate Dockerfile.

Compose uses an alternate file to build with. A build path must also be specified. Default is `./Dockerfile`.  

``` yaml
build:
  context: ./dir
  dockerfile: Dockerfile-alternate
```

### **command**  

Override the default command. Command and args should be used with [`entrypoint`](#entrypoint) and expressed in quotes as a list.

```  yaml
entrypoint: /usr/bin/nginx-debug
command: 
  - "-g"
  - "daemon off;"
```

### **configs**  

Grant access to configs on a per-service basis using the per-service `configs` configuration. Both [Docker `configs` short syntax and long syntax](https://docs.docker.com/compose/compose-file/compose-file-v3/#configs) are supported.  

> **Note**: `uid`, `gid`, and `mode` long syntax parameters are not supported.

#### Short syntax  

The short syntax variant only specifies the config name. This grants the container access to the config and mounts it at /<config_name> within the container. The source name and destination mountpoint are both set to the config name.  

The following example uses the short syntax to grant the redis service access to the `my_config` resource. The value of `my_config` is set to the contents of the file `./my_config.txt`.

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

#### Long syntax

The long syntax provides more granularity in how the config is created within the service’s task containers.

- `source`: The identifier of the config as it is defined in this configuration.  

- `target`: The path and name of the file to be mounted in the service’s task containers. Defaults to /<source> if not specified.

``` yaml
services:
  loadbalancer:
      image: nginx:latest
      configs:
        - source: nginx-conf
          target: /etc/nginx/conf.d/override.conf
configs:
  nginx-conf:
    file: ./override.conf
x-uffizzi-ingress:
  service: loadbalancer
  port: 8080
```

### **deploy**  

Specify configuration related to the deployment and running of services. 

#### **x-uffizzi-auto-deploy-updates**  

Possible values: `true`, `false`  
Default value: `true`

Auto deploys updates to an existing preview—either a new commit in the git repository or the deployed tag is updated. If this parameter is missing, Uffizzi will auto-deploy updates to repositories or images by default.   

``` yaml
services:
  foo:
    build:
      context: github.com/UffizziCloud/foo#main
    deploy:
      x-uffizzi-auto-deploy-updates: false
```

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
image: example.azurecr.io/example-service:latest  
``` 

> **Note**: To be able pull images from container registries, you must first add your registry credentials in the Uffizzi UI (**Settings** > **Integrations**). However, you do not need to provide Docker Hub credentials to pull public images from hub.docker.com.


### **secrets**  

Grant access to secrets on a per-service basis using the per-service `secrets` configuration. Uffizzi Compose currently supports the secrets [short syntax](https://docs.docker.com/compose/compose-file/compose-file-v3/#secrets) only.  

Secrets are name/value pairs that provide a mechanism for securing and sharing environment variables across all services in a stack. The secret name/value pairs must be added in the Uffizzi Dashboard (UI).  

In the following example, `pg_user` and `pg_password` are references to secrets invoked in the top-level `secrets` stanza. `POSTGRES_USER` and `POSTGRES_PASSWORD` are the names of secrets that have been added in the Uffizzi Dashboard. Their respective values are injected into the `db` service container once the stack is deployed.  

``` yaml
services:
  db:
    image: postgres:9.6
    secrets:
      - pg_user
      - pg_password

secrets:
  pg_user:
    external: true
    name: "POSTGRES_USER"
  pg_password:
    external: true
    name: "POSTGRES_PASSWORD"
```

### **x-uffizzi-continuous-previews**  

An option for specifying continuous previews policies per service. This option overrides global [`continuous_previews`](#continuous_previews) policies for the service where it is specified. 

``` yaml
services:
  frontend: 
    image: foo:latest
  backend:
    image: bar:latest
    x-uffizzi-continuous-previews:
      deploy_preview_when_image_tag_is_created: false
      delete_preview_when_image_tag_is_updated: false
x-uffizzi:
  ingress:
    service: frontend
    port: 80
  continuous_previews:
    deploy_preview_when_image_tag_is_created: true
    delete_preview_when_image_tag_is_updated: true 
```

In this example, a preview will be triggered when a new tag is created for `frontend` but not for `backend`. This is because the continuous previews policies are set to `false` within the `backend` service definition, which overrides the global policies. The `frontend` service definition contains no such override, so continuous previews will still be enabled for `frontend`.

&nbsp;  

## `configs` configuration reference  

The top-level `configs` declaration defines [configs](#configs) that can be granted to the services in this stack. The source of the config is a `file` (`external` source is currently not supported).

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

&nbsp;  

## `secrets` configuration reference

A top-level reference to secrets that can be granted to the services in a stack. Secrets are name/value pairs that provide a mechanism for securing and sharing environment variables across all services defined in the compose file. The source of the secret must be added in the Uffizzi Dashboard and invoked with `external` and secret name. If the external secret does not exist, you will see a secret-not-found error message in the Uffizzi Dashboard.

- `external`: Indicates that the secret object (a name/value pair) is declared in the Uffizzi Dashboard (UI). Value must be `true`.  
- `name`: The name of the secret object in Uffizzi.

In the following example, `POSTGRES_USER` and `POSTGRES_PASSWORD` are the names of secrets that have been added in the Uffizzi Dashboard. Their respective values are available to the `db` service once the stack is deployed.  

``` yaml
services:
  db:
    image: postgres:9.6
    secrets:
      - pg_user
      - pg_password

secrets:
  pg_user:
    external: true
    name: "POSTGRES_USER"
  pg_password:
    external: true
    name: "POSTGRES_PASSWORD"
```