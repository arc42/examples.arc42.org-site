---
title: Runtime View
order: 6
---

This view addresses the dynamic aspects of SNS and shows how the individual parts work together.

To help understand the following scenarios, here is a brief explanation of the terminology used in SKOS (Simple Knowledge Organization System) and therefore in iQvoc:

* **Concept**: central element of SKOS. Concepts represent the idea behind a term.
* **Label**: assigned to the concept established in step 1. There are two types of labels: `prefLabel` (preferred label) and `altLabel` (alternative label). `prefLabel` serves as the preferred designation of a concept, `altLabel` as additional alternative designation(s). Put simply, `prefLabel` corresponds to the descriptor and `altLabel` to the non-descriptor from thesauri.

## Similar Terms

### Preconditions

* No precondition (e.g. login) is necessary.

### Process

Process of SimilarTerms using the example input "baum" from [https://github.com/innoq/iqvoc_umt/issues/437](https://github.com/innoq/iqvoc_umt/issues/437)

1. Search in the current language for all labels (whether pref or alt) that contain the spelling "baum":
   * Search input: `terms = "baum"`, `lang = de`

```text
labels = [
   Baum (https://sns.uba.de/umthes/de/labels/TH_00003834.html)
]
```

2. Collect the connected concepts from the previous label search:

```text
concepts = [
   Baum (https://sns.uba.de/umthes/de/concepts/_00003834.html)
]
```

3. Create a preliminary result set with the labels of the found concept, including weighting:
   * Weighting factors:
     * `'Labeling::SKOSXL::PrefLabel'` => 5
     * `'Labeling::SKOSXL::AltLabel'` => 2
     * `'Labeling::SKOSXL::HiddenLabel'` => 1
   * The intermediate result is expanded over the course of the process

```text
Zwischenergebnis = {
  "Baumphysiologie" = [2, https://sns.uba.de/umthes/de/concepts/_00003834.html]
  "Baumwachstum" = [2, https://sns.uba.de/umthes/de/concepts/_00003834.html]
  "Pionierbaumart" = [2, https://sns.uba.de/umthes/de/concepts/_00003834.html]
  "Baumkrankheit" = [2, https://sns.uba.de/umthes/de/concepts/_00003834.html]
  "Baumplantage" = [2, https://sns.uba.de/umthes/de/concepts/_00003834.html]
  "Nährstoffversorgung von Bäumen" = [2, https://sns.uba.de/umthes/de/concepts/_00003834.html]
  "Baumpflanzung" = [2, https://sns.uba.de/umthes/de/concepts/_00003834.html]
  "Baum" = [5, https://sns.uba.de/umthes/de/concepts/_00003834.html]
}
```

4. Narrower/Related analysis (`find_related_and_narrower_concepts`):
   * Collect narrower and related concepts for the concept "Baum" in a new data structure
   * Process:
     * add narrower terms
     * add related terms
     * add compound-in compositions (only if a. and b. produce no results)

```text
related/narrower = [
    Baumstamm (https://sns.uba.de/umthes/de/concepts/_00003860.html)
    Waldbaum (https://sns.uba.de/umthes/de/concepts/_00027032.html)
    Baumform (https://sns.uba.de/umthes/de/concepts/_00030245.html)
    Obstbaum (https://sns.uba.de/umthes/de/concepts/_00030595.html)
    Speierling (https://sns.uba.de/umthes/de/concepts/_00603839.html)
    Kakaobaum (https://sns.uba.de/umthes/de/concepts/_00604135.html)
    Nussbaum (https://sns.uba.de/umthes/de/concepts/_00649690.html)
    Biotopbaum (https://sns.uba.de/umthes/de/concepts/_00655034.html)
    Kautschukbaum (https://sns.uba.de/umthes/de/concepts/_00666651.html)
    Stadtbaum (https://sns.uba.de/umthes/de/concepts/_00023103.html)
    Straßenbaum (https://sns.uba.de/umthes/de/concepts/_00023670.html)
    Laubbaum (https://sns.uba.de/umthes/de/concepts/_00015861.html)
    Nadelbaum (https://sns.uba.de/umthes/de/concepts/_00017738.html)
    Baumart (https://sns.uba.de/umthes/de/concepts/_00003837.html)
    Baumkrone (https://sns.uba.de/umthes/de/concepts/_00003849.html) <-- bis hier Spezifischere Begriffe/Narrower
    Baumfällung (https://sns.uba.de/umthes/de/concepts/_00003846.html) <-- ab hier neu Verwandte Begriffe
    Baumschutz (https://sns.uba.de/umthes/de/concepts/_00003855.html)
    Baumwurzel (https://sns.uba.de/umthes/de/concepts/_00003867.html)
    Dendrometrie (https://sns.uba.de/umthes/de/concepts/_00006549.html)
    Baumgrenze (https://sns.uba.de/umthes/de/concepts/_00030248.html)
    Dendrologie (https://sns.uba.de/umthes/de/concepts/_00030298.html)
    Windbruch (https://sns.uba.de/umthes/de/concepts/_00051506.html)
    Palmen (https://sns.uba.de/umthes/de/concepts/_00608682.html)
    Baumschule (https://sns.uba.de/umthes/de/concepts/_00003854.html)
    Baum des Jahres (https://sns.uba.de/umthes/de/concepts/_00045805.html)
    Baumschaden (https://sns.uba.de/umthes/de/concepts/_00003852.html)
    Baumrinde (https://sns.uba.de/umthes/de/concepts/_00003851.html)
    Holz (https://sns.uba.de/umthes/de/concepts/_00028848.html)
]
```

5. Add terms from step 4 to the intermediate results:
   * Weighting = 1
   * Weighting increases by 1 each time a concept is present with two different labels

```text
Zwischenergebnis = {
  "Baumphysiologie" = [2, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Baumwachstum" = [2, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Pionierbaumart" = [2, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Baumkrankheit" = [2, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Baumplantage" = [2, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Nährstoffversorgung von Bäumen" = [2, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Baumpflanzung" = [2, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Baum" = [5, 'https://sns.uba.de/umthes/de/concepts/_00003834']
  "Baumstamm" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003860'] <-- ab hier neue Narrower/Related
  "Waldbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00027032']
  "Baumform" = [1, 'https://sns.uba.de/umthes/de/concepts/_00030245']
  "Obstbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00030595']
  "Speierling" = [1, 'https://sns.uba.de/umthes/de/concepts/_00603839']
  "Kakaobaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00604135']
  "Nussbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00649690']
  "Biotopbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00655034']
  "Kautschukbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00666651']
  "Baumfällung" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003846']
  "Baumschutz" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003855']
  "Baumwurzel" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003867']
  "Dendrometrie" = [1, 'https://sns.uba.de/umthes/de/concepts/_00006549']
  "Baumgrenze" = [1, 'https://sns.uba.de/umthes/de/concepts/_00030248']
  "Dendrologie" = [1, 'https://sns.uba.de/umthes/de/concepts/_00030298']
  "Windbruch" = [1, 'https://sns.uba.de/umthes/de/concepts/_00051506']
  "Palmen" = [1, 'https://sns.uba.de/umthes/de/concepts/_00608682']
  "Baumschule" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003854']
  "Stadtbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00023103']
  "Straßenbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00023670']
  "Baum des Jahres" = [1, 'https://sns.uba.de/umthes/de/concepts/_00045805']
  "Laubbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00015861']
  "Nadelbaum" = [1, 'https://sns.uba.de/umthes/de/concepts/_00017738']
  "Baumart" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003837']
  "Baumschaden" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003852']
  "Baumkrone" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003849']
  "Baumrinde" = [1, 'https://sns.uba.de/umthes/de/concepts/_00003851']
  "Holz" = [1, 'https://sns.uba.de/umthes/de/concepts/_00028848']
}
```

6. Sort the intermediate results by weighting and output the result. This results in a result set of 36 similar terms.

## Automatic Keyword Assignment with AutoClassify (Plain Text)

### Preconditions

* No precondition (e.g. login) is necessary.

### Process

The AutoClassify process is divided into five main phases:

1. **Document preparation**: input validation, text combination and normalization
2. **Linguistic analysis**: tokenization, phrase recognition, and language-specific processing
3. **Thesaurus matching**: hash-based search and database queries
4. **Advanced term processing**: homograph resolution and compound form recognition
5. **Concept assignment and weighting**: label-to-concept mapping and ranking

### Technical Processing Flow

As an example, the title of the article "Schwammstadt: Der Städtebau der Zukunft - Grün in die Stadt"[^1] is used.

[^1]: https://www.gruen-in-die-stadt.de/schwammstadt/, last accessed: 20.07.2025

1. The user's keyword assignment request is forwarded/dispatched by the reverse proxy to the SNS subsystem UMTHES into the Plain Controller.
2. Instantiation of a new `Document::Plain` with the `title` and `content` of the keyword assignment request.
3. Keyword assignment is started by calling the `classify!` method:
   * previous keyword assignment results for the document are removed (`classifications.destroy_all`)
   * the `concepts` method starts the analysis, calls `determine_concepts`, which in turn starts `determine_labels`
   * the text to be keyword-assigned is split into sentences by `DocumentParser::German` (`PragmaticSegmenter`)
   * German language normalization by `DocumentParser::German.normalize_sentence`:
     * removal of stop words: `['oder']`
     * elimination of irrelevant abbreviations: `['ca.', 'etc.', 'usw.', 'bzw.', 'vgl.', 'evtl.', 'P.S.', 'z. B.', 'd. h.', 's. o.', 'u.a.', 'z. T.', 'z. Zt.', 'i. A.', 'i. V.', 'i. d. R.', 'Min.', 'min.', 'Mio.', 'Mrd.', 'Nr.', 'Dr.', 'Prof.', 'Fa.', 'ff.']`
   * tokenization by `DocumentParser::Base` along delimiters `[' ', "\t", ',', ':', ';', '"', "'", '(', ')']`
   * token normalization by `TokenNormalizer.do_it` (German special characters are preserved)
   * instantiation of a new `WordMatcher` instance with the sentence array
   * the `WordMatcher` is used to find labels (`def labels` in `WordMatcher`). For this, the previously formed individual sentences are iterated over:
     * `phrase_recognition_variants`: to find multi-word terms, phrase variants of increasing size are formed (e.g. "schwammstadt der", "der städtebau", "städtebau der", "der zukunft", "schwammstadt der städtebau", "der städtebau der zukunft")
     * `add_non_dotted_variants`: for special handling of phrases with periods, additional variants without a period are added (e.g. "CO₂-Äquiv." → "CO₂-Äquiv." and "CO₂-Äquiv")
     * `find_existing_inflectionals`: the previously collected phrases are used to find and return variants in the database (e.g. "schwammstadt", "stadt", "städtebau" are found as existing inflectional forms)
     * `remove_duplicate_word_partials`: ensures that more specific variants of phrases are preferred over more general ones (e.g. `["monetäre bewertung von umweltschäden", "monetäre bewertung"]` => `["monetäre bewertung von umweltschäden"]`)
     * `label_index`: the hashes (for a more efficient search) of the cleaned variants are used to find labels for the inflectional forms:
       * "schwammstadt" → Hash `ae9fc10c8688d3889701b94d504fd56a` → Label-ID 107562
       * "städtebau" → Hash `cfbe280de98e35e5e7a6601f21aba0c4` → Label-ID 171360
       * "stadt" → Hash `37b9e141bf7fa3a8f592e2f56fb5de18` → Label-ID 194652
     * `homographs(label_seqs)`: combines label IDs into homographs/qualifiers (e.g. label ID 95326 "Berlin [Stadt]" has both homograph 132357 "Berlin" and qualifier 194652 "Stadt", both of which occur in the text. This replaces the ambiguous label "Berlin" with "Berlin[Stadt]")
     * `compound_forms(label_seqs)`: combines label IDs into compound labels, if the option is enabled
     * `remove_autoclassify_disabled_label_seq(label_seqs)`: removes labels for which AutoClassify was explicitly disabled
     * the labels found per sentence are collected and returned for the entire document
   * the label result set is iterated over in `determine_concepts`:
     * labels of unpublished concepts are filtered out (`!concept.published?`)
     * labels of expired concepts are filtered out (`concept.expired?`)
     * labels of disabled concepts are filtered out (`!concept.auto_classify?`), only if `exclude_disabled_concepts` is enabled
     * labels of collections are explicitly excluded (`.where.not(labelings: { owner_type: Iqvoc::Collection.base_class_name })`)
     * remaining labels are used to find concepts in the text corpus, with weighting by designation type:
       * `'Labeling::Skosxl::PrefLabel'` => 1.0
       * `'Labeling::Skosxl::AltLabel'` => 0.8
       * `'Labeling::Skosxl::HiddenLabel'` => 0.3
     * **Title bonus**: concepts from the document title receive fivefold weighting (`determine_title_concepts`)
     * **Relationship analysis**: relationships of the found concepts are used to refine the weighting, with configurable factors:
       * Broader relation: 1.5x
       * Narrower relation: 2.0x
       * Related relation: 1.3x
     * `Classification` objects are created and sorted by weighting
     * `create_classification_trace` stores the complete processing trace as JSON (e.g. `@trace` for the "Schwammstadt" title):
       * `token_index`: `{"schwammstadt der städtebau...": ["-", "in", "die", "der", "grün", "stadt", "zukunft", "städtebau", "schwammstadt"]}`
       * `label_index`: `{"schwammstadt der städtebau...": [194652, 171360, 107562]}`
       * `homograph_index`: `{"schwammstadt der städtebau...": []}`
       * `result_index`: `{"schwammstadt der städtebau...": [194652, 171360, 107562]}`
4. Concepts found in the text corpus are returned to the requesting user via the Plain Controller of UMTHES through the reverse proxy.

### Illustration

![AutoClassify process](../images/runtime_autoclassify.jpg)
