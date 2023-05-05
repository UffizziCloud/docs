# **Demo on Uffizzi** button

Add the **Demo on Uffizzi** button to your repository's `README.md` to give visitors a fast way to interact with your application in a live demo environment. This button requires **no configuration** by your users, and it **does not** require them to have a Uffizzi account.

![Demo](https://storage.googleapis.com/cdn.uffizzi.com/demo-button.svg)  
 
!!! Note
    The **Demo on Uffizzi** button is currently available only to Uffizzi [Open Source Plan](https://www.uffizzi.com/pricing) customers—i.e. it will not work on any arbitrary repo. Open source maintainers can [contact us on Slack](https://join.slack.com/t/uffizzi/shared_invite/zt-ffr4o3x0-J~0yVT6qgFV~wmGm19Ux9A) to configure this for their projects.

## How it works  

For qualifying projects, Uffizzi creates a public route of the the form `https://app.uffizzi.com/demo/github.com/<ACCOUNT>/<PROJECT>`. When a user visits this endpoint (by clicking on the demo button), Uffizzi checks that a demo Compose file (`docker-compose.demo.uffizzi.yml`) is configured for the project. If it exists, Uffizzi will deploy this configuration to a demo environment.

```
[![Demo](https://cdn.uffizzi.com/demo-button.svg)](https://app.uffizzi.com/demo/github.com/<ACCOUNT>/<PROJECT>)
```


