#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixtures_root="$repo_root/scripts/fixtures/validate-docs"

pass() {
    printf 'PASS: %s\n' "$1"
}

fail() {
    printf 'FAIL: %s\n' "$1"
    exit 1
}

if ! command -v python3 >/dev/null 2>&1; then
    fail "python3 is required to run regression fixtures"
fi

scratch_root="$(mktemp -d)"
cleanup() {
    rm -rf "$scratch_root"
}
trap cleanup EXIT

apply_manifest_patch() {
    local sandbox="$1"
    local patch_file="$2"

    python3 - "$sandbox" "$patch_file" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
patch = json.loads(pathlib.Path(sys.argv[2]).read_text(encoding="utf-8"))
manifest_path = root / "kit.manifest.json"
manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
manifest.update(patch)
manifest_path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
PY
}

run_case() {
    local case_name="$1"
    local expected_summary="$2"
    local expected_detail="$3"
    local fixture_dir="$fixtures_root/$case_name"
    local sandbox="$scratch_root/$case_name"
    local output_file="$scratch_root/$case_name.out"

    mkdir -p "$sandbox"
    cp -a "$repo_root"/. "$sandbox"/

    if [[ -f "$fixture_dir/manifest.patch.json" ]]; then
        apply_manifest_patch "$sandbox" "$fixture_dir/manifest.patch.json"
    fi

    if [[ -d "$fixture_dir/overlay" ]]; then
        cp -a "$fixture_dir/overlay"/. "$sandbox"/
    fi

    if (cd "$sandbox" && bash scripts/validate-docs.sh >"$output_file" 2>&1); then
        printf 'FAIL: %s unexpectedly passed\n' "$case_name"
        cat "$output_file"
        exit 1
    fi

    if ! grep -Fq "$expected_summary" "$output_file"; then
        printf 'FAIL: %s missing expected summary\n' "$case_name"
        cat "$output_file"
        exit 1
    fi

    if ! grep -Fq "$expected_detail" "$output_file"; then
        printf 'FAIL: %s missing expected detail\n' "$case_name"
        cat "$output_file"
        exit 1
    fi

    pass "$case_name fails with the expected diagnostic"
}

run_case \
    "broken-canonical-file" \
    "FAIL: manifest contract paths drifted" \
    "canonical_file: missing path docs/wesnoth/DOES_NOT_EXIST.md"

run_case \
    "undeclared-root-file" \
    "FAIL: orphan files found in repo root or tracked directories (add to installed_files or generated_outputs in kit.manifest.json)" \
    "UNDECLARED_ROOT.txt"

run_case \
    "changelog-exceeds-ceiling" \
    "FAIL: changelog anchors exceed as_of_changelog ceiling" \
    "exceeds as_of_changelog=1.19.10"

printf 'Negative regression harness completed successfully.\n'