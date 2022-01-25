This table provides a quick guide for how to execute various actions related to preview deployments in the Uffizzi Dashboard (UI).  

|                              |                                                                                   |
|------------------------------|-----------------------------------------------------------------------------------|
| **[Create a manual preview](set-up-previews.md)**  | Navigate to desired project. Select **NEW PREVIEW**.                                                    |
|                              | Option 1 (From Compose): Select **Deployment method** > **From Compose**, then selct **Compose** > *filename* > **DEPLOY** |
|                              | Option 2 (From scratch): Select **Deployment method** > **None (from scratch)**. Manually add components, then select **DEPLOY**                      |
| **[Set-up Continuous Previews (CP)](set-up-previews.md#using-compose)**                | Navigate to **Project** > **Specs** > **Compose**                                                         |
|                              | Select **NEW COMPOSE**                                                                    |
|                              | Sign in to GitHub (if not already). Select repo, branch and compose filename (e.g.`docker-compose.uffizzi.yml`)                              |
|                              | CP must be defined within `docker-compose.uffizzi.yml`                                 |
| **[Manage secrets](guides/secrets.md)**           | Navigate to **Project** > **Specs** > **Secrets**                                                          |
|                              | Select **NEW SECRET**. Enter secrets, then select **SAVE & CLOSE**                                                                        |
|                              | (Note: Secrets must be [explicitly invoked](references/compose-spec.md#secrets-configuration-reference)  in your `docker-compose.uffizzi.yml`)                             |
| **[Add environment variables](guides/environment-variables.md)** | Environment variables are added via your `docker-compose.uffizzi.yml`                               |
|                              | Option 1: Use the [`environment`](references/compose-spec.md#environment) object in your `docker-compose.uffizzi.yml`                                                        |
|                              | Option 2: Use the [`env_file`](references/compose-spec.md#env_file) parameter in your `docker-compose.uffizzi.yml`                                          |
| **[Add config files](references/compose-spec.md#configs)** | Config files should exist in the same repository as (and be invoked within) your `docker-compose.uffizzi.yml`                         |
|                              | Reference the config files in your repo with the [`configs` top-level element](references/compose-spec.md#configs-configuration-reference)                                                       |
|                              | Call the top-level `configs` with the [service-level `configs`](references/compose-spec.md#configs) object                                        |
| **[CP with a Uffizzi build](guides/git-integrations.md)**  | Use the [`build: context:`](references/compose-spec.md#build) element in your `docker-compose.uffizzi.yml` where the value is your GitHub repo's URL                                |
|                              | Use the [`continuous_previews`](references/compose-spec.md#continuous_previews) option within your `docker-compose.uffizzi.yml`                                                           |
|                              | Set [`deploy_preview_when_pull_request_is_opened: true`](references/compose-spec.md#deploy_preview_when_pull_request_is_opened)                                |
|                              | Set [`delete_preview_when_pull_request_is_closed: true`](references/compose-spec.md#delete_preview_when_pull_request_is_closed)                                |
| **[CP with Bring Your Own Build](guides/container-registry-integrations.md)** | Use the [`image`](references/compose-spec.md#image) element in your `docker-compose.uffizzi.yml`                             |
|                              | Configure your build system to tag images built from new pull requests with `uffizzi_request_#`, where `#` is the pull request number.                                                      |
|                              | Use the [`continuous_previews`](references/compose-spec.md#continuous_previews) option within your `docker-compose.uffizzi.yml`                                                           |
|                              | Set [`deploy_preview_when_new_image_is_created: true`](references/compose-spec.md#deploy_preview_when_new_image_is_created)                                |
|                              | Set [`delete_preview_after: 24h`](references/compose-spec.md#delete_preview_when_after)                                |
| **Share preview URL**        | Share the preview URL to various third-party platforms                              |
|                              | Use the [`continuous_previews`](references/compose-spec.md#continuous_previews) option within your `docker-compose.uffizzi.yml`        |
|                              | Set [`share_to_[service]: true`](references/compose-spec.md#share_to_github)(i.e., GitHub, Jira, Slack, etc.)                                |
