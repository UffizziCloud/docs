# Overview

Previewing code before it’s merged shouldn’t be limited to frontends. Define your full-stack apps with a familiar syntax based on Docker Compose and Uffizzi will create on-demand test environments when you open pull requests or build new images. Preview URLs are updated when there’s a new commit, so your team can catch issues early, iterate quickly, and accelerate your release cycles.

Uffizzi provides an off-the-shelf Continuous Previews capability that can support your entire application eco-system and is highly configurable.  You can define your Previews by extending `docker-compose.yml` or by using a GUI-based template - in either case you have the ability to define trigger-based previews based on either pull requests or via image tag updates.

When a developer is ready for their feature branch to be previewed they `git push` to remote then open a `pull request` for their feature branch which then triggers a preview of the stack as defined in `docker-compose-uffizzi.yml`.  Users have the option for Uffizzi to build from source and deploy or to deploy directly from one of several integrated image registries (Docker Hub, ACR, ECR, GCR).  

Uffizzi also offers a Bring Your Own Build (BYOB) option that enables users to leverage their own build process to trigger previews.  In this scenario images tagged `uffizzi_request_<#>` will initiate new previews.  In addition to being compatible with custom build processes this allows for users on Gitlab and Bitbucket to benefit from Uffizzi prior to releasing those integrations.

## Configuration Options and Features 

Uffizzi has a cloud-hosted offering and a self-hosted offering with separate CLI and GUI interfaces.  The GUI is the only component of Uffizzi that is not open source.

During our beta phase (~Dec2021-Feb2022) we will be releasing more source code and documentation to install and run Uffizzi in the self-host configuration.

The below table shows a list of features by configuration (dated 12/8/21):

|                                    | **Open Source/Self-hosted**   | **Cloud-hosted** | **Paid/Self-hosted**           |
|-----------------------------------------|-------------------------------|--------------------------|----------------------------------|
| **INTERFACE:**                              |                               |                          |                                  |
| CLI                                     | Y                             | Y                        | Y                                |
| GUI                                     | N                             | Y                        | Y                                |
| **REPO/REGISTRY INTEGRATION:**              |                               |                          |                                  |
| Github                                  | Y                             | Y                        | Y                                |
| GitLab                                  | N, planned                    | N, planned               | N, planned                       |
| Bitbucket                               | N, planned                    | N, planned               | N, planned                       |
| Docker Hub                              | Y                             | Y                        | Y                                |
| ACR                                     | Y                             | Y                        | Y                                |
| GCR                                     | Y                             | Y                        | Y                                |
| ECR                                     | Y                             | Y                        | Y                                |
| Generic Self-hosted Repo                | N, planned                    | N, planned               | N, planned                       |
| Generic Self-hosted Registry            | N, planned                    | N, planned               | N, planned                       |
| **BUILDS:**                                 |                               |                          |                                  |
| Uffizzi-managed Build Option            | N, N/A                      | Y                        | Custom                           |
| Custom Build Option                     | Y                             | Y                        | Y                                |
| **PREVIEWS:**                               |                               |                          |                                  |
| Preview                                 | Y                             | Y                        | Y                                |
| Continuous Previews                     | Y                             | Y                        | Y                                |
| COLLABORATION INTEGRATION:              |                               |                          |                                  |
| Jira                                    | N, planned                    | N, planned               | N, planned                       |
| Slack                                   | N, planned                    | N, planned               | N, planned                       |
| Microsoft Teams                         | N, planned                    | N, planned               | N, planned                       |
| Asana                                   | N, planned                    | N, planned               | N, planned                       |
| Trello                                  | N, planned                    | N, planned               | N, planned                       |
| **TEAM COLLABORATION:**                     |                               |                          |                                  |
| Mutliple Projects                       | N, planned                    | Y                        | Y                                |
| RBAC                                    | N, planned                    | Y                        | Y                                |
| SSO / Directory Sync                    | N, planned                    | Y                        | Y                                |
| LOGGING:                                |                               |                          |                                  |
| Container Logs                          | N, planned                    | Y                        | Y                                |
| Build Logs                              | N, planned                    | Y                        | Y                                |
| Event Logging                           | N, planned                    | N, planned               | N, planned                       |
| Uffizzi Event / Audit Logging           | N, planned                    | N, planned               | N, planned                       |
| **SECURITY:**                               |                               |                          |                                  |
| Secrets Management                      | N, planned                    | Y                        | Y                                |
| Password Protected Previews             | N, not planned                | N, planned               | N, planned                       |
| **INSTALL / SET-UP:**                       |                               |                          |                                  |
| Uffizzi Compose                         | Y                             | Y                        | Y                                |
| Uffizzi Templates                       | N, N/A                        | Y                        | Y                                |
| Requires CLI download                   | Y                             | Y                        | Y                                |
| Requires Coordination with Uffizzi Reps | N / Never                     | No                       | Y, pending upgrade to onboarding |
| Requires own K8s cluster                | Y                             | No                       | Y                                |
| Requires self-host GUI                  | No Option                     | No                       | Y                                |
| Requires self-host Postgres Db          | Y                             | No                       | Y                                |
| Requires self-host Uffizzi App          | Y                             | No                       | Y                                |
| Requires self-host Redis                | Y                             | No                       | Y                                |

## Popular Links

* [Continuous Previews](continuous-previews.md)
* [Uffizzi Compose Specification v1](references/compose-spec.md)
