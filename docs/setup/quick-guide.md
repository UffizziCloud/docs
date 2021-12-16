This is a quick-guide for how to execute various actions related to Preview Deployments on Uffizzi using the Compose or Template Method to define your application:

|                    | **Compose Method**                                       | **Template Method**                            |
|------------------------------|----------------------------------------------------------|------------------------------------------------|
|                              |                                                          |                                                |
| **Create a Preview**             | 1. From Project Level- New Preview button                          | 1. From Project Level- New Preview button               |
|                              | 2. Select Compose Tab                                           | 2. Select From Template or From Scratch                  |
|                              | 3. Connect to uffizzi-compose.yml in Repo             | Option 1- From existing template or create new |
|                              |                                                          | Option 2- User Manually Adds Components        |
|                              |                                                          |                                                |
| **Set-up CP**                    | From Project Level- Specs                                 | From Project Level- Specs                       |
|                              | Choose Compose                                           | Choose Templates                               |
|                              | Connect to uffizzi-compose.yml in Repo                   | User chooses existing Template or creates new  |
|                              | CP is defined within uffizzi-compose.yml                 | User selects CP Policy as part of the Template |
|                              |                                                          |                                                |
| **Manage Secrets**               | From Project Level- Project Settings                      | Same                                           |
|                              | Secrets Tab                                              |                                                |
|                              | User Adds Secrets to UI as Write Only                    |                                                |
|                              | Note- Secrets are applied to containers at run-time      |                                                |
|                              |                                                          |                                                |
| **Manage ENVs / Config Files**      | Option 1- Include in compose.yml                         | Add ENVs / Config Files to component                          |
|                              | Option 2- Save within Repo and                              |                  |
|                              | Reference the File within compose.yml                    |                                                |
|                              |                                                          |                                                |
| **CP with a Uffizzi Build**      | User Specifies within uffizzi-compose.yml-               | User specifies CP policy in Template         |
|                              | continuous_preview:                                      |                                            |
|                              | deploy_preview_when_pull_request_is_opened: true         |                                                |
|                              | delete_preview_when_pull_request_is_closed: true         |                                                |
|                              |                                                          |                                                |
| **CP with Bring Your Own Build** | User Specifies within uffizzi-compose.yml-               | Not Available from Template - not currently planned          |
|                              | Note- Tag must = uffizzi_request_#                          |                                                |
|                              | continuous_preview:                                      |                                                |
|                              | deploy_preview_when_image_tag_is_created: true           |                                                |
|                              | *delete_preview_after: Xh                                |                                                |
|                              |                                                          |                                                |
| **Share Preview URL**            | User Specifies within uffizzi.compose.yml-                           | Check box in UI [Share to Github]              |
|                              | continuous_preview:                                      |                                                |
|                              | share_to_service: true (i.e. Github, Jira, Slack...) |                                                |
|                              |                                                          |                                                |
| **Time-based deletion**          | User Specifies within uffizzi-compose.yml-               |                                                |
|                              | continuous_preview:                                      |                                                |
|                              | *delete_preview_after: Xh                                 |                                                |
|                              | *Options are 1h to 720h                                   |                                                |
