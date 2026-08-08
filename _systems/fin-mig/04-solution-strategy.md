---
title: Solution Strategy
order: 4
---

Migration in batch, built on three core concepts:

* A **pipes-and-filters** processing chain with a relational database acting as
  the pipe. *(Quality goal: performance.)*
* **Parallelization** of the compute-intensive business migration.
  *(Quality goal: performance.)*
* **Error sensors** in every processing step, collecting every detected error in
  an error database. *(Quality goal: correctness.)*
