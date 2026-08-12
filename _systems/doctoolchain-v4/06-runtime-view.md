---
title: Runtime View
order: 6
---

The v4 runtime is significantly simpler than v3: no Gradle daemon, no build graph, no dependency resolution. Tasks are individual script invocations.

## Scenario 1: Generate HTML Documentation

![Sequence diagram: dtcw invokes generateHTML.groovy, which renders AsciiDoc via AsciiDoctor](../images/runtime-generatehtml-v4.png)

**Key differences from v3**: No Gradle overhead and no Gradle daemon. AsciiDoctor runs *embedded* as AsciidoctorJ in the same JVM (ADR-6, revised — the external-CLI option was evaluated but not adopted), so JRuby still initialises in-process on the first render. The Groovy script invokes AsciidoctorJ directly for all `inputFiles`. Startup is JVM cold start plus JRuby/AsciidoctorJ initialisation (~1-2s combined).

## Scenario 2: Publish to Confluence

![Sequence diagram: publishToConfluence.groovy checks page hashes and creates or updates Confluence pages via the REST API](../images/runtime-confluence-v4.png)

**Key difference from v3**: The user runs `generateHTML` and `publishToConfluence` as separate, explicit commands. There are no implicit task dependencies — each script is self-contained. This matches real-world usage: users rarely chain tasks automatically.

## Scenario 3: LLM Modifies Documentation via daCLI

![Sequence diagram: an LLM agent navigates, searches and updates documentation sections through the daCLI MCP server](../images/runtime-llm-v4.png)

**This is a new v4 scenario.** The LLM navigates a 50-page documentation project using ~10k tokens instead of the ~100k tokens needed to read all files. daCLI maintains an in-memory index for O(1) lookups. Optimistic locking (hash comparison) prevents concurrent modification conflicts.

## Scenario 4: Generate Microsite

![Sequence diagram: generateSite.groovy builds an in-memory content model, converts AsciiDoc pages and applies Groovy SimpleTemplate templates](../images/runtime-site-v4.png)

**Key difference from v3**: No jBake library, no OrientDB content database. The site generator is a Groovy script that reads files, builds an in-memory model, applies Groovy SimpleTemplate templates, and writes static HTML. Runs on all platforms including Apple Silicon (QS-10).

## Scenario 5: Error and Recovery — Publish Fails with HTTP 401 / Locked File

This scenario exercises the error-handling path, not the happy path. It shows how the `DtcException` hierarchy (ADR-8, Chapter 8.5 Error Handling) turns a failure into an actionable message and a differentiated exit code (QS-17).

![Sequence diagram: a locked output file or an HTTP 401 raises a DtcException, and dtcw prints only the guidance message with a differentiated exit code](../images/runtime-error-recovery-v4.png)

**Recovery behaviour**: A locked output file raises a `DtcException` (exit code 1); an HTTP 401 raises a `DtcApiException` (exit code 3). In both cases the top-level handler prints only the guidance message — what the user must do (close the file, fix the credentials) — and suppresses the stack trace. CI/CD distinguishes a config/credential problem (exit 3) from a user-fixable local issue (exit 1) without parsing logs. This realises quality goal #4 (Actionable error guidance, QS-17) and the Chapter 8.5 Error Handling concept; the exception hierarchy and exit-code table are defined in ADR-8.
