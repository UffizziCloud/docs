# Uffizzi Overview

## What is Uffizzi?
Uffizzi is a platform that enables teams to easily create and destroy on-demand cloud environments for development, QA, staging, and more. These "ephemeral environments" give teams a flexible way to scale their test infrastructure, while avoiding the bottleneck of a traditional shared test environment. With Uffizzi ephemeral environments, developers can test pre-release branches in clean, isolated environments that are not polluted by previous tests. Uffizzi ephemeral environments can also be used by product and sales teams to preview new features for clients and other stakeholders.  

Other common names for ephemeral environments are _preview environments_, _on-demand environments_, _scratch environments_, _environments-as-a-service (EaaS)_, _pull request environments_, and _continuous previews_.

## How it works

When added to your git repository or continuous integration (CI) pipeline, Uffizzi works in the background each time a change is made to your code—for example, when a pull request (PR) or merge request (MR) is opened, closed, or updated. Additionally, you can create environments via the Uffizzi CLI from your local workstation, or by manually triggering a CI workflow.  

If initiated via PR, Uffizzi will post a comment to your PR issue with a secure _https_ link to your ephemeral environment. Or you can customize your workflows to send the URL to another service like Slack. In either case, your environment is continually refreshed when you push new commits, so anyone reviewing the environment will see the latest changes. Uffizzi also handles clean up, so your environments last only as long as you need them.

<img src="assets/images/pr-comment.webp" width="800">

## Quicklinks
| Topic  | Description |
|--------|---------------|
| [Quickstart](quickstart.md)  | How to install and get started with Uffizzi |
| [Detailed Setup Guide](set-up-guide-docker-compose-environment.md)  | Detailed integration guide that covers git and/or CI integration |
| [CLI Reference](references/cli.md)  | Command-line reference |
| [Troubleshooting](troubleshooting/most-common-problems.md)  | Most common problems and ways to solve them  |