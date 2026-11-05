{pagebreak}

{#section-v-2}
## VII.2 Introduction and Goals

This chapter describes the key requirements and driving forces that must be considered when implementing the software architecture and developing the system.

{#section-vii-2-1}
### About FotoMaX

FotoMaX is a white label solution for ordering photo products. It enables retailers of various types to offer their own customers additional services, related to the processing and ordering of photographic content. This solution consists of two parts, the device hardware and software, which in their combination are set up at various partners as "Sales Units" or just "Units". This document primarily describes the software and only discusses the hardware when it influences the software design significantly.

FotoMax does not take care of the actual printing of the orders. It provides the link between the companies that set up a sales unit in their stores and those that do the actual printing of the photo products. Based on the chosen version of FotoMax these could even be the same companies. The products are paid directly in the respective store or via mobile payment solutions. 

In the simplest case, printing takes place directly in the store ("FotoMaX Standalone") or can be forwarded to a print shop ("FotoMaX Connect") to allow a larger variety of products like cloths, coffee cups or posters. 

Typical points of sale:

* Supermarkets
* Drugstores
* Hotels
* ...

{pagebreak}


{#section-vii-2-2}
### Stakeholders

The following people represent a particular view of the system and should therefore be consulted in fundamental decisions.

A> Please note that these persons and their contact details are purely fictional. Similarities to existing companies or persons are therefore purely coincidental.

{width="wide"}
| Name | Contact | Role |
|---|---|---|
| Hannelore Meier | Hannelore.Meier@fotomax.net | Partner Manager Europe|
| Marcus Heinemann | Marcus.Heinemann@fotomax.net | End-User Representative |
| Mareike Edelman |Mareike.Edelman@fotomax.net|Operation Manager Europe |
| Peter Laudner | Peter.Laudner@fotmax.net | Enterprise Architect |
