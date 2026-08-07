---
title: Context and Scope
order: 3
---

>**Content and Motivation**
>
>You want to know the boundaries and scope of the system
>to distinguish it from neighboring systems. The context identifies the
>systems relevant external interfaces.

## 3.1 Business Context

>You want to identify all neighboring systems and the different kinds of
>(business) data or events that are exchanged between your system and its neighbors.

![Business context](../images/3-hsc-business-context.png)

| Neighbor | Description |
|------|:-----|
|user         |documents software with toolchain that generates html. Wants to ensure that links within this HTML are valid.     |
| | |
|build system      |mostly [Gradle](https://gradle.org) |
| | |
|local HTML files  |HtmlSC reads and parses local HTML files and performs sanity checks within those. |
| | |
|local image files |HtmlSC checks if linked images exist as (local) files.     |
| | |
|external web resources |HtmlSC can be configured to optionally check for the existence of external web resources. **Risk**: Due to the nature of web systems and the involved remote network operations, this check might need significant time and might yield invalid results due to network and latency issues.  |

## 3.2 Deployment Context

>You like to know about the technical or physical infrastucture of your system,
>together with physical channels or protocols.

The following diagram shows the participating computers (nodes) with their technical
connections plus the major artifacts of HtmlSC, the hsc-plugin-binary.

![Deployment context](../images/3-deployment-context.png)

|Node / Artifact   |Description                                           |
|------|--------|
|hsc-development   |where development of HtmlSC takes place               |
| | |
|hsc-plugin-binary |compiled and packaged version of HtmlSC including required dependencies.|
| | |
|artifact repository | A global public _cloud_ repository for binary artifacts, similar to [MavenCentral](https://search.maven.org/), the [Gradle Plugin Portal](https://plugins.gradle.com) or similar. HtmlSC binaries are uploaded to this server.          |
| | |
|hsc user computer |where arbitrary documentation takes place with html as output formats.|
| | |
|build.gradle      |Gradle build script configuring (among other things) the HtmlSC plugin to perform the HTML checking.  |
| | |

For details see the [deployment-view](../07-deployment-view/).
