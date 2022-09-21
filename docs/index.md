# Getting Started

## Introduction

Uffizzi is a platform that lets you preview pull requests before merging. Create on-demand Preview Environments for APIs, frontends, backends, databases, and microservices. Each Preview Environment gets a secure HTTPS URL that is continually refreshed when you push new commits. Uffizzi also handles clean up, so your environments last only as long as you need them.  

You can also use Uffizzi to create demo environments, debugging environments, release candidate environments, or to replace your team's shared QA or Staging environment.

## **Quickstart (~ 1 minute )**

Get started using Uffizzi Preview Environments in 3 simple steps...

### 1. Fork the `quickstart` repo  

Fork the [quickstart](https://github.com/UffizziCloud/quickstart) repo on GitHub. Be sure to uncheck the option **Copy the `main` branch only**. This ensures that the `try-uffizzi` branch will be included in your fork.  

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191072997-94fdc9cc-2be2-4b44-900f-d4507c6df8a6.png" width="800">  
</details>

### 2. Enable GitHub Actions workflows for your fork

Select **Actions**, then select **I understand my workflows, go ahead and enable them**. GitHub Actions is free for public repositories.   

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191074124-8ace8e9f-4970-46e5-9418-0f18d30bd08c.png" width="800">  
</details>

### 3. Open a pull request for `try-uffizzi` branch against `main` in your fork  

That's it! This will kick off a GitHub Actions workflow and post the Preview Environment URL as a comment to your PR issue.  

<details><summary>Click to expand</summary>
<img alt="gha" src="https://user-images.githubusercontent.com/7218230/191423820-f0a19489-4fc2-41ee-96aa-00a75554a563.png" width="800">  
</details>

## What to expect  

The PR will trigger a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-environment.yml) that creates a Uffizzi Preview Environment for the [microservices application](#architecture-of-this-example-app) defined by this repo. The Preview Environment URL will be posted as a comment in your PR issue when the workflow completes, along with a link to the Uffizzi Dashboard where you can view application logs. The Preview Environment and comment is deleted after 1 hour or when the PR is merged/closed.  

[Screenshot of uffizzi-bot comment]

## How it works  

#### Configuration

Previews are configured with a [Docker Compose template](https://github.com/UffizziCloud/quickstart/blob/main/docker-compose.template.yml) that describes the application configuration and a [GitHub Actions workflow](https://github.com/UffizziCloud/quickstart/blob/main/.github/workflows/uffizzi-environment.yml) that includes a series of jobs triggered by a `pull_request` event and subsequent `push` events:  

1. [Build and push images to a container registry](https://github.com/UffizziCloud/quickstart/blob/a6d9ec7816da58c4d8c5b2ea47ad9cf3cfa0585f/.github/workflows/uffizzi-previews.yml#L14-L124)  
2. [Render a Docker Compose file](https://github.com/UffizziCloud/quickstart/blob/a6d9ec7816da58c4d8c5b2ea47ad9cf3cfa0585f/.github/workflows/uffizzi-previews.yml#L126-L164) from the Docker Compose template and the built images  
3. [Deploy the application (per the Docker Compose file) to a Uffizzi Preview Environment](https://github.com/UffizziCloud/quickstart/blob/a6d9ec7816da58c4d8c5b2ea47ad9cf3cfa0585f/.github/workflows/uffizzi-previews.yml#L166-L185) and post a comment to the PR issue  
4. [Delete the Preview Environment](https://github.com/UffizziCloud/quickstart/blob/a6d9ec7816da58c4d8c5b2ea47ad9cf3cfa0585f/.github/workflows/uffizzi-previews.yml#L187-L200) when the PR is merged/closed or after `1h`      

#### Uffizzi Cloud

Running this workflow will create a [Uffizzi Cloud](https://uffizzi.com) account and project from your GitHub user and repo information. If you sign in to the Uffizzi Dashboard you can view logs, password protect your Preview Environments, manage projects and team members, set role-based access controls, and configure single-sign on (SSO).

Each account receives 10,000 preview minutes per month for free. If you exceed this amount, your Preview Environments will be paused unless you add a credit card. See [our pricing](https://uffizzi.com/pricing) for details.

## Add Uffizzi for your own application

Now that you know how Uffizzi works, [add Uffizzi for your own application or service ➡️](add-uffizzi-for-your-own-application.md).

