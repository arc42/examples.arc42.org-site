{pagebreak}

{#section-vii-6}
## VII.6 Solution Strategy

The Wizard was implemented in 2010 as a monolith, based on the .NET Framework and Windows Presentation Foundation. After a comprehensive architecture review, it was decided in 2019 to restructure it as a modulith. 

Since FotoMaX is a white label solution, this base application is heavily customized depending on the partner. Thus, while there are software modules that apply to all pitch providers, there are also some that are loaded only for specific providers.

This chapter explains both the associated base application and the migration strategy, which describes how the previous monolith is transformed into a modulith.

### The Modulith

#### Basic Design

As a basis for the modulith, a framework application was created based on the Prism Framework (→[VII.11.4](#section-vii-11-4)), which provides general features for central services such as user administration, settings management, etc.

{width="70%"}
![](images/fotomax/chapter6/modulith.png)

#### Module Design

A module, in the sense of a modulith, is a collection of functionalities with the same concerns. Within a module, the technical layers are separated from each other via interfaces. Modules can also use the functionality of other modules via interfaces. Dependencies between modules are monitored by static code analysis, to avoid harmful dependencies and complex dependency trees. The architecture distinguishes between two types of modules: Workflow modules and Service modules.

**Workflow Modules**: These are central modules that map domain specific processes and workflows. As a rule, they also have more complex user interfaces that are implemented as a workflow within the wizard.

**Service Modules:**: These are modules that add specific functionality to the workflow. These include, for example, assets of the respective customer such as logos, color designs, etc.; but also include functions that can change depending on the characteristics of the sales unit.

{width="90%"}
![](images/fotomax/chapter6/modulecommunication.png)

#### Module Integration

The kernel integrates the modules into the application during a bootstrapping process. The modules can access central interfaces, and they have a root element that is called by bootstrapper to control their initialization. Modules are strictly prohibited from accessing the concrete implementation of either other modules or any central services. Rather, they have to request all services via dependency injection, using constructor injection, meaning that the service interfaces are injected as parameters into the module constructors.

{width="90%"}
![](images/fotomax/chapter6/modulith-structure.png)


### Migration Strategy

In 2019, the architecture of the Wizard had a highly coupled structure, with neither functional nor technical layering. The following diagram depicts this situation by using the same colors for components with the same responsibility, while the different sizes and distributions to represent the unstructured nature of the system.

![](images/fotomax/chapter6/current-architecture.png)

To decompose the monolith, first the various responsibilities within the codebase are assessed. Then a strategic decomposition is prepared, and a frame application is created, that can incorporate the modules.

![](images/fotomax/chapter6/legacy-to-new.png)

Subsequently, the Legacy Wizard is included as a closed module in the frame application, so that the startup is no longer performed by the Legacy Wizard, but by the kernel of the frame application.

![](images/fotomax/chapter6/first-module.png)

Based on the strategic considerations, the next step is to prioritize a business or technical context, and extract the associated components into a separate module, by extracting its public access points to an abstract interface layer. This interface layer is then referenced in the legacy code while its logic is restructured.

![](images/fotomax/chapter6/finished-migration.png)

This procedure is continued until either the entire Wizard is disassembled, or only such components are left for which restructuring is not worthwhile.
