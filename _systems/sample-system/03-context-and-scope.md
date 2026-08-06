---
title: Context and Scope
order: 3
---

_Placeholder content._ This section exists so the reading column, the table
styling and the wide-table overflow behaviour can be checked with something in
them.

## Business Context

| Partner | Input | Output |
|---|---|---|
| Reader | Opens an example from the dashboard | A complete arc42 documentation |
| Contributor | A directory of Markdown plus images | A published example, linked from the dashboard |
| Maintainer | Review of a pull request | Merge, or a request for the missing provenance |

## Technical Context

The site is a static build. There is no runtime, no database and no API — the
whole system is Jekyll turning a directory tree into HTML, and GitHub Pages
serving it.

> A documentation that describes a static site does not need a deployment
> diagram, and this one does not have one. Saying so is more useful than
> drawing a box labelled "web server".

Diagrams belong in `../images/` and are referenced relatively, so a system
directory stays movable:

```markdown
![Context diagram](../images/03-context.png)
```
