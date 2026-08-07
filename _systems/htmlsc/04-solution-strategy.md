---
title: Solution Strategy
order: 4
---

> **Content and Motivation**
>
>You need a brief summary and explanation of the fundamental solution ideas
>and strategies. These key ideas should be familiar to everyone involved
>in development and architecture.
>
>Briefly explain how you achieve the most important quality requirements.

1. Implement HtmlSC mostly in the Groovy programming language and partially in Java
with minimal external dependencies.
2. We wrap this implementation into a Gradle plugin, so it can be used within
automated builds. Details are given in the
[Gradle userguide](https://docs.gradle.org/current/userguide/userguide.html).
(The Maven plugin is still under development).
3. Apply the [_template-method-pattern_](https://sourcemaking.com/design_patterns/template_method/)
to enable:
  * multiple checking algorithms. See the [concept for checking algorithms](../08-crosscutting-concepts/),
  * both HTML (file) and text (console) output. See the [reporting-concept](../08-crosscutting-concepts/).
4. Rely on standard Gradle and Groovy conventions for configuration, having a single configuration file.
  * For the Maven plugin, this might lead to problems.
