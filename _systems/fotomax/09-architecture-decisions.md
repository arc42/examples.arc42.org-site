---
title: Architecture Decisions
order: 9
---

Fundamental decisions should not be made based on gut feeling, but as empirically as possible. This chapter collects all the relevant information for design decisions.

## ADR 001 - Base Technology Selection {#adr-001}

> This documentation is primarily intended to show what an [Architecture Decision Record](https://adr.github.io/) can look like. This does not mean that such a simple description is sufficient for such a serious and long-term decision as in the present case. Especially in this case, a deep analysis is of course worthwhile, and the analysis results should then also be filed at this point!

### Context

The basic technology of a software determines not only which APIs are available for development, but also which ecosystem will have an influence on the software in the long term. This ecosystem includes both free and proprietary libraries and frameworks. The selected technology also determines future viability, licensing costs and maintenance efforts.

In order to prevent technological fragmentation as much as possible, FotoMaX must have a base technology that can be used in the long term on the sales units, the portal, and possibly also on the end users' (mobile) devices. In addition, it must be stable and cost-effective to avoid unexpectedly high costs of maintenance, operation, and licensing.

In the course of setting up a new customer portal, a decision must be made about which basic technology should be used.

### State

Accepted.

### Decision

Date of adoption of the resolution: 15.06.2015

A decision was made in favor of .NET and the Microsoft ecosystem as the basis for software development at FotoMaX. .NET has been actively maintained by Microsoft for many years, and it allows the development of rich clients as needed for the sales units, websites, and mobile applications.

In addition, the decision makes it possible to continue maintaining the existing source code for the sales units without having to develop it from scratch. It is also possible to migrate the portal to the Azure Cloud with comparatively little effort.

### Consequences

Higher licensing costs are generally to be expected when using .NET and Microsoft technologies as opposed to other technologies. These include the costs for development environments, database servers and operating systems. However, economies of scale can be exploited here by standardizing corporate IT.

## ADR 002 - Base Architecture of the Wizard {#adr-002}

### Context

The architecture review of May 12, 2019, determined that the architecture of the Wizard is too difficult to maintain. Therefore, an alternative architecture is to be developed. The following architecture samples have been compared to the quality requirements to enable a selection. Please note: The evaluation was made based on an existing and complex software structure, which excludes a completely new development.

> The following comparison is to be understood as an example of how architecture patterns can be compared with the aid of a decision matrix. The evaluation does not claim to be complete or correct!

The following architecture patterns were compared:

| **Monolith** | is an architecture pattern where the software system can only function as a whole during development and runtime. Separations between the (technical) concerns must be enforced organizationally, as they are separated to a limited extent (all code is developed in the same repository). This means less organizational effort for changes but increases organizational effort for maintenance.|
| **Modulith** | is a special type of monolith where essential parts are physically separated from each other by either being developed in multiple code repositories and/or the software is split into multiple parts at compile time but executed and deployed as a whole. This definition follows a hybrid of the terms "allocation monolith" and "run time monolith," which are also commonly used. The modulith helps reduce maintenance costs compared to a monolith, but benefits from the runtime advantages of monoliths due to less complex runtime environments compared to service-oriented solutions. Moduliths are often an important step in migrating from monoliths to service-oriented architectures because they help to partition the monolith. |
| **SOA** | According to Wikipedia, "The term SOA has slightly different meanings. The first meaning is quite broad, describing it as a software design that divides functions into distinct units that developers make accessible over a network so that users can combine and reuse them when building applications. The other meaning describes it in more detail, following specific protocols and responsibilities." This comparison is based on the broader definition.|
| **Microservices** | can be considered as a specific type of SOA. The distinctive feature of microservices is that they are decoupled top-down using specific protocols, represent specific business units, and can be deployed independently of each other. SOA, in contrast, tends to be interpreted as having only a collection of features as separate functionality.|

**Analyzability**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Poor | Good | Medium | Medium |

For monoliths, the entire structure needs to be understood as it may not be decoupled. SOA and Microservices become complicated when the whole picture needs to be understood. This can be done with special tools, but is more difficult than with moduliths, where the software exists as a whole.

**Appropriateness**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Not applicable | Not applicable | Not applicable | Not applicable |

 This quality attribute must be addressed by specific implementation details that are not part of the architecture pattern.

**Authenticity**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Not applicable | Not applicable | Not applicable | Not applicable |

This quality attribute must be addressed by specific implementation details that are not part of the architecture pattern.

**Completeness**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Not applicable | Not applicable |Not applicable |Not applicable |

This quality attribute must be addressed by specific implementation details that are not part of the architecture pattern.

**Confidentiality**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Good | Good | Medium | Medium |

This quality attribute must be addressed by specific implementation details that are not part of the architecture pattern. However, services need to be secured more at runtime because they are deployed independently and separated from each other. This means a larger attack surface.

**Fault Tolerance**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Poor | Medium | Good | Good |

Because components in service-oriented architectures are physically separated from each other, faults can have less impact. Moduliths can compensate for faults somewhat better than monoliths, but are ultimately similarly vulnerable.

**Installability**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
|Good | Good| Medium | Poor |

Moduliths work as "deployment monoliths" and thus have the same advantage. The infrastructure for installing microservices is more difficult to set up than the infrastructure for just a few services.

**Integrity**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Good | Good | Medium | Medium |

This quality attribute must be addressed by specific implementation details that are not part of the architecture pattern. However, services simply need to be secured more at runtime because they are provided separately. This means a larger attack surface.

**Interoperability**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Poor | Medium | Good | Good|

Services use open interfaces that facilitate connecting external services. The Modulith is better prepared for such connections because it can be equipped with the appropriate adapters more quickly than is the case with the Monolith.

**Maturity**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
|Good| Good| Good|Good|

When used correctly, all architectural patterns can ensure the proper functioning of the software system.

**Modifiability**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Poor | Medium | Good |Good |

Monoliths are difficult to modify because their internal structure is less likely to be decoupled and therefore changes to one part can affect other parts. Microservices, on the other hand, operate as independently as possible.

**Modularity**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
|Poor|Good|Medium|Good|

Microservices are the most modular systems possible. SOA depends on the number and size of services. Moduliths are built with modularity in mind.

**Recoverability**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
|Poor|Medium|Good|Good|

Monoliths only work as a whole, so errors are more likely to affect the entire system. Moduliths have a greater chance of looking at individual components separately than monoliths do. Service-oriented architectures are associated with a whole range of tools that can be used to restore the status of individual services as quickly as possible.

**Testability**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
|Poor| Good| Medium|Medium|

Moduliths are great to test because they can run as a whole but also divided in their modules. Services based architectures are sometimes hard to test as a whole and monoliths cannot be decomposed.

**Time behavior**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Good| Medium| Poor| Poor|

Performance is lost with each layer of abstraction. Service-based systems have many more abstraction layers than software systems running in the same process.

**User error protection**

| Monolith | Modulith |SOA | Microservices|
| - | - | - | - |
| Not applicable| Not applicable|Not applicable|Not applicable|

This quality attribute must be addressed by specific implementation details that are not part of the architecture pattern.

Evaluation is based on ISO 25010.

### Decision

Accepted - 20.05.2019

The future Wizard will be implemented as a Modulith. This allows the best backwards compatibility and a smooth migration of the existing system. The actual advantages of service-oriented architectures and microservices cannot be exploited in the case of the deployment scenario.

### Consequences

An infrastructure must be created in order to be able to implement the Wizard as a modulith. A migration strategy is then required to break the Wizard down into modules and integrate them into the framework application in a loosely coupled manner.

## ADR 003 - Strategic decomposition of the wizard {#adr-003}

> This chapter is meant to show a more complex ADR as an example on how these can be used to justify design decisions and strategies.

### Context

Part of the further development of the Wizard is its decomposition into workflow modules and service modules. This document describes which grouping and priority should be taken into account in the decomposition. This is being coordinated with various stakeholders. It should also be noted that this decomposition is currently still very rough and is primarily intended as a preparation for creating a minimally modular application. In a further restructuring step, a functional decomposition can be performed on the basis of the target architecture.

![Risk against expected effort: codecs and image algorithms (S, small risk), hardware connection (M, small), general workflow logic (between M and L, medium), partner assets (XL, high), specific workflows (XL, highest)](../images/decomposition.png)

| Designation | Description | Efforts | Risks |
| - | --- | --- | --- |
|Codecs & Image Algorithms| Codecs and image algorithms are used to read photos of various types and to prepare them for printing. Furthermore, they are used to apply filters or distortion effects to image contents.|The effort for extraction is comparatively low, since algorithms and codecs are used primarily, but do not have any external dependencies themselves.| The risk of extraction is comparatively low, since the use of the algorithms can be traced very well in the code, and the interfaces are very clear.|
|Hardware connection |This contains all driver information and dialogs that technicians come into contact with during commissioning and/or maintenance of sales units.| The hardware connection area is manageable. However, the dialogs are very rigid and not prepared for use in environments like the frame application. | Since dialogs are primarily seen by technicians, the risk is comparatively low. However, it can happen that technicians are hindered in their work in case of errors.|
|Workflow Engine | This group describes all the logic that is used for the general implementation of dynamic workflows and navigation. It is not (!) about the actual workflows, but only about their infrastructure. | The code has to be rewritten as much as possible because such a procedure was not foreseen when the existing application was designed. | The biggest risks come from the fact that the workflow engine has to be freely configurable and must not have any dependencies to the concrete workflows at individual partners. Since it is a central control element, errors here may have an impact all the way to the end customer. |
|Partner Assets |Logos, Themes, Workflow configurations etc. for different partners |Due to the large number of partners and their respective customizations, the effort required to extract the code is very difficult to estimate. For some partners, special adaptations were made to the Sales Unit, which must also be reflected in a restructured version. | Due to the large amount of code, the many possible combinations, and the pervasiveness of the application (some assets are hardcoded), the risk of overlooking things that then become apparent as errors directly to the customer or partner is very high.|
|Special Workflows| Dialogs, workflows, product descriptions, etc., the use of which can be configured via the partner assets.| The same applies here as with the partner assets, only in an increased form. | The same applies here as with the partner assets, only in an increased form. |

### Decision

Accepted 27.11.2019

Due to the low effort and low risk of the conversion measures, it was decided to first outsource the codecs and the image algorithms to a separate service module. Although this does not serve the goal of a functional modularization of the wizard, it does allow the migration to be run through once with a low investment before more complex and riskier conversion measures are undertaken.

After the migration of the codecs and the image algorithms, the implementation of the general workflow logic as an independent module will be pushed forward. Again, this does not serve the long-term goal of functional modularization, but it does allow such a central and important component to be decoupled and easily testable from the outset.

Based on the resulting structures, the areas of partner assets and specific workflows can then be implemented.

### Consequences

While the initial modules will most likely not yet conform to the long-term architecture, they will be designed to be easily adaptable. Once the workflow logic has been implemented, further analysis of the legacy code and more detailed planning of the migration will need to take place in consultation with the various stakeholders.

## ADR 004 - Application framework {#adr-004}

> This chapter shows how decision matrices can be used to formalize the comparison of different solution alternatives.

### Context

The basic architecture requires an application framework with which modular applications can be created. As part of this, the following evaluation was carried out in October 2020. This comparison was performed to the best of the team's knowledge and belief by first establishing and ranking the evaluation criteria. Then the frameworks were analyzed by different people, presented to the team, and evaluated in terms of their suitability (Score). The procedure was deliberately designed in this way because it is a very important and long-term decision that should be made as objectively as possible.

Rank:

* 3 – perfect
* 2 – good
* 1 – at least not bad
* 0 – bad

The total score of an alternative is calculated by multiplying the score of each alternative by the prioritization of each criterion and then adding them up.

| Criterion | Description | Rank | PRISM WPF | PRISM WPF notes | Catel | Catel notes |
|---|---|---|---|---|---|---|
| **Score** | | | **78** | | **55** | |
|**Documentation**|How much information is available? How well is it written? Is it up-to-date? | 3 | 3 | excellently documented | 2 | partial (Stack Overflow); many base classes; property bag (Undo/Redo available); one-man show but fast reaction; huge community|
| **GitHub Activity** | How fast are issues handled? How many issues can be found? How many people work on it? | 1 | 2 | 1 week ago, Issues taken care of | 3 | 1 day ago, Issues taken care of |
| **GitHub fame** | How many people are interested in the framework? | 1 | 2 | 4.2k stars, 1.2k forks | 1 | 574 stars, 129 forks |
| **View Handling** | Is it possible to switch between views? | 3 | 3 | wire view/viewModel declaratively in XAML (DI is possible) | 1 | no special info found |
| **Messaging** | Does it have a message bus? | 2 | 3 | EventAggregator; messaging to the UI from background threads is possible | 3 | via static Message Mediator |
| **Bootstrapping** | Does it control how the application is started? Is the startup structured? | 2 | 3 | integral part | 0 | no, manual registration at IoC Container |
| **Module Handling** | Is it possible to create modules and load them dynamically? | 2 | 3 | yes, lots of different ways | 1 | it seems so (lack of documentation), it is not as good as Prism |
| **UI Styling** | Is it possible to create and manage themes? | 1 | 0 | not part of Prism | 0 | not part of Catel |
|**.NET 5 compatibility**| | 3| 3| yes| 2| .NET Core 3.1|
| **Data Validation** | Are there helpers to validate user input? Are there helpers to show validation errors? | 2 | 1 | not part of Prism but WPF makes it possible | 3 | yes |
|**Costs (including learning costs)**|Are there licence fees? How long might it take to learn?|2| 2| moderate because of excellent documentation| 2| huge learning cost because of lacking documentation|
|**Relevance**| How often is it used? How many questions can be found on Stack Overflow? How easy is it to find information about?| 2| 2| 950 downloads per day|0 |not measurable|
|**Sustainability**| How long does it exist? Are there signs that it will be closed down in the future?| 3| 3| yes |3| yes (2008)|
|**Mockable for testing**| Does it use IoC? Do central services have abstract interfaces?|3| 3|yes| 0| no (everything is static)|
|**License**| It must be an approved licence.|3| 3| MIT| 3| MIT|

### Decision

Accepted - 13.10.2020

The Prism framework was chosen as the application framework for the Wizard because it meets all the requirements. Static code analysis must be used to ensure that there are no dependencies on the framework outside of bootstrapping, module definition and the user interface. In these parts, dependencies can be tolerated, since there is a dependency on WPF here anyway. However, if a platform-independent technology is chosen in the future, then a new development of the entire wizard should not be necessary because of Prism!

### Consequences

By choosing an application framework based on WPF, this technology will continue to be used for the wizard, which in turn means dependencies on Windows as the operating system. At the same time, the migration of the existing application is easier because it has already been implemented with WPF.
