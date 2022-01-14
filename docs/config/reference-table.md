This table provides a summary of the elements described in detail in the [Uffizzi Compose file reference](../compose-spec).  

&nbsp;  

|Top-level element       | Sub-level element                            | Required | Notes                                                                                                                       |
| ---------------------- | -------------------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------- |
| **x-uffizzi**          |                                              |          | The Uffizzi [custom extension](https://github.com/docker/compose/issues/7200)                                               |
|                        | **ingress**                                  | ✔︎        | An alternative to the top-level `x-uffizzi-ingress`                                                                         |
|                        | ingress: service                             | ✔︎        | The service that should receive incoming HTTPS requests                                                                     |
|                        | ingress: port                                | ✔︎        | The port the service is listening on                                                                                        |
|                        | **continuous_previews**                      |          |                                                                                                                             |
|                        | continuous_previews: deploy_preview_when_pull_request_is_opened  |          | Uffizzi will setup webhooks on your git repositories to watch for open pull requests (PR).              |
|                        | continuous_previews: delete_preview_when_pull_request_is_closed  |          | Should be used with `deploy_preview_when_pull_request_is_opened`                                        |
|                        | continuous_previews: deploy_preview_when_image_tag_is_created    |          | Requires that you have first [configured webhooks on your container registry](../container-registry-integrations) |
|                        | continuous_previews: delete_preview_when_image_tag_is_updated    |          | Should be used with `deploy_preview_when_image_tag_is_created`                                          |
|                        | continuous_previews: delete_after            |          | Accepts values from `0-720h`, defaults to `72h`                                                                             |
|                        | continuous_previews: share_to_github         |          | Post the preview URL to GitHub pull request issue. Requires that you have first [added your GitHub credentials](../git-integrations) in the Uffizzi Dashboard (UI) |
| **x-uffizzi-ingress**  |                                              |          | A top-level alternative to `x-uffizzi`: `ingress`                                                                            |
|                        | service                                      | ✔︎        | The service that should receive incoming HTTPS requests                                                                     |
|                        | port                                         | ✔︎        | The port the service is listening on                                                                                        |
| **x-uffizzi-continuous-previews**  |                                  |          | A top-level alternative to `x-uffizzi`: `continuous_previews`                                                                            |
|                        | deploy_preview_when_pull_request_is_opened   |          | Uffizzi will setup webhooks on your git repositories to watch for open pull requests (PR).              |
|                        | delete_preview_when_pull_request_is_closed   |          | Should be used with `deploy_preview_when_pull_request_is_opened`                                        |
|                        | deploy_preview_when_image_tag_is_created     |          | Requires that you have first [configured webhooks on your container registry](../container-registry-integrations) |
|                        | delete_preview_when_image_tag_is_updated     |          | Should be used with `deploy_preview_when_image_tag_is_created`                                          |
|                        | delete_after                                 |          | Accepts values from `0-720h`, defaults to `72h`                                                                             |
|                        | share_to_github                   |          | Post the preview URL to GitHub pull request issue. Requires that you have first [added your GitHub credentials](../git-integrations) in the Uffizzi Dashboard (UI) |
| **services**           |                                              | ✔︎        |                                                                                                                             |
|                        | **build**                                    |          | A string containing a path to the build context. Required if `image` is not specified.                                      |
|                        | build: context                               |          | Expects either a local path or a URL to a GitHub repository (e.g., `context: <repository_url>#<branch_name>`) or a relative path in the current repository | 
|                        | build: dockerfile                            |          | Defaults to `./Dockerfile`                                                                                                  |
|                        | command                                      |          |                                                                                                                             |   
|                        | **configs**                                  |          | Expects a list of sources with targets                                                                                      |
|                        | configs: source                              | ✔︎        | Required if **configs** is specified; A config name as defined in the top-level **config** definition                       |
|                        | configs: target                              | ✔︎        | Required if **configs** is specified; Mount path (including filename) within the container                                  |
|                        | **deploy**                                   |          |                                                                                                                             |
|                        | deploy: x-uffizzi-auto-updates               |          | Defaults to `true`; If true, Uffizzi will auto-deploy changes made to a git or image repository                             |
|                        | deploy: resources: limits: memory            |          | Defaults to `125M`; possible values: `125M`, `250M`, `500M`, `1000M`, `2000M`, `4000M`                                      |
|                        | env_file                                     |          |                                                                                                                             |
|                        | environment                                  |          |                                                                                                                             |
|                        | image                                        |          | Defaults to `latest` tag; Expects a URI to a container registry; Currently supports ACR, ECR, GCR, and Docker Hub. Required if `build` is not specified.    |
|                        | x-uffizzi-continuous-preview                 |          | Overrides global `continuous_preview` policies for the service where it is specified.
| **configs**            |                                              |          |                                                                                                                             |
|                        | file                                         | ✔︎        | Required if top-level `configs` is defined; The relative path to the config file                                            |
| **ingress**            |                                              | ✔︎        |                                                                                                                             |
|                        | service                                      | ✔︎        | The service that should receive incoming HTTP/S traffic                                                                     |
|                        | port                                         | ✔︎        | The port the containerized service is listening on                                                                          |
| **continuous_preview** |                                              |          |                                                                                                                             |
|                        | deploy_preview_when_image_tag_is_created     |          | `true` or `false`; When `true`, all new tags created for each **image** defined in the compose file will be deployed        |
|                        | deploy_preview_when_pull_request_is_opened   |          | `true` or `false`                                                                                                           |
|                        | delete_preview_when_pull_request_is_closed   |          | `true` or `false`                                                                                                           |
|                        | delete_preview_after                         |          | Expects hours as an integer; Value is implicitly set to `72h` for previews triggered from new/updated image tag             |
|                        | share_to_github                              |          | `true` or `false`; This options shares preview URL to the GitHub pull request as a comment                                  |
