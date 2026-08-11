---
layout: system

permalink: /systems/biking/

title: biking2
tagline: Self-hosted bike-mileage and GPS-track tracker, Spring Boot on Java 8.

domain: Personal / fitness tracking

main_goal: >-
  Stay simple enough to double as a learning project for Java 8, Spring Boot
  and AngularJS, while still being a real system one person runs in production.

decisions:
  - Spring Boot single "fat jar" deployment
  - Constructor injection only
  - AngularJS single-page app bundled in the same artifact
  - MQTT (via ActiveMQ) for near real-time tracking

technologies:
  - Java
  - Spring Boot
  - AngularJS
  - MQTT

scale: Single maintainer · personal project · in production since 2014

order: 30

# Provenance. Permission to republish confirmed directly by Michael Simons,
# the original author, 2026-08-08. The biking2 source code is Apache-2.0, but
# that licence governs the software, not this prose — CC BY-SA 4.0 here
# follows the same convention used for the other imported examples on this
# site.
attribution: Michael Simons
licence: CC BY-SA 4.0
licence_url: https://creativecommons.org/licenses/by-sa/4.0/
source_url: https://github.com/michael-simons/biking2/tree/public/src/docs
imported: 2026-08
---

[biking2](https://biking.michael-simons.eu) tracks Michael Simons' bikes and
their mileage, converts Garmin TCX tracks to GPX, and visualizes both tracks
and ride pictures — built as a running exercise in Spring Boot, Java 8 and
AngularJS.

The documentation is written directly in arc42's AsciiDoc template, in
English, with the naming and structure enforced by jQAssistant — worth
comparing against the other examples here for how closely a real,
single-maintainer project can stick to the template's letter.
