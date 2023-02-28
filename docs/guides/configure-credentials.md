**Section 3 of 3**  
# Configure credentials

In this section, we'll create a Uffizzi Cloud account and connect it with your CI provider.

## Uffizzi CI

If you're using Uffizzi CI, you will need to link to the Docker Compose template in your GitHub repository from the Uffizzi Dashboard. If you haven't already done so, sign up at [Uffizzi Cloud](https://app.uffizzi.com/sign_up), and then follow the steps to set up your account.

<details><summary>1. Connect to GitHub and your container registries</summary>
<p>In <b>Step 3 of 4</b> of the account setup guide, you are asked to connect to various external services. Select <b>Sign in to GitHub</b> to install the Uffizzi app in your GitHub account, then grant Uffizzi access to the repositories you want to deploy. If the Docker Compose template you created in <a href="../docker-compose-template">Section 1</a> references images stored in a private container registry, add those credentials in this step, as indicated in the screenshot below:
</p>
<img src="../../assets/images/configure-repositories.png">  
<hr>
<p>If you need to make changes to your GitHub credentials in the Uffizzi Dashboard, navigate to <b>Settings</b> > <b>Integrations</b> > <b>GitHub</b> > <b>CONFIGURE/DISCONNECT</b>.</p>
<img src="../../assets/images/settings-integrations-github.png">  
<hr>
<p>Similarly, you can manage the Uffizzi app installation from GitHub by navigating to <b>Settings</b> > <b>Applications</b> > <b>Uffizzi Cloud</b> > <b>Configure</b></p>
<img src="../../assets/images/github-apps-configure.png">
<hr>
</details>

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

## Connect to Uffizzi Cloud from an external CI provider

In the [previous section](integrate-with-ci.md), we added a GitHub Actions [reusable workflow](https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml) to our pipeline that takes several inputs, including:

  * `username`
  * `server`
  * `project`
  * `password`

In this section, we'll add our container registry credentials in the Uffizzi Dashboard, then create the `username`, `password`, and `project` values to pass to the workflow. If you haven't already done so, sign up at [Uffizzi Cloud](https://app.uffizzi.com/sign_up), and then follow these steps to set up your account:

<details><summary>1. Add container registry credentials to Uffizzi</summary>
<p>How you add container registry credentials to Uffizzi depends on your registry of choice.</p>

<h4>GHCR</h4>

<p>If you use GitHub Container Registry (ghcr.io), you will need to generate a <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token">GitHub personal access token</a> with access to the <code>read:packages</code> scope. Once this token is generated, <a href="https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository">add it as a GitHub repository secret</a>, then pass this value to the <a href="https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml">reusable workflow</a> using the <code>personal-access-token</code> parameter, as described in the <a href="../integrate-with-ci#reusable-workflow">previous section</a>.</p>

``` yaml
    secrets:
      personal-access-token: ${{ secrets.GHCR_ACCESS_TOKEN }}
```

<h4>ECR, ACR, GCR, Docker Hub</h4>

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

<details><summary>2. Make note of your project slug</summary>
<p>In <b>Step 4 of 4</b>, make note of the project slug when creating your project. You will need it to set the <code>project</code> parameter of the <code>deploy-uffizzi-preview</code> and <code>delete-uffizzi-preview</code> jobs of your pipeline that we configured in the <a href="../integrate-with-ci#reusable-workflow">previous section</a>. A project slug is URL-compatible ID used to uniquely identify your project. This can be seen highlighted in the image below. You can also find the project slug on the Project Settings page, as shown in the second image below. 
</p>
<img src="../../assets/images/project-slug.png">  
<hr>
<img src="../../assets/images/project-settings-slug.png">  
</details>

<details><summary>3. Add <code>username</code>, <code>server</code>, and <code>project</code> to your create, update, and delete jobs</summary>
<p>Back in GitHub Actions, input your Uffizzi <code>username</code> (i.e. email address), <code>server</code> (https://app.uffizzi.com), and <code>project</code> slug values into the deploy and delete jobs, as highlighted below:

    ``` yaml title=".github/workflows/ci.yml" hl_lines="14 15 16 34 35 36"
    name: Build images and deploy with Uffizzi

      [...]

      # Create and update test environments with Uffizzi
      deploy-uffizzi-preview:
        name: Use Remote Workflow to Preview on Uffizzi
        needs: render-compose-file
        uses: UffizziCloud/preview-action/.github/workflows/reusable.yaml@v2.1.0
        if: ${{ github.event_name == 'pull_request' && github.event.action != 'closed' }}
        with:
          compose-file-cache-key: ${{ needs.render-compose-file.outputs.compose-file-cache-key }}
          compose-file-cache-path: docker-compose.rendered.yml
          username: foo@example.com
          server: https://app.uffizzi.com
          project: my-application
        secrets:
          password: ${{ secrets.UFFIZZI_PASSWORD }}
          personal-access-token: ${{ secrets.GHCR_ACCESS_TOKEN }}
          url-username: admin
          url-password: ${{ secrets.URL_PASSWORD }}
        permissions:
          contents: read
          pull-requests: write

      # Delete test environments with Uffizzi
      delete-uffizzi-preview:
        name: Use Remote Workflow to Delete an Existing Preview
        uses: UffizziCloud/preview-action/.github/workflows/reusable.yaml@v2.1.0
        if: ${{ github.event_name == 'pull_request' && github.event.action == 'closed' }}
        with:
          compose-file-cache-key: ''
          compose-file-cache-path: docker-compose.rendered.yml
          username: foo@example.com
          server: https://app.uffizzi.com
          project: my-application
        secrets:
          password: ${{ secrets.UFFIZZI_PASSWORD }}
        permissions:
          contents: read
          pull-requests: write
    ```
</p>
</details>

<details><summary>4. Add <code>UFFIZZI_PASSWORD</code> as a GitHub Actions secret</summary>
<p>In GitHub, navigate to your repository, then select <b>Settings</b> > <b>Secrets</b> > <b>Actions</b> > <b>New repository secret</b>.</p>

<img src="../../assets/images/github-actions-secrets.png">
<hr>
<p>For the name, enter <code>UFFIZZI_PASSWORD</code>. For the value, enter your Uffizzi account password. Then select <b>Add secret</b>. After your secret is added here, you can update or remove it, but you will not be able to view the plaintext again within GitHub.

<img src="../../assets/images/github-add-secret.png">
<hr>
<p>Once your secret has been added, you should see it stored as a new repository secret.</p>
<img src="../../assets/images/github-repository-secrets.png">
<hr>
<p><code>UFFIZZI_PASSWORD</code> is now available to the reusable workflow via:</p>
``` yaml
    secrets:
      password: ${{ secrets.UFFIZZI_PASSWORD }}
```
</details>

That's it! Your pipeline is now configured to use Uffizzi. To test your pipeline, try opening a new pull request.

## Suggested articles

* [Configure password-protected environments](password-protected.md) 
* [`UFFIZZ_URL` environment variable](../references/uffizzi-environment-variables.md)
* [Set up single sign-on (SSO)](single-sign-on.md)
