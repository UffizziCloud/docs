# Teams and Accounts on Uffizzi Cloud

The Uffizzi Team and Account model is tightly coupled with the GitHub and GitLab account models. For example... 

Uffizzi Cloud requires that you sign up for an account using either GitHub or GitLab OAuth. When you create a new account with Uffizzi, you are creating a personal account from your [GitHub Personal Account](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts#personal-accounts) or [GitLab User Account](https://docs.gitlab.com/ee/user/profile/), depending on which provider you selected. Your Uffizzi personal account is always named after your personal GitHub/GitLab account. You cannot disassociate your Uffizzi personal account from your GitHub/GitLab personal account. If you sign in to Uffizzi with different GitHub/GitLab personal accounts, they will not be merged, i.e. you will have two separate Uffizzi personal accounts. 

A Uffizzi personal account may also be a Member of one or more Team accounts.

When you create a Team on Uffizzi, you are creating it from a [GitHub Organizational Account](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts#organization-accounts) or a [GitLab Group](https://docs.gitlab.com/ee/user/group/). Your Team is always named after your GitHub Organization or GitLab Group. You cannot disassociate your Team account from your GitHub Organization or GitLab Group. Projects created within the context of a Team account are only visible from your Team account. Similarly, projects within the context of your pesonal account, are only visible from your personal account, not your Team account.

## **`Accounts do not match` error**

!!! Important
    You cannot attach GitHub Organization or GitLab Group credentials to a Uffizzi personal account. You must first create a Uffizzi Team for your GitHub Organization or GitLab Group, then configure credentials. Otherwise, you will see the error below.

<details><summary><strong>Click to expand (Error message)</strong></summary>
<p>This error occurs when, for example, a personal account tries to configure credentials for a GitHub Organizational Account. You should first create a Uffizzi Team to conenct to a GitHub Organization / GitLab Group.</p>
<img src="../../assets/images/accounts-do-not-match-error.webp" width="600">
</details>

## **Create a Team**
When you login to Uffizzi, you login to your personal account. You can switch to a Team account or create a new Team from the account dropdown. If you choose **Create team**, you will be asked to install the Uffizzi GitHub/GitLab App and select the repositories you want to configure.

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

