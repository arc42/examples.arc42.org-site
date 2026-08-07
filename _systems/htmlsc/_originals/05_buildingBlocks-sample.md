{pagebreak}

{#section-ii-5}
## II.5 Building Block View

A>##### Content and Motivation
A>
A>The building block view explains the static decomposition of the system into building blocks
A>(modules, components, subsystems, packages...) and their relationships. It shows the overall
A>structure of the source code.
A>
A>This view is organized in a top-down hierarchy.


### 5.1 Whitebox HtmlSanityChecker

{width="80%"}
![Whitebox (HtmlSC)](images/htmlsc/5-whitebox-hsc-level-1.png)


**Rationale:** We used _functional decomposition_ to separate responsibilities:

* `HSC Core` shall encapsulate checking logic and HTML parsing/processing.
* `Plugins` and `GraphicalUI` encapsulate all _usage_ aspects

**Contained Blackboxes:**


|Building block | Description    |
|-------|:------|
| `HSC Core`   |HTML parsing and sanity checking |
|-------|------|
| `HSC Gradle Plugin` |Exposes HtmlSC via a standard Gradle plugin, as described in the [Gradle user guide](https://docs.gradle.org/current/userguide/userguide.html). Source: Package `org.aim42.htmlsanitycheck`, classes: `HtmlSanityCheckPlugin` and `HtmlSanityCheckTask`
|-------|------|
| `NetUtil`    |package `org.aim42.inet`, checks for internet connectivity, configuration of http status codes     |
|-------|------|
| `FileUtil`  |package `org.aim42.filesystem`, file extensions etc. |
|-------|------|
| HSC Graphical UI   |(planned, not implemented)                      |
|-------|------|


{pagebreak}




W> The full book contains a much more extensive description of
W> the building blocks of HtmlSC...
