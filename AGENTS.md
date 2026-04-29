# Wesnoth Coding Instructions (WML + Lua, 1.19.x)

## Scope

- Target branch: `1.19.x` development line.
- Do not assume `1.18.x` compatibility unless explicitly requested.

## Source of truth

Always prefer the project canonical reference:
- `docs/wesnoth/WML_1.19_CANONICAL.md`
- Write all generated pipeline outputs to `docs/wesnoth/generated/`.

If uncertain about an API/tag/property:
- mark it `[UNVERIFIED]`
- avoid inventing replacements

## WML and Lua rules

- Use Lua named location tuples (`loc.x`, `loc.y`), not positional indexing.
- Avoid deprecated or removed WFL fields (`unit.side`, `terrain.owner`).
- Include minimum version gates in examples:
  - Lua: `-- Requires: 1.19.X+`
  - WML: `# Requires: 1.19.X+`

## Change safety

- Prefer small, isolated edits.
- For behavior changes, include a migration note.
- Do not silently rewrite legacy content without calling out compatibility impact.
- Keep generated task artifacts under `docs/wesnoth/generated/` instead of project root.
