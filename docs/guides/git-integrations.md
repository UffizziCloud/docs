Uffizzi's GitHub integration provides an easy way for you to preview code changes made to your GitHub repositories. To configure this integration, you will need to install the Uffizzi app in your GitHub account, then grant Uffizzi read-only access to the repositories you want to preview. Follow these simple steps to install the Uffizzi app in your GitHub account:  

1. Log into [app.uffizzi.com](https://app.uffizzi.com)  
2. Navigate to **Settings** -> **Integrations**  
3. Select the **CONFIGURE** button next to GitHub  
4. A pop-up window will appear asking you to authenticate with GitHub  
5. Once authenticated, select which repositories you want Uffizzi to have access to  
6. Save your selection  

Your Uffizzi account should now have access to the repositories you selected. Repositories that are visible to Uffizzi can be referenced in your compose spec. For more information on using the GitHub build context for compose, see the [Uffizzi Compose file reference](../references/compose-spec.md).

Additionally, Uffizzi's GitHub integration will configure webhooks for your repositories so that anytime your repository changes Uffizzi will apply those changes accordingly.  

For existing Preview Deployments any new commits to the relevant repositories will be built and the Deployment will be updated automatically.  This is the default configuration in `docker-compose.uffizzi.yml`, if you want to turn this feature off you can set [`deploy: auto: false`](../references/compose-spec/#x-uffizzi-auto-deploy-updates) at the service level.   

>**Note:** Any changes made to your `docker-compose.uffizzi.yml` will be recognized and will be applied to any future Preview Deployments - these changes will not impact existing Preview Deployments.  
