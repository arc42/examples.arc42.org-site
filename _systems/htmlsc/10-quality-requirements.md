---
title: Quality Requirements
order: 10
---

> **Content and motivation**
>
>You want to know specific and operational quality requirements,
>at best in form of a specific _quality tree_. This section
>completes, augments or refines the top-quality goals already
>given in arc42-section 1.2.

Remark: For our small example, such a quality tree is overly extensive...
whereas in real-live systems we've seen quality trees with more than 100
scenarios. Therefore, we stick to (repeating) a few scenarios here.

## Quality Scenarios

|Attribute     |Description  |
|---|:---|
|Correctness |Every broken internal link will be found. |  
| | |
|Correctness |Every missing (local) image will be found.|
| | |
|Correctness |Correctness of all checks is ensured by automated positive and negative tests. |
| | |
|Completeness |The results-report must contain _all_ results (aka findings) |
| | |
|Flexibility |HtmlSC shall be extensible with new checking algorithms and new usage scenarios (i.e. from different build systems) |
| | |
|Safety |HtmlSC leaves its source files completely intact: Content of files to be checked will _never_ be modified.|
| | |
|Performence |HtmlSC performs all checks on a 100kByte HTML file in less than 10 seconds.|
| | |
