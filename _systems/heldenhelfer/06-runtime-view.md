---
title: Runtime View
order: 6
---

## Create Club Workflow

After a club was created the following workflow happens to configure the digital office and the club forum:

![Create Club for digital office runtime view](../images/runtime_view_club_creation_new.svg)

A *HELD Member* creates a new club via the *Hero Portal Web UI*. If the save button is clicked, then a backend call via REST API to the *Hero Portal Backend* is done. The backend saves the club in the database, sends a club created event to kafka and returns a positive response to the Web UI.

After the club created event appears on the kafka message bus, the *Digital Office Sidecar Backend* starts the configuration process. Folders, groups and shares are configured to nextcloud directly. The assignment of the users to the groups works via client roles in keycloak. If a user has a client role with the same name as a nextcloud group, than the user is directly member of this group.

In parallel to the *Digital Office* configuration, the *Club Forum* configuration is done. The *Club Forum Sidecar Backend* receives the club created event and configures discourse directly.
