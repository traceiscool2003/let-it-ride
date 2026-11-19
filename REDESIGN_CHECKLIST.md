# LET IT RIDE: Redesign Checklist

This is the user's full redesign request (from 2026-11-18), split into items. It is the **source of truth** for the redesign. Where it conflicts with `GAME_DESIGN.md` or `AAA_CHECKLIST.md`, this file wins.

**How to work it:**
- Go down the list in order, one item at a time.
- When an item is done **and** compile-checked (plus smoke-tested where it applies), change `[ ]` to `[x]` and add a short note on what changed and in which files.
- If an item is only partly done, leave it `[ ]` and add a `PROGRESS:` note so the next session can continue.
- Log every session at the bottom: date, which items it finished, and what is next.

## The user's vision, in one paragraph
A Hollow Knight-style action platformer (movement, combat, animation, map) with Balatro- and Risk of Rain-style stacking buffs.
- **The hero:** a degenerate gambler who loves risk.
- **The climb:** you rise through 5 **cities**, from a grimy alley to the nicest casino in Vegas.
  - Each city has **5 floors**: 4 explore floors, then a boss on floor 5.
  - Each boss is a **table/poker game**.
  - The final boss is **THE HOUSE**, playing Texas Hold'em.
- **The game is mostly exploration:** hidden rooms, breakable walls, secret and side bosses, and vendor rooms.
- **Gambling** is for buffs: slots, and a sketchy vendor's drugs and booze.
- **Everything is clothing:**
  - abilities and buffs are wearables, so good buffs look sharp and bad buffs look ugly
  - every floor up dresses you nicer
  - every city earns a new casino status
- **Money:** real-color poker chips that fall and scatter.

## Locked decisions (already agreed with the user)
- **Names:** every real casino and gambling website gets a *slightly-off* parody name, for trademark safety. The user explicitly chose this.
- **Originality:** design in the *spirit* of Hollow Knight, Silksong, Balatro and Risk of Rain, but with original art, names and characters. Never copy their assets, names or characters.
- **Tech:** Godot 4.7.2 and GDScript only. All art is drawn in code and all audio is synthesized (no asset files), except the optional voice files from item 30.

## Tooling notes (for a fresh session)
- **Project:** `C:\let it ride\let-it-ride` (note the space in the path; quote it).
- **Godot (console build):** `C:\Users\trace\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe`
- **Compile check:**
  ```
  "<godot>" --headless --path "C:/let it ride/let-it-ride" --script res://tests/parse.gd
  ```
  It must print `parse check: 0 failed`.
- **Smoke tests:** `--script res://tests/smoke.gd`, `systems.gd` and `casino_test.gd`. Update the tests as systems change; never delete coverage without replacing it.
- **Screenshots:** run `tests/capture*.gd` without `--headless`. PNGs land in `%APPDATA%\Godot\app_userdata\LET IT RIDE`.
- **GDScript gotchas:**
  - Never use `:=` on Variant expressions (dictionary or array reads); give an explicit type instead.
  - SceneTree test scripts use `paused`, not `get_tree()`.
  - Test scripts must `load()` scripts that use the autoloads, not `preload()`.
  - Don't put multi-line lambdas inside call arguments.
- **No Python on this PC.** Edit files with the Edit and Write tools.
- **Main code:**
  - `scripts/main.gd` (about 3,700 lines): the game loop, states, the lobby and the menus
  - `player.gd`: movement and combat
  - `level.gd`: generation
  - `enemy.gd` and `boss.gd`
  - `hud.gd`
  - `casino.gd`, `charms.gd` (the buff engine) and `story.gd`
  - `music.gd` and `sfx.gd` (both autoloads)
  - `rig.gd`: the procedural IK character rig
  - `config/movement.tres`: every movement number

---

## A. Movement
- [x] **1. Hollow Knight-style movement, as crisp as possible.**
  - DONE: retuned `movement_config.gd` for near-instant acceleration and stopping, a sharp jump cut (0.15), a heavier fall, a stop-dead dash and a new `dash_cooldown`.
  - `player.gd` now has an `abil` dictionary. Wall cling and jump, wall run, slide, vault and ledge grab only work when the matching ability is on.
  - Added a double jump (`_double_jump`), a glide, and a ground or air dash that is horizontal unless `super_dash` is on.
  - WARNING: the current level generator assumes the parkour kit. Make sure floors are completable with the base kit (items 25-28), or guarantee the needed ability.
  - Near-instant acceleration and stopping.
  - A snappy variable jump with a fast fall and a short apex.
  - Keep coyote time, jump buffer and corner correction.
  - Remove or gate the parkour extras (wall run, slide, vault, ledge grab) so the default kit reads like HK.
  - The map is "grounded and slower": walking pace, not a speedrunner game.
- [ ] **2. Abilities are wearable clothing items**
  - PROGRESS: the player side is done (`player.abil` keys `dash`, `double_jump`, `wall`, `wall_run`, `slide`, `vault`, `ledge`, `glide`, `super_dash`; `pound` is not wired yet).
  - Still to do:
    - a clothing item table in main
    - drops and vendor sales
    - setting `player.abil` from worn items on spawn
    - drawing the clothes on the rig
    - the HUD found or bought on runs, for example:
  - Dash: Thrift Sneakers, worn in the starting outfit
  - Double jump: Wingtip Shoes
  - Wall cling and wall jump: Grip Gloves
  - Super dash: a Track Jacket
  - Ground pound: Steel-toe Boots
  - Hover or glide: a Silk Scarf
- [ ] **3. Hollow Knight-style animations:**
  - squash and stretch, anticipation frames, a nail-slash arc
  - recoil on hits, hit-flash, landing dust, a run cycle with lean
  - Use the existing `rig.gd`.

## B. Combat
- [ ] **4. Hollow Knight-style fighting controls:**
  - one attack button for side, up and down (a pogo off enemies and spikes)
  - knockback and recoil on both sides
  - i-frames, and a hold-to-heal focus that uses a meter filled by hitting enemies ("Nerve")
  - The existing parry can stay as an item.
- [ ] **5. Lots of ranged weapons for the player.** At least 8, each with its own feel, for example:
  - chip flick, card throw, dice bomb, bottle toss, snub revolver, roulette-ball cannon, cash-band boomerang, coin shotgun
  - They use ammo or Nerve, are found and bought, and have one equipped slot (more from items).
- [ ] **6. Amazing combat feel:**
  - hitstop, screen shake, enemy stagger, damage numbers
  - satisfying sound effects and particles on every hit

## C. Enemies
- [ ] **7. Every regular enemy is basic and ranged** (simple patterns, readable telegraphs), plus a few melee variants.
- [ ] **8. Distinct enemy types with different movesets** (at least 10 across the cities). Regular enemies get small moveset *variations* per instance (speed, burst count, aim lead).
- [ ] **9. Enemies change from nasty to professional as you climb:**
  - City 1: junkies, rats, alley thugs, a bottle thrower
  - Middle cities: dealers, bouncers, pit bosses
  - Vegas: suited security, snipers, drones

## D. Bosses
- [ ] **10. Each city's floor 5 is a boss, and every boss is a table/poker game.**
  - Bosses 1-4 are randomized each run from a pool of poker-game bosses: Five Card Draw, Seven Card Stud, Omaha, Three Card Poker, Razz, Pai Gow, Blackjack and so on.
  - The **final boss is always THE HOUSE, playing Texas Hold'em.**
- [ ] **11. Bosses are named after slightly-off gambling websites and casinos**, for example DraftQueens, FanDool, PokerStarz, BetMGN, Steak.com and Bovado.
- [ ] **12. Bosses have multiple phases and fixed, learnable movesets.**
  - Each attack has a clear telegraph and a consistent pattern, so players can memorize the fight.
  - Attacks change per phase.
  - The fights must feel super satisfying: a stagger, a big finish, a slow-mo kill.
- [ ] **13. Use your earnings and buffs from the 4 floors in the boss fight.** Spend chips at the table, for example a Buy-in or Raise at phase changes that multiplies your damage, and every buff carries over.
- [ ] **14. Really good boss music:** its own intense track per boss that escalates per phase. It's synthesized in `music.gd`.
- [ ] **15. Secret bosses and side bosses,** hidden behind secret rooms or off the main path.

## E. Buffs, items and gambling
- [ ] **16. Buffs work like Balatro** (rule-bending, combo-scaling jokers) **and stack like Risk of Rain items.** Everything you get is kept for the whole run. The floor-buff picks should feel like Risk of Rain's.
- [ ] **17. 1-2 buffs per floor**, and all buffs from earlier floors are kept.
- [ ] **18. Slots only pay buffs, never money.**
  - A bigger bet means better odds of a good buff.
  - A small bet means better odds of a bad (shitty) buff.
- [ ] **19. Shady upgrades** that help or hurt depending on luck.
- [ ] **20. A sketchy vendor** sells drugs and alcohol as gamble buffs. Each one has a random good or bad effect.
- [ ] **21. Everything is tied to items, shown as clothing:**
  - bad buffs are ugly clothes and good buffs are nice clothes
  - each run looks and plays differently
  - the character visibly wears what they have
- [ ] **22. Each floor you climb dresses you in nicer clothes** (a base outfit tier per floor or city).

## F. World, levels and exploration
- [ ] **23. Levels are cities, and each city has a casino.**
  - They progress from nasty places with crappy casinos up to the nicest Vegas casino.
  - Each casino has a parody name of a real American casino, for example:
    1. Atlantic Shitty: Resortz
    2. Reno: Cirrcus Cirrcus
    3. Biloxi: Hard Rok
    4. Fremont, Las Vegas: Goldun Nugget
    5. The Strip: Bellagiro
- [ ] **24. The run starts in a grimy, nasty alleyway.** Each floor gets nicer, and you eventually make it into the casino.
- [ ] **25. Each city is 5 floors you climb up,** with 4 explore floors and a boss on floor 5.
- [ ] **26. Exploration is most of the game, not casino gameplay.**
  - Bigger, deeper, Hollow Knight-style interconnected maps.
  - The pace is grounded and slower, rewarding players who take their time.
- [ ] **27. Hidden stuff:** breakable walls, secret rooms and hidden items.
- [ ] **28. The map naturally guides you to the boss** through layout, lighting and signage, not a waypoint arrow.
- [ ] **29. Vendor rooms are spread around the map:** a clothing or items vendor, the sketchy vendor and a weapons vendor.
- [ ] **30. Silksong-style map screen on M** that shows only rooms you've visited, plus your position and markers.
- [ ] **31. Each city earns you a new casino status**, like real loyalty tiers (Bronze, Silver, Gold, Platinum, Black Card). The status gives perks and shows on the HUD.

## G. Money
- [ ] **32. Money is poker chips that physically fall and scatter.** Each value has its real-life color:
  - $1 white, $5 red, $25 green, $100 black, $500 purple, $1000 orange/yellow

## H. Story and voice
- [ ] **33. The hero is a degenerate gambler who loves risk.** Rewrite the story and tone for this: funny and self-aware.
- [ ] **34. Voice every character.**
  - Write `VOICE_SCRIPT.md`, which lists every line per character with a line ID.
  - Add a voice system that plays `res://voice/<character>/<line_id>.ogg` when that file exists and falls back to the text blip when it doesn't. The user records or generates the files themself.
  - Document how to add them in the README.

## I. Wrap-up
- [ ] **35. Update** the README, the tests and the screenshots, and make a final full playthrough pass with the bot or capture scripts.

---

## Session log
- **2026-11-18:**
  - Wrote this checklist and set up the auto-resume scheduled task.
  - Later the same night: item 1 done. Parse, smoke, systems and casino_test all pass.
  - Next: item 2 (clothing items that grant `player.abil`).
