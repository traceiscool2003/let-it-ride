# LET IT RIDE — Game Design Document

**Engine:** Godot 4.7 (latest stable), GDScript only
**Genre:** 2D roguelite precision platformer with parkour movement and push-your-luck gambling
**Run length:** 25–35 minutes for a full clear; levels take 2–3 minutes; restarting after a death takes under 3 seconds
**This file is the source of truth.** If something here doesn't work in practice, flag it and propose a fix. Don't silently change it.

---

## 0. The Pitch

You're Kit Calloway, a cocky free-runner whose grandfather lost Kit's soul in a card game twenty years ago. Now the debt has come due. Kit wakes up in **The Pit**, an underground casino that's alive and talks like a game-show host. Kit has to fight down through it floor by floor.

Every chip you grab goes into your **Pot**. At every exit door you have to choose:

- **CASH OUT:** bank the Pot safely.
- **LET IT RIDE:** keep it at risk, double the multiplier, and face a nastier next level.

Stylish movement, meaning parkour moves chained without stopping, builds **Flow**, and Flow multiplies every chip you pick up. When you die, the House revives you in the Lobby because a debtor isn't allowed to die. Every death moves the story forward.

### Design pillars
1. **Movement is the joy.** It should be fun to run around an empty room.
2. **Every run is a series of bets.** Skill makes greed pay off, and greed demands more skill.
3. **Death is progress.** Every death unlocks something: a line of dialogue, an unlock, a clue, or a new strategy.
4. **The luck can be bent.** Randomness creates the drama, and the player's tools let them rig it.
5. **One more run.** Restarts are fast, runs are short, and there's always a reason to go again.

---

## 1. Research Basis: Why These Choices

Each design decision below comes from what made the most-played and best-loved games work. Sources are listed at the end.

| Finding | Where it comes from | How LET IT RIDE uses it |
|---|---|---|
| Players enjoy games, and keep playing them, when they feel **competence, autonomy, and relatedness** | Ryan, Rigby & Przybylski 2006 (self-determination theory study of games) | Competence: tight controls and fair deaths. Autonomy: route, bet, and build choices every minute. Relatedness: hub characters who remember you, plus daily-seed rivalry |
| **Fun is learning.** Players get bored once nothing new is left to master | Raph Koster, *A Theory of Fun* | New mechanics unlock gradually. Each floor adds one new rule. Synergies and secrets keep revealing new patterns |
| **Flow** happens when the challenge matches the player's skill. Too hard causes anxiety, too easy causes boredom. Letting the player pick their own difficulty helps | Jenova Chen, *Flow in Games* (2007) | **Let It Ride is player-chosen difficulty.** Strong players ride for bigger rewards and struggling players cash out. Stakes add opt-in difficulty later |
| Small hidden forgiveness tricks make hard platformers feel fair: **coyote time, jump buffering, half gravity at the jump apex, corner correction** | Maddy Thorson's *Celeste & Forgiveness* | All of these are in the movement spec (Section 3) |
| **Juice** (screen shake, hit-stop, particles, sound) can make the same mechanics feel like a different game | Vlambeer's "Art of Screenshake"; "Juice It or Lose It" | Feedback on every action, including a big celebration when you cash out (Section 10) |
| Procedural levels work best as **half generated, half designed**: hand-made room templates on a random grid with a guaranteed path, and simple consistent rules that interact | Derek Yu, *Spelunky* | A Spelunky-style 4x4 room grid and systemic hazards (Section 7). Daily seed runs, which Spelunky helped pioneer |
| **Death that moves the story forward** removes the sting of restarting. NPCs react to *how* you died | Greg Kasavin / Supergiant, *Hades* | The Lobby hub and a condition-based dialogue system with priorities (Section 8) |
| **Randomness you can control** plus synergies that multiply and "break" the game | *Balatro*; *CloverPit* | The Charm synergy engine with a multiplicative modifier pipeline, and slot machines built to be rigged (Sections 5–6) |
| A casino theme sells. A slot-machine roguelike sold a million copies, with streamers driving it, and its make-or-break failure moments made great live drama | *CloverPit* (2025) | The Cash Out / Let It Ride moment is staged as a streamable climax |
| **Opt-in difficulty modifiers** after the first win stretch replayability enormously | *Hades*' Pact of Punishment / Heat | "Stakes" (Section 9) |
| **Optional speed rewards** reward mastery without punishing slower players | *Dead Cells* timed doors | Vault Doors that open only if you reach them under par time (Section 6) |
| Short runs, quick power, humor, and big absurd moments drove the 2025 breakouts | *Vampire Survivors*, *Megabonk* | 25–35 minute runs, absurd synergies, a comedic narrator |
| A **layered mystery revealed across runs** keeps story players hooked long after the credits | *Blue Prince* | Losing Tickets lore collectibles and secrets (Section 8) |
| Meta-progression should mostly add **variety ("horizontal")**, not raw power, so skill stays the real progression | General roguelite design consensus | Unlocks mostly add options. Permanent stat boosts are small and capped (Section 9) |

---

## 2. The Loops (with time targets)

| Loop | Length | What happens | What feels good |
|---|---|---|---|
| **Second-to-second** | 1–5 s | Run, jump, wall-run, slide, stomp, grab chips | Movement feel, Flow building, chip sounds rising in pitch |
| **Level** | 2–3 min | Cross a procedural level, take on slots and side bets, reach the exit | **The exit decision: Cash Out or Let It Ride** |
| **Floor** | 8–10 min | 3 levels, then the Dealer shop, then a boss | Build coming together, boss win |
| **Run** | 25–35 min | 4 floors plus the final boss, or death | Power fantasy, big numbers, the story climax |
| **Meta** | Days/weeks | Lobby conversations, unlocks, character arcs, Stakes, daily runs | Relationships, mysteries, mastery |

**Hard rule:** death → Collection Notice → Lobby → new run must be under 3 seconds if the player mashes the button. Story scenes in the Lobby are optional, so players walk up to characters if they want to talk.

---

## 3. Movement & Feel (TOP PRIORITY)

The game uses a 16 px tile size at a base resolution of 480x270, integer-scaled for pixel-perfect output. All values live in an exported `MovementConfig` Resource. The values below are starting points to tune in Phase 1.

| Move | Spec (starting values) |
|---|---|
| Run | ~10 tiles/s, accelerates in ~0.08 s, decelerates in ~0.06 s. Momentum carries up to a 14 tiles/s cap from slides, wall-jumps, and dashes |
| Jump | Variable height: ~3.5 tiles when held, ~1.5 tiles when tapped |
| Coyote time | 0.1 s after leaving a ledge |
| Jump buffer | 0.1 s before landing |
| Apex hang | Half gravity while jump is held and vertical speed is near 0 |
| Corner correction | Bumping your head on a corner within 4 px nudges you around it. The same applies to ledge-top corners during dashes |
| Wall slide | Slower fall while holding toward a wall |
| Wall jump | Kicks away from the wall. Also buffered and coyote-timed (about 3 px of wall tolerance) |
| Wall run | Hitting a wall at ≥ 9 tiles/s lets you run up it for ~0.5 s. Jumping off it gives a boosted wall jump |
| Ledge grab | Auto-grab near ledge corners. Climbing up is quick and can be cancelled into a jump |
| Slide | Hold down while running. Low hitbox, keeps speed, fits under 1-tile gaps, kicks enemies. Jumping out of a slide gives a "slide hop" with bonus horizontal speed |
| Vault | Running at speed into waist-high obstacles hops over them automatically with no speed loss |
| Air dash | 1 per airtime, 8 directions, reset on landing or wall contact. Brief freeze plus trail |
| Stomp | Landing on an enemy stomps it and bounces you (holding jump gives a bigger bounce) |
| Pick up / Throw | Spelunky-style. Pick up dice, bottles, chip bags, and stunned guards, then throw them |
| Chip flick | Throw a single chip as a light projectile. **Chips are both your money and your ammo.** Every throw costs 1 chip from the Pot |

**Feel checklist for Phase 1:** a test room with gaps, walls, 1-tile crawlspaces, vault blocks, ledges, and a long run-up. It's done when moving around feels good with no goals at all.

---

## 4. Chips, Pot, Flow & the Exit Decision

### Currencies
- **Pot:** chips picked up since your last Cash Out. They're at risk: you lose the whole Pot on death.
- **Stack:** banked chips for this run. Safe for the rest of the run, and spent at the Dealer, slots, and side bets.
- **Tokens:** permanent meta currency. At the end of any run, win or lose, the Stack converts to Tokens at 10:1. Tokens are spent in the Lobby.

### Flow (x1 → x5)
- Chaining distinct moves without standing still or touching the ground for more than ~0.4 s raises Flow. Repeating the same move gives reduced gain, which pushes players toward variety.
- Flow decays when you stop and drops to x1 when you take a hit.
- Flow multiplies the value of chips you pick up.
- Feedback: a HUD meter, a player afterimage trail at x3+, chip pickup pitch rising with Flow, and music layers coming in.

### Getting hit while carrying a Pot
You lose 1 heart **and spill 20% of your Pot** as bouncing chips (like rings in Sonic). You can grab them back within ~3 s. It's readable, it doesn't feel unfair, and it rewards recovering fast.

### The exit door, the signature moment
When you touch the exit, time slows and the camera zooms in. Two neon buttons appear:

- **CASH OUT:** Pot × Ride multiplier goes into your Stack, and the multiplier resets to x1. You get a satisfying chip-counting animation and slot-machine payout sounds.
- **LET IT RIDE:** the Pot stays at risk and the multiplier steps up (x1 → x2 → x4 → x8 → x16, capped). The next level gets a random **House Rule**, better loot, and rarer slot machines. A drumroll and the House's laughter play over it.

Also show: Pot size, current multiplier, what the next multiplier would be, and a preview of the House Rule you'd draw (shown face-down as a card. A charm can reveal it).

### House Rules (applied when riding; one per ride, stacking up to 3)
| Rule | Effect |
|---|---|
| Hot Floor | Floor tiles heat up 1.5 s after you stand on them. The floor is lava, so you have to keep moving |
| Lights Out | Only a radius around Kit is visible |
| Greased Floors | Low friction |
| Security Sweep | A laser grid slowly scans across the level |
| Rush Hour | Double enemies |
| Short Fuse | The exit locks after 90 s, and a timer shows on the HUD |
| Double Vision | 25% of chips are fakes that explode when touched (they have a subtle tell) |
| High Limit | All chips are worth double, and all enemies deal double damage |

---

## 5. Builds: Charms & the Synergy Engine

Charms are run-long modifiers, the equivalent of Balatro's Jokers. You get **5 slots** (upgradable to 7). They come from slot machines, the Dealer, Vault Doors, and bosses.

### Synergy engine (build this first, before writing any charms)
Every gameplay event goes through an **EventBus** (`chip_collected`, `stomp`, `wall_run_tile`, `slide_kick`, `damage_taken`, `level_exit`, `cash_out`, `let_it_ride`, `slot_spin`, `bet_won`, and so on). Every number goes through a **modifier pipeline**: base value → additive mods → multiplicative mods → final value, with charms applied in slot order. Slot order matters, and players can rearrange charms. This is what lets synergies multiply into absurd, streamable numbers.

Each charm is a Resource with: `id`, `name`, `description`, `rarity` (Common/Uncommon/Rare/Jackpot), `tags`, `price`, and an effect script that subscribes to events and/or registers modifiers.

**Tags:** FLOW, AIR, WALL, GREED, LUCK, RISK, DEBT, COMBAT. Charms that share tags should combo with each other.

### Starter charm set (25)
| Charm | Tags | Effect |
|---|---|---|
| Chalk Bag | WALL | Wall runs last 50% longer |
| Wall Street | WALL, GREED | Each tile of wall run drops 1 chip |
| Second Wind | FLOW | Flow decays half as fast |
| Hot Streak | RISK, FLOW | +1 max Flow tier for each consecutive Let It Ride this run |
| Double Down | AIR, GREED | Chips grabbed while airborne get the Flow multiplier applied twice |
| Greased Lightning | FLOW | Slides lose no speed; slide hops get +25% speed |
| Slide Rule | COMBAT, GREED | Slide-kicked enemies drop 5 chips |
| Loaded Dice | LUCK | Your first slot spin each level is free |
| Lucky Seven | LUCK, GREED | Every 7th chip you pick up is worth 7 |
| Rabbit's Foot | LUCK, RISK | Once per floor, a lethal hit dumps your whole Pot instead of killing you |
| High Roller | GREED, RISK | +50% chip value, −1 max heart |
| Card Counter | LUCK | Shows side-bet odds and slot symbol weights, and reveals the next House Rule |
| Comp'd | GREED | Dealer prices −25% |
| Pickpocket | COMBAT, GREED | Stomping a guard steals 10 chips |
| House Money | RISK, GREED | While riding at x4 or higher, chip value +100% |
| Snake Eyes | LUCK, COMBAT | Stomps have a 1-in-6 chance to drop a Die (a random 15-second buff) |
| Bankroll | GREED | Cash Out pays +20% |
| Ricochet | COMBAT | Flicked chips bounce once, and half of them come back to you |
| Featherweight | AIR | +1 air dash |
| Hang Time | AIR | Apex hang lasts twice as long |
| Interest Free | DEBT | Your first loan from Mags each run has no interest |
| Bad Credit | DEBT, GREED | +50% chip value while you owe Mags |
| All In | RISK | Ride multiplier steps are x3 instead of x2, but you have −1 heart while riding |
| Insurance | RISK | On death, 25% of your Pot converts to Tokens |
| Jackpot Magnet | GREED | Pulls in chips from 3 tiles away |

**Consumables** (one slot, used with a button): Energy Drink (refill dashes and +20% speed for 10 s), Smoke Bomb (guards lose track of you), Lucky Coin (reroll one slot result), Bribe (silence an alarm), Chalk (+1 s of wall run).

**Hustles** (starting loadouts, unlocked over time, like Balatro's decks): *The Runner* (default), *The Acrobat* (double jump, no air dash), *The Whale* (starts with 300 Stack and 2 hearts), *The Grifter* (starts owing Mags, with Bad Credit equipped), *The Purist* (no charms, but Flow caps at x8 instead of x5).

---

## 6. Gambling Systems

All gambling uses in-game chips. Nothing is ever bought with real money. As CloverPit's developers put it, the slot machine is there to be broken and beaten.

1. **Slot Machines** (placed in levels, with more of them in Slot Rooms). Pay chips, pull the lever, and watch 3 reels spin and stop one at a time with near-miss suspense. The symbols are Cherry, Bell, Bar, 7, Skull, and Clover:
   - 3 matching symbols give a charm or consumable whose rarity depends on the symbol
   - 3 Sevens is a **JACKPOT**: a chip fountain plus a Rare/Jackpot charm
   - Skulls give a curse (−1 max heart this floor, slower Flow build, or a guard ambush)
   - Charms and consumables can change the symbol weights. Weights are always visible with Card Counter
   - Hitting a machine (stomping it or throwing something at it) tilts it: there's a 50% chance it pays out and a 50% chance it sounds the alarm
2. **Side Bets.** Before each level, 2–3 bet cards are offered. You pay to place one, and it pays out if you complete it. Examples: "Finish under 60 s", "Take no damage", "Stay airborne 8 s straight", "Reach x5 Flow", "Never touch the floor in the first room". Side Bets unlock after run 3.
3. **Vault Doors** (adapted from Dead Cells' timed doors). A sealed door appears on certain levels, with a par time shown over it. Reach it under par and it opens, holding a Rare charm plus a chip pile. This exists to reward parkour mastery.
4. **The Dealer (Vera Vex).** Her shop appears between floors. It sells charms, consumables, and curse removal, and lets you reroll stock. She also offers **High-Low**: draw a card and bet whether the next one is higher or lower, up to 3 times in a row, to win an item.
5. **Markers (Mags the Loan Shark).** When you're broke, Mags lends chips. You have to repay with 50% interest within 2 floors. If you don't, Mags herself, an unkillable shark in a pinstripe suit, swims through the walls and chases you every level until you pay. She eats enemies in her path, so a skilled player can use her.

---

## 7. Levels, Floors, Enemies, Bosses

### Generation (Spelunky method)
- Each level is a **4x4 grid of rooms**, and each room is 10x8 tiles. A guaranteed critical path runs from the top entrance to the bottom exit, assigning room types: left-right, drop-from-above, landing, and side.
- Rooms are built from **hand-authored templates** stored as text files, plus randomized 3x3/5x3 "chunks" for variety.
- Special rooms: Slot Room, Side Bet Kiosk, Vault Door, Secret rooms, and Lore rooms (which hold Losing Tickets).
- **Seeded RNG with separate streams** for layout, loot, and slot outcomes, so a seed always reproduces the same run and the Daily Deal is identical for everyone.
- Use TileMapLayer.

### Floors (each adds one new rule, so there's always something to learn)
| Floor | Theme | New rule it teaches | Boss |
|---|---|---|---|
| 1. The Slot Hall | Neon slot rows, red carpet | Card-shooter traps, slot machines | **The One-Armed Bandit**: a slot-machine robot. Stomp its lever, and its reels decide its next attack. A tutorial in reading and rigging reels |
| 2. The Back Rooms | Poker dens, smoke, counting-room conveyor belts | Laser tripwires → alarm → guard waves (light stealth) | **Knuckles Varga, the Pit Boss**: a recurring rival who charges, ground-pounds, and talks trash. The arena is full of poker tables to vault |
| 3. The Vault | Giant safes, gears, gold piles | Rotating platforms, crushing vault doors | **The Vault Keeper**: a giant safe. Hit its dials in the right order. The combination is hidden in clues across Floor 3's levels, so players who paid attention get rewarded |
| 4. The Felt | Surreal: giant cards as platforms, roulette floors, tumbling dice | Rooms reshuffle mid-level (cards flip over) | **The House** (final), below |

**The House (final boss), three phases:**
1. **Reels:** a giant slot face whose spinning reels decide its attacks.
2. **Roulette:** the arena is a spinning roulette wheel. Dodge the ball and hit the numbered pockets.
3. **Double or Nothing:** the House stops the fight and offers a deal. **Walk away now with your Pot** (the joke "Cash Out" ending: Kit leaves rich, Lou stays trapped, and the credits are short and smug), or **let it ride** into a final escape gauntlet.

### Enemies (one clear rule each, in Spelunky style)
- **Guard:** patrols and chases when it sees you. Stompable.
- **Card Sharp:** throws arcing cards. Stays at range.
- **Bouncer:** blocks hallways and can't be stomped. You slide under it or vault over it, so it's a parkour check.
- **Waiter:** drops bottles from above, and the bottles can be thrown.
- **Security Drone:** follows a laser sightline. If it sees you, the alarm goes off.
- **Roulette Ball:** a rolling hazard that bounces off walls.

### Hazards
Spikes, pits, card-shooter wall traps, laser tripwires, falling chandeliers, crushers, conveyors, steam vents, collapsing card platforms.

### Systemic interactions (rules that combine into stories)
- Chandeliers and crushers kill enemies too.
- Spilled chips distract Guards, who stop to pick them up.
- Thrown objects set off traps and tripwires.
- Alarms bring guards, and guards can be lured into lasers.
- Mags eats anything between her and you.
- A tilted slot machine's payout can bury a pit under chips (a temporary floor).

---

## 8. Story

### Premise
Twenty years ago, legendary gambler **"Lucky" Lou Calloway** put his grandchild's name on a Marker in his last game against the House, and lost. On **Kit Calloway's** 21st birthday the Marker comes due. Kit is pulled into **The Pit**, a sentient underground casino that feeds on bets.

The House sets the rules: reach the High Table at the bottom and beat the House at its own game, and you walk free. Until then, the House won't let a debtor die. Every death gets Kit revived in the Lobby, with interest added to the debt. **That's the in-world reason for the roguelike loop.**

### Theme
**Knowing when to walk away, and when to bet everything on the people you love.** Lou never cashed out in his life. Kit has to learn the difference between greed and courage. The core mechanic and the theme are the same choice.

### Cast
| Character | Role | Personality | Personal arc (unlocked through relationship + runs) |
|---|---|---|---|
| **Kit Calloway** | Player | Cocky, quick-witted, secretly scared | Goes from resenting Lou to understanding him, and learns when to fold |
| **The House** | Antagonist and narrator | A smooth game-show host. Charming, petty, a sore loser. Speaks through slot machines and the PA system | Revealed to be **Eddie Duval**, Lou's old partner, a man who never walked away from a table and *became the casino* |
| **"Lucky" Lou Calloway** | Lobby lounge pianist, still working off his own debt | Charming, guilt-ridden, full of tall tales | Confesses he dared Eddie into the bet that turned him into the House. Wants Kit to stop him from ever doing it again |
| **Vera Vex** | The Dealer (shopkeeper) | Dry, sharp, sells everything including advice | Her deck is missing the Queen of Spades, which is her own soul-marker. Kit can find it across runs to free her |
| **Mags Moray** | Loan Shark (literally a shark in a pinstripe suit) | Comedic menace with a soft heart | Secretly hates the House's interest rates and becomes an ally in the final hand |
| **Knuckles Varga** | Pit Boss, recurring boss and rival | Big, loud, grudging respect | Goes from boss to frenemy to sparring partner. Asks Kit to get him out too |
| **Lucky** | The Lobby's black cat | Cat | You can pet Lucky. Once per run, petting gives a tiny luck buff. Players love this |

### How the story is delivered
1. **Lobby conversations after every run.** Each NPC has a pool of lines. The **DialogueManager** chooses, per NPC, the **highest-priority eligible unseen line**. If none qualifies, it picks random filler.
   - Each line has: `id`, `speaker`, `text`, `priority` (0–100), `requirements` (conditions on persistent stats and flags), `once` or `repeatable` with a cooldown, and `sets_flags`.
   - Conditions should be **specific**, which is the main lesson from Hades. "Died to the Vault Keeper while riding at x8" gives a much better line than "died".
   - Tracked stats include: runs, deaths, `deaths_by_cause[...]`, wins, floors reached, cash-outs vs rides this run and all-time, highest ride streak, biggest Pot lost, jackpots, loans taken and defaulted, charms seen, gifts given, bosses beaten, and the Hustle used.
   - Players can review lines they've seen in a **Recent Remarks** log.
2. **House PA barks during runs**, triggered by events with a 45 s cooldown. Examples: first jackpot, riding at x8, a near-death, getting stomped by the same guard twice, dying to a chandelier.
3. **The Collection Notice (death screen):** a funny in-game receipt from the House listing cause of death, chips lost, "interest" added, a stat highlight, and the seed. It's fun to screenshot and share.
4. **Gifts and relationships:** **Comp Tickets** are rare finds in runs. Give one to an NPC to raise your relationship. At each threshold you unlock a story scene and a **Keepsake** (equip one per run for a small perk).
5. **Losing Tickets**, a lore collectible: torn betting slips left by past runners and hidden in levels (inspired by Blue Prince). Collecting them across many runs pieces together the House's origin and Eddie Duval's story.
6. **Milestone beats:** first reaching each floor, the first boss kill, the first loan, the first Let It Ride at x8, a run-5 check-in, the first win, and so on.

### Story structure
- **Run 1:** intro. Kit gets dragged in, the House explains the rules, Lou is introduced, and a short tutorial plays in the Service Tunnel. Expect to die.
- **Runs 2–~15:** relationships grow, mysteries deepen, and mechanics unlock gradually (Side Bets, Markers, Hustles).
- **First win:** Kit beats the House, and the House laughs. "House rules, kid. The debt's paid when the House goes broke." Short credits roll, Stakes unlock, and the story keeps going, as it does after Hades' first escape.
- **Clears 2–N:** free the NPCs one by one by finishing their personal arcs (relationship level + a specific item carried through a run + a clear).
- **True ending, "The Final Hand":** requires Lou's arc to be complete and all four Markers (Lou, Vera, Mags, Knuckles) collected. Kit stakes every Marker on one final hand: the ultimate Let It Ride. The House goes broke, Kit offers Eddie the chance to finally cash out, and the epilogue turns the Pit into **The Free House**, a club its former debtors run themselves. After that, Stakes and daily runs carry on, with a grumpy, reformed House as narrator.
- **Joke ending:** Cash Out during the final boss's Phase 3.

### Secrets (for Spelunky-style community discovery)
A hidden chain unlocks a secret area, **The Comp Suite**, with a secret boss. To reach it: carry the Golden Die (found on Floor 1) to Floor 3 without ever cashing out, then roll it at the Vault Keeper. Add more chains later.

### Tone guide
Neon noir comedy, PG-13, witty and warm underneath. The House is smug but charming. The game **never** makes the player feel stupid for dying; the jokes are aimed at the situation, the House, or Kit's ego. The emotional core is Kit and Lou.

**Sample lines (they set the voice; write the rest in the same style):**
- **House (PA):** "Attention, valued guests: Kit Calloway has been defeated by a chandelier. The chandelier's drinks are on the house."
- **House (when you ride):** "Let it ride? Oh, I *like* you."
- **House (when you cash out):** "Playing it safe. How... responsible. Ugh."
- **Lou:** "Kid, I know what you're thinking. And yeah — I would've let it ride too. That's the problem."
- **Vera:** "Everything's for sale, sugar. Advice included. Advice especially."
- **Mags:** "Interest isn't personal, Calloway. It's just math with teeth."
- **Knuckles:** "You again? I'm starting to think you like getting thrown out."

**Writing volume targets:** about 150 lines for the vertical slice, 800+ for 1.0. Prioritize *reactive* lines tied to specific run events over generic chit-chat.

---

## 9. Meta-Progression & Difficulty

- **Lobby upgrades (Tokens):** mostly horizontal. Add charms to the drop pool, unlock Hustles, add slot machine types and Lobby cosmetics, and unlock Lou's piano songs (a music player). There's a small, **capped** vertical track: up to +1 heart, +1 charm slot, and a 50-chip starting Stack.
- **Gradual unlocks double as the tutorial** (as in Slay the Spire): Side Bets after run 3, Markers once you meet Mags, Hustles after the first Floor 2 boss, Stakes after the first win.
- **Stakes (opt-in difficulty after the first win, like Hades' Heat):** stackable "Table Limits" such as *No Comps* (higher shop prices), *Tight Security* (more guards), *Short Stack* (−1 heart), *House Edge* (worse slot odds), *Hot Start* (begin at x2 with a House Rule), and *Loan Sharked* (Mags' deadline is 1 floor). Each adds Heat. Clearing at higher Heat unlocks rewards, new lines, and cosmetics.
- **Daily Deal:** a daily seeded run. You get one attempt for the score; after that, practice runs are allowed. Keep a local leaderboard and make seeds easy to share. An online leaderboard can come later.
- **Assist Mode (inspired by Celeste):** game speed slider, extra hearts, invincibility, and infinite dashes. It never blocks story progress. It only marks the save as "assisted" for leaderboards.

---

## 10. Presentation

- **Art:** placeholder shapes or generated pixel sprites so the game runs with **zero external assets**. Keep sprites swappable. Palette: deep purples, gold, casino red, black, and neon cyan for interactables. **Readability first:** hazards are red/orange, chips are gold, interactables are cyan, and enemies have clear silhouettes.
- **Juice:** trauma-based screen shake, hit-stop on stomps and kicks, squash and stretch, landing dust, wall-jump sparks, a chip fountain on jackpots, number pop-ups, the afterimage trail, a camera that looks ahead in your direction of travel, and a slow-motion zoom on the exit decision.
- **Audio:** procedural or placeholder SFX through clean hooks (an `AudioManager` with named events). Pitch rises with Flow. Music is dynamic, with layers added as Flow and the Ride multiplier climb. A drumroll plays for Let It Ride and a cash register for Cash Out.
- **HUD:** hearts, Pot, multiplier, Flow meter, Stack, charm slots, active House Rules, and a timer when it matters. It should stay minimal and readable on a stream.
- **Input:** keyboard and controller through the Input Map, with rebindable controls.

---

## 11. Technical Architecture (Godot 4.7)

```
res://
  autoload/      GameState, SaveManager, EventBus, RNGService, DialogueManager, AudioManager, Settings
  config/        MovementConfig.tres, EconomyConfig.tres, OddsConfig.tres
  data/charms/   *.tres (one per charm) + effect scripts
  data/dialogue/ *.json (one file per speaker)
  data/rooms/    room templates (*.txt), chunks
  data/rules/    House Rules, Stakes, Side Bets
  scenes/        player/, enemies/, hazards/, levels/, ui/, lobby/, bosses/
  scripts/       shared helpers
  tests/         headless test scenes for generation and economy math
```

- **EventBus + modifier pipeline:** see Section 5. This is the backbone, so build it before content.
- **RNGService:** a seeded master RNG with named sub-streams (`layout`, `loot`, `slots`, `ai`).
- **SaveManager:** JSON in `user://`. Stores persistent stats, flags, unlocks, relationships, seen dialogue, settings, and best scores. Save at safe points and after each run.
- **Debug tools:** F1 overlay (FPS, seed, Flow, Pot, multiplier, player state). F2 menu (grant chips/charms, skip level, invincibility, force House Rule, jump to floor, trigger a dialogue line).
- **Run log:** append one CSV row per run locally (seed, Hustle, floor reached, cause of death, rides, cash-outs, biggest Pot, duration) for balance tuning.

---

## 12. Build Phases & Fun Checks

Build **vertically**: get the core loop fun with grey boxes before adding content. After each phase: run headless checks, commit, summarize, give a testing checklist, and **stop for playtesting**.

| Phase | Build | Fun check before moving on |
|---|---|---|
| 1 | Movement kit, camera, juice basics, test room, debug overlay | Running around an empty room is fun |
| 2 | Level generation, chips, Flow, Pot, exit decision (Cash Out / Let It Ride), House Rules ×3, HUD | The exit choice feels tense and you *want* to ride |
| 3 | Hazards, 3 enemies, hearts, chip spill, death → Collection Notice → restart in under 3 s | Deaths feel fair and you instantly want another go |
| 4 | EventBus modifier pipeline, charms (all 25), slot machines, consumables, Dealer shop | Builds feel different and at least one combo makes you laugh |
| 5 | Lobby hub, DialogueManager, House PA barks, 4 NPCs, intro sequence, ~150 lines, save system | You look forward to seeing who says what after dying |
| 6 | Floors 1–2 fully, bosses 1–2, Side Bets, Vault Doors, Markers + Mags | A full Floor 1–2 run feels like a game |
| 7 | Floors 3–4, Vault Keeper, The House (3 phases), first ending, Stakes, Daily Deal, Hustles, Lobby upgrades, menus, settings, Assist Mode | Full run start to finish |
| 8 | Polish pass: audio, juice, balance (using the run log), more charms and dialogue, secrets, true ending | Playtesters ask for "one more run" without being asked |

---

## 13. Guardrails

- **No real money, ever.** No microtransactions and no way to buy chips. The gambling is theme and mechanics only.
- **Scope control:** don't add a new system unless an existing phase's fun check fails without it. Content (charms, rooms, lines) scales up; systems don't.
- **Fair randomness:** every death has to be readable. Hazards telegraph for at least 0.4 s, nothing spawns on top of the player, and the death screen names the killer.

---

## Sources

- Ryan, Rigby & Przybylski (2006), *The Motivational Pull of Video Games: A Self-Determination Theory Approach*: https://www.rochester.edu/warner/lida/wp-content/uploads/2022/11/02bfe513dd59366750000000.pdf
- Jenova Chen (2007), *Flow in Games (and Everything Else)*, Communications of the ACM: https://khoury.northeastern.edu/~lieber/courses/csu670/f08/materials/p31-chen-flow-in-games.pdf
- Raph Koster, *A Theory of Fun for Game Design* (summary): https://www.shortform.com/blog/what-is-the-meaning-of-fun/
- Maddy Thorson, *Celeste & Forgiveness*: https://maddymakesgames.com/articles/celeste_and_forgiveness/
- Vlambeer, "The Art of Screenshake" (overview): https://gamedo-live.pages.dev/news/game-feel-juice-guide-indie-devs
- Spelunky level generation (GMTK breakdown of Derek Yu's book): https://amara.org/videos/p6MHlmreohsY/en-gb/3101319
- Spelunky and the Daily Run: https://newsletter.gamediscover.co/p/how-spelunky-got-its-procedural-hook
- Hades death-as-narrative (Greg Kasavin): https://www.vice.com/en/article/how-hades-made-a-genre-known-for-being-impossibly-hard-accessible
- Hades dialogue priority system: https://filmstories.co.uk/?p=83138
- Hades Pact of Punishment: https://hades.wiki.fextralife.com/New+Game+Plus
- Balatro randomness and control: https://mechanicsofmagic.com/2025/05/23/critical-play-addiction-by-design
- CloverPit sales and streamer success: https://www.pcgamer.com/games/roguelike/slot-machine-roguelike-cloverpit-sells-1-million-copies-and-its-developer-celebrates-the-payout-by-adding-its-most-requested-feature-yet
- CloverPit "not gambling" stance: https://www.pcgamesn.com/cloverpit/out-now
- Dead Cells timed doors: https://earlyguides.pages.dev/dead-cells/tips
- Megabonk breakout (2025): https://www.pcgamesn.com/megabonk/steam-player-count-hades-2
- Blue Prince layered mystery: https://www.slantmagazine.com/games/blue-prince-review/
- Roguelike market 2026: https://tech4gamers.com/roguelikes-steam-500m-2026/
