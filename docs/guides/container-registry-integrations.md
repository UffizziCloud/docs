When defining your application stack with a compose file or template, you can choose to add your application components from source code or as pre-built container images. Uffizzi has out-of-the-box support for the following hosted container registry providers. If your provider is not listed below, consider contributing a new integration to [open-source Uffizzi](https://github.com/UffizziCloud).

## Amazon ECR  
#### Authorize Uffizzi to pull container images from ECR

To fetch container images from your private ECR repositories, Uffizzi requires an API access key for an IAM User within your AWS Account. It's a best practice to grant this user only the permissions required. This section will walk you through creating a new IAM User, granting it strict permissions, and creating an API access key.

The easiest way to create this user is to use the AWS command-line interface (CLI). Make sure you have installed and configured the `aws` command on your workstation or container, including setting the default region to match your ECR repositories.

Create a new IAM User within your AWS Account. If you get an error that it already exists, that's fine.

    aws iam create-user --user-name uffizzi --output table  

Attach an Amazon-managed policy to the new User. This grants permission only to list and read images.

    aws iam attach-user-policy --user-name uffizzi --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

Create and obtain an API access key for this user. You'll need the output of this command soon.

    aws iam create-access-key --user-name uffizzi --query "[join(' ', ['Access Key ID:', AccessKey.AccessKeyId]), join(' ', ['Secret Access Key:', AccessKey.SecretAccessKey])]" --output table

When you configure ECR within Uffizzi, you'll need those values.  
&nbsp;  
#### Configure webhooks for continuous previews from Amazon ECR

After configuring AWS ECR to pull images, you'll probably also want to enable continuous previews when you push a new container image. This requires configuring AWS EventBridge to send Uffizzi notifications via webhook HTTP requests. This section will walk you through configuring these webhooks.

The easiest way to configure these webhooks is to use the AWS CLI. Make sure you have installed and configured the `aws` command on your workstation or container, including setting the default region to match your ECR repositories.

Download the following shell script to configure these webhooks for you:   

    wget http://uffizzi.com/docs/setup/container-registry-integrations/assets/scripts/uffizzi_ecr_webhook_configure.bash


Review the contents so you understand what you're executing. Then execute the script:

    bash ./uffizzi_ecr_webhook_configure.bash

You should see output about the resource you've just created. If you see errors about resources already existing that's fine; that means someone else has already configured them.

You should also see the EventBridge Rule and other resources within the AWS Console:  

![Screenshot](../assets/images/ecr-webhook-screenshot.png)
&nbsp;  
#### Removing webhook configuration

We've also provided a script to remove all of this configuration. Use this when you want to reconfigure the webhooks or when you no longer require automatic deployment to Uffizzi.

Download the removal script:

    wget https://uffizzi.zendesk.com/hc/article_attachments/4410648688919/uffizzi_ecr_webhook_remove.bash

Review the contents so you understand what you're executing. Then execute the removal script:

    bash ./uffizzi_ecr_webhook_remove.bash
&nbsp;  
#### Removing IAM User

You can revoke Uffizzi's access to your ECR repositories by detaching the policy from the IAM User:

    
    aws iam detach-user-policy --user-name uffizzi --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

If no longer needed, you can then delete the IAM User. You must first delete all of the user's API Access Keys.

## Azure Container Registry (ACR)  

#### Authorize Uffizzi to pull container images from ACR  

To access your container images directly, Uffizzi requires access to your Azure Container Registry. The easiest way to accomplish this is to create a Service Principal and grant it the `ACRPull` role. You can read more about Azure Service Principals here: <https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals>

You may need to create an Application with a Subscription. You can read more about this here: <https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app>

Once you have an active Subscription and [a Container Image Registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli), you can use the `create-for-rbac` command to create a service principal and simultaneously grant it the `ACRPull` role:

```
az ad sp create-for-rbac --name uffizzi-example-acrpull --scopes /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/uffizzi-example/providers/Microsoft.ContainerRegistry/registries/uffizziexample --role acrpull
```

This command will output a JSON object with some values you will need later: `appId` and `password`. You can read more about this command here: <https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli>

#### Configure Uffizzi to use Azure Service Principal
To grant Uffizzi access to pull images from your ACR, you will need:  

* Your registry domain (*myregistry*.azurecr.io)
* Application ID
* Password

The Application ID and Password are provided in the output from the `create-for-rbac` command above, or they can be obtained within the Azure web portal.

Log into [app.uffizzi.com](https://app.uffizzi.com) and navigate to **Settings** -> **Integrations**, then select **CONFIGURE** next to ACR. Enter your credentials when prompted, then click **SAVE**. Uffizzi should now have access to pull images from your ACR.
&nbsp;  
#### Configure webhooks for continuous previews from ACR

If you've added images from ACR to a template or compose file, you'll probably also want to enable continuous previews when you push a new container image. This requires adding a webhook to send Uffizzi notifications. This section will walk you through configuring this webhook.

The easiest way to configure these webhooks is to use the Azure command-line interface (CLI). Make sure you have installed and configured the `az` command on your workstation or container.

First identify which ACR Registry you want to use for automatic deployments.

    az acr list --output table

Use the name of that registry when you add the webhook:

    az acr webhook create --registry <registry name> --name uffizzi --actions push --uri https://app.uffizzi.com/api/v1/webhooks/azure
&nbsp;  
#### Removing webhook configuration

To stop sending notifications to Uffizzi, you can remove the webhook you configured above:

    az acr webhook delete --registry <registry name> --name uffizzi

## Google Container Registry (GCR)  

#### Authorize Uffizzi to pull container images from GCR  
To grant Uffizzi access to pull images from your GCR, you will need a JSON key file.  

Log into [app.uffizzi.com](https://app.uffizzi.com) and navigate to **Settings** -> **Integrations**, then select **CONFIGURE** next to GCR. Upload or copy and paste your key file when prompted, then click **SAVE**. Uffizzi should now have access to pull images from your GCR.  
&nbsp;  
#### Configure webhooks for continuous previews from GCR
If you've added images from GCR to a template or compose file, you'll probably also want to enable continuous previews when you push a new container image. This requires adding a webhook to send Uffizzi notifications. This section will walk you through configuring this webhook.

The easiest way to configure these webhooks is to use the Google Cloud command-line interface (CLI). Make sure you have installed and configured the `gcloud` command on your workstation or container.

First, create a Topic on Google's Pub/Sub API:

    gcloud pubsub topics create gcr

Then configure a Subscription to notify Uffizzi:

    gcloud pubsub subscriptions create uffizzi-gcr-webhook --topic=gcr --push-endpoint=https://app.uffizzi.com/api/v1/webhooks/google --expiration-period=never --message-retention-duration=10m

If these commands fail, make sure you have enabled the Pub/Sub API for your Google Cloud Project.  You may also need to specify --project if you have multiple Google Cloud Projects.

You can read more about configuring notifications from GCR here: [https://cloud.google.com/container-registry/docs/configuring-notifications](https://cloud.google.com/container-registry/docs/configuring-notifications)  
&nbsp;  
#### Removing Webhook Configuration

To stop sending notifications to Uffizzi, you can remove the webhook you configured above:

gcloud pubsub subscriptions delete uffizzi-gcr-webhook
If this was your only Subscription to the gcr Topic, you could also delete that Topic.

If that was your only Topic, you could also disable the Pub/Sub API.
