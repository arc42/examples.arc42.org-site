---
title: Quality Requirements
order: 10
---

(for a brief overview of quality requirements, please see [section 1.2.2](../01-introduction-and-goals/)).

## Flexibility Scenarios

|ID |Scenario |
|---|---------------------------|
|F1 |New CSV import format shall be configurable at CCT  within 2 hours. |
| | |
|F2 |New fix-field import format shall be configurable at CCT within 2 hours. |
| | |
|F3 |New XML based import format shall be configurable at CCT within 2 hours. |
| | |
|F4 |New CSV export format shall be configurable at CCT within 2 hours. |
| | |
|F5 |New fix-field export format shall be configurable at CCT within 2 hours. |
| | |
|F6 |New XML based export format shall be configurable at CCT within 2 hours. |

**CCT**: Campaign configuration time

In all cases we require both a documentation of the desired format, plus a minimum
of 10 different test data records.

## Runtime Performance Scenarios

|ID |Scenario |
|---|---------------------------|
|P1 |Import and fully process 250.000 scanned documents (including images) within 24hrs. That's an average processing rate of approximately 3 complete documents per second. Import format will be a combination of csv file plus images as single files.|
| | |
|P2 |Import and fully process 100.000 records of csv file within 30 minutes |
| | |

## Security Scenarios

|ID |Scenario |
|---|---------------------------|
|S1 |Client and campaign data from one mandator shall never be accessible for another mandator. |
| | |
|S2 |MaMa is required to preserve all incoming data from mandators and partners for the appropriate timeframe (usually 90-180 days after the end of a campaign). Such archived data (e.g. files or messages) needs to be made completely accessible for an auditor or inspection within 90 minutes at most.  |
| | |
|S3 |In case campaigns involve financial data of clients (e.g. credit card, bank account or similar information), these have to be processed and managed compliant to [PCIDSS](https://en.wikipedia.org/wiki/Payment_Card_Industry_Data_Security_Standard) regulations.
