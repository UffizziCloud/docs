# Secrets  

Secrets provide a mechanism for securely adding sensitive data, such as passwords, tokens, or keys, to the containers of a preview environment. Secrets are similar to environment variables, but they are intended for confidential data. Secrets are defined as name/value pairs and are injected at runtime. 

You can add secrets in one of two ways, depending on which CI solution you choose:

## External CI

If you're using an external CI provider, such as GitHub Actions, GitLab CI, or CircleCI, secrets should be stored via your provider's interface and referenced in your compose file using the [`environment`](../references/compose-spec.md#environment) element with variable substitution.  

In the following example, `PG_USER` and `PG_PASSWORD` are stored using [GitHub Actions secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) and referenced using variable substitution in a [Docker Compose template](../docker-compose-template.md).  

See the [Uffizzi resuable workflow](https://github.com/marketplace/actions/create-preview-environment) for example usage.

=== "GitHub Actions"

    ``` yaml
    secrets:
      username: ${{ secrets.PG_USER }}
      password: ${{ secrets.PG_PASSWORD }}
    ```  

=== "Docker Compose Template"

    ``` yaml
    services:
      postgres:
        image: postgres:9.6
        environment:
          POSTGRES_USER: "${PGUSER}"
          POSTGRES_PASSWORD: "${PGPASSWORD}"
        deploy:
          resources:
            limits:
              memory: 500M
    ```  

## Uffizzi CI 

### Add secrets in the Uffizzi Dashboard (app.uffizzi.com)
If you're using Uffizzi CI, secrets can be added in the Uffizzi Dashboard (**Project** > **Project Settings** > **Secrets**). Once added, they cannot be viewed or edited. To update a Secret, you should delete the old Secret and create a new one. Secrets added in the **Project Settings** are available to all Preview environments in that project.  
&nbsp;  

![](../assets/images/secrets.png)

### Add `secrets` element to your Docker Compose template  

In your Docker Compose, add the `secrets` and `external` elements as show in the example below. Be sure that your secrets are added in the Uffizzi Dashboard. If the external secret does not exist, you will see a secret-not-found error message in the Uffizzi Dashboard.

- `external`: Indicates that the secret object (a name/value pair) is declared in the Uffizzi Dashboard (UI). Value must be `true`.  
- `name`: The name of the secret object in Uffizzi.

In the following example, `POSTGRES_USER` and `POSTGRES_PASSWORD` are the names of secrets that have been added in the Uffizzi Dashboard. Their respective values are available to the `db` service once the stack is deployed.  

=== "Uffizzi CI"

    ``` yaml
    services:
      db:
        image: postgres:9.6
        secrets:`
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