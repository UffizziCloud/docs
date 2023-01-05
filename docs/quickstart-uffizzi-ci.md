# Quickstart (Uffizzi CI)

## What is Uffizzi CI?
Uffizzi CI is an integrated build service provided by Uffizzi Cloud. Every time you push a new commit to your repository, Uffizzi CI receives a webhook and builds your application from source. Choose this solution if you don't already have a CI platform or don't want to use your existing solution to build preview images. [Learn more >](references/uffizzi-ci.md)  


## **1. Fork the `quickstart-uffizzi-ci` repository**  
Fork the [`quickstart-uffizzi-ci`](https://github.com/UffizziCloud/quickstart-uffizzi-ci) repository on GitHub. Be sure to uncheck the option **Copy the `main` branch only**. This ensures that the `try-uffizzi` branch will be included in your fork.  

<details><summary>Click to expand</summary>
<img src="https://user-images.githubusercontent.com/7218230/191072997-94fdc9cc-2be2-4b44-900f-d4507c6df8a6.png" width="800">  
</details>

### What's in this repository?
This repository includes a sample voting application that consists of five microservies. Also included in the repository is a Docker Compose template ([`docker-compose.uffizzi.yml`](https://github.com/UffizziCloud/quickstart-uffizzi-ci/blob/main/docker-compose.uffizzi.yml)) that describes the application stack and includes information required by Uffizzi.

At a minimum, this file must include the following object definitions:

1. **[`services`](references/compose-spec.md#services)** - The container service(s) that make up your application. See [Docker Compose for Uffizzi](references/compose-spec.md) for supported keywords.
2. **[`x-uffizzi`](references/compose-spec.md#x-uffizzi-extension-configuration-reference)** - This is a custom extension field required by Uffizzi.

    a. [`ingress`](references/compose-spec.md#ingress-required) - Tells Uffizzi which of your `services` should receive incoming _https_ traffic
    b. [`continuous_previews`](references/compose-spec.md#continuous_previews) - Required by Uffizzi CI. Set the following values to `true`:

    - `deploy_preview_when_pull_request_is_opened: true`
    - `delete_preview_when_pull_request_is_closed: true`
    - `share_to_github: true` - Toggles commenting on GitHub pull request issues

Your Docker Compose template must be committed to the branch that you merge _into_, i.e. your target base branch (typically this is your default branch). It is recommended to commit your compose file to the root directory, although this is not required. Note that all paths specified in your `docker-compose.uffizzi.yml` file should be relative to this file location. 

!!! Note  
    See the [Docker Compose for Uffizzi reference guide](references/compose-spec.md) for a comprehensive list of supported keywords. 

## **2. Create a project at uffizzi.com**  

If you haven't already done so, [create a Uffizzi Cloud account](https://app.uffizzi.com/sign_up). Once logged in, follow these steps to create project:  

1. Select **New project**  > **Uffizzi CI** > **Configure GitHub**  
2. Install Uffizzi Cloud on your GitHub account  
3. Install & Authorize the Uffizzi GitHub App your repository  
4. Select **Set up project** for your desired repository  
5. Add your `docker-compose.uffizzi.yml` file in **Project** > **Settings** > **Compose**. Be sure to choose the branch that you merge <i>into</i>, i.e. your target base branch.  
6. Save and validate your compose; resolve any errors  
7. Check your configuration with a test deployment  

<details><summary><strong>Click to expand (Screenshots)</strong></summary>
<p>1. Select New project  > Uffizzi CI > Configure GitHub</p>
<img src="../assets/images/new-uffizzi-ci-project.webp" width="600">
<p>2. Install Uffizzi Cloud on your GitHub account</p>
<img src="../assets/images/install-github-app.webp" width="600">
<p>3. Install & Authorize the Uffizzi GitHub App your repository</p>
<img src="../assets/images/authorize-uffizzi.webp" width="600">
<p>4. Select Set up project for the repository you just forked</p>
<img src="../assets/images/set-up-project.webp" width="600">
<p>5. Add your `docker-compose.uffizzi.yml` file in Project > Settings > Compose. Be sure to choose the branch that you merge <i>into</i>, i.e. your target base branch.</p>
<img src="../assets/images/add-compose-in-settings.webp" width="600">
<p>6. Save and validate your compose; resolve any errors  </p>
<img src="../assets/images/resolve-compose-errors.webp" width="600">
<p>7. Check your configuration with a test deployment </p>
<img src="../assets/images/compose-added.webp" width="600">
</details>  

## **3. Open a pull request for `try-uffizzi` branch against `main` in your fork** 

Be sure that you're opening a PR on the branches of _your fork_ (i.e. `your-account/main` ← `your-account/try-uffizzi`). If you try to open a PR for `UffizziCloud/main` ← `your-account/try-uffizzi`, a preview will not run in this example.   

That's it! This will kick off Uffizzi CI and post the Preview Environment URL as a comment to your PR issue. 
