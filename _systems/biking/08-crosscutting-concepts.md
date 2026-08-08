---
title: Cross-cutting Concepts
order: 8
---

## Domain Models

_biking2_ is a data centric application, so everything is based around an entity-relationship diagram:

![ER diagram](../images/8_1-er-diagram.png)

| Table | Description |
|---|---|
| bikes | Stores the bikes. Contains dates when the bike was bought and decommissioned, an optional link, color for the charts, and also an auditing column for when a row was created. |
| milages | Stores milages for a bike (when and how much). |
| tracks | Stores GPS tracks recorded and uploaded with an optional description. For each day the track names must be unique. The columns `minlat`, `minlon`, `maxlat` and `maxlon` store the encapsulating rectangle for the track. The `type` column is constrained to "biking" and "running". |
| assorted_trips | Stores a date and a distance on that day. Multiple distances per day are allowed. |
| locations | Stores arbitrary locations (latitude/longitude based) for a given timestamp, with an optional description. |
| biking_pictures | Stores pictures collected from _Daily Fratze_ together with their original date of publication, their unique external id, and a link to the page the picture originally appeared on. |
| gallery_pictures | Stores all pictures uploaded by the user, with a description and the date the picture was taken. The `filename` column contains a single, computed filename without path information. |

Those tables are mapped to the following domain model:

![Domain model](../images/8_1-domain-model.png)

| Name | Description |
|---|---|
| BikeEntity | A bike was bought on a given date and can be decommissioned. It has a color and an optional link to an arbitrary website. It may or may not have milages recorded. See its important business methods below. |
| MilageEntity | A milage is part of a bike. For each bike, one milage per month can be recorded. The milage is the combination of its recording date, the amount and the bike. |
| TrackEntity | The representation of _tracks_ contents. The type is an enumeration. Notable public operations are `getPrettyId` (computes a "pretty" id based on the instance's id) and `getTrackFile` (generates a reference to the GPS track file in the passed data storage directory). |
| BikingPictureEntity | For handling pictures collected from _Daily Fratze_. Parses the image link on construction and retrieves the unique, external id. |
| GalleryPictureEntity | A bean for handling the pictures uploaded by the user. `prePersist` fills the `createdAt` attribute prior to inserting into the database. |
| AssortedTripEntity | Captures a distance covered on a certain date; can be used for keeping track of trips with bikes not stored in this application, for example. |
| LocationEntity | Used in the tracker module for working with real time locations. |

**Important business methods on BikeEntity**

| Name | Description |
|---|---|
| `decommission` | Decommissions a bike on a given date. |
| `addMilage` | Adds a new milage for a given date and returns it. Only added if the date is after the date the last milage was added, and the amount is greater than the last milage. |
| `getPeriods` | Gets all monthly periods in which milages have been recorded. |
| `getMilage` | Gets the total milage of this bike. |
| `getLastMilage` | Gets the last milage recorded. In most cases the same as `getMilage`. |
| `getMilageInPeriod` | Gets the milage in a given period. |
| `getMilagesInYear` | Gets all milages in a year as an array (of months). |
| `getMilageInYear` | Gets the total milage in a given year. |

## Persistency

_biking2_ uses an [H2](https://www.h2database.com/html/main.html) database for storing relational data, and the file system for binary image files and large ASCII files (especially all GPS files).

During development and production the H2 database is retained and not in-memory based. The location of this file is configured through the `biking2.database-file` property, and its default value during development is `./var/dev/db/biking-dev`, relative to the working directory of the VM.

All access to the database goes through JPA using Hibernate as the provider. See the [domain models](#domain-models) above for all entities used in the application.

The JPA `EntityManager` isn't accessed directly, but only through the facilities offered by Spring Data JPA — that is, through repositories only.

All data stored as files is stored relative to `biking2.datastore-base-directory`, which defaults to `./var/dev`. Inside are 3 directories:

- `bikingPictures`: contains all pictures collected from _Daily Fratze_
- `galleryPictures`: contains all uploaded pictures
- `tracks`: contains uploaded GPS data and the result of converting TCX files into GPX files

## User Interface

The default user interface for _biking2_, packaged within the final artifact, is a single page application written in JavaScript using AngularJS together with a very default Bootstrap template.

For using the real time location update interface, choose one of the many MQTT clients out there.

There is a second user interface written in Java, called [bikingFX](https://info.michael-simons.eu/2014/10/22/getting-started-with-javafx-8-developing-a-rest-client-application-from-scratch/).

## JavaScript and CSS optimization

JavaScript and CSS dependencies are managed through Maven dependencies in the form of [webjars](https://www.webjars.org) wherever possible, without the need for brew, npm, bower and the like.

Furthermore _biking2_ uses [wro4j](https://alexo.github.io/wro4j/), together with a small [Spring Boot Starter](https://github.com/michael-simons/wro4j-spring-boot-starter), to optimize JavaScript and CSS web resources.

wro4j provides a model like this:

```xml
<groups xmlns="http://www.isdc.ro/wro">
  <!-- Dependencies for the full site -->
  <group name="biking2">
    <group-ref>osm</group-ref>

    <css minimize="false">/webjars/bootstrap/@bootstrap.version@/css/bootstrap.min.css</css>
    <css>/css/icons.css</css>
    <css>/css/stylesheet.css</css>

    <js minimize="false">/webjars/jquery/@jquery.version@/jquery.min.js</js>
    <js minimize="false">/webjars/bootstrap/@bootstrap.version@/js/bootstrap.min.js</js>
    <js minimize="false">/webjars/momentjs/@momentjs.version@/min/moment-with-locales.min.js</js>
    <js minimize="false">/webjars/angular-file-upload/@angular-file-upload.version@/angular-file-upload-html5-shim.min.js</js>
    <js minimize="false">/webjars/angularjs/@angularjs.version@/angular.min.js</js>
    <js minimize="false">/webjars/angularjs/@angularjs.version@/angular-route.min.js</js>
    <js minimize="false">/webjars/angularjs/@angularjs.version@/angular-sanitize.min.js</js>
    <js minimize="false">/webjars/angular-file-upload/@angular-file-upload.version@/angular-file-upload.min.js</js>
    <js minimize="false">/webjars/angular-ui-bootstrap/@angular-ui-bootstrap.version@/ui-bootstrap.min.js</js>
    <js minimize="false">/webjars/angular-ui-bootstrap/@angular-ui-bootstrap.version@/ui-bootstrap-tpls.min.js</js>
    <js minimize="false">/webjars/highcharts/@highcharts.version@/highcharts.js</js>
    <js minimize="false">/webjars/highcharts/@highcharts.version@/highcharts-more.js</js>
    <js minimize="false">/webjars/sockjs-client/@sockjs-client.version@/sockjs.min.js</js>
    <js minimize="false">/webjars/stomp-websocket/@stomp-websocket.version@/stomp.min.js</js>

    <js>/js/ansi_up.js</js>
    <js>/js/app.js</js>
    <js>/js/controllers.js</js>
    <js>/js/directives.js</js>
  </group>
</groups>
```

This model file is filtered by the Maven build; version placeholders are replaced, and all resources — in webjars as well as inside the filesystem — become available as `biking.css` and `biking.js`.

How those files are optimized, minimized or otherwise processed is up to wro4j's configuration, but minification can be turned off during development.

## Transaction Processing

_biking2_ relies on Spring Boot to create all necessary beans for handling local transactions within the JPA `EntityManager`. _biking2_ does not support distributed transactions.

## Session Handling

_biking2_ only provides a stateless public API; there is no session handling.

## Security

_biking2_ secures its API endpoints only via [HTTP basic access authentication](https://en.wikipedia.org/wiki/Basic_access_authentication), and, in the case of the MQTT module, with MQTT's default security model. Security can be increased by running the application behind an SSL proxy, or by configuring SSL support in the embedded Tomcat container.

For the kind of data managed here, it's an agreed tradeoff to keep the application simple. See also [Safety](#safety).

## Safety

No part of the system has a life-endangering aspect.

## Communications and Integration

_biking2_ uses an internal Apache ActiveMQ broker on the same VM as the application, for providing STOMP channels and an MQTT transport. This broker is volatile — messages are not persisted across application restarts.

## Plausibility and Validity Checks

Datatypes and ranges are checked via [JSR-303](https://beanvalidation.org/1.0/spec/) annotations on classes representing the [domain models](#domain-models). Those classes are directly bound to external REST interfaces.

There are three important business checks:

1. Bikes which have been decommissioned cannot be modified (i.e. they can have no new milages): checked in `BikesController`.
2. For each unique month, only one milage can be added to a bike. Checked in `BikeEntity`.
3. A new milage must be greater than the last one. Also checked inside `BikeEntity`.

## Exception/Error Handling

Errors due to inconsistent data (with regard to the data models' constraints), as well as failures of [plausibility and validity checks](#plausibility-and-validity-checks), are mapped to HTTP errors. Those errors are handled by the frontend's controller code. Technical errors (hardware, database etc.) are not handled and may lead to application failure or lost data.

## Logging, Tracing

Spring Boot configures logging to standard out by default. The default [configuration](#configurability) isn't changed in that regard, so all framework logging (especially Spring and Hibernate) goes to standard out in standard format, and can be grabbed or ignored via OS specific means.

All business components use the Simple Logging Facade for Java (SLF4J). The actual configuration of logging is done through Spring Boot's means; no special implementation is included manually — instead _biking2_ depends transitively on `spring-boot-starter-logging`.

The name of each logger corresponds to the package name of the class instantiating it, so the modules are immediately recognizable in the logs.

## Configurability

Spring Boot offers a plethora of configuration options; those are just the main options to configure Spring Boot and the available starters: [Common application properties](https://docs.spring.io/spring-boot/docs/current/reference/html/common-application-properties.html).

The default configuration is available in `src/main/resources/application.properties`. During development, those properties are merged with `src/main/resources/application-dev.properties`. Additional properties can be added through the system environment, or through an `application-*.properties` file in the current JVM directory.

During tests an additional `application-test.properties` can be used to add or overwrite additional properties or values.

**biking2 specific configuration properties**

| Property | Default | Description |
|---|---|---|
| `biking2.color-of-cumulative-graph` | `000000` | Color of the cumulative line graph |
| `biking2.dailyfratze-access-token` | n/a | An OAuth access token for _Daily Fratze_ |
| `biking2.datastore-base-directory` | `${user.dir}/var/dev` | Directory for storing files (tracks and images) |
| `biking2.fetch-biking-picture-cron` | `0 0 */8 * * *` | A cron expression for configuring the `FetchBikingPicturesJob` |
| `biking2.home.longitude` | `6.179489185520004` | Longitude of the home coordinate |
| `biking2.home.latitude` | `50.75144902272457` | Latitude of the home coordinate |
| `biking2.connector.proxyName` | n/a | The name of a proxy, if _biking2_ runs behind one |
| `biking2.connector.proxyPort` | `80` | The port of a proxy, if _biking2_ runs behind one |
| `biking2.gpsBabel` | `/opt/local/bin/gpsbabel` | Fully qualified path to the _GPSBabel_ binary |
| `biking2.scheduled-thread-pool-size` | `10` | Thread pool size for the job pool |
| `biking2.tracker.host` | `localhost` | The host on which the tracker (MQTT channel) should listen |
| `biking2.tracker.stompPort` | `2307` | STOMP port |
| `biking2.tracker.mqttPort` | `4711` | MQTT port |
| `biking2.tracker.username` | `${security.user.name}` | Username for the MQTT channel |
| `biking2.tracker.password` | `${security.user.password}` | Password for the MQTT channel |
| `biking2.tracker.device` | `iPhone` | Name of the OwnTracks device |

## Internationalization

The only supported language is English. There is no hook for internationalization in the frontend, and there are no plans to create one.

## Migration

_biking2_ replaced a Ruby application based on the Sinatra framework. Data was stored in a SQLite database, which was migrated by hand to the H2 database.

## Testability

The project contains JUnit tests in the standard location of a Maven project. At the time of writing, those tests cover more than 95% of the code. Tests must be executed during the build and should not be skipped.

## Build Management

The application can be built with Maven without external dependencies outside Maven. `gpsbabel` must be on the path to run all tests, though.
