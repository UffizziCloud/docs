# Continuous Previews with Bring Your Own Build 

If you're looking for a Full Stack Preview capability but want to bring your own CI/CD solution and Container Registry - keep reading.  In this blog I'll cover how Uffizzi gives users the ability to enable Tag-initiated Previews (aka Continuous Previews) by setting up a webhook in their registry and by using the Uffizzi tagging convention `uffizzi_request_#`. 

For this blog I'll be referencing Gitlab + Azure's Container Registry (ACR) but the concepts apply to any CI/CD + Container Registry combination.

## Starting with your docker-compose.uffizzi.yml



