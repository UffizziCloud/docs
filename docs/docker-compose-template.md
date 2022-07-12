# Create a Docker Compose template

In this section, we'll create a template using [Docker Compose](https://docs.docker.com/compose/compose-file/) that describes our application configuration. Uffizzi uses Docker Compose as its configuration format because it is relatively simple and widely used by developers.

!!! note
    Uffizzi supports a subset of the [Compose specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md). For a full list of supported keywords, see the [Uffizzi Compose file reference](references/compose-spec.md). 

## Configure dynamic service updates

The Uffizzi environment creation step typically executes at the end of a CI pipeline after a series of build and push steps that are triggered by an event, such as a pull request or new commit. If you don't have an existing CI solution, Uffizzi CI can build your application from source and store your container images for you (Note: Your source code must be stored in a GitHub repository to use Uffizzi CI). Alternatively, if you're using an external CI service, such as GitHub Actions or CircleCI, you will need to tell Uffizzi where your images are stored and how to access them.

Each time your CI pipeline builds and pushes new images, Uffizzi needs access to them. This means that we need to dynamically update our compose file `service` definitions with the new image names and tags each time our pipeline runs. To do this, we'll follow one of two methods, depending on which CI solution you choose:

- **External CI** - If you're using an external CI provider, you can use variable substitution to pass the output from your CI build step, i.e. `image:tag`, to your Compose file `image` definition (See highlighted example below). This solution is discussed in detail in the [next section](integrate-with-ci.md).

- **Uffizzi CI** - If you want to use Uffizzi CI, you can simply define a `build` context that points to your source code repository on GitHub and let Uffizzi handle building, tagging, and updating your Compose. See the [Uffizzi Compose file reference](https://docs.uffizzi.com/references/compose-spec/#build) for `build` and `context` details.

=== "External CI"

    ``` yaml hl_lines="3" title="docker-compose.template.yml"
    services:
      app:
        image: "${APP_IMAGE}"    # Output of build step stored as environment variable
        environment:
          PGUSER: "${PGUSER}"
          PGPASSWORD: "${PGPASSWORD}"
        deploy:
          resources:
            limits:
              memory: 250M

      db:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "${PGUSER}"
          POSTGRES_PASSWORD: "${PGPASSWORD}"
    ```

=== "Uffizzi CI"

    ``` yaml hl_lines="3-5" title="docker-compose.template.yml"
    services:
      app:
        build:
          context: https://github.com/example/app
          dockerfile: Dockerfile
        environment:
          PGUSER: "${PGUSER}"
          PGPASSWORD: "${PGPASSWORD}"
        deploy:
          resources:
            limits:
              memory: 250M

      db:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "${PGUSER}"
          POSTGRES_PASSWORD: "${PGPASSWORD}"
    ```

## Define an ingress for your application

Whether using Uffizzi CI or an external platform, Uffizzi needs to know which of your application services will receive incoming HTTPS traffic. This "ingress" should be one of the services defined in your `services` definition. Along with the service name, you must indicate on which port the ingress service is listening. The `ingress` must be defined within an `x-uffizzi` [extension field](https://docs.docker.com/compose/compose-file/compose-file-v3/#extension-fields) as shown in the example below:

``` yaml hl_lines="1-5"
# This block tells Uffizzi which service should receive HTTPS traffic
x-uffizzi:
  ingress:
    service: app
    port: 80

# My application
services:
  app:
    image: "${APP_IMAGE}"    # Output of build step stored as environment variable
    environment:
      PGUSER: "${PGUSER}"
      PGPASSWORD: "${PGPASSWORD}"
    deploy:
      resources:
        limits:
          memory: 250M

  db:
    image: postgres:9.6
    environment:
      POSTGRES_USER: "${PGUSER}"
      POSTGRES_PASSWORD: "${PGPASSWORD}"
```

## Add secrets in your CI platform (optional)

You may also want to move sensitive information like database credentials out of your Docker Compose file before commiting it to a remote repository. Most CI providers offer a way to store secrets and then reference them in the steps of your pipeline. To do this, we'll follow one of two methods, depending on which CI solution you choose:

- **External CI** - If you're using an external CI provider, you can store the secrets using your provider's interface and then reference them via variable substitution within an `environment` definition (See highlighted example below). This solution is discussed in detail in the [next section](integrate-with-ci.md).

- **Uffizzi CI** - If you want to use Uffizzi CI, you can create read-only secrets in the Uffizzi Dashboard web interface, then reference them using the `external` keyword, as shown below. See the [Uffizzi Compose file reference](https://docs.uffizzi.com/references/compose-spec/#secrets_1) for `secrets` and `external` details.

=== "External CI"

    ``` yaml hl_lines="20-22" title="docker-compose.template.yml"
    # This block tells Uffizzi which service should receive HTTPS traffic
    x-uffizzi:
      ingress:
        service: app
        port: 80

    services:
      app:
        image: "${APP_IMAGE}"    # Output of build step stored as environment variable
        environment:
          PGUSER: "${PGUSER}"
          PGPASSWORD: "${PGPASSWORD}"
        deploy:
          resources:
            limits:
              memory: 250M

      db:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "${PGUSER}"
          POSTGRES_PASSWORD: "${PGPASSWORD}"
    

    ```

=== "Uffizzi CI"

    ``` yaml hl_lines="19-29" title="docker-compose.template.yml"
    # This block tells Uffizzi which service should receive HTTPS traffic
    x-uffizzi:
      ingress:
        service: app
        port: 80

    services:
      app:
        build:
          context: https://github.com/example/app
          dockerfile: Dockerfile
        deploy:
          resources:
            limits:
              memory: 250M

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

## Next article

[Integrate with your CI pipeline](integrate-with-ci.md)