---
title: Architecture Constraints
order: 2
---

The backend consists of six NestJS 11 applications in TypeScript on Node.js 20 in containers, the frontend of React 18, Vite 5 and Material UI 5. Persistence and messaging are provided by PostgreSQL 16 with TypeORM (`synchronize: true`) and Apache Kafka 3.9.1 via the NestJS Kafka transport. Resilience is handled by the Opossum circuit breaker with 5 s timeout, 50 % error threshold and 10 s reset time without a set `volumeThreshold` (default 0), so that the first failure already opens the breaker. Delivery is via Docker Compose.
