---
title: Solution Strategy
order: 4
---

After checking that the configuration exists, the coordinator starts only the anchor Fluids; from then on the choreography continues decentrally via REST: Fluids starts Drivetrain and Mechanical in parallel, both report their completion independently to EMS, which only begins once the fan-in for the same `runId` is complete. All four services publish status and results via Kafka; the coordinator maintains a volatile read model per run from them and transmits changes as SSE. Resilience is local: the caller protects every automatic REST transition with a circuit breaker and publishes a technical call error as `failed` of the target cluster. The retry is decentralised as well – the coordinator only publishes a generic Kafka command. Persistence is separated: only the config service accesses PostgreSQL. The algorithms are simulated: 5, 6, 9 or 10 seconds of waiting time (`ANALYSIS_DURATION_MS`), fixed `ok` results.

**Assessment of the as-is architecture:** The as-is architecture was assessed against all 21 smells and anti-patterns of Schirgi & Brenner [1]. Four shaped this design: Isolation of Failures (circuit breaker locally), Mega Service / Wrong Cut (four business clusters), Shared Persistence (database per service), Hard-Coded Endpoints (Compose DNS instead of IPs). The anti-pattern Shared Libraries is deliberately accepted (TS-1).

## References

[1] T. Schirgi, E. Brenner, "Quality Assurance for Microservice Architectures", 2021.
