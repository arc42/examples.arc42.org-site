---
title: Context and Scope
order: 3
---

## Business Context

The PoC implements the bounded context *Analysis* of the company's target architecture. It is in a partnership with *Manufacturing* and is separated from SAP ERP and CRM by an anti-corruption layer. The context view shows the subsystem as a blackbox; chapter 5 opens it into six building blocks, and `IAnalysis` corresponds to the coordinator endpoint.

![Context view: subsystem Analysis as a blackbox with user, React UI and neighbouring contexts](../images/context-view.png)

## Technical Context

The UI uses three REST interfaces: the config service (`GET/POST /configs`, `GET/PUT /configs/:id`), the coordinator (`POST /analysis/start`, `POST /analysis/:runId/retry/:cluster`) and its simulation proxy (`GET /simulation/statuses`, `POST /simulation/:cluster/up|down`); status, result and overall flow back as SSE via `GET /analysis/:runId/stream`. Between the services, `POST /analyze` with `AnalyzeRequest = { runId, source? }` represents the transitions of the choreography; `source` is only permitted for EMS and restricted there to Drivetrain or Mechanical. Kafka carries `analysis-status` (`{ runId, cluster, status }`, consumed by coordinator and EMS), `analysis-result` (`{ runId, cluster, results[] }`, by the coordinator) and `analysis-retry` (`{ runId, cluster }`, to the algorithm services) – each consumer with its own consumer group.
