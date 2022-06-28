# Create a Docker Compose template

In this section, we'll create a template using [Docker Compose](https://docs.docker.com/compose/compose-file/) that describes our application configuration. Uffizzi uses Docker Compose as its configuration format because it is relatively simple and widely used by developers around the world. 

!!! note
    Uffizzi supports a subset of the [Compose specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md). For a full list of supported keywords, see the [Uffizzi Compose file reference](references/compose-spec.md). 

## Define your services

How you define your application services will depend on your CI platform. Currently, Uffizzi has first-class support for GitHub Actions, so that is what we'll describe in this Getting Started guide. For help with writing actions for other CI providers, see the [Uffizzi CLI documentation](https://github.com/UffizziCloud/uffizzi_cli). Alternatively, if you don't use have an existing CI solution, Uffizzi CI can build your application from source and store your container images for you (**Note:** Your source code must be in a GitHub repository to use Uffizzi CI). 

### Add a previews action to your workflow

Uffizzi publishes a GitHub Action reusable workflow. 

=== "GitHub Actions"

    ``` yaml hl_lines="16"
    # This block tells Uffizzi which service should receive HTTPS traffic
    x-uffizzi:
      ingress:
        service: app
        port: 80

    # My application
    services:
      db:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "${PGUSER}"
          POSTGRES_PASSWORD: "${PGPASSWORD}"

      app:
        image: "${APP_IMAGE}"
        environment:
          PGUSER: "${PGUSER}"
          PGPASSWORD: "${PGPASSWORD}"
        deploy:
          resources:
            limits:
              memory: 250M
    ```

=== "Uffizzi CI"

    ``` c++
    #include <iostream>

    int main(void) {
      std::cout << "Hello world!" << std::endl;
      return 0;
    }
    ```

## Define an ingress for your application

Uffizzi needs to know which of your application services will receive incoming HTTPS traffic. This "ingress" should be one of the services defined in your `services` definition. Along with the service name, you must indicate on which port the ingress service is listening. The `ingress` must be defined within an `x-uffizzi` [extension field](https://docs.docker.com/compose/compose-file/compose-file-v3/#extension-fields) as shown in the example below:

``` yaml hl_lines="1-5"
# This block tells Uffizzi which service should receive HTTPS traffic
x-uffizzi:
  ingress:
    service: app
    port: 80

# My application
services:
  db:
    image: postgres:9.6
    environment:
      POSTGRES_USER: "${PGUSER}"
      POSTGRES_PASSWORD: "${PGPASSWORD}"

  app:
    image: "${APP_IMAGE}"
    environment:
      PGUSER: "${PGUSER}"
      PGPASSWORD: "${PGPASSWORD}"
    deploy:
      resources:
        limits:
          memory: 250M
```

## Add secrets in your CI platform



## Next article

[Integrate with your CI pipeline](integrate-with-ci.md)