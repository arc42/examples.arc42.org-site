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

## Vocabulary risks of the English translation

*This section was added by examples.arc42.org and is not part of the original documentation. The German original remains the authoritative text; these are the places where its vocabulary does not map one-to-one onto English, so a reader comparing sections should not mistake a change of word for a change of meaning.*

* **One German word, two English ones.** German *Begriff* covers both the SKOS `Concept` — the abstract unit of the thesaurus — and the everyday "term". The translation says *concept* wherever the data model is meant, as SKOS's own English does, but *term* survives in the service name **SimilarTerms** and its glossary entry ("similar terms for a search term"). Where *term* and *concept* appear side by side in English, the German had one word: SimilarTerms returns concepts, not label strings.
* ***Benennung* is rendered three ways.** *Designation* in the solution strategy (section 4), *label* in the runtime view (section 6, following SKOS-XL), *term* in the glossary's UMTHES entry. SKOS English is *label*; all three name the same thing.
* ***Descriptor* appears mostly in numbers.** The figures "~12,000 descriptors · ~40,000 non-descriptors" use ISO-25964 thesaurus vocabulary that the running text rarely uses — section 4 calls the same 12,000 entries "concepts (keywords)". The bridge is a single sentence in section 6: `prefLabel` corresponds to the descriptor, `altLabel` to the non-descriptor.
* ***Keyword* is overloaded.** *Verschlagwortung* is consistently translated as *keyword assignment*, but *keyword* also glosses descriptors (section 5) and concepts (section 4) — three referents for one English word where the German kept *Schlagwort*, *Deskriptor* and *Verschlagwortung* apart. AutoClassify's name adds a fourth tension, promising classification while performing keyword assignment; that one is inherited from the original.
* **The worked examples stay German.** Concept labels in the runtime examples (Seeschifffahrt, Wattenmeer, Baumkrone …) are live UMTHES content and were deliberately not translated: their URLs resolve to the real, German-first thesaurus at sns.uba.de.
