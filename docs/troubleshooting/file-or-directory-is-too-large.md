# Error: File or Directory is Too Large

Are you trying to mount a host file and/or directory to your Uffizzi ephemeral environment built using external CI, and seeing an error that says the file or directory is too large? In this article, we’ll take a look at how you can solve this problem.  

## Problem
We often come across use cases where projects need to mount host files and directories to their Uffizzi ephemeral environments. This can be achieved through the [`volumes` directive](../references/compose-spec.md#volumes-1) within services in the docker-compose.uffizzi file (example below): 

``` yaml
services:
 proxy:
   image: nginx
   volumes:
     - ./nginx_conf:/etc/nginx

volumes:
 share_db:
```

Uffizzi compresses the source file or directory to archive. If you’re using Uffizzi with an external CI, the size of this archive needs to be less than 1 MB, the currently supported limit (support for larger volumes is planned). If you mount a file or directory, which is larger than 1 MB compressed, you’ll see an error, **`File or Directory is Too Large`**.

As a workaround, you can mount multiple volumes each up to 1 MB, Mouting multiple volumes, however, be onerous for cases where multiple files and/or directories need to be mounted, each coming to be larger than 1 MB compressed.  

The question is: how to mount larger files and/or directories on Uffizzi ephemeral environments built using an external CI in cases where mounting multiple volumes is cumbersome. Below are the steps of how you can achieve this effortlessly.

## Solution 
In this example, we are looking at how you can make larger files (compressed size over 1MB) available to your Uffizzi ephemeral environment built using GitHub Actions (GHA). The same procedure can be followed for other external CIs. 

The solution assumes that the file or directory you’re mounting is available in your git repo. Once the file is available in the git repo, you then download the zipped source (or clone the repo) into your container using the command directive. Depending upon your use case, you might have to export certain variables from your external CI and use these within `docker-compose.uffizzi.yml`. Step-by-step below:  

### **Step 1: Export GHA Context Variables**
This is an important step in the case where the file or directory to be mounted changes the behavior of the environment. The variables we export will make sure that the most recent changes in your repo are downloaded in the container. 

In your GHA workflow file, under the Render Compose File step in the render-compose-file job export the following variables:
**github.actor** → represents the committer  
**github.event.repository.name** → represents the name of the repository (head repository, in case the environment was spun for a PR from a fork)  
**github.head_ref** → represents the branch within the repo for which the environment will be spun  

These [GitHub context](https://docs.github.com/en/actions/learn-github-actions/contexts#github-context) variables will make sure that the repository that is downloaded to the container—which includes the file or the directory that needs to be mounted—contains the most recent changes.  

The _render-compose-file_ step in your GHA workflow file should look like this:  

``` yaml
render-compose-file:
name: Render Docker Compose File
# Pass output of this workflow to another triggered by `workflow_run` event.
runs-on: ubuntu-latest
needs:
    - build-application
outputs:
    compose-file-cache-key: ${{ steps.hash.outputs.hash }}
steps:
    - name: Checkout git repo
    uses: actions/checkout@v3
    - name: Render Compose File
    run: |
        APP_IMAGE=${{ needs.build-application.outputs.tags }}
        export APP_IMAGE
        GHA_ACTOR=${{github.actor}}
        GHA_REPO=${{github.event.repository.name}}
        GHA_BRANCH=${{github.head_ref}}
        export GHA_ACTOR GHA_REPO GHA_BRANCH
        # Render simple template from environment variables.
        envsubst < ./uffizzi/docker-compose.uffizzi.yml > docker-compose.rendered.yml
        cat docker-compose.rendered.yml
```

You’ll need these variables only if you want the most recent changes reflected in your environment. If, however, your environment is not dependent on changes you make, these variables are not needed. 

### **Step 2: Download the git repo in your container**
You can now download the git repo in your container. Once you have access to the file/directory, you can then also move it to a custom location as if you were mounting a volume to a certain destination. 

In the following example, we will download the zipped source that contains the directories our container needs with the most recent changes using `wget` (make sure the utility is available in your container). In your `docker-compose.uffizzi.yml`, make the following changes in your container:  

```
  app:
    image: my_app_image
    ports:
    - "3000:3000"
    entrypoint: ["/bin/bash"]
    command:
    - "-c"
    - "apt-get update && \
      apt-get install wget -y && \ # install wget
      wget 'https://github.com/$GHA_ACTOR/$GHA_REPO/archive/refs/heads/$GHA_BRANCH.zip' && \ # download the most recent changes from the git repo
      unzip $GHA_BRANCH.zip -d . && \ # unzip at root
      rm -rf $GHA_BRANCH.zip # delete the zipped folder
      "
```

As your container comes up, these commands will be executed, and your git repo will be downloaded at the location you define in your container, and unzipping it will make your entire project available in the container. Alternatively, if your ephemeral environment is not dependent upon changes made to the file/directory you’re trying to mount, you can also simply clone the remote repository into the container at the location you want. 

This way the files and the directories you need will be made available to your application, and you will have easily passed the `File or Directory Too Large` error. In case this approach does not solve your problem, [reach out to us](https://www.uffizzi.com/contact) and let us know how we can help.  

&nbsp;  