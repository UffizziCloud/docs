**Section 3 of 3**  
# Configure credentials

In this section, we'll create a Uffizzi Cloud account and connect it with your CI provider.

## **Uffizzi CI**

If you're using Uffizzi CI, you will need to link to the Docker Compose template in your GitHub repository from the Uffizzi Dashboard. If you haven't already done so, sign up at [Uffizzi Cloud](https://app.uffizzi.com/sign_up), and then follow the steps to set up your account.

<details><summary>1. Connect the Uffizzi GitHub App</summary>
<p>In this step you will install the Uffizzi GitHub App and grant Uffizzi access to the repositories you want to deploy. Login to Uffizzi, then navigate to <b>Account</b> > <b>Settings</b> > <b>General</b>, then select <b>Configure</b> next to the GitHub option.
</p>
<img src="../../assets/images/configure-github-app.png">  
<hr>
<p>You'll be asked to Install Uffizzi Cloud, then grant access to your repositories.</p>
<hr>
<img src="../../assets/images/repos.png">
<hr>
<p>Similarly, you can manage the Uffizzi app installation from GitHub by navigating to <b>Settings</b> > <b>Applications</b> > <b>Uffizzi Cloud</b> > <b>Configure</b></p>
<img src="../../assets/images/github-apps-configure.png">
<hr>
</details>

If the Docker Compose template you created in <a href="../docker-compose-template">Section 1</a> references images stored in a private container registry, add those credentials in this step, as indicated in the screenshot below:

<details><summary>2. Add application secrets</summary>
<p>If your compose file includes [application secrets](https://docs.uffizzi.com/references/compose-spec/#secrets), such as database credentials, you can add them in the Uffizzi Dashboard. Navigate to your project, then select <b>Specs</b> > <b>Secrets</b> > <b>NEW SECRET</b>. This will open a modal, where you can input your secrets as <code>NAME=VALUE</code> pairs. Be sure to add one secret per line, separatedy by <code>=</code> with no white spaces.
</p>
<img src="../../assets/images/settings-secrets.png">  
<hr>
<img src="../../assets/images/add-secrets.png">  
<hr>
<p>Once the secrets are saved, you will not be able to view or edit their values. To make changes to a secret, first delete the old secret, then create a new one.
</details>

<details><summary>3. Link to your Docker Compose template</summary>
<p>In this final step, we'll link to our Docker Compose template that's stored in our GitHub repository. To do this, navigate to your project, then select <b>Specs</b> > <b>Compose</b> > <b>NEW COMPOSE</b>. Next, select the repository, branch (typically this is the branch you open pull requests against), and name of the compose file. Finally, select <b>VALIDATE & SAVE</b>.
</p>
<img src="../../assets/images/settings-compose-file.png"> 
<hr>
<p>Note, if you did not add your secrets as described in the previous step, you will see a validation error with a link to add your secretes.</p>
<img src="../../assets/images/settings-compose-resolve-errors.png">  
<hr>
<p>Once your compose file has been successfully added, you will see it in the Uffizzi Dashboard with a link to its source on GitHub. Any changes you make to this compose file on GitHub will be synced in the Uffizzi Dashboard.</p>
<img src="../../assets/images/settings-compose-synced.png">
<hr>
</details>

That's it! Uffizzi is now configured with your Docker Compose template. To test your setup, you can manually deploy your primary branch to an on-demand test environment using the **Test Compose** button in the Uffizzi Dashboard, or try opening a pull request on GitHub to deploy a feature branch.

## **Connect container registy credentials to Uffizzi**

Follow this section if you're using an external container registry, such as GHCR, ECR, or Docker Hub, to store your built images (i.e. You are not relying on Uffizz CI to storage images for you).

How you add container registry credentials to Uffizzi depends on your registry of choice.

### GitHub Container Registry (ghcr.io)

<p>If you use GitHub Container Registry (ghcr.io), you will need to generate a <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token">GitHub personal access token</a> with access to the <code>read:packages</code> scope. Once this token is generated, <a href="https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository">add it as a GitHub repository secret</a>, then pass this value to the <a href="https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml">reusable workflow</a> using the <code>personal-access-token</code> parameter, as described in the <a href="../integrate-with-ci#reusable-workflow">previous section</a>.</p>

``` yaml
    secrets:
      personal-access-token: ${{ secrets.GHCR_ACCESS_TOKEN }}
```

Once you've created a personal access token, you should add it in your Uffizzi Account Settings.

<details><summary>Add GHCR personal access token in Account Settings</summary>
Login to Uffizzi, then navigate to <b>Account</b> > <b>Settings</b> > <b>Registries</b>, then select <b>Configure</b> next to the GHCR option.</p>
<img src="../../assets/images/account-settings-registries.png">
<hr>
<img src="../../assets/images/ghcr-login.png">
<hr>
<p>Enter your GitHub username and personal access token, then select <b>Sign in to GitHub Container Registry</b>.
</details>

### ECR, ACR, GCR, Docker Hub
If you use Amazon ECR, Azure Container Registry (ACR), Google Container Registry (GCR), or Docker Hub, you should add your credentials as [GitHub repository secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository).

<details><summary>See this AWS ECR example</summary>
<p>If you use Amazon ECR, Azure Container Registry (ACR), Google Container Registry (GCR), or Docker Hub, you should add your credentials as <a href="https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository">GitHub repository secrets</a>. In the highlighted example below, <code>AWS_ACCESS_KEY_ID</code> and <code>AWS_SECRET_ACCESS_KEY</code> are used:</p>

    ``` yaml title=".github/workflows/ci.yml" hl_lines="15 16"
    [...]

    jobs:
      # Build and push app image
      build-app:
        name: Build and Push `app`
      runs-on: ubuntu-latest
      outputs:
        tags: ${{ steps.meta.outputs.tags }}
      steps:
        - name: Login to ECR
          uses: docker/login-action@v2
          with:
            registry: 263049488290.dkr.ecr.us-east-1.amazonaws.com
            username: ${{ secrets.AWS_ACCESS_KEY_ID }}
            password: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        - name: Checkout git repo
          uses: actions/checkout@v3
        - name: Docker metadata
          id: meta
          uses: docker/metadata-action@v3
          with:
            images: 263049488290.dkr.ecr.us-east-1.amazonaws.com/app
        - name: Build and Push Image to ECR
          uses: docker/build-push-action@v2
          with:
            push: true
            tags: ${{ steps.meta.outputs.tags }}
            labels: ${{ steps.meta.outputs.labels }}
            context: ./app
    
      [...]

    ```

<p>Now, we need to add these same credentials in the Uffizzi Dashboard. In <b>Step 3 of 4</b> of the account setup guide, you are asked to connect to various external services, as shown below. Select the <b>Sign in</b> option for your registry provider(s) of choice, then enter your credentials. For example, to add <code>AWS_ACCESS_KEY_ID</code> and <code>AWS_SECRET_ACCESS_KEY</code>, select <b>Sign in to Amazon Elastic Container Registry</b>.</p> 
<img src="../../assets/images/add-container-registry-credentials.png">
<hr>
<p>After account setup, you can make changes to your credentials by selecting <b>Menu</b> (three horizontal lines) > <b>Settings</b> > <b>Integrations</b> > <b>CONFIGURE/DISCONNECT</b>.</p>
<img src="../../assets/images/settings-integrations-container-registries.png">
<hr>
</details>

That's it! Your pipeline is now configured to use Uffizzi. To test your pipeline, try opening a new pull request.

## Suggested articles

* [Configure password-protected environments](password-protected.md) 
* [`UFFIZZ_URL` environment variable](../references/uffizzi-environment-variables.md)
* [Set up single sign-on (SSO)](single-sign-on.md)
