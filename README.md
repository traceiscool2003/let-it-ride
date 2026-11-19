# LET IT RIDE

A 2D parkour-and-brawling roguelike heist through The Pit, an illegal casino buried under the city. Built in Godot 4.7 with GDScript only. It needs no asset files: the art is drawn in code, and the sound effects and music are synthesized live.

**Story:** Rico, a degenerate gambler, climbs five casinos (Atlantic Shitty, Reno, Biloxi, Fremont and the Bellagiro on the Strip) to win his brother James back from The House. Marlow talks you through it over the radio. Beating The House at Texas Hold'em ends the first story; High Roller mode opens after.

## Run it
Open `project.godot` in Godot 4.7 and press F5.

## Controls
| Action | Keyboard | Gamepad |
|---|---|---|
| Move | A/D or Arrows | Left stick / D-pad |
| Jump (hold for height) | Space / Z / C | A |
| Air dash (8-way) | Shift / X | B / RB |
| Strike (3-hit combo; Up = uppercut, Down in air = pogo) | F / J | X |
| Parry (tight window, stuns and reflects) | Q / K | LB / Y |
| Slide | Hold Down while running | Down |
| Doors, slots, tables, bar | Up | Up |
| Pause menu / Restart | Esc / R | Start / Back |

## What's in it
- **Movement:**
  - wall run, wall jump, ledge grab and mantle, slide, auto-vault, air dash and stomp
  - every number is in `config/movement.tres`, including combat timings
- **Combat:**
  - strike combos with a finisher, pogo strikes and parries
  - parried cards and roulette balls fly back at whoever threw them
  - hitstop and slow-mo on big hits
- **Enemies:**
  - Guards: telegraphed punches you can parry
  - Bats: swoop down at you
  - Dealers: throw cards from range
  - Heavies: a riot shield blocks frontal strikes, so flank them, stomp them, or break the guard with a finisher
- **Bosses:** three bosses with two phases each, health bars with a ghost-damage chunk, and stun windows.
  - Table bosses: card fans, charges and ground slams
  - Later bosses: add bouncing balls and wheels
  - The House: adds summoned guards
- **Economy:**
  - Pot, Flow multiplier, and the Cash Out vs Let It Ride choice at each door
  - the House Rules list grows while you ride
- **Casino:** seven games, all bet from your Pot:
  - **Slots:** 3x3 reels, 5 paylines and wild chips. Every cabinet rolls its own hidden odds, and a hidden heat drifts each spin, so machines run hot and cold.
  - **Blackjack:** hit, stand and double down.
  - **Video Poker:** Jacks or Better.
  - **High Roller Hold'em:** you play against the dealer.
  - **Baccarat:** played with the real third-card rules.
  - **Hi-Lo Ladder.**
  - **Roulette:** the full betting board.
  - After any win you can play **Double or Nothing** up to 5 times.
  - Bet sizes grow with depth: $5 up to $2,500, plus Half and All In.
- **Zones:** each one has its own art, lighting, table mix and security mix, and the loading screens are illustrated.
  - The Slot Hall (floors 1-4)
  - The Back Rooms (5-8)
  - The Vault (9-12)
  - High Limit (13 and below)
- **Progression:**
  - XP from everything you do.
  - Levels give SKILL POINTS.
  - The Fence skill tree has 5 branches and 20 skills: Body, Fists, Feet, Fortune and Gambler.
  - Difficulty grows with your floor, level and skills, and elite guards show up deeper down.
- **Presentation:**
  - An animated, illustrated title screen.
  - An opening cutscene that introduces every character with name cards.
  - A "TRY IT" controls coach on your first run.
  - The BUST slot-reel death transition with a trapdoor drop back into the Lobby.
- **Lucky the bartender:** sells drinks mid-run.
- **Environment:**
  - real-time 2D lights with shadows, neon signs, slot cabinets and god rays
  - breakables: glass you can smash through, cracked secret walls, crumbling floors, and crates, urns and display cases full of chips
  - grass that reacts to you, swinging vines and glowing mushrooms
  - a post-processing pass (bloom, vignette and an iris transition)
- **Animation:** a procedural IK rig for every character, a physics scarf and afterimages.
- **Music:** calm generative piano while exploring; it crossfades into an intense drum-and-bass battle track near enemies and in boss fights.
- **Meta:**
  - The Fence skill tree: 5 branches and 20 skills, paid for with SKILL POINTS from levelling up (The Fence also sells extra points for banked cash)
  - 3 playable runners: Rook; Dice, unlocked by beating the first boss; James, unlocked by finishing the story
  - 31 trophies
  - saved settings and stats

## Tuning
- **Feel:** edit `config/movement.tres` in the Inspector.
- **Flow, economy and boss frequency:** select the `Main` node in `scenes/main.tscn`.
- **Story text:** `scripts/story.gd`.
- **Skills, runners and trophies:** the `SKILLS`, `CHARACTERS` and `TROPHIES` tables at the top of `scripts/main.gd`.

## Tests
- `godot --headless --path . --script res://tests/parse.gd` compile-checks every script.
- `godot --headless --path . --script res://tests/smoke.gd` runs generation, combat, a boss, the casino, skills and death.
- `godot --headless --path . --script res://tests/systems.gd` covers the Lobby, dialogue, charms, menus, loans, side bets, vaults, tickets, settings and saves.
- `godot --headless --path . --script res://tests/casino_test.gd` covers the poker hand ranks, baccarat rules, slot odds, every game end to end, XP and skill points.
- `godot --headless --path . --script res://tests/balance.gd` simulates thousands of rounds and reports each game's house edge.
- `godot --path . --script res://tests/capture_new.gd` and `capture_casino.gd` save screenshots of the title, loading screens, cutscenes, the death transition, every casino game, the skill tree and each zone.
- `AAA_CHECKLIST.md` lists every feature and where it lives in the code.
- `godot --path . --script res://tests/capture.gd` saves screenshots to `user://`.
- `godot --path . --script res://tests/poses.gd` saves a gallery of every animation pose.

## Voice acting

Every line of dialogue can be voiced. Drop `res://voice/<character>/<line_id>.ogg` (or `.wav`/`.mp3`) and the game plays it automatically; missing files fall back to pitched text blips.

- `HOW_TO_RECORD.md`: beginner step-by-step guide, recipe cards, per-character tick-box checklist
- `VOICE_CAST.md`: how each character should sound
- `VOICE_SCRIPT.md`: every line with its ID
- Press **F3** in game for the Voice Test menu. Settings > Audio has Voice Volume and Voice Filters.
- After editing `scripts/voice_lines*.gd` or `voice_profiles.gd`, regenerate the docs and folders with:
  `godot --headless --path . --script res://tools/gen_voice_kit.gd`

## The redesign (2026-11)

- 5 cities x 5 floors (4 explore + 1 table-game boss); final boss THE HOUSE (Hold'em). `scripts/cities.gd`, `scripts/boss_defs.gd`.
- Abilities and buffs are clothing (`scripts/wardrobe.gd`); 8 ranged weapons (`weapons.gd`); 13 enemy kinds (`enemy_types.gd`).
- Controls: G fire, TAB weapon, E focus-heal, M map, F3 voice test, F4 journal.
- Tests: `godot --headless --path . --script res://tests/<parse|smoke|systems|casino_test|roster_test|boss_test|voice_test>.gd`
- See `REDESIGN_CHECKLIST.md` for the full status.
