# Uffizzi Overview

## What is Uffizzi?
Uffizzi is a platform that enables teams to easily create and destroy on-demand cloud environments for development, QA, staging, and more. These "ephemeral environments" give teams a flexible way to scale their test infrastructure, while avoiding the bottleneck of a traditional shared test environment. With Uffizzi ephemeral environments, developers can test pre-release branches in clean, isolated environments that are not polluted by previous tests. Uffizzi ephemeral environments can also be used by product and sales teams to preview new features for clients and other stakeholders.  

## How it works

When added to your git repository or continuous integration (CI) pipeline, Uffizzi works in the background each time a change is made to your code—for example, when a pull request (PR) or merge request (MR) is opened, closed, or updated. Additionally, you can create environments via the Uffizzi CLI from your local workstation, or by manually triggering a CI workflow.  

If initiated via PR, Uffizzi will post a comment to your PR issue with a secure _https_ link to your ephemeral environment. Or you can customize your workflows to send the URL to another service like Slack. In either case, your environment is continually refreshed when you push new commits, so anyone reviewing the environment will see the latest changes. Uffizzi also handles clean up, so your environments last only as long as you need them.

<img src="assets/images/pr-comment.webp" width="800">

## Configuration
To configure Uffizzi environments for your project, you'll need two things:  

1. **A configuration file** that describes your application or service. Depending on the type of environment you want to create, this will be a Kubernetes manifest YAML or [`docker-compose.uffizzi.yaml`](references/compose-spec.md).  
2. **CI platform (optional, but recommended)** - A service that builds each new commit, such as GitHub Actions, GitLab CI, or [Uffizzi CI](references/uffizzi-ci.md). 

!!! Note 
    **What is Uffizzi CI?** Uffizzi CI is an integrated build service provided by Uffizzi Cloud. Every time you push a new commit to your repository, Uffizzi CI receives a webhook and builds your application from source. Choose this solution if you don't already have a CI platform or don't want to use your existing solution to build preview images. [Learn more >](references/uffizzi-ci.md)

## **Quicklinks**
| Topic  | Description   |
|--------|---------------|
| [Quickstart](quickstart.md)  | How to install and get started with Uffizzi |
| [Set up Uffizzi for your application](set-up-uffizzi-for-your-application.md)  | Detailed integration guide that covers git and/or CI integration |
| [CLI Reference](references/cli.md)  | Command-line reference |
| [Troubleshooting](troubleshooting/most-common-problems.md)  | Most common problems and ways to solve them  |

&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  

