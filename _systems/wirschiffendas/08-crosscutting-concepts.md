---
title: Cross-cutting Concepts
order: 8
---

## Circuit Breaker

The shared Opossum implementation offers the decorator `@CircuitBreaker(name, fallbackMethod)` for the service clients and the factory `createCircuitBreaker(...)` for the `ClusterGateway`, which knows `ConfigClient` and `FluidsClient` only via `IConfigLookup` and `IAnalyze` respectively; the fallback publishes `failed`, but no synthetic results.

## Status Telemetry via Kafka

`KafkaClient` implements `IEventPublisher` and encapsulates the three topics: the algorithm services produce status and results, the coordinator consumes both for its read model, EMS the upstream status.

## Server-Sent Events

`AnalysisService` holds a process-local `ReplaySubject(50)` per `runId` and forwards status, result and overall as SSE; after the overall the UI closes the stream.

## Invalidation of Outdated EMS Runs

Every EMS run has a monotonically increasing `version`: failure or retry of an upstream increments it and invalidates the running attempt, which then discards its result.

## Failure Simulation

`POST /simulation/:cluster/down|up` sets the state of a service whose `/analyze` then responds with 503 – a PoC variant of the Test Harness pattern according to Nygard (chapter 5). In production the trigger is a real failure; the breakers behave the same.

## Interfaces as Contracts (Provided/Required)

The contracts are separated from the components and live in `@shared/contracts`; the rest of the library (`http`, `kafka`, `circuit-breaker`, `simulation`, …) is infrastructure. Required interfaces are injected as an abstraction: services and `ClusterGateway` depend via `@Inject(TOKEN)` on the contract, not on a client class. The `@Module` is the assembler that binds each token to an implementation – tokens instead of abstract classes, because TypeScript interfaces do not exist at runtime and Fluids needs two bindings of the same `IAnalyze`. Provided interfaces are enforced by `implements` on the controller; every service publishes them as OpenAPI 3 under `/api-docs-json` (UI under `/api-docs`), the exported documents are in `docs/api/`. The Kafka topics are typed via `TopicContracts`, so that a message can only be published on its topic. Limitation: the TypeScript contract is bound to language and monorepo (TS-1); only the generated OpenAPI document is independent of the component.
