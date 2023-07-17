# Uffizzi Command -Line Interface (CLI) Reference

The Uffizzi command-line interface (CLI) allows you to interact with the Uffizzi API. To list available commands, you can run `uffizzi` or `uffizzi help`, or to get help on a specific group or subcommand run `uffizzi [GROUP] help` or `uffizzi [GROUP] [SUBCOMMAND] help`.

## Groups and Subcommands

| Group                              | Subcommands                                         | Description                                   |
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

Manage virtual clusters

```
uffizzi cluster [SUBCOMMAND] [OPTIONS]
```

### cluster create

Create a virtual cluster

```
uffizzi cluster create -n [CLUSTER_NAME] -k [PATH_TO_KUBECONFIG] -m [PATH_TO_MANIFEST_FILE]
```  

| Option                    | Description                                                                                |
| --------------------------|------------------------------------------------------------------------------------------- |
| `-n`, `--name`            | The name of the cluster to be created. If no name is provided, a name is auto-generated.   |
| `-k`, `--kubeconfig`      | The location of the kubeconfig file to create or update                                    |
| `-m`, `--manifest`        | The path to a Kubernetes manifest file. If no manifest is provided, Uffizzi creates an empty cluster instance. |
| `-o`, `--output`          | Formats the output of this command. Accepted values are `pretty-json` and `json`           |

### cluster delete

Delete a virtual cluster

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
uffizzi connect [SUBCOMMAND]
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

## **cluster**

## **disconnect**

## **login**

## **logout**

## **preview**

### service

## **project**


### compose

### create

### delete

### describe

### list

### secret

### set_default
