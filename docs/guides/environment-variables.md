# Add environment variables  

Environment variables are name/value pairs that are dynamically loaded into your containers at runtime. They are often used to pass configuration details to your application. Using environment variables instead of hard-coded values lets you keep environment-specific details out of your source code.  

When you define your application stack with a [Uffizzi Compose file](../references/compose-spec.md), you have two options for adding environment variables to your containers: `environment` or `env_file`.  

* Use `environment` if you have a small number of environment variables to add. You can list your variables in an `environment` block within the service definition. For example, the following `docker-compose.uffizzi.yml` snippet adds two environment variables, `FOO` and `BAR`, to the `myservice` container:    
```yaml    
services:
    mysevice:
      image: example/myservice:latest
      environment:
        FOO: bar
        BAR: baz
```

* Use `env_file` if you have a large number of enviroment variables that would otherwise clutter up your compose file. You can store your variables in a file within your repository and use the `env_file` component to specify the path to this file. For example, the following `docker-compose.uffizzi.yml` snippet tells Uffizzi to read the contents of `envs/myconfigs.env` and add them to the container `myservice`:  
```yaml
services:
    mysevice:
      image: example/myservice:latest
      env_file: ./envs/myconfigs.env
```
