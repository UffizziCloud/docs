#### Vote App - Monorepo Example  

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

&nbsp;  
#### Vote App - Example of PR-initiated Preview (Build from Source)

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
