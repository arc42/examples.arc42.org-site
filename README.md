# examples.arc42.org

Complete architecture documentations of real systems, each written along the
twelve sections of the [arc42](https://arc42.org) template. Published at
**https://examples.arc42.org** via GitHub Pages.

The home page is a dashboard of tiles — one per system, each carrying its
domain, its main goal, its strategic decisions and its technologies as
keywords, so a reader can pick an example in a few seconds.

## Build & serve

```bash
make dev          # local dev server via Docker (http://localhost:4042)
make site         # build the static site into _site/
make check        # brand deny-list + Imprint Rule checks
make check-links  # build + validate internal links/HTML (html-proofer)
make check-external  # check the off-site URLs in _data/in-the-wild.yml still resolve
make new-system SLUG=my-system   # scaffold a new example
make clean        # remove _site and the Docker cache volumes
make help         # all targets
```

The dev image is built from this repo's own `Dockerfile` (Ruby 3.2, gems
pinned via `Gemfile.lock`). Run `make install` after editing the `Gemfile`.

> This site's dev server uses port 4042 (not Jekyll's default 4000) so it can
> run alongside other arc42 sites' dev servers without a port clash.

Without Make: `docker compose up`. Native Ruby: `bundle install && bundle exec
jekyll serve`. Production deploys automatically from `main`.

## One directory is one system

This is the structural commitment the whole repository is built around:

```
_systems/
├── _TEMPLATE/            the skeleton contributors copy
└── dokchess/
    ├── index.md          front matter IS the dashboard tile
    ├── 01-introduction-and-goals.md
    ├── …                 twelve sections
    ├── 12-glossary.md
    ├── images/           published at /systems/dokchess/images/…
    └── _originals/       source .adoc/.puml/.drawio — never published
```

Adding an example is `make new-system SLUG=…` and filling in files. Removing
one is `rm -rf`. **No file outside the directory is ever edited** — there is no
navigation config, no index, no registry to keep in sync.

That works because the system's slug is derived from the directory name in
`_includes/system-context.html`, not written into the section files. The single
exception is the `permalink:` line in each system's `index.md`, which
`make new-system` rewrites for you.

Two naming rules are load-bearing:

- `_originals/` keeps its leading underscore. Jekyll's `EntryFilter` skips any
  path segment starting with `_`; renaming it to `originals/` would publish
  every source file.
- Section files are numbered `NN-name.md` and carry `order: NN`. The rail, the
  stepper and the section grid all sort on `order`.

## Layout

| Path | What |
|---|---|
| `_systems/` | The collection. One directory per documented system. |
| `_layouts/` | `default`, `home` (dashboard), `system` (overview), `system-section` |
| `_includes/` | `system-context.html` resolves "which system am I in?"; masthead, spine, rail, stepper, tile |
| `_sass/` | `_tokens.scss` is the only file allowed to contain a hex literal |
| `_data/spine.yml` | The six spine segments, with their measurements |
| `_data/in-the-wild.yml` | Links to arc42 documentation we do **not** host — see below |
| `scripts/check-brand.sh` | ADR-0003 mechanical floor, run by `make check` |
| `scripts/check-external-links.sh` | Link-rot check for `in-the-wild.yml`, run by `make check-external` |

## Design and brand

This site has **no signature hue**. It is recognized by the *spine* — the
six-segment rule under the masthead, in the shared arc42 family colours. The
ground is a neutral umber graphite that makes no hue claim, following the
precedent status.arc42.org set for its slate.

That is a registered exception, not a local choice: see
[ADR-0008](https://github.com/arc42/meta.arc42.org/blob/main/adr/0008-examples-owns-a-device-not-a-hue.md)
in the meta repository, and [DESIGN.md](DESIGN.md) here for the site-local
system. The family definition lives in
[meta.arc42.org](https://github.com/arc42/meta.arc42.org):
`BRAND.md` (values) and `DESIGN.md` (rules).

`make check` enforces the mechanical part — retired colours, no other site's
signature hue in any role, and no hex literal outside `_sass/_tokens.scss`.

## Documentation we link but do not host

`/in-the-wild/` is an annotated list of arc42 documentation that cannot be
republished here — usually for licensing reasons. It is filled from
`_data/in-the-wild.yml`, whose header documents the fields.

**It is not a second dashboard, and it has no tiles on purpose.** A tile carries
`domain`, `main_goal`, `decisions`, `technologies` and `scale`, and every one of
those can only be filled in by somebody who read all twelve sections. Nobody has
done that for these links, so the data file has no field to put in a tile and
the page is set as a bibliography instead. If you are tempted to unify the two,
read the "In the wild" section of [DESIGN.md](DESIGN.md) first — the
visual difference is carrying a factual claim.

Adding an entry is one block of YAML and no other change. Contributors supply
`title`, `url`, `author` and `description`; the `note` — the one editorial
sentence — is written by the maintainers, because author-supplied notes turn
into blurbs.

`make check-external` requests every URL in the file and reports anything that
is not 2xx. It is deliberately excluded from `make check` and `make check-links`:
a build must never fail because somebody else's server is down.

## Relationship to docs.arc42.org

[docs.arc42.org](https://docs.arc42.org) hosts short, **section-sized** example
snippets that illustrate what belongs in each arc42 section. This site hosts
**complete** documentations. The two overlap deliberately and neither is
generated from the other — the same arrangement arc42.org and arc42.de use.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). The short version: complete
documentations only, real systems only, and provenance is not optional.

## Licence

Site content is [CC BY-SA 4.0](LICENSE). Each example additionally carries its
own licence and attribution on its overview page — the systems documented here
belong to their authors.
