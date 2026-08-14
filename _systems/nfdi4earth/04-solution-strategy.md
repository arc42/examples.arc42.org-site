---
title: Solution Strategy
order: 4
---

NFDI4Earth aims to reuse existing services or parts of the services to build a
sustainable infrastructure for the ESS. Moreover, we target identifying and
collaborating with sustainable services that act as data sources whenever
appropriate and applicable.

The NFDI4Earth software architecture is, thus, organized along a service
portfolio. The NFDI4Earth Service Portfolio contains all relevant services
including community services and NFDI4Earth-developed services addressing
researchers' needs on the previously mentioned overall use cases.

> **Community services** are either disciplinary services offered by NFDI4Earth
> partners or discipline-agnostic/multidisciplinary services offered by
> trustworthy providers, both open for community usage.
>
> **NFDI4Earth-developed services** serve as openly available central support
> backbone services designed to address ESS researchers' needs in research data
> management. NFDI4Earth-developed services are developed by a distributed
> software developer team from NFDI4Earth partner institutions.

## Community Services

Information on community services was collected using a systematic approach.
Taking the different types of provided resources into account, we either
assessed data sources for the specific types of resources or performed a
landscaping process with manual steps, e.g., conducting interviews with the
service providers if there was no proper data source.

Data sources allow the harvesting of existing information via application
programming interfaces (APIs). In NFDI4Earth, we harvest information on
repositories and archives, data services, datasets, software, documents,
standards and specifications, and education and training materials.

Here, we distinguish the following interaction types depending on the data
sources' characteristics and scope:

| Data source's characteristics and scope | Actions | Example(s) |
|---|---|---|
| The identified data source is selected to publish NFDI4Earth-developed resources | NFDI4Earth implements the publishing process, curates the metadata, and harvests the source. | NFDI4Earth Zenodo Community |
| The identified data source provides relevant (meta)data for the ESS community. Meta(data) is managed and curated via the data source. | NFDI4Earth develops a metadata mapping in close collaboration with the data source and harvests the source. | DLR EOC Web Services Catalog |
| The identified data source provides relevant (meta)data for the research community. Meta(data) is managed and curated as a community effort. There is no need for specific ESS adaptions. By providing and updating information NFDI4Earth contributes to the overall research community. | NFDI4Earth recommends managing metadata in the related data source and assists if needed. Moreover, NFDI4Earth implements a proper harvester and provides an NFDI4Earth-developed workaround for resource providers who are not (yet) able to manage their metadata there, e.g., with manually curated and managed information. | Research Organisation Registry (ROR) for the resource type organisations; WIKIDATA to get NFDI4Earth member organisations; RDA Metadata Standards Catalog and Digital Curation Centre (DCC) for standards |
| The identified data source provides relevant (meta)data for the research community. Meta(data) is managed and curated as a community effort. Metadata provided by the data source needs regular updates and/or qualified information to tackle researchers' requirements. By registering new resources in the data source, NFDI4Earth contributes to the overall research community, e.g., by facilitating multidisciplinary use cases. | NFDI4Earth recommends managing metadata in the related data source and assists if needed. Moreover, NFDI4Earth and the data source align strategies on updating and improving metadata for the registered services. NFDI4Earth and the data source collaborate on the development of metadata schemas that meet the ESS community's requirements. NFDI4Earth, thus, utilizes the data source to manage metadata and provide a sustainable service and API for metadata harvesting. | Registry of research data repositories (re3data) for the resource type repository and archive |
| The identified data source provides relevant (meta)data for the ESS community and acts as an aggregator by harvesting relevant metadata from distributed sources. Moreover, NFDI4Earth provides additional community services that act as potential data sources for harvesting and should be integrated. | NFDI4Earth recommends managing metadata in the harvested data sources and assists if needed. NFDI4Earth and the data source align implementation strategies, co-develop solutions, such as harvesters, and provide common recommendations, e.g., on metadata schemas and APIs. | Helmholtz Earth and Environment DataHub for the resource type dataset |

The full list of harvested data sources is available at
[knowledgehub.nfdi4earth.de](https://knowledgehub.nfdi4earth.de) and will be
continuously adapted with respect to the following main goals:

- adding further sources to provide additional high-quality (meta)data or to
  reduce the number of manually collected (meta)data,
- linking metadata records and minimize duplication of information with respect
  to the quality of metadata,
- remove a source when it gets harvested by another source that is integrated
  in the NFDI4Earth software architecture or when the source is no longer
  maintained.

### NFDI Basic Services

Basic services provide specific community services. Following the general
service definition as described in
[section 1](../01-introduction-and-goals/), they additionally

- create added values for the consortia and their users
- typically bundle existing services
- are characterized by scalability and sustainable operating models
- must be effective over time and in terms of usage (trackable by KPIs)
  (source: [base4nfdi.de](https://base4nfdi.de/process/basic-services))

| Service name | Integration |
|---|---|
| [IAM4NFDI](https://base4nfdi.de/projects/iam4nfdi) | NFDI4Earth needs authentication and authorization in the EduTrain learning management system to track the learner's progress and preferences. We thus use the NFDI-AAI-provided [AcademicID solution](https://doc.nfdi-aai.de). The integration is implemented as [incubator](https://incubators.nfdi-aai.de) in the IAM4NFDI project. |
| [PID4NFDI](https://base4nfdi.de/projects/pid4nfdi) | NFDI4Earth actively contributes to the PID basic service as principal investigator and with providing use cases and derived requirements. |
| [nfdi.software](https://base4nfdi.de/projects/nfdi-software) | NFDI4Earth actively contributes to the basic service as principal investigator and with providing the Research Software Directory. |
| [DMP4NFDI](https://base4nfdi.de/projects/dmp4nfdi) | NFDI4Earth contributes with a use case to integrate existing services in RDMO. |

## NFDI4Earth-developed Services

NFDI4Earth provides five central support services. The **Knowledge Hub** is the
backend service that manages structured and interlinked metadata. It stores all
metadata in RDF (Resource Description Framework) and is accessible through a
SPARQL API. Through the use of the data management middleware Cordra that
stores all manually-created and harvested metadata, the architecture supports
the management of digital objects at scale and facilitates the mobilization of
(ESS) data as FAIR Digital Objects. The **OneStop4All** provides a single entry
point to find and explore ESS resources. The communication between the
OneStop4All and the Knowledge Hub happens through the Knowledge Hub's SPARQL
API and the OneStop4All search index.

The **Living Handbook** stores and manages web-based, interactive articles
about topics relevant to the community and the documentation of the NFDI4Earth.
It provides an editorial workflow to generate high-quality content for users
and ensures giving credit to attract authors. Living Handbook articles are
stored in the NFDI4Earth GitLab, are harvested through the API and made visible
in the OneStop4All.

The **EduTrain** learning resources are stored in an instance of the OPENedX
learning management system (LMS) and are also harvested through the API.

The **User Support Network** is a distributed helpdesk based on a ticket system
(Znuny) hosted at TU Dresden. The network is closely linked to helpdesks of the
community services, e.g., the Helmholtz Earth and Environment DataHub.

![Figure 1: the five NFDI4Earth-developed services and the software each is
built on — OneStop4All on React and Solr, Knowledge Hub on Jena, Python and
Cordra, EduTrain on Open edX, Living Handbook on GitLab and Markdown, User
Support on Znuny](../images/01-developed-services.png)

The following table provides an overview of chosen approaches and concepts:

| Service | Approach(es) | Concept |
|---|---|---|
| Knowledge Hub | Question-based approach | Described in deliverable D4.3.2: [10.5281/zenodo.7950860](https://doi.org/10.5281/zenodo.7950860) |
| OneStop4All | User-centred design and scenario-based approach | Described in deliverable D4.3.1: [10.5281/zenodo.10351658](https://doi.org/10.5281/zenodo.10351658) |
| Living Handbook | Scenario-based approach | Described in the [Living Handbook repository](https://git.rwth-aachen.de/nfdi4earth/livinghandbook/livinghandbook) |
| User Support Network | Helpdesk concept based on longstanding practical experiences | Described in deliverable D2.2.2: [10.5281/zenodo.7895294](https://doi.org/10.5281/zenodo.7895294) |
| Education and Training Materials and Services (EduTrain) | Focus group, requirement analysis | Described in deliverable D1.3.1: [10.5281/zenodo.7940195](https://doi.org/10.5281/zenodo.7940195) |

## NFDI4Earth-funded Community Software

The [NFDI4Earth Pilots](https://nfdi4earth.de/2participate/pilots) are studies
focused on providing solutions for specific needs of the ESS community. They
are managed in the
[NFDI4Earth GitLab](https://git.rwth-aachen.de/nfdi4earth/pilotsincubatorlab/pilots)
and made discoverable through the OneStop4All and integrated in the NFDI4Earth
architecture whenever possible (see
[section 1, Requirements Overview](../01-introduction-and-goals/)).

The [NFDI4Earth Incubator Lab](https://nfdi4earth.de/2participate/incubator-lab)
projects are small blue-sky projects on innovative ESS RDM approaches with an
experimental character. They are made discoverable through the OneStop4All and
their [source code and descriptions](https://git.rwth-aachen.de/nfdi4earth/pilotsincubatorlab/incubator)
are published for reuse by the ESS community.

## NFDI4Earth Virtual Research Environment

NFDI4Earth provides a virtual research environment for the development,
piloting, and operation of NFDI4Earth software and services. The Web
application service enables hosting community solutions on an NFDI4Earth
provided virtual machine. The service is operational and available at
[webapps.nfdi4earth.de](https://webapps.nfdi4earth.de).

NFDI4Earth offers High Performance Computing (HPC) Resources for
NFDI4Earth-related activities, such as pilot projects. Resources can be
requested by following a
[structured process](https://onestop4all.nfdi4earth.de/result/lhb-docs-HPC-Resources_Application.md).

Our NFDI4Earth helpdesk (helpdesk@nfdi4earth.de) supports the related tasks.
