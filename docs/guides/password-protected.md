# Configure password-protected environments

Uffizzi allows you to configure a username and password for your test environments to limit who has access to them. This feature is enabled per project, so anyone navigating to the URL of any environment of that project, either via a web browser or with a command like `curl`, must enter valid credentials to gain access. To configure this feature, you must be an account Admin:

1. Navigate to your project, then select **Project Settings** > **Password protection** > **EDIT** > **Password protection** (toggle).  
2. Enter a username and password, then select **SAVE**.

Password protection will now be enabled for all environments belonging to this project, including any pre-existing environments.  

___

![Enable password protection](../../assets/images/enable-password-protection.png)

___  

!!! Warning
    If you enable password protection and are using the GitHub Actions [reusable workflow](https://github.com/UffizziCloud/preview-action/blob/6504e1578015e5470858bfe7e7793779fa01b6a4/.github/workflows/reusable.yaml), as described in the [Getting started guide](getting-started.md), you must pass `URL_USERNAME` and `URL_PASSWORD` as parameters to the reusable workflow, otherwise the deployment confirmation step will fail. You can find an example GitHub Actions job [here](https://github.com/UffizziCloud/example-voting-app/blob/161d76c159607455b7c3cda74fcb2515502b2920/.github/workflows/uffizzi-previews.yml#L161-L176).

## Suggested articles
* [Set up single sign-on (SSO)](guides/single-sign-on.md)
* [Configure role-based access (RBAC)](guides/rbac.md)
* [Check the logs](guides/logs.md)
