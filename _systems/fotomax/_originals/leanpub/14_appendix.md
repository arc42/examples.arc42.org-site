{pagebreak}

{#section-vii-14}
## VII.14 Organizational Topics

This chapter contains information that does not relate directly to the software architecture, but to the day-to-day collaboration in implementing the software.

{#section-vii-14-1}
### Onboarding

A> Note that this chapter is a direct result of the quality requirements and scenarios regarding maintainability which states that new team members should be able to be productive in a certain amount of time.


This chapter describes resources to help new team members get the best possible start on the project.

{#section-vii-14-1-1}
#### Checklist for the start-up phase
The following checklist is intended to help new team members find their way around the team as quickly as possible and be able to work productively.

{width="wide"}
|Check | Work Item | Contact Person|Reference Material|
|---|---|---|---|
|▢| Basics of agile working | Scrum Master| [Scrum Guide](https://www.scrum.org/resources/scrum-guide), [Agile Manifesto](https://agilemanifesto.org/)|
|▢| Clarification of how the team has adapted the agile work |Scrum Master| [Team Charter](#section-vii-14-3-1), [Definition of Ready](#section-vii-14-3-2), [Definition of Done](#section-vii-14-3-3)|
|▢| Invitation to regular meetings |Scrum Master| Daily, Review, Planning, Retro, Refinement|
|▢| Invitation to agile tools |Scrum Master| Teamretro, Miro |
|▢| Introduction to used agile tools| Scrum Master| [scrum-poker.org](scrum-poker.org), Teamretro, Miro|
|▢| Introduction to product|Product Owner| Marketing Documentation, User Manual, Test System|
|▢| Introduction to architecture documentation | Architect | [Architecture Documentation](#section-vii-1) |
|▢| Read and understand architecture documentation | New Member| [Architecture Documentation](#section-vii-1) |
|▢| Set up development environment|New Member|[Installation Guide](#section-vii-14-1-2)|
|▢| Overview of the development process| Developer |[Coding Guidelines](#section-vii-14-2-1), [Review Guidelines](#section-vii-14-2-3) |
|▢| Overview of test procedures and tools used| Developer | [Testing Guidelines](#section-vii-14-2-2), Testing Frameworks, Test isolation Frameworks |
|▢| Read past sprint reviews| New Member | [Sprint Reviews](#section-vii-14-3-4)|
|▢| Implement Tutorial | New Member | [Tutorial](#section-vii-14-1-3)|
|▢| Checkout Repository| New Member | Git Repository |
|▢| Write first test in production code | New Member| Source Code |

{#section-vii-14-1-2}
#### Installation Guide
A>In a real documentation, this chapter would describe of how to set up a new development environment. Among other things, the following questions should be answered:
* Which software is to be installed in which order?
* Which environment variables or similar have to be set?
* From where can the source code be obtained?

{#section-vii-14-1-3}
#### Tutorial
A>In a real documentation, a description would be found in this chapter, with which new team members can develop a first feature. This helps them to understand the basic architecture and the tools used, but also to test their development environment before they write their first real production code.

{pagebreak}

{#section-vii-14-2}
### Guidelines

{#section-vii-14-2-1}
#### Coding Guidelines

A>This chapter would contain descriptions of how the code should be styled, if this was a real documentation. In general, the coding guidelines should mainly deal with special cases instead of explaining the code style in detail. The latter can be better checked by static code analysis tools and/or a linters. Things to consider are for example:
* Mention of the code style used with a link to additional sources and incl. explanation of how it is checked.
* Dealing with exceptions (if supported by the language)
* Dealing with enumerations (if supported by the language)
* Common (Anti-)Patterns to avoid

{#section-vii-14-2-2}
#### Testing Guidelines
A>This chapter should contain descriptions on how automated or manual tests are to be performed. It is worthwhile at this point to formulate guidelines individually for each type of test in order to be able to design them in a way that is appropriate for the target group.
* Unit Test Guidelines
* Integration Test Guidelines
* Exploratory Test Guidelines
* ...

{#section-vii-14-2-3}
#### Review Guidelines
Code reviews are a very important means of quality assurance. This document is intended to provide reviewers with a guideline to decide whether or not a pull request may be included in the main branch. This guideline only includes things that are not already checked by an automated check through build tools.

____Precondition of a review____

{width="wide"}
|Check | Description 
|---|---|
| ▢ | The review is performed by a person who was not involved in the programming himself. |
| ▢ | The code was checked out locally by the reviewer. |
| ▢ | The code was built locally. |
| ▢ | Automated tests were executed locally. |

____Criteria____

{width="wide"}
|Check | Description 
|---|---|
| ▢ | The software was built successfully. |
| ▢ | The software can be started locally and simple operations in the area of the change are possible without complications. |
| ▢ | No exceptions were detected during the execution of the code (see Exception Information of the debugger).   |
| ▢ | All automated tests can be executed successfully.|
| ▢ | There are no ignored tests.|
| ▢ | If tests were deleted, this was done justifiably or they were replaced by others.| |
| ▢ | There are no warnings in the local development environment.|
| ▢ | There is no code that suppresses warnings in the code analysis tools.|
| ▢ | The code satisfies the rules from the [Coding Guidelines](#section-vii-14-2-1).|
| ▢ | The tests satisfy the rules from the [Testing Guidelines](#section-vii-14-2-2).|

{#section-vii-14-3}
### Daily Work
This part of the documentation is reserved for all topics regarding the organization of the daily work of the team.

A> This area would be separately handled for each and every team. Following only one example can be found to hold the overall documentation short.

{#section-vii-14-3-1}
#### Team Charter
The team charter is a set of rules created by each team itself to define how it wants to work together. It should only contain things that all members can agree on. Examples:

* We are punctual.
* Problems are resolved promptly and factually.
* Documentation and testing are as important as source code.
* We maintain a positive feedback culture.
* Cell phones may not be used during an appointment.

{#section-vii-14-3-2}
#### Definition of Ready
With the Definition of Ready, the team determines which prerequisites must be met before the actual development can start. The DoR was created by the team and each team member agreed on it.

* The requirements are described as user stories and placed in the backlog.
* The user story has been assigned a business value.
* The user story is understood by all team members.
* Testable acceptance criteria are available.
* External dependencies have been named.
* The user story has been estimated in story points.
  
{#section-vii-14-3-3}
#### Definition of Done
With the Definition of Done, the team determines when it is finally finished with the work on a feature. The DoD was created by the team and each team member agreed on it.

* A code review was performed by a developer who was not involved in the implementation.
* All acceptance criteria have been implemented.
* Test coverage is at least 75%.
* All tests are successful.
* The code has been transferred to the Main Branch.
* There was a formal review by the product owner.

{#section-vii-14-3-4}
#### Sprint Reviews
A> Results or resources from and for the sprint reviews can be stored in this area. In this way, the information is not lost and can contribute to continuous improvement.

{#section-vii-14-3-5}
#### Vacation Planning
If there is no better solution, this area of the documentation can be used to track the availability of team members and plan vacations. This allows a more effective sprint planning.