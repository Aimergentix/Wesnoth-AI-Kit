# 05 - Multiplayer and Campaign Analysis (Wesnoth 1.19.x)

Target: 1.19.x

## MP infrastructure and engine-facing changes

- Multiplayer queueing groundwork was added in 1.19.10. VERIFIED(changelog:1.19.10)
- Roadmap planning around 1.19.10 also references lobby queue work as a branch goal. VERIFIED(wiki:1.19_Roadmap)

## Mainline campaign movement in 1.19.x

- `Dusk of Dawn` entered mainline in 1.19.18. VERIFIED(changelog:1.19.18)
- `Heir to the Throne` revision was added to mainline in 1.19.18, while classic HttT remained as a separate campaign entry. VERIFIED(changelog:1.19.18)
- `Of Pearls and Pirates` was added to mainline in 1.19.21. VERIFIED(changelog:1.19.21)

## Campaign rework direction and branch timing

- Roadmap notes identify new/revised campaign tracks including TDG, HttT revised, and other SP reworks. VERIFIED(wiki:1.19_Roadmap)
- 1.19.21 marks feature/string freeze start; after that point API changes are bug-fix only. VERIFIED(wiki:1.19_Roadmap)
- 1.19.24 marks API freeze start (RC phase). VERIFIED(wiki:1.19_Roadmap)

## Practical implications for MP campaign authors

- Avoid relying on post-freeze API additions in late 1.19.x branch cycles; treat freeze boundaries as hard compatibility constraints. VERIFIED(wiki:1.19_Roadmap)
- Prefer explicit sync-safe Lua patterns for player-choice logic to reduce OOS risk in cooperative MP campaigns. VERIFIED(wiki:LuaAPI)
- If your campaign uses custom recruit/recall flows, use 1.19.8 dialog APIs for deterministic UI behavior across clients. VERIFIED(changelog:1.19.8)

## Practical implications for SP campaign maintainers targeting 1.19.x

- Campaign integration cadence in 1.19.x was active through 1.19.21 and then shifted to freeze discipline; maintenance should prioritize bug-fix clarity and regression safety. VERIFIED(changelog:1.19.18) VERIFIED(changelog:1.19.21) VERIFIED(wiki:1.19_Roadmap)

## Summary

- 1.19.x delivered a meaningful set of campaign-level content transitions plus targeted MP/lobby infrastructure work, while enforcing stricter stabilization gates in late-cycle versions. VERIFIED(changelog:1.19.10) VERIFIED(changelog:1.19.18) VERIFIED(changelog:1.19.21) VERIFIED(wiki:1.19_Roadmap)
