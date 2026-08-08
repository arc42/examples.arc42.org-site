---
title: Context and Scope
order: 3
---

The context view delimits the system from all its neighbouring systems and thereby
fixes the essential external interfaces.

## 3.1 Business Context

![Business context of the M&M migration system](../images/03-business-context.png)

### Brief Description of the External Interfaces

| Interface | Description | Technology |
|---|---|---|
| VSAM data | Four kinds of data (person data, address data, bank data, account data) | Tapes, LTO-1, see [section 3.3](#33-overview-of-the-input-data-interfaces). |
| Migrated data | According to the object model produced by KOUSYNE[^kousyne] | The object graph is handed over via a session bean |
| Reports, statistics | During the migration: continuous output of the number of persons migrated. After the migration: output of the number of error records | Console |

[^kousyne]: KOUSYNE is the parallel project building the new Java account system that M&M migrates *into*. The original text introduces the name here without explanation.

*Note on the external interfaces:* in agreement with the client, the error
database that has to be built is treated as an **internal** interface.

## 3.2 Technical (Deployment) Context

The migration will run on two separate servers: a migration server for the actual
data migration and for executing the technical and business transformations, and
a second one as the database server.

The new system (not shown in the figure) will access the database created by the
migration directly. The migration server therefore has to know the future class
and table model.

![Deployment context: mainframe, tapes, migration server, database server](../images/03-deployment-context.png)

## 3.3 Overview of the Input Data (Interfaces)

All input data is delivered on individual LTO-1 tapes, one per kind of data. Each
of these tapes holds up to 100 gigabytes. The exact volume of data cannot be
specified in advance, because of technical limitations at Fies und Teuer AG.

| Input data | Description |
|---|---|
| Account data | Despite the name, this tape holds the posting and transaction data for all accounts. Variable record format with 5–25 fields, according to FT record type 43. |
| Person data | Master data of the persons and organizations (companies, clubs, foundations, public authorities) served by Fies und Teuer AG. Variable record format with 15–50 fields, according to FT record type 27. |
| Address data | Address and postal data, including information about authorized recipients, town and street details, and details of main and secondary addresses (head offices, branches) for organizations and companies. Variable record format with 5–40 fields, according to FT record type 33. Several records per person are possible. |
| Bank data | Data of external banks (reference accounts and contra accounts of the persons and organizations). Fixed record format, but several records per person are possible. |
