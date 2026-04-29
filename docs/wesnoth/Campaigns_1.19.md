# Campaign Research Notes — Wesnoth 1.19.x

<!-- source-metadata
last-updated: 2026-04-28
allowed-domains: wiki.wesnoth.org, wesnoth.org, forums.wesnoth.org, github.com/wesnoth, raw.githubusercontent.com/wesnoth
sources-verified-against: wiki.wesnoth.org/1.19_Roadmap, raw.githubusercontent.com/wesnoth/wesnoth/master/changelog.md
-->

> **Policy**: All citations in this file must reference canonical Wesnoth sources only.
> Non-canonical third-party links are out of policy for this repository and should
> be treated as validation failures during review.

## Campaign and MP Notes for 1.19.x

The 1.19 development branch combines two different kinds of information:
release-confirmed content changes recorded in the upstream changelog, and
roadmap-tracked campaign work that describes branch direction but not necessarily
completed mainline integration. This file keeps those categories separate.[^1][^2]

### Release-confirmed mainline campaign additions and revisions

The following items are directly confirmed by the upstream 1.19 changelog:

- **Dusk of Dawn** — added to mainline in **1.19.18**.[^1]
- **Heir to the Throne (Revised)** — added to mainline in **1.19.18**;
  **Heir to the Throne, Classic** remained as a separate campaign entry.[^1]
- **Of Pearls and Pirates** — added to mainline in **1.19.21** as a new
  peasants-and-merfolk campaign tied to the tutorial line.[^1]

### Roadmap-tracked campaign work in the 1.19 branch

The 1.19 roadmap also documents campaign work that was planned, in progress, or
being staged for branch integration. Treat these as branch-direction notes rather
than release confirmation unless the changelog independently confirms them.[^2]

- The roadmap tracks **The Deceiver's Gambit**, **The South Guard: Tutorial**,
  **Dusk of Dawn**, and **Heir to the Throne (Revised)** under the branch's
  single-player campaign rework effort.[^2]
- The same roadmap note lists revised-campaign work for **Liberty**,
  **The Hammer of Thursagan**, **Sceptre of Fire**, and broader rework activity
  around other SP campaigns.[^2]
- `Mercenaries` appears on the roadmap as planning for **1.19.12**, but this file
  does **not** treat it as confirmed shipped mainline content because the checked
  changelog evidence here does not show a corresponding mainline-addition entry.[^1][^2]

### MP-facing branch changes relevant to campaign authors

- Multiplayer queueing groundwork was added in **1.19.10**.[^1]
- The roadmap also tracks lobby queue work as a branch goal around that period,[^2]
  which matches the changelog's incremental rollout.
- **1.19.21** marks the start of feature freeze and string freeze for the branch.[^2]
- **1.19.24** marks the start of API freeze for the RC phase.[^2]

### Scope note

Older mainline MP content such as **World Conquest** and **Isle of Mists** is
intentionally omitted from the "what's new in 1.19.x" summary because those entries
predate the 1.19 branch and do not describe new 1.19 campaign additions.[^1]

[^1]: [Upstream changelog](https://raw.githubusercontent.com/wesnoth/wesnoth/master/changelog.md)
[^2]: [1.19 Roadmap](https://wiki.wesnoth.org/1.19_Roadmap)
[^3]: [Lua API reference](https://wiki.wesnoth.org/LuaAPI)
[^4]: [Lua WML reference](https://wiki.wesnoth.org/LuaWML)
