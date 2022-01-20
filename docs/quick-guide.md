This is a quick-guide for how to execute various actions related to Preview Deployments on Uffizzi - the reference below is related to the Uffizzi Web Interface (GUI):

|                              |                                                                                   |
|------------------------------|-----------------------------------------------------------------------------------|
| **Create a Manual Preview**      | From Project Level New Preview                                                    |
|                              | Option 1- User chooses the compose configuration they want to deploy as a Preview from their repo |
|                              | Option 2- User manually adds components via point and click                       |
|                              |                                                                                   |
| **Set-up CP**                    | From Project Level Specs                                                          |
|                              | Choose Compose                                                                    |
|                              | Connect to base `docker-compose.uffizzi.yml` in Repo                              |
|                              | CP is defined within `docker-compose.uffizzi.yml`                                 |
|                              |                                                                                   |
| **Manage Secrets**               | From Project Level Specs                                                          |
|                              | Secrets Tab                                                                       |
|                              | User Adds Secrets to UI as Write Only                                             |
|                              | Note- Secrets are applied to containers at run-time                               |
|                              |                                                                                   |
| **Add ENVs and/or Config Files** | Option 1- Include in `docker-compose.uffizzi.yml`                                 |
|                              | Option 2- Save within Repo                                                        |
|                              | Reference the File from within your compose                                       |
|                              |                                                                                   |
| **CP with a Uffizzi Build**      | User Specifies within `docker-compose.uffizzi.yml`-                               |
|                              | continuous_preview:                                                               |
|                              |   deploy_preview_when_pull_request_is_opened: true                                |
|                              |   delete_preview_when_pull_request_is_closed: true                                |
|                              |                                                                                   |
| **CP with Bring Your Own Build** | User Specifies within `docker-compose.uffizzi.yml`-                               |
|                              | Tag must = uffizzi_request_*                                                    |
|                              | continuous_preview:                                                               |
|                              |   deploy_preview_when_image_tag_is_created: true                                  |
|                              |   delete_preview_after: Xh                                                        |
|                              |                                                                                   |
| **Share Preview URL**            | User Specifies within `docker-compose.uffizzi.yml`-                               |
|                              | continuous_preview:        |
|                              |  share_to_service: true (i.e. Github, Jira, Slack...) |




