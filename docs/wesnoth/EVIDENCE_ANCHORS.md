# Evidence Anchor Schema (Wesnoth AI Kit)

Generated reference files in `docs/wesnoth/generated/` use inline evidence
anchors of the form:

```
VERIFIED(<source>)
```

This document defines the closed grammar for `<source>`. The validator at
`scripts/validate-docs.sh` enforces this grammar and fails on any anchor
that does not match.

## Grammar

```
anchor       := "VERIFIED(" source ")"
source       := canonical | changelog | wiki
canonical    := "canonical"
changelog    := "changelog:" version
version      := "1.19." ( digit | nonzero_digit digit* )
digit        := "0" | nonzero_digit
nonzero_digit := "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
wiki         := "wiki:" page
page         := [A-Za-z0-9_.]+ ( "#" [A-Za-z0-9_.-]+ )?
```

## Source key meanings

- `canonical` — claim is verified by `docs/wesnoth/WML_1.19_CANONICAL.md`,
  the kit's own pinned baseline.
- `changelog:<X.Y.Z>` — claim is verified by the entry for version `X.Y.Z`
  in the upstream Wesnoth changelog. The version string MUST match
  `1.19.<n>` (no spaces, no leading zeros, no plus suffix).
- `wiki:<Page>` — claim is verified by the named page on
  `wiki.wesnoth.org`. An optional `#anchor` may be appended for sections.
  The page name uses the wiki's URL form (e.g., `LuaAPI`, `LuaWML`,
  `1.19_Roadmap`).

## Citation companion rule

Every distinct `wiki:<Page>` and `changelog:<X.Y.Z>` anchor used in a
generated file SHOULD have at least one accompanying HTTPS URL footnote
pointing to the same source somewhere in that file or in
`docs/wesnoth/Campaigns_1.19.md`. The `canonical` key requires no URL
because it points to a file in this repository.

URLs in any tracked text file must use one of the canonical domains
listed in `kit.manifest.json:allowed_citation_domains`.

## Examples (valid)

- `VERIFIED(canonical)`
- `VERIFIED(changelog:1.19.10)`
- `VERIFIED(wiki:LuaAPI)`
- `VERIFIED(wiki:LuaWML#Lua_in_save_files)`
- `VERIFIED(wiki:1.19_Roadmap)`

## Examples (invalid — will fail validation)

- `VERIFIED(changelog: 1.19.10)` — extra space inside `changelog:`
- `VERIFIED(changelog:1.19.10+dev)` — version suffix not allowed
- `VERIFIED(changelog:1.19.04)` — leading zero in patch component
- `VERIFIED(wiki:Some Page)` — space in page name
- `VERIFIED(blog:somepost)` — `blog` is not in the source key set
- `VERIFIED()` — empty source
