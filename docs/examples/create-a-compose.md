# Create a Uffizzi Compose  

This section highlights some of the key elements that you will likely want to include in your compose file. See the [Uffizzi Compose Specification v1](../../config/compose-spec.md) for the full list of supported keys and options. 

## File structure  

Uffizzi Compose files are YAML, so they should comply with the [YAML Specification](https://yaml.org). It is recommended to name your Uffizzi Compose file, `docker-compose.uffizzi.yml` (Note: You can use either the `.yml` or `.yaml` extension). At a minimum, a Uffizzi Compose file must container `services` and `ingress`. Services are the containers that make up your application, and ingress is the container that should receive incoming HTTPS traffic. Ingress requires a port number that the container is listening on.   

## Service configuration examples
This section contains of example configurations supported by a service definition in version 1.  

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