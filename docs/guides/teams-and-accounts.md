# Teams and Accounts

The Uffizzi Team and Account model is tightly coupled with the GitHub Organization and Account model. For example... 

When you create a new account with Uffizzi, you are creating a personal account from your [GitHub Personal Account](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts#personal-accounts). Your Uffizzi personal account is always named after your GitHub Personal Account. You cannot disassociate your Uffizzi personal account from your GitHub Personal Account. If you sign in to Uffizzi with different GitHub Personal Accounts, they will will not be merged, i.e. you will have two separate Uffizzi personal accounts. 

A Uffizzi personal account may also be a Member of one or more Team accounts.

When you create a Team on Uffizzi, you are creating a it from a [GitHub Organizational Account](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts#organization-accounts). Your Team is always named after your GitHub Organization. You cannot disassociate your Team account from your GitHub Organizational Account.

## **`Accounts do not match` error**

!!! Important
    You cannot attach GitHub Organization Credentials to a Uffizzi personal account. You must first create a Uffizzi Team for your GitHub Organization, then configure credentials. Otherwise, you will see the error below.

<details><summary><strong>Click to expand (Error message)</strong></summary>
<p>This error occurs when, for example, a personal account tries to configure credentials for a GitHub Organizational Account. You should first create a Uffizzi Team to conenct to a GitHub Organization.</p>
<img src="../../assets/images/accounts-do-not-match-error.webp" width="600">
</details>

## **Create a Team**
When you login to Uffizzi, you login to your personal account. You can switch to a Team account or create a new Team from the account dropdown. If you choose **Create team**, you will be asked to install the Uffizzi GitHub App and select the repositories you want to configure.

<details><summary><strong>Click to expand (Screenshots)</strong></summary>
<p>Account dropdown</p>
<img src="../../assets/images/account-dropdown.webp" width="600">
<p>Create a team</p>
<img src="../../assets/images/create-team.webp" width="600">
<p>Choose an Organization to create a Team. If you choose a personal account in this step you will get an error in Uffizzi.</p>
<img src="../../assets/images/choose-org.webp" width="600">
<p>Select the repositories you want to configure with Uffizzi.</p>
<img src="../../assets/images/select-repositories.webp" width="600">
</details>
&nbsp;  
&nbsp;  
&nbsp;  
&nbsp;  

