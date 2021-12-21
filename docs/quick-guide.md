This is a quick-guide for how to execute various actions related to Preview Deployments on Uffizzi using either the Compose or Template Method to define your application - the reference below is related to the Uffizzi Web Interface (GUI):

|                    | **Compose Method**                                       | **Template Method**                            |
|------------------------------|----------------------------------------------------------|------------------------------------------------|              
| **Deploy a Preview**             | 1. [From Project Level- Select `New Preview` button](https://docs.uffizzi.com/setup/config-previews/#initiating-a-manual-preview)                          | 1. From Project Level- Select `New Preview` button               |
|                              | 2. Select `Compose` Tab                                           | 2. Select From `Template` or From Scratch                  |
|                              | 3. Choose `docker-compose.uffizzi.yml` in Repo             | Option 1- Create from existing template or create new |
|                              |                                                          | Option 2- User Manually Adds Components        |
|                              |                                                          |                                                |
| **Set-up Continuous Previews**                    | 1. [From Project Level- Specs](https://docs.uffizzi.com/getting-started/set-up-previews/#with-compose)                                 | 1. From Project Level- Specs                       |
|                              | 2. Select `Compose` tab                                           | 2. Select `Template` tab                              |
|                              | 3. Connect to `docker-compose.uffizzi.yml` in Repo                   | 3. User chooses existing Template or creates new Template  |
|                              | 4. CP is defined within `docker-compose.uffizzi.yml`                 | 4. User selects CP Policy as part of the Template |
|                              |                                                          |                                                |
| **Manage Secrets**               | 1. [From Project Level- Go to Project Settings](https://docs.uffizzi.com/set-up-previews/config-previews/#with-compose)                       | Same                                           |
|                              | 2. Select `Secrets` Tab                                              |                                                |
|                              | 3. User Adds Secrets to UI as Write Only                    |                                                |
|                              | Note- Secrets are applied to containers at run-time      |                                                |
|                              |                                                          |                                                |
| **Manage ENVs / Config Files**      | Option 1- Include ENVs or Config in `docker-compose.uffizzi.yml`                         | Add ENVs / Config Files to components in GUI                          |
|                              | Option 2- Save within Repo and                              |                  |
|                              | reference the the File(s) within `docker-compose.uffizzi.yml`                   |                                                |
|                              |                                                          |                                                |
| **CP with a Uffizzi Build**      | User Specifies within `docker-compose.uffizzi.yml`-               | User specifies CP policy in Template         |
|                              | i.e. continuous_preview:                                      |                                            |
|                              | deploy_preview_when_pull_request_is_opened: true         |                                                |
|                              | delete_preview_when_pull_request_is_closed: true         |                                                |
|                              |                                                          |                                                |
| **CP with Bring Your Own Build** | User Specifies policy within `docker-compose.uffizzi.yml`-               | Feature Not Available from `Template` - not currently planned          |
|                              | Trigger is tag-based. Tag must = `uffizzi_request_#`                          |                                                |
|                              | i.e. continuous_preview:                                      |                                                |
|                              | deploy_preview_when_image_tag_is_created: true           |                                                |
|                              | delete_preview_after: Xh                                |                                                |
|                              |                                                          |                                                |
| **Share Preview URL**            | User Specifies within `docker-compose.uffizzi.yml`-                           | Check box in UI [Share to Github]              |
|                              | i.e. continuous_preview:                                      |                                                |
|                              | share_to_service: true (i.e. Github, Jira, Slack...) |                                                |
|                              |                                                          |                                                |
| **Time-based deletion**          | User Specifies within `docker-compose.uffizzi.yml`-       |  Not currently supported, planned |        |                                                |
|                              | i.e. continuous_preview:                                      |                                                |
|                              | *delete_preview_after: Xh                                 |                                                |
|                              | *Options are 1h to 720h                                   |                                                |
