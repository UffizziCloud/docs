# Set up your account

## From GitHub  Actions
When you run a GitHub Actions workflow that calls the Uffizzi [preview action](https://github.com/marketplace/actions/preview-environments), a Uffizzi account will be automatically created from your GitHub username. This happens because Uffizzi receives a signed [OIDC token](oidc.md) from GitHub that verifies your identity. There is no need to create a Uffizzi account before running the workflow. Afterwards when you sign in to _uffizzi.com_, you will see that your account already exists.

!!! Important  
    When a preview workflow is first merged into your [default branch](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/changing-the-default-branch), the workflow run will fail. This is expected behavior since the preview workflow must be _initiated from the default branch_ of the base repository. That is, this workflow must first be merged into the default branch for subsequent workflow runs to succeed.

## From uffizzi.com  
You can alternatively create an account by signing up at [uffizzi.com](https://uffizzi.com). From there, you can manage your account and project settings, including adding team members.
