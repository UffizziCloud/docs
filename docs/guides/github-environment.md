# Create a GitHub Environment for your previews 
[GitHub Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) are a convenient way to collect all of your previews in a single view on GitHub. Specifically, GitHub Environments are the target of your workflows, so you can configure a "uffizzi" Environment to be the target of your ephemeral preview deployments. You'll also see these deployments appear in your Actions workflow graph.

<img src="../../assets/images/github-environments.webp" width="600">
<hr>
<img src="../../assets/images/github-environments-2.webp" width="600">
<hr>
<img src="../../assets/images/github-environments-5.webp" width="600">

## Set up a "uffizzi" GitHub Environment
If you're using the standard [Uffizzi reusable workflow](https://github.com/marketplace/actions/preview-environments) to create, update, and delete environments on pull request events, then you just need to create a GitHub Environment called "uffizzi" in your reposiory via the GitHub UI. The reusable workflow is pre-configured to populate this Environment with Uffizzi preview deployments. If you're not using the resuable workflow, you'll need to configue the `jobs.<job-id>.environment` key as described [here](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#using-an-environment).

Login to GitHub, then navigate to your repository **Settings** > **Environments** and select **New environment**. For the Environmnet name enter "**uffizzi**". Note that if you name it something else, it won't work since the reusable workflow expects the enviroment to be named "uffizzi".

That's it! You can now select the "uffizzi" Environment to see the new Deployments that are created every time your Uffizzi workflow runs.

<img src="../../assets/images/github-environments-3.webp" width="600">
<hr>
<img src="../../assets/images/github-environments-4.webp" width="600">
