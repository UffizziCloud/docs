# Uffizzi Overview

## What is Uffizzi?
Uffizzi is a platform that lets you preview pull requests before merging. It gives teams a simple way to catch bugs early and to test branches in clean, isolated and ephemeral environments that are not polluted by previous tests. Uffizzi supports APIs, frontends, backends, databases, microservices, binaries, and command-line tools.

## How it works

When added to your git repository or continuous integration (CI) pipeline, Uffizzi works in the background each time a pull request is opened, closed, or updated. Uffizzi will post a comment to your pull request issue with a secure _https_ link to your Preview Environment. This environment is continually refreshed when you push new commits, so anyone reviewing the preview will see the latest changes to the branch. Uffizzi also handles clean up, so your environments last only as long as you need them.

<img src="assets/images/pr-comment.webp" width="800">

## Configuration
To configure Uffizzi previews for your project, you'll need two things:  

1. **`docker-compose.uffizzi.yaml`**- A configuration file that describes your application or service. This file must be committed to your repository.  
2. **CI platform** - A service that builds each new commit, such as GitHub Actions, GitLab CI, or [Uffizzi CI](references/uffizzi-ci.md). 

!!! Note 
    **What is Uffizzi CI?** Uffizzi CI is an integrated build service provided by Uffizzi Cloud. Every time you push a new commit to your repository, Uffizzi CI receives a webhook and builds your application from source. Choose this solution if you don't already have a CI platform or don't want to use your existing solution to build preview images. [Learn more >](references/uffizzi-ci.md)

## Getting Started
Uffizzi is designed to work as a step in your CI pipeline, after images are built and pushed to a container registry. As noted above, you can use Uffizzi's integrated CI service ([Uffizzi CI](references/uffizzi-ci.md)) if you don't have an existing solution. 

Choose a guide below based on your CI provider of choice.  
&nbsp;  
[&nbsp; &nbsp; Quickstart for Uffizzi CI &nbsp; &nbsp;](quickstart-uffizzi-ci.md){ .md-button .md-button--primary }&nbsp; &nbsp;
[Quickstart for GitHub Actions](quickstart-gha.md){ .md-button }
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  

