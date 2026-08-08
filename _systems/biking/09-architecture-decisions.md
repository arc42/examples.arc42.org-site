---
title: Architecture Decisions
order: 9
---

Use GPSBabel for converting TCX into GPX format

: **Problem:** popular JavaScript mapping frameworks provide easy ways to include geometries from GPX data on maps. Most Garmin devices, however, record track data in TCX format, so a way to convert TCX to GPX was needed. Both formats are relatively simple and, in the case of GPX, well documented.

: **Constraints:** conversion needs to handle TCX files with single tracks, laps and additional points without problem. The focus of this project was on developing a modern application backend for an AngularJS SPA, not on parsing GPX data.

: **Assumptions:** using an external, non-Java based tool makes it harder for people who just want to try out this application. Although well documented, both file types can contain varieties of information (routes, tracks, waypoints), which makes them hard to parse.

: **Considered alternatives:** writing a custom converter, or using the existing swiss army knife for GPS data, [GPSBabel](http://www.gpsbabel.org) — "GPSBabel converts waypoints, tracks, and routes between popular GPS receivers such as Garmin or Magellan and mapping programs like Google Earth or Basecamp. [...] It has been downloaded and used tens of millions of times since it was first created in 2001, so it's stable and trusted."

: **Decision:** _biking2_ uses GPSBabel for the heavy lifting of GPS related data. The project's README states that GPSBabel must be installed. GPSBabel can be installed on Windows with an installer, and on most Linux systems through the official package manager. Under OS X it is available via MacPorts or Homebrew.

Use local file storage for image and track data

: **Problem:** _biking2_ needs to store "large" objects: image data (biking and gallery pictures) as well as track data.

: **Considered alternatives:** cloud storage like S3, or the local file system.

: **Decision:** local file system, to avoid spending much effort evaluating cloud services. If _biking2_ should ever need to run in a cloud based setup, an abstraction over the local filesystem currently used would need to be created.

Use a database centric approach

: **Problem:** _biking2_ was not conceived as database centric in the beginning. Hibernate entities had been modelled, and the database was set up with Hibernate's automatic DDL. Analytic functions were not used; computation was done in memory instead.

: **Considered alternatives:** a database centric approach, as described in ["Live with your SQL-fetish and choose the right tool for the job"](https://speakerdeck.com/michaelsimons/live-with-your-sql-fetish-and-choose-the-right-tool-for-the-job).

: **Decision:** in late 2019, that decision was implemented. Flyway was introduced to create tables and other migrations via SQL scripts. Based on a database that is actually under our control, a jOOQ schema is generated, on which all SQL generation for computing statistics is done. For more information, see the [whitebox view of the statistics module](../05-building-block-view/#statistics-whitebox).
