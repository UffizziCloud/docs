# Quickstart (GitLab CI)

!!! Important
    This quickstart guide uses [GitLab CI](https://www.google.com/search?client=safari&rls=en&q=gitlab+ci&ie=UTF-8&oe=UTF-8) as a fast way to demonstrate Uffizzi capabilities, but Uffizzi will work with any CI platform. If you don't have a CI provider, you can use [Uffizzi CI](quickstart-uffizzi-ci.md), a free build service that integrates with your GitHub repository.

Go from merge request to Uffizzi ephemeral environment in less than one minute...

### 1. Fork the `quickstart` repo

Fork the [`quickstart`](https://gitlab.com/uffizzi/quickstart) repository on GitLab. From the project home page, select **Fork**, then choose a namespace and project slug. Select **Fork project**.

<details><summary>Click to expand</summary>
<img src="../assets/images/quickstart-gitlab-fork-1.png" width="800">
<hr>
<img src="../assets/images/quickstart-gitlab-fork-2.png" width="800">  
</details>

### 2. Ensure GitLab CI/CD is enabled for your project

If you don't see the **Build > Pipelines** option in left sidebar, following [these steps](https://docs.gitlab.com/ee/ci/enable_or_disable_ci.html#enable-cicd-in-a-project) to enable it.

<details><summary>Click to expand</summary>
<img src="../assets/images/quickstart-gitlab-build-pipelines.png" width="800">
</details>

### 3. Open a merge request (MR) for `try-uffizzi` branch against `master` in your fork

:warning: Be sure that you’re opening the MR on the branches of _your fork_ (i.e. `your-account/master` ← `your-account/try-uffizzi`).

If you try to open a MR for `uffizzi/quickstart/~/tree/master` ← `your-account/~/tree/try-uffizzi`, the pipeline will not run in this example.

<details><summary>Click to expand</summary>
<img src="../assets/images/quickstart-gitlab-create-mr.png" width="800">
</details>

That’s it! This will kick off a GitLab pipeline and the ephemeral environment URL will be dumped to `stdout` of the pipeline job. 



## What to expect

The MR will trigger a pipeline defined in [`.gitlab-ci.yml`](https://gitlab.com/uffizzi/quickstart/-/blob/master/.gitlab-ci.yml) that creates a Uffizzi ephemeral environment for the [microservices application](#architecture-of-this-example-app) defined by the `quickstart` repo. The ephemeral environment URL will be echoed to `stdout` of the `deploy_environment` Job. Look for the following line in the job logs:

```
$ echo "Uffizzi Environment deployment details at URI:${UFFIZZI_CONTAINERS_URI}"
Uffizzi Environment deployment details at URI:https://app.uffizzi.com//projects/8526/deployments/27720/containers
```

This link will take you to the Uffizzi Dashboard where you can view application logs and manage your environments and team. The environment will be deleted when the MR is merged/closed or after 1 hour ([configurable](https://gitlab.com/uffizzi/quickstart/-/blob/master/docker-compose.uffizzi.yml#L7)).

You might also want configure a new job to [post the URL as a comment](https://engineering.dunelm.com/how-to-post-a-custom-message-to-your-merge-request-using-gitlabci-3551824a1e5b) to your MR issue or send a notification to Slack or Microsoft Teams, etc. See our Slack notification example [here](https://gitlab.com/uffizzi/environment-action/-/blob/main/Notifications/slack.yml).

## How it works

### Configuration

Ephemeral environments are configured with a [Docker Compose template](https://gitlab.com/uffizzi/quickstart/-/blob/master/docker-compose.uffizzi.yml) that describes the application components and a [GitLab CI pipeline](https://gitlab.com/uffizzi/quickstart/-/blob/master/.gitlab-ci.yml) that includes a series of jobs triggered by a `merge_request_event`:

1. [Build and push images to a container registry](https://gitlab.com/uffizzi/quickstart/-/blob/master/.gitlab-ci.yml#L14)
2. [Render a Docker Compose file from the Docker Compose template and the built images](https://gitlab.com/uffizzi/quickstart/-/blob/master/.gitlab-ci.yml#L56-76)
3. [Deploy the application to a Uffizzi ephemeral environment and echo the environment URL to the Job logs](https://gitlab.com/uffizzi/environment-action/-/blob/main/environment.gitlab-ci.yml#L30-76)
4. [Delete the environment](https://gitlab.com/uffizzi/environment-action/-/blob/main/environment.gitlab-ci.yml#L98-115)

!!! Tip
    Each ephemeral environment is available at a predictable URL which consists of `https://app.uffizzi.com/` appended with the GitLab merge request domain. For example:  
    `https://app.uffizzi.com/gitlab.com/{account}/{repo}/merge_requests/{merge-request-number}`.  

    You can make requests to specific endpoints by appending a route to the end of the URL. For example:  
    `https://app.uffizzi.com/gitlab.com/acme/example-app/pull/661/api/health`  

#### Uffizzi Cloud

Running this workflow will create a [Uffizzi Cloud](https://uffizzi.com) account and project from your GitLab user and repo information, respectively. If you sign in to the [Uffizzi Dashboard](https://app.uffizzi.com/sign_in) you can view logs, password protect your environments, manage projects and team members, set role-based access controls, and configure single-sign on (SSO).

Our Starter Plan is free for up to two concurrent ephemeral environments. The Pro Plan gives your team access to unlimited environments. If you'd like to self-host Uffizzi on your own Kubernetes cluster, check out our Enterprise Plan. See [our pricing](https://uffizzi.com/pricing) for all plan details. 

## Set up Uffizzi for your application

Now that you know how Uffizzi works, [set up Uffizzi for your application or service ➡️](set-up-guide-docker-compose-environment.md).

