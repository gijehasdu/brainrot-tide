# Brainrot Tide

Brainrot Tide is a 3D Steal-a-Brainrot-style game for Roblox: absurd characters wander a tidal island meadow; grab them, carry them home, and set them on your base pads to earn cash every second; hatch eggs, chase rarities and gold mutations, and rebirth for permanent income. When the tsunami warning sounds, run: the wave takes whatever you are carrying in the open.

## How to play

- Grab brainrots in the meadow and carry them home; carrying makes you slower.
- Place brainrots on one of your six base pads to earn income every second.
- Sell brainrots directly from their pad when you want cash back.
- Buy eggs at the plaza shop in three tiers to hatch new characters.
- Rebirth at the shrine to reset your progress for permanent income bonuses.
- A tsunami arrives about every 90 seconds. Bases and the plaza are safe; the open meadow is not.

## The cast

The rarity ladder is Common < Uncommon < Rare < Epic < Legendary < Mythic. Meet 12 original characters: Croissant Boxer, Toaster Pup, Shark in Sneakers, Banana Butler, Cactus Cowboy, Fridge Penguin, Disco Mushroom, Robo Noodle, Dragon Taco, Wizard Baguette, Galaxy Lobster, and TV Head Titan. Any character can appear with a gold mutation (4% chance), which pays 5x its normal income.

## Under the hood

Everything is procedural: the island, bases, characters, and eggs are built from Parts by Luau code at runtime, with no toolbox assets. The module map is:

- `Config` — character, rarity, egg, and game balance data.
- `BrainrotFactory` — builds the figures and eggs.
- `WorldBuilder` — builds the island and its world layout.
- `PlayerData` — leaderstats and pcall-guarded DataStore persistence.
- `init.server` — gameplay, economy, and tsunami systems.
- `client/Game.client` — the HUD.

The economy is server-authoritative. DataStore saves Cash, Rebirths, and your placed roster.

## Build and hand in

Build the Roblox place with Rojo:

```sh
rojo build default.project.json --output game.rbxl
```

Then run the hand-in command from the project root:

```sh
mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts
```

`PLAY.json` names the published place. This project is licensed under MIT; see [LICENSE](LICENSE).
