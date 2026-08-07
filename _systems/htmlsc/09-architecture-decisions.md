---
title: Architecture Decisions
order: 9
---

> **Content and Motivation**
>
> You like to understand important, huge, expensive, risky or otherwise special
> architecture and design decisions.
>
> It's especially interesting to keep the _reasons_ for these decisions.

## 9.1 Checking of external links postponed
In the current version of HtmlSC we won't check external links.
These checks have been postponed to later versions.

## 9.2 HTML Parsing with jsoup
To check HTML we parse it into an internal (DOM-like) representation.
For this task we use [Jsoup](https://jsoup.org), an open-source parser without
external dependencies.

To quote from the their website:

[quote]
jsoup is a Java library for working with real-world HTML.
It provides a very convenient API for extracting and manipulating data,
using the best of DOM, CSS, and jQuery-like methods.

**Goals of this decision:**
Check HTML programmatically by using an existing API that provides access and finder
methods to the DOM-tree of the file(s) to be checked.

**Decision Criteria:**

* Few dependencies, so the HtmlSC binary stays as small as possible.
* Very easy to use: Simple and elegant (accessor and finder) methods to easily locate images, links and link-targets within the DOM tree.
* Highly flexible: Can parse files and strings (and other) input.

**Alternatives:**

* jsoup: a plain HTML parser without any dependencies (!) and a rich API to access all HTML elements in DOM-like syntax. Clear winner!
* HTTPUnit: a testing framework for web applications and -sites. Its main focus is web testing and it suffers from a large number of dependencies.
* [HtmlCleaner](https://htmlcleaner.sourceforge.net/)
