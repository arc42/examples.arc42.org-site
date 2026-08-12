---
title: Risks and Technical Debt
order: 11
---

## Rails vs. iQvoc

iQvoc is an open source thesaurus framework based on the web standards SKOS and RDF. The technical foundation of iQvoc is the Ruby on Rails framework (https://rubyonrails.org/). The source code of iQvoc and its functional extensions is freely available on the GitHub platform (https://github.com/innoq/iqvoc).

General best practices and principles for developing Ruby on Rails applications were applied when implementing the framework. iQvoc itself, however, is not a classic Ruby on Rails application, but forms an abstraction layer above the application framework for developing thesauri based on SKOS and linked data principles.

Additional functions were implemented abstractly and reusably in the form of Rails engines (https://guides.rubyonrails.org/engines.html) and integrated into the SNS system. This type of development requires familiarization with advanced techniques for developing with the Ruby on Rails application framework.

## Single-Sign-On (SSO)

Currently there is no central single sign-on system for central user authentication, meaning each subsystem (UMTHES, Chronicle) implements its own user management. Central user management has not been a focus of the project so far, since different specific users have in any case been responsible for maintaining the applications up to now.

## Bootstrap 4 Style Guide

The visual design of SNS is based on the separately developed German Environment Agency (Umweltbundesamt, UBA) Bootstrap theme. This is now available in a newer version based on the frontend framework Bootstrap v5. SNS still uses an older version of this style guide (Bootstrap 4). Migration to the new version is still pending.
