
#### Vote App - Example of a Tag-initiated Preview (Bring Your Own Build)

``` yaml title="docker-compose.uffizzi.1.yml"
# Uffizzi extension
x-uffizzi:
  ingress:    # required
    service: loadbalancer
    port: 8080
  continuous_preview:
    deploy_preview_when_image_tag_is_created: true
    delete_preview_after: 8h
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
    image: uffizzi.azurecr.io/example-voting-worker:latest
    deploy:
      resources:
        limits:
          memory: 250M
  result:
    image: uffizzi.azurecr.io/example-voting-result:latest
    environment:
      PORT: 8088
  vote:
    image: uffizzi.azurecr.io/example-voting-vote:latest
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

&nbsp;  
#### Wiki.js Example - Example of Tag-initiated Preview (Bring Your Own Build)

``` yaml title="docker-compose.uffizzi.3.yml"
services:
  db:
    image: postgres:11-alpine
    environment:
      POSTGRES_DB: wiki
      POSTGRES_PASSWORD: wikijsrocks
      POSTGRES_USER: wikijs
  wiki:
    image: requarks/wiki
    environment:
      DB_TYPE: postgres
      DB_HOST: localhost
      DB_PORT: 5432
      DB_USER: wikijs
      DB_PASS: wikijsrocks
      DB_NAME: wiki
x-uffizzi:
  ingress:
    service: wiki
    port: 3000
  continuous_preview:  #for tag-initiated preview tag must = uffizzi_request_#
    deploy_preview_when_image_tag_is_created: true   
```
