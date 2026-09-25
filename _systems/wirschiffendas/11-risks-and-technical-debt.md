---
title: Risks and Technical Debt
order: 11
---

| Debt / risk | Justification in the PoC | Countermeasure |
|---|---|---|
| **TS-1** Shared library with domain code (cluster, equipment, DTOs, messages); one Dockerfile for all services [Shared Libraries, IV.B.2] | Contract shared at build time, not at runtime; one team, one release cycle | Contracts in a schema registry; separate `package.json` per service |
| **TS-2** UI calls coordinator and config service directly [No API Gateway, IV.B.3] | Two endpoints in the PoC; a gateway would be a pure proxy | API gateway / BFF, as modelled in the target architecture |
| **TS-3** Logging only to stdout, no central logging, no monitoring [Local Logging, Insufficient Monitoring, IV.B.4] | Outside the PoC scope | Loki/Grafana or ELK; correlation ID = `runId` is available |
| **TS-4** Run projection in memory (`ReplaySubject`), EMS fan-in in `Map` [Horizontal Scalability, IV.A.4] | State is run-local and short-lived (ADR-007) | Projection in Redis; persist EMS state; partitioning by `runId` |
| **TS-5** Caller publishes `failed` for an unreachable target service [Status Ownership, own observation] | Run must become terminal; the target cannot publish anything (ADR-005) | Separate status `unreachable` instead of `failed` |
| **TS-6** Algorithms do not read the configuration; result always `ok` [ADR-004] | Simulation of the flows, not of the business logic | One cluster reads the config and returns `failed` for a combination |
| **TS-7** No API versioning, no CI/CD pipeline [No API Versioning, No CI/CD, IV.B.3] | PoC, one consumer | `/v1/` prefix; GitLab CI with build/test/push per service |
| **TS-8** `TypeORM synchronize: true` [ – ] | PoC | Migrations |
| **TS-9** Read model completes a run only after all expected predecessors have reported; a timeout for missing reports is lacking [ – ] | Call errors are reported by the breaker as `failed`; a silently missing report keeps the run open | Timeout per run in the projection, then `failed` |
| **TS-10** Kafka contracts only as TypeScript types (`TopicContracts`), no AsyncAPI document; no consumer-driven contract tests [ – ] | Producers and consumers in the same monorepo, the compiler checks both sides | AsyncAPI for the three topics; Pact tests for REST and Kafka |
| **R-1** Kafka at-least-once: duplicate status messages possible [ – ] | EMS idempotent via `version`, coordinator via `overallEmitted` | Message key = `runId`, deduplication in the consumer |
| **R-2** Kafka as single point of failure: services do not start without Kafka; on failure status and results are lost [ – ] | deliberate PoC limitation | Replication; outbox pattern; timeout for hanging runs |

## Retrospective

A central API alone does not turn an architecture into orchestration; what matters is whether it knows the flow and the recovery – and the coordinator deliberately does not (ADR-001). Circuit breakers protect automatic calls but do not perform a retry: repetition remains a business decision (ADR-003, ADR-005). What would be done differently is the handling of the contracts – schema registry instead of a shared library (TS-1).

## References

[1] T. Schirgi, E. Brenner, "Quality Assurance for Microservice Architectures", 2021.
