When defining your application stack with a compose file or template, you can choose to add your application components from source code or as pre-built container images. Uffizzi has out-of-the-box support for the following hosted git providers. If your provider is not listed below, consider contributing a new integration to [open-source Uffizzi](https://github.com/UffizziCloud).

## GitHub
Uffizzi's GitHub integration provides an easy way for you to preview code changes made to your GitHub repositories. To setup this integration, you will need to install the Uffizzi app in your GitHub account, then grant Uffizzi read-only access to the repositories you want to preview. Follow these simple steps to install the Uffizzi app in your GitHub account:  

1. Log into [app.uffizzi.com](https://app.uffizzi.com)  
2. Navigate to **Settings** -> **Integrations**  
3. Select the **CONFIGURE** button next to GitHub  
4. A pop-up window will appear asking you to authenticate with GitHub  
5. Once authenticated, select which repositories you want Uffizzi to have access to  
6. Save your selection  

Your Uffizzi account should now have access to the repositories you selected. Repositories that are visible to Uffizzi can be added to compose files or to templates. For more information on using the GitHub build context for compose, see the [Uffizzi Compose Specification](../config/compose-spec.md).

Additionally, Uffizzi's GitHub integration will configure webhooks for your repositories so that anytime your repository changes, Uffizzi will update your previews. Webhooks are automatically configured when you select the **Auto-deploy code changes** option in the Uffizzi web console or set `deploy: auto: true` in your compose file.
