# Wesnoth AI Kit — Agent Rules (1.19.x)

Canonical rule set for every AI agent operating in this repository.
The other agent files (`CLAUDE.md`, `GEMINI.md`,
`.github/copilot-instructions.md`) delegate here.

## Repository kind

Documentation-only kit for Wesnoth `1.19.x`. No installer, no runtime, no
WML/Lua source tree. Agents must not create `.cfg` or `.lua` source files
or directories outside what `kit.manifest.json` declares.

## Source of truth

- Canonical baseline: `docs/wesnoth/WML_1.19_CANONICAL.md`.
- Campaign notes: `docs/wesnoth/Campaigns_1.19.md`.
- Pipeline output destination: `docs/wesnoth/generated/` (only).
- Repository contract: `kit.manifest.json` (validated against
  `kit.manifest.schema.json`).

Target branch is `1.19.x`. Do not assume `1.18.x` compatibility unless
explicitly requested.

## Manifest contract (validator-enforced)

`scripts/validate-docs.sh` will fail any change that violates these:

- New tracked files must be listed in either `installed_files` or
  `generated_outputs` in `kit.manifest.json`.
- Markdown files under `docs/wesnoth/generated/` must contain no marker
  tokens (`[UNVERIFIED]`, `[NEEDS REVIEW]`); resolve uncertainty before
  writing there, or place the draft outside `generated/`.
- URLs in tracked text files must use a domain from
  `kit.manifest.json:allowed_citation_domains`.
- Evidence anchors (`VERIFIED(...)`) in generated files must conform to
  `docs/wesnoth/EVIDENCE_ANCHORS.md`.
- No `VERIFIED(changelog:1.19.<m>)` anchor in a generated file may exceed
  `kit.manifest.json:as_of_changelog`. Raise that field when you verify a
  newer version, do not bypass the gate.
- Every distinct `wiki:` and `changelog:` anchor in a generated file needs
  a companion HTTPS URL in that file or in `docs/wesnoth/Campaigns_1.19.md`.
  `wiki:` anchors require a URL containing `wiki.wesnoth.org/<Page>`;
  `changelog:` anchors only require any URL containing `changelog`
  (upstream ships a single `changelog.md`, so per-version pairing is not
  enforced).
- Two narrow escape hatches:
  - `marker_scan_excludes` exempts named `.md` files under
    `docs/wesnoth/generated/` from the marker-token scan.
  - `citation_scan_excludes` exempts named text files (anywhere in the
    repo) from the URL allowlist scan.
  Use only when a file legitimately quotes markers or cites outside the
  allowlist (test fixtures, etc.). Document the reason in the PR.

The citation scan is intentionally repo-wide rather than scoped to
`installed_files` / `generated_outputs`, so stray drafts dropped into the
tree are caught before they're declared.

The freshness gate derives its version prefix from `as_of_changelog` at
runtime, so renaming the kit's target line (e.g. to `1.20.x`) requires
bumping `as_of_changelog` *and* the regex patterns for `target_branch` and
`as_of_changelog` in `kit.manifest.schema.json` together — they are
coupled by convention, not by validator logic.

## Uncertainty handling

- In non-generated docs: mark unverified claims `[UNVERIFIED]` and leave
  them for review rather than inventing a replacement.
- In generated outputs: resolve or remove the claim before commit (the
  validator rejects the marker there).

## WML / Lua rules (apply to code examples in documentation)

Examples shown in docs must reflect 1.19.x usage:

- Use Lua named location fields (`loc.x`, `loc.y`), not positional indexing.
- Avoid deprecated or removed WFL fields (e.g. `unit.side`, `terrain.owner`).
- Include a minimum-version gate comment on each example:
  - Lua: `-- Requires: 1.19.X+`
  - WML: `# Requires: 1.19.X+`

## Change safety

- Prefer small, isolated edits; avoid drive-by changes.
- Note compatibility impact when revising legacy guidance; do not silently
  rewrite it.
- Run `bash scripts/validate-docs.sh` before finalizing.
