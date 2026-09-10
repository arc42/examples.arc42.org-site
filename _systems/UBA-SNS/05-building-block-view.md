---
title: Building Block View
order: 5
---

## Whitebox overall system

![Building block view overall system](../images/building_block_view.jpg)

| Subsystem | Description | Source code |
|---|---|---|
| Caddy reverse proxy | Central entry point to the SNS system. Dispatches to the respective subsystem. Access to the reverse proxy is encrypted via HTTPS. The reverse proxy performs SSL offloading. Communication with the subsystems is then unencrypted. | |
| UMTHES | Environmental thesaurus with about 12,000 descriptors (keywords) and about 40,000 non-descriptors (access vocabulary, German and English). | [https://github.com/innoq/iqvoc_umt](https://github.com/innoq/iqvoc_umt) |
| Chronicle | Environmental Chronicle with about 4,000 entries on environmental events. | [https://github.com/innoq/iqvoc_chronicle](https://github.com/innoq/iqvoc_chronicle) |
| Portal | Simple CMS and landing page of the SNS system. Markdown files are created in the portal's version control using the GitHub editor. The portal application handles the transformation of Markdown into HTML format. | [https://github.com/innoq/sns_portal](https://github.com/innoq/sns_portal) |
| PostgreSQL DBMS | Relational database management system (UMTHES & Chronicle) | |

## Level 2

### Whitebox UMTHES

![Whitebox UMTHES](../images/building_block_umthes.jpg)

A description of the individual components and the architecture can be found in the chapter [Crosscutting Concepts](../08-crosscutting-concepts/) under *iQvoc* -> *Extensions*.
