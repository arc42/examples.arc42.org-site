{pagebreak}

{#section-vii-4}
## VII.4 Constraints

This chapter describes the constraints and requirements that limit software design, implementation or the development process.

{#section-vii-4-1}
### Organizational Constraints

The company basically has two main products that are customized depending on the business partner in terms of features, workflows and graphical assets (→[VII.5.1](#section-vii-5-1)).

{width="wide"}
|**Start of development**  | _Wizard:_ 07.2010 _Portal:_ 03.2018|
| | |
|**Team Wizard** | Five members, responsible for the implementation, adaptation and customizing of the software for the end-customer approach on the sales units. |
| | |
|**Team Connect** | Four members, responsible for processing, forwarding and accounting of orders. |
| | |
| **Team Portal** | Eight members, responsible for the portal solution where customers can view their orders and partners can view their commissions. |
| | |
|**Team Data** | Two members, responsible for the analysis and preparation of the accruing data for partners and for product maintenance. |
| | |
|**Wizard Installations** | Approx. 250 in different versions|
| | |
|**Customers** | Approx. 60 different pitch providers, approx. five different print providers, approx. 12 000 registered end users _(December 2022)_|

{pagebreak}

{#section-vii-4-2}
### Technical Constraints
* **Technologies Used:**
  * **Wizard:** .NET 4.8, C#, WPF
  * **Portal:** .NET 6, C#, Angular 11, NServiceBus for internal communication between services
* **Runtime Environment:**
  * **Wizard:** Windows 10, SQLite
  * **Portal:** Windows Server 2019, SQL Server 2019
* **Release Cycles:**
  * **Wizard:** About once every two to six months, depending on the partner, over the air.
  * **Portal:** Approx. every two weeks
Technische Besonderheiten:
  
**Note:** 40 Wizard instances from before 2015 do not have a remote update capabilities, and must be updated by a service engineer until 2025. After that, the maintenance contracts expire, forcing the customer to upgrade to a remote-enabled version.

{#section-vii-4-3}
### Conventions
* Code
  * The coding guidelines are located in [VII.14.2.1.](#section-vii-14-2-1)
* Test 
  * The testing guidelines are located in [VII.14.2.2.](#section-vii-14-2-2)
* Review
  * The review guidelines are located in [VII.14.2.3.](#section-vii-14-2-3)