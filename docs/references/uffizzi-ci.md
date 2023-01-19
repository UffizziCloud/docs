# Uffizzi CI  
_If you use [GitHub Actions](https://github.com/features/actions) or another CI provider, you do not need to use Uffizzi CI._

## What is Uffizzi CI?
Uffizzi CI is an integrated build and deployment service provided by Uffizzi Cloud free of charge. Choose this solution if you don't already have a CI platform or don't want to use your existing solution to build preview images.

Every time you push a new commit to your repository, Uffizzi CI receives a webhook and builds your application from source. This ensures that the latest changes are always included in your previews. To use Uffizzi CI, your code must be stored in a GitHub repository.

## Setting up Uffizzi CI
To set up Uffizzi CI, you'll first need to create a project in the Uffizzi Dashboard, then install and authorize the Uffizzi GitHub App. Once you've done that, you'll connect a [Compose file](../references/compose-spec.md) in your project settings. 

### **1. Create a Uffizzi CI project**

If you haven't already done so, create a Uffizzi CI project. Login to the [Uffizzi Dashboard](https://app.uffizzi.com/sign_in), then navigate to **Account** > **Projects**. Select **New project**  > **Uffizzi CI** > **Configure GitHub**  
<details><summary><strong>Click to expand (Screenshots)</strong></summary>
<img src="../../assets/images/new-uffizzi-ci-project.webp" width="600">
</details>

### **2. Install & Authorize the Uffizzi GitHub App**
After selecting **Configure GitHub**, you will be redirected to a GitHub login page to install and authorize the Uffizzi Cloud [GitHub App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps). If you have more than one GitHub account, be sure to install the GitHub App on the same account that you used to create your Uffizzi account. To install the Uffizzi Cloud GitHub App on an organizational account, you must have Owner permissions for your GitHub Organization.

<details><summary>Click to expand (Screenshots)</summary>
<p>Install Uffizzi Cloud on your GitHub account</p>
<img src="../../assets/images/install-github-app.webp" width="600">
<img src="../../assets/images/authorize-uffizzi.webp" width="600">
<hr>
</details>

Next, choose which repositories you wish to preview, then select **Install & Authorize**. Uffizzi requests only the minimum permissions it needs, which includes read access to your code and write access to pull request issues for posting comments. You can manage the GitHub App permissions from the **Developer Settings** page in GitHub.  

### **3. Add a Compose file in project settings**

After installing and authorizing the GitHub App, you will be redirected back to the Uffizzi Dashboard. From there you can select a repository to complete project set up.  

1. Select **Set up project** for your desired repository  
2. Add your [`docker-compose.uffizzi.yml`](../references/compose-spec.md) file in **Project** > **Settings** > **Compose file**. Be sure to choose the branch that you merge <i>into</i>, i.e. your target base branch. For example, if your team opens pull requests against `main`, select this branch.
3. Save and validate your Compose; resolve any errors  
4. Check your configuration with a test deployment  

<details><summary><strong>Click to expand (Screenshots)</strong></summary>
<p>1. Select Set up project for the repository you just forked</p>
<img src="../../assets/images/set-up-project.webp" width="600">
<p>2. Add your `docker-compose.uffizzi.yml` file in Project > Settings > Compose. Be sure to choose the branch that you merge <i>into</i>, i.e. your target base branch.</p>
<img src="../../assets/images/add-compose-in-settings.webp" width="600">
<p>3. Save and validate your Compose; resolve any errors  </p>
<img src="../../assets/images/resolve-compose-errors.webp" width="600">
<p>4. Check your configuration with a test deployment </p>
<img src="../../assets/images/compose-added.webp" width="600">
</details>  


## How to use Uffizzi CI  
Once everything is configured on both GitHub and Uffizzi, you don't need to do anything special to get Uffizzi CI working. Open pull requests as you normally do. Uffizzi CI will work in the background to build your application every time a PR is opened, closed, reopened, or synchronized (i.e. new commits). Uffizzi will post a comment to your pull request issue with a link to your Preview Environment. You can also login to the Uffizzi Dashboard to see a list of all your previews and your application logs.  

<details><summary><strong>Click to expand (Screenshots)</strong></summary>
<p>Open a pull request on GitHub:</p>
<img src="../../assets/images/create-pr.webp" width="600">
<hr>
<p>Uffizzi CI will post a comment to your pull request issue:</p>
<img src="../../assets/images/uffizzi-ci-comment.webp" width="600">
<hr>
<p>Log in to the Uffizzi Dashboard to see a list of Preview Environments and your application logs:</p>
<img src="../../assets/images/deploying-preview.webp" width="600">
</details>

### When are previews triggered?
!!! Important
    **Uffizzi CI design is changing.** Our team is working on updating the logic for Uffizzi CI triggers. In the next release of Uffizzi CI, **any pull request** that is opened on your repository between **any two branches** will trigger a preview. Uffizzi CI will use whichever Compose file is in the head branch (i.e. the merging branch).

Currently Uffizzi CI will only create previews for pull requests that target the branch you configure in the Uffizzi Dashboard (**Project** > **Settings** > **Compose file** > **Branch** > **Path to Compose**).  

<details><summary><strong>Click to expand (Screenshots)</strong></summary>
<p>Open a pull request on GitHub:</p>
<img src="../../assets/images/compose-target-branch.webp" width="600">
</details>

For example, if you configure Uffizzi CI with a Compose file from your <code>main</code> branch, Uffizzi will apply the following logic:

**Previews will be triggered for pull requests matching**: 

- `main` ← `{topic_branch}`

**Previews _will not_ be triggered for pull requests matching**:  

- `{topic_branch}` ← `main` or  
- `{topic_branch}` ← `{topic_branch}`

Note that this design is changing with the next release of Uffizzi CI.  

!!! Important
    If the Compose file in a base and head branches do not match for a given pull request, Uffizzi will use the Compose file in the head branch (i.e. the merging branch) as the preview configuration.  

    For example, if a pull request is opened for `develop` ← `my-feature` and the Compose files do not match, Uffizzi will use the Compose file from `my-feature`,

&nbsp;  
&nbsp;  
