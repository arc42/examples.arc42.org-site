---
title: Introduction and Goals
order: 1
---

## About this document {#about-this-document}

> It is safe to assume that new readers of the document will start with the first page of the document. Thus we can use this page to provide the most important information and guide the reader through the document. This approach is especially important when using wiki systems, which can otherwise become very confusing.

This documentation describes all aspects that should and must be considered in the development and maintenance of the FotoMaX device software. It uses the arc42 template as a basic structure. According to this, the documentation is divided into the following subsections, which can be read from top to bottom, leading from an abstract and external problem view to a concrete internal solution view.

*On this site the sections follow the arc42 numbering, so the chapters below are linked to the section that holds them. The original order is kept in the list.*

### Introduction & Goals

This chapter contains basic information necessary to understand the product and the business context in which it was created.

### [Quality Requirements](../10-quality-requirements/)

> This chapter deviates from the official arc42 structure in order to emphasize the importance of the quality requirements. Normally, these would only appear much later in the document, which makes sense if they are described in great detail. In this case, there are only a comparatively small number of scenarios. All of these are very important and therefore brought into focus by appearing very early in the document.

This chapter describes the non-functional requirements of the software system and prioritizes its quality attributes. These are fundamental decisions that influence many different aspects of the software and software architecture.

### [Constraints](../02-architecture-constraints/)

This chapter describes the constraints and requirements that limit software design, implementation or the development process.

### [Context & Scope](../03-context-and-scope/)

In this chapter the system is delimited from its environment. In this way, user roles, external systems and the associated interactions as well as needed interfaces are identified.

### [Solution Strategy](../04-solution-strategy/)

The actual implementation strategy is described in this chapter.

### [Building Block View](../05-building-block-view/)

The structural design and its decomposition into building blocks of various granularity is described in this chapter.

### [Runtime View](../06-runtime-view/)

All dynamic relationships that are to be highlighted are described in the runtime view chapter.

### [Deployment View](../07-deployment-view/)

The deployment view clarifies in which runtime environments the individual components of the system are installed and executed.

### [Crosscutting Concepts](../08-crosscutting-concepts/)

This chapter summarizes all concepts that cannot be assigned to a specific application layer, neither from a functional nor a technical point of view.

### [Architectural Decisions](../09-architecture-decisions/)

Fundamental decisions should not be made on the basis of a gut feeling, but as empirically as possible. In this chapter, all the information that is decisive for design decisions is collected.

### [Risks & Technical Debt](../11-risks-and-technical-debt/)

We see risks as all the things that can have a negative impact on the project and the software system if they are not handled appropriately. This chapter describes all risks and technical liabilities together with their possible effects and countermeasures, to make sure that they are not forgotten.

### [Glossary](../12-glossary/)

The glossary summarizes all terms that may hinder the understanding of the documentation.

### [Organizational Topics](../12-glossary/#organizational-topics)

> This chapter is not part of arc42 but was added to this documentation to show how teams can organize their daily work next to the architecture documentation so that both information sources are kept close together. This allows linking between the two and also ensures that both are always present. This in turn ensures that the architecture documentation is not perceived as something that exists somewhere somehow, but is an important part of one's own work.

This chapter contains information that does not relate directly to the software architecture, but to the day-to-day collaboration in implementing the software. This includes the Definition of Ready and Definition of Done, but also guidelines, checklists and things like vacation planning.

## Introduction and Goals

This chapter describes the key requirements and driving forces that must be considered when implementing the software architecture and developing the system.

### About FotoMaX {#about-fotomax}

FotoMaX is a white label solution for ordering photo products. It enables retailers of various types to offer their own customers additional services related to the processing and ordering of photographic content. This solution consists of two parts, the device hardware and software, which in their combination are set up at various partners as "Sales Units" or just "Units". This document primarily describes the software and only discusses the hardware when it influences the software design significantly.

FotoMaX does not take care of the actual printing of the orders. It provides the link between the companies that set up a sales unit in their stores and those that do the actual printing of the photo products. Based on the chosen version of FotoMaX, these could even be the same companies. The products are paid directly in the respective store or via mobile payment solutions.

In the simplest case, printing takes place directly in the store ("FotoMaX Standalone") or can be forwarded to a print shop ("FotoMaX Connect") to allow a larger variety of products like clothes, coffee cups or posters.

Typical points of sale:

* Supermarkets
* Drugstores
* Hotels
* ...

### Quality Goals

*The original places its quality requirements directly after this chapter. They are in [section 10](../10-quality-requirements/) on this site.*

### Stakeholders {#stakeholders}

The following people represent a particular view of the system and should therefore be consulted in fundamental decisions.

> Please note that these persons and their contact details are purely fictional. Similarities to existing companies or persons are therefore purely coincidental.

| Name | Contact | Role |
|---|---|---|
| Hannelore Meier | Hannelore.Meier@fotomax.net | Partner Manager Europe |
| Marcus Heinemann | Marcus.Heinemann@fotomax.net | End-User Representative |
| Mareike Edelman | Mareike.Edelman@fotomax.net | Operation Manager Europe |
| Peter Laudner | Peter.Laudner@fotomax.net | Enterprise Architect |
