# LET IT RIDE: AAA 2D Checklist

**Status:** every item on this list is done and checked by the automated tests and screenshot captures.

This is every feature a polished, commercial-quality 2D action roguelike is expected to have, grouped by area and worked top to bottom.

- `[x]` means it is in the game and tested.
- `[ ]` means it is still to do.
- Each item names where it lives in the code, so you can find it.

---

## 1. First launch and onboarding
- [x] **Boot straight into an animated title screen.** No dead frames, and music starts immediately. (`hud._draw_title`, `scenery.gd`)
- [x] **Animated, illustrated title screen.** City skyline, the casino tower, searchlights, falling cards, a roulette-wheel moon, Rook on the edge of The Pit, and a neon logo. (`scenery.gd`)
- [x] **"NEW GAME" on first launch.** One button and you're in. Pressing it plays the opening cutscene right away. (`main._title_select`)
- [x] **Opening cutscene that introduces every character.** Each gets a portrait name card with a role line: Rook, Mags, The House, Vera, Lucky, Comp, Marlow. (`main._intro_steps`, `hud._draw_cast_card`)
- [x] **Chapter card after the intro.** "CHAPTER ONE: THE MARKER".
- [x] **The story stays simple.** One goal at a time: get Jules back, and bank or ride at each door.
- [x] **Objective tracker always on screen.** "Take the DESCEND door", "Reach the EXIT", boss goals. (`main.objective_lines`)
- [x] **Waypoint arrows.** A bouncing arrow over the DESCEND door, and an off-screen EXIT arrow in runs.
- [x] **One-time contextual tips.** For slots, Vera, side bets, vaults, the bar, the boss floor, loans and the Lobby. (`main._tip`)
- [x] **Guided first floor.** Floor 1 of your first run uses 60% difficulty: fewer guards and fewer spikes. A "TRY IT" coach teaches each control with your actual key, in this order: move, jump, strike, air dash, wall run, slide, parry. (`main._coach_tick`)
- [x] **Controls shown on the title screen and in Settings > Controls.**
- [x] **"!" markers over NPCs who have something new to say.**

## 2. Presentation and transitions
- [x] **Letterboxed cutscenes.** They have camera pans, zooms, shakes and title cards, and you can skip them with ESC.
- [x] **Illustrated loading screens.** One painting per place, plus a spinning chip, the floor name, a tip and a progress bar. (`scenery.painting`, `hud._draw_loading`)
  - The Lobby, the Slot Hall, the Back Rooms, the Vault and High Limit.
  - Sal's Office, the Roulette Ballroom and the Penthouse.
- [x] **Cinematic death and respawn.** BUSTED, then the collection notice. Then four slot reels slam down and stop on B-U-S-T with "THE HOUSE COLLECTS". The reels fall away and Rook drops through a trapdoor into the Lobby, landing with a dust burst and "WELCOME BACK". There is no instant teleport. (`scenery.bust_wipe`, `main._respawn_sequence`)
- [x] **Iris-in at the start of every floor.** (post shader)
- [x] **Boss intro cards.** Name and title, a low camera, and a slam.
- [x] **Boss phase callouts.** Includes the "FINAL PHASE" banner.
- [x] **Floor banner.** Each floor shows its name and a whisper line.
- [x] **Zone name card.** Shown when you enter a new zone, for example "THE BACK ROOMS".
- [x] **Ending cutscene, plus the true-ending cutscene.**

## 3. Art: characters, bosses, NPCs
- [x] **Procedural IK rig for every humanoid.** Walk cycles, combat poses and scarf physics.
- [x] **Detailed vector bosses.**
  - Big Sal: fedora, cigar smoke and brass knuckles. He loses the hat in phase 3.
  - Madame Roulette: wheel halo, gown and ball pin. Her hair falls loose in phase 3.
  - The House: cape, dollar-sign mask, orbiting dice. The mask cracks, then breaks open into slot reels.
- [x] **Three visual phases per boss.**
- [x] **Detailed NPC models.**
  - Vera: dealer's vest, shuffling cards.
  - Mags: a shark in a pinstripe suit at her ledger desk.
  - Lucky: behind a bar with bottles.
  - Jules, Comp the cat, and Marlow's payphone.
- [x] **Large illustrated portraits in dialogue.** Bosses, Vera and Mags.
- [x] **Enemy designs.** Guard, Bat, Dealer and Heavy, each with a riot shield, telegraphs and hit flashes.
- [x] **Lucky and Marlow portraits drawn as vector art.** No more pixel heads in dialogue. (`art.npc_portrait`)

## 4. Art: environments
- [x] **Dynamic 2D lights.** Shadow occluders, neon signs, lamps and god rays.
- [x] **Foliage, vines, glowing mushrooms, ambient dust and particles.**
- [x] **Three themed zones**, each with its own palette, wall art, tile style, set dressing and lighting: (`level.ZONES`)
  - **The Slot Hall** (floors 1-3): crimson velvet, gold trim, slot banks.
  - **The Back Rooms** (floors 5-7): green felt, wood paneling, smoke haze, card tables.
  - **The Vault** (floors 9-11): cold steel, rivets, gold bars, laser grid.
- [x] **Boss arenas themed to each boss.** Sal's Office, The Roulette Ballroom, The Penthouse.
- [x] **The Lobby hub.** Spotlights, neon, and every NPC on stage.
- [x] **Post-processing.** Bloom, vignette and the hurt vignette, with toggles.

## 5. Game feel
- [x] Coyote time, jump buffering, variable jump height and corner correction.
- [x] Wall run, wall jump, ledge grab and mantle, slide, auto-vault and 8-way air dash.
- [x] Hitstop, screen shake (with a slider), slow-mo on big hits, and squash and stretch.
- [x] Parry with a tight window that reflects projectiles. Knockback and invulnerability frames.
- [x] Chip magnet, chip pop-ups and the Flow meter with tiers.
- [x] Camera look-ahead (with a slider).

## 6. Core loop
- [x] **The Pot.** Cash out (safe) or let it ride (doubles your multiplier, adds a House Rule).
- [x] **8 House Rules** that stack as you ride.
- [x] **25 charms in 4 rarities.** Licensed at Vera's in the Lobby, bought on the floors.
- [x] **Side bets, Vault Doors, Mags' loans and Table Limits (Heat).**
- [x] **Riskier, bigger side bets.** Three stake sizes (Small, Big, All-In), with bigger payouts the deeper you are. (`main.SIDE_BETS`)

## 7. The casino (gambling)
- [x] **Slot machines with randomly generated, unpredictable odds.**
  - Every cabinet rolls its own hidden reel weights, paytable, volatility and RTP band.
  - A hidden streak meter drifts every spin, so the same machine runs hot and cold.
  - There are 5 cabinet themes, with a 3x3 grid, 5 paylines and wild chips. (`casino._new_machine`)
- [x] **Blackjack.** Hit, Stand and Double Down. Blackjack pays 3:2. The dealer stands on 17.
- [x] **Video Poker (Jacks or Better).** Hold or draw, with a full paytable. (`casino` "poker")
- [x] **High Roller Hold'em (Casino Hold'em vs the dealer).** Ante, then Call or Fold, then turn and river, with a dealer qualifier and an ante bonus table. (`casino` "holdem")
- [x] **Baccarat.** Player, Banker or Tie, using real third-card rules.
- [x] **Hi-Lo Ladder.** Guess higher or lower. Each rung multiplies the pot by the true odds, and you can cash out at any rung.
- [x] **Roulette with a full betting board.** Red, Black, Odd, Even, 1-18, 19-36, the three Dozens, Green 0, and a single number at 35:1.
- [x] **Double or Nothing.** After any win, gamble the payout on a card color.
- [x] **Lucky's bar.**
- [x] **Bet sizes scale with depth.** $5, $25, $100, $500, half the Pot and All-In, plus a High Limit table from a skill.
- [x] **Tables are mixed through the floors.** Deeper floors get more and better tables, and each zone favors its own games.

## 8. Progression
- [x] **XP and levels.** You earn XP from knockouts, floors, bosses, vaults, tickets, casino wins and cash-outs. Each level-up gives a SKILL POINT, with a fanfare. (`main._gain_xp`)
- [x] **Bigger skill tree.** 5 branches (BODY, FISTS, FORTUNE, FEET, GAMBLER) by 4 tiers makes 20 skills.
  - Skills cost SKILL POINTS.
  - The Fence also sells extra points for cash, at a price that rises each time.
- [x] **3 playable runners with unlocks.**
- [x] **Trophies.** 31 in total, 8 of them new: Made Man, Fully Loaded, Big Winner, Royalty, Top Rung, Double Trouble, Finders Keepers and Bouncer Bouncer.
- [x] **20 Losing Tickets.** Lore collectibles that unlock the true ending.
- [x] **Daily Deal.** A seeded run that's the same for everyone.
- [x] **Table Limits (Heat).** Opt-in difficulty for veterans.

## 9. Difficulty and balance
- [x] **Smooth difficulty curve by floor.** It controls enemy count, enemy health, enemy speed, spike density and how often Dealers and Heavies appear. Zone 1 is gentle. (`level.generate`, `enemy.setup`)
- [x] **Difficulty also scales with your level and skills.** Higher-level players face sharper security, and you are never stuck. (`main.threat()`)
- [x] **Elite guards** appear deeper down. They have a gold crown, double health and triple payout.
- [x] **Boss health scales by tier.** Bosses have phase 3 and signature attacks.
- [x] **Economy pass.** Chip values, Lucky's prices, Vera's prices, loan size, vault timers and casino house edge, all tuned with a simulation test. (`tests/balance.gd`)
- [x] **Assist mode.** Game speed and invincibility. Daily scores are flagged when assist is on.

## 10. Exploration
- [x] Cracked secret walls, breakable glass, crates, urns and display cases.
- [x] Losing Tickets and Vault Doors.
- [x] **Hidden stash rooms.** Behind cracked walls, holding gold chips and a guaranteed charm chance. (`level._stash`)
- [x] **Minimap with fog of war.**

## 11. Audio
- [x] Adaptive synthesized music: calm piano that crossfades into a battle track and a boss tempo.
- [x] Synthesized sound effects for every action.
- [x] Master, Music, SFX and dialogue-blip volume, plus mute when the window is unfocused.

## 12. Settings (all saved)
- [x] **Graphics.** Window mode, resolution, VSync, FPS cap, bloom, vignette, shadows, particles, ambient effects, foliage and the FPS counter.
- [x] **Audio.** Every volume slider.
- [x] **Gameplay.** Shake, hitstop, look-ahead, text speed, cutscenes (always, first time, or off), tips, House barks, run timer and hints.
- [x] **Accessibility.** Assist speed, invincibility, flash reduction, hurt vignette and slow-mo effects.
- [x] **Controls.** Full keyboard rebinding, reset to defaults and gamepad support.

## 13. UI and UX
- [x] Every menu works with keyboard or gamepad, with clear button hints.
- [x] The pause menu has resume, settings, restart, quit and a charm list.
- [x] Receipt-style Collection Notice when you bust.
- [x] **XP bar and level badge.** In the Lobby, on the title screen, in The Fence, and as a slim bar along the bottom during runs.
- [x] Toasts for trophies, charms and loans.

## 14. Save and persistence
- [x] Autosaves on every important event: settings, stats, trophies, flags, tickets, charms, licenses and Daily results.
- [x] XP, level and skill points are saved.

## 15. Replayability
- [x] Procedural floors from a run seed, with seeded Daily Deals.
- [x] Random charm offers, House Rules, side bets and vaults.
- [x] Random slot odds on every cabinet, every run.
- [x] Character unlocks, the true ending, High Roller loop floors and Heat.

## 16. Technical and quality
- [x] **Headless smoke test.** (`tests/smoke.gd`)
- [x] **Systems test.** 70+ checks. (`tests/systems.gd`)
- [x] **Casino and odds tests.** Hand evaluators, baccarat rules, RTP ranges, and XP and skill-point math. (`tests/casino_test.gd`)
- [x] **Screenshot capture test.** (`tests/capture.gd`)
- [x] Original files backed up in `backup_before_claude/`.
