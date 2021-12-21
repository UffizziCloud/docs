##Configuration Options

Option 1- **Compose**  - A configuration-as-code YAML - `docker-compose.uffizzi.yml`- based on Docker Compose (version 3.9) .
            Unless otherwise noted, Uffizzi recognizes Docker Compose syntax.

Option 2- **Templates** - Configurations created and managed in the Uffizzi Web Interface (GUI).

##Build Options

Option 1- **Bring Your Own Build** (BYOB) - Use your existing CI/CD to handle the Build. 
     
   *This is for users who have custom builds or who are using a VCS that is not yet integrated with Uffizzi.

Option 2- **Use Uffizzi's Integrated Build** - Uffizzi will build from source from your connected VCS.

   *This is for users on Github who want Uffizzi to manage the full processs.

##Integrations and Webhooks

Out-of-the-box Uffizzi supports integrations with Github, Docker Hub, AWS Elastic Container Registry, Azure's Container Registry, and Google's Container Registry.  Ensure you have connected to the relevant Repos and Registries at the Account Level Settings.  

Uffizzi will automatically set-up webhooks with Github and Docker Hub.  For ECR, ACR, and GCR the user must manually set-up the [webhooks](config/container-registry-integrations.md).

## Using Compose

1. Write Your Compose - Start with your `docker-compose.yml` and create a new file named `docker-compose.uffizzi.yml`.  Check [References](https://docs.uffizzi.com/config/compose-spec/) and [Examples](examples/example-compose.md) for detailed information on how to write your `docker-compose.uffizzi.yml`.  


2. Add your `uffizzi` element(s) and save your `docker-compose.uffizzi.yml` at the top level of the `main` or primary branch in your repository.  

![Screenshot](../assets/images/compose-in-git.png)

### Connecting Your Compose

3. Within the Uffizzi UI go to Projects/Specs/Compose and select `new compose` to connect to your `docker-compose.uffizzi.yml` which should be stored in your git repository.  To connect to your repository see [Source Code Integrations](config/source-code-integrations.md).

![Screenshot](../assets/images/compose-one.png)

After adding the repo, branch, and path, select the `validate` button - Uffizzi will confirm if your file is valid or will provide error messaging that indicates what needs to be addressed.

![Screenshot](../assets/images/add-compose.png)

If you want `uffizzi_app` to recognize changes to your `docker-compose.uffizzi.yml` check the Box for "Auto-deploy updates".

Save your setting and return to Project Overview.

### Initiating a Trigger-based Preview

#### `Open Pull Request` Trigger 
 If you have enabled a Pull Request trigger in your compose you can initiate a preview by opening a `pull request` within any git repository that is invoked by your `docker-compose.uffizzi.yml`.

![Screenshot](../assets/images/open-pr.png)

The webhook within your git repo will inform `uffizzi_app` of the `Open pull request` and initiate the Preview.

#### Bring Your Own Build `Tag-based` Trigger
 If you have enabled a Tag-based trigger the webhook within your image registry will inform `uffizzi_app` of the new image tagged with `uffizzi_request_#` and will initiate the Preview.

When a Preview is triggered `uffizzi_app` will show the new Preview and its status:

![Screenshot](../assets/images/initiated-preview.png)

The Preview will take a few minutes to finish deploying - the build process is typically the longest part of the sequence.  You can monitor the status by clicking on your Preview.  Within the UI you can monitor the activity log, build logs, individual container logs, and event logs.

![Screenshot](../assets/images/preview-status.png)


When the Preview has finished deploying, the Preview URL turns blue - the link is now live and you can securely access your Preview.  Please note that if you have deployed multiple containers, some of those containers may still take time to fully initiate after the Preview URL goes live.

![Screenshot](../assets/images/preview-link-live.png)

### Deleting a Trigger-based Preview

1- `Close Pull Request` Deletion Trigger - If you have enabled deletion based on a Close Pull Request trigger in your compose your Preview will be deleted by merging or closing the respective `pull request` that initiated the Preview.

2- `Time-based` Deletion Trigger - If you have enabled time-based deletion, your Preview will be deleted after the specified amount of time. The range is 1h to 720h.

3- You can always delete a Preview by selecting the `trash` icon in the UI.

![Screenshot](../assets/images/delete.png)

If you have enabled both a `Close Pull Request` deletion trigger and a `Time-based` deletion trigger, `uffizzi_app` will recognize whichever trigger fires first.

*Note- for Previews initiated with a `Tag-based` trigger the only programmatic deletion is `Time-based`.  This will be improved with future releases.

### Initiating a Manual Preview

Alternatively, you can select `new preview` from the UI and choose a compose from within your connected repository to deploy a preview.  If you use this method to initiate a preview you must manually delete it from the UI.

![Screenshot](../assets/images/compose-two.png)

![Screenshot](../assets/images/compose-three.png)

![Screenshot](../assets/images/compose-four.png)


### Deleting a Manual Preview

You can always delete a Preview by selecting the `trash` icon in the UI.

![Screenshot](../assets/images/delete.png)

## Using Templates
