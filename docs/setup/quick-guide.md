This is a quick-guide for how to execute various actions related to Preview Deployments on Uffizzi using either the Compose or Template Method to define your application - the reference below is related to the Uffizzi Web Interface (GUI):

|                    | **Compose Method**                                       | **Template Method**                            |
|------------------------------|----------------------------------------------------------|------------------------------------------------|              
| **Create a Preview**             | 1. From Project Level- Select `New Preview` button                          | 1. From Project Level- Select `New Preview` button               |
|                              | 2. Select `Compose` Tab                                           | 2. Select From `Template` or From Scratch                  |
|                              | 3. Connect to `docker-compose-uffizzi.yml` in Repo             | Option 1- Create from existing template or create new |
|                              |                                                          | Option 2- User Manually Adds Components        |
|                              |                                                          |                                                |
| **Set-up CP**                    | 1. From Project Level- Specs                                 | 1. From Project Level- Specs                       |
|                              | 2. Select `Compose` tab                                           | 2. Select `Templates` tab                              |
|                              | 3. Connect to `docker-compose-uffizzi.yml` in Repo                   | 3. User chooses existing template or creates new Template  |
|                              | 4. CP is defined within uffizzi-compose.yml                 | 4. User selects CP Policy as part of the `Template` |
|                              |                                                          |                                                |
| **Manage Secrets**               | 1. From Project Level- go to Project Settings                      | Same                                           |
|                              | 2. Select `Secrets` Tab                                              |                                                |
|                              | 3. User Adds Secrets to UI as Write Only                    |                                                |
|                              | Note- Secrets are applied to containers at run-time      |                                                |
|                              |                                                          |                                                |
| **Manage ENVs / Config Files**      | Option 1- Include ENVS or Config in compose                         | Add ENVs / Config Files to components in GUI                          |
|                              | Option 2- Save within Repo and                              |                  |
|                              | reference the the File(s) within compose                    |                                                |
|                              |                                                          |                                                |
| **CP with a Uffizzi Build**      | User Specifies within docker-compose-uffizzi.yml-               | 1. User specifies CP policy in Template         |
|                              | i.e. continuous_preview:                                      |                                            |
|                              | deploy_preview_when_pull_request_is_opened: true         |                                                |
|                              | delete_preview_when_pull_request_is_closed: true         |                                                |
|                              |                                                          |                                                |
| **CP with Bring Your Own Build** | User Specifies policy within docker-compose-uffizzi.yml-               | Feature Not Available from Template - not currently planned          |
|                              | Note- Tag must = `uffizzi_request_#`                          |                                                |
|                              | i.e. continuous_preview:                                      |                                                |
|                              | deploy_preview_when_image_tag_is_created: true           |                                                |
|                              | *delete_preview_after: Xh                                |                                                |
|                              |                                                          |                                                |
| **Share Preview URL**            | User Specifies within uffizzi.compose.yml-                           | Check box in UI [Share to Github]              |
|                              | i.e. continuous_preview:                                      |                                                |
|                              | share_to_service: true (i.e. Github, Jira, Slack...) |                                                |
|                              |                                                          |                                                |
| **Time-based deletion**          | User Specifies within uffizzi-compose.yml-               |                                                |
|                              | i.e. continuous_preview:                                      |                                                |
|                              | *delete_preview_after: Xh                                 |                                                |
|                              | *Options are 1h to 720h                                   |                                                |
