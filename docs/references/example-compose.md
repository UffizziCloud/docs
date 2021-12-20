#### Vote App - Example of a Tag-initiated Preview (Bring Your Own Build)

```
services:  #required
  redis:
    image: redis  #defaults to pulling from Docker Hub and latest tag

  postgres:
    image: postgres:9.6
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    deploy:  #optional, defaults to 125M
      resources:
        limits:
          memory: 250M #options are 250M, 500M, 1000M, 2000M, 4000M

  nginx:
    image: nginx:latest
    configs:
      - source: vote.conf
        target: /etc/nginx/conf.d/vote.conf

  worker:
    image: uffizziqa.azurecr.io/example-voting-worker:latest
    auto: false  #optional, default=true, turns off auto-deploys to a Preview
    deploy:
      resources:
        limits:
          memory: 250M

  vote:
    image: uffizziqa.azurecr.io/example-voting-vote:latest
    env_file:
      - vote1.env
      - vote2.env
    deploy:
      resources:
        limits:
          memory: 250M

  result:
    image: gcr.io/uffizzi-pro-qa-gke/example-result:latest

configs:
  source:
    file: ./vote.conf

continuous_preview:       #for tag-initiated preview tag must = uffizzi_request_#
  deploy_preview_when_image_tag_is_created: true  
  delete_preview_after: 10h
  share_to_github: true

ingress:
  service: nginx
  port: 8080
```

#### Vote App - Example of PR-triggered Preview (Build from Source)

```
services:
  nginx:
    image: nginx:latest
    configs:
      - source: vote.conf
        target: /etc/nginx/conf.d

  redis:
    image: redis:latest

  postgres:
    image: postgres:9.6
    env_file:
      - file1.env
      - file2.env

  worker:
    build:
      context: https://github.com/UffizziCloud/example-voting-worker:main
      dockerfile: #optional, defaults to Dockerfile in directory
    deploy:
      resources:
        limits:
          memory: 250M

  vote:
    build:
      context: https://github.com/UffizziCloud/example-voting-vote:main
      dockerfile: 
    environment:
      key_1: value_1
      key_2: value_2
    deploy:
      resources:
        limits:
          memory: 250M

  result:
    build:
      context: https://github.com/UffizziCloud/example-voting-result:main
      dockerfile: Dockerfile

continuous_preview:  #optional, example below is PR-triggered example
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
  share_to_github: true
  delete_preview_after: 12h

ingress:  #required
  service: nginx
  port: 8080
```

#### Wiki.js Example - Example of Tag-initiated Preview (Bring Your Own Build)

```
version: "3"  #optional
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

ingress:
  service: wiki
  port: 3000

continuous_preview:  #for tag-initiated preview tag must = uffizzi_request_#
  deploy_preview_when_image_tag_is_created: true   
  share_to_github: true
```
