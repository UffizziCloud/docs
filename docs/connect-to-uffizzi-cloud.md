**Section 3 of 3**  
# Connect to Uffizzi Cloud

In this section, we'll create a Uffizzi Cloud account and connect it with your CI provider.


## External CI

If you haven't already, sign up at [Uffizzi Cloud](https://app.uffizzi.com/sign_up), then follow the steps to set up your account.

!!! tip
    If you're using an external CI provider, such as GitHub Actions, GitLab, or CircleCI, you can skip **Step 3 of 4** of the setup guide. Credentials for your container registry should be passed via secrets from your CI provider as described [here](docker-compose-template.md#secrets), so you don't need to connect them in the Uffizzi Dashboard.

<details><summary>1. Make note of your project slug</summary>
<p>Make note of the project slug when creating your project. You will need it to set the <code>project</code> parameter of the <code>uffizzi-test-env</code> job of your pipeline that we configured in the <a href="../integrate-with-ci#reusable-workflow">previous section</a>. This can be seen highlighted in the image below. A project slug is unique, URL-compatible ID used to uniquely identify your project. You can also find the project slug on the Project Settings page, as shown in the second image below.
</p>
<img src="../../assets/images/project-slug.png">  
<hr>
<img src="../../assets/images/project-settings-slug.png">  
</details>

<details><summary>2. Add username, server, and project slug to your <code>uffizzi-test-env</code> job</summary>
<p>As described in the <a href="../integrate-with-ci#reusable-workflow">previous section</a> 
</p>
<img src="../../assets/images/project-slug.png">  
</details>

## Uffizzi CI


## Add Uffizzi password as a secret


## Suggested articles

* [Configure password-protected environments](password-protected.md)  
* [Set up single sign-on (SSO)](guides/single-sign-on.md)