# Uffizzi Command -Line Interface (CLI) Reference

The Uffizzi command-line interface (CLI) allows you to easily interact with the Uffizzi API. To list available commands, you can run `uffizzi` or `uffizzi help`, or to get help on a specific group or subcommand run `uffizzi [GROUP] help` or `uffizzi [GROUP] [SUBCOMMAND] help`.

## Groups and Subcommands

| Group or Command                   | Subcommands                                         | Description                                   |
| ---------------------------------- | --------------------------------------------------- | --------------------------------------------- |
| [**account**](cli.md#account)      | list, set-default                                   | Manage your Uffizzi accounts                  |
| [**cluster**](cli.md#cluster)      | create, delete, list, update-kubeconfig             | Manage virtual clusters                       |
| [**config**](cli.md#config)        | get-value, list, set, unset                         | Manage the CLI's configuration                |
| [**connect**](cli.md#connect)      | acr, docker_hub, docker_registry, ecr, gcr, ghcr    | Manage connections to external services       |
| [**disconnect**](cli.md#disconnect)| acr, docker_hub, docker_registry, ecr, gcr, ghcr    | Disconnect account from external services     |
| [**login**](cli.md#login)          |                                                     | Login to Uffizzi                              |
| [**logout**](cli.md#logout)        |                                                     | Logout of Uffizzi                             |
| [**preview**](cli.md#preview)      | create, delete, describe, events, list, update      | Manage Docker Compose preview environments    |
| [**project**](cli.md#project)      | create, delete, describe, list, secret, set-default | Manage projects                               |
| [**version**](cli.md#version)      |                                                     | Show CLI version                              |

## **account**

Manage your Uffizzi accounts

```
uffizzi account [SUBCOMMAND] [OPTIONS]
```

### account list
List all user's accounts, including your personal account and any organizational accounts.

```
uffizzi account list
```

### account set-default
Sets the default account context to use when running other groups/subcommands. Also see [config](cli.md#config) for details.

```
$ uffizzi account set-default [ACCOUNT_NAME]

```

## **cluster**

Manage [virtual clusters](../topics/virtual-clusters.md)

```
uffizzi cluster [SUBCOMMAND] [OPTIONS]
```

### cluster create

Create a [virtual cluster](../topics/virtual-clusters.md)

```
uffizzi cluster create -n [CLUSTER_NAME] -k [PATH_TO_KUBECONFIG] -m [PATH_TO_MANIFEST_FILE] --update-current-context
```  

| Option                    | Description                                                                                |
| --------------------------|------------------------------------------------------------------------------------------- |
| `-n`, `--name`            | The name of the cluster to be created. If no name is provided, a name is auto-generated.   |
| `-k`, `--kubeconfig`      | The location of the kubeconfig file to create or update                                    |
| `-m`, `--manifest`        | The path to a Kubernetes manifest file. If no manifest is provided, Uffizzi creates an empty cluster instance. |
| `-o`, `--output`          | Formats the output of this command. Accepted values are `pretty-json` and `json`           |
| `--update-current-context`| Updates the current kubeconfig context to the named cluster created by this command        |

### cluster delete

Delete a [virtual cluster](../topics/virtual-clusters.md)

```
uffizzi cluster delete -n [CLUSTER_NAME]
```

| Option                    | Description                                                                                           |
| --------------------------|------------------------------------------------------------------------------------------------------ |
| `-n`, `--name`            | (Required) The name of the cluster to be deleted                                                      |


### cluster describe

Shows metadata for a cluster given a valid cluster name  

| Option                    | Description                                                                                |
| --------------------------|------------------------------------------------------------------------------------------- |
| `-n`, `--name`            | The name of the cluster to describe                                                        |
| `-o`, `--output`          | Formats the output of this command. Accepted values are `pretty-json` and `json`           |


### cluster list

List all virtual clusters for the default account and project context. See [account](cli.md#account) and [config](cli.md#config) for details about changing default account or project contexts.

```
uffizzi cluster list
```

To view clusters from a different project, you can pass the CLI-wide `--project` option and pass an alternative project:

```
uffizzi cluster list --project [ALT_PROJECT]
```

| Option                    | Description                                                                                |
| --------------------------|------------------------------------------------------------------------------------------- |
| `-o`, `--output`          | Formats the output of this command. Accepted values are `pretty-json` and `json`           |

### cluster update-kubeconfig

Create or update the user's kubeconfig file with the named cluster's details.

```
uffizzi cluster update-kubeconfig [CLUSTER_NAME] [OPTIONS]
```

| Option                    | Description                                                                                |
| --------------------------|------------------------------------------------------------------------------------------- |
| `-p`, `--print`           | Dump kubeconfig to `STDOUT`                                                                |
| `-q`, `--quiet`           | Suppress output                                                                            |
| `-k`, `--kubeconfig`      | This option specifies the location of the kubeconfig file to create or update              |

!!! Note
    - If you specify a path with the `--kubeconfig` option, then the resulting configuration file is created at that location if none exists or is merged with an existing kubeconfig at that location.  
    - If you have the `KUBECONFIG` environment variable set, then the resulting configuration file is created at the first entry in that variable or merged with an existing kubeconfig at that location.  
    - If a previous cluster configuration exists for a Uffizzi cluster with the same name at the specified path, the existing configuration is overwritten with the new configuration.  
    - When `update-kubeconfig` writes a configuration to a kubeconfig file, the current context of the kubeconfig file is set to that configuration.

## **config**

Manage the CLI's configuration

```
uffizzi config [SUBCOMMAND] [OPTIONS]
```

### config get-value

Displays the value of the specified option

```
uffizzi config get-value [OPTIONS]
```

| Option                    | Description                                                                                |
| --------------------------|------------------------------------------------------------------------------------------- |
| `-p`, `--print`           | Dump kubeconfig to `STDOUT`                                                                |
| `-q`, `--quiet`           | Suppress output                                                                            |
| `-k`, `--kubeconfig`      | This option specifies the location of the kubeconfig file to create or update              |

### config list

Lists all options and their values from the config file  

```
uffizzi config list
```

### config set

Sets the value of the specified option

```
uffizzi config set [OPTION] [VALUE]
```

### config unset

Deletes the value of the specified option

```
uffizzi config unset [OPTION]
```

## **connect**

Grant a Uffizzi user account access to external registries

```
uffizzi connect [SUBCOMMAND] [OPTIONS] [FLAGS]
```

| Flags                          | Description                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------|
| `--skip-raise-existence-error` | If credential exists, do not raise an exception, just print a message.                     |
| `--update-credential-if-exists`| Update credential if it exists.                                                            |

### connect acr

Given valid credentials, grants a Uffizzi user account access to a private Azure Container Registry (ACR). Credentials can be provided interactively or non-interactively via command options or environment variables `ACR_REGISTRY_URL`, `ACR_REGISTRY_USERNAME`, and `ACR_REGISTRY_PASSWORD`.

If ACR environment variables are not set, the following command will prompt the user to enter ACR credentials, including registry domain, Docker ID and password or access token:

```
uffizzi connect acr
```

| Options                     | Environment Variables &nbsp;&nbsp;&nbsp;&nbsp;| Description                                       |
|-----------------------------|-----------------------------------------------|---------------------------------------------------|
| `-r`, `--registry`          | `ACR_REGISTY_URL`                             | URL of the Azure Container Registry               |
| `-u`, `--username`          | `ACR_REGISTY_USERNAME`                        | Username of the Azure Container Registry          |
| `-p`, `--password`          | `ACR_REGISTY_PASSWORD`                        | Password of the Azure Container Registry          |

### connect docker-hub

Given valid credentials, grant a Uffizzi user account access to a private Docker Hub registry (hub.docker.com). Credentials can be provided interactively or non-interactively via command options or environment variables `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD`.

If Docker Hub environment variables are not set, the following command will prompt the user to enter Docker Hub credentials, including Docker ID and password or access token:

```
uffizzi connect docker-hub
```

| Options                     | Environment Variables            | Description                                    |
|-----------------------------|----------------------------------|------------------------------------------------|
| `-u`, `--username`          | `DOCKERHUB_USERNAME`             | Docker Hub username                            |
| `-p`, `--password`          | `DOCKERHUB_PASSWORD`             | Password or access token to Docker Hub         |

### connect docker-registry

Given valid credentials, grant a Uffizzi user account access to any registry implementing the Docker Registry HTTP API protocol (i.e., generic Docker registry). Credentials can be provided interactively or non-interactively via command options or environment variables `DOCKER_REGISTRY_URL`, `DOCKER_REGISTRY_USERNAME` and `DOCKER_REGISTRY_PASSWORD`.

If Docker Registry environment variables are not set, the following command will prompt the user to enter Docker Registry credentials, including Docker ID and password:

```
uffizzi connect docker-registry
```

| Options                     | Environment Variables            | Description                                    |
|-----------------------------|----------------------------------|------------------------------------------------|
| `-u`, `--username`          | `DOCKER_REGISTRY_URL`            | Docker Registry username                       |
| `-u`, `--username`          | `DOCKER_REGISTRY_USERNAME`       | Docker Registry username                       |
| `-p`, `--password`          | `DOCKER_REGISTRY_PASSWORD`       | Password or access token to Docker Registry    |

### connect ecr

Given valid credentials, grants a Uffizzi user account access to a private Amazon Elastic Container Registry (ECR). Credentials can be provided interactively or non-interactively via command options or environment variables `ECR_REGISTRY_URL`, `AWS_ACCESS_KEY_ID`, and `AWS_SECRET_ACCESS_KEY`.

If ECR environment variables are not set, the following command will prompt the user to enter ECR credentials, including registry domain, acces key ID and secret access key:

```
uffizzi connect ecr
```

| Options                     | Environment Variables &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Description                                             |
|-----------------------------|-----------------------------------------------------------|---------------------------------------------------------|
| `-r`, `--registry`          | `ECR_REGISTRY_URL`                                        | URL of the AWS Elastic Container Registry               |
| `--id`                      | `AWS_ACCESS_KEY_ID`                                       | Access key ID of the AWS Elastic Container Registry     |
| `-s`, `--secret`            | `AWS_SECRET_ACCESS_KEY`                                   | Secret access key of the AWS Elastic Container Registry |

### connect gcr

Given a valid Google Cloud service account key file (JSON), grants a Uffizzi user account access to a private Google Container Registry (GCR). Credentials can be provided interactively or non-interactively via command argument or environment variable `GCLOUD_SERVICE_KEY`.

```
uffizzi connect gcr [KEY_FILE]
```

| Environment Variables &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Description                                             |
|-----------------------------------------------------------|---------------------------------------------------------|
| `GCLOUD_SERVICE_KEY`                                      | Google Cloud service account key file (JSON)            |

### connect ghcr

Given valid credentials, grants a Uffizzi user account access to a private GitHub Container Registry (GHCR). Credentials can be provided interactively or non-interactively via command options or environment variables `GITHUB_USERNAME` and `GITHUB_ACCESS_TOKEN`.

If GHCR environment variables are not set, the following command will prompt the user to enter GHCR credentials, including GitHub account name and access token (PAT):

```
uffizzi connect ghcr
```

| Options                     | Environment Variables&nbsp;&nbsp;&nbsp;&nbsp;           | Description                                    |
|-----------------------------|---------------------------------------------------------|------------------------------------------------|
| `-u`, `--username`          | `GITHUB_USERNAME`                                       | GitHub account username                        |
| `-t`, `--token`             | `GITHUB_ACCESS_TOKEN`                                   | Password or access token to Docker Hub         |

## **disconnect**

Revoke a Uffizzi user account access to external registries

```
uffizzi disconnect [SUBCOMMAND]
```

| Environment Variables              | Description                                             |
|------------------------------------|---------------------------------------------------------|
| acr                                | Azure Container Registry (ACR)                          |
| docker-hub                         | Docker Hub                                              |
| docker-registry                    | Docker Registry                                         |
| ecr                                | Amazon Elastgic Container Registry (ACR)                |
| gcr                                | Azure Container Registry (ACR)                          |
| ghcr                               | Azure Container Registry (ACR)                          |


## **login**

Login in to Uffizzi to manage your environments

To login via the browser, run:

```
uffizzi login
```

| Options                        | Description                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------|
| `--email`                      | Email to use for login                                                                     |
| `--server`                     | Login in to an alternate server                                                            |

## **logout**

Log out of a Uffizzi user account

```
uffizzi logout
```

## **preview**

Manage Docker Compose preview environments

```
uffizzi preview [SUBCOMMAND] [OPTIONS]
```

### preview create

Create a Docker Compose preview environment. See the [Uffizzi Compose Reference](compose-spec.md) for details.

```
uffizzi preview create [COMPOSE_FILE] [FLAGS]
```

| Flags                          | Description                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------|
| `--set-labels`                 | Set metadata for a deployment. Useful when filtering deployments                           |

To create a preview with single label, run:

```
uffizzi preview create docker-compose.uffizzi.yaml --set-labels github.repo=my_repo
```

### preview delete

Delete a Docker Compose preview environment given a valid preview ID. See the [Uffizzi Compose Reference](compose-spec.md) for details.

```
uffizzi preview delete [PREVIEW_ID]
```

### preview describe

Show metadata for a project given a valid preview ID. See the [Uffizzi Compose Reference](compose-spec.md) for details.

```
uffizzi preview describe [PREVIEW_ID]
```

### preview list

Lists all previews for a project, including active, building, deploying, failed, and sleeping.

```
uffizzi preview list [FLAGS]
```

| Flags                          | Description                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------|
| `--filter`                     | Metadata to filter list of deployments                                                     |
| `--output`                     | Format output as `json` or `pretty-json`                                                   |

## **project**

Manage Uffizzi projects

```
uffizzi project [SUBCOMMAND] [OPTIONS]
```

### project compose

Manage the default compose file for a project. 

```
uffizzi project compose [SUBCOMMAND] [OPTIONS]
```

#### project compose set

Sets the configuratoin of a project with the given compose file. By default, sets the configuration of the default project with the specified compose file. Use the --project flag to set the compose file of a different project. If already set, this command overrides the project´s configuration with the new compose file. The compose file must exist within a GitHub repository.

| Flags                          | Description                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------|
| `--repository`                 | The repository that contains the compose file to use for the project                       |
| `--branch`                     | The branch of repository that contains the compose file to use for the project             |
| `--path`                       | This compose file is used as the default when creating previews.                           |


```
uffizzi project compose set \
    --repository="github.com/example/example-app" \
    --branch="main" \
    --path="app/docker-compose.uffizzi.yml"
```

#### project compose describe

Show metadata for a compose file. By default, shows the contents of the default project’s compose file. Use the `--project` flag to describe the compose file of a different project.

```
uffizzi project compose describe
```

#### project compose unset

Unseet the compose file for a project. By default, unsets the compose file for the default project. Use the `--project` flag to unset the compose file of a different project.

```
uffizzi project compose unset
```

### project create

Create a new Uffizzi project

| Flags                          | Description                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------|
| `--description`                | Project description. Max of 256 characters.                                                |
| `--name`                       | Name for the project to create                                                             |
| `--slug`                       | A URL-compatible name used to uniquely identify your Uffizzi project. If a slug is not provided, Uffizzi will automatically generate one.|


### project delete

Deletes a Uffizzi project witht the given slug.

```
uffizzi project delete my-app-xc8fw
```

### project describe

Shows metadata for a project

```
uffizzi project describe [OPTOIN]
```

| Flags                          | Description                                                                                |
|--------------------------------|--------------------------------------------------------------------------------------------|
| `--output`                     | Format output as `json` or `pretty`                                                        |

### project list

List all projects for a user's account

```
uffizzi project list
```

### project secret

Manage secrets for a project

```
uffizzi project secret [SUBCOMMAND] [OPTIONS]
```

#### project secret create

Create a secret from STDIN. Once added, project secrets cannot be viewed or edited—only deleted. Be sure to pass your secrets securely so they are not recoverable from process logs. For example, this command reads standard input piped from the `printf` command: 

```
printf "my secret password" | uffizzi project secret create MY_SECRET - 
```

#### project secret delete

Delete a secret

```
uffizzi project secret delete [SECRET]
```

#### project secret list

Lists metadata for all secrets in a project

```
uffizzi project secret list
```

### project set_default

Set the default project given with the given project slug. When set, all commands use this project as the default context unless overridden by the --project flag. See [`config`](cli.md#config) for details about CLI configuration.

```
uffizzi project set-default [PROJECT_SLUG]
```

## version 

Show the CLI version  

```
uffizzi version
```