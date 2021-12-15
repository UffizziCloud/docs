# Overview

All of a Uffizzi Environment's containers are deployed within a single Kubernetes Pod. Containers within this Pod share their network namespaces - including their IP address. This means that containers within an Environment can all reach each other on `localhost`. This is similar to using Docker's `host` network.

This also means that containers must coordinate port usage, but this is no different from processes on a workstation or virtual machine. Be careful you don't configure two or more containers to bind to the same TCP port.

# Load Balancing Incoming Traffic

Every Uffizzi environment includes a load balancer that receives incoming HTTPS requests and routes them to the [HTTP port specified](references/compose-spec/#ingress-required) for the container which receives incoming requests. Uffizzi load balancers are set up and managed automatically, so you don't need to enable or configure them. Uffizzi also handles HTTPS certificates for you; our certificate authority is trusted by all popular web browsers and devices.

Uffizzi will also set up an external IP address and DNS record for your load balancer, so you and your stakeholders can access it from anywhere via a public HTTPS URL.

Separate preview deployments do not share an internal network, so they may only communicate over the public internet.
