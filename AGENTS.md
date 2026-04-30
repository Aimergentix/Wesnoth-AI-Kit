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
- Two narrow escape hatches exist (`marker_scan_excludes`,
  `citation_scan_excludes`); use only when the file legitimately quotes
  markers or cites outside the allowlist. Document the reason in the PR.

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
