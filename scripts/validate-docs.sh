#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

status=0

pass() {
    printf 'PASS: %s\n' "$1"
}

fail() {
    printf 'FAIL: %s\n' "$1"
    status=1
}

fail_with_output() {
    printf 'FAIL: %s\n%s\n' "$1" "$2"
    status=1
}

if ! command -v python3 >/dev/null 2>&1; then
    fail "python3 is required to run validation"
    exit "$status"
fi

if [[ -f kit.manifest.json ]]; then
    pass "kit.manifest.json exists"
else
    fail "kit.manifest.json is missing"
    exit "$status"
fi

# Schema validation of the manifest itself.
if schema_violations="$(python3 - "$repo_root" <<'PY'
import json
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / "kit.manifest.json").read_text(encoding="utf-8"))
schema = json.loads((root / "kit.manifest.schema.json").read_text(encoding="utf-8"))

errors = []

def type_ok(value, expected):
    if expected == "object":
        return isinstance(value, dict)
    if expected == "array":
        return isinstance(value, list)
    if expected == "string":
        return isinstance(value, str)
    if expected == "integer":
        return isinstance(value, int) and not isinstance(value, bool)
    if expected == "boolean":
        return isinstance(value, bool)
    return True

def check(value, schema_node, path):
    expected_type = schema_node.get("type")
    if expected_type and not type_ok(value, expected_type):
        errors.append(f"{path}: expected type {expected_type}")
        return
    if isinstance(value, dict):
        if schema_node.get("additionalProperties") is False:
            allowed = set(schema_node.get("properties", {}).keys())
            for key in value:
                if key not in allowed:
                    errors.append(f"{path}.{key}: unknown property")
        for key in schema_node.get("required", []):
            if key not in value:
                errors.append(f"{path}.{key}: required property missing")
        for key, sub_schema in schema_node.get("properties", {}).items():
            if key in value:
                check(value[key], sub_schema, f"{path}.{key}")
    elif isinstance(value, list):
        item_schema = schema_node.get("items")
        if item_schema is not None:
            for idx, item in enumerate(value):
                check(item, item_schema, f"{path}[{idx}]")
        if schema_node.get("uniqueItems") and len(value) != len(set(map(repr, value))):
            errors.append(f"{path}: items are not unique")
        if "minItems" in schema_node and len(value) < schema_node["minItems"]:
            errors.append(f"{path}: fewer than {schema_node['minItems']} items")
    elif isinstance(value, str):
        if "minLength" in schema_node and len(value) < schema_node["minLength"]:
            errors.append(f"{path}: shorter than {schema_node['minLength']}")
        if "pattern" in schema_node and not re.search(schema_node["pattern"], value):
            errors.append(f"{path}: does not match pattern {schema_node['pattern']}")
        if "enum" in schema_node and value not in schema_node["enum"]:
            errors.append(f"{path}: not in enum {schema_node['enum']}")

# Tripwire: walk every schema node and flag keywords this validator does not implement.
# If the schema gains e.g. maxItems, oneOf, const, format they would silently no-op
# without this check.
KNOWN_KEYWORDS = {
    # Meta / annotations — safe to ignore, do not affect validation output
    "$schema", "title", "description", "$comment",
    # Validation keywords actually implemented above
    "type", "required", "additionalProperties", "properties",
    "items", "uniqueItems", "minItems", "minLength", "pattern", "enum",
}

def collect_schema_nodes(node, acc=None):
    if acc is None:
        acc = []
    if not isinstance(node, dict):
        return acc
    acc.append(node)
    for sub in node.get("properties", {}).values():
        collect_schema_nodes(sub, acc)
    if isinstance(node.get("items"), dict):
        collect_schema_nodes(node["items"], acc)
    if isinstance(node.get("additionalProperties"), dict):
        collect_schema_nodes(node["additionalProperties"], acc)
    return acc

for _schema_node in collect_schema_nodes(schema):
    for _kw in _schema_node:
        if _kw not in KNOWN_KEYWORDS:
            errors.append(
                f"schema uses keyword '{_kw}' which this validator does not implement — "
                "add support or remove the keyword from the schema"
            )

check(manifest, schema, "$")

if errors:
    print("\n".join(errors))
    sys.exit(1)
PY
)"; then
    pass "kit.manifest.json conforms to schema"
else
    fail_with_output "kit.manifest.json schema violations" "$schema_violations"
fi

# Manifest-listed files are present.
if missing_paths="$(python3 - "$repo_root" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / "kit.manifest.json").read_text(encoding="utf-8"))
missing = [
    rel for rel in manifest.get("installed_files", []) + manifest.get("generated_outputs", [])
    if not (root / rel).exists()
]

if missing:
    print("\n".join(missing))
    sys.exit(1)
PY
)"; then
    pass "manifest-listed files are present"
else
    fail_with_output "manifest-listed paths are missing" "$missing_paths"
fi

# Manifest-declared contract paths resolve and remain tracked.
if manifest_contract_issues="$(python3 - "$repo_root" <<'PY'
import json
import pathlib
import shlex
import sys

root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / "kit.manifest.json").read_text(encoding="utf-8"))
declared = set(manifest.get("installed_files", [])) | set(manifest.get("generated_outputs", []))
issues = []

for field in ("canonical_file", "campaigns_file"):
    rel = manifest.get(field, "")
    if not rel:
        continue
    if not (root / rel).exists():
        issues.append(f"{field}: missing path {rel}")
    if rel not in declared:
        issues.append(
            f"{field}: path not listed in installed_files/generated_outputs -> {rel}"
        )

entrypoint = manifest.get("validation_entrypoint", "")
for token in shlex.split(entrypoint):
    if token.startswith("-"):
        continue
    if token in {"bash", "sh", "python", "python3", "env", "make"}:
        continue
    if "/" not in token and not token.startswith("."):
        continue
    if not (root / token).exists():
        issues.append(f"validation_entrypoint: missing path {token}")
    if token not in declared:
        issues.append(
            "validation_entrypoint: path not listed in installed_files/generated_outputs -> "
            f"{token}"
        )

if issues:
    print("\n".join(issues))
    sys.exit(1)
PY
)"; then
    pass "manifest contract paths resolve and are tracked"
else
    fail_with_output "manifest contract paths drifted" "$manifest_contract_issues"
fi

# Orphan-file check across repo root and tracked_directories.
if orphan_paths="$(python3 - "$repo_root" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / "kit.manifest.json").read_text(encoding="utf-8"))
declared = set(manifest.get("installed_files", [])) | set(manifest.get("generated_outputs", []))
tracked_roots = set(manifest.get("tracked_directories", []))
ignore_dir_names = {".git", "__pycache__", ".pytest_cache", ".mypy_cache", "node_modules"}
orphans = []

for path in sorted(root.iterdir()):
    rel = path.relative_to(root).as_posix()
    if rel in ignore_dir_names:
        continue
    if path.is_file() and rel not in declared:
        orphans.append(rel)
    if path.is_dir() and rel not in tracked_roots:
        orphans.append(f"{rel}/")

for tracked_rel in tracked_roots:
    tracked_root = root / tracked_rel
    if not tracked_root.is_dir():
        continue
    for path in sorted(tracked_root.rglob("*")):
        if not path.is_file():
            continue
        parts = path.relative_to(root).parts
        if any(part in ignore_dir_names for part in parts):
            continue
        rel = path.relative_to(root).as_posix()
        if rel not in declared:
            orphans.append(rel)

if orphans:
    print("\n".join(orphans))
    sys.exit(1)
PY
)"; then
    pass "no orphan files in repo root or tracked directories"
else
    fail_with_output "orphan files found in repo root or tracked directories (add to installed_files or generated_outputs in kit.manifest.json)" "$orphan_paths"
fi

# Marker-token cleanliness in generated outputs (respecting excludes).
if marker_hits="$(python3 - "$repo_root" <<'PY'
import json
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / "kit.manifest.json").read_text(encoding="utf-8"))
excludes = set(manifest.get("marker_scan_excludes", []))
generated_dir = root / "docs" / "wesnoth" / "generated"
pattern = re.compile(r"\[UNVERIFIED\]|\[NEEDS REVIEW\]")
hits = []

if generated_dir.is_dir():
    for path in sorted(generated_dir.rglob("*.md")):
        rel = path.relative_to(root).as_posix()
        if rel in excludes:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for line_number, line in enumerate(text.splitlines(), start=1):
            if pattern.search(line):
                hits.append(f"{rel}:{line_number}: {line.strip()}")

if hits:
    print("\n".join(hits))
    sys.exit(1)
PY
)"; then
    pass "generated outputs are marker-token clean"
else
    fail_with_output "generated outputs still contain marker tokens" "$marker_hits"
fi

# Citation URL allowlist check across text-bearing files (respecting excludes).
if citation_violations="$(python3 - "$repo_root" <<'PY'
import json
import pathlib
import re
import sys
from urllib.parse import urlparse

root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / "kit.manifest.json").read_text(encoding="utf-8"))
allowed = [entry.lower().rstrip("/") for entry in manifest.get("allowed_citation_domains", [])]
excludes = set(manifest.get("citation_scan_excludes", []))
text_suffixes = {".md", ".cfg", ".lua", ".json", ".mdc", ".txt", ".sh"}
url_pattern = re.compile(r"https?://[^\s<>'\"\]\)]+")
violations = []

for path in root.rglob("*"):
    if not path.is_file():
        continue
    rel_path = path.relative_to(root)
    if any(part in {".git", "__pycache__"} for part in rel_path.parts):
        continue
    if path.suffix.lower() not in text_suffixes:
        continue
    if path.name in {"LICENSE", "kit.manifest.schema.json"}:
        continue
    rel = rel_path.as_posix()
    if rel in excludes:
        continue
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        continue

    for line_number, line in enumerate(content.splitlines(), start=1):
        for raw_url in url_pattern.findall(line):
            url = raw_url.rstrip(".,;:")
            parsed = urlparse(url)
            candidate = (parsed.netloc + parsed.path).lower().rstrip("/")
            host = parsed.netloc.lower()

            allowed_match = False
            for allowed_entry in allowed:
                if "/" in allowed_entry:
                    if candidate == allowed_entry or candidate.startswith(allowed_entry + "/"):
                        allowed_match = True
                        break
                elif host == allowed_entry:
                    allowed_match = True
                    break

            if not allowed_match:
                violations.append(f"{rel_path}:{line_number}: {url}")

if violations:
    print("\n".join(violations))
    sys.exit(1)
PY
)"; then
    pass "all citation URLs use allowed canonical domains"
else
    fail_with_output "citation URLs use disallowed domains" "$citation_violations"
fi

# Evidence-anchor schema check on generated outputs.
if anchor_violations="$(python3 - "$repo_root" <<'PY'
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
generated_dir = root / "docs" / "wesnoth" / "generated"
anchor_pattern = re.compile(r"VERIFIED\(([^)]*)\)")
source_pattern = re.compile(
    r"^(canonical|changelog:1\.19\.(0|[1-9][0-9]*)|wiki:[A-Za-z0-9_.]+(#[A-Za-z0-9_.\-]+)?)$"
)
violations = []

if generated_dir.is_dir():
    for path in sorted(generated_dir.rglob("*.md")):
        rel = path.relative_to(root).as_posix()
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for line_number, line in enumerate(text.splitlines(), start=1):
            for match in anchor_pattern.finditer(line):
                source = match.group(1)
                if not source_pattern.match(source):
                    violations.append(f"{rel}:{line_number}: VERIFIED({source})")

if violations:
    print("\n".join(violations))
    sys.exit(1)
PY
)"; then
    pass "evidence anchors conform to schema"
else
    fail_with_output "evidence anchors violate schema (see docs/wesnoth/EVIDENCE_ANCHORS.md)" "$anchor_violations"
fi

# Anchor freshness: no changelog:1.19.<m> anchor may exceed manifest.as_of_changelog.
if freshness_violations="$(python3 - "$repo_root" <<'PY'
import json
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
manifest = json.loads((root / "kit.manifest.json").read_text(encoding="utf-8"))
ceiling = manifest["as_of_changelog"]
ceiling_patch = int(ceiling.rsplit(".", 1)[1])
generated_dir = root / "docs" / "wesnoth" / "generated"
anchor_pattern = re.compile(r"VERIFIED\(changelog:1\.19\.(0|[1-9][0-9]*)\)")
violations = []

if generated_dir.is_dir():
    for path in sorted(generated_dir.rglob("*.md")):
        rel = path.relative_to(root).as_posix()
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for line_number, line in enumerate(text.splitlines(), start=1):
            for match in anchor_pattern.finditer(line):
                patch = int(match.group(1))
                if patch > ceiling_patch:
                    violations.append(
                        f"{rel}:{line_number}: changelog:1.19.{patch} exceeds as_of_changelog={ceiling}"
                    )

if violations:
    print("\n".join(violations))
    sys.exit(1)
PY
)"; then
    pass "no changelog anchors exceed as_of_changelog ceiling"
else
    fail_with_output "changelog anchors exceed as_of_changelog ceiling (raise the manifest field or correct the anchor)" "$freshness_violations"
fi

# Companion-citation enforcement: every distinct wiki: / changelog: anchor used in a
# generated file must have at least one HTTPS URL companion in that same file or in
# Campaigns_1.19.md (as documented in docs/wesnoth/EVIDENCE_ANCHORS.md).
if companion_violations="$(python3 - "$repo_root" <<'PY'
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
generated_dir = root / "docs" / "wesnoth" / "generated"
campaigns_file = root / "docs" / "wesnoth" / "Campaigns_1.19.md"

url_re = re.compile(r"https?://[^\s)\"'>\]]+")
anchor_re = re.compile(r"VERIFIED\((changelog:[^)]+|wiki:[^)]+)\)")

# Build URL pool from Campaigns_1.19.md (covers all generated files).
campaigns_urls = set()
if campaigns_file.is_file():
    for m in url_re.finditer(campaigns_file.read_text(encoding="utf-8")):
        campaigns_urls.add(m.group())

violations = []

if generated_dir.is_dir():
    for path in sorted(generated_dir.rglob("*.md")):
        rel = path.relative_to(root).as_posix()
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue

        file_urls = set(m.group() for m in url_re.finditer(text))
        all_urls = file_urls | campaigns_urls

        for source in set(m.group(1) for m in anchor_re.finditer(text)):
            if source.startswith("changelog:"):
                # Any URL containing "changelog" serves as companion.
                if not any("changelog" in u for u in all_urls):
                    violations.append(
                        f"{rel}: anchor '{source}' has no companion changelog URL"
                    )
            elif source.startswith("wiki:"):
                # Strip optional #fragment; companion must contain wiki.wesnoth.org/<Page>.
                page = source[len("wiki:"):].split("#")[0]
                needle = f"wiki.wesnoth.org/{page}"
                if not any(needle in u for u in all_urls):
                    violations.append(
                        f"{rel}: anchor '{source}' has no companion URL for wiki.wesnoth.org/{page}"
                    )

if violations:
    print("\n".join(violations))
    sys.exit(1)
PY
)"; then
    pass "companion citations present for all non-canonical anchors"
else
    fail_with_output "missing companion citations (see docs/wesnoth/EVIDENCE_ANCHORS.md)" "$companion_violations"
fi

if [[ $status -eq 0 ]]; then
    printf 'Validation completed successfully.\n'
fi

exit "$status"
