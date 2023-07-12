# **Debugging Uffizzi ephemeral environments**

By [Shruti Chaturvedi](https://github.com/ShrutiC-git)  

Learn how to debug failures in your Uffizzi ephemeral environments.

## **Introduction**

Before you start fixing an issue, you first need to know that something is failing and then identify where the failure is coming from. We published an article on [the most common reasons your ephemeral environments are faililing](most-common-problems.md). These errors can broadly be divided into three categories:  

- Errors with the `docker-compose.uffizzi.yml` (incorrect path to host-volume, missing ingress, etc).
- Errors encountered while building the container (incorrect path to the Dockerfile, incorrect context, etc).
- Errors encountered while running the application containers (OOM error, incorrect host-volume path, init-container exited causing the environment to become unserviceable, etc).  

In this article, we will take a look at where you can find and identify errors with your Uffizzi ephemeral environments. 

## **Debugging environments built from Uffizzi CI**  

If you’re using Uffizzi CI to build and provision ephemeral environments, you’ll be able to access all the build logs and the container logs through the Uffizzi CI dashboard. Once you open a pull request in your project (make sure the target branch of the PR is also the branch that contains the docker-compose.uffizzi.yml you have added as the default configuration for your ephemeral environments), Uffizzi CI gets triggered to start building your application image from source, push it to a container registry, and spin the environment from this image. You can encounter errors due to misconfigurations in the docker-compose.uffizzi.yml. Alternatively, your application can throw an error while the application image is being built or while the application is running. 

### Misconfigured `docker-compose.uffizzi.yml`
As you connect your compose file to Uffizzi CI on the Uffizzi dashboard, it will be validated to make sure that the docker-compose is not misconfigured to run Uffizzi integration. If there are issues with validating your compose, a popup will appear on the same screen guiding you on what is wrong. If there is a missing directive (like ingress), or an incorrect path to your host volume, `docker-compose.uffizzi.yml` validation will throw an Invalid compose error.   

For example, if you do not specify an ingress in your `docker-compose.uffizzi.yml`, which is needed by Uffizzi to define an entrypoint into your environment, you’ll see the following on this screen:

<img src="../../assets/images/invalid-compose-erorr.webp" width="600">

Please note that this step does not validate issues with application-level misconfigurations, for example, insufficient memory allocated to the container or an incorrect environment variable. 

Once you’ve added a valid compose file, you’ll be able to test it by clicking the Test Compose button on the Settings page to make sure that there are no application-level issues in the compose file.

### Build Errors
If, for example, your Uffizzi is unable to locate your application Dockerfile given in the `docker-compose.uffizzi.yml`, Uffizzi will fail to build the application image. If there are other issues in your Dockerfile, for example, issues with conflicting dependencies, in this case too, building the image will fail, and hence, Uffizzi will fail to create/modify an ephemeral environment. In either case, you would want to check the build logs. 

To identify issues with building your application image, head over to the Uffzzi dashboard and select the project you’re debugging (you might have one or multiple projects listed on the dashboard). You will then see all currently active ephemeral environments for this project. If you are debugging a particular ephemeral environment for a specific PR, you can select that environment. Typically, the timestamp of when the environment was updated along with the Preview URL, which looks something like `_https://pr-10-deployment-1234-your-application.app.uffizzi.com_`, will help you identify if that environment corresponds to your PR.

Once you select the environment you are debugging, you will see a list of all the containers in that project. If a container has failed (either while the image-building process or while running the container), you will see it marked failed on the Uffizzi UI. 

Selecting a container will take you to the container logs (these will be logs from the application container itself). We will look at checking the container logs in the next step. 

The vertical navbar on the left side lists a tab called Build Logs. Click this tab and you will then be able to look at the build logs for that particular container. The build logs will log the steps taken to build the application image from the Dockerfile you have specified in your `docker-compose.uffizzi.yml`. You could either look through the build logs to go through each step. Alternatively, you can also filter build logs for generic or application-specific keywords. 

<img src="../../assets/images/build-logs-menu.jpg" width="200">

For example, in the case where you have passed an incorrect path to Dockerfile in your docker-compose.uffizzi.yml, you’ll see something like this in your build logs:

```
Step #2: unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /workspace/build/ci/Dockerfile: no such file or directory
Finished Step #2
ERROR
ERROR: build step 2 "******/cloud-builders/docker" failed: step exited with non-zero status: 1
```

Checking the build logs is a very helpful step in identifying issues with building your application container image. You can also view the logs post environment creation (in case the build passes successfully) for debugging purposes—if the environment is refreshed, the build step is retriggered, and hence the logs also change to correspond to the new build. It is important to note that the build logs will only be available for the container's you are building from the source. If a container pulls an image from a container registry, there will be no build logs for such a container. 

### Application Errors  

Your application could have failed due to an error thrown by one or more of your containers. When you come onto the Uffizzi dashboard, select your, and select the ephemeral environment you’re testing, all the containers defined in your ephemeral environments will be listed. 

Selecting a container will list the execution logs for this container. Generic errors like [`OOM kill`](most-common-problems.md#1-container-killed-due-to-insufficient-memory-oom-kill) will mark the container as failed. You can visit the Troubleshooting guide on how to fix common errors with your Uffizzi ephemeral environments. In other cases, if your container failed and exited due to an application-specific error, you can check the container logs to figure out the root cause of the issue. Sometimes, the ephemeral environment might not work as it is supposed to despite all the containers passing successfully. For example, if the backend fails to connect to the database, the backend container might not be marked as failed, but the environment will not work as expected. In this case, I would benefit from checking container logs from both the backend container and my database container to figure out why the backend is unable to connect to the database.

See below what the container logs on Uffizzi UI look like:

<img src="../../assets/images/container-logs.webp" width="800">

If your container restarted or keeps restarting, you’ll also be able to look into the logs of the previous container and check why the container had to restart. 

## **Debugging environments built using GitHub Actions (or other external CI)**
If you have Uffizzi integrated into external CI, like GitHub Actions or GitLab CI, the external CI handles building and pushing the image, and thereafter, pulling it to create a new ephemeral environment. The external CI will also handle modifying and/or deleting the environment depending on the status of the PR. Therefore, you’ll need to check logs from your external CI to make sure the application image builds and is pushed to the registry successfully; your compose file is valid; the environment gets successfully created, updated, and/or deleted. For checking application/container logs, you will have to check these on Uffizzi UI. 

Usually, if the environment is not up while you are expecting it to be, this typically would suggest an issue either with the build failing or an invalid compose file. Either way, in case you are using an external CI, it is always a good idea to check logs from your external CI, and then head over to Uffizzi UI for further debugging. Check the section above on where to find application-level logs. 

### Debugging Errors on GitHub Actions  

We’re looking at an example of debugging your Uffizzi ephemeral environments built through GitHub Actions. Once you open a PR after adding the GitHub Action workflow file in your default branch, a new GitHub Action to build and deploy your Uffizzi ephemeral environment will be triggered. Head over to the Actions tab in the repository, and you’ll see a new run triggered for your action. Similar to the Uffizzi CI, the branch name and the timestamp will give you an idea of the action corresponding to your change. 

After selecting a particular run, you’ll then see the status of each of the steps for this action.  

<img src="../../assets/images/gha-jobs.jpg" width="800">

In the above image, we can see that all except one build job have passed. Clicking on the job that failed, I’ll be able to check all the steps of the job, and identify which step failed and for   what reason. Once you update your PR with a fix for the error, a new run of the action will be triggered, and if passed successfully, all the steps will be marked green. You can then visit your ephemeral environment through the URL posted as a comment on your PR. In case the environment does not work as expected or throws an unexpected error, check the container logs on Uffizzi dashboard.  

## **Next Steps**

Once you find the root cause behind a failing ephemeral environment, the next step is fixing them. We identified the top places where misconfigurations occur and wrote a [troubleshooting guide](most-common-problems.md) to help projects easily get set up with Uffizzi. If you’d like to get more help, [reach out to us](https://www.uffizzi.com/contact) and let us know how we can help!




