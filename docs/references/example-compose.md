#### uffizzi-compose-1.yml  

```
services:
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

  worker:
    image: uffizziqa.azurecr.io/example-voting-worker:latest
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

continuous_preview:
  deploy_preview_when_image_tag_is_created: true
  share_to_github: true

ingress:
  service: nginx
  port: 8080
```  

#### uffizzi-compose-2.yml  

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
      dockerfile: Dockerfile
    deploy:
      resources:
        limits:
          memory: 250M

  vote:
    build:
      context: https://github.com/UffizziCloud/example-voting-vote:main
      dockerfile: Dockerfile
    deploy:
      resources:
        limits:
          memory: 250M

  result:
    build:
      context: https://github.com/UffizziCloud/example-voting-result:main
      dockerfile: Dockerfile

continuous_preview:
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
  share_to_github: true
  delete_preview_after: 1h

ingress:
  service: nginx
  port: 8080
```
