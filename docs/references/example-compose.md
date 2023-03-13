# Example Docker Compose files for Uffizzi

## **Monorepo example (using Uffizzi CI)**
In this example, Uffizzi CI builds multiple serviecs that are all co-located in a single repository (i.e., a "monorepo")

See the source code for this example here: https://github.com/UffizziCloud/example-voting-app-monorepo  

```yaml title="docker-compose.uffizzi.monorepo.yml"
# Uffizzi extension
x-uffizzi:
  ingress:
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
    build: ./worker      # Assumes Dockerfile exists in this repo  
    deploy:
      resources:
        limits:
          memory: 250M

  result:
    build: ./result     
    context: Dockerfile  # Or you can specify an alternate monorepo
    environment:
      PORT: 8088

  vote:
    build: ./vote
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

## **Polyrepo example (using Uffizzi CI)**
In this example, Uffizzi CI builds services from source that are stored in different repositories (i.e. a "polyrepo").

See the source code for this example here: https://github.com/UffizziCloud/example-voting-worker/blob/main/docker-compose.uffizzi.yml

``` yaml title="docker-compose.uffizzi.2.yml"
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
    image: redis:latest   # Defaults registry is hub.docker.com
  postgres:
    image: postgres:9.6   # Defaults registry is hub.docker.com
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
    x-uffizzi-continuous-preview:
      deploy_preview_when_pull_request_is_opened: false
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

## Expose multiple routes in an ephemeral environment

Some applications may want to expose different services at different routes, for example, `/` and `/console`. To do this, we can use `nginx` to map requests for specific ports to their target containers. We'll first add an `nginx` service to our Docker Compose file, then define the routes in an `nginx.conf` file.

```yaml title="docker-compose.uffizzi.3.yml"
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
      - ./uffizzi/nginx:/etc/nginx/conf.d/

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


