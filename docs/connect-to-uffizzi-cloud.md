**Section 3 of 3**  
# Connect to Uffizzi Cloud

In this section, we'll create a Uffizzi Cloud account and connect it with your CI provider.


## Connect to Uffizzi Cloud from an external CI provider

In the [previous section](integrate-with-ci.md), we added a GitHub Actions [reusable workflow](https://github.com/UffizziCloud/preview-action/blob/master/.github/workflows/reusable.yaml) to our pipeline that takes as input several parameters, including:

  * `username`
  * `server`
  * `project`
  * `UFFIZZI_PASSWORD`

In this section, we'll create the `username`, `UFFIZZI_PASSWORD`, and `project` values to pass to the workflow. If you haven't already done so, sign up at [Uffizzi Cloud](https://app.uffizzi.com/sign_up), and then follow the steps to set up your account.

!!! tip
    If you're using an external CI provider, such as GitHub Actions, GitLab, or CircleCI, you can skip **Step 3 of 4** of the setup guide. Credentials for your container registry should be passed via secrets from your CI provider as described [here](docker-compose-template.md#secrets), so you don't need to connect them in the Uffizzi Dashboard.

<details><summary>1. Make note of your project slug</summary>
<p>Make note of the project slug when creating your project. You will need it to set the <code>project</code> parameter of the <code>uffizzi-test-env</code> job of your pipeline that we configured in the <a href="../integrate-with-ci#reusable-workflow">previous section</a>. A project slug is URL-compatible ID used to uniquely identify your project. This can be seen highlighted in the image below. You can also find the project slug on the Project Settings page, as shown in the second image below. 
</p>
<img src="../../assets/images/project-slug.png">  
<hr>
<img src="../../assets/images/project-settings-slug.png">  
</details>

<details><summary>2. Add username, server, and project slug to your <code>uffizzi-test-env</code> job</summary>
<p>Back in GitHub Actions, input your Uffizzi <code>username</code> (i.e. email address), <code>server</code> (https://app.uffizzi.com), and <code>project</code> slug values into the <code>uffizzi-test-env</code> job, as highlighted below:

    ``` yaml title=".github/workflows/ci.yml" hl_lines="14 15 16"
    name: Build images and deploy with Uffizzi

      [...]

      # Create, update, and delete test environments with Uffizzi
      uffizzi-test-env:
        name: Use Remote Workflow to Preview on Uffizzi
        needs: render-compose-file
        uses: UffizziCloud/preview-action/.github/workflows/reusable.yaml@reusable-workflow
        if: github.event_name == 'pull_request'
        with:
          compose-file-cache-key: ${{ needs.render-compose-file.outputs.compose-file-cache-key }}
          compose-file-cache-path: docker-compose.rendered.yml
          username: foo@example.com
          server: https://app.uffizzi.com
          project: app-9djwj8
        secrets:
          password: ${{ secrets.UFFIZZI_PASSWORD }}
        permissions:
          contents: read
          pull-requests: write
    ```
</p>
<img src="../../assets/images/project-slug.png">  
</details>

<details><summary>3.Add <code>UFFIZZI_PASSWORD</code> as a GitHub Actions secret</summary>
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
```
    secrets:
      password: ${{ secrets.UFFIZZI_PASSWORD }}
```
</details>

That's it! Your pipeline is now configured to use Uffizzi. To test your pipeline, try opening a new pull request.


## Suggested articles

* [Configure password-protected environments](password-protected.md)  
* [Set up single sign-on (SSO)](guides/single-sign-on.md)