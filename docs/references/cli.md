# Uffizzi Command -Line Interface (CLI) Reference

The Uffizzi command-line interface (CLI) allows you to interact with the Uffizzi API. To list available commands, you can run `uffizzi` or `uffizzi help`, or to get help on a specific group or subcommand run `uffizzi [GROUP] help` or `uffizzi [GROUP] [SUBCOMMAND] help`.

## Groups and Subcommands

| Group                              | Subcommands                                         | Description                                   |
| ---------------------------------- | --------------------------------------------------- | --------------------------------------------- |
| [**account**](cli.md#account)      | list, set-default                                   | Manage your Uffizzi accounts                  |
| [**cluster**](cli.md#cluster)      | create, delete, list, update-kubeconfig             | Manage virtual clusters                       |
| [**config**](cli.md#config)        | get-value, set, list                                | Manage the CLI's configuration                |
| [**connect**](cli.md#connect)      | acr, docker_hub, docker_registry, ecr, gcr, ghcr    | Manage connections to container registries    |
| [**disconnect**](cli.md#disconnect)| acr, docker_hub, docker_registry, ecr, gcr, ghcr    | Disconnect a container registry               |
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
$ uffizzi account set-default [ACCOUNT_NAME ]

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

Shows metadata for a cluster given a valid cluster name.  

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

**Options**  
`-p`, `--print` - This option dumps kubeconfig to `stdout`.  
`-q`, `--quiet` - This option suppresses output.  
`--kubeconfig` - This option specifies the location of the kubeconfig file to create or update

!!! Note
    - If you specify a path with the `--kubeconfig` option, then the resulting configuration file is created at that location if none exists or is merged with an existing kubeconfig at that location.  
    - If you have the `KUBECONFIG` environment variable set, then the resulting configuration file is created at the first entry in that variable or merged with an existing kubeconfig at that location.  
    - If a previous cluster configuration exists for a Uffizzi cluster with the same name at the specified path, the existing configuration is overwritten with the new configuration.  
    - When `update-kubeconfig` writes a configuration to a kubeconfig file, the current context of the kubeconfig file is set to that configuration.

## **config**

Manage the CLI's configuration

```
uffizzi config 
```

### config get-value

### config set

### config list

## **connect**

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
