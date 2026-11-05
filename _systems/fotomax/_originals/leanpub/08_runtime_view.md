{pagebreak}

{#section-vii-8}
## VII.8 Runtime View

All dynamic relationships that are to be highlighted are described in the runtime view chapter.

{#section-vii-8-1}
### Application frame: Steps of the module initialization

Below is the sequence that is run through during program startup for each module to initialize itself and its managed components.

![](images/fotomax/chapter8/activity-initialization-order-management.png)

Not every type has to be initialized by the module itself. This is only necessary for module components which actually require a special initialization. The component initialization should happen here if possible asynchronously around the start not to hinder.

{#section-vii-8-2}
### Order Management: Initialization

Like any other module, the Order Management is initialized during the program start. Depending on whether the Wizard is operated in standalone or connected mode, a different procedure for the order process has to be chosen. The following image shows the processes, that have to be executed during the initialization of the workflow module to load the correct components.

![](images/fotomax/chapter8/module-initialization.png)

Note: The same document printer is always installed in the sales unit, therefore it can be decided via the selection of a template whether a remote order or a local order is to be issued.