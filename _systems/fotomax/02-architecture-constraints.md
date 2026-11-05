---
title: Architecture Constraints
order: 2
---

This chapter describes the constraints and requirements that limit software design, implementation or the development process.

## Organizational Constraints

The company basically has two main products that are customized depending on the business partner in terms of features, workflows and graphical assets (→ [Business Context](../03-context-and-scope/#business-context)).

| **Start of development** | _Wizard:_ 07.2010 _Portal:_ 03.2018 |
| **Team Wizard** | Five members, responsible for the implementation, adaptation and customizing of the software for the end-customer approach on the sales units. |
| **Team Connect** | Four members, responsible for processing, forwarding and accounting of orders. |
| **Team Portal** | Eight members, responsible for the portal solution where customers can view their orders and partners can view their commissions. |
| **Team Data** | Two members, responsible for the analysis and preparation of the accruing data for partners and for product maintenance. |
| **Wizard Installations** | Approx. 250 in different versions |
| **Customers** | Approx. 60 different pitch providers, approx. five different print providers, approx. 12 000 registered end users _(December 2022)_ |

## Technical Constraints

* **Technologies Used:**
  * **Wizard:** .NET 4.8, C#, WPF
  * **Portal:** .NET 6, C#, Angular 11, NServiceBus for internal communication between services
* **Runtime Environment:**
  * **Wizard:** Windows 10, SQLite
  * **Portal:** Windows Server 2019, SQL Server 2019
* **Release Cycles:**
  * **Wizard:** About once every two to six months, depending on the partner, over the air.
  * **Portal:** Approx. every two weeks

**Note:** 40 Wizard instances from before 2015 do not have remote update capabilities, and must be updated by a service engineer until 2025. After that, the maintenance contracts expire, forcing the customer to upgrade to a remote-enabled version.

## Conventions

* Code
  * The coding guidelines are located in [Coding Guidelines](../12-glossary/#coding-guidelines).
* Test
  * The testing guidelines are located in [Testing Guidelines](../12-glossary/#testing-guidelines).
* Review
  * The review guidelines are located in [Review Guidelines](../12-glossary/#review-guidelines).
