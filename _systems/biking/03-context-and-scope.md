---
title: Context and Scope
order: 3
---

This chapter describes the environment and context of _biking2_: who uses the system, and on which other systems _biking2_ depends.

## Business Context

![Business context](../images/3_1-business-context.png)

**Biker**

A passionate biker uses _biking2_ to manage his bikes, milages, tracks and also visual memories (aka images) taken on tours etc. He also wants to embed his tracks as interactive maps on other websites.

**Daily Fratze**

[Daily Fratze](https://dailyfratze.de) provides a list of images tagged with certain topics. _biking2_ collects all images for a given user tagged with "Theme/Radtour".

**GPSBabel**

GPSBabel is a command line utility for manipulating GPS related files in various ways. _biking2_ uses it to convert TCX into GPX files. The heavy lifting is done by GPSBabel, and the resulting file is managed by _biking2_.

**Arbitrary websites**

The user may want to embed (or brag about) tracks on arbitrary websites. He only wants to paste a link to a track on a website that supports embedded content, to embed a map with the given track.

## Technical Context

![Technical context](../images/3_2-technical-context.png)

_biking2_ is broken into two main components:

**Backend (biking2::api)**

The API runs on a supported application server, using either an embedded container or an external container. It communicates via operating system processes with GPSBabel on the same server.

The connection to _Daily Fratze_ is an http based RSS feed. The feed is paginated and provides all images with a given tag, but older images may no longer be available once the owner decides to add a digital expiry.

Furthermore _biking2_ provides an [oEmbed](http://oembed.com) interface for all tracks stored in the system. Arbitrary websites supporting that protocol can request embeddable content over http knowing only a link to the track, without working against the track or map APIs themselves.

**Frontend (biking2::spa and biking2::bikingFX)**

The frontend is implemented with two different components; `biking2::spa` (a Single Page Application) is part of this package. The SPA runs in any modern web browser and communicates via http with the API.

| Business interface | Channel |
|---|---|
| Format conversions | System processes, command line interface |
| Collection of biking pictures | RSS feed over Internet (http) |
| Embeddable content | oEmbed format over Internet (http) |
| API for business functions | Internet (http) |
