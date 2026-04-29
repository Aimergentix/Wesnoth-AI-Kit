# 04 - Best Practices for Wesnoth 1.19.x (WML/Lua/WFL)

Target: 1.19.x

## 1) Use canonical 1.19 property names

- Replace `unit.side` with `unit.side_number` in formulas and migration patches. VERIFIED(canonical) VERIFIED(changelog:1.19.5)
- Replace `terrain.owner` with `terrain.owner_side`. VERIFIED(canonical) VERIFIED(changelog:1.19.5)

## 2) Prefer explicit event payloads

- Use `[fire_event][data]...[/data]` for structured payload passing and consume via `$data.*`. VERIFIED(canonical) VERIFIED(changelog:1.19.9)
- Keep payload keys compact and deterministic for replay safety and easier debugging. VERIFIED(changelog:1.19.9)

## 3) Prefer built-in conditionals over ad-hoc checks

- Use `[have_side]` for side existence checks rather than custom side-loop logic. VERIFIED(canonical) VERIFIED(changelog:1.19.10)

## 4) Keep recruit/recall UI customizations in supported API paths

- Use `gui.show_recruit_dialog()` / `gui.show_recall_dialog()` when presenting custom lists in gameplay UI. VERIFIED(canonical) VERIFIED(changelog:1.19.8)
- Use `gui.switch_theme()` only when you control compatible GUI2 theme assets. VERIFIED(canonical) VERIFIED(changelog:1.19.4)

## 5) Respect Lua lifecycle and save/load behavior

- Lua globals set during a running scenario do not persist across save/load; do not rely on mid-scenario globals to survive a reload. VERIFIED(wiki:LuaWML)
- Boot-time registrations from top-level `[lua]` in `_main.cfg` (for example, `wesnoth.require` calls and `wml_action` registrations) are re-executed on every load and therefore survive save/reload. VERIFIED(wiki:LuaWML)
- Top-level `[lua]` executes very early; keep it for load-time registrations and avoid runtime UI assumptions there. VERIFIED(wiki:LuaWML)

## 6) Follow named-tuple conventions in Lua

- Access location members with `.x` and `.y` to align with modern named-tuple API behavior. VERIFIED(canonical) VERIFIED(changelog:1.19.0)

## 7) MP/replay-safe scripting defaults

- For state-changing local choices in Lua, use synchronized evaluation wrappers (for example `wesnoth.sync.evaluate_single`) in multiplayer-sensitive logic. VERIFIED(wiki:LuaAPI)
- Avoid unsynced randomness in gameplay logic; use MP-safe random helpers where appropriate. VERIFIED(wiki:LuaWML)

## 8) Dismiss/recall policy should be explicit

- Configure dismissability and user messaging per unit using `[unit]dismissable` and `[unit]block_dismiss_message`. VERIFIED(canonical) VERIFIED(changelog:1.19.10)

## Quick migration checklist

- Audit formulas for removed keys (`unit.side`, `terrain.owner`). VERIFIED(changelog:1.19.5)
- Audit event contracts to adopt `$data` payloads where relevant. VERIFIED(changelog:1.19.9)
- Audit side checks and replace ad-hoc logic with `[have_side]`. VERIFIED(changelog:1.19.10)
- Audit Lua location indexing and switch to named members. VERIFIED(changelog:1.19.0)
