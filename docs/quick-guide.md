This is a quick-guide for how to execute various actions related to Preview Deployments on Uffizzi - the reference below is related to the Uffizzi Web Interface (GUI):

|                              |                                                                                   |
|------------------------------|-----------------------------------------------------------------------------------|
| **Create a Manual Preview**      | Within the UI, From Project Level select [New Preview](/set-up-previews/#initiating-a-manual-preview)                                                    |
|                              | Option 1- User chooses the compose configuration they want to deploy as a Preview from their repo |
|                              | Option 2- User manually adds components via point and click                       |
|                              |                                                                                   |
| **Set-up Continuous Previews (CP)**                    | Within the UI, Go to Project Level/Specs                                                          |
|                              | Choose Compose Tab                                                                    |
|                              | [Connect](https://docs.uffizzi.com/set-up-previews/#connecting-your-compose) to base `docker-compose.uffizzi.yml` in Repo                              |
|                              | continuous_previews is defined within `docker-compose.uffizzi.yml`                                 |
|                              |                                                                                   |
| **Manage Secrets**               | Step 1: Add [secrets:...](https://docs.uffizzi.com/references/compose-spec/#secrets_1) to your `docker-compose.uffizzi.yml                                                          |
|                              | Step 2: Within UI, From Project Level choose [Secrets](guides/secrets.md) Tab                                                                      |
|                              | User Adds Secrets to UI as Write Only                                             |
|                              | Note- Secrets are applied to containers at run-time                               |
|                              |                                                                                   |
| **Add ENVs** | Option 1- Use [`environment:...`](https://docs.uffizzi.com/references/compose-spec/#environment) within `docker-compose.uffizzi.yml`                            |
|                              | Option 2- Use [`env_file:...`](https://docs.uffizzi.com/references/compose-spec/#env_file)                                                        |
                                     |
|                              |                                                                                   |
| **CP with a Uffizzi Build**      | User Specifies within `docker-compose.uffizzi.yml`-                               |
|                              | [continuous_preview](https://docs.uffizzi.com/references/compose-spec/#continuous_previews):                                                               |
|                              |   deploy_preview_when_pull_request_is_opened: true                                |
|                              |   delete_preview_when_pull_request_is_closed: true                                |
|                              |                                                                                   |
| **CP with Bring Your Own Build** | User [Specifies](engineeringblog/ci-cd-registry.md) within `docker-compose.uffizzi.yml`-                               |
|                              | Tag must = uffizzi_request_*                                                    |
|                              | continuous_preview:                                                               |
|                              |   deploy_preview_when_image_tag_is_created: true                                  |
|                              |   delete_preview_after: Xh                                                        |
|                              |                                                                                   |
| **Share Preview URL**            | User Specifies within `docker-compose.uffizzi.yml`-                               |
|                              | continuous_preview:        |
|                              |  [share_to_service](https://docs.uffizzi.com/references/compose-spec/#share_to_github): true (i.e. Github, Jira, Slack...) |




