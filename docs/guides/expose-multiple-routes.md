# Expose multiple routes for your application

## Understanding Uffizzi `ingress`
For each ephemeral environment, Uffizzi provisions one _https_ load balancer to receive incoming traffic for your application. This "`ingress`" is defined in your Docker Compose file and requires a `service` and `port` definition, as shown in the example below. 

``` yaml
x-uffizzi:
  ingress:
    service: app
    port: 80

services:
  app:
    ...
```

## Exposing multiple routes

Uffizzi allows only one `service` to act as your `ingress`, but your application may have multiple services you want to expose. For example, you may want to serve your main application at `/` and a console at `/console`. To do this, you can add a new `nginx` service to your configuration to map requests for specific ports to their target containers. We'll first add an `nginx` service to the Docker Compose file, then configure it as the `ingress`. Finally, we'll define the routes in an `nginx.conf` file.

```yaml title="docker-compose.uffizzi.multiple-routes.yml"
x-uffizzi:
  ingress:
    service: nginx
    port: 8081

services:
  nginx:
    image: nginx:alpine
    ports:
      - "8081:8081"
    volumes:
      - ./uffizzi/nginx:/etc/nginx/conf.d/

  app:
    ports:
      - 3001:3001
  
  api:
    ports: 
      - 7001:7001
```

&nbsp;

Now we will create a new file in our repository `/uffizzi/nginx/nginx.conf` that defines how our paths will be exposed. By default the official `nginx:latest` base image we used in our Docker Compose file will include all `/etc/nginx/conf.d/*.conf` files.  

Here we assume that `app` is listening for connections on `3001` and `3002` for the main applicaiton and console, respectively. If requests for port `:3001` are received, we tell `nginx` to forward those requests to `/`. If requests for port `3002` are received, we tell `nginx` to forward those requests to `/console`.

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
