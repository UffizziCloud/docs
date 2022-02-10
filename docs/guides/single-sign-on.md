# Single sign-on (SSO)  

Single sign-on allows you to require that members of your organization sign in to the Uffizzi Dashboard via your Identity Provider. Uffizzi is compatible with any Identity Providers that supports both the SAML and OpenID Connect protocols. We currently have out-of-the-box support for the following SSO Identity Providers:  

* ADFS  
* Azure AD  
* Google SAML  
* Okta  
* OneLogin  
* OpenID  
* PingIdentity  
* SAML (generic)  
* VMWare  

## Configure SSO  

Follow these steps to configure SSO on Uffizzi:   

1. Create an account with email/password at [app.uffizzi.com](https://app.uffizzi.com/sign_in). By default, the user that creates an account will become an account [Admin](../rbac/#admin).  
2. Once your account is created and you are logged in to the Uffizzi Dashboard, select the menu icon in the top left corner (the three horizontal lines). Then navigate to **Settings** -> **Single Sign-On (SSO)**.  
3. In the text field provided, enter the domain associated with your organization's email addresses. For example if your email address format is name@acme.com, then enter *acme.com* in the domain field. Once you've entered your domain, select **ADD DOMAIN**.     
4. Select **CONFIGURE SSO**. This will route you to a setup guide that includes configuration instructions specific to your Identity Provider. Once you complete the setup guide, you will be routed back to the Uffizzi Dashboard.  
5. If your configuration was successful, you should see a confirmation message. If so, SSO is now configured for your account. Your teammates will now be required to sign in to the Uffizzi Dashboard with SSO. On the Uffizzi sign in page, they should select the **SIGN IN WITH SSO** option.  
6. If there is a problem with your SSO connection, you can reset your configuration by selecting the **CONFIGURE SSO** button again and then selecting **Reset Connection** in the setup guide.  

## Sign in with SSO  

Once configured, your team members must authenticate via [app.uffizzi.com](https://app.uffizzi.com/sign_in_sso) with the **Sign in with SSO** option. Ufizzi does not support signing in from your Identity Provider (IdP) portal. This is because IdP-initiated authentication is vulnerable to man-in-the-middle attacks since unsolicited authentication requests made to Uffizzi cannot be verified. It is recommended that you disable the Uffizzi sign in option in your IdP's portal. 


