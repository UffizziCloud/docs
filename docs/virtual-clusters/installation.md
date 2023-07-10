# **Installing `uffizzi` (Command-line tool)**

This guide describes how to install the command-line interface (CLI) tool [`uffizzi`](https://github.com/UffizziCloud/uffizzi_cli), which will allow you to create and manage clusters on Uffizzi Cloud or a self-hosted installation of Uffizzi. This is NOT a guide for installing the Uffizzi platform (API) itself. For that, you can [contact sales](mailto:sales@uffizzi.com) or try our [open-source version](https://github.com/UffizziCloud/uffizzi).

## **Download and install the Uffizzi CLI**
The Uffizzi CLI is currently available as a binary for macOS and Linux. Windows users should use our official Docker container image, [available on Docker Hub](https://hub.docker.com/r/uffizzi/cli).

=== "Mac (Intel/AMD)"

    ``` bash
    curl -L -o uffizzi "https://github.com/UffizziCloud/uffizzi_cli/releases/latest/download/uffizzi-darwin-amd64" && sudo install -c -m 0755 uffizzi /usr/local/bin && rm -f uffizzi
    ```

=== "Mac (Apple Silicon/ARM)"

    ``` bash
    curl -L -o uffizzi "https://github.com/UffizziCloud/uffizzi_cli/releases/latest/download/uffizzi-darwin-arm64" && sudo install -c -m 0755 uffizzi /usr/local/bin && rm -f uffizzi
    ```

=== "Linux (AMD)"  

    ``` bash
    curl -L -o uffizzi "https://github.com/UffizziCloud/uffizzi_cli/releases/latest/download/uffizzi-linux-amd64" && sudo install -c -m 0755 uffizzi /usr/local/bin && rm -f uffizzi
    ```

=== "Linux (ARM)"  

    ``` bash
    curl -L -o uffizzi "https://github.com/UffizziCloud/uffizzi_cli/releases/latest/download/uffizzi-linux-arm64" && sudo install -c -m 0755 uffizzi /usr/local/bin && rm -f uffizzi
    ```

=== "Windows / Docker"  

    ``` bash
    docker run --interactive --rm --tty --entrypoint=sh uffizzi/cli
    ```


## **Login**
Once you've downloaded and installed the `uffizzi` CLI, you can login. For Uffizzi Cloud customers, the following command will provide you with a link to sign in via a browser.
``` bash
uffizzi login
```

## **From a CI pipeline**

