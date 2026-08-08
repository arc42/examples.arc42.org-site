---
title: Deployment View
order: 7
---

![Deployment](../images/7-deployment.png)

| Node / artifact | Description |
|---|---|
| biking2 development | Where _biking2_ development takes place: a standard computer with JDK 8, Maven and GPSBabel installed. |
| Uberspace host | A host on [Uberspace](https://uberspace.de) where `biking2.jar` runs inside a [Server JRE](http://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html) with restricted memory usage. |
| biking2.jar | A "fat jar" containing all Java dependencies and a loader, so that the jar is runnable either as a jar file or as a service script (on Linux hosts). |
| Browser | A recent browser to access the AngularJS biking2 single page application. All major browsers (Chrome, Firefox, Safari, IE / Edge) should work. |
