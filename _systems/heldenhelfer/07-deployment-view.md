---
title: Deployment View
order: 7
---

## Overall Deployment View

![Overall Deployment View](../images/structurizr-1-Deployment-001.svg)

As a cloud provider the Open Telekom Cloud is used due to data protection reasons. In order to achieve synergies with the Smart City Hub and to reduce operation costs, the SCH cloud instance will be used. That means that the HELD application runs on the same kubernetes cluster as the SCH applications but in an other namespace. Also the Database server and the File service is used from SCH.
