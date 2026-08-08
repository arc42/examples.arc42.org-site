---
title: Building Block View
order: 5
---

The application, packaged as `biking2.jar`, contains two (the api and the spa) of the three main parts shown in the [business context](../03-context-and-scope/):

![Level 0](../images/5_0-level0.png)

From those two, we take a closer look at the api only. For details regarding the structure of an AngularJS 1.2.x application, have a look at their [developer's guide](https://code.angularjs.org/1.2.28/docs/guide).

> To comply with the Java coding style guidelines, the modules "bikingPictures" and "galleryPictures" reside in the Java packages `bikingpictures` and `gallerypictures`.

## Whitebox biking2::api

The following diagram shows the main building blocks of the system and their interdependencies:

![Level 1 — biking2::api](../images/5_1-level1-biking-api.png)

Functional decomposition was used to separate responsibilities. The individual parts of the api are all encapsulated in their own components, represented as Java packages.

All components depend on a standard JPA `EntityManager`, and some on local file storage — those blackboxes aren't detailed further here.

**Contained blackboxes:**

| Building block | Description |
|---|---|
| bikes | Managing bikes, adding monthly milages, computing statistics and generating charts. |
| tracks | Uploading tracks (TCX files), converting to GPX, providing an oEmbed interface. |
| trips | Managing assorted trips. |
| locations | MQTT and STOMP interface for creating new locations and providing them in real time on websockets via STOMP. |
| bikingPictures | Reading biking pictures from an RSS feed provided by _Daily Fratze_ and providing an API to them. |
| galleryPictures | Uploading and managing arbitrary pictures. |
| statistics | Provides an API for statistics. |

**Interfaces:**

| Interface | Description |
|---|---|
| bikes API | REST API containing methods for reading, adding and decommissioning bikes, and for adding milages to single bikes. |
| charts | Methods for retrieving statistics as fully set up chart definitions. |
| tracks API | REST API for uploading and reading TCX files. |
| trips API | REST API for adding new trips. |
| oEmbed | HTTP based oEmbed interface, generating URLs with embeddable content. |
| Real time locations | WebSocket / STOMP based interface on which new locations are published. |
| Real time location updates | MQTT interface to which MQTT compatible systems like [OwnTracks](http://owntracks.org) can offer location updates. |
| RSS feed reader | Needs a _Daily Fratze_ OAuth token for accessing an RSS feed containing biking pictures, which are then grabbed from _Daily Fratze_. |
| galleryPictures API | REST API for uploading and reading arbitrary image files (pictures related to biking). |

### bikes (Blackbox)

**Intent/Responsibility:** `bikes` provides the external API for reading, creating and manipulating bikes and their milages, as well as computing statistics and generating charts.

**Interfaces:**

| Interface | Description |
|---|---|
| REST interface `/api/bikes/*` | Contains all methods for manipulating bikes and their milages. |
| REST interface `/api/charts/*` | Contains all methods for generating charts. |

**Files:** the `bikes` module and all of its dependencies are contained inside the Java package `ac.simons.biking2.bikes`.

### tracks (Blackbox)

**Intent/Responsibility:** `tracks` manages file uploads (TCX files), converts them to GPX files and computes their surrounding rectangle (envelope) using GPSBabel. It also provides the oEmbed interface that resolves URLs to embeddable tracks.

**Interfaces:**

| Interface | Description |
|---|---|
| REST interface `/api/tracks/*` | Contains all methods for manipulating tracks. |
| `/api/oembed` | Resolves track URLs to embeddable tracks (content). |
| `/tracks/*` | Embeddable track content. |

**Files:** the `tracks` module and all of its dependencies are contained inside the Java package `ac.simons.biking2.tracks`.

### trips (Blackbox)

**Intent/Responsibility:** `trips` manages distances that have been covered on single days without relationships to bikes.

**Interfaces:**

| Interface | Description |
|---|---|
| REST interface `/api/trips/*` | Contains all methods for manipulating trips. |

**Files:** the `trips` module and all of its dependencies are contained inside the Java package `ac.simons.biking2.trips`.

### locations (Blackbox)

**Intent/Responsibility:** `locations` stores locations with timestamps in near real time and provides access to locations from the last 30 minutes.

**Interfaces:**

| Interface | Description |
|---|---|
| REST interface `/api/locations/*` | For retrieving all locations from the last 30 minutes. |
| WebSocket / STOMP topic `/topic/currentLocation` | Interface for getting notification of new locations. |
| MQTT interface | Listens for new locations coming in via MQTT, in [OwnTracks format](http://owntracks.org/booklet/tech/json/). |

**Files:** the `locations` module and all of its dependencies are contained inside the Java package `ac.simons.biking2.tracker`. The module is configured through `ac.simons.biking2.config.TrackerConfig`.

### bikingPictures (Blackbox)

**Intent/Responsibility:** `bikingPictures` is used for regularly checking an RSS feed from Daily Fratze, collecting new images and storing them locally. It also provides an API for getting all collected images.

**Interfaces:**

| Interface | Description |
|---|---|
| RSS feed reader | Provides access to the _Daily Fratze_ RSS feed. |
| Image reader | Provides access to images hosted on _Daily Fratze_. |
| REST interface `/api/bikingPictures/*` | Contains all methods for accessing biking pictures. |

**Files:** the `bikingPictures` module and all of its dependencies are contained inside the Java package `ac.simons.biking2.bikingpictures`.

### galleryPictures (Blackbox)

**Intent/Responsibility:** `galleryPictures` manages file uploads (images). It stores them locally and provides an RSS interface for getting metadata and image data.

**Interfaces:**

| Interface | Description |
|---|---|
| REST interface `/api/galleryPictures/*` | Contains all methods for adding and reading arbitrary pictures. |

### statistics (Blackbox)

**Intent/Responsibility:** module for computing statistics, generating charts and providing version and summary information.

**Interfaces:**

| Interface | Description |
|---|---|
| REST interface `/api/charts/*` | Contains all methods for generating [Highcharts](https://www.highcharts.com/) charts. |
| REST interface `/api/summary/*` | Aggregated values. |

**Files:** the `statistics` module and all of its dependencies are contained inside the Java package `ac.simons.biking2.statistics`.

## Building Blocks — Level 2

### bikes (Whitebox)

![bikes, level 2](../images/5_2-level2-bikes.png)

The `BikeRepository` is a Spring Data JPA based repository for `BikeEntities`. The `BikeController` and the `ChartsController` access it to retrieve and store instances of `BikeEntity`, and provide external interfaces.

**Contained blackboxes:**

| Building block | Description |
|---|---|
| highcharts | Contains logic for generating configurations and definitions for [Highcharts](http://www.highcharts.com) on the server side. |

### tracks (Whitebox)

![tracks, level 2](../images/5_2-level2-tracks.png)

The `TrackRepository` is a Spring Data JPA based repository for `TrackEntities`. The `TracksController` and the `OembedController` access it to retrieve and store instances of `TrackEntity`, and provide external interfaces.

**Contained blackboxes:**

| Building block | Description |
|---|---|
| gpx | Generated JAXB classes for parsing GPX files. Used by the `TracksController` to retrieve the surrounding rectangle (envelope) for new tracks. |

### trips (Whitebox)

![trips, level 2](../images/5_2-level2-trips.png)

The `AssortedTripRepository` is a Spring Data JPA based repository for `AssortedTripEntities`. The `TripsController` accesses it to retrieve and store instances of `AssortedTripEntity`, and provide external interfaces.

### locations (Whitebox)

![locations, level 2](../images/5_2-level2-locations.png)

Locations are stored and read via a Spring Data JPA based repository named `LocationRepository`. This repository is only accessed through the `LocationService`. The `LocationService` provides real time updates for connected clients through a `SimpMessagingTemplate`, and the `LocationController` uses the service to provide access to all locations created within the last 30 minutes.

New locations are created by the service either through a REST interface in the form of the `LocationController`, or via a `MessageListener` on an MQTT channel.

### bikingPictures (Whitebox)

![bikingPictures, level 2](../images/5_2-level2-bikingPictures.png)

A Spring Data JPA repository named `BikingPicturesRepository` is used for all access to `BikingPictureEntities`; the external REST API for reading pictures is implemented with `BikingPicturesController`. The RSS feed is read by `FetchBikingPicturesJob` using a JAXB context "rss". The URLs to the image files, which may be protected by various means, are provided to the job via a `DailyFratzeProvider`.

**Contained blackboxes:**

| Building block | Description |
|---|---|
| rss | Generated JAXB classes for parsing RSS feeds. Used by the `FetchBikingPicturesJob` to read the contents of an RSS feed. |

### galleryPictures (Whitebox)

![galleryPictures, level 2](../images/5_2-level2-galleryPictures.png)

The `GalleryPictureRepository` is a Spring Data JPA based repository for `GalleryPictureEntities`. The `GalleryController` accesses it to retrieve and store instances of `GalleryPictureEntity`, and provide external interfaces.

### statistics (Whitebox)

The `StatisticService` is a database centric service that uses an instance of jOOQ's `DSLContext` for creating SQL. That SQL is not generated SQL, but handcrafted — jOOQ is used only to do this in a type-safe way.

During the build, jOOQ reads a temporary database, created from SQL based migration scripts, and generates several Java classes reassembling a schema. Those classes, along with the DSL, are used to write SQL.

The statements make heavy use of analytic functions. This is necessary because the original decision for storing milages was to not store the amount biked each month, but the accumulated milage on a bike — so the monthly values need to be computed. This is done with queries like the following:

```sql
-- Query that provides the statistics for the current year
WITH mm AS (
  SELECT
    bikes.name,
    bikes.color,
    milages.recorded_on,
    (lead(milages.amount) OVER (PARTITION BY bikes.id ORDER BY milages.recorded_on) - milages.amount) value
  FROM bikes
    JOIN milages
      ON milages.bike_id = bikes.id
  ORDER BY milages.recorded_on ASC
)
SELECT
  mm.name,
  mm.color,
  (EXTRACT(MONTH FROM mm.recorded_on) - 1) idx,
  mm.value,
  sum(mm.value) OVER (PARTITION BY mm.recorded_on) total
FROM mm
WHERE (
  mm.value IS NOT NULL
  AND EXTRACT(YEAR FROM mm.recorded_on) >= EXTRACT(YEAR FROM DATE '2019-01-01')
)
ORDER BY mm.name ASC
```
