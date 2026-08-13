---
title: Context and Scope
order: 3
---

![Context diagram](../images/context.jpg)

| Actor | Description | Interface |
|---|---|---|
| Visitor (browser) | The visitor of the public web portal https://sns.uba.de. These are anonymous visitors interested in environmental information. | HTTPS |
| Interface user | Third-party system that integrates SNS interfaces/services and retrieves structured information. The services and interfaces can be used anonymously, without registration. | HTTPS |
| Administrator (browser) | The administrator of the SNS system. This is a role with extended access rights. Administrators can, among other things:<br>- create users (e.g. for editorial work)<br>- manage system configuration (e.g. available languages)<br>- import and export data | HTTPS |
| Maintenance (browser) | User who performs editorial maintenance of the SNS data holdings (typically German Environment Agency (Umweltbundesamt, UBA) staff). SNS also enables collaboration in maintaining and publishing the data holdings through a fine-grained role system. | HTTPS |
