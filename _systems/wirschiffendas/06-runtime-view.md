---
title: Runtime View
order: 6
---

## Regular Analysis Run

The happy path from the start via the anchor Fluids and the parallel execution of Drivetrain and Mechanical to the fan-in in EMS and the `overall` event takes about 25 s.

![Sequence diagram happy path: coordinator starts the anchor Fluids, Fluids starts Drivetrain and Mechanical in parallel, EMS performs the fan-in](../images/sequence-happy-path.png)

## EMS Fan-in

EMS accepts at `/analyze` only `source = drivetrain` or `source = mechanical` in any order, because a set stores the ready upstreams per `runId`. In addition, EMS consumes `analysis-status`: a `ready` adds to the same set, a `failed` invalidates the attempt, removes the upstream and publishes `failed` for EMS. Execution starts only when the fan-in is complete; multiple reports do not lead to parallel runs because of `Set`, `running` and `completed`.

## Retry

Read-side invalidation in the coordinator (`RETRY_PROJECTION_SCOPE`):

| Retry of | Reset projection |
|---|---|
| Fluids | Fluids, Drivetrain, Mechanical, EMS |
| Drivetrain | Drivetrain, EMS |
| Mechanical | Mechanical, EMS |
| EMS | EMS |

## Unreachable Service and Circuit Breaker

| Call | Circuit breaker | Fallback in code |
|---|---|---|
| Coordinator → Config service | `coordinator->config` | no fallback, but an `errorFilter`: 404 as "Config not found", otherwise "Config service unavailable". |
| Coordinator → Fluids | `coordinator->fluids` | `failFluidsChain` publishes `failed` for Fluids, Drivetrain and Mechanical; EMS follows with its own `failed`. |
| Fluids → Drivetrain | `fluids->drivetrain` | `failed` for Drivetrain. |
| Fluids → Mechanical | `fluids->mechanical` | `failed` for Mechanical. |
| Drivetrain → EMS | `drivetrain->ems` | `failed` for EMS. |
| Mechanical → EMS | `mechanical->ems` | `failed` for EMS. |

The circuit breaker does not repeat the business run: it bounds the REST call and translates unreachability into a technical cluster status. The explicit retry remains separate from it.

![Failure: circuit breaker fluids→drivetrain opens, EMS invalidates](../images/sequence-failure.png)

Failure: circuit breaker fluids→drivetrain opens, EMS invalidates

![Recovery and targeted retry](../images/sequence-retry.png)

Recovery and targeted retry
