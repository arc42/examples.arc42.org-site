---
title: Solution Strategy
order: 4
---

At the core of _biking2_ is a simple yet powerful domain model based on a few entities, of which a "Bike" and its "Milage" are the most important.

Although data centric, the application resigns from using too much SQL for creating reports, summaries and such, but tries to achieve that with Java 8 features around streams, lambdas and map/reduce functions.

Building the application with Spring Boot was an obvious choice, as one of the main [quality goals](../01-introduction-and-goals/) is learning about it. But furthermore, using Spring Boot as a "framework" for the Spring Framework allows concentration on the business logic. On the one hand there is no need to understand a complex XML configuration, and on the other hand all building blocks are still put together using dependency injection.

Regarding dependency injection and testability: all injection is done via constructor injection, setter injection is only allowed when there's no other technical way. This way, units under test can only be correctly instantiated. Otherwise one tends to forget collaborators, or even worse: 20 injected attributes may not hurt, but a constructor with 20 parameters will. This hopefully prevents centralized "god classes" that control pretty much every other aspect of the application.

Spring Boot applications can be packaged as single, "fat jar" files. Since Spring Boot 1.3, those files contain a startup script and can be directly linked to `/etc/init.d` on a standard Linux system, which serves constraint [TC4](../02-architecture-constraints/).

Interoperability is achieved by using JSON over plain http for the main API. Security is not the main focus of this application. It should be secure enough to prevent others from tampering with the data; confidentiality is not a main concern (read: passwords can be transmitted in plain text over http).

The internal single page application is implemented using AngularJS. The deployable artifact contains this application, so there is no need for hosting a second webserver for the static files.

For real time tracking, the MQTT protocol is used, which is part of Apache ActiveMQ, supported out of the box by Spring Messaging.

Graphing is not implemented from scratch; instead the [Highcharts](http://www.highcharts.com) library is used. The configuration for all charts is computed server side.

> The original installment of this project used Java 8 streams and the streams API heavily to compute statistics (everything under `biking.michael-simons.eu/milages`). Back in 2014 and 2015, when Java 8 was new, it helped a lot to learn that API. Nearly 5 years later, thinking about my history with databases and looking at a ton of talks about SQL I've given, I decided it was time to go back to my roots. All the charts are now created with a dedicated statistics service, based on jOOQ and type-safe SQL.
