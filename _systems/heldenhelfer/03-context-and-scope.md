---
title: Context and Scope
order: 3
---

## Business Context

![System Context View](../images/structurizr-1-SystemLandscape.svg)

**HELD** - The HELD Application that consist of microservices. To see the HELD Application in more detail have a look at the building block view.

## Actors {#actors}

**HELD Admin** - An authenticated user who has administrator privileges (*superadmin*) of all HELD applications and clubs. The *HELD Admin* isn't a member of a club, but is able to change/delete all of them. Even though the actor has *superadmin* privileges, a full access to the data of a club shall not be possible.

**HELD Member** - An authenticated user with no special privileges and no club membership. Because the *HELD Member* has already a keycloak account it would be possible to join clubs without further steps.

**Club Admin** - An authenticated user with a membership of at least one club. In this club the *Club Admin* has administrator privileges to edit this special club. The creator of a club is automatically *Club Admin*.

**Club Member** - An authenticated user who is a member of a club with access to the functions of the club. The *Club Member* has access to all resources of a club, but no privilege to change club specific configuration.

**Unknown** - An unauthenticated user which shall have access to an overview list of all clubs. The user does not have the privileges to see usage data of the clubs. If the *Unknown* wants to join a club a registration to the identity provider is firstly necessary.

## External Systems

**SCH** - The Smart City Hub applications has for now no direct interface to the HELD Application. If there are some requirements in the future the communication shall be over dedicated Interfaces like for example the *Kafka* Message Queue.

**Monitoring** - The existing monitoring solution of the Smart City Hub cluster shall be used. That are the tools *Grafana*, *Prometheus* and *Loki*.

**IAM** - The Identity- and Accessmanagement solution *Keycloak* of the Smart City Hub shall be used for providing the user a single sign on solution.
