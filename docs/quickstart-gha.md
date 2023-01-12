# Quickstart (GitHub Actions)

!!! Important
    This quickstart guide uses [GitHub Actions](https://github.com/features/actions) as a fast way to demonstrate Uffizzi capabilities, but Uffizzi will work with any CI platform. If you don't have a CI provider, you can use [Uffizzi CI](quickstart-uffizzi-ci.md), a free build service that integrates with your GitHub repository.

Get started using Uffizzi Preview Environments in 3 simple steps...

## 1. Fork the `quickstart` repository  

Fork the [quickstart](https://github.com/UffizziCloud/quickstart) repository on GitHub. Be sure to uncheck the option **Copy the `main` branch only**. This ensures that the `try-uffizzi` branch will be included in your fork.  

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191072997-94fdc9cc-2be2-4b44-900f-d4507c6df8a6.png" width="800">  
</details>

## 2. Enable GitHub Actions workflows for your fork

Select **Actions**, then select **I understand my workflows, go ahead and enable them**. GitHub Actions is free for public repositories.   

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191074124-8ace8e9f-4970-46e5-9418-0f18d30bd08c.png" width="800">  
</details>

## 3. Open a pull request for `try-uffizzi` branch against `main` in your fork  

Be sure that you're opening a PR on the branches of _your fork_ (i.e. `your-account/main` ← `your-account/try-uffizzi`). If you try to open a PR for `UffizziCloud/main` ← `your-account/try-uffizzi`, the Actions workflow will not run in this example.   

That's it! This will kick off a GitHub Actions workflow and post the Preview Environment URL as a comment to your PR issue. 

<img alt="uffizzi-bot" src="https://user-images.githubusercontent.com/7218230/191825295-50422b35-23ac-47f6-8a22-c67f95c89d8c.png" width="800">

## What to expect  

The PR will trigger a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-preview.yaml) that creates a Uffizzi Preview Environment for the [microservices application](https://github.com/UffizziCloud/quickstart#architecture-of-this-example-app) defined by the repo. The Preview Environment URL will be posted as a comment in your PR issue when the workflow completes, along with a link to the Uffizzi Dashboard where you can view application logs. The Preview Environment and comment is deleted when the PR is merged/closed or after 1 hour (configurable).  

!!! Tip
    Each Preview Environment is available at a predictable URL which consists of `https://app.uffizzi.com/` appended with the GitHub pull request domain. For example:  
    `https://app.uffizzi.com/github.com/{account}/{repo}/pull/{pull-request-number}`.  

    You can make requests to specific endpoints by appending a route to the end of the URL. For example:  
    `https://app.uffizzi.com/github.com/boxyhq/jackson/pull/661/api/health`  

## How it works  

#### Configuration

Previews are configured with a [Docker Compose template](https://github.com/UffizziCloud/quickstart/blob/main/docker-compose.uffizzi.yml) that describes the application configuration and a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-preview.yaml) that includes a series of jobs triggered by a `pull_request` event and subsequent `push` events:  

1. [Build and push images to a container registry](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L14-L116)  
2. [Render a Docker Compose file](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L118-L156) from the Docker Compose template and the built images  
3. [Deploy the application (per the Docker Compose file) to a Uffizzi Preview Environment](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L158-L171) and post a comment to the PR issue  
4. [Delete the Preview Environment](https://github.com/UffizziCloud/quickstart/blob/5699f461f752b0bd787d69abc2cfad3b79e0308b/.github/workflows/uffizzi-preview.yaml#L173-L184) when the PR is merged/closed or after `1h`      

#### Uffizzi Cloud

Running this workflow will create a [Uffizzi Cloud](https://uffizzi.com) account and project from your GitHub user and repo information, respectively. If you sign in to the [Uffizzi Dashboard](https://app.uffizzi.com/sign_in) you can view logs, password protect your Preview Environments, manage projects and team members, set role-based access controls, and configure single-sign on (SSO).

Each account receives 10,000 preview minutes per month for free. If you exceed this amount, your Preview Environments will be paused unless you add a credit card. See [our pricing](https://uffizzi.com/pricing) for details. Alternatively, you can [install open-source Uffizzi](https://github.com/UffizziCloud/uffizzi_app/blob/develop/INSTALL.md) if you have your own Kubernetes cluster.

## Set up Uffizzi for your application

Now that you know how Uffizzi works, [set up Uffizzi for your application or service ➡️](set-up-uffizzi-for-your-application.md).

