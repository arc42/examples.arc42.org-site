---
title: Architecture Constraints
order: 2
---

The few constraints on this project are reflected in the final solution. This section shows them and, if applicable, their motivation.

## Technical Constraints

| ID | Constraint | Background and / or motivation |
|---|---|---|
| | **Software and programming constraints** | |
| TC1 | Implementation in Java | The application should be part of a Java 8 and Spring Boot show case. The interface (i.e. the API) should be language and framework agnostic, however. It should be possible that clients can be implemented using various frameworks and languages. |
| TC2 | Third party software must be available under a compatible open source license and installable via a package manager | The interested developer or architect should be able to check out the sources, compile and run the application without problems compiling or installing dependencies. All external dependencies should be available via the package manager of the operating system or at least through an installer. |
| | **Operating system constraints** | |
| TC3 | OS independent development | The application should be compilable on all 3 major operating systems (Mac OS X, Linux and Windows). |
| TC4 | Deployable to a Linux server | The application should be deployable through standard means on a Linux based server. |
| | **Hardware constraints** | |
| TC5 | Memory friendly | Memory can be limited (due to availability on a shared host or deployment to a cloud based host). If deployed to a cloud based solution, every megabyte of memory costs. |

## Organizational Constraints

| ID | Constraint | Background and / or motivation |
|---|---|---|
| OC1 | Team | Michael Simons |
| OC2 | Time schedule | Start in early 2014 with Spring Boot beta based prototypes running on Java 8 early access builds, first "release" version March 2014 together with the initial release of Java 8. Upgrade to a final Spring Boot release when available. |
| OC3 | IDE independent project setup | No need to continue the editor and IDE wars. The project must be compilable on the command line via standard build tools. Due to _OC2_ there was, at the time, only one IDE supporting Java 8 features out of the box: _NetBeans 8_ beta and release candidates. |
| OC4 | Configuration and version control / management | Private git repository with a complete commit history and a public master branch pushed to GitHub and linked to a project blog. |
| OC5 | Testing | Use JUnit to prove functional correctness and integration tests, and JaCoCo to ensure a high test coverage (at least 90%). |
| OC6 | Published under an Open Source license | The source, including documentation, should be published as Open Source under the Apache 2 License. |

## Conventions

| ID | Convention | Background and / or motivation |
|---|---|---|
| C1 | Architecture documentation | Structure based on the English arc42 template, version 6.5. |
| C2 | Coding conventions | The project uses the [Code Conventions for the Java Programming Language](http://www.oracle.com/technetwork/java/codeconvtoc-136057.html). The conventions are enforced through Checkstyle. |
| C3 | Language | English. The project and the corresponding blog target an international audience, so English is used throughout the whole project. |
| C4 | Naming conventions | A number of naming conventions are checked and enforced with [jQAssistant](https://jqassistant.org). |
