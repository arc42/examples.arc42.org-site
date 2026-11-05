{pagebreak}

{#section-vii-5}
## VII.5 System Scope and Context

In this chapter the system is delimited from its environment. This way user roles, external systems and the associated interactions, as well as the necessary interfaces are identified.

{#section-vii-5-1}
### Business Context

The business context describes the external dependencies of the software system from a domain-oriented perspective.

FotoMaX maps two different workflows: In standalone mode, all jobs are processed on the client's premises; in connected mode, jobs are forwarded to external print service providers.

{width="90%"}
![](images/fotomax/chapter5/bussinesscontext.png)

{width="wide"}
|Designation | Description |
| --- | --- |
|End Customer | A person who uses photo printing services via a sales unit and can track them via the portal. |
| | |
|Service Technician | An employee of FotoMaX GmbH who performs initial submission and maintenance work on Sales Units. |
| | |
|Pitch Provider | An employee of the respective pitch provider who performs minor maintenance work on sales units. This includes replenishing printing paper and cartridges of the receipt printer or retrieving orders in standalone mode. In the Connected case, the parking space provider can view orders and check invoices. |
| | |
|Print Provider | An employee of the print provider who can view order data and modify orders. |
| | |
|Sales Unit | The hardware/software combination set up at a parking space provider to take orders from end customers. |
| | |
|Portal | Customer and partner portal via which orders can be tracked. |
| | |
|Order System Print| The external system of the print provider to which print orders are forwarded. Each print provider can be expected to have its own system. |
| | |
|Billing System / Printing Site | The billing system of the printing site provider, via which print jobs are billed. |

#### Standalone Setup

In standalone mode the sales unit is only connected to a local printer and has no internet connection. All orders are processed and paid for within the premises of the pitch provider. The supplier rents both the sales unit and the printer from FotoMaX at a fixed monthly rate. In addition, consumables such as ink and paper are billed according to usage. In addition to printing the ordered items, the sales unit also prints a receipt, which has to be paid by the end customer at the checkout of the pitch provider. FotoMaX is not involved in the actual billing process.

#### Connected Setup

The connected setup allows end customers to place more extensive orders and track them online. In addition, the orders are not executed exclusivly on the premises of the provider's premises, but also at a corresponding print provider on additional products such as mugs, t-shirts or similiar articles. In a partially connected setup, the billing is done by the pitch provider.

In a full connected setup, the orders are then either paid for by EC or credit card at the device or the customer receives an invoice via e-mail. In this case, the pitch provider is not involved in the billing of an order, but receives a fixed monthly stand fee, and commission on all sales. They can view their earnings at any time via the portal.

### Technical Context

The technical context highlights the technical environment in which the software system exists
and the respective interfaces to external systems.

![](images/fotomax/chapter5/technicalcontext.png)

{width="wide"}
| Element | Description |
| --- | --- |
|Service Technician | An employee of FotoMaX GmbH, who performs maintenance work on sales units on site. |
| | |
|Local Technician | An employee of the respective sales pitch provider, who performs minor maintenance work on sales units. This includes replenishing printing paper and cartridges of the receipt printer or retrieving orders in standalone mode. The wizard's UI is used to confirm all maintenance tasks. Local technicians have no access to the sales unit's operating system. |
| | |
|End Customer | A person who uses photo printing services through a sales unit, or views order data on the customer management website. |
| | |
|Wizard | The software that takes orders and initiates prints either locally or remotely. |
| | |
|Hardware Hub | The central control unit via which various hardware components can be addressed. This is used to read images from cameras, USB sticks or memory cards. The connection is made via USB and is standardized for all sales units. |
| | |
|Receipt Printer | A thermal printer used to print out receipts for orders that then have to be paid at a cash register. |
| | |
|Order Printer | FotoMaX can forward print orders directly to printers of the location provider and thus trigger immediate printing. Printers can be connected via USB or as network printers.|
| | |
|Pitch provider | An employee of the pitch provider who can view orders and check invoices. |
| | |
|Print provider | An employee of the print provider who can view and, if necessary, change job status and orders. | 
| | |
|Portal |The web portal that contains customer administration, order administration, and partner administration. |
| | |
|Job system | The external system of the respective print provider, to which jobs are forwarded. The connection varies greatly depending on the system and is therefore assumed in simplified form only as HTTPs. |

The hardware is connected to the Wizard via the API of the operating system during a standardized configuration process after the manufacturing of the units. Thus, no special protocols have to be considered. The only exceptions are order printers: when integrated as network printers, those have to be configured separately.

