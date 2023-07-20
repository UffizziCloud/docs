# Installing Uffizzi

This guide describes how to install the command-line interface (CLI) tool [`uffizzi`](https://github.com/UffizziCloud/uffizzi_cli), which will allow you to create and manage clusters on Uffizzi Cloud or a self-hosted installation of Uffizzi. This is NOT a guide for installing Uffizzi platform (API) itself. For that, you can [contact sales](mailto:sales@uffizzi.com) or try our [open-source version](https://github.com/UffizziCloud/uffizzi).

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


## Login

Once you've downloaded and installed the `uffizzi` CLI, you can login. For Uffizzi Cloud customers, the following command will provide you with a link to sign in via a browser.
``` bash
$ uffizzi login

```

## Account setup

1. **Select an account** - If you have multiple GitHub accounts, select which one you want to configure as your default account context. You can change this setting later with the [`uffizzi config`](references/cli.md#config) command.  

2. **Create a new project** - If this is your first time setting up Uffizzi, select **Create a new project**. Then enter a project name, slug, description.