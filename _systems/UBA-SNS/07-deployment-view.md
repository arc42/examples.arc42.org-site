---
title: Deployment View
order: 7
---

This view describes the environment in which the SNS system is operated.

## Production Environment

The operational infrastructure has been provided by the Umwelt-Info project (https://gitlab.opencode.de/umwelt-info/infrastruktur/testbetrieb) since early 2024 and is based on a single virtual machine in the agency's own data center. The virtual machine is set up fully automated with OpenStack. Cloud services are not involved.

## Infrastructure Level 1

![Umwelt-Info infrastructure](../images/deployment-view-umweltinfo.png)

## Infrastructure Components

### Application Server

* **Operating system**: Ubuntu 24.04 LTS
* **Caddy reverse proxy**: latest stable version for Ubuntu 24.04
* **Docker**: latest current version
* **Gitlab (OpenCode) container registry**: Technical infrastructure for deployment. Serves as the receiving point/source for Docker containers that contain the respective specialist application.

### Database Server

* **PostgreSQL**

### Specialist Applications

The specialist applications UMTHES, Chronicle, and Portal are delivered by development in the form of Docker containers and run on the container platform. The containers contain all required components (e.g. the Ruby interpreter) and expose the respective application to the application server through an exposed port.

Details on installing and operating Docker can be found in the official documentation: https://docs.docker.com/

The specific Docker containers for UMTHES, Chronicle, and Portal are part of the source code (Dockerfile, docker-compose.yml) of the respective specialist application (see [Building Block View](../05-building-block-view/)).
