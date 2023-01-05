# Uffizzi CI  
_If you use [GitHub Actions](https://github.com/features/actions) or another CI provider, you do not need to use Uffizzi CI._

## What is Uffizzi CI?
Uffizzi CI is an integrated build and deployment service provided by Uffizzi Cloud free of charge. Choose this solution if you don't already have a CI platform or don't want to use your existing solution to build preview images.

Every time you push a new commit to your repository, Uffizzi CI receives a webhook and builds your application from source. This ensures that the latest changes are always included in your previews. To use Uffizzi CI, your code must be stored in a GitHub repository.

## Setting up Uffizzi CI
To set up Uffizzi CI, login to the [Uffizzi Dashboard](https://app.uffizzi.com/sign_in), then navigate to **Project** > **Settings** > **General** and select **Configure** next to the GitHub option. You will be redirected to a GitHub login page to install and authorize the Uffizzi Cloud [GitHub App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps). If you have more than one GitHub account, be sure to install the GitHub App on the same account that you used to create your Uffizzi account. To install the Uffizzi Cloud GitHub App on an organizational account, you must have Owner permissions for your GitHub Organization.

Next, choose which repositories you wish to preview, then select **Install & Authorize**. Uffizzi requests only the minimum permissions it needs, which includes read access to your code and write access to pull request issues for posting comments. You can manage the GitHub App permissions from the **Developer Settings** page in GitHub.  

Once the Uffizzi Cloud GitHub App is installed and has access to your repository, follow the [Quickstart for Uffizzi CI](quickstart-uffizzi-ci.md) guide to complete the set up process.  

&nbsp;  
<img src="../../assets/images/authorize-uffizzi.webp" width="600">

## How to use Uffizzi CI  
Once everything is configured on both GitHub and Uffizzi, you don't need to do anything special to get Uffizzi CI working. Simply push commits and open pull requests as you normally do. Uffizzi CI will work in the background to build your application. Uffizzi will post a comment to your pull request issue with a link to your Preview Environment.

&nbsp;  
&nbsp;  
