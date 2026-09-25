---
title: Quality Requirements
order: 10
---

![Quality tree: Performance Efficiency, Reliability and Maintainability refined into the quality goals of the PoC](../images/quality-tree.png)

| ID | Stimulus | System response | Measure |
|---|---|---|---|
| QS-1 | UI starts analysis | `runId` returned, algorithms run in the background | response time < 500 ms |
| QS-2 | Drivetrain is `down` | Fluids CB opens and publishes `failed` for Drivetrain; Mechanical continues; EMS `failed` | ≤ 5 s until status, no blocking |
| QS-3 | Retry Drivetrain after `up` | Only Drivetrain and EMS run again, the other results remain | projection resets exactly 2 clusters |
| QS-4 | Kafka unreachable at start | Services do not start (`depends_on`), no inconsistent state | known limitation, see §11 |
