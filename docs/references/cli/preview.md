# `uffizzi preview`  

## Usage  

```
$ uffizzi preview COMMAND
```

## Description

Manage Uffizzi previews

## Child commands

| **Command**                                     | **Description**              |
|-------------------------------------------------|------------------------------|
| [uffizzi preview create](preview.md#create)     | Create a preview             |
| [uffizzi preview delete](preview.md#delete)     | Delete a preview             |
| [uffizzi preview describe](preview.md#describe) | Display details of a preview |
| [uffizzi preview list](preview.md#list)         | list all previews            | 


## <a id="create"></a> `uffizzi preview create`  

### Usage

```  
$ uffizzi preview create [POSITIONAL_ARGUMENTS] [UFFIZZI_WIDE_FLAG ...]
```

### Description

Creates a new preview. If no COMPOSE_FILE is specified, the preview is created with the project´s default compose file.

This command can fail for the following reasons:  

- The project does not have a default compose file set. Run `$ uffizzi compose --help` for details.  
- The alternate compose file is invalid.  

### Positional arguments

`[COMPOSE_FILE]` - An alternate compose file to the default compose.

You can pass a compose file to this command to create an ad hoc preview of an alternate compose configuration. The file passed via this argument does not replace the default compose file for the project. Alternate compose files share the same lifecyle as the previews they create: when the preview is deleted, the alternate compose is deleted by the Uffizzi API.

### Uffizzi wide flags

The flage `--project` is available to all commands. Run `$ uffizzi help` for details.

### Examples  

To create a preview with the project´s default compose file, run:  

```
$ uffizzi preview create
```

To create a preview with an alternate compose file, run:  

```
$ uffizzi preview create docker-compose.uffizzi.alt.yml
```

## <a id="delete"></a> `uffizzi preview delete`  

### Usage

```  
$ uffizzi preview delete [POSITIONAL_ARGUMENTS] [UFFIZZI_WIDE_FLAG ...]
```

### Description

Deletes a preview with the given preview ID. This command can fail for the following reasons:  

- The preview specified does not exist.
- The preview specified belongs to a different project.

### Positional arguments

`[PREVIEW_ID]` - ID for the preview you want to delete.  

### Uffizzi wide flags

The flage `--project` is available to all commands. Run `$ uffizzi help` for details.

### Examples  

The following command deletes the preview with ID `deployment-213`:

```
$ uffizzi preview delete deployment-213
```

## <a id="describe"></a> `uffizzi preview describe`  

### Usage

```  
$ uffizzi preview describe [POSITIONAL_ARGUMENTS] [UFFIZZI_WIDE_FLAG ...]
```

### Description

Shows metadata for a project given a valid preview ID. This command can fail for the following reasons:  

- The preview specified does not exist.
- The preview specified belongs to a different project.  

### Positional arguments

`[PREVIEW_ID]` - ID for the preview you want to describe.  

### Uffizzi wide flags

The flage `--project` is available to all commands. Run `$ uffizzi help` for details.

### Examples  

To list all previews in the default project, run:

```
$ uffizzi preview list
```

To list all previews in a project with name `my_project`, run:

```
$ uffizzi preview list --project="my_project"
```


## <a id="list"></a> `uffizzi preview list`  

### Usage

```
$ uffizzi preview list [UFFIZZI_WIDE_FLAG ...]
```

### Description

Lists all previews for a project, including `active`, `building`, `deploying` and `failed` previews.  

### Uffizzi wide flags
The flage `--project` is available to all commands. Run `$ uffizzi help` for details.

### Examples  

To list all previews in the default project, run:

```
$ uffizzi preview list
```

To list all previews in a project with name `my_project`, run:

```
$ uffizzi preview list --project="my_project"
```
