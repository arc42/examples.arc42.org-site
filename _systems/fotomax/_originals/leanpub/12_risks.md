{pagebreak}

{#section-vii-12}
## VII.12 Risks & Technical Debt

{width="wide"}
| ID | Risk | Description | Effects | Countermeasures |
|--|---|---|---|---|
| R1 | Low test coverage in Wizard | The Wizard was implemented over a longer period of time without unit tests, focusing on UI tests instead. As a result, the test coverage is below 10%. | There are occasional errors in the production environment. The effort of manual tests is very high. | Manual tests have been greatly increased and a fixed release process must be run before each release, in which the processes in the wizard are completely tested once. Developers are given time for test automation and refactoring. Test coverage is checked automatically and is not allowed to fall below a certain threshold for modified code. |
| | | | |
| R2 | Porting the wizard to .NET 5 was not possible | June 2021 an attempt was made to port the wizard to .NET 5. This failed due to various reasons (see also Lessons Learned). For this reason, the wizard was initially only upgraded to .NET 4.8, which will not be compatible with newer .NET versions in the long run. | As time goes on, the Wizard will use obsolete technology that is no longer supported by Microsoft. | A new migration attempt has been planned for 2022. First the test coverage shall be increased, and unsupported components shall be replaced. |
| | | | |
| R3 | WPF does not allow platform independence | WPF is used as the front-end technology of the Wizard. The entire architecture of the Wizard is geared towards the use of WPF and thus replacement is not easily possible. | WPF mandates the use of Windows. The licensing costs for Windows are high compared to Linux distributions. The WPF add-on libraries used in the software hinder the actual compatibility to newer .NET versions. | The incompatible libraries are replaced. Then the application is migrated to a newer .NET version. Then the need for platform independence is re-evaluated. |
| | | | |
| R4 | No remote access | Sales units cannot be accessed remotely even in the Connected version. Access is restricted to the extent that they can only transfer their data to the portal or receive minor software updates for the wizard. This decision was made deliberately to prevent attacks from the Internet. | Logging is limited to log files only and is therefore no longer up to date. Remote support is not possible and service technicians are always forced to make changes to the system on site. Updates of the systems are limited to the wizard but not to windows, which presents security risk. | An evaluation of alternative procedures has already begun. Based on this, the entire handling of the sales unit and the contractual arrangements with partners could change. It is therefore unlikely that the problem will be resolved in the short term. |
| | | | |
| R5 | Global context for image exchange | All loaded images are kept in a static context class at runtime. |The logic to fill the context and empty it again after the end of a workflow is very complex. In the past, there were cases where customers saw other customers' images. This has been fixed but it must not happen again under any circumstances! |A restructuring of the image algorithms has top priority in the restructuring of the wizard. |
