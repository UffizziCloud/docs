# Role-based Access Control

## Accounts

Accounts are the top of the Role-based Access Control (RBAC) hierarchy and are associated with a customer billing account, typically the customer's company or organization. Support for one user login to have access to multiple organizational accounts is not currently support but is coming soon.  A user can be a member of multiple accounts by using different email logins.  

## Projects  

Projects fall within accounts and represent a development effort such as an application ecosystem (repositories, backing services, configuration files, etc.). Projects can be created and edited by Admins and Developers.  

## Team Members

Members are individual users that are associated with an Account and have an assigned access role of Admin, Developer, or View Only.  The Member who creates an Account is by default the Admin of that account.  An account must always have one Admin.

## Single Sign On (SSO)

If a Members Organization has enabled SSO for their account, then a member must utilize the SSO function to log in to their account. Administrators are still able to login in via email/password to administer SSO configuration. See [Single Sign-on](setup/single-sign-on.md) for more details.

## Roles 

* **Admin** - Admins can do all and see all within an Account.  Admins can view and edit every project and deployment.  This is the highest level of permission for an account.  Uniquely they control the RBAC and billing, installation, and clusters as required.  An Account must have at least one Admin.  Admins control who is on the Account.

* **Developer** - Developers can view and edit projects and deployments that they either created or were invited to.  They can NOT edit billing, installations, and clusters.  A Developer can create Projects and be invited to Projects.  A Developer can invite other Developers to a Project.  A Developer can only “see” and “edit” Projects that they either created or were invited to.

* **Viewers** - Viewers can see every project that they have been invited to.