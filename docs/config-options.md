# Configuration Options and Features
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
| Requires Coordination with Uffizzi Reps | N / Never                     | N                       | Y, pending upgrade to onboarding |
| Requires own K8s cluster                | Y                             | N                       | Y                                |
| Requires self-host GUI                  | N, N/A                     | N                       | Y                                |
| Requires self-host Postgres Db          | Y                             | N                       | Y                                |
| Requires self-host Uffizzi App          | Y                             | N                       | Y                                |
| Requires self-host Redis                | Y                             | N                       | Y                                |