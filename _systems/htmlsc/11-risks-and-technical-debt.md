---
title: Risks and Technical Debt
order: 11
---

>**Content and Motivation**
>
>You want to know the technical risks of your system,
>so you can address potential future problems.
>
>In addition you want to support your management
>stakeholders (i.e. project management, product owner)
>by identifying technical risks.

**Remark:** In our small example we don't see
any _real_ risks for architecture and implementation.
Therefore the risks shown below are a bit artificial...

## 11.1 Technical risks

|Risk                            |Description                                |
|-------|-----|
|Bottleneck with access rights on public repositories |Currently only one single developer has access rights to deploy new versions of HtmlSC on public servers like Bintray or Gradle plugin portal.  |
| | |
|High effort required for new versions of Gradle |Upgrading Gradle from v-3.x to v-4.x required configuration changes in HtmlSC. Such effort might be needed again for future upgrades of the Gradle API. |

## 11.2 Business or domain risks

|Risk  |Description  |
|-------|-----|
|System might become obsolete    |In case AsciiDoc or Markdown processors implement HTML checking natively, HtmlSC might become obsolete.                             |
