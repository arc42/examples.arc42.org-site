---
title: Cross-cutting Concepts
order: 8
---

## 8.1 Persistence

Data storage in the new system is handled by a Java framework based on J2EE —
more precisely, on bean-managed persistence. The mapping of the object structure
onto the relational database is taken over completely by the framework.

For the migration components themselves, persistence thereby becomes almost
transparent: once an object graph has been built up in memory, it can be stored
in one go.

### Persistence of Intermediate Formats and Error Cases

The input data, in sequential VSAM format, is written directly into the migration
database via SQL. All error records likewise reach the error database via SQL.

## 8.2 Process Control

The coordination and control of all migration processes is carried out by one
central building block, the `MigrationController`.

All processing is record by record. The person file is processed record by
record, all the associated account information is assigned to those records, and
the resulting data packages are then migrated together.

For cost reasons, no commercial workflow engine should be used.

## 8.3 Exception and Error Handling

Because of the client's high correctness requirements, all exceptions — that is,
all records that cannot be migrated — are stored in an error table.

After the migration, every error record has to be migrated manually by clerks,
and only about 200 person-days of effort are available for this. A clerk can
migrate 25 persons per day on average, so the error table may contain at most
5,000 records.[^arithmetic]

[^arithmetic]: The original text gives this as "5000 (= 20 * 25)". With 200 person-days at 25 persons per day the figure would be 5,000 = 200 × 25; the "20" appears to be a typo in the source. The limit of 5,000 records is what matters.
