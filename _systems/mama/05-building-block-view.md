---
title: Building Block View
order: 5
---

## 5.1 MaMa Whitebox Level 1

![MaMa Whitebox (Level1 )](../images/5-MaMa-Level-1.png)

**Rationale**:
The structure of building blocks within MaMa is based upon _functional decomposition_ and the concept of _generated persistence_ (see [section 8.1](../08-crosscutting-concepts/)).

**Contained Blackboxes:**

|Element       |Description                                 |
|--------------|--------------------------------------------|
|Import Handler |Imports data from Partners or Mandator via external interfaces |
| | |
|--------------|--------------------------------------------|
|Export Handler|Exports data to Partners or Mandator via external interfaces |
| | |
|--------------|--------------------------------------------|
|Configuration  |Maintains configuration of all import- and export activity types, import- and export filters and campaign business rules. Includes syntax driven editors for configuration. |
| | |
|--------------|--------------------------------------------|
|Reporting |Reports campaign state to Mandator and Partners, as configured. |
| | |
|--------------|--------------------------------------------|
|Process Control |Responsible for management and execution processes within a campaign, especially for execution of campaign specific business rules. |
| | |
|--------------|--------------------------------------------|
|Campaign Data Management |Completely generated. Stores all client- and campaign data.|
| | |
|--------------|--------------------------------------------|
|Operations Monitoring |Monitors (and reports) all import and export processes plus database and application state.|
| | |
|--------------|--------------------------------------------|
|Code Generator |Generates the (complete) `CampaignDataManagement` from a campaign specific UML model. See [persistence concept](../08-crosscutting-concepts/) for details. |  
|--------------|--------------------------------------------|

### Import Handler (Blackbox)

**Intent/Responsibility:** `Import Handler` contains the core functions
to imports data from Partners or Mandator via external interfaces. It handles
csv, fix-format or xml input, either or both encrypted and compressed of configurable
structure.

**Interfaces:**

|Interface (From-To) | Description        |
|----|-----------------------------------------------|
|`getImportConfig`  |Read all required configuration information to perform imports, especially details about data structures (like csv formats) and filter chains. |
| | |
|---|-----------------------------------------------|
|`storeClient` |Sends an imported instance of `Client` to `CampaignDataManagement` to be either updated or inserted. |
| | |
|----|-----------------------------------------------|
|`tryImport`(from `ProcessControl`) |ProcessControl either calls or schedules a specific imports activity. |
| | |
|----|-----------------------------------------------|
|`ImportHandler` -> external port |ImportHandler needs to access various external entities, like ftp server, file system or even remote access to Mandator or Partner hosts.  |

**Quality of Service:**

ImportHandler implements extensive failure handling mechanisms and can therefore deal
with a large number of error categories (e.g. communication errors, data format errors,
  compression and encryption issues and so forth.)

**Details:**

For details see the [Import Handler (Whitebox)](../05-building-block-view/).

### Configuration (Blackbox)

**Intent/Responsibility:** `Configuration` is responsible to provide deploy-time flexibility
to all MaMa subsystems. It handles the following kinds of configuration information:

* Data import and export configuration
  * csv, fix-format and xml formats
  * transmission and routing information, endpoints, network configuration
  * configuration for compression, encryption and similar filter operations
  * account and security information required to communicate with the campaign-specific
  external systems.

* Campaign configuration
  * validation rules
  * activities: what kind of imports, exports and maintenance activities are required for this campaign?
* Configuration for archiving of imported data

**Interfaces:**

* For all configuration methods, the campaignID and mandatorID need always be input parameters.
* Configuration information is always subclass of the (abstract) superclass `Configuration`.

|Interface (From-To) |Description |
|----|-----------------------------------------------|
|`getImportConfig` |Methods to get import configurations for a specific campaign. |
| | |
|`getExportConfig` |Methods to get export configurations for a specific campaign.  |
| | |
|`getCampaignConfig` | |
| | |
|`store/retrieveConfig` |Calls DataManagement to store/retrieve configuration data. |

**Quality of Service:**
(not documented)

## MaMa Level 2

### Import Handler (Whitebox)

![](../images/5-importHandler.png)

**Rationale**: This is (again) based upon _functional decomposition_ of the
generic import process. [Section 6.1](../06-runtime-view/)
describes the runtime behavior of this component.

**Contained Blackboxes:**

|Element|Description|
|-|---|
|`Receiver` |Receives data from partners or mandators via the ImportData port.|
| | |
|`ImportErrorHandler` |Handles the various possible errors during import. With severe errors, import is stopped. Many (especially record or object level) errors are recoverable - these will be logged, eventually the administrator is notified. |
| | |
|`ImportData` (Port) |Connection to the outside world - via ftp and http, usually transmitted via VPN. |
| | |
|`FileArchiver` |Non-erasable archive where all imported files are kept for auditability. |
| | |
|`FileFilter` |Various filter operations, like decrypt, unzip etc. Explained in the [filter concept in section 8](../08-crosscutting-concepts/) |
| | |
|`Validator` |Checks files, records (collections of strings) and client objects for validity. |
| | |
|`UnMarshaller` |Creates Java objects from collections of strings by using reflection magic. You don't want to know all the dirty details of this component. |
| | |

**Important Interfaces:**

Not documented.

## MaMa Level 3

### Receiver (Whitebox)

![](../images/5-receiver-level-3.png)

**Rationale**: We have to admit that this structure just evolved out of a number of prototypes.
A more functional oriented design would most likely improve understandability, but we
never refactored the code into that direction due to different priorities.

**Contained Blackboxes:**

|Element|Description|
|-|---|
|`Directory` or `WebService` or `Message` - `Listener` |Components that listen for input of specific kinds, e.g. the `DirectoryListener` watches for new files to appear in certain directories, (configurable) either in a local or remote file system.|
| | |
|`FileProcessor` |Completely handles input files, calls all required operations to be performed on the file (archive, unzip, decrypt etc.). A big mess of spaghetti code - you don't want to look at it... |
| | |
|`FileToRecordSplitter` |Depending on configuration, creates a collection of records from the imported file. Most often a record is represented by a single row/line within the file, but sometimes several lines from the file have to be combined. |
| | |
