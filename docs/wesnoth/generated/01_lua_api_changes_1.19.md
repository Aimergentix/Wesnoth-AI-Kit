# 01 - Lua API Changes in Wesnoth 1.19.x

Target: 1.19.x

## Confirmed API/runtime changes

- Wesnoth 1.19.x uses Lua 5.4 in the engine runtime. VERIFIED(canonical) VERIFIED(wiki:LuaAPI) VERIFIED(changelog:1.19.4)
- Lua API location objects moved to named tuples; use `loc.x` and `loc.y` instead of positional indexing. VERIFIED(canonical) VERIFIED(changelog:1.19.0)
- New function `gui.switch_theme()` allows changing GUI2 theme during scenario runtime. VERIFIED(canonical) VERIFIED(changelog:1.19.4)
- New functions `gui.show_recruit_dialog()` and `gui.show_recall_dialog()` were added for in-game custom recruit/recall UIs. VERIFIED(canonical) VERIFIED(changelog:1.19.8)
- `rich_label` supports `on_link_click` event handler to capture link clicks in UI content. VERIFIED(changelog:1.19.9)
- `wesnoth.terrain_types` gained `mvt_alias` and `def_alias` keys for terrain metadata access. VERIFIED(changelog:1.19.10)
- `wml.valid_var` was added for validating WML variable paths from Lua-facing interfaces. VERIFIED(changelog:1.19.19)

## Migration implications for existing add-ons

- Replace any location tuple indexing like `loc[1]`/`loc[2]` with `loc.x`/`loc.y` to avoid brittle behavior in modern codepaths. VERIFIED(canonical) VERIFIED(changelog:1.19.0)
- Prefer `gui.show_recruit_dialog()` and `gui.show_recall_dialog()` for controlled UX instead of ad-hoc menu emulation. VERIFIED(changelog:1.19.8)
- If your add-on hot-swaps themes for scenario mood/branding, use `gui.switch_theme()` directly and keep fallback theme IDs documented. VERIFIED(changelog:1.19.4)

## Compatibility notes

- For 1.19.x baseline add-ons, treat Lua 5.4 semantics as authoritative. VERIFIED(canonical) VERIFIED(wiki:LuaAPI)
- APIs listed above are all present in 1.19.x releases identified in changelog anchors. VERIFIED(changelog:1.19.4) VERIFIED(changelog:1.19.8) VERIFIED(changelog:1.19.9) VERIFIED(changelog:1.19.10) VERIFIED(changelog:1.19.19)
