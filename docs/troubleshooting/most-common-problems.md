# **Troubleshooting Guide**  

By [Shruti Chaturvedi](https://github.com/ShrutiC-git)   

## **Most common problems**

Learn about the possible reasons your Uffizzi ephemeral environments might be failing and how you can fix them.  

## Introduction

You’ve now added Uffizzi integration into your project; you create a new PR, and you’re getting ready to access your ephemeral environment and get your feature reviewed. But, something seems to have failed — it could be the container-build step or perhaps an issue with insufficient memory. Some of these issues, like an out-of-memory (`OOM`) error, can be due to application-level misconfigurations in the docker-compose.uffizzi.yml file, while other issues can be due to misconfigurations in appropriately setting-up GitHub Actions (or alternatively Uffizzi CI) to build your application and provision ephemeral environments. 

This article will cover some of the top reasons your Uffizzi ephemeral environments might not be working and go through the process of fixing these issues so you can quickly get your ephemeral environments running efficiently. 

## **1. Container killed due to insufficient memory (`OOM Kill`)**
The most common reason Uffizzi ephemeral environments might not be working is an out-of-memory (`OOM`) error. This error occurs when a container does not have enough resources assigned to it.

If no memory limit is set in the `docker-compose.uffizzi.yml`, by default, Uffizzi sets a 500 megabytes (`500M`) memory limit on each container, which may not be sufficient for certain memory-intensive applications. If insufficient memory is allocated to a container, the container will either exit with the `OOM` error or sometimes with an application-specific exit code indicating that the containerized application needs more memory. 

If you see your container exiting due to OOM Kill you can increase its memory by using the deploy.resources.limits key in your docker-compose.uffizzi.yml file. 

memory defaults to `500M`, but you can increase the memory using the following increments: `1000M`, `2000M`, and `4000M`.  

``` yaml
services:
  myservice:
    image: example.azurecr.io/example-service:latest
    deploy:
      resources:
        limits:
          memory: 500M
```

Uffizzi supports the following memory limits for a container `125M`, `250M`, `500M`, `1000M`, `2000M`, and `4000M`. Depending upon the memory usage of your application, you can set either of these limits on your containers. In case your application needs more memory, you can contact us [here](mailto:support@uffizzi.com).  

## **2. Container dependency chain is not working**
Uffizzi does not currently support [`depends_on`](https://docs.docker.com/compose/compose-file/#depends_on) within the `docker-compose.uffizzi.yml` to define container dependencies. In case your container needs to wait for other containers to start, you can use tools like [**dockerize**](https://github.com/jwilder/dockerize), [**wait4ports**](https://github.com/erikogan/wait4ports), or [**wait-for-it**](https://github.com/vishnubob/wait-for-it). [dockerize](https://github.com/jwilder/dockerize) supports waiting for services on a number of protocols: `file`, `TCP`, `HTTP`, `HTTPS`, and `Unix`. [wait-for-it](https://github.com/vishnubob/wait-for-it) and [wait4ports](https://github.com/erikogan/wait4ports) only support `TCP` sockets. To use [dockerize](https://github.com/jwilder/dockerize) and [wait4ports](https://github.com/erikogan/wait4ports), you can go through the installation steps to add these as dependencies in your application. [wait4ports](https://github.com/erikogan/wait4ports) on the other hand is a shell script, and you’ll only need the [`wait-for-it.sh`](https://github.com/vishnubob/wait-for-it/blob/master/wait-for-it.sh) script to use this tool.

Depending upon the tool you’re using, once it is configured, it can be used with the [`entrypoint`](https://docs.uffizzi.com/references/compose-spec/#entrypoint) or [`command`](https://docs.uffizzi.com/references/compose-spec/#command) directives in the `docker-compose.uffizzi.yml`. Alternatively, you can also wrap the call to your application using the `ENTRYPOINT` or `CMD` directives in the application’s `Dockerfile`. 

For example, your backend application might need to wait for Postgres to be running before it starts. Here is how you can define that dependence in your `docker-compose.uffizzi.yml` using `dockerize`:  

``` yaml
entrypoint: ["dockerize", "-wait", "tcp://localhost:5432", "-timeout", "3600s"] 
```

The `timeout` flag is optional. In case Postgres cannot be reached within the limits of the timeout, your application will exit with code `1`. 

This can also be defined using the [`command`](https://docs.uffizzi.com/references/compose-spec/#command) directive:  

``` yaml
command: ["dockerize", "-wait", "tcp://localhost:5432", "-timeout", "3600s"] 
```

Using `wait4ports`:
``` yaml
entrypoint: ["wait4ports", "tcp://localhost:5432"] 
```

Using `wait-for-it` (make sure you have added the [`wait-for-it.sh`](https://github.com/vishnubob/wait-for-it/blob/master/wait-for-it.sh) script to your application’s runtime):  

``` yaml
entrypoint: ["./wait-for-it.sh tcp://localhost:5432"]
```

## **3. Init container finishes and a previously working environment throws `Service Unavailable` error**

Often if an application has init containers, the ephemeral environments will start throwing a `Service Unavailable` error as soon as the init container completes successfully and exits. This happens because all the containers in a given environment have the same life cycle. Therefore, when an init container completes its execution and exits, the other containers also exit and your ephemeral environment might throw a `503` error. 

To prevent your containers from exiting when the init containers complete execution, you’ll need to keep the init container running by providing it with an infinite process. There are a few of ways to do this:  

- Add an infinite loop at the end of the init-container script
- Use `tail -f /dev/null`, or use `sleep infinity`
- Adding any process that will keep the init container running will fix this issue 

## **4. Volumes: file or directory is too large** 

When mounting host/non-empty [`volumes`](https://docs.uffizzi.com/references/compose-spec/#volumes_1), you might get an error saying that the file or the directory you’re mounting is too large. Currently, [Uffizzi support non-empty volumes for files and directories up to 1MB (compressed)](https://docs.uffizzi.com/references/compose-spec/?h=non+empty#volumes_1), although you can mount multiple volumes each up to 1M.  

If the size of the file or the compressed folder you’re mounting exceeds 1MB, you’ll get the error - `file or directory is too large` during the creation of your ephemeral environment. 

As a workaround, you can mount multiple non-empty volumes in your `docker-compose.uffizzi.yml`: 

``` yaml
services:
 app:
   image: myproject/app
   volumes:
     - ./frontend/public/svg:/frontend/public/svg
     - ./frontend/public/assets:/frontend/public/assets
     - ./frontend/src/app:./frontend/src/app
```

## **5. Passing files as source path to non-empty volumes** 

You cannot directly pass the path to files as non-empty [`volumes`](https://docs.uffizzi.com/references/compose-spec/#volumes_1). The following way of mounting files will **fail** the deployment:  
``` yaml
services:
 app:
   image: nginx
   volumes:
     - ./nginx/nginx.conf:/etc/nginx/nginx.conf
```


If you want to mount a file(s) onto your container, you can place it in a directory and mount the directory. You can try the previous case in this way:  
``` yaml
services:
 app:
   image: nginx
   volumes:
     - ./nginx:/etc/nginx
```

If you are using Uffizzi CI, you can utilize the [`configs`](https://docs.uffizzi.com/references/compose-spec/#configs_1) directive in the `docker-compose.uffizzi.yml` file. The above, in Uffizzi CI, can be achieved in the following way:

``` yaml
services:
  nginx:
    image: nginx
    configs:
      - source: nginx-conf
        target: /etc/nginx/nginx.conf
configs:
  nginx-conf:
    file: ./nginx/nginx.conf
```

## **6. Setting and accessing sensitive environment variables** 
If you are trying to set sensitive environment variables like access tokens, secret keys, etc, there are different ways to do this in the Uffizzi CI and external CI providers like GitHub Actions. 

### Uffizzi CI
Uffizzi CI supports the [`secrets`](https://docs.uffizzi.com/references/compose-spec/#secrets_1) directive in the `docker-compose.uffizzi.yml`. These secrets should be first added through the Uffizzi dashboard (check out [how to add secrets in the Uffizzi dashboard](https://docs.uffizzi.com/guides/secrets/#add-secrets-in-the-uffizzi-dashboard-appuffizzicom)) and then these can be accessed securely across all services in the stack.  

**Example**
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

Make sure to set the `external` flag to true—it indicates that the [`secret`](https://docs.uffizzi.com/references/compose-spec/#secrets_1) object (name/value pair) is declared in the Uffizzi Dashboard (UI).

### External CI Providers
If you are using external CI providers like GitHub actions, GitLab CI, etc, you cannot directly use the [`secrets`](https://docs.uffizzi.com/references/compose-spec/#secrets_1) directive. However, you can still use sensitive information in your application by storing it within your external CI provider and accessing it through the [`environment`](https://docs.uffizzi.com/references/compose-spec/#environment) directive in the `docker-compose.uffizzi.yml` file with variable substitution. 

**Example with GitHub Actions**
Once you have added the secrets to your GitHub repository, these can be accessed in your GitHub Actions (GHA) workflow file. You can then export them and consequently, they will be available for use within your compose file. 

[After you have added your secret to your GitHub repository](https://docs.github.com/en/actions/security-guides/encrypted-secrets), add the following line to the _Render Compose File_ step in the _render-compose-file_ job:
``` yaml
SOME_SECRET=${{secrets.SOME_SECRET}}
```

_render-compose-file_ after adding the above line:
``` yaml
  render-compose-file:
    name: Render Docker Compose File
    # Pass output of this workflow to another triggered by `workflow_run` event.
    runs-on: ubuntu-latest
    needs:
      - some-job
    outputs:
      compose-file-cache-key: ${{ steps.hash.outputs.hash }}
    steps:
      - name: Checkout git repo
        uses: actions/checkout@v3
      - name: Render Compose File
        run: |
          APP_IMAGE=${{ needs.some-job.outputs.tags }}
          export APP_IMAGE
          SOME_SECRET=${{secrets.SOME_SECRET}}
          export SOME_SECRET
          # Render simple template from environment variables.
          envsubst < docker-compose.uffizzi.yml > docker-compose.rendered.yml
          cat docker-compose.rendered.yml
```

Once you export the secret from the GHA workflow file, you can leverage the [`environment`](https://docs.uffizzi.com/references/compose-spec/#environment) directive in the `docker-compose.uffizzi.yml` file and through environment substitution, use this secret like below:
``` yaml
  my_app_fe:
    image: app_fe_image
    environment:
      SOME_SECRET: "${SOME_SECRET}" 
  my_app_be:
    image: app_be_image
    environment:
      SOME_SECRET: "${SOME_SECRET}" 
```

## **Other issues?**
If you're having issues with your Uffizzi ephemeral environment that are not listed above, [get help on Slack](https://join.slack.com/t/uffizzi/shared_invite/zt-ffr4o3x0-J~0yVT6qgFV~wmGm19Ux9A) or [set up a Zoom call](https://calendly.com/d/yjr-gfc-g5w/uffizzi-support-call) with a member of our Technical Support Team.
