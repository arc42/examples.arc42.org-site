---
title: Building Block View
order: 5
---

This area describes the different levels of the HELD application.

![Over All Building Block View](../images/structurizr-1-SystemContext-001.svg)

## Level 1 - HELD Application

![Level 1 - HELD Application View](../images/structurizr-1-Container-001.svg)

**Hero Portal Web UI** - This is the Web UI microservice which contains every Web UI logic for the Hero Portal.

**Hero Portal Backend** - This is the backend microservice which contains every backend logic for the Hero Portal.

**Club Forum** - As the club forum the open source software *Discourse* is used.

**Digital Office** - The open source software *Nextcloud* is used for the Digital Office measure.

**Identity Provider Sidecar Backend** - Central Sidecar Service that communicates with the identity provider (keycloak) via REST API. To avoid that every service knows the admin credentials from keycloak to configure or read something, this sidecar service exist. Every service that want to interact with keycloak can do this via the sidecar. The authentication works over an API key. Because of different API keys it is also possible to implement a small authorization, so that not every service can do anything on keycloak. This shall enhance the security.

**External Systems** - As external systems there are the Identity and Access Management system, the monitoring system, a database server, file store systems and event streaming system. There are also the known actors which uses the HELD application.

## Level 2 - Hero Portal Backend

![Level 2 - Hero Portal Backend View](../images/structurizr-1-Component-001.svg)

**Clubs** - The clubs module of the Hero Portal Backend Micro Service. It handles the CRUD operations for the clubs. Furthermore members could be invited here into different clubs. This module also stores the information about which actors are members and which are administrators via the user id. Over the *Identity Provider Sidecar Backend*-Service the user information with *Keycloak* is synchronized.

**Event Streaming** - A event streaming service (Kafka) is used to publish *ClubEvents* (e.g. *ClubCreated*). With this mechanism the *Hero Portal Backend* is completely decoupled from the third-party systems. Every Sidecar of the third-party system can subscribe the *ClubEvents* Messages and can use the information in it.

## Level 2 - Digital Office View

![Level 2 - Digital Office View](../images/structurizr-1-Component-002.svg)

**Nextcloud** - The main application behind the digital office is the *Nextcloud* third party open source tool. This application delivers a collaboration platform for the clubs. The club areas are implemented within the share folder basic functionality. Sharing files and folders are basic functionalities and therefore not dependent on other nextcloud apps. Every club has two folders which are called *club area* in this project context. One is just for administrators and one is for every club member. A club is technically a group in nextcloud. Each club member and admin is in a corresponding group. These groups are used to share the folders. Every configuration is done automatically by the *Hero Portal Backend*.

**Digital Office Sidecar** - The sidecar service is a service for the nextcloud configuration. It's a self written Fast API based service. The idea behind this service is to decouple the digital office configuration from the *Hero Portal Backend* service via an event streaming platform (Kafka). Every club setting change by club admin is published from the *Hero Portal Backend*. The *Digital Office Sidecar*-Service subscribes all club events and will then configure *Nextcloud* accordingly via REST API.

**Nextcloud Office** - This is a nextcloud app installed via the nextcloud app store. It works with a *Collabora* instance to provide the office functionality.

**Collabora** - [Collabora](https://www.collaboraoffice.com) is a own instance in the kubernetes cluster and is used by the *Nextcloud Office* application.

**OpenID Connect Login** - This is a nextcloud extension that provides the SSO functionality with keycloak.

**EVS** - To avoid higher costs the *Elastic Volume Service* is used at the beginning to store the nextcloud data. The advantage is that this kind of storage is cheap and fast. The disadvantage is that there is only a *ReadWriteOnce* access possible. Therefore this kind of storage is not usable if the horizontal pod autoscaling shall be used. For the autoscaling functionality the storage must be switched to the *SFS Turbo* Service of the *Open Telekom Cloud*.

## Level 2 - Club Forum View

![Level 2 - Club Forum View](../images/structurizr-1-Component-003.svg)

**Discourse** - The main application behind the club forum is the open source third party application [Discourse](https://www.discourse.org). In discourse it's possible to install plug-ins, which are providing more functionality. The image of this view shows all installed plug-ins.

**Club Forum Sidecar** - The sidecar service is a service for the discourse configuration. It's a self written Fast API based service. The idea behind this service is to decouple the club forum configuration from the *Hero Portal Backend* service via an event streaming platform (Kafka). Every club setting change by club admin is published from the *Hero Portal Backend*. The *Club Forum Sidecar*-Service subscribes all club events and will then configure *Discourse* accordingly via REST API.

**Club Forum Redis** - *Discourse* is not able to run without a Redis-Database. The used [Helm-Chart](https://github.com/bitnami/charts/blob/main/bitnami/discourse/README.md) from Bitnami offers the possibility to deploy a Redis master and replica instance directly with Discourse. This is used for now. If this is not stable a service from the *Open Telekom Cloud* can be used instead.

**EVS** - As File Store the *Elastic Volume Service* is used. The access to this storage is *ReadWriteOnce*. Every Redis instance creates it's own EVS. Also for discourse itself the EVS is used. First tries with an OBS failed because of access rights problems.

## Level 2 - IAM SCH Realm

![Level 2 - IAM SCH Realm View](../images/structurizr-1-Component-004.svg)

**Hero Portal Application** - This is a client in Keycloak. It's responsible to authenticate and authorize users within the Hero Portal Web UI via the OIDC protocol. The client shall have the following roles:

- HP Administration - That is the role the actor *HELD Admin* shall obtain to authorize against the Hero Portal Backend

**Digital Office Application** - This keycloak client handles the authentication and authorization of the digital office. Nextcloud also uses this client to synchronize the user information within keycloak.The client shall have the following roles:

- DO Administration - That is the role the actor *HELD Admin* shall obtain to have access to the nextcloud administration settings.
- DO Mitglied - This role shall be added to every authenticated actor like *HELD Member*, *Club Admin*, *Club Member* to have access to nextcloud.

**Club Forum Application** - The club forum (discourse) uses this keycloak client to authenticate and authorize the users.
