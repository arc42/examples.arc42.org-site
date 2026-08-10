---
title: Crosscutting Concepts
order: 8
---

## 8.1 Domain Entity Model

![Fig. 8.1: Domain Entity Model](../images/08_1-domain-entity-model.jpg)

| Term | Definition |
|---|---|
| Frame Interval | the smallest period for data sampled by the TPU. It corresponds to the duration of one video frame, which is 40 milliseconds for a frequency of 25 video frames per second. |
| Distance Per Frame | the distance (in millimeters) travelled during one frame |
| Distance Per Second | the distance (in millimeters) travelled during one second |
| Pursuit Step | the measured and calculated data for one second within a pursuit. It consists of pursuit duration, distance, current speed, current maximum violation. |
| Pursuit Step File | a file containing all pursuit steps |
| Pursuit File | a file containing the video, the pursuit step file and the printout for one pursuit |
| Pursuit Protocol | second-by-second logging of the driven speed + pursuit summary |
| Sector | a part of a complete pursuit |
| Video Frame | one picture within a video stream. Usually we have 25 frames per second. |

## 8.2 Event Handling

### Motivation

In a system with several components generating a variety of events, that should
be handled by appropriate event handlers, we face the following problems:

1. In a robust and flexible architecture, components that generate events should
   be kept free of any knowledge about the handling of these events (separation
   of concerns). So they are not able to deliver the events they produce to the
   right destinations. An appropriate event propagation concept is needed.
2. An event handler in general does not want to be prepared to handle a newly
   arriving event while just handling one event. Especially if the handling of
   the current event may result in a change of state leading to a different
   handling of successive events.

Within the TPU many different events are generated, partly as a result of
measurements on a periodic time base and partly asynchronously like user input
or special system events (e.g. disk space warning). These events are generated
from different building blocks and are managed in a central event queue for
sequential delivery on one single thread. On that thread the events are
delivered to event handlers, which are organized in a stack. The first queued
event is offered to the topmost event handler on the stack. The handler can
decide to consume it, or return the same or a different event for delivery to
the event handler located on the previous stack position.

### Solution

![Fig. 8.2: Event Handling Scenario](../images/08_2-event-handling.jpg)
