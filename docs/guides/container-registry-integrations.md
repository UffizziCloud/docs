When defining your application stack with a [compose file](../references/compose-spec.md), you can choose to add your application components from source code or as pre-built images pulled from a container registry. This guide describes the process of configuring your registry and Uffizzi to preview container images. If your container registry provider is not listed below, [let us know](mailto:support@uffizzi.com).

## Amazon ECR  

To configure Uffizzi to pull images from your Amazon ECR, it is recommended that you first create a dedicated IAM user for this purpose. After creating this IAM user, add its credentials in the Uffizzi Dashboard. Finally, configure webhooks to send notifications to Uffizzi when you push new images to ECR.   

<details><summary>Create IAM user to authorize Uffizzi to pull images from ECR</summary>

<p>To fetch container images from your private ECR repositories, Uffizzi requires an API access key for an IAM User within your AWS Account. It's a best practice to grant this user only the permissions required. This section will walk you through creating a new IAM User, granting it strict permissions, and creating an API access key.</p>

<p>The easiest way to create this user is to use the AWS command-line interface (CLI). Make sure you have installed and configured the `aws` command on your workstation or container, including setting the default region to match your ECR repositories.</p>

</p>Create a new IAM User within your AWS Account. If you get an error that it already exists, that's fine.</p>

```
aws iam create-user --user-name uffizzi --output table
```  

<p>Attach an Amazon-managed policy to the new User. This grants permission only to list and read images.</p>

```
aws iam attach-user-policy --user-name uffizzi --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
```

<p>Create and obtain an API access key for this user. You'll need the output of this command soon.</p>

```
aws iam create-access-key --user-name uffizzi --query "[join(' ', ['Access Key ID:', AccessKey.AccessKeyId]), join(' ', ['Secret Access Key:', AccessKey.SecretAccessKey])]" --output table
```

<p>When you configure ECR within Uffizzi in the next step, you'll need these values.</p>  
</details>

<details><summary>Add IAM user credentials in the Uffizzi Dashboard</summary>

<p>In the Uffizzi Dashboard (UI), navigate to <code>Settings</code> > <code>Integrations</code>. There you will see a list that includes container registries supported by Uffizzi. Select <code>CONFIGURE</code> next to the Amazon ECR option.</p>

<img src="../../assets/images/settings-integrations.png">  

&nbsp;  
<p> When prompted, sign in to ECR with your registry domain, access key ID, and your secret access key. Once authenticated, Uffizzi will now be able to pull images from your registry.</p>  

<img src="../../assets/images/ecr-login.png">  

</details>   

<details><summary>Configure webhooks for Continuous Previews from ECR</summary>

<p>After configuring AWS ECR to pull images, you'll probably also want to enable Continuous Previews when you push a new container image. This requires configuring AWS EventBridge to send Uffizzi notifications via webhook HTTP requests. This section will walk you through configuring these webhooks.</p>

<p>The easiest way to configure these webhooks is to use the AWS CLI. Make sure you have installed and configured the <code>aws</code> command on your workstation or container, including setting the default region to match your ECR repositories.</p>

<p>Download the following shell script to configure these webhooks for you:</p>   

```
wget http://uffizzi.com/docs/setup/container-registry-integrations/assets/scripts/uffizzi_ecr_webhook_configure.bash
```


<p>Review the contents so you understand what you're executing. Then execute the script:</p>

```
bash ./uffizzi_ecr_webhook_configure.bash
```

<p>You should see output about the resource you've just created. If you see errors about resources already existing that's fine; that means someone else has already configured them.</p>

<p>You should also see the EventBridge Rule and other resources within the AWS Console:<p>    

<img src="../../assets/images/ecr-webhook-screenshot.png">  

</details>
<details><summary>Removing webhook configuration</summary>

<p>We've also provided a script to remove all of this configuration. Use this when you want to reconfigure the webhooks or when you no longer require automatic deployment to Uffizzi.<p>

</p>Download the removal script:</p>

```
wget https://uffizzi.zendesk.com/hc/article_attachments/4410648688919/uffizzi_ecr_webhook_remove.bash
```

<p>Review the contents so you understand what you're executing. Then execute the removal script:</p>

<code>bash ./uffizzi_ecr_webhook_remove.bash</code>  
</details>

<details><summary>Removing IAM User</summary>

<p>You can revoke Uffizzi's access to your ECR repositories by detaching the policy from the IAM User:</p>

    
```
aws iam detach-user-policy --user-name uffizzi --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
```

<p>If no longer needed, you can then delete the IAM User. You must first delete all of the user's API Access Keys.</p>
</details>

## Azure Container Registry (ACR)  

To configure Uffizzi to pull images from your ACR, it is recommended that you first create a dedicated service principal for this purpose, along with an Application and Subscription. After creating these resources, add the service principal's credentials in the Uffizzi Dashboard. Finally, configure webhooks to send notifications to Uffizzi when new images or tags are pushed to ACR.   

<details><summary>Create Azure service principal to authorize Uffizzi to pull images from ACR</summary>

<p>To access your container images directly, Uffizzi requires access to your Azure Container Registry. The easiest way to accomplish this is to <a href="https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals">create a service principal and grant it the `ACRPull` role</a>.</p>

<p>You may need to <a href="https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app">create an Application with a Subscription</a>.</p>

<p>Once you have an active Subscription and a <a href="https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli">Container Registry</a>, you can use the <code>create-for-rbac</code> command to create a service principal and simultaneously grant it the <code>ACRPull</code> role:</p>

```
az ad sp create-for-rbac --name uffizzi-example-acrpull --scopes /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/uffizzi-example/providers/Microsoft.ContainerRegistry/registries/uffizziexample --role acrpull
```

<p>This command will output a JSON object with some values you will need later: <code>appId</code> and <code>password</code>. See the <a href="https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli">Azure CLI documentation</a> for details about this command.
</details>

<details><summary>Add your Azure service principal in the Uffizzi Dashboard</summary>
<p>To grant Uffizzi access to pull images from your ACR, you will need:</p>

<ul>
  <li>Your registry domain (<i>registry-name</i>.azurecr.io)</li>
  <li>Application ID</li>
  <li>Password</li>
</ul>

<p>The Application ID and Password are provided in the output from the <code>create-for-rbac</code> command above, or they can be obtained within the Azure web portal.</p>

<p>Log in to the <a href="https://app.uffizzi.com">Uffizzi Dashboard (UI)</a> and navigate to <b>Settings</b> > <b>Integrations</b> then select <b>CONFIGURE</b> next to the ACR option.</p>

<img src="../../assets/images/settings-integrations.png">  

&nbsp;   
<p>Enter your credentials when prompted, then click <b>Sign in to Azure Container Registry</b>. Uffizzi should now have access to pull images from your ACR.</p>  

<img src="../../assets/images/acr-login.png">

</details>

<details><summary>Configure webhooks for Continuous Previews from ACR</summary>

<p>If you've added images from ACR to a template or compose file, you'll probably also want to enable continuous previews when you push a new container image. This requires adding a webhook to send Uffizzi notifications. This section will walk you through configuring this webhook.</p>

<p>The easiest way to configure these webhooks is to use the Azure command-line interface (CLI). Make sure you have installed and configured the <code>az</code> command on your workstation or container.</p>

<p>First identify which ACR Registry you want to use for automatic deployments.</p>

```
az acr list --output table
```

<p>Use the name of that registry when you add the webhook:</p>

```
az acr webhook create --registry <registry name> --name uffizzi --actions push --uri https://app.uffizzi.com/api/v1/webhooks/azure
```
</details>

<details><summary>Removing webhook configuration</summary>

<p>To stop sending notifications to Uffizzi, you can remove the webhook you configured above:</p>

```
 az acr webhook delete --registry <registry name> --name uffizzi
```
</details>

## Google Container Registry (GCR)  

To configure Uffizzi to pull images from your GCR, you need to add your GCR key file in the Uffizzi Dashboard (UI). Once added, configure a webhook to send notifications to Uffizzi when you push new images to GCR.   

<details><summary>Authorize Uffizzi to pull container images from GCR</summary>

<p>To grant Uffizzi access to pull images from your GCR, you will need a JSON key file.</p>

<p>Log in to the <a href="https://app.uffizzi.com">Uffizzi Dashboard</a> and navigate to <b>Settings</b> > <b>Integrations</b>, then select <b>CONFIGURE</b> next to the GCR option.</p>

<img src="../../assets/images/settings-integrations.png">  
&nbsp;  

<p>Upload or copy and paste your key file when prompted, then click <b>Add GCR Key File</b>. Uffizzi should now have access to pull images from your GCR.</p>  

<img src="../../assets/images/gcr-login.png">  


</details>

<details><summary>Configure webhooks for continuous previews from GCR</summary>

<p>If you've added images from GCR to a template or compose file, you'll probably also want to enable continuous previews when you push a new container image. This requires adding a webhook to send Uffizzi notifications. This section will walk you through configuring this webhook.</p>

<p>The easiest way to configure these webhooks is to use the Google Cloud command-line interface (CLI). Make sure you have installed and configured the <code>gcloud</code> command on your workstation or container.</p>

<p>First, create a Topic on Google's Pub/Sub API:</p>

```
gcloud pubsub topics create gcr
```

<p>Then configure a Subscription to notify Uffizzi:</p>

```
gcloud pubsub subscriptions create uffizzi-gcr-webhook --topic=gcr --push-endpoint=https://app.uffizzi.com/api/v1/webhooks/google --expiration-period=never --message-retention-duration=10m
```

<p>If these commands fail, make sure you have enabled the Pub/Sub API for your Google Cloud Project. You may also need to specify </code>--project</code> if you have multiple Google Cloud Projects.</p>

<p>Learn more about <a href="https://cloud.google.com/container-registry/docs/configuring-notifications">configuring notifications</a> from GCR.</p>

</details>

<details><summary>Removing Webhook Configuration</summary>

<p>To stop sending notifications to Uffizzi, you can remove the webhook you configured above:</p>

```
gcloud pubsub subscriptions delete uffizzi-gcr-webhook
```

<p>If this was your only Subscription to the GCR Topic, you could also delete that Topic.</p>

<p>If that was your only Topic, you could also disable the Pub/Sub API.</p>

</details>

## Docker Hub  

To configure Uffizzi to pull images from your private Docker Hub registry, it is recommended that you first create an Access Token to provide to Uffizzi. Once authorized, Uffizzi will automatically configure webhooks on your registry to be notified when you push new images.  

<details><summary>Create an access token for Docker Hub</summary>

<p> Log in to <a href="https://hub.docker.com">Docker Hub</a>, then navigate to <b>Account Settings</b> > <b>Security</b> and select the <b>New Access Token</b> button. In the <b>Access Token Description</b> field, enter "uffizzi" or a similar description. For <b>Access permissions</b> choose <b>Read-only</b>, then select <b>Generate</b> to create your Access Token.</p>

<img src="../../assets/images/docker-hub-generate-access-token.png">

<p>On the next screen, you should see your Accesss Token. Save this value, as you will need it in the next step.</p>

<img src="../../assets/images/docker-hub-access-token.png">

</details>

<details><summary>Authorize Uffizzi to pull container images from Docker Hub</summary>  

<p>Log in to the <a href="https://app.uffizzi.com">Uffizzi Dashboard</a> and navigate to <b>Settings</b> > <b>Integrations</b>, then select <b>CONFIGURE</b> next to the Docker Hub option.</p>

<img src="../../assets/images/settings-integrations.png">

<p>Enter your Docker ID and the access token you created, then select <b>Sign in to Docker Hub</b>. Uffizzi should now have access to pull images from your Docker Hub registry. Uffizzi will automatically configure a webhook to be notified when you push new images.</p>

<img src="../../assets/images/docker-hub-login.png">  

</details>

<details><summary>Deleting the access token for Docker Hub</summary>  

<p> Log in to <a href="https://hub.docker.com">Docker Hub</a>, then navigate to <b>Account Settings</b> > <b>Security</b>. Select the the checkbox next the access token you added in the Uffizzi Dashboard, then select <b>Delete</b> and <b>Delete Forever</b> to confirm. 

<img src="../../assets/images/docker-hub-delete-access-token.png">

<img src="../../assets/images/docker-hub-delete-access-token-confirmation.png">


</details>
