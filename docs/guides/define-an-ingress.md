# Define an `ingress` for your ephemeral environment

Uffizzi needs to know which of your application services will receive incoming traffic. This "Ingress" is an HTTPS load balancer that will forward HTTP traffic to one of the defined `services`. Along with the service name, you must indicate on which port the target container is listening. The `ingress` must be defined within an `x-uffizzi` [extension field](https://docs.docker.com/compose/compose-file/compose-file-v3/#extension-fields) as shown in the example below:

``` yaml title="docker-compose.uffizzi.yml"
# This block tells Uffizzi which service should receive HTTP traffic.
x-uffizzi:
  ingress:
    service: app
    port: 80

# My application
services:
  app:
    build: ./
    Dockerfile: ./Dockerfile
    ...
```

## Expose multiple routes

Some applications may want to expose multiple routes, not just the base path `/`. For example, you may want to serve your main application at `/` and console at `/console`. To do this, we can use `nginx` to map requests for specific ports to their target containers. We'll first add an `nginx` service to our Docker Compose file, then define the routes in an `nginx.conf` file.

```yaml title="docker-compose.uffizzi.multiple-routes.yml"
x-uffizzi:
  ingress:
    service: nginx
    port: 8081
  continuous_previews:
    deploy_preview_when_pull_request_is_opened: true
    delete_preview_when_pull_request_is_closed: true
    share_to_github: true

services:
  nginx:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - "8081:8081"
    volumes:
      - ./uffizzi/nginx:/etc/nginx

  app:
    depends_on:
      - "postgres"
    build:
      context: ./
      dockerfile: ./Dockerfile
    ports:
      - 3001:3001

  postgres:
    image: postgres:14-alpine
    user: postgres
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres" # See https://docs.uffizzi.com/guides/secrets/#add-secrets-element-to-your-docker-compose-template
    deploy:
      resources:
        limits:
          memory: 500M
```

&nbsp;  

Now we will create a new file in our repository `/uffizzi/nginx/nginx.conf` that defines how our paths will be exposed.

```json title="nginx.conf"

events {
  worker_connections  4096;  ## Default: 1024
}

http {
    server {
        listen 8081;

        location / {
            proxy_pass http://localhost:3001;
        }

        location /console/ {
            proxy_pass http://localhost:3002;
        }
    }
}
```