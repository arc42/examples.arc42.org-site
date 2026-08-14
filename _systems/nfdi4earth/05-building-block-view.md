---
title: Building Block View
order: 5
---

The detailed description of the NFDI4Earth architecture is done by using a
**blackbox–whitebox approach** that describes the major aim, the main
functionalities and interfaces of the services as seen by the outward facing
properties first (blackbox), e.g., user perspective, and then provides details
on the (inner) solutions, e.g., service components, implementations
(whitebox).

## Whitebox Overall System

The NFDI4Earth software architecture provides two services that serve as entry
points to several linked NFDI4Earth and community-developed services: the
**OneStop4All** as human-readable interactive user interface and the
**Knowledge Hub** as machine-interpretable interface.

![Figure 2: the NFDI4Earth software architecture as hexagonal clusters —
NFDI4Earth-developed, community and basic services, coloured by the
research-data-management capability each covers; the centre cell numbers the
five developed services](../images/02-software-architecture.png)

### Blackbox Knowledge Hub

This blackbox description is based on the Knowledge Hub concept one-pager and
concept deliverable ([10.5281/zenodo.7950859](https://doi.org/10.5281/zenodo.7950859),
[10.5281/zenodo.7583596](https://doi.org/10.5281/zenodo.7583596)).

The Knowledge Hub serves as one major backend service of NFDI4Earth. It
integrates metadata about ESS resources and is accessed via an API.

| | |
|---|---|
| **Problem** | Research products from the Earth System Sciences (ESS) are increasingly difficult to find. There is a need for tools that automate their discovery. 'Research products' is used here as a catch-all term that includes 1) datasets, 2) services, 3) tools, 4) vocabularies, 5) reports, 6) scientific papers, and 7) peer reviews, etc. |
| **Innovations** | • Structured and interlinked metadata for ESS resources produced in NFDI4Earth or relevant for the NFDI4Earth. These ESS resources can be any research product listed above, but also an article of the Living Handbook, or an educational material from the EduTrain. We use RDF (Resource Description Framework) as an encoding format.<br>• Structured and interlinked metadata for ESS resources hosted by NFDI4Earth partners.<br>• NFDI4Earth label — compiled based on the available metadata — as an indicator of the extent to which services are FAIR, and in particular, the degree of interoperability of the services. |
| **Users** | • **Consumers**: people who have skills in programmatic data access (i.e., they are able to program a short snippet of code in a programming language to retrieve data).<br>• **Producers**: these create/edit metadata for the Knowledge Hub. They may have programming skills (in which case they create/edit metadata, e.g., harvest, via the API of the Knowledge Hub) or have no programming skills (in which case they do the creation/editing via a user interface). |
| **Interface(s)** | SPARQL API |
| **Unit of adoption** | Individuals |

The Knowledge Hub is available at
[knowledgehub.nfdi4earth.de](https://knowledgehub.nfdi4earth.de/).

### Blackbox OneStop4All

This blackbox description is based on the OneStop4All concept one-pager
([10.5281/zenodo.7583596](https://doi.org/10.5281/zenodo.7583596)).

The NFDI4Earth OneStop4All is the primary visual and user-friendly NFDI4Earth
access point.

| | |
|---|---|
| **Challenges** | Research products from the ESS community are diverse and increasingly difficult to find. There is thus a need for platforms that efficiently organize the access to ESS resources, in particular quality-assured resources. These platforms should be:<br>• User-friendly and easy-to-use, taking specific user characteristics and needs into account<br>• Flexible enough to integrate future RDM services (e.g., address multidisciplinary use cases with other NFDIs, link to EOSC services). |
| **Innovations** | • Central search on NFDI4Earth resources and distributed sources, including relevant governmental, research and other open data sources<br>• Innovative user interfaces to explore the linked ESS resources that adapt to the needs of different user groups<br>• Intelligent functionality to connect Living Handbook information for registered resources<br>• Seamless transition from machine-based to human-based support<br>• A community tool fostering the sharing of high-quality information and resources |
| **Users** | We envision the following types of primary users:<br>• Users, who are looking for ESS research and ESS RDM information, e.g., events, networks<br>• Users, who are looking for support, e.g., on NFDI4Earth tools or on how to use NFDI4Earth services<br>• Users, who want to offer information/research products<br>• Users, who want to provide feedback on the content |
| **Interface(s)** | User interface |
| **Unit of adoption** | Individuals |

The NFDI4Earth OneStop4All is available at
[onestop4all.nfdi4earth.de](https://onestop4all.nfdi4earth.de/).

### Blackbox EduTrain

This blackbox description is based on the EduTrain concept one-pager
([10.5281/zenodo.7583596](https://doi.org/10.5281/zenodo.7583596)).

The EduTrain provides a comprehensive overview on existing education and
training material and provides FAIR, open, ready-to-use modular course material
that are developed by the EduTrain team based on the community's needs.

| | |
|---|---|
| **Problem** | A lack of FAIR and open educational resources is one of the biggest obstacles to scientific activities. Although substantial effort has already been put into developing Open Educational Resources (OERs), many issues still exist, e.g., peer-reviewing the content, maintenance responsibility, quality control, management, and lack of funding for the development and maintenance. Another major problem is that most existing FAIR principles and Open Science materials are generic. At the same time, ESS-specific materials that outline adapting the FAIR principles and Open Science concepts are highly needed but mainly missing.<sup>[1](#fn1)</sup> |
| **Innovations** | • Development and maintenance of OERs and curriculum based on regular educational needs assessment of the ESS community<br>• Continuous collection and evaluation of existing OERs in research data management tailored for ESS, spatio-temporal data literacy, and spatio-temporal data science<br>• Funding the development of new open-licensed materials to meet the educational needs of the ESS community by publishing calls for educational pilots<br>• Development of target group-specific curricula |
| **Users** | • Scientists, ranging from early-career researchers (Ph.D. students, Post-Docs) to experienced senior scientists and professors<br>• Master students<br>• Bachelor students<br>• Educators and training professionals (e.g., professors, lecturers, teaching assistants) |
| **Interface(s)** | User interface |
| **Unit of adoption** | • Individuals<br>• Higher education institutions<br>• Research centres |

The EduTrain Service is available at
[edutrain.nfdi4earth.de](https://edutrain.nfdi4earth.de/).

<span id="fn1"></span>1. Peter Pelz et al., *Working Group Charter Training
Infrastructures*, [10.5281/zenodo.6478698](https://doi.org/10.5281/zenodo.6478698),
2022.

### Blackbox Living Handbook

This blackbox description is based on the Living Handbook concept one-pager
([10.5281/zenodo.7583596](https://doi.org/10.5281/zenodo.7583596)).

The Living Handbook provides an interactive Web-based documentation for all
aspects related to the NFDI4Earth, its services and outcomes.

| | |
|---|---|
| **Problem** | Many researchers, societies, funding agencies, companies, authorities, or the interested public are not familiar with each aspect of the NFDI4Earth, its services, or ESS research data in general. A core service with overview documents of such topics is, hence, required. The various user needs, and prior knowledges must be reflected in these documents, i.e., these must provide a flexible granularity, from being brief and informal to being comprehensive and detailed. |
| **Innovations** | • Structuring and harmonizing all aspects of NFDI4Earth as well as ESS related information from different, also previously unpublished, sources.<br>• Curate and present information about the NFDI4Earth as a collection of edited, inter-linked, human-readable documents of various types (documentation, report, article, manual, tutorial, ed-op, etc.) that are externally linked with general ESS resources.<br>• Compilation of documents tailored to the different proficiency levels and backgrounds of readers by a combination of automatic re-combination and re-arrangement of the document's elements. |
| **Users** | • **Consumers**: Users with interest in NFDI4Earth, NFDI or else ESS related information, data, services, concepts, software etc. We expect users with a high variety in their backgrounds and prior knowledge.<br>• **Editors/authors**: Persons that provide and regularly quality check the LHB contents. |
| **Interface(s)** | User interface |
| **Unit of adoption** | The LHB is beneficial to, e.g.:<br>• Researchers as a manual how to use NFDI4Earth and related external products and to learn what the scope of the NFDI4Earth and its services are.<br>• Scientific and professional societies as a place to refer their members as a resource for ESS data related topics.<br>• Funding agencies to understand how researchers are using and providing ESS data<br>• Authorities to get and provide information about ESS data<br>• The interested public as the first stop to find ESS related information |

The Living Handbook is managed
[in the NFDI4Earth GitLab](https://git.rwth-aachen.de/nfdi4earth/livinghandbook/livinghandbook).

### Blackbox User Support

This blackbox description is based on the User Support Network concept one-pager
([10.5281/zenodo.7583596](https://doi.org/10.5281/zenodo.7583596)).

The User Support Network provides distributed, cross-institutional user support
based on the services of the existing partner institutions' services and the
upcoming NFDI4Earth innovations.

| | |
|---|---|
| **Challenges** | Research data services from the Earth system sciences community are diverse and until now mainly directed to a smaller community, e.g., an institute. We work on a structure in the USN that allows to map the different resources and to access them. The USN will also evaluate if an open community support system (like Stack Overflow) will be of value next to the institutional RDM support of the USN team. To work on that evaluation, we need a solid idea of what kind of user questions are asking, which we expect to get by running the ticketing system. |
| **Innovations** | • Single point of access to a national expert pool offering individual support for ESS RDM problems for all phases of the data lifecycle<br>• Collection, harmonization and provision of expert knowledge based on institutional experience, e.g., via Living Handbook<br>• Creation of standard operation procedures (SOPs) for user support |
| **Users** | We envision the following types of primary users:<br>• Users, who are looking for general information, e.g., on NFDI4Earth tools or on how to use NFDI4Earth services<br>• Users, who are looking for support in ESS research data management (RDM) |
| **Interface(s)** | User interface |
| **Unit of adoption** | • Individuals<br>• Research institutions |

The User Support Network can be contacted via
[onestop4all.nfdi4earth.de/?support](https://onestop4all.nfdi4earth.de/?support).

## Whitebox NFDI4Earth-developed Services

Here, we describe the implementation solutions for the NFDI4Earth-developed
services and the NFDI4Earth-funded Community Software.

### Whitebox Knowledge Hub

The NFDI4Earth Knowledge Hub consists of three building blocks to harvest,
process and provide metadata.

The **pre-processing scripts** mainly provide pipelines to harvest data sources
or populate manually collected metadata, map metadata to the NFDI4Earth schemas
and add/update the harmonised metadata in the data management system. These
scripts are written in Python and provided as open-source in the NFDI4Earth
GitLab.

Through the use of a **data management system** that stores all
manually-created and harvested metadata, the NFDI4Earth software architecture
supports the management and provision of FAIR digital objects.

The **triple store** stores all metadata as semantically-enriched metadata in
RDF (Resource Description Framework) and is accessible through a SPARQL API.

The implementation of the data management system and the triple store happens
in NFDI4Earth through open-source software: **Cordra** as the data management
system and **Jena Fuseki** as the triple store (see
[section 9](../09-architecture-decisions/) for both decisions, and
[section 7](../07-deployment-view/) for how the harvesting pipelines are
scheduled).

![Figure 3: whitebox Knowledge Hub — Python pre-processing scripts publish
metadata as JSON-LD over REST into the Cordra data management system, which
synchronizes triples into a Jena triple store exposed through
SPARQL](../images/03-whitebox-knowledge-hub.png)

The NFDI4Earth Ontology is available at
[nfdi4earth.de/ontology](https://nfdi4earth.de/ontology). The Ontology is
iteratively developed in the open Knowledge Hub working group.

The Knowledge Hub source code is managed in the
[NFDI4Earth GitLab](https://git.rwth-aachen.de/nfdi4earth/knowledgehub).
Developments, e.g., harvester implementations, are coordinated across the
products in the
[NFDI4Earth developer meeting](https://www.nfdi4earth.de/2coordinate/software-developer-team).

### Whitebox OneStop4All

The OneStop4All provides the Web frame for all NFDI4Earth user interface (UI)
services. Thus, the OneStop4All links or embeds the EduTrain learn management
system and the Living Handbook user interfaces with respect to a user-friendly
navigation and a common look-and-feel for all NFDI4Earth UI services and
provides access to the User Support Network via Web form. By doing so, the
OneStop4All does not provide the exclusive, but an additional access point for
all other NFDI4Earth services with user interfaces. The central search on all
NFDI4Earth resources provides the core functionality of the OneStop4All.

The OneStop4All is implemented as a custom solution — built on the **Open
Pioneer Trails** framework from
[52°North](https://52north.org/software/software-components/open-pioneer-trails/)
(React, Chakra UI, Vite, pnpm), and split into three components: a *frontend*
serving the user interface, an *index* that mirrors Knowledge Hub data into
[Apache Solr](https://solr.apache.org), and a *harvester* that pulls from the
Knowledge Hub's triple store over SPARQL and feeds the index. See
[section 7](../07-deployment-view/) for how the three are deployed.

![Figure 4: whitebox OneStop4All — central login, central search and a content
management UI sit above EduTrain, the Living Handbook and User Support; the
Living Handbook is embedded, the other two are linked](../images/04-whitebox-onestop4all.png)

The design and implementation strategy are described in
[10.5281/zenodo.10351658](https://doi.org/10.5281/zenodo.10351658) and
[10.5281/zenodo.13629130](https://doi.org/10.5281/zenodo.13629130). OneStop4All
source code is managed in the
[NFDI4Earth GitLab](https://git.rwth-aachen.de/nfdi4earth/onestop4all).
Developments are coordinated across the products in the
[NFDI4Earth developer meeting](https://www.nfdi4earth.de/2coordinate/software-developer-team).

## Whitebox NFDI4Earth-funded Community Software

The NFDI4Earth-funded community software includes NFDI4Earth Pilots and
Incubators.

### Blackbox NFDI4Earth Pilots

The blackbox description is based on the Pilots concept one-pager
([10.5281/zenodo.7583596](https://doi.org/10.5281/zenodo.7583596)).

The NFDI4Earth Earth System Science (ESS) Pilots are small projects from
various disciplines of the ESS community usually lasting for one year. Pilots
are used to assess and define requirements in other task areas and promising
results will be integrated into the NFDI4Earth infrastructure.

| | |
|---|---|
| **Problem** | To achieve acceptance and adoption of the community as well as a cultural change, NFDI4Earth must not implement top-down solutions but involve ideas and existing tools from the research community. Different domains of ESS face different challenges in interoperability, standardization of data, methods and workflows. Expertise and technologies are existent but need further development to meet domain specific requirements and often lack transferability for usage beyond a small user group. |
| **Innovations** | • Agile projects that directly reflect researchers' needs in data management and implement novel solutions for research data management<br>• Bottom-up innovation scouts for other Task Areas of NFDI4Earth<br>• Focus on transferability of results and enhancement of technologies to make use of existing resources and foster community driven design of NFDI4Earth |
| **Users** | The target community are researchers from the ESS community working on tools that enhance research data management. The solutions implemented from the pilots are targeted to the respective scientific community. |
| **Interface(s)** | Depending on the individual pilot proposals |
| **Unit of adoption** | • NFDI4Earth includes pilots' results into their infrastructure<br>• User communities of different domains that adopt the newly developed tools by pilots |

As the pilots provide individual solutions, we don't include the whitebox
description here. NFDI4Earth Pilots are available in the
[NFDI4Earth GitLab](https://git.rwth-aachen.de/nfdi4earth/pilotsincubatorlab/pilots).

### Blackbox NFDI4Earth Incubators

NFDI4Earth Incubators are documented at
[nfdi4earth.de/2participate/incubator-lab](https://nfdi4earth.de/2participate/incubator-lab).
