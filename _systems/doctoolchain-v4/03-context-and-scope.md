---
title: Context and Scope
order: 3
---

docToolchain sits between documentation authors (human and AI) and their audiences.
Authors write AsciiDoc sources in a version-controlled repository; docToolchain processes these sources and delivers the output to readers.
In v4, LLM agents become first-class users of the system via daCLI's MCP server.

## Business Context

![Business context diagram: docToolchain v4 with authors, DevOps engineers, readers, LLM agents, ecosystem tools and external systems](../images/business-context.png)

| Communication Partner | Input to docToolchain | Output from docToolchain |
|---|---|---|
| Documentation Author | AsciiDoc source files, configuration (`docToolchainConfig.groovy`), CLI commands via `dtcw` | Generated HTML, PDF, DocBook, Reveal.js slides, microsite |
| LLM Agent (via daCLI) | MCP tool calls: `get_structure`, `get_section`, `search`, `update_section`, `insert_content` | Structured section content, metadata, validation results |
| Bausteinsicht | JSONC architecture models, draw.io diagram exports (PNG, PlantUML) | — (consumed as images/includes in AsciiDoc sources) |
| LLM-Prompts | Prompt-guided AsciiDoc output (arc42 chapters, ADRs, quality scenarios) | — (consumed as doc sources) |
| Atlassian Confluence | — | HTML pages with attachments, page hierarchy, labels |
| Atlassian Jira | Issues (via JQL queries), sprint data, custom fields | — |
| Enterprise Architect | UML diagrams (via COM automation, Windows only) | — |
| Git Repository | Commit history, contributor metadata | — |
| Structurizr | Architecture model (DSL files) | — |

## Technical Context

| External System | Protocol / Interface | Configuration |
|---|---|---|
| daCLI | MCP protocol via stdio. LLMs call 10 tools for document navigation, search, and modification. | `dacli-mcp --docs-root <path>` — points to docToolchain's `src/docs/` directory. |
| Atlassian Confluence | REST API v1 (Server/Data Center) or v2 (Cloud). HTTPS with Basic Auth or Bearer Token. | `confluence.api`, `confluence.credentials`, `confluence.spaceKey` in config |
| Atlassian Jira | REST API v3 (Cloud) or v1 (Server). HTTPS with Basic Auth or Bearer Token. | `jira.api`, `jira.credentials`, `jira.exports[].jql` in config |
| Enterprise Architect | COM automation via VBScript. Reads `.eap` / `.eapx` project files. | `exportEA.connection`, `exportEA.packageFilter` in config |
| Structurizr | File-based. Parses Structurizr DSL, renders to PlantUML. | `structurizr.workspace.filename` in config |
| Git | Local CLI (`git log`, `git shortlog`). No network access required. | `changelog.dir`, `changelog.cmd` in config |
| AsciiDoctor CLI | External tool (gem/brew/apt), auto-installed by `dtcw` in a pinned version (ADR-6). Processes AsciiDoc to HTML5, PDF, DocBook via CLI batch invocation. | `inputFiles`, `inputPath`, `outputPath` in config |
| Groovy Site Generator | Custom Groovy script replacing jBake. Reads AsciiDoc + Groovy SimpleTemplates, generates static HTML microsite. | `microsite.*` config section (backward-compatible with v3 jBake metadata headers) |
