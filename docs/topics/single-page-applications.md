# Configure `API_BASE_URL` for React Apps and Other Single-Page Applications (SPA)

In a typical single-page application (SPA) frontend + REST API backend example, the frontend service would have an `API_BASE_URL` or similar `ENV` `var` which points to the backend service. How would we set something like this up with Uffizzi’s preview environments?  

Each Uffizzi environment includes an environment variable [`UFFIZZI_URL`](../references/uffizzi-environment-variables.md) which is available to all containers in the environment. It’s value is the public endpoint of the environment, so if you just have a backend API deployed there, that’s what you’d need to provide to your frontend. Note that this URL is dynamically created when the ephemeral environment is created.
