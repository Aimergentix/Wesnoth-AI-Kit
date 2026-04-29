# Contributing to Wesnoth AI Kit

This repository maintains reusable AI guidance and workflow tooling for Wesnoth `1.19.x`.

## Local workflow

1. Make focused, minimal edits.
2. Keep references project-root-relative.
3. If script behavior changes, update:
   - Any affected workflow docs (under `docs/wesnoth/`)
4. Run repo-local validation:
   - `bash scripts/validate-docs.sh` (requires Python 3.8 or newer)
   - Review VS Code Problems for each modified file and keep diagnostics clean.
5. Remove temporary scratch files before finalizing.

This checkout currently ships documentation validation only. It does not include a
`Makefile`, installer harness, or repo-local dry-run install command.

## Documentation and workflow rules

- Treat `docs/wesnoth/WML_1.19_CANONICAL.md` as the primary factual baseline.
- Keep generated outputs under `docs/wesnoth/generated/`.
- If a detail is uncertain, mark it `[UNVERIFIED]` until verified.

## Manifest escape hatches

`kit.manifest.json` exposes two exclude lists that silence specific validator gates for
named paths:

- **`marker_scan_excludes`** — add a path here only when the file legitimately
  quotes marker tokens such as `[UNVERIFIED]` or `[NEEDS REVIEW]` as examples or
  audit-log entries rather than as live uncertainty markers (e.g., a doc that
  documents the marker policy itself).
- **`citation_scan_excludes`** — add a path here only when the file intentionally
  contains URLs outside the `allowed_citation_domains` allowlist, such as a one-off
  reference document that is not a generated output.

## Script safety expectations

- Prefer idempotent behavior.
- Support true no-touch dry-run modes.
- Use defensive shell settings (`set -euo pipefail`).
- Avoid non-portable assumptions when practical.

## Pull request checklist

- [ ] `bash scripts/validate-docs.sh` passes.
- [ ] Modified files are clean in editor diagnostics.
- [ ] Docs updated for behavior changes.
- [ ] No stale path references introduced.
- [ ] Generated marker policy remains intact.
