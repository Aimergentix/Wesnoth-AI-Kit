# Canonical Wesnoth 1.19 Reference (Project Baseline)

Last updated: 2026-04-27

## Branch and runtime baseline

- Target line: `1.19.x` (development branch)
- Lua runtime: `5.4` in Wesnoth `1.19.x`
- Treat `1.18.x` and `1.19.x` as distinct API surfaces

## High-impact migration notes

- Lua location objects use named tuple members:
  - use `loc.x`, `loc.y`
  - avoid positional indexing (`loc[1]`, `loc[2]`)
- WFL removals:
  - replace `unit.side` with `unit.side_number`
  - replace `terrain.owner` with `terrain.owner_side`

## Confirmed 1.19 additions (seed list)

- `gui.switch_theme()` (`1.19.4+`)
- `gui.show_recruit_dialog()` (`1.19.8+`)
- `gui.show_recall_dialog()` (`1.19.8+`)
- Event-scoped `$data` via `[fire_event][data]` (`1.19.9+`)
- `[have_side]` and unit dismissal keys (`1.19.10+`)

## Verification policy

- Preferred sources:
  - https://github.com/wesnoth/wesnoth/blob/master/changelog.md
  - https://wiki.wesnoth.org/LuaAPI
  - https://wiki.wesnoth.org/Luawml
  - https://wiki.wesnoth.org/UnitsWML
- If a claim is not confirmed in canonical sources, mark `[UNVERIFIED]`.
- Never invent tags/functions/properties.
