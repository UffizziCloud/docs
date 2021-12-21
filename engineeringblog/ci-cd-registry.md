# Lorem Ipsum

Uffizzi is a Full-stack Previews Engine that makes it easy for your team to preview code changes before merging—whether frontend, backend or microservice. Define your full-stack apps with a familiar syntax based on Docker Compose, then Uffizzi will create on-demand test environments when you open pull requests or build new images. Preview URLs are updated when there’s a new commit, so your team can catch issues early, iterate quickly, and accelerate your release cycles.

Uffizzi provides an off-the-shelf Continuous Previews capability that can support your entire application eco-system and is highly configurable.  You can define your Previews by extending `docker-compose.yml` or by using a GUI-based template - in either case you have the ability to define trigger-based previews based on either pull requests or via image tag updates.

When a developer is ready for their feature branch to be previewed they `git push` to remote then open a `pull request` for their feature branch which then triggers a preview of the stack as defined in `docker-compose-uffizzi.yml`.  Users have the option for Uffizzi to build from source and deploy or to deploy directly from one of several integrated image registries (Docker Hub, ACR, ECR, GCR).  

Uffizzi also offers a Bring Your Own Build (BYOB) option that enables users to leverage their own build process to trigger previews.  In this scenario images tagged `uffizzi_request_<#>` will initiate new previews.  In addition to being compatible with custom build processes this allows for users on Gitlab and Bitbucket to benefit from Uffizzi prior to releasing those integrations.

## Yada Yada Yada

Uffizzi has a cloud-hosted offering and a self-hosted offering with separate CLI and GUI interfaces.  The GUI is the only component of Uffizzi that is not open source.