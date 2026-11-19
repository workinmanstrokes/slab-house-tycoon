# Slab House Tycoon

> **Buy the lot, spot the flaw, grade the gem, sell it live.**

A 3D simulation and tycoon game for PC and Mobile. You run a high-end trading
card shop and live auction house: buy mystery lots of sports, anime, and comic
trading cards, inspect rare pulls at the Inspection Desk, submit the best ones
for professional grading, and sell graded slabs in a live-streaming virtual
auction where hype and chat-bot bidders set the price.

## What it is

- **Buy mystery lots** from tiered sports, anime, and comic suppliers.
- **Open packs** and reveal cards with rarity and a hidden true condition.
- **Inspection Desk** — a draggable magnifier checks centering ratios,
  corners, edges, and surface print lines on rare pulls. Mark flaws and
  decide whether a card is worth grading.
- **Grading** — pay to submit a card and hope for a pristine 10, which
  multiplies its value.
- **Live auction** — a timed mini-game with a hype meter, chat-bot bidders,
  rising bids, and a gavel slam to close the sale.
- **Shop upgrades** — display cases, lighting, and neon signs that boost hype
  and sale prices, plus higher-tier supplier boxes as you progress.
- **Realistic 3D cards** — flip and rotate cards with dynamic holographic and
  foil shader effects inside a polished, modern hobby shop.

## Tech

- **Engine:** Godot 4 (GDScript) — one codebase exports to PC and mobile,
  with built-in shader/material support for holo/foil cards.
- **Art:** 3D card models with a custom holographic shader, modern hobby
  shop environment.

## How to run

1. Install **Godot 4.x** (4.3 or newer) from https://godotengine.org.
2. Clone this repo and open `project.godot` in Godot.
3. Press **F5** (or the Play button) to run the main scene
   (`scenes/main.tscn`).

### PC / mobile export

- **PC:** Project → Export → add the Windows/Linux preset, export.
- **Mobile:** Project → Export → add the Android/iOS preset (requires the
  Godot export templates and, for Android, the Android SDK). Touch controls
  are handled through the same input actions as mouse input.

## Project layout

| Path | Purpose |
| --- | --- |
| `project.godot` | Godot 4 project configuration and export settings |
| `scenes/main.tscn` | Main 3D shop scene and UI root |
| `scripts/main.gd` | Game loop, currency, shop state, screen switching |
| `scripts/card.gd` | 3D card model, flip/rotate, foil/holo shader control |
| `data/cards.json` | Initial card sets, rarities, suppliers, base values |

## Build milestones

1. Playable skeleton: 3D shop room, UI shell, currency and save, buy a lot
   and receive a random card.
2. Card data, pack opening, and 3D card model with holo/foil shader.
3. Inspection Desk with magnifier, flaw marking, and
   centering/corner/edge/surface checks.
4. Grading submission, cost, and 1–10 reveal tied to true condition.
5. Live auction with hype meter, chat-bot bidders, timed bidding, and
   gavel slam.
6. Shop upgrades and higher-tier supplier boxes with progression and
   economy balance.
7. Mobile touch controls, PC and mobile exports, tuning, and polish.

## Open questions

- Should cards use fictional sets or real licensed sports/anime/comic IP?
- Paid game or free-to-play with in-app purchases — how should the currency
  economy be balanced?
- Is the auction strictly single-player against chat-bot bidders, or is any
  real multiplayer intended later?
