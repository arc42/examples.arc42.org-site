---
title: Building Block View
order: 5
---

The whitebox of the subsystem Analysis shows the six services, PostgreSQL, Kafka, the provided and required interfaces and the six REST edges protected by circuit breakers; the legend gives the colour coding (yellow = process-local runtime state, green = message channel, grey = stateless) and the origin of the technologies (OSS / in-house).

![Building block view level 2: whitebox subsystem Analysis with interfaces, circuit breaker edges and colour legend](../images/building-block-view-level2.png)

## Whitebox Analysis Subsystem

| Building block | Responsibility | Dependencies |
|---|---|---|
| Coordinator | Config check, `runId`, anchor start, retry entry point, simulation proxy, run projection, overall, SSE | Config service, Fluids, Kafka; for simulation all algorithm services |
| Config service | CRUD and persistence of the engine configurations | PostgreSQL |
| Fluids | Analysis of Oil, Fuel and Cooling System; start of Drivetrain and Mechanical | Drivetrain, Mechanical, Kafka |
| Drivetrain | Analysis of Power Transmission and Gearbox Options; completion report to EMS | EMS, Kafka |
| Mechanical | Analysis of Starting System, Auxiliary PTO, Mounting and Exhaust System; completion report to EMS | EMS, Kafka |
| EMS | Fan-in of Drivetrain and Mechanical; analysis of Engine Management and Monitoring/Control System; invalidation of outdated attempts | Kafka |

Each interface of the diagram is exactly one contract in `analysis/libs/shared/src/contracts/` (§8.6). The provider implements it with `implements`, the consumer knows only the contract and receives the implementation via an injection token.

| Interface (diagram) | Contract (`@shared/contracts`) | Provided (code) | Required (code, injection token) | OpenAPI |
|---|---|---|---|---|
| IAnalyze | `analyze.ts`: `IAnalyze` | `FluidsController`, `DrivetrainController`, `MechanicalController`, `EmsController` (`POST /analyze`) | Coordinator `FluidsClient` → `FLUIDS_ANALYZE`; Fluids `DrivetrainClient` → `DRIVETRAIN_ANALYZE`, `MechanicalClient` → `MECHANICAL_ANALYZE`; Drivetrain and Mechanical `EmsClient` → `EMS_ANALYZE` | `api/{fluids,drivetrain,mechanical,ems}.openapi.json` |
| IConfig | `config.ts`: `IConfig`, subset `IConfigLookup` | `ConfigController` (`/configs`) | React UI (CRUD); Coordinator `ConfigClient` → `CONFIG_LOOKUP` (only `getConfig`) | `api/config.openapi.json` |
| ISimulation | `simulation.ts`: `ISimulation`, `ISimulationClient` | `SimulationController` in `@shared` (`/simulation/status|down|up`) | Coordinator `SimulationClient` → `SIMULATION_CLIENT` | `api/{fluids,drivetrain,mechanical,ems}.openapi.json` |
| IAnalysis | `analysis.ts`: `IAnalysis` | Coordinator `AnalysisController` (`POST /analysis/start`, `POST /analysis/:runId/retry/:cluster`) | React UI | `api/coordinator.openapi.json` |
| IStream | `analysis.ts`: `IStream` | `AnalysisController.stream` (SSE `/analysis/:runId/stream`) | React UI | `api/coordinator.openapi.json` |
| ISimulationProxy | `analysis.ts`: `ISimulationProxy` | Coordinator `SimulationController` (`/simulation/statuses`, `/simulation/:cluster/down|up`) | React UI | `api/coordinator.openapi.json` |
| IStatusEvents | `events.ts`: `IStatusEvents`; publisher `IEventPublisher` | `EventController.onStatusEvent` (Coordinator, EMS) | `emitStatus` via `EVENT_PUBLISHER` (`KafkaClient`) in all algorithm services, breaker fallbacks, `ClusterGateway` | – (topic contract `TopicContracts`) |
| IResultEvents | `events.ts`: `IResultEvents`; publisher `IEventPublisher` | `EventController.onResultEvent` (Coordinator) | `emitResult` via `EVENT_PUBLISHER` in Fluids, Drivetrain, Mechanical, EMS | – (topic contract `TopicContracts`) |
| IRetryCommands | `events.ts`: `IRetryCommands`; publisher `IEventPublisher` | `EventController.onRetryEvent` (Fluids, Drivetrain, Mechanical, EMS) | `emitRetry` via `EVENT_PUBLISHER` in the Coordinator (`ClusterGateway.retry`) | – (topic contract `TopicContracts`) |
