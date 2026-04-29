# 02 - WML Engine Changes in Wesnoth 1.19.x

Target: 1.19.x

## Confirmed WML engine changes

- WFL-facing properties `unit.side` and `terrain.owner` were removed; use `unit.side_number` and `terrain.owner_side`. VERIFIED(canonical) VERIFIED(changelog:1.19.4) VERIFIED(changelog:1.19.5)
- `[fire_event][data]` payload is exposed as `$data` inside the fired event context. VERIFIED(canonical) VERIFIED(changelog:1.19.9)
- New conditional tag `[have_side]` was added; it accepts `[filter_side]` arguments and returns true if a matching side exists. VERIFIED(canonical) VERIFIED(changelog:1.19.10)
- `[unit]dismissable` and `[unit]block_dismiss_message` keys were added for recall-dialog dismiss behavior control. VERIFIED(canonical) VERIFIED(changelog:1.19.10)
- `[side][variables]` no longer initializes implicit leader-unit variables; leader-specific variables now require `[leader]`. VERIFIED(changelog:1.19.8)
- `[set_variables]` can be used inside `[modify_side]` and `[modify_unit]`. VERIFIED(changelog:1.19.19)
- `[variable]blank=yes` can test whether a variable is empty. VERIFIED(changelog:1.19.19)

## Migration checklist

- Replace WFL references to removed properties with side_number/owner_side equivalents. VERIFIED(canonical) VERIFIED(changelog:1.19.5)
- Migrate custom existence checks from manual side counting to `[have_side]`. VERIFIED(changelog:1.19.10)
- For event payloads, prefer `[fire_event][data]` and consume via `$data.*` in handlers for cleaner event contracts. VERIFIED(changelog:1.19.9)
- If you rely on side init variables affecting leaders, move that logic to explicit leader construction/update. VERIFIED(changelog:1.19.8)

## Practical effect on add-ons

- 1.19.x narrows ambiguous side/terrain ownership lookups and improves explicitness in WFL and event data flow. VERIFIED(canonical) VERIFIED(changelog:1.19.4) VERIFIED(changelog:1.19.9)
- Recall management became more configurable via dismiss-related unit keys. VERIFIED(changelog:1.19.10)
