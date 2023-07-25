# Using Uffizzi

This guide explains the basics of using Uffizzi to manage ephemeral environments. It assumes that you have already [installed](install.md) the Uffizzi client.

If just want to run a few quick commands, you may want to start with the [Quickstart Guide](quickstart.md). This guide covers specific Uffizzi commands, and explains the most common ways that teams use Uffizzi: via the command-line or a continuous integration (CI) pipeline.

## Environment management and access

Uffizzi has two primary functions:   

1. **Lifecycle Management** - Uffizzi creates, updates and deletes your environments based on triggers. These triggers can be initiated manually, for example from the [Uffizzi](install.md) client, or via automated workflow like a CI pipeline.
2. **Access Control** - Uffizzi limits how your environments can be accessed and by whom. For example, you can configure password-protected environments to limit public access. Uffizzi also enforces [role-based access controls (RBAC)](topics/rbac.md) to limit who on your team can manage or update your environments.



