# Uffizzi Full-Stack Previews Engine  

Previewing code before it’s merged shouldn’t be limited to frontends. Define your full-stack apps with a familiar syntax based on Docker Compose and Uffizzi will create on-demand test environments when you open pull requests or build new images. Preview URLs are updated when there’s a new commit, so your team can catch issues early, iterate quickly, and accelerate your release cycles.

## TL;DR  
Start with a `docker-compose.yml` file, then add the following custom parameters to create a [Uffizzi Compose file](setup/compose-spec.md):  
``` yaml title="docker-compose.uffizzi.yml"
services:
  ...

continuous_previews:
  deploy_preview_when_pull_request_is_opened: true
  delete_preview_when_pull_request_is_closed: true
  share_to_github: true

ingress:
  service:   # The service that receives incoming HTTPS traffic
  port:      # The port number the container is listening on
```

Once you've created your Uffizzi Compose file, head over to our [Quick Guide](setup/quick-guide.md) to start continuously previewing your application.



## Popular Links

* [Continuous Previews](continuous-previews.md)
* [Uffizzi Compose Specification v1](references/compose-spec.md)
