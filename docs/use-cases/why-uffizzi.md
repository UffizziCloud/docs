Uffizzi helps alleviate two problems that commonly plague software development teams:  

1. **Dirty code in your `main` branch**: Uffizzi provides Dev and QA teams with the ability to rapidly share and review new features before they're merged—catching bugs early and keeping them out of a team's `main` git branch. This capability also empowers a team to simplify their testing process by separating functional testing from integration testing - an individual developer's topic branch can be tested in isolation before merging it with the rest of the team's contributions.

2. **Limited Dev/QA environments**: Uffizzi eliminates problems associated with multiple developers sharing a single or limited number of test environments. With Uffizzi, previews are isolated (one developer's preview won't clobber another's) and ephemeral (they exist only as long as they are needed). New previews can be triggered when important events occur, like when a new PR is opened or a new image tag is created. Then previews environments are destroyed when the PR is closed or on a preset time-based deletion.  If an on-demand environment is broken you can throw it away and create a new one without impacting your teammates.

Uffizzi supports *configuration-as-code*. To configure Uffizzi, you provide a `docker-compose.uffizzi.yml` file that defines your application stack in Docker Compose syntax, along with a few extra parameters to tell Uffizzi when and how to deploy your previews. See the [Uffizzi Compose file reference](./references/compose-spec.md) for details or check out these [example Uffizzi Compose files](./references/example-compose.md).

When Continuous Previews are configured, Uffizzi uses webhooks on your git repository or container registry to watch for changes to your application. When it detects a trigger, a new preview is deployed based on the policies you set within your Uffizzi Compose file. For each new preview, Uffizzi generates a secure, shareable URL, and when you push new commits/tag updates, the preview link is automatically updated. This allows you to avoid context switching by staying within a git workflow - you do not have to tell Uffizzi to deploy previews.

## Uffizzi-Managed Build vs. Bring Your Own Build Options
Uffizzi supports deploying previews directly from your [git repository](./guides/git-integrations.md) or from a [container registry](./guides/container-registry-integrations.md).  

Users have the option for Uffizzi to build your application or you can [augment your existing CI/CD solution with a Continuous Previews (CP) capability](./engineeringblog/ci-cd-registry.md).  

If you are using your own CI/CD for the build, images tagged `uffizzi_request_<#>` can initiate new preview deployments.  In addition to being compatible with custom build processes this allows for users on Gitlab, Bitbucket, or other Version Control Systems to immediately benefit from Uffizzi.

## What can I use Uffizzi for?  

- **Implementing a Continuous Previews capability**  
If you're new to this concept, checkout this [Continuous Previews overview](continuous-previews.md).  

- **Catch mistakes early**  
It's much easier to find and fix issues early in the development cycle than after an issue has been merged. Merge with confidence knowing a feature works as intended.  

- **Iterate quickly**  
Uffizzi helps improve collaboration across Dev and Product Teams to iterate faster.  

- **Accelerate release cycles**  
Uffizzi directly improves Lead Time, Cycle Time, Team Velocity, and Code Stability Key Performance Indicators (KPIs) 

- **Deconflict your shared Test/QA environment**  
You can eliminate the bottlenecks of a shared development environment since every developer on your team can have as many preview environments as they need. And because preview environments are isolated and ephemeral, you no longer have to worry that a new commit might break QA for the rest of the team. 

- **Trace root causes more easily**  
With Uffizzi, teams can test topic branches *before* they're merged. This means you can separate functional testing from integration testing, allowing you to merge with confidence knowing that the feature works as expected before it undergoes integration testing.  

- **Reduce costs**  
Uffizzi's preview environments can replace your static QA environment. Every preview exists in its own lightweight environment, which is destroyed when a PR is closed or after a certain number of hours. See [Uffizzi Compose file reference](./references/compose-spec.md) for configuration options.

- **Augment your existing CI/CD pipeline with CP**  
Continuous Previews can be combined with your existing CI/CD solution 


