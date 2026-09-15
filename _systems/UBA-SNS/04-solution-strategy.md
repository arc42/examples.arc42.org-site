---
title: Solution Strategy
order: 4
---

The publication of SNS data holdings is based on Linked Open Data (https://www.w3.org/standards/semanticweb/data). Linked Data means linking individual data elements that can be accessed directly. This is based on web addresses (HTTP URIs) for each data element and on the universal data model of the Resource Description Framework (RDF). Accordingly, every SNS record is identifiable through a dedicated URL and can therefore be freely referenced. Providing the data through RDF formats and serializations standardized by the W3C guarantees machine-readable processing.

The data provided by the SNS system originates from two autonomous specialist applications:

* **environmental thesaurus UMTHES**: Environmental terminology of interlinked technical and everyday designations. Of these designations, about 12,000 function as concepts for the automatic keyword assignment of documents. The remaining designations (about 23,000 German and about 17,000 English) are set as synonymous with the concepts (keywords). All concepts are embedded in a network structure, in which more general broader concepts are linked to more specific narrower concepts (e.g. tree <> conifer). Beyond that, there is also a connection between thematically related concepts (e.g. tree <> tree protection).
* **Environmental Chronicle**: Collection of about 4,000 historical and current environmental events. Since 2017, the Environmental Chronicle has no longer been maintained on a regular basis.

## Example

An example of the linking of data from the individual specialist applications:

* Environmental thesaurus UMTHES:
  * Concept: "Seeschifffahrt", URL: https://sns.uba.de/umthes/de/concepts/_00022275.html
  * Concept: "Schutzgebiet", URL: https://sns.uba.de/umthes/de/concepts/_00021997.html
  * Concept: "Wattenmeer", URL: https://sns.uba.de/umthes/de/concepts/_00027422.html
* Environmental Chronicle:
  * Event: "Wattenmeer international unter Schutz gestellt", URL: https://sns.uba.de/chronik/de/concepts/t1d97d0d_102035cd5d4_-362b.html

![Example of data linking](../images/solution-example.jpg)
