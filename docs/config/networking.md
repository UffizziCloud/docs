# Overview

All of a Preview environment's containers are deployed within a single Kubernetes Pod. Containers within this Pod share their network namespaces - including their IP address. This means that containers within an environment can all reach each other on `localhost`. This is similar to using Docker's `host` network.

This also means that containers must coordinate port usage, but this is no different from processes on a workstation or virtual machine. Be careful you don't configure two or more containers to bind to the same TCP port.

# Load Balancing Incoming Traffic

Every Preview environment includes a load balancer that receives incoming HTTPS requests and routes them to the [HTTP port specified](https://docs.uffizzi.com/config/compose-spec/#ingress-required) for the container which receives incoming requests. Preview load balancers are set up and managed automatically, so you don't need to enable or configure them. The load balancer also handles HTTPS certificates for you; the certificate authority is trusted by all popular web browsers and devices.

The load balancer will also set up an external IP address and DNS record, so you and your stakeholders can access it from anywhere via a public HTTPS URL.

Separate Preview environments do not share an internal network, so they may only communicate over the public Internet.

# Limitations

Only HTTP traffic is forwarded by the load balancer, and only to one container within each Preview. If your application needs external traffic that is not HTTP, and/or needs to route external traffic to more than one container, please [let us know on Slack](https://join.slack.com/t/uffizzi/shared_invite/zt-ffr4o3x0-J~0yVT6qgFV~wmGm19Ux9A)!
