# 03 - WFL Changes in Wesnoth 1.19.x

Target: 1.19.x

## Confirmed WFL changes

- WFL no longer supports `unit.side`; use `unit.side_number` instead. VERIFIED(canonical) VERIFIED(changelog:1.19.4) VERIFIED(changelog:1.19.5)
- WFL no longer supports `terrain.owner`; use `terrain.owner_side` instead. VERIFIED(canonical) VERIFIED(changelog:1.19.4) VERIFIED(changelog:1.19.5)
- New WFL functions were added in 1.19.15: `nearest_loc`, `run_file`, `debug_label`, `is_shrouded`, `is_fogged`. VERIFIED(changelog:1.19.15)
- 1.19.23+dev includes WFL fixes for empty map-literal serialization and decimal conversion behavior. VERIFIED(changelog:1.19.23)

## Migration patterns

- Property rename pattern:
  - old: `unit.side`
  - new: `unit.side_number`
  - old: `terrain.owner`
  - new: `terrain.owner_side`
  VERIFIED(canonical) VERIFIED(changelog:1.19.5)

- Utility function adoption:
  - replace ad-hoc nearest-hex helpers with `nearest_loc`
  - use `is_shrouded` / `is_fogged` where visibility checks were previously indirect
  VERIFIED(changelog:1.19.15)

## Risk notes

- Add-ons that still use removed property names can fail at runtime or silently mis-evaluate formulas, depending on call site and validation mode. VERIFIED(changelog:1.19.5)
- During migration, test formula-heavy events and filters first, especially ownership- and side-dependent logic. VERIFIED(canonical)
