# Wesnoth AI Kit

This repository is a documentation kit for Wesnoth `1.19.x`.

It is not an installer repository, packaging repository, or runtime harness. In the
current checkout, installer and runtime validation remain intentionally partial
because no installer flow is shipped here.

## Canonical and maintained files

- Canonical baseline: `docs/wesnoth/WML_1.19_CANONICAL.md`
- Campaign notes: `docs/wesnoth/Campaigns_1.19.md`
- Repository metadata: `kit.manifest.json`

## Generated outputs

Generated documentation lives under `docs/wesnoth/generated/`.

These files are derived workflow outputs and should stay marker-token clean.

## Validation

Run repo-local validation from the repository root with:

```bash
bash scripts/validate-docs.sh
bash scripts/test-validate-docs-regressions.sh
```

The validator currently checks:

- `kit.manifest.json` exists (boot check)
- `kit.manifest.json` conforms to its JSON Schema (`kit.manifest.schema.json`)
- manifest-listed files are present on disk
- manifest contract paths resolve and remain tracked
- no orphan files exist in the repo root or tracked directories
- generated outputs are marker-token clean (`[UNVERIFIED]`, `[NEEDS REVIEW]`)
- citation URLs use only the allowed canonical domains in `kit.manifest.json`
- evidence anchors conform to the grammar in `docs/wesnoth/EVIDENCE_ANCHORS.md`

The regression harness intentionally mutates a temporary checkout to verify that
`scripts/validate-docs.sh` rejects a broken `canonical_file` pointer and an
undeclared repo-root file with stable diagnostics.

## Repository intent

Use this folder as a maintained Wesnoth `1.19.x` documentation bundle with a clear
separation between canonical source material and generated analysis.

## License

Licensed under the GNU General Public License, version 2. See [LICENSE](LICENSE).
