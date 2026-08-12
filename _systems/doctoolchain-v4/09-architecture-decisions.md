---
title: Architecture Decisions
order: 9
---

All architecture decisions are evaluated against the quality scenarios defined in the Quality Requirements section.
docToolchain v4 represents a fundamental shift: from a Gradle-based build tool to an LLM-native docs-as-code platform.
v3 is the current production version.

The ADRs themselves live in the register at `src/docs/arc42/adrs/` and are included below.
Statuses follow Nygard values (Proposed / Accepted / Superseded / Deprecated). `Accepted (inferred)` marks decisions whose rationale was reconstructed from the codebase (carried forward from v3).

| ADR | Title | Status |
|---|---|---|
| ADR-1 | Use Groovy as Primary Scripting Language | Accepted (inferred) |
| ADR-2 | Separate Core Logic from Gradle | Superseded by ADR-3 |
| ADR-3 | Remove Gradle — Direct Groovy Script Execution | Accepted (for v4) |
| ADR-4 | Replace jBake for Static Site Generation | Accepted (for v4) |
| ADR-5 | LLM-Native Architecture | Accepted (for v4) |
| ADR-6 | AsciiDoctor as External Tool with Versioned Auto-Installation | Accepted (for v4) — revised (AsciidoctorJ embedded) |
| ADR-7 | `lib/` Directory for Remaining Java Dependencies | Accepted (for v4) |
| ADR-8 | Actionable Error Guidance | Accepted (for v4) — carrier pending (R-004) |
| ADR-9 | Server-Based Diagram Rendering via Kroki-Compatible API | Accepted (for v4) — not yet implemented (R-007) |
| ADR-10 | Risk-Based Quality Assurance (Vibe-Coding Risk Radar) | Accepted |
| ADR-11 | Tier 2 Mitigation Implementation | Accepted |
| ADR-12 | Tasks Are Self-Contained Groovy Scripts — No Compiled Core Module at Runtime | Accepted (port pending) |
| ADR-13 | `dtcw4` → `dtcw` Wrapper Delegation | Accepted (inferred) |
| ADR-14 | Task Discovery via `// @task` Marker | Accepted (inferred) |
| ADR-15 | Structural Diagrams as Architecture-as-Code (Bausteinsicht model, PlantUML render) | Accepted (for v4) — export wiring deferred |
| ADR-16 | Project-Local Tasks — Custom Tasks and Monkey-Patching | Accepted (for v4) |
| ADR-17 | `dtc.scriptsHome` — Resolve `lib/` Helpers from the Installation | Accepted (for v4) |
| ADR-18 | v4 Task Dispatch Moves into a Groovy Launcher | Accepted (for v4) |
| ADR-TBD-1 | Confluence API Version Strategy | Proposed |
| ADR-TBD-2 | Jira Cloud vs. Server Client Architecture | Proposed |

## ADR-1: Use Groovy as Primary Scripting Language

* **Status**: Accepted (inferred) — carried forward from v3, rationale reconstructed from the codebase
* **Context**: docToolchain uses scripts in multiple languages. The team needed a consistent primary language for maintainability.
* **Decision**: Use Groovy for all scripting tasks. Exception: Visual Basic for Windows COM automation (Enterprise Architect, PowerPoint export) where no Java library exists.
* **Alternatives considered**:

| Criterion | Groovy | Kotlin (script) | Plain Java |
|---|---|---|---|
| No compilation step (QS-11) | +1 (runs as script) | 0 (kotlinc startup is slow) | –1 (requires compile) |
| Java interop / ecosystem reuse | +1 (seamless) | +1 (seamless) | +1 (native) |
| Contributor friendliness (QS-1) | +1 (forgiving, dynamic) | 0 (stricter, less known here) | –1 (verbose, ceremony) |
| Config DSL (`ConfigSlurper`) | +1 (built-in) | –1 (no equivalent) | –1 (none) |
| Existing codebase fit | +1 (already Groovy) | –1 (full rewrite) | 0 (partial) |
| **Total** | **+5** | **–1** | **–3** |

* **Quality Tradeoffs**:
  * Supports **QS-1 (Extensibility)**: Contributors need only one language to extend the system.
  * Supports **QS-2 (Portability)**: Groovy runs on the JVM, same bytecode on all platforms.
  * Supports **QS-11 (Script-first)**: Groovy scripts run without compilation.
  * Compromises **QS-2 (Portability)** partially: VBScript exceptions limit some features to Windows.

## ADR-2: Separate Core Logic from Gradle — SUPERSEDED

* **Status**: Superseded by ADR-3
* **Context**: ADR-2 proposed isolating business logic into a compiled `core/` submodule (Shadow JAR) to decouple from Gradle.
* **Superseded because**: v4 removes Gradle entirely (ADR-3) and reverts to scripts as the primary code organization. Compiled code requires a build step that slows the edit-run cycle. Scripts are easier to adapt and maintain, especially for community contributors. The problem ADR-2 tried to solve (Gradle coupling) is better addressed by removing Gradle, not by adding a compilation layer.

## ADR-3: Remove Gradle — Direct Groovy Script Execution

* **Status**: Accepted (for v4)
* **Context**: Gradle has been the task orchestration framework since docToolchain's inception. Over time it has caused significant problems:
  * Slow startup (~95 seconds first run, 10-15 seconds subsequent runs)
  * Complex configuration hard for contributors to understand
  * Tight coupling between business logic and build system
  * Gradle daemon management issues (zombie processes, port conflicts)
  * Dependency resolution overhead for simple documentation tasks
* **Decision**: Remove Gradle entirely. The `dtcw` wrapper invokes Groovy scripts directly via the `java`/`groovy` runtime. AsciiDoctor is an external CLI tool, auto-installed by dtcw (ADR-6). Task orchestration is handled by simple script conventions, not a build framework.
* **Alternatives considered**:

| Criterion | Keep Gradle | dtcw + Groovy direct | Switch to Maven | Custom task runner |
|---|---|---|---|---|
| Startup time | –1 | +1 | 0 | +1 |
| Contributor friendliness | –1 | +1 | 0 | 0 |
| Ecosystem compatibility | +1 | 0 | +1 | –1 |
| Maintenance burden | –1 | +1 | 0 | 0 |
| LLM-friendliness | –1 | +1 | –1 | +1 |
| **Total** | **–3** | **+4** | **0** | **+1** |

* **Quality Tradeoffs**:
  * Supports **QS-9 (Fast startup)**: No Gradle wrapper, no daemon, no dependency resolution. Startup under 3 seconds.
  * Supports **QS-11 (Script-first)**: Scripts are the primary code artifacts, no compilation needed.
  * Supports **QS-1 (Extensibility)**: Adding a feature requires no build system knowledge.
  * Supports **QS-3 (Usability)**: Simpler mental model for contributors.
  * Risk on **QS-14 (v3 compatibility)**: v3 projects using `./gradlew` directly will need to switch to `./dtcw`. The `dtcw` interface remains stable.
* **Consequences**: `build.gradle`, `settings.gradle`, `gradle.properties`, `libs.versions.toml`, and the `gradle/` wrapper directory are removed. The `core/` module is dissolved back into scripts. Dependencies are managed as JARs in a `lib/` directory or downloaded on demand. This decision creates risk *R-002 (v3 migration path)* — Gradle-based workflows break — and *R-003 (script loading and classpath conflicts)* now that Gradle no longer resolves dependencies; both are tracked in the Risks and Technical Debt section.

## ADR-4: Replace jBake for Static Site Generation

* **Status**: Accepted (for v4) — implemented in v4.0 as `MicrositeBaker` (`scripts/lib/MicrositeBaker.groovy`, see Chapter 8)
* **Context**: jBake is the current static site generator for docToolchain's microsite feature. Critical problems:
  * **Unmaintained**: Governance crisis (Issue #785). PRs not reviewed. v2.7.0 not published to Maven Central.
  * **Apple Silicon**: Does not run on modern Macs without workarounds (OrientDB JNI issue #709). Fix exists but is not released.
  * **Java 21 incompatible**: Bundled Groovy too old for JDK 21 class files (Issue #797).
  * **Heavy**: OrientDB adds 38MB of JARs for a database that could be an in-memory list.
  * **Best available fork**: rschwietzke/jbake removes OrientDB + upgrades to Java 21 (PR #800), but is stuck waiting for review.
* **Decision**: Build a custom Groovy-based static site generator using Groovy SimpleTemplate. The core requirement is: AsciiDoc files + templates -> static HTML site with navigation, search, and theming.
* **Alternatives considered**:

| Criterion | jBake Fork (rschwietzke) | Custom Groovy SSG |
|---|---|---|
| Groovy template reuse | +1 | +1 |
| Stack consistency | 0 (external Java project) | +1 (own code) |
| Maintenance control | 0 (dependent on fork maintainer) | +1 (full control) |
| Apple Silicon | +1 (fork removes OrientDB) | +1 |
| Implementation effort | +1 (fork exists, PR #800) | –1 (must be developed) |
| Dependency footprint | –1 (jBake + ~15 JARs) | +1 (no additional JARs) |
| Future-proofing (Phase 2 LLM UI) | –1 (jBake rendering pipeline limits control) | +1 (full control over HTML output) |
| Gradle independence | –1 (needs custom runner or jBake Java API) | +1 (pure Groovy script) |
| **Total** | **0** | **+5** |

> **Note:** With AsciiDoctor externalized (ADR-6), the custom SSG only needs to handle template rendering and content model — AsciiDoc processing is done by the external AsciiDoctor CLI. This reduces the estimated effort to ~300 LOC of new code. Metadata parsing (~50 LOC) and menu builder (167 LOC) are reused from v3's `generateSite.gradle` and `menu.groovy`.

* **Quality Tradeoffs**:
  * Supports **QS-10 (Apple Silicon)**: No OrientDB, no JNI issues.
  * Supports **QS-13 (Modern UI)**: Full control over output HTML enables modern theme.
  * Supports **QS-11 (Script-first)**: Generator is a Groovy script, not a compiled plugin.
  * Risk on **QS-8 (Performance)**: Must match jBake generation speed (~5s for typical sites).
  * Risk on **QS-14 (v3 compatibility)**: Must support jBake metadata headers (`:jbake-title:`, `:jbake-type:`) for backward compatibility.
* **Consequences**: Existing 23 Groovy SimpleTemplate files can be reused with minimal changes. The custom SSG parses AsciiDoc metadata (`:jbake-*:` attributes) itself — a simple regex pass over file headers (~20 LOC, reused from v3's `generateSite.gradle`). AsciiDoctor CLI handles HTML rendering (ADR-6). No database — in-memory content model. Modern UI theme replaces Docsy (Phase 1: modern look; Phase 2: LLM-augmented UI in future version). This decision creates risk *R-001 (custom site generator maturity)* — feature-parity and regression risk — tracked in the Risks and Technical Debt section.

## ADR-5: LLM-Native Architecture

* **Status**: Accepted (for v4)
* **Context**: The GenAI era changes how documentation is created and consumed. Traditional export scripts (EA, PPT, Visio, Excel) address a workflow where humans manually extract data from tools. LLMs can handle these transformations directly. Meanwhile, LLMs need structured document access (daCLI) and benefit from Skills, Prompts, and Semantic Anchors.
* **Decision**: Shift docToolchain's strategic focus toward LLM-native tooling:
  * **daCLI integration**: MCP server for structured document access (10 tools, already operational)
  * **Semantic Anchors and Contracts**: Precise reference terms (anchors like "arc42", "SOLID", "Docs-as-Code") and bundled working agreements (contracts in `CLAUDE.md`) that enable consistent LLM collaboration without verbose instructions
  * **Skills and Prompts**: Reusable LLM interaction patterns for documentation tasks (arc42 generation, ADR creation, quality scenario extraction — see LLM-Prompts repository)
  * **Bausteinsicht integration**: Architecture-as-code with JSONC models and bidirectional draw.io sync — LLMs read/write JSONC natively
* **Quality Tradeoffs**:
  * Supports **QS-12 (LLM Friendliness)**: Structured document access via MCP. Semantic Anchors and Contracts enable precise, consistent LLM communication.
  * Supports **QS-1 (Extensibility)**: New capabilities can be added as Prompts/Skills without code changes.
  * Supports **QS-3 (Usability)**: LLMs lower the barrier to creating quality architecture documentation.
* **Consequences**: Existing scripts remain available but strategic investment shifts to MCP tools, Prompts, and Semantic Anchors. The docToolchain ecosystem becomes: docToolchain (generation) + daCLI (LLM access) + Bausteinsicht (architecture diagrams) + LLM-Prompts (interaction patterns). Traditional scripts are maintained but not the primary growth area.

## ADR-6: AsciiDoctor as External Tool with Versioned Auto-Installation

* **Status**: Accepted (for v4) — **revised**: the analysis below favoured the external CLI, but v4 as built **embeds AsciidoctorJ in-process** (the external-CLI option was *not* adopted). See the *Revision* note after the matrix; the footprint consequences are reflected in ADR-7 and Chapter 11.
* **Context**: In v3, AsciiDoctor is embedded as `asciidoctorj` — a Java wrapper that bundles JRuby (~30 MB). Together with transitive dependencies, this adds ~25 JARs and ~45 MB to the classpath. JRuby initialization adds 2-3 seconds to every startup. AsciiDoctor also exists as a standalone CLI tool installable via `gem`, `brew`, or `apt`.
* **Decision**: Use AsciiDoctor as an external tool, auto-installed by `dtcw` in a pinned version. This follows the same pattern as Java auto-installation. AsciiDoctor CLI supports batch processing (`asciidoctor *.adoc`), so 50 files are handled in one process invocation.
* **Alternatives considered**:

| Criterion | Library (asciidoctorj) | External Tool | Both (fallback) |
|---|---|---|---|
| Startup overhead (QS-9) | 0 (2-3s JRuby init) | +1 (no JRuby) | +1 |
| Throughput 50 pages (QS-9) | 0 | 0 (batch mode) | 0 |
| First-run experience (QS-3) | +1 (bundled) | 0 (auto-installed by dtcw) | 0 |
| Distribution size (QS-6) | –1 (+45 MB) | +1 (0 MB) | 0 |
| Offline capability (QS-2) | +1 (always available) | 0 (offline after install) | +1 |
| Determinism (QS-4) | +1 (exact JAR version) | 0 (dtcw pins version) | 0 |
| Docker compatibility (QS-2) | 0 | 0 | 0 |
| Apple Silicon (QS-10) | 0 | 0 | 0 |
| Solution complexity | 0 | 0 | –1 (two code paths) |
| **Total** | **+2** | **+2** | **+1** |

At equal score, **QS-9 (Startup + Throughput) is Quality Goal #1** and breaks the tie in favor of the external tool. The –1 for First-Run and Determinism in the raw external-tool score are eliminated by `dtcw` auto-installing a pinned version.

> **Revision — embedded AsciidoctorJ was chosen, not the external CLI**
>
> v4 as built **embeds AsciidoctorJ in-process** (`generateHTML.groovy` imports `org.asciidoctor.Asciidoctor` and calls `Asciidoctor.Factory.create()`; `lib/` ships `asciidoctorj-*.jar` and `jruby-*.jar`). The external-CLI decision above was reversed during implementation because the *Library* column wins on the criteria that turned out to matter most in practice:
>
> * **First-run / determinism (QS-3/QS-4):** no `gem`/Ruby toolchain to install or pin per machine — the exact renderer ships in `lib/`.
> * **Apple Silicon / portability (QS-10):** a single bundled JVM artifact, no native gem builds.
> * **Bundled diagram support:** AsciidoctorJ carries `asciidoctor-diagram`, so diagrams render without a separate tool (see ADR-9).
>
> The cost is the footprint and startup the matrix scored against the Library: JRuby adds ~1-2s to first render, and the `asciidoctorj`/`jruby` JARs stay in `lib/` (~49 MB). That cost is recorded honestly in **ADR-7** (real footprint: 177 JARs / ~126 MB) and as technical debt in **Chapter 11**. Re-externalising AsciiDoctor to reclaim the footprint remains an option for a future version.

* **Quality Tradeoffs**:
  * Supports **QS-9 (Startup + Throughput)**: No JRuby overhead. Batch processing for multiple files.
  * Supports **QS-6 (Installability)**: Distribution 45 MB smaller. AsciiDoctor installed automatically on first use.
  * Neutral on **QS-4 (Determinism)**: `dtcw` pins the AsciiDoctor version (e.g., `gem install asciidoctor:2.0.23`).
  * Neutral on **QS-3 (First-Run)**: Auto-installation is transparent — same UX as Java auto-install.
* **Consequences** (as built, per the *Revision* above): scripts call the **AsciidoctorJ Java API** in-process — there is no external `asciidoctor` CLI step in `dtcw`. The `asciidoctorj`, `asciidoctorj-diagram`, `asciidoctorj-pdf`, and JRuby JARs are **retained** in `lib/` (the original plan to remove them was not carried out). This keeps v4 self-contained at the cost of footprint and JRuby startup — the real `lib/` footprint is **177 JARs / ~126 MB** (ADR-7), tracked as technical debt in the Risks and Technical Debt section.

## ADR-7: lib/ Directory for Remaining Java Dependencies

* **Status**: Accepted (for v4)
* **Context**: AsciiDoctor is embedded as AsciidoctorJ (ADR-6, revised), so the Java dependencies that ship in `lib/` are:
  * AsciidoctorJ + `asciidoctor-diagram` + JRuby (~49 MB) — in-process rendering
  * Groovy runtime (~15 JARs, ~10 MB)
  * jsoup 1.18.1 (1 JAR, 0.5 MB) — HTML parsing for Confluence publishing
  * Apache HttpClient 5.3 (~5 JARs, ~2 MB) — REST API calls to Confluence/Jira
  * Apache POI 5.3.0 (~10 JARs, ~10 MB) — Excel export (only needed for exportExcel)
  * plus transitive dependencies of all of the above
  * **Actual total: 177 JARs, ~126 MB** (`ls lib/*.jar | wc -l` = 177; `du -sh lib/` = 126M). The early estimate of ~30 JARs / 23 MB assumed AsciiDoctor would be externalized; embedding it (ADR-6, revised) is the dominant contributor.
* **Decision**: Ship all JARs in a `lib/` directory. `dtcw` sets the classpath via `java -cp lib/*`. No runtime resolution, no Grape, no downloads.
* **Rationale**: A bundled `lib/` gives zero resolution overhead (supports QS-9), full offline capability, and determinism — every user gets the exact same JARs. The simplest possible solution. The trade-off is size: the real footprint is ~126 MB (not the 23 MB first estimated), driven by embedding AsciidoctorJ/JRuby (ADR-6, revised) — recorded as technical debt in Chapter 11.
* **Alternatives considered**:

| Criterion | Bundled `lib/` | Grape (`@Grab`) | Maven resolve at runtime |
|---|---|---|---|
| Startup overhead (QS-9) | +1 (one classpath glob) | 0 (cache hit fast, first run slow) | –1 (resolution every run) |
| Offline capability (QS-2) | +1 (no network) | 0 (offline after first grab) | –1 (needs network) |
| Determinism (QS-4) | +1 (pinned at release) | 0 (cache can drift) | –1 (resolves latest unless locked) |
| Distribution size (QS-6) | 0 (+23 MB) | +1 (download on demand) | +1 (download on demand) |
| Simplicity / debuggability | +1 (just files) | 0 (Grape config) | –1 (resolver config) |
| **Total** | **+4** | **+1** | **–3** |

* **Quality Tradeoffs**:
  * Supports **QS-9 (Startup + Throughput)**: Zero dependency resolution overhead. Classpath construction is one glob: `lib/*`.
  * Supports **QS-4 (Determinism)**: Exact JARs pinned at release time.
  * Supports **QS-2 (Offline)**: Works without internet after installation.
  * Risk on **QS-6 (Distribution size)**: the real footprint is ~126 MB — *larger* than v3's Gradle distribution (~50 MB), because AsciidoctorJ/JRuby are embedded rather than externalized. Making the POI and AsciidoctorJ JARs optional/lazy is a tracked future optimization (Chapter 11 debt).
* **Consequences**: Release process must resolve all transitive dependencies and package them into `lib/` (177 JARs today). A simple shell script or one-time Gradle/Maven call at release time handles this. The ~126 MB footprint is the main downside; POI and AsciidoctorJ/JRuby JARs could be made optional/lazy in a future optimization (load only when the task needs them) — tracked as technical debt in the Risks and Technical Debt section. This decision creates risk *R-005 (release-time dependency resolution)* — a tampered or vulnerable JAR (threat T-006) would reach every user — and contributes to *R-003 (script loading and classpath conflicts)*; both are tracked in the Risks and Technical Debt section.
  * Affects **QS-2 (Portability)**: All options work cross-platform. Docker image can pre-bundle JARs.
  * Affects **QS-3 (Usability)**: lib/ is simplest to understand. Grape is most Groovy-idiomatic.
  * Affects **QS-6 (Installability)**: Download-on-demand keeps the initial download small.

## ADR-8: Actionable Error Guidance

* **Status**: Accepted (for v4) — **carrier implemented; rollout in progress**. The hierarchy and top-level handler below exist in `scripts/lib/DtcException.groovy` (`DtcError.report()` maps each type to a differentiated exit code; `DtcError.redact()` masks secret-shaped values), unit-tested in `DtcExceptionSpec`. Seven tasks are migrated (`generateHTML`, `generatePDF`, `publishToConfluence`, `copyThemes`, `lintAsciiDoc`, `generateCICD`, `downloadTemplate`): they throw `DtcConfigException`/`DtcApiException`/`DtcException` with guidance and route everything through a single top-level handler (differentiated exit codes 0/1/2/3). The remaining task scripts still use `System.exit` + `println` and are migrated incrementally (risk **R-004**). `redact()` also delivers the T-002 secret-redaction mitigation for script-level error output, and `DtcRestClient` redacts its own HTTP error output via the same logic (Chapter 8).
* **Context**: v3 error handling is inconsistent: `RuntimeException` in core, `GradleException` in scripts, `println` + silent continuation in some scripts. With Gradle removed, `GradleException` is gone. More importantly, the fundamental problem is not *how* errors are thrown, but *what* the user sees. v3 shows stack traces and technical error messages. Users cannot determine what to do next.

  Real example from v3: PDF generation fails with a cryptic `IOException: Access denied` when the output PDF is still open in Adobe Acrobat. Users who know the tool recognize this — new users are stuck.
* **Decision**: Every user-recoverable error must include an **actionable remediation step** — not what went wrong, but what the user should do to fix it. Implemented as a lightweight exception hierarchy with mandatory guidance messages (`scripts/lib/DtcException.groovy`):

  ```groovy
  // Shared helper (lib/DtcException.groovy, ~25 LOC)
  class DtcException extends RuntimeException {
      String guidance  // What the user should do
      int exitCode
      DtcException(String guidance, int exitCode = 1, Throwable cause = null) {
          super(guidance, cause)
          this.guidance = guidance
          this.exitCode = exitCode
      }
  }
  class DtcConfigException extends DtcException {
      DtcConfigException(String guidance) { super(guidance, 2) }
  }
  class DtcApiException extends DtcException {
      DtcApiException(String guidance) { super(guidance, 3) }
  }

  // Usage in scripts:
  if (!outputFile.canWrite()) {
      throw new DtcException(
          "Die Datei ${outputFile.name} ist gesperrt. " +
          "Bitte schließe sie in deinem PDF-Viewer und führe den Befehl erneut aus."
      )
  }

  if (!configFile.exists()) {
      throw new DtcConfigException(
          "Config-Datei '${configFile.name}' nicht gefunden. " +
          "Erstelle sie mit: ./dtcw4 downloadTemplate"
      )
  }

  if (response.statusCode == 401) {
      throw new DtcApiException(
          "Confluence-Authentifizierung fehlgeschlagen. " +
          "Prüfe confluence.api/credentials in docToolchainConfig.groovy bzw. die passenden Umgebungsvariablen."
      )
  }

  // Top-level runner (in dtcw wrapper or bootstrap script):
  try { script.run() }
  catch (DtcConfigException e) { System.err.println("⚙ ${e.guidance}"); System.exit(2) }
  catch (DtcApiException e)    { System.err.println("🌐 ${e.guidance}"); System.exit(3) }
  catch (DtcException e)       { System.err.println("→ ${e.guidance}"); System.exit(1) }
  catch (Exception e)          { System.err.println("BUG: ${e.message}"); e.printStackTrace(System.err); System.exit(99) }
  ```

  Exit codes: 0 = success, 1 = user-fixable error, 2 = config error, 3 = API/network error, 99 = bug.

  Stack traces are shown **only** for exit code 99 (bugs). All other errors show only the guidance message.

* **Alternatives considered**:

| Criterion | A: Exit + stderr (plain) | B: Exception hierarchy with guidance | C: Return codes |
|---|---|---|---|
| Actionable guidance (QS-15) | 0 (message is free-form, no structure enforces guidance) | +1 (guidance field is mandatory in constructor) | 0 (message is free-form) |
| No silent failures (QS-4) | +1 (try/catch enforces handling) | +1 | –1 (easy to forget check) |
| Differentiated exit codes (QS-5) | 0 (only 0/1) | +1 (0/1/2/3/99) | +1 |
| Compatibility with existing code | 0 | +1 (existing exceptions wrapped) | –1 (rewrite needed) |
| Script-first simplicity (QS-11) | +1 (no imports) | 0 (one import) | 0 (new pattern) |
| **Total** | **+2** | **+4** | **–1** |

* **Quality Tradeoffs**:
  * Supports **QS-17 (Actionable Guidance)**: The `guidance` field in `DtcException` enforces that every thrown error contains a user-actionable message. This is not optional — it's the constructor parameter.
  * Supports **QS-4 (Reliability)**: No more silent `println` + continue. Every error is thrown and caught at the top level.
  * Supports **QS-5 (CI/CD)**: Differentiated exit codes (2=config, 3=API, 99=bug) enable targeted CI/CD responses.
  * Neutral on **QS-11 (Script-first)**: One import per script (`import DtcException`). ~25 LOC in a shared file.
* **Consequences**: Every script must use `DtcException` (or subclass) instead of `println` for errors. Existing `RequestFailedException` is replaced by `DtcApiException`. A catalog of common error scenarios with guidance messages should be maintained (see examples in Risks section). The guidance messages should be in English (matching the codebase language), with the tone of a helpful colleague, not a system log. This decision *mitigates* risk *R-004 (residual inconsistent error handling)* in the Risks and Technical Debt section: until every script adopts `DtcException`, the mixed-error-handling risk remains tracked.

## ADR-9: Server-Based Diagram Rendering via Kroki-Compatible API

* **Status**: Accepted (for v4) — **decided; not yet implemented**. The `diagramServer` config key, the auto-started local Kroki container, and the QS-16 external-URL warning described below do **not** exist in code yet (risk **R-007**). Today diagrams render through the embedded `asciidoctor-diagram` (AsciidoctorJ, ADR-6 revised), and `DiagramToolHints.groovy` points users at the public `kroki.io` *with no warning* — which is exactly the privacy gap this ADR closes. Goal #1 (no implicit cloud processing) is therefore met today only because the default render path happens to be local, not because the documented control is enforced.
* **Context**: With AsciiDoctor embedded (ADR-6, revised), diagram rendering (PlantUML, Mermaid, GraphViz, Ditaa, C4, BPMN) requires either locally installed tools or a diagram server. Local tools mean installing PlantUML (Java), Graphviz (C binary), Mermaid (Node.js) — different package managers per OS, per tool. A diagram server reduces this to one URL.

  Kroki provides a unified HTTP API for 20+ diagram formats. Crucially, Kroki is **compatible with GitLab's built-in PlantUML server API**. Large enterprises running GitLab already have a PlantUML server — replacing it with Kroki gives them all diagram formats for free. This makes enterprise adoption frictionless.

* **Decision**: Use a **Kroki-compatible diagram server** as the rendering strategy. The user configures one URL — everything else follows. The default is `docker` (a local Kroki container), which keeps all diagram source on the machine and satisfies quality goal #1 (no implicit cloud processing). Users may opt in to the public `https://kroki.io/` service or, for enterprises, point to their own Kroki or GitLab PlantUML server.

  Configuration (one line in `docToolchainConfig.groovy`):

  ```groovy
  // Option 1: dtcw starts a local Kroki Docker container automatically
  diagramServer = 'docker'

  // Option 2: Public Kroki service
  diagramServer = 'https://kroki.io/'

  // Option 3: Enterprise server (GitLab PlantUML / self-hosted Kroki)
  diagramServer = 'https://gitlab.company.com/kroki/'
  ```

  When `diagramServer = 'docker'` (default), dtcw checks if Docker is available, starts `yuzutech/kroki` as a container on port 8000, and sets the URL to `http://localhost:8000/`. The container persists between runs — dtcw only starts it if not already running.

  **Privacy rule (QS-16):** When `diagramServer` points to an external URL (anything other than `docker` or `localhost`), docToolchain prints a warning on every run:

  ```
  ⚠ Diagramm-Quelltexte werden an kroki.io gesendet.
    Für lokale Verarbeitung setze diagramServer = 'docker' in docToolchainConfig.groovy.
  ```

  No data leaves the machine without the user's explicit, informed configuration. The default `docker` mode processes everything locally.

  `asciidoctor-diagram` receives the resolved URL via `:diagram-server-url:` and `:diagram-server-type: kroki_io` attributes.

* **Alternatives considered**:

| Criterion | Local tools (dtcw installs) | Diagram server (Kroki URL) | Kroki bundled in Docker |
|---|---|---|---|
| Usability / Zero-config (QS-3) | –1 (multiple tools to install per OS) | +1 (one URL) | +1 (just works) |
| LLM-managed config (QS-15) | –1 (LLM must know per-OS install commands) | +1 (one config key: `diagramServer`) | +1 (no config needed) |
| Enterprise adoption | 0 | +1 (reuse GitLab PlantUML/Kroki server) | –1 (conflicts with enterprise infra) |
| Format breadth (Mermaid, BPMN, C4...) | –1 (each format = separate install) | +1 (20+ formats via one service) | +1 |
| Portability / Apple Silicon (QS-10) | –1 (Graphviz ARM builds vary) | +1 (server-side, platform-irrelevant) | +1 |
| Offline capability (QS-2) | +1 (local binaries) | 0 (needs network to server) | +1 (embedded) |
| Distribution size | +1 (no overhead) | +1 (no overhead) | –1 (+200 MB image) |
| Actionable guidance (QS-16) | 0 (which tool? which OS? which version?) | +1 ("Set diagramServer in config") | +1 |
| **Total** | **–2** | **+7** | **+4** |

* **Quality Tradeoffs**:
  * Supports **QS-15 (LLM-managed Config)**: One config key (`diagramServer`). An LLM understands "set the diagram server URL" — no per-OS tool installation knowledge needed.
  * Supports **QS-3 (Usability)**: One URL instead of installing PlantUML + Graphviz + Mermaid + Node.js.
  * Supports **QS-10 (Apple Silicon)**: Rendering happens server-side — no local native binaries.
  * Supports **QS-17 (Actionable Guidance)**: If diagram rendering fails, the message is: "Setze `diagramServer = 'https://kroki.io/'` in docToolchainConfig.groovy" — not "install PlantUML from https://... and add it to PATH".
  * Risk on **QS-2 (Offline)**: Requires network access to diagram server. Mitigation: enterprises run Kroki locally. For fully offline scenarios, local PlantUML remains an option via `asciidoctor-diagram` without server config.
* **Consequences**: `docker` (a local Kroki container) is the default diagram server, so no diagram data leaves the machine unless the user explicitly configures an external URL (QS-16). `asciidoctor-diagram` configuration attributes are set automatically based on the `diagramServer` config key. Enterprise users point to their GitLab PlantUML server or self-hosted Kroki. The docToolchain Docker image does NOT bundle Kroki — it connects to the configured server. A `docker-compose.yml` example is provided for users who want to run Kroki locally alongside docToolchain.

## ADR-10: Risk-Based Quality Assurance (Vibe-Coding Risk Radar)

* **Status**: Accepted
* **Context**: docToolchain v4 uses AI-assisted development (Claude Code). AI-generated code carries risks that depend on code type, language safety, deployment context, data sensitivity, and blast radius. Without a systematic framework, mitigation measures are applied inconsistently — some areas are over-tested while critical gaps remain.

  The Vibe-Coding Risk Radar provides a dimension-based risk assessment model that maps code to one of four tiers, each with cumulative mitigation requirements.
* **Decision**: Adopt the Vibe-Coding Risk Radar as the quality assurance framework. The risk assessment is documented in `CLAUDE.md` (machine-readable for AI agents) and reviewed when the codebase changes significantly.

**Assessment result (2026-03-30):**

| Dimension | Score | Level | Evidence |
|---|---|---|---|
| Code Type | 2 | Business Logic | Doku-Generierung + REST-Client für Jira/Confluence (read/publish, kein eigener API-Server) |
| Language | 2 | Dynamically typed | 81 .groovy, 32 .gradle files |
| Deployment | 1 | Internal tool | Open-Source CLI, lokal oder in CI/CD, kein Server/Service |
| Data Sensitivity | 1 | Internal business data | Verarbeitet Dokumentation, Credentials nur durchgereicht |
| Blast Radius | 1 | Performance / DoS | Kaputte Doku oder fehlerhafte Confluence-Seiten, Quellen in Git |

**Tier 2 — Extended Assurance** (determined by Code Type + Language = 2).

Required mitigations for Tier 2 (cumulative with Tier 1):

| Measure | Status | Details |
|---|---|---|
| Linter & Formatter | ✅ | shellcheck in CI |
| Type Checking | ❌ | Groovy is dynamically typed, no static analysis configured |
| Pre-Commit Hooks | ❌ | Not configured |
| Dependency Check | ❌ | No audit step in CI |
| CI Build & Tests | ✅ | GitHub Actions (build, test, shellcheck, BATS) |
| SAST | ✅ | CodeQL |
| AI Code Review | ✅ | Claude Code reviews on PRs |
| Property-Based Tests | ❌ | Not configured |
| SonarQube Quality Gate | ✅ | SonarCloud as external PR check |
| Sampling Review | ✅ | PR-based review process |

5/10 mitigations present. Pending: type checking, pre-commit hooks, dependency audit, property-based tests.

* **Alternatives considered**:

| Criterion | No framework | Risk Radar | Full formal review |
|---|---|---|---|
| Consistency of QA measures | –1 (ad-hoc) | +1 (systematic per dimension) | +1 |
| Overhead | +1 (none) | 0 (one-time assessment + updates) | –1 (heavy process) |
| AI-agent awareness | –1 (no machine-readable risk info) | +1 (in CLAUDE.md) | 0 |
| Proportionality to risk | –1 (same effort for UI and crypto) | +1 (tier-based) | –1 (over-invests on low risk) |
| Community contributor friendliness | +1 (no barriers) | 0 (clear expectations) | –1 (discouraging) |
| **Total** | **–1** | **+3** | **–1** |

* **Quality Tradeoffs**:
  * Supports **QS-4 (Reliability)**: Systematic mitigation coverage reduces defect risk.
  * Supports **QS-11 (Script-first)**: Tier 2 does not require compilation or formal verification — compatible with script-based development.
  * Supports **QS-12 (LLM Friendliness)**: Risk assessment in CLAUDE.md gives AI agents awareness of which code areas require extra caution.
  * Neutral on **QS-1 (Extensibility)**: Contributors need to add `// @task` markers and follow conventions, but no additional tooling burden.
* **Consequences**: The risk assessment in CLAUDE.md must be updated when new modules are added or when the deployment context changes. Pending mitigations (type checking, pre-commit hooks, dependency audit, property-based tests) should be addressed incrementally. The tier may change if docToolchain adds authentication features or processes sensitive data.

## ADR-11: Tier 2 Mitigation Implementation

* **Status**: Accepted
* **Context**: ADR-10 assessed docToolchain as Tier 2 (Extended Assurance) with only 5 of 10 required mitigations in place. Four gaps needed to be closed: pre-commit hooks, dependency checking, type checking/static analysis, and AI code review. Property-based tests were identified as the tenth measure but deferred.
* **Decision**: Implement the four missing mitigations using free, open-source tools that work independently of Gradle (preparing for the v4 transition per ADR-3).

**Implemented measures:**

| Measure | Tool | Rationale |
|---|---|---|
| Pre-Commit Hooks | pre-commit framework with bash-syntax, shellcheck, asciidoc-linter, gitleaks | Catches issues locally before CI. Gitleaks prevents accidental credential commits. asciidoc-linter ensures documentation quality at the source. |
| Dependency Check | Trivy (aquasecurity/trivy-action) | Scans `lib/*.jar` for known CVEs. Works without Gradle — scans the filesystem directly. Runs on PRs and weekly (Monday 06:00 UTC). Results uploaded to GitHub Security tab via SARIF. |
| Type Checking / Static Analysis | CodeNarc (standalone CLI, no Gradle plugin) | Standard Groovy linter. Checks basic rules, exception handling, unused imports. Runs standalone via downloaded JARs — no Gradle dependency. Matches Groovy 3.0.13 (same version as docToolchain). |
| AI Code Review | GitHub Copilot Code Review | Enabled on the default branch. Automated reviewer on PRs. Complements manual reviews and SonarCloud. |

**Deferred measure:**

Property-Based Tests — deferred until v4 Groovy scripts are production-ready. The v4 functions currently live in `dtcw` (shell) where property-based testing is impractical. When Groovy scripts handle business logic, jqwik or Spock data-driven tests will be added.

* **Alternatives considered**:

| Criterion | Gradle-integrated tools | Standalone tools | No additional tooling |
|---|---|---|---|
| Gradle independence (ADR-3) | –1 (ties us to Gradle) | +1 (works after Gradle removal) | +1 |
| Setup complexity | +1 (plugins are easy) | 0 (JARs must be downloaded) | +1 |
| CI transparency | 0 (hidden in Gradle output) | +1 (dedicated workflows, clear logs) | –1 |
| Maintenance after v4 migration | –1 (must be rewritten) | +1 (unchanged) | +1 |
| Coverage of mitigation requirements | +1 | +1 | –1 (gaps remain) |
| **Total** | **0** | **+4** | **+1** |

* **Quality Tradeoffs**:
  * Supports **QS-4 (Reliability)**: 9/10 mitigations cover automated gates and extended assurance comprehensively.
  * Supports **QS-9 (Fast startup)**: All tools run standalone — no Gradle overhead in CI for these checks.
  * Supports **QS-11 (Script-first)**: CodeNarc analyzes scripts directly without requiring compilation.
  * Neutral on **QS-14 (v3 compatibility)**: Tools analyze the codebase as-is, no changes to runtime behavior.
* **Consequences**: All CI workflows are independent of Gradle and will survive the v4 migration unchanged. The `pre-commit` framework must be installed in the devcontainer (added to `post-create.sh`). CodeNarc downloads JARs from Maven Central at CI runtime (~12 MB). Trivy scans require `./gradlew packageLibs` to populate `build/lib/` — after v4 migration this will be replaced by whatever populates `lib/`.

## ADR-12: Tasks Are Self-Contained Groovy Scripts — No Compiled Core Module at Runtime

* **Status**: Accepted (port of `publishToConfluence` pending)
* **Context**: ADR-3 decided to remove Gradle and stated as a consequence that "the `core/` module is dissolved back into scripts." Eleven of the twelve v4 tasks honour this — they are standalone `scripts/*.groovy` files that use only the `scripts/lib/` helpers and third-party JARs. **One task does not**: `scripts/publishToConfluence.groovy:10` imports `org.docToolchain.tasks.Asciidoc2ConfluenceTask`, an 823-LOC class in the compiled `core/` module that pulls in six further core classes. Because `packageLibs` does not ship the core module's own JAR, that class is not on the task classpath and `publishToConfluence` fails to load at all (#1626). The compiled core module therefore survives solely for this one task, contradicting ADR-3 and keeping a build-and-package step alive that the rest of v4 has shed.
* **Decision**: Make "a task is a self-contained Groovy script with no compiled `core/` dependency" an explicit, enforced architectural rule. Port `Asciidoc2ConfluenceTask` (and the core classes it needs) into a standalone `scripts/publishToConfluence.groovy` built on the `lib/` helpers (`DtcRestClient`, `DtcConfig`). Once that is the last consumer, drop the compiled `core/` module from the runtime classpath entirely.
* **Alternatives considered**:

| Criterion | Keep compiled core JAR | Port to Groovy script | Hybrid (core for this task only) |
|---|---|---|---|
| Consistency with ADR-1/ADR-3 (script-per-task) | –1 | +1 | –1 |
| Runtime/build simplicity (no core module to package) | 0 | +1 | –1 |
| Type safety & testability (existing Spock tests) | +1 | –1 | +1 |
| Contributor friendliness (no compile step) | –1 | +1 | 0 |
| Cleanly removes the dead-task root cause | –1 | +1 | 0 |
| **Total** | **–2** | **+3** | **–1** |

* **Quality Tradeoffs**:
  * Supports **QS-11 (Script-first)**: every task becomes a plain script artifact; no compilation, no `core/` build.
  * Supports **QS-1 (Extensibility)** and **QS-3 (Usability)**: one uniform task model — contributors learn a single pattern.
  * Supports **QS-9 (Fast startup)** and footprint goals: the `core/` module and its build output leave the runtime.
  * Cost on **type safety / testability**: porting an 823-LOC typed class to an untyped Groovy script gives up compile-time checking and the existing Spock unit tests. This is the standard v4 tradeoff (dynamically-typed, script-first) and must be offset by service-level tests around the new script.
* **Consequences**: `publishToConfluence` is rewritten as a standalone script; the `core/tasks/Asciidoc2ConfluenceTask` logic and its required helpers move into `scripts/`/`scripts/lib/`. After the port, the compiled `core/` module is dropped from the packaged classpath, completing ADR-3's "core dissolved into scripts." This decision creates risk *R-006 (publishToConfluence port regression)* — re-implementing the most complex task (page tree, attachments, new-editor handling, rate limiting) risks behavioural regressions in Confluence publishing — tracked in the Risks and Technical Debt section. Until the port lands, `publishToConfluence` remains non-functional (#1626); the ADR Status stays "Accepted (port pending)" and flips to "Accepted" when the script ships and the core module is removed.

## ADR-13: `dtcw4` → `dtcw` Wrapper Delegation

* **Status**: Accepted (inferred) — reconstructed from `dtcw4` and `dtcw`; no prior written decision.
* **Context**: v4 is distributed as a git checkout that must be built (`packageLibs`) before use, and it coexists on developer machines with v3. A project needs *some* entry point checked into its repository, but that entry point should not pin a project to one machine's installation, nor require every project to carry the full wrapper logic. Two concerns pull apart: the **per-project bootstrap** (what lives in the repo) and the **installed runtime** (what actually runs tasks).
* **Decision**: Ship only a thin `dtcw4` bootstrap in the project directory. It performs v4-specific installation — clone `main-4.x`, run `packageLibs` — into `~/.doctoolchain/docToolchain-<version>/`, then **delegates all task execution** to the installed `dtcw` there (`dtcw4` lines 5-9). The installed `dtcw` owns environment detection, classpath construction from `lib/`, and task dispatch. Only `dtcw4` needs to live in a project; upgrading the runtime does not touch the project.
* **Alternatives considered**:

| Criterion | A: One fat wrapper in project | B: Thin `dtcw4` + delegate (chosen) | C: Global install only, no project wrapper |
|---|---|---|---|
| Per-project footprint | –1 (full wrapper copied into every repo) | +1 (one small bootstrap file) | +1 (nothing in repo) |
| Version isolation (v3/v4 coexist) | 0 (project pins its copy) | +1 (runtime installed per version under `~/.doctoolchain`) | 0 (one global version wins) |
| First-run install UX | 0 (wrapper must still install) | +1 (bootstrap installs then delegates) | –1 (user must pre-install manually) |
| Maintenance (one place to fix wrapper logic) | –1 (logic duplicated across projects) | +1 (logic lives in the installed `dtcw`) | +1 |
| **Total** | **–2** | **+4** | **+1** |

* **Consequences**: A project commits one small `dtcw4` file. The heavy wrapper logic lives once in the installed `dtcw`, so fixes ship with a runtime upgrade rather than requiring every project to re-copy a wrapper. The delegation seam means task-execution behaviour is identical whether invoked via `dtcw4` or the installed `dtcw` directly. The bootstrap depends on `git` and network access on first install; this is the same install-time dependency already accepted for Java/AsciiDoctor provisioning and is not separately risk-tracked.

## ADR-14: Task Discovery via `// @task` Marker

* **Status**: Accepted (inferred) — reconstructed from `dtcw`; no prior written decision.
* **Context**: v4 tasks are plain Groovy files in `scripts/`. That same directory also holds *non-task* code: `scripts/lib/` helpers (`DtcConfig.groovy`, `MicrositeBaker.groovy`, `DtcRestClient.groovy`, …) that are loaded by tasks but must never be invoked as tasks themselves. The wrapper needs a reliable way to answer two questions — "which scripts may a user run?" (for `dtcw tasks`) and "is this name a real task?" (for `dtcw <name>`) — without a central registry that every new task has to be added to.
* **Decision**: A script is a runnable task **iff** it carries the line marker `// @task` within its first 5 lines. `dtcw` discovers tasks by scanning `scripts/*.groovy` and grepping the file head for that marker (`dtcw` lines 685 and 702); listing and validation use the same check. Adding a task is therefore a one-file operation: drop a `scripts/<name>.groovy` with `// @task` near the top — no edit to any registry, build file, or the wrapper.
* **Alternatives considered**:

| Criterion | A: Central task registry/list | B: `// @task` marker (chosen) | C: Every `scripts/*.groovy` is a task |
|---|---|---|---|
| Adding a task (no central edit) | –1 (must edit a registry too) | +1 (drop one marked file) | +1 (drop one file) |
| Excludes `lib/` helpers from being run | +1 (only listed names run) | +1 (helpers lack the marker / live in `lib/`) | –1 (helpers would be runnable, dangerous) |
| Self-documenting / greppable | 0 (registry is separate from code) | +1 (marker sits in the script it describes) | 0 |
| Implementation simplicity (wrapper) | 0 (parse a registry) | +1 (one `grep` over the file head) | +1 |
| **Total** | **–1** | **+4** | **+1** |

* **Consequences**: The marker is the single source of truth for "is this a task", so the task list never drifts from the files on disk. Helper code stays safe simply by living in `scripts/lib/` and omitting the marker. The cost is a convention contributors must know: a new task silently fails to appear if the `// @task` line is missing or pushed past the first 5 lines — a documentation/onboarding concern rather than a runtime risk. The marker is intentionally a comment, so it costs nothing at execution time and survives any Groovy tooling that ignores comments.

## ADR-15: Structural Diagrams as Architecture-as-Code (Bausteinsicht model, PlantUML render)

* **Status**: Accepted (for v4) — **model authored; inline C4-PlantUML kept as the rendered artifact; export wiring deferred**. The spike (#1641) confirmed that Bausteinsicht has **no PlantUML exporter**, so the hoped-for `model → PlantUML → microsite` round-trip does not exist yet. The Level-1 model lives at `src/docs/arc42/models/level1-container.jsonc`; it is authored against the published Bausteinsicht JSON schema and the `online-shop` reference example and parses as JSONC, but has not yet been validated by the Bausteinsicht binary (not available in the docs build environment) — a `bausteinsicht sync` validation pass is the open follow-up.
* **Context**: The arc42 Chapter 5 building-block views are hand-written C4-PlantUML embedded directly in `05_building_block_view.adoc` (`level1-container-v4`, `level3-atlassian-v4`). They satisfy the Semantic Contract (PlantUML + C4-PlantUML stdlib `!include <C4/...>`), but every structural change means editing PlantUML by hand and there is no single, tool-readable source of truth. `Bausteinsicht` — our own Go architecture-as-code tool (JSONC model, bidirectional draw.io sync) — exists precisely for this, and the cross-repo relationship states *"Bausteinsicht generates architecture diagrams consumable by docToolchain."* We do not currently eat our own dog food for docToolchain's own architecture docs.

  The spike evaluated consuming a Bausteinsicht export as an AsciiDoc include. Finding: Bausteinsicht's structural exports are **draw.io (native)**, **PNG/SVG via the draw.io CLI**, and **Mermaid C4** — there is **no PlantUML output**. Mermaid is explicitly forbidden by the Semantic Contract ("Diagrams are PlantUML, not Mermaid"). PNG/SVG requires the draw.io CLI (a headless Electron binary; cf. Bausteinsicht issue #385) and replaces a text-rendered diagram with a committed binary, breaking the docs-as-code "diagram is reviewable text" property and the existing Kroki/`asciidoctor-diagram` render path (ADR-9, ADR-6 revised).

* **Decision**: Maintain the **structural (C4 building-block) views as a versioned Bausteinsicht JSONC model** — the single, machine-readable, LLM-editable source of truth — **but keep the inline C4-PlantUML block as the rendered artifact** in the microsite for now. Start with the Level-1 container view; keep Level-3 (`level3-atlassian-v4`) inline-only until the model proves itself. Wire an automatic render path only once a clean text-based export exists (a Bausteinsicht PlantUML exporter — to be requested upstream — or an accepted draw.io-CLI image step). Until then, the model and the inline PlantUML are kept in sync by hand (tracked as technical debt in the Risks and Technical Debt section).

* **Alternatives considered**:

| Criterion | A: Hand-written PlantUML only (status quo) | B: Model + PNG via draw.io CLI | C: Model as SoT + PlantUML render (chosen) |
|---|---|---|---|
| Machine-readable single source of truth for structure (QS-12) | –1 | +1 | +1 |
| Author can edit diagrams via draw.io (no PlantUML skill needed) | –1 | +1 | +1 |
| Renders as reviewable text, no binary artifact in git (docs-as-code) | +1 | –1 | +1 |
| Semantic-Contract render output (PlantUML + C4, not Mermaid/binary) (QS-13) | +1 | 0 | +1 |
| Build simplicity — no draw.io CLI / Electron dependency | +1 | –1 | +1 |
| No manual model↔render synchronisation | +1 | +1 | –1 |
| **Total** | **+2** | **+1** | **+4** |

* **Quality Tradeoffs**:
  * Supports **QS-12 (LLM friendliness)**: the architecture is now a machine-readable JSONC model an LLM or tool can read, diff, and edit — not prose embedded in PlantUML.
  * Supports **QS-13 (modern UI / rendered output)**: the microsite keeps rendering hand-tuned C4-PlantUML through the existing pipeline, so diagram quality and layout are unchanged (no auto-layout regression, no binary image).
  * Preserves the docs-as-code property: the rendered diagram stays reviewable text in git; no Electron/draw.io-CLI dependency enters the build.
  * Cost — **manual synchronisation**: until an export path is wired, the JSONC model and the inline PlantUML must be edited together, and they can drift. This is the one criterion option C loses on and is recorded as technical debt (below).

* **Consequences**: `src/docs/arc42/models/level1-container.jsonc` becomes the source of truth for the Level-1 container view; `05_building_block_view.adoc` carries a NOTE linking the inline `level1-container-v4` block to that model and to this ADR. The decision creates a **technical-debt** item — *"Hand-synchronised Bausteinsicht model and inline PlantUML"* — recorded in the Risks and Technical Debt section (11.2) against the Chapter 5 building-block view documentation; it is **explicitly accepted as low-cost** (one Level-1 view, changed rarely) rather than tracked as an `R-NNN` risk. The debt retires when either (a) Bausteinsicht ships a PlantUML/C4-PlantUML exporter — to be requested upstream — and `generateSite` consumes it as a generated include kept inside the rendered doc tree (a file-outside-tree include is fatal), or (b) the team accepts a draw.io-CLI PNG/SVG step in the build. Level-3 stays inline-only; rolling the model out to Level-3 is a follow-up gated on the same export path. Open follow-up: validate the model with `bausteinsicht sync` once the binary is available in the build environment, and add the `bausteinsicht` ecosystem tool note in Chapter 5 (already present).

## ADR-16: Project-Local Tasks — Custom Tasks and Monkey-Patching via a Project `scripts/` Directory

* **Status**: Accepted (for v4)
* **Context**: v4 tasks are self-contained Groovy scripts (ADR-12) discovered by the `// @task` marker (ADR-14), but `dtcw` only ever resolves them from the *installed* runtime (`~/.doctoolchain/docToolchain-<version>/scripts/`). A project therefore could not (a) add its **own** task without forking docToolchain, nor (b) **modify** a shipped task short of editing the shared installation — which every other project on the machine then inherits. The v3 mechanism for this (`scripts/customTasks.gradle`, the `customTasks = [...]` config list, and a Gradle `createTask`) is Gradle-bound and dead under the Gradle-free v4 runtime (ADR-3). Quality goal QS-1 ("a contributor adds a task as one script, no build-system knowledge") is only half met: it holds for docToolchain's own repo, not for a *consuming* project. Two distinct user needs share one root cause — `dtcw` does not look in the project:

  1. **Custom tasks** — a user drops a new task into their project and runs it.
  2. **Monkey-patching** — a user copies an installed task into their project, edits it, and has their version run instead of the shipped one.

* **Decision**: `dtcw` resolves a task from a **project-local scripts directory first, then the installation**. The directory defaults to `scripts/` under the project root and is overridable via `DTC_PROJECT_SCRIPTS_DIR`. The same ADR-14 rule applies: a file is a task **iff** it is a `*.groovy` with `// @task` in its first 5 lines — so discovery is uniform across installed and project tasks, with no registry and no config edit (extending QS-1 to consuming projects).
  * A project task whose name does **not** match an installed task is a **custom task** (need 1).
  * A project task whose name **matches** an installed task **overrides** it — monkey-patching (need 2). `dtcw` prints a `Note:` to stderr on every override run, so a shadowed task is never silent (transparency; relevant to T-005).
  * Two helper tasks make the workflow one command: `createTask <name>` scaffolds a marked skeleton in the project, and `copyTask <name>` copies an installed script into the project for editing.

* **Alternatives considered**:

| Criterion | A: Config list (`customTasks=[…]`, v3-style) | B: Project `scripts/` + `// @task` auto-discovery (chosen) | C: Edit the shared installation directly |
|---|---|---|---|
| Adding a task (no central edit) — QS-1 | –1 (must list every file in config) | +1 (drop one marked file, like installed tasks) | 0 (no project file, but edits global state) |
| Consistency with ADR-14 (one discovery rule) | –1 (second, different mechanism) | +1 (same `// @task` rule everywhere) | +1 (it *is* the installation) |
| Override isolation (per project, not global) | 0 (no override story) | +1 (override lives in the project repo) | –1 (every project on the box inherits the edit) |
| Transparency of an override (no silent shadowing) — T-005 | 0 | +1 (`Note:` printed on each override run) | –1 (invisible global change) |
| Reproducibility (override travels with the repo) | 0 | +1 (committed alongside the docs) | –1 (lives outside version control) |
| **Total** | **–2** | **+5** | **–2** |

* **Quality Tradeoffs**:
  * Supports **QS-1 (Extensibility)**: a consuming project adds a task exactly the way docToolchain's own repo does — one marked script, no build-system knowledge, appears in `./dtcw tasks`.
  * Supports **QS-11 (Script-first)** and **QS-3 (Usability)**: one uniform task model; `createTask`/`copyTask` keep the first step to a single command.
  * Cost on **predictability**: a project file can now silently change what `generateHTML` does. Mitigated by the mandatory override `Note:` and by the override being flagged in `./dtcw tasks`.
* **Consequences**: `dtcw` gains a project-first resolution step in `assert_v4_task_exists`, `list_v4_tasks`, and `build_command`; the listing flags overrides and groups custom tasks. Project tasks are executable Groovy authored by the project — the **same local-trust assumption already accepted for `docToolchainConfig.groovy`** (threat **T-005**, see the Cross-cutting Concepts section): opening and running `dtcw` in a project already runs that project's Groovy, so project tasks add no new trust class, only more surface within it. The override `Note:` keeps shadowing visible. This decision depends on ADR-17 so that a copied or custom script can still load the bundled `lib/` helpers from the installation. No new Chapter 11 risk is created; the consequence is recorded as accepted under the existing T-005 local-trust model. The Windows wrappers (`dtcw.ps1`/`dtcw.bat`) do not yet carry the v4 path at all (Chapter 11 technical debt), so project-task resolution lands in the Bash `dtcw` first; Windows parity rides on the existing "no v4 Windows wrapper path" debt item.

## ADR-17: `dtc.scriptsHome` — Resolve `lib/` Helpers and Resources from the Installation, Not the Script Location

* **Status**: Accepted (for v4)
* **Context**: Every v4 task script loads its shared helpers relative to *its own* file location: `def scriptDir = new File(getClass().protectionDomain.codeSource.location.toURI()).parentFile` and then `new File(scriptDir, 'lib/DtcConfig.groovy')`. Three scripts likewise derive `dtcHome = scriptDir.parentFile` to find bundled resources (themes, landing page). This works only because installed scripts sit next to `lib/`. ADR-16 lets a script run from the *project* `scripts/` directory, where there is no `lib/` and no bundled resources — so a copied (monkey-patched) or custom script would fail to load `DtcConfig`/`DtcException` and break at startup. The helpers and resources it needs live in the installation, not the project.
* **Decision**: `dtcw` passes the installed scripts directory to every run as a system property: `-Ddtc.scriptsHome="${dtc_home}/scripts"` (and `/opt/docToolchain/scripts` inside the Docker image). Scripts resolve their helper/resource base from that property, falling back to the on-disk script location when it is absent:

  ```groovy
  def scriptDir = System.getProperty('dtc.scriptsHome')
      ? new File(System.getProperty('dtc.scriptsHome'))
      : new File(getClass().protectionDomain.codeSource.location.toURI()).parentFile
  ```

  For an installed script `dtc.scriptsHome` equals its own directory, so behaviour is unchanged; for a project script it points back at the installation, so `lib/` and bundled resources resolve correctly regardless of where the script file lives.

* **Alternatives considered**:

| Criterion | A: Copy `lib/` into the project too | B: `dtc.scriptsHome` system property (chosen) | C: Put `lib/` on the classpath and load helpers by class name |
|---|---|---|---|
| Project-script startup works (ADR-16) — QS-1 | +1 (lib present locally) | +1 (resolves from install) | +1 |
| Footprint / no duplication (QS-6) | –1 (copies ~MBs of helpers per project) | +1 (single installed copy) | +1 |
| Determinism — copy can't drift from the runtime (QS-4) | –1 (project lib goes stale on upgrade) | +1 (always the installed helpers) | +1 |
| Change size / risk across existing scripts | +1 (no script change) | 0 (one mechanical line per script) | –1 (rework every helper-loading site + packaging) |
| Backward compatibility (installed scripts unchanged) | +1 | +1 (property defaults to own dir) | 0 |
| **Total** | **+1** | **+4** | **+2** |

* **Quality Tradeoffs**:
  * Supports **QS-1 (Extensibility)**: custom and copied scripts load the same bundled helpers as installed tasks — the project extension point is fully functional, not a stub.
  * Supports **QS-4 (Determinism)** and **QS-6 (Footprint)**: helpers exist once, in the installation; a project copy can never drift from the runtime and adds no per-project megabytes.
  * Cost: a one-line convention every helper-loading script must follow; a script that hard-codes `scriptDir` from its own location instead of honouring `dtc.scriptsHome` silently breaks when run as a project override. Documented as the canonical idiom and demonstrated by the `createTask` skeleton.
* **Consequences**: The `scriptDir`/`dtcHome` definition is updated to the property-first form across the v4 scripts that load `lib/` or bundled resources, and `dtcw` exports `dtc.scriptsHome` on every v4 invocation (local and Docker). This unblocks ADR-16: monkey-patched and custom scripts run against the installed helpers. It also contributes to **R-003 (script loading / classpath)** — helper resolution now hinges on a correctly-set property — mitigated by the safe fallback to the script's own directory when the property is unset (e.g. direct `groovy` invocation outside `dtcw`).

## ADR-18: v4 Task Dispatch Moves into a Groovy Launcher — Bash Wrapper Reduced to JVM Bootstrap

* **Status**: Accepted (for v4)
* **Context**: v4 task *dispatch* logic currently lives in the Bash wrapper `dtcw`: task discovery (`list_v4_tasks`), validation (`assert_v4_task_exists`), and selection/invocation (the v4 branch of `build_command`), including the project-first resolution and override notes added for ADR-16. `dtcw4` only bootstraps and `exec`s the installed `dtcw` (ADR-13). Two forces make Bash the wrong long-term home for this logic:
  * **No cross-platform single source.** The v4 `GroovyMain` path exists only in the Bash `dtcw`; `dtcw.ps1`/`dtcw.bat` carry no v4 path at all (tracked as technical debt in the Risks and Technical Debt section). Every piece of dispatch logic added in Bash must eventually be re-implemented twice more, in two more untyped shell dialects — exactly the drift the `// @task` marker (ADR-14) was meant to avoid for the task list.
  * **Untestable, against the v4 grain.** Dispatch logic in Bash is exercised only by bats integration tests; it cannot be unit-tested. v4's direction is script-first Groovy with logic out of the wrapper/build layer (ADR-3, ADR-5, ADR-12). Discovery, project-vs-install resolution, and override signalling are business logic, not JVM bootstrapping.
* **Decision**: Extract v4 task discovery, resolution, and invocation into a single **Groovy launcher** (e.g. `scripts/Launcher.groovy`) executed inside the JVM the wrapper already starts. The platform wrappers (`dtcw`, `dtcw.ps1`, `dtcw.bat`) are reduced to what only they can do — detect the environment, locate Java, build the `lib/*` classpath, and hand **all** arguments to the launcher with the existing system properties (`docDir`, `dtc.scriptsHome`, `DTC_PROJECT_SCRIPTS_DIR`, …). The launcher owns: scanning the project and installed scripts directories, the `// @task` marker check, project-first selection with override/custom notes (ADR-16), unknown-task guidance, and dispatch to the chosen task script. This is the structural move; behaviour is preserved (the bats acceptance tests from ADR-16 stay green and are joined by Spock unit tests around the launcher).
* **Alternatives considered**:

| Criterion | A: Keep dispatch in each wrapper (Bash + PS + BAT) | B: Groovy launcher, wrappers bootstrap only (chosen) | C: Compiled Java launcher in `lib/` |
|---|---|---|---|
| Single source across platforms (kills the Windows-parity debt) — QS-2 | –1 (logic hand-ported into three shells) | +1 (one launcher for all wrappers) | +1 |
| Testability (Spock unit tests vs bats/manual) | –1 | +1 | +1 |
| Script-first, no compile step (ADR-3/ADR-12) | 0 | +1 | –1 (reintroduces a build artifact) |
| Startup overhead (QS-9) | +1 (no extra step) | 0 (runs in the JVM already started for the task) | +1 |
| Change size / risk | 0 | 0 | –1 (build + packaging return) |
| **Total** | **–1** | **+3** | **+1** |

* **Quality Tradeoffs**:
  * Supports **QS-2 (Portability)** and retires the *"No v4 Windows wrapper path"* technical debt: one launcher gives `dtcw.ps1`/`dtcw.bat` the v4 path for free.
  * Supports **QS-1 (Extensibility)**, **QS-11 (Script-first)**, **QS-5 (Testability/maintainability)**: dispatch becomes Groovy, unit-tested, and consistent with how tasks themselves are written.
  * Neutral on **QS-9 (Fast startup)**: discovery moves into the JVM that is started for the task anyway — no second process.
  * Cost: a one-time refactor and the discipline of keeping the wrappers thin. Bash keeps only environment/JVM bootstrapping.
* **Consequences**: The v4 dispatch in `dtcw` (the ADR-16 resolution, listing, and notes) has moved into `scripts/Launcher.groovy`, with the pure logic in `scripts/lib/TaskLauncher.groovy` (IOSP: Operation vs Integration) and unit tests in `scripts/lib/TaskLauncherTest.groovy`. The Bash wrapper now only validates the task-name format, enforces the docker relative-path constraint, and invokes `groovy.ui.GroovyMain .../Launcher.groovy <task> <args>`. The launcher runs the resolved task script in the same JVM via `GroovyShell`; `dtc.scriptsHome` (ADR-17) lets that script load its `lib/` helpers regardless of where it lives. ADR-16's user-visible behaviour is preserved; the bats suite now asserts the wrapper *delegates* (java is mocked there), while discovery/resolution/listing are covered by `TaskLauncherTest`. This decision **does not change** ADR-13 (thin `dtcw4` → installed wrapper) or ADR-17 (`dtc.scriptsHome`), which already live in Groovy. A consequence is that `dtcw tasks` and unknown-task errors now start the JVM (no separate process — the launcher runs in the JVM started for the task); acceptable since QS-9 targets task runs, not listing. Wiring `dtcw.ps1`/`dtcw.bat` to the same launcher — closing the *"No v4 Windows wrapper path"* debt in the Risks and Technical Debt section — is the remaining follow-up.

## ADR-TBD-1: Confluence API Version Strategy

* **Status**: Proposed (deferred — decide when Confluence publishing is reworked)
* **Context**: Two parallel Confluence client implementations (V1 for Server, V2 for Cloud). Lower priority in the LLM era — documentation increasingly consumed via daCLI/MCP rather than pushed to Confluence.

## ADR-TBD-2: Jira Cloud vs. Server Client Architecture

* **Status**: Proposed (deferred — decide when Jira integration is reworked)
* **Context**: Only `JiraServerClient` exists. Lower priority — LLMs can query Jira directly via MCP tools, reducing the need for batch export scripts.
