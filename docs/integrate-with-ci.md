2. Paste the contents into a new file called `docker-compose.uffizzi.yml`  
(This file is used by Uffizzi to configure previews for your application)   
3. Add the `x-uffizzi` Compose extension to create a [Uffizzi Compose file](references/compose-spec.md):   
``` yaml title="docker-compose.uffizzi.yml"
# Uffizzi extension
x-uffizzi:
  ingress:                   # required
    service: [service-name]  # the service that should receive https traffic
    port: [port-number]      # the port this service listens on
  continuous_previews:
    deploy_preview_when_pull_request_is_opened: true
    delete_preview_when_pull_request_is_closed: true
    share_to_github: true

# Your application services
services:  
...
```

## Next article

[Connect to Uffizzi Cloud](connect-to-uffizzi-cloud.md)