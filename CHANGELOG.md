# Changelog

All notable changes to this project will be documented in this file.

This changelog is based on the current repository contents and uses the packaged kit version as the release identifier.

## [Unreleased]

### Added

- `kit.manifest.json:as_of_changelog` (renamed from `source_version`) is now a validator-enforced freshness ceiling: any `VERIFIED(changelog:1.19.<m>)` anchor in `docs/wesnoth/generated/` whose `<m>` exceeds the field fails `scripts/validate-docs.sh`.
- Regression fixtures `changelog-exceeds-ceiling`, `marker-exclude-passes`, and `citation-exclude-passes` covering the new freshness gate and both exclude lists. Harness gains `run_pass_case` for positive (must-pass) assertions.
- `kit.manifest.json:citation_scan_excludes` allowlist so individual files can be exempted from the URL-domain gate without disabling it globally (parallels `marker_scan_excludes`). Schema updated accordingly.
- `LICENSE` (GNU General Public License, version 2) at repo root.
- `kit.manifest.schema.json` declaring the manifest's required keys, types, and patterns.
- `docs/wesnoth/EVIDENCE_ANCHORS.md` defining the `VERIFIED(...)` evidence-anchor grammar.
- `kit.manifest.json:marker_scan_excludes` allowlist so audit-log files can discuss marker tokens without tripping the gate.
- `kit.manifest.json:tracked_directories` declaring the directories the manifest is responsible for.
- New validator gates in `scripts/validate-docs.sh`:
  - manifest schema check;
  - orphan-file detection in `tracked_directories`;
  - evidence-anchor schema enforcement.

### Changed

- `scripts/validate-docs.sh` freshness gate and evidence-anchor schema check now derive the version prefix from `kit.manifest.json:as_of_changelog` at runtime instead of hardcoding `1.19`. The schema's `target_branch` / `as_of_changelog` regex patterns remain coupled by convention; bump them together when retargeting the kit.
- `scripts/test-validate-docs-regressions.sh` strips `.git` from each sandbox before running the validator, and `apply_manifest_patch` now merges list-valued keys (deduped, order-preserving) instead of replacing them, so fixtures can extend `installed_files` etc.
- `scripts/validate-docs.sh` orphan-files diagnostic names the actual manifest fields (`installed_files` / `generated_outputs`) instead of saying "add to manifest".
- `AGENTS.md` rewritten as the canonical rule set: repository kind (documentation-only), explicit list of validator-enforced gates, uncertainty handling split between non-generated and generated docs, exclude-list semantics described per gate, and an explicit note that the citation scan is intentionally repo-wide. `.github/copilot-instructions.md` retitled to delegate.
- `scripts/validate-docs.sh` documented Python requirement set to 3.8 (matches actual feature usage); CI workflow pins Python 3.8 via `actions/setup-python@v5`. The optional `ripgrep` fallback was removed; only `python3` + `grep -E` are used.
- `scripts/validate-docs.sh` citation-URL gate now honors `kit.manifest.json:citation_scan_excludes`.
- `scripts/validate-docs.sh` stale-validation-command gate is now manifest-driven: it scans text-bearing files in `installed_files` + `generated_outputs` instead of a hard-coded path list, so newly added docs are picked up automatically.
- `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` now delegate to `AGENTS.md` instead of duplicating its rules.
- `docs/wesnoth/generated/04_best_practices_1.19.md` §5: split the Lua-persistence bullet to distinguish runtime globals (do not survive save/load) from boot-time `[lua]` registrations in `_main.cfg` (re-executed on every load).

### Removed

- `scripts/validate-docs.sh` stale-validation-command gate (the cleanup it enforced is complete; superseded by the `as_of_changelog` freshness gate).
- `docs/wesnoth/generated/07_second_pass_verification.md` and `docs/wesnoth/generated/09_final_audit_wesnoth_ai_kit.md` (and the earlier `docs/wesnoth/generated/08_third_pass_marker_elimination.md`): one-shot process audit logs superseded by inline `VERIFIED(...)` evidence anchors and CHANGELOG history.

### Fixed

- Marker-token validator no longer relied on prose paraphrasing in audit logs; the exclusion is now driven by `kit.manifest.json:marker_scan_excludes`.

## [1.1.0] - 2026-04-28

### Added

- Initial packaged release of the Wesnoth AI Kit for the Wesnoth 1.19.x development line.
- Project-wide instruction sets for Copilot, Claude, Gemini, and AGENTS-based workflows.
- A canonical Wesnoth 1.19 reference covering runtime baseline, migration-sensitive API changes, and verification policy.
- Campaign research notes focused on Wesnoth 1.19.x content and multiplayer context.
- A workflow prompt defining output locations, anti-hallucination rules, verification passes, and final audit requirements.
- A manifest describing the kit version, target branch, source version, installed files, generated outputs, and allowed citation domains.

### Documentation

- Added generated reference material for Lua API changes in Wesnoth 1.19.x.
- Added generated reference material for WML engine changes in Wesnoth 1.19.x.
- Added generated reference material for WFL changes in Wesnoth 1.19.x.
- Added generated best-practices guidance for WML, WFL, and Lua targeting 1.19.x.
- Added generated analysis of multiplayer and campaign-relevant changes for the 1.19.x line.

### Examples

- Added Lua example coverage for GUI theme switching.
- Added Lua example coverage for recruit and recall dialog usage.
- Added WML example coverage for fire_event data payloads.
- Added WML example coverage for have_side checks and dismiss-related unit keys.
- Added WFL migration example coverage for removed ownership and side properties.
- Added top-level Lua registration example coverage for custom WML action setup.

### Validation

- Added a second-pass verification report for generated outputs.
- Added a third-pass marker-elimination report to ensure generated outputs are marker-clean.
- Added a final kit audit report covering layout, generated deliverables, path consistency, and documentation-pipeline completeness.

### Compatibility

- Targets Battle for Wesnoth 1.19.x.
- Assumes Lua 5.4 in the Wesnoth runtime.
- Treats 1.18.x and 1.19.x as distinct API surfaces for documentation and examples.
