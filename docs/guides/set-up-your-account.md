# Set up your account

## From GitHub  Actions
When you run a GitHub Actions workflow that calls the Uffizzi [preview action](https://github.com/marketplace/actions/preview-environments), a Uffizzi account will be automatically created from your GitHub username. This happens because Uffizzi receives a signed [OIDC token](oidc.md) from GitHub that verifies your identity. There is no need to create a Uffizzi account before running the workflow. Afterwards when you sign in to _uffizzi.com_, you will see that your account already exists.

!!! Important  
    When a preview workflow is first merged into your [default branch](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/changing-the-default-branch), the workflow run will fail. This is expected behavior since the preview workflow must be _initiated from the default branch_ of the base repository. That is, this workflow must first be merged into the default branch for subsequent workflow runs to succeed.

## From uffizzi.com  
You can alternatively go to [uffizzi.com](https://uffizzi.com) and use the **Sign up with GitHub** button to create an account with your GitHub login. When you do this, you will be redirected to the GitHub OAuth page, which includes a warning that Uffizzi may "Act on your behalf". Note  that this is part of the standard permissions for GitHub OAuth. The warning is misleading because Uffizzi is only requesting read-only access to your email address and username at this step to set up your account. 

After selecting **Authorize Uffizzi Cloud**, you are asked to **Install & Authorize** the Uffizzi GitHub App, where you can see which permissions Uffizzi is requesting. Uffizzi requests only the minimum permissions it needs. The only way Uffizzi acts on your behalf is by commenting on PRs.

<img src="../../assets/images/authorize-uffizzi-cloud.png" width="400">  
<img src="../../assets/images/install-and-authorize-uffizzi-cloud.png" width="400">  

