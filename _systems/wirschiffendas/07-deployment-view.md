---
title: Deployment View
order: 7
---

![Deployment view: Docker Compose project with eight containers, communication paths and published ports](../images/deployment-view.png)

Docker Compose starts eight containers: the six NestJS applications from the same multi-stage Dockerfile (`node:20` for the build, `node:20-slim` at runtime, `ARG APP`), `apache/kafka:3.9.1` as KRaft broker and `postgres:16` with the volume `wirschiffendas-configdb-data`. Published to the host are 3000 (coordinator), 3001 (config service) and, for development, 9092 (Kafka) and 5432 (PostgreSQL). Every application container has a `healthcheck` on `GET /health`; via `depends_on: service_healthy` the algorithm containers wait for Kafka, the config service for PostgreSQL, the coordinator for Kafka, config service and Fluids. Compose does not build the React UI.
