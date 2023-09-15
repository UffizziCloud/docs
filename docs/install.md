# Install the Uffizzi CLI

This guide describes how to install the command-line interface (CLI) tool [`uffizzi`](https://github.com/UffizziCloud/uffizzi_cli), which will allow you to create and manage ephemeral environments on Uffizzi Cloud. If you're self-hosting Uffizzi, you should instead follow the [self-hosting installation guide](https://github.com/UffizziCloud/uffizzi/blob/develop/INSTALL.md).

## Homebrew Tap

If you're on macOS, you can install the Uffizzi CLI via the [Homebrew](https://brew.sh/) tap:

``` bash
brew update
brew tap uffizzicloud/uffizzi
brew install uffizzi
```

**Note**: Be sure to first run `brew tap` before running `brew install uffizzi`.

## From the binrary releases
The Uffizzi CLI is currently available as a binary for macOS and Linux. Windows users should use our official Docker container image, [available on Docker Hub](https://hub.docker.com/r/uffizzi/cli).

=== "Mac (AMD or ARM)"

    ``` bash
    curl -L -o uffizzi "https://github.com/UffizziCloud/uffizzi_cli/releases/latest/download/uffizzi-darwin" && sudo install -c -m 0755 uffizzi /usr/local/bin && rm -f uffizzi
    ```

=== "Linux (AMD or ARM)"  

    ``` bash
    curl -L -o uffizzi "https://github.com/UffizziCloud/uffizzi_cli/releases/latest/download/uffizzi-linux" && sudo install -c -m 0755 uffizzi /usr/local/bin && rm -f uffizzi
    ```

=== "Windows / Docker"  

    ``` bash
    docker run --interactive --rm --tty --entrypoint=sh uffizzi/cli
    ```

Alternatively, you can download binaries directly from the [GitHub Releases](https://github.com/UffizziCloud/uffizzi_cli/releases) page, then add the location to your `PATH`.

## Configure the CLI

Once you've downloaded and installed the Uffizzi CLI, run `uffizzi config` to set the Uffizzi API server you want to use. Accept the default value `app.uffizzi.com` (Uffizzi Cloud):

``` bash
$ uffizzi config
...
Server: (app.uffizzi.com)
```


## Login

Login to Uffizzi Cloud or your installation of Uffizzi.

### Via GitHub or GitLab OAuth

Once you've configured the Ufizzi CLI, you can login with your GitHub or GitLab credentials via `uffizzi login`. This command will open a browser window to https://app.uffizzi.com where you can sign up for a new account or sign in to an existing account.

``` bash
uffizzi login
```

Once you're logged in, return to the CLI. You'll need to select which GitHub/GitLab account you want to use as the default account context, for example, if you have both a personal and organizational account. You can change this setting later with the [`uffizzi config`](references/cli.md#config) command. 

``` bash
$ uffizzi login
Select an account: (Press ↑/↓ arrow to move and Enter to select)
‣ Acme Corp
  jdoe
```

For more information on Uffizzi's account model, see [Teams and Accounts on Uffizzi Cloud](topics/teams-and-accounts.md) and [Role-based Access Control](topics/rbac.md).

### Via Email/Password

If you have an email and password login for Uffizzi, you can login via:

```
uffizzi login --email <email> --username <username> --server <defaults to app.uffizzi.com>
```

### Via Environment Variables

Alternatively, for email/password accounts (i.e. not GitHub or GitLab OAuth), if you set environment varialbes `UFFIZZI_USER_EMAIL` and `UFFIZZI_USER_PASSWORD`, Uffizzi will log you in automatically when you run `uffizzi login`.

## Create a new project

In Uffizzi, every environment must belong to a project. If this is your first time setting up Uffizzi, select **Create a new project**. Then enter a project name, slug, description.

``` bash
$ uffizzi login
...
> Create a new project
```