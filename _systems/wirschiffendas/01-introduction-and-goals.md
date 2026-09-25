---
title: Introduction and Goals
order: 1
---

## Requirements Overview

The application is a proof of concept for the analysis of an optional equipment configuration of the yacht engine family "Diesel Engine 2000 M96", distributed across the four algorithm services Fluids, Drivetrain, Mechanical and EMS. A React frontend manages configurations, starts analysis runs, shows status and results and allows the retry of a single algorithm.

| Requirement | Implementation |
|---|---|
| Input of an optional equipment configuration | React dialog for engine model, cylinder variant, gearbox type and the eleven equipment groups |
| Persistent management of configurations | Config service with its own PostgreSQL database via TypeORM; `/configs` creates, reads and updates |
| Analysis button starts an anchor algorithm, the call stays responsive | `POST /analysis/start` checks the configuration, creates the `runId`, starts only Fluids asynchronously and returns immediately |
| Choreographed microservices, sequential and parallel via REST | Fluids starts Drivetrain and Mechanical in parallel, both report to EMS; no central process instance |
| At least four algorithms as independent services | Four clusters by physical assembly groups: Fluids, Drivetrain, Mechanical, EMS |
| EMS builds on previous results | Fan-in: EMS starts only when Drivetrain and Mechanical have been reported ready for the same `runId` |
| Result per equipment and overall result | Each cluster publishes one `EquipmentResult` per equipment group; after the terminal status of all four clusters the coordinator computes `overall` |
| Status `running` / `ready` / `failed` pushed proactively via one endpoint | Kafka topic `analysis-status` feeds the run projection, the coordinator pushes it via SSE |
| Circuit breaker, failure simulation and targeted retry | Opossum on all six REST edges between the services; fault injection via `POST /simulation/:cluster/down|up`; the retry addresses `runId` and cluster and is executed by the service |
| REST endpoints per microservice | `/analyze` per algorithm service, `/configs` in the config service, `/analysis` and `/simulation` in the coordinator, `/health` everywhere |

## Quality Goals

| Priority | Quality goal (ISO 25010) | Scenario | Implementation |
|---|---|---|---|
| 1 | Responsiveness (Time Behaviour) | `POST /analysis/start` responds in < 500 ms with `runId`, independent of the algorithm duration (5–10 s) | asynchronous anchor start, SSE push |
| 2 | Resilience (Fault Tolerance) | Failure of a service leads within ≤ 5 s (CB timeout) to `failed` for this cluster and the dependent EMS, the others continue | circuit breaker at the caller, fallback publishes status |
| 3 | Observability (Analysability) | Every status change is visible in the UI ≤ 1 s after it occurs | Kafka `analysis-status` → coordinator → SSE |

Secondary, but demonstrated, are recoverability via the retry per cluster (QS-3) and modifiability: a new cluster costs one more NestJS application and one entry each in the cluster enum, in `RETRY_PROJECTION_SCOPE` and in Compose.

## Stakeholders

Four roles carry the requirements: management expects a proof of concept for microservices against the position of the engineering department; the engineer expects visible status per algorithm, individual retry and monitoring while components stay responsive; the software architect expects evidence that the analysis component can be decomposed without blocking Manufacturing; operations expects container deployment and health checks (implemented) as well as central logging and monitoring (open, §11).
