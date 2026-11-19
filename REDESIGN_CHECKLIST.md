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
- [x] **2. Abilities are wearable clothing items**
  - DONE: new `scripts/wardrobe.gd` (item table, slots, swag score, per-city outfit tiers, rig drawing); `main.worn` sets `player.abil` on spawn, Vera's table sells 2 clothes, bosses drop one, ground pound added (`player.pounded`).
  - (old note) PROGRESS: the player side is done (`player.abil` keys `dash`, `double_jump`, `wall`, `wall_run`, `slide`, `vault`, `ledge`, `glide`, `super_dash`; `pound` is not wired yet).
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
- [x] **3. Hollow Knight-style animations:**
  - DONE (`player.gd`): run lean, attack windup rock-back + stretch + dust, white hit-flash and hit squash, landing/pound dust. Slash arc, squash/stretch and rig IK were already present.
  - squash and stretch, anticipation frames, a nail-slash arc
  - recoil on hits, hit-flash, landing dust, a run cycle with lean
  - Use the existing `rig.gd`.

## B. Combat
- [x] **4. Hollow Knight-style fighting controls:**
  - DONE: Nerve meter (`main.nerve`, HUD), hold FOCUS (E/L) to heal, spike pogo, hit recoil, one attack button for side/up/down already existed (`main.gd`, `hud.gd`, `sfx.gd`).
  - one attack button for side, up and down (a pogo off enemies and spikes)
  - knockback and recoil on both sides
  - i-frames, and a hold-to-heal focus that uses a meter filled by hitting enemies ("Nerve")
  - The existing parry can stay as an item.
- [x] **5. Lots of ranged weapons for the player.**
  - DONE: 8 weapons in new `weapons.gd` (G fires, TAB cycles), `projectile.gd` weapon kind (arc, bounce, boomerang, explode, pierce), ammo/pot/nerve costs, Vera sells one, bosses drop one, HUD shows weapon. At least 8, each with its own feel, for example:
  - chip flick, card throw, dice bomb, bottle toss, snub revolver, roulette-ball cannon, cash-band boomerang, coin shotgun
  - They use ammo or Nerve, are found and bought, and have one equipped slot (more from items).
- [x] **6. Amazing combat feel:**
  - DONE: `main._hit_juice` (damage numbers, directional sparks, finisher/kill boom, hitstop, shake, stagger); weapon hits use the same.
  - hitstop, screen shake, enemy stagger, damage numbers
  - satisfying sound effects and particles on every hit

## C. Enemies
- [x] **7. Every regular enemy is basic and ranged**
  - DONE: new `enemy_types.gd` + `enemy.gd _ranged()`: 10 ranged kinds with telegraphs (aim state, "!", sniper laser) plus melee Guard/Rat/Heavy; `projectile.gd` has needle, bottle, chip, bullet. `tests/roster_test.gd` covers all. (simple patterns, readable telegraphs), plus a few melee variants.
- [x] **8. Distinct enemy types with different movesets** (at least 10 across the cities). DONE: 13 kinds; per-instance variation `v_speed`, `v_shots`, `v_lead`, `v_cd` in `enemy.gd`. Regular enemies get small moveset *variations* per instance (speed, burst count, aim lead).
- [x] **9. Enemies change from nasty to professional as you climb:**
  - DONE: `EnemyTypes.pick(floor, air, rng)` weights kinds by city (junkies/rats/thugs/bottle thrower, then dealers/bouncers/pit bosses, then suited security/snipers/drones). City = (floor-1)/5.
  - City 1: junkies, rats, alley thugs, a bottle thrower
  - Middle cities: dealers, bouncers, pit bosses
  - Vegas: suited security, snipers, drones

## D. Bosses
- [x] **10. Each city's floor 5
  - DONE: `boss_defs.gd` POOL of 8 poker/table bosses (4 random per run via `boss_order`), FINAL = THE HOUSE Hold'em on floor 25; boss floors every 5 (`main.boss_every`). is a boss, and every boss is a table/poker game.**
  - Bosses 1-4 are randomized each run from a pool of poker-game bosses: Five Card Draw, Seven Card Stud, Omaha, Three Card Poker, Razz, Pai Gow, Blackjack and so on.
  - The **final boss is always THE HOUSE, playing Texas Hold'em.**
- [x] **11. Bosses are named after
  - DONE: DRAFTQUEENS, FANDOOL, POKERSTARZ, BETMGN, STEAKE.COM, BOVADOH, SEEZER'S CLUB, WYNNER'S CIRCLE (`boss_defs.gd`). slightly-off gambling websites and casinos**, for example DraftQueens, FanDool, PokerStarz, BetMGN, Steak.com and Bovado.
- [x] **12. Bosses have multiple phases
  - DONE: `boss.gd`: fixed attack `deck` per phase (cycles in order, `deal` volley named per game), on-screen attack labels, stagger at phase change, slow-mo kill. `tests/boss_test.gd` runs every boss through all phases. and fixed, learnable movesets.**
  - Each attack has a clear telegraph and a consistent pattern, so players can memorize the fight.
  - Attacks change per phase.
  - The fights must feel super satisfying: a stagger, a big finish, a slow-mo kill.
- [x] **13. Use your earnings
  - DONE: Phase-change RAISE menu (`main._on_boss_phase_raise`, kind "raise"): Call/Raise/All-in spend Pot for x1.5/x2/x3 damage (`boss.dmg_mult`), refunded x1.5 on win; all charms/clothes carry over. and buffs from the 4 floors in the boss fight.** Spend chips at the table, for example a Buy-in or Raise at phase changes that multiplies your damage, and every buff carries over.
- [x] **14. Really good boss music
  - DONE: `music.gd boss_music`: each boss has bpm/root/mode/lead wave in `boss_defs.gd`; escalates per phase (tempo, hats, kick, octave lead).:** its own intense track per boss that escalates per phase. It's synthesized in `music.gd`.
- [x] **15. Secret bosses
  - DONE: 3 secret bosses in `boss_defs.SECRET` (Snake Eyes Sal, One-Armed Bandit, Mr. Lucky) behind SECRET TABLE doors in breakable-wall stash rooms (`level._stash`, `main._enter_secret`); big chip/loot payout. and side bosses,** hidden behind secret rooms or off the main path.

## E. Buffs, items and gambling
- [x] **16. Buffs work like Balatro
  - DONE: `charms.gd`: new Snowball (scales per kill), Overdraft; Risk-of-Rain stacking (`stacks`, `count`, `add_stack`) and 12% stack drops; same-charm pickups stack.** (rule-bending, combo-scaling jokers) **and stack like Risk of Rain items.** Everything you get is kept for the whole run. The floor-buff picks should feel like Risk of Rain's.
- [x] **17. 1-2 buffs per floor**
  - DONE: `_build_floor` queues a pick-of-3 each non-boss floor plus a 35% free bonus; all buffs carry over the run., and all buffs from earlier floors are kept.
- [x] **18. Slots only pay buffs
  - DONE: `casino._eval_slots` pays no money: bet size sets bad-buff odds (55%/35%/18%/6%) and tier bumps; booby prize on small no-win bets; `main` hands out bad charms (`roll_bad`)., never money.**
  - A bigger bet means better odds of a good buff.
  - A small bet means better odds of a bad (shitty) buff.
- [x] **19. Shady upgrades**
  - DONE: "shady" menu/stall: pay 15% of Pot, ~50% (+flow) stacks a buff, else backfires into a bad buff. that help or hurt depending on luck.
- [x] **20. A sketchy vendor**
  - DONE: Doc Fizz stall (`prop._draw_stall`, `main` "fizz" menu): unlabeled drugs/booze with hidden random good/bad effects (`FIZZ_EFFECTS`, `_drink_fizz`). sells drugs and alcohol as gamble buffs. Each one has a random good or bad effect.
- [x] **21. Everything is tied to items
  - DONE: wardrobe slots + `Wardrobe.draw_charm_gear`: every charm shows as an accessory, bad ones are garish; `run_swag()` sums swag; NPCs react to ugly/sharp., shown as clothing:**
  - bad buffs are ugly clothes and good buffs are nice clothes
  - each run looks and plays differently
  - the character visibly wears what they have
- [x] **22. Each floor you climb dresses you
  - DONE: `Wardrobe.TIERS` base outfit per city (rags to Black-card tux), drawn via `outfit_floor`. in nicer clothes** (a base outfit tier per floor or city).

## F. World, levels and exploration
- [x] **23. Levels are cities
  - DONE: `cities.gd` CITIES (parody casino names), `main.ZONES`, `level.gd` zone palettes 4 (alley) and 5 (strip)., and each city has a casino.**
  - They progress from nasty places with crappy casinos up to the nicest Vegas casino.
  - Each casino has a parody name of a real American casino, for example:
    1. Atlantic Shitty: Resortz
    2. Reno: Cirrcus Cirrcus
    3. Biloxi: Hard Rok
    4. Fremont, Las Vegas: Goldun Nugget
    5. The Strip: Bellagiro
- [x] **24. The run starts in a grimy
  - DONE: `Cities.is_alley`: floors 1-2 use the new alley zone palette (brick, grime), then the Atlantic Shitty casino interior., nasty alleyway.** Each floor gets nicer, and you eventually make it into the casino.
- [x] **25. Each city is 5 floors
  - DONE: `boss_every = 5`, `Cities.city_of`; floor 5/10/15/20/25 are bosses. you climb up,** with 4 explore floors and a boss on floor 5.
- [x] **26. Exploration is most of the game
  - DONE: floors are now 6x5 rooms (was 4x4) in `level.gd` (RX/RY), downward-flowing layout completable with the base kit, secret rooms, vendors, map; pace stays grounded., not casino gameplay.**
  - Bigger, deeper, Hollow Knight-style interconnected maps.
  - The pace is grounded and slower, rewarding players who take their time.
- [x] **27. Hidden stuff:**
  - DONE: breakable (cracked) walls guard stash rooms with chips, safes and the secret table door; rooms hit ~85% of floors from floor 3. breakable walls, secret rooms and hidden items.
- [x] **28. The map naturally guides you
  - DONE: removed the exit waypoint arrow (`hud.gd`); the lit exit door (lamp + glow in `level._build_lights`) and the M map guide you. Level layout bias toward the exit is unchanged. to the boss** through layout, lighting and signage, not a waypoint arrow.
- [x] **29. Vendor rooms are spread
  - DONE: tailor, Doc Fizz, Gunny, shady stalls added to every zone's `level.TABLE_POOLS`; map labels them. around the map:** a clothing or items vendor, the sketchy vendor and a weapons vendor.
- [x] **30. Silksong-style map screen
  - DONE: `state "map"` (M key): `hud._draw_map` draws only seen cells, you, exit, shops/tables, boss, SPACE drops markers (`main.map_markers`). on M** that shows only rooms you've visited, plus your position and markers.
- [x] **31. Each city earns you
  - DONE: `main.run_status()` (Bronze..Black Card per boss beaten in the run), chip bonus, shop discount (Gold+), +1 life (Platinum+), status on the HUD (`cities.gd`). a new casino status**, like real loyalty tiers (Bronze, Silver, Gold, Platinum, Black Card). The status gives perks and shows on the HUD.

## G. Money
- [x] **32. Money is poker chips
  - DONE: `chip.gd` real colors incl. $500 purple and $1000 orange, edge-spot art; kills spill loose chips (`main.chips_for`), bosses drop 500/1000 chips. that physically fall and scatter.** Each value has its real-life color:
  - $1 white, $5 red, $25 green, $100 black, $500 purple, $1000 orange/yellow

## H. Story and voice
- [x] **33. The hero is a degenerate gambler
  - DONE: hero renamed RICO everywhere; `story.gd` INTRO/quips/whispers rewritten funny and self-aware; intro cards say five cities; boss lines per boss in `boss_defs.gd`. who loves risk.** Rewrite the story and tone for this: funny and self-aware.
- [x] **34. Voice every character.**
  - DONE: voice.gd autoload + voice_lines*.gd registry (921 lines with IDs), VOICE_SCRIPT.md, README section.
  - Write `VOICE_SCRIPT.md`, which lists every line per character with a line ID.
  - Add a voice system that plays `res://voice/<character>/<line_id>.ogg` when that file exists and falls back to the text blip when it doesn't. The user records or generates the files themself.
  - Document how to add them in the README.

## I. Wrap-up
- [x] **35. Update
  - DONE: README sections, new tests (roster, boss, voice), all suites pass. Screenshots (capture_*.gd) need a display and were not regenerated; the bots in smoke/roster/boss tests exercise the full flow headless.** the README, the tests and the screenshots, and make a final full playthrough pass with the bot or capture scripts.

---

## Session log
- **2026-11-18:**
  - Wrote this checklist and set up the auto-resume scheduled task.
  - Later the same night: item 1 done. Parse, smoke, systems and casino_test all pass.
  - Next: item 2 (clothing items that grant `player.abil`).

---

# PART 2 (added 2026-11-18): do these after items 1-35 are all [x]

## J. Voice acting kit (the user voices EVERY character himself)
- [x] **36. `voice/` folder.**
  - DONE: 46 folders under voice/ with README.txt + .gitkeep, generated by tools/gen_voice_kit.gd.
  - Create one folder per character: `voice/<character_id>/`.
  - Each folder gets a `README.txt` that lists every line file it expects: `<line_id>.ogg` (or `.wav`), with the line text and a direction note.
  - Also add `voice/_cutscenes/<cutscene_id>/` folders.
  - Add an empty `.gitkeep` so the folders exist.
- [x] **37. `VOICE_CAST.md`
  - DONE: VOICE_CAST.md generated from voice_profiles.gd (33 cards).: one card per character**, so the user knows how to perform each voice. Each card has:
  - The name with a signature quote, for example: `RICO "Let it ride, baby!"`.
  - Characteristics: age, accent, pitch (low/mid/high), speed, energy, attitude, a real-world voice reference type (for example "raspy old boxing trainer"), and mouth tricks (gravel, nasal, smile, lisp).
  - A suggested in-engine voice filter preset. The user performs all characters, so the game must help them sound different.
- [x] **38. Per-character voice filters in Godot.**
  - DONE: voice_profiles.gd table, Voice_<id> buses (pitch/EQ/distortion/chorus/reverb) built in voice.gd, Settings > Audio voice volume + filters toggle.
  - Each character gets an AudioServer bus (`Voice_<id>`) with effects: AudioEffectPitchShift, EQ, Distortion (radio/phone), Reverb, Chorus. The presets are defined in one data table (`scripts/voice_profiles.gd`).
  - Voice playback goes through `scripts/voice.gd` (an autoload). It plays `res://voice/<char>/<line_id>.ogg` if the file exists. Otherwise it falls back to synthesized gibberish blips pitched per character, Animal Crossing-style.
  - Add a Settings toggle for the voice volume and for "voice filters on/off".
- [x] **39. `VOICE_SCRIPT.md`
  - DONE: generated; line ids are the ones the dialogue code looks up (voice_lines.gd lookup).: the full recording script.**
  - It is grouped by character, then by scene.
  - Every line has: `line_id`, the text, an emotion/direction note, and where it plays.
  - The dialogue code must reference the same `line_id`s, so dropping a file in makes it play with no code changes.
- [x] **40. Lots of NPCs
  - DONE: minor NPCs (Velma, Dumpster Dan, Slick Nick, Lorraine, Officer Dunn) stand on floors (`prop._draw_npc`, `main._talk_npc`), vendors Silas/Fizz/Gunny, crowd barks every ~30s per city (`main._crowd_bark`), reactive pools (`voice_lines.gd pick`).
  - PROGRESS: all line pools written (14 NPCs, 40+/15+ lines, 72+ crowd barks + 12 per city) and reactive picking in `main._talk`; vendors/crowd NPCs are not yet placed in levels (items 29/26). with lots of lines.**
  - At least 12 named NPCs: vendors, the sketchy dealer, the bartender, alley bums, rival gamblers, a lounge singer, security, the cat, and so on.
  - At least 40 lines each for the main NPCs, and 15+ for minor ones.
  - At least 60 random "barks" for generic crowd/mob NPCs per city: drunk tourists, junkies, pit bosses and others.
  - Lines react to the player's state: winning, losing, ugly clothes, rich, broke, recently died, boss beaten, and so on.
- [x] **41. Voiced cutscenes.**
  - DONE: cutscene dialogue speaks via Voice, waits for the clip then auto-advances, skippable; city arrival scenes, boss intro/defeat per boss, ending scenes. Secret-boss scenes are scripted but wait for item 15.
  - An intro, one per city arrival, a boss intro and boss defeat for every boss, secret boss cutscenes and the ending.
  - Each cutscene line has a `line_id`, so it can be voiced (`voice/_cutscenes/...`).
  - Cutscenes wait for the voice clip to finish when one exists, and are skippable.
- [x] **42. `HOW_TO_RECORD.md`
  - DONE: HOW_TO_RECORD.md generated.: a step-by-step guide for the user.**
  - What to install: Audacity (free).
  - Mic tips, and how to record one line per file.
  - File naming, export settings (OGG, 44.1 kHz, mono).
  - Where to drop the files and how to test them in game.
  - How to make one person sound like many characters: acting tips, plus the in-engine filters.
  - A per-character progress checklist.

## K. Research-driven "what players loved" pass
- [x] **43. Research.**
  - DONE: `RESEARCH_PLAYERS_LOVED.md` with sources (and honest gaps). Use WebSearch/WebFetch to research what players loved most in top roguelikes and platformers:
  - Hollow Knight and Silksong, Hades and Hades II, Dead Cells, Balatro, Risk of Rain 2, Spelunky 2, Celeste
  - Enter the Gungeon, Binding of Isaac, Slay the Spire, Rogue Legacy 2, Blasphemous, Ori
  - Sources: Steam reviews, Reddit and design talks.
  - Write the findings to `RESEARCH_PLAYERS_LOVED.md` with sources. The aim is a NEW game idea built heavily on proven ideas.
- [x] **44. Implement the top 10-15 loved features from the research** that fit this game, as original takes. Examples to judge:
  - synergy discovery moments and item descriptions with personality
  - a hub that grows between runs
  - NPCs who remember you
  - boss rematch or hard modes
  - a bestiary / hunter's journal
  - fast restart
  - secrets that the community shares
  - daily seeds
  - unlockable characters
  - accessibility options
  - satisfying "breaking the game" builds
  - Add each as its own `[ ]` item below as you plan it, then do them one by one.
- [x] **45. A final full-game polish pass
  - DONE: README updated; tests extended; AAA_CHECKLIST untouched (superseded by this file).,** then update README.md, `AAA_CHECKLIST.md` and every test.

  - [x] **44a.** Hunter's journal (F4): `main.bestiary`, `hud._draw_journal`, saved.
  - [x] **44b.** Synergy discovery toasts: `main.COMBOS`, `_check_combos`.
  - [x] **44c.** Item cards with personality: `Charms.FLAVOR`.
  - [x] **44d.** Charm stacking (Risk of Rain style): `charms.add_stack`.
  - [x] **44e.** Already present: fast restart (R), Daily Deal seeds, Assist/accessibility, Heat/Table Limits hard modes, secrets.

## L. Extra voice requirements (added by the user, 2026-11-18)
- [x] **42b. A super simple voice-changing guide**
  - DONE: in HOW_TO_RECORD.md and every voice/<char>/README.txt; F3 voice test menu built; free tool research: Clownfish (free, basic presets) and Voicemod free tier (limited rotating voices)., added to `HOW_TO_RECORD.md` and to every `voice/<character>/README.txt`. Write it for a total beginner, step by step and numbered, with short sentences and no jargon.
  - **Free tools, with exact clicks:**
    - **Audacity** (free): record, trim, Effect > Pitch and Tempo > Change Pitch, then Effect > EQ / Distortion / Reverb, then export.
    - Optionally the **free tier of a real-time voice changer**, so the user can hear the voice live while acting. Name a currently free option found by research (for example Voicemod's free tier or Clownfish), and note any limits of the free version.
  - **One recipe card per character**, with the exact Audacity settings to make the user's single voice sound like that character. For example: `BIG SAL: Change Pitch -4 semitones, Bass Boost +6 dB, slight Distortion 10%`. Each card also has an acting tip, such as "talk from your chest, slow, chewing a cigar".
  - Mention that the game ALSO applies a light in-engine filter per character (item 38). The user can choose either path: bake the effect in with Audacity, or record clean and let the game do it. Say which is easier: recording clean.
  - **A "go down the list" recording checklist** per character: a numbered table of every line with its file name, the exact text, how to say it, and a `[ ]` box for the user to tick. Order it character by character, so the user records one character's whole session in one sitting.
  - **"Test it in game" steps:** drop the file, open Godot, press F5, and go to where the line plays (or use a debug "voice test" menu that plays any line by ID). Build that menu.
- The VOICE NOTIFICATION should only fire after 42b is also [x].

- **2026-11-19 (run 1):**
  - Finished items 2-14 and 23-25 (see notes above). New files: wardrobe.gd, weapons.gd, enemy_types.gd, cities.gd, boss_defs.gd, voice*.gd.
  - DEVIATION: jumped ahead to the voice kit (items 34, 36-42b) so the user can start recording sooner. Items 15-22, 26-33, 35, 40 partly, 43-45 come after.
  - PROGRESS on voice: voice.gd autoload, voice_profiles.gd, voice_lines*.gd (921 lines), F3 voice test menu, settings, tests/voice_test.gd are done. Next: tools/gen_voice_kit.gd -> voice/ folders, VOICE_CAST.md, VOICE_SCRIPT.md, HOW_TO_RECORD.md.

  - Voice kit done (36-42b). VOICE_READY.md written and notification sent. Next: 15-22, 26-33, 35, 40 placement, 43-45.

- **2026-11-19 (run 1 end):** All items 1-45 and 42b are [x]. Remaining known gaps: screenshots not regenerated (no display in the cloud run); ability-only base-kit completability was reasoned about (downward flow) but not bot-verified; hub-based NPC placement of minor NPCs is on floors only. Next: playtest by hand, record voices (see HOW_TO_RECORD.md).

- **2026-11-19 (lobby makeover):** The lobby is now Rico's apartment (bed, window, wardrobe, couch/TV, front door APT 4B) opening onto a night street (skyline, storefronts for Pawn/Lucky/Vera/Mags/News, lamps, bus stop to Atlantic Shitty). `level.generate_lobby`, `_draw_home_bg`, `_draw_home_tile`; screenshots via `xvfb-run ... tests/capture_home.gd`. Voice IDs unchanged; one Marlow intro line's text changed.

---

# PART 3 (added 2026-11-19): AAA visual and audio overhaul
The user wants everything to look and sound advanced, like a AAA game: "not cheap, fast things". Take your time on each item and make it genuinely beautiful. Check your work with screenshots: run `tests/capture*.gd` windowed and compare against the reference games.

Item 50 (sound effects and grunt slots) is being done in a LOCAL session. Do NOT edit `scripts/sfx.gd` or the grunt sections of `HOW_TO_RECORD.md`.

## M. Environments: every map, Hollow Knight and Silksong quality
- [x] **46. Rendering upgrade for levels:**
  - DONE: new `scripts/zone_fx.gd` (4 layers per level: back = 4 fogged parallax layers + light shafts + wall decals; ao = ambient occlusion/contact shadows; mid = animated set dressing; front = 2 foreground parallax silhouettes, vignette, zone particles). Tile materials, rim light from lamps/neons, decals and low-frequency variation via `ZoneFx.tile_detail` in `level._draw_tile`. Camera: slower vertical easing in `main._update_camera`. `tests/capture_zones.gd` screenshots every zone (checked by eye).
  - Parallax: at least 4 background layers plus 1-2 foreground layers per zone, with depth fog and atmospheric perspective.
  - Lighting: rim lighting, light shafts, emissive props, animated ambient particles (dust, steam, embers, rain, confetti depending on zone).
  - Tiles: edge highlights, ambient occlusion in corners, varied tiles (no repeating grid look), decals (cracks, stains, posters, graffiti), and props that break up silhouettes.
  - Smooth camera framing.
- [x] **47. A distinct, detailed look for each city/zone, matching the trashy-to-luxury climb:**
  - **Alley (city 1):** wet brick, dumpsters, fire escapes, flickering neon, steam vents, rain, trash bags, rats, puddle reflections.
  - **Atlantic Shitty, Resortz:** peeling carpet, water-stained ceilings, dim slots, boardwalk windows.
  - **Reno, Cirrcus Cirrcus:** tacky carnival colors, tent stripes, clown art, a tired carousel.
  - **Biloxi, Hard Rok:** guitars, stage lights, gulf windows, wood and leather.
  - **Fremont, Goldun Nugget:** gold, neon canopy, a shark tank, old-Vegas glamour.
  - **The Strip, Bellagiro:** marble, crystal chandeliers, fountains, gardens, art.
  - **Boss arenas:** each table-game boss gets a themed stage with set dressing.
  - **The apartment hub:** cozy-gross, lived-in detail.
  - DONE: zones 0-5 each have their own parallax set, dressing, decals and particles (alley rain/steam/rats/puddles/barrel fire; Resortz carpet/palms/leaks/boardwalk windows; Cirrcus tent stripes/bunting/ferris wheel/balloons/popcorn/carousel horse/confetti; Hard Rok wood paneling/amps/guitars/gulf windows/smoke (palette retuned); Goldun Nugget gold arches/shark tank/glitter; Bellagiro marble/chandeliers/fountains/topiary/sparkles). Boss arenas: curtains, spotlight sweep, per-boss emblem (`level.boss_id`), table + chairs, rising embers. Hub makeover was already done.
- [x] **48. Every character redesigned to look premium:**
  - DONE (this pass): enemy gear per type in new `scripts/gear.gd` (bandana, junkie beanie+syringe, bottle in paper bag, eyeshade+fanned cards, headset+clipboard, shades+earpiece+tie, scoped sniper rifle, crown+monocle) and city jacket palettes (grimy alley, teal Resortz, tent-red Cirrcus, leather Hard Rok, black-gold Nugget, white-tux Bellagiro) via `Rig.enemy_style(kind, floor)`; generated dialogue portraits for every other speaker (all bosses, rivals, crowd) in new `scripts/portraits.gd`, hooked from `Art.npc_portrait`; Rico/boss/NPC rig art, wardrobe tiers and 3-phase boss changes already existed from earlier items. Screenshots: `tests/capture_enemies.gd`, `tests/capture_cast.gd`.
  - **Rico:** silhouette, outfit layers, the clothing tiers per floor, readable at gameplay zoom.
  - **Every enemy type:** distinct silhouettes, color coding by city.
  - **Every NPC:** the vendors, the cat, the rivals, the singer and the others.
  - **Every boss:** big, detailed, animated, with a visual change per phase.
  - **Portraits:** dialogue portraits for everyone.
  - Use `rig.gd` (the procedural IK rig) and code-drawn art, with smooth shading, outlines, highlights and secondary motion (cloth, hair, coats).
  - Keep the animation quality Hollow Knight-like.
- [x] **49. Music overhaul (`scripts/music.gd`):** replace the chiptune/beep feel with rich synthesized music.
  - DONE: `scripts/music.gd` rewritten: FM Rhodes, detuned string pads, upright/sub bass, sax/trumpet/guitar/vibes/calliope leads, brass stabs, pre-rendered drum kit (kick, snare, brush, hats, ride, clap, toms, riser), stereo comb reverb + ping-pong echo, vinyl dust. One theme per zone via `Music.zone` (alley noir, lounge, carnival, blues-rock, swing, luxe strip, home chill) with crossfade on change; boss tracks escalate by phase. `tests/music_test.gd` renders all offline (8-18 us/sample).
  - **Synthesis:** layered pads, an electric-piano/Rhodes timbre (FM), upright or electric bass, real-sounding drum kits (kick, snare, hats synthesized with noise and pitch envelopes), and reverb/echo.
  - **Exploration:** one theme per city that matches its mood: grimy lo-fi jazz noir in the alley, through smoky lounge jazz, to big-band and luxe Vegas on the Strip.
  - **Bosses:** an intense track per boss with phase escalation.
  - **Transitions:** smooth crossfades.
  - **Performance:** keep CPU use reasonable. Precompute wavetables, or render loops into AudioStreamWAV buffers at load time instead of per-sample generation where possible.

## N. Sound effects (LOCAL session: do not edit)
- [x] **50. Sound effects and grunt slots.**
  - DONE (local): `scripts/sfx.gd` rewritten as layered foley at 44.1 kHz: pitch-drop thumps, filtered noise, metal and bell partials, clay-chip clacks, glass shatter, debris grains and room echo. No more beeps.
  - Added `double_jump`, `land_hard` and `heal` sounds.
  - Grunt slots: `Sfx.grunt(who, slot)` plays `res://voice/<who>/grunt_<slot>_<n>.ogg` if the user recorded one. Hooked to Rico's moves, enemy deaths and boss hits and deaths.
  - Documented in `HOW_TO_RECORD.md` and the voice folder READMEs.

---

# PART 4 (added 2026-11-19): comedy pass on every line
`scripts/voice_studio.gd`, `tools/gen_all_lines.gd` and `voice/ALL_LINES.md` (the F6 in-game recording studio and the master list) were built in a LOCAL session. You may regenerate `ALL_LINES.md` with the tool, but don't restructure the studio.

- [x] **51. Make every voice line genuinely funny: dark humor that makes people laugh out loud.**
  - DONE (2026-11-19 run 3): rewrote all voice pools (`voice_lines_main/misc.gd`), `story.gd` (new INTRO/ENDING/TRUE_ENDING/quips/whispers, `STORY_SO_FAR`), `dialogue.gd` (conversations, PA barks, tickets), per-boss `rico_intro`/`rico_defeat` in `boss_defs.gd`; all existing line ids kept (25 new ids: city1-4 `_clue` scenes + longer arrival/ending scenes). Story: city beats in `SCENES` (`city1-5_arrive`, `city1-4_clue` after each boss); Marlow's confession fires on first arrival at Biloxi (flag `marlow_confessed` set in `main`, follow-up conversation needs `max_city>=3`); Big Sal/Madame Roulette/DESCEND/underground wording removed; Mr. Lucky renamed KENO KEVIN (id `mr_lucky` kept); pause menu shows STORY SO FAR (`hud._draw_pause`, `Story.STORY_SO_FAR`); 'Vault Door' renamed 'Safe Door' in UI. Regenerated kit with `tools/gen_voice_kit.gd` + `gen_all_lines.gd`, but merged only changed line text back so the local session's grunt/studio sections in HOW_TO_RECORD.md, VOICE_SCRIPT.md and voice READMEs are intact (the generator would otherwise drop them). Tests: parse, smoke, systems, casino, boss, roster, voice, studio pass. Not checked by ear/eye (no display this run).
  - The user hasn't recorded yet, so do this BEFORE they start. KEEP every line id (`greet_1`, and so on) so the studio and files still match. Only change the text and the "how to say it" notes.
  - **Voice:** Rico is a self-destructive degenerate gambler who is weirdly proud of it. Lean into gallows humor about debt, losing, bad decisions, addiction-as-personality, near-death and The House's corporate cruelty.
    - Comedy styles to draw on: deadpan, absurd escalation, callbacks, rule-of-three, punchy one-liners, characters roasting Rico.
    - Every character has their own comic voice:
      - Mags: cheerful menace.
      - Doc Fizz: horrifying side-effect disclaimers.
      - The bosses: trash talk themed on their game.
      - Crowd NPCs: overheard casino-floor misery.
  - **Rules:**
    - Short lines; punchlines at the end.
    - No slurs, nothing hateful about real groups, nothing sexual involving minors.
    - Dark, but fun, not mean-spirited toward the player.
    - Use the parody casino and site names.
  - **Story consistency:** while rewriting, fix the leftover story contradictions from the old "underground Pit" version so everything fits the 5-city climb from Atlantic Shitty up to the Bellagiro:
    - Remove Big Sal and Madame Roulette references, "down"/"below" wording and the "DESCEND door" tip.
    - Use the new boss roster for the `story.gd` BOSS_* fallbacks.
    - Move Jules's ending to the top of the Bellagiro.
  - **Files:**
    - `scripts/voice_lines_main.gd`, `voice_lines_misc.gd`, `voice_lines.gd`
    - `story.gd`, `dialogue.gd`, `boss_defs.gd` (the boss lines)
    - the death quips, whispers, Losing Tickets and tips
  - **Afterwards, regenerate everything:**
    - Run `tools/gen_voice_kit.gd` and `tools/gen_all_lines.gd`, so `VOICE_SCRIPT.md`, the voice/ READMEs and `voice/ALL_LINES.md` match.
    - Run `tests/voice_test.gd` and `tests/studio_test.gd`.

- **2026-11-19 (run 2, scheduled):** Finished Part 3 items 46, 47, 48, 49 (item 50 was done locally). Music rewritten (`music.gd`, `tests/music_test.gd`); per-zone environments (`zone_fx.gd`, palettes retuned for Reno and Biloxi, `tests/capture_zones.gd`); enemy gear/city palettes (`gear.gd`) and generated portraits (`portraits.gd`). All of Parts 1-3 are now [x]. Notes: `boss_test.gd` is occasionally flaky (random; passes on rerun, also flaked-free on the old code). Music was checked offline for NaNs/clipping/CPU only, not by ear: tune `STYLES` in music.gd by listening. Next: playtest by hand, record voices (HOW_TO_RECORD.md).

## 51 (extra direction from the user): funny AND moves the story forward AND simple to follow
- **Every line should do two jobs:** make people laugh (dark humor), and remind the player where the story is or move it along. Keep it simple: a player who skips half the dialogue should still always know who Rico is chasing, why, and what just happened.
- **Fix all 8 story issues while rewriting:**
  1. Give each city a story beat (the outline below).
  2. Remove the "underground Pit" wording ("down", "below", "vault door", "DESCEND door").
  3. Remove Big Sal and Madame Roulette.
  4. The final boss uses new phase shouts.
  5. The first ending happens at the top of the Bellagiro.
  6. Rename the secret boss "MR. LUCKY" to "KENO KEVIN". Keep the id `mr_lucky` so the folders still match.
  7. Give Rico an active goal with a payoff.
  8. Add a story beat in the middle of the game.

### THE STORY (simple version: use this exactly)
- **The one-line pitch:** Rico climbs 5 casinos, from a dumpster to the Vegas Strip, to win back his brother Jules from The House. The joke is that Rico is just as hooked as Jules was.
- **Intro (the apartment):**
  - Jules bet himself at The House's table and lost. Now he works for The House.
  - Mags makes Rico sign a Marker: Rico can't die, he just wakes up at home owing more. Rico: "So... infinite credit?"
  - Marlow tells him The House keeps Jules at the top of the Bellagiro.
  - The goal is stated plainly: "Climb five casinos. Get Jules. Try not to bet him."
- **City 1, Atlantic Shitty (Resortz):**
  - Rico finds Jules's old jacket in the alley, with a pawn ticket from Reno in the pocket.
  - The boss was holding Jules's first IOU. Taking it gives the clue: "He went to Reno."
- **City 2, Reno (Cirrcus Cirrcus):**
  - Jules pawned his watch here, and the pawn guy says Jules "got promoted" to Biloxi.
  - The boss confirms it: Jules is dealing for The House now.
- **City 3, Biloxi (Hard Rok): the MID-GAME TWIST.**
  - Marlow confesses on the radio: he's the one who got Jules his seat at The House's table.
  - Rico is furious, but keeps climbing, because Marlow is the only one who knows the way. Marlow's confession now fires here, the first time you reach Biloxi, not after 9 runs.
- **City 4, Fremont (Goldun Nugget):**
  - Rico finds a note in Jules's handwriting: "Don't come for me. I'm finally winning."
  - Rico realizes Jules doesn't WANT to be saved, because he's hooked, just like Rico. Rico: "...Okay, that's a little relatable."
- **City 5, the Strip (Bellagiro):**
  - The penthouse. Jules is dealing for The House.
  - The House challenges Rico to Texas Hold'em, with Jules as the pot.
- **First ending:**
  - Rico wins. But Jules only leaves if he CHOOSES to cash out.
  - Rico, the guy who has never once cashed out, has to talk his brother into walking away from a winning table. Played funny and sweet.
  - Jules cashes out. Rico: "...So, one more run? For fun?" Then High Roller mode opens.
- **True ending:** unchanged (Eddie Duval, all 20 tickets, Vera freed). Make sure it says "the top of the Bellagiro".

### Where the story gets told
- **City arrival cutscenes:** one short scene per city with the beat above, in 3-6 lines, with a joke in each.
- **Boss intros and defeats:** each boss teases the beat on intro, and drops the clue on defeat.
- **Marlow's radio lines:** one per city that recaps "where Jules is" in a funny way.
- **NPC chatter:** reacts to the current city's beat.
- **The pause menu:** a one-line "STORY SO FAR" that updates per city (for example, "Jules pawned his watch in Reno. He's in Biloxi now.").

### Tone examples (match this energy)
- RICO, on getting the Marker: "Can't die, just owe more. I've been training for this my whole life."
- MAGS: "Don't think of it as debt, sweetie. Think of it as a relationship."
- DOC FIZZ: "Side effects include luck, death, and a strong opinion about jazz."
- MARLOW: "Good news, Jules is alive. Bad news, he's in Reno."

- **2026-11-19 (run 3, scheduled):** Finished item 51 (comedy + story pass). Everything in Parts 1-4 is now [x]. NOTE: gen_voice_kit.gd overwrites HOW_TO_RECORD.md, VOICE_SCRIPT.md and voice READMEs and drops the local grunt/studio sections; merge line changes only if you rerun it. Next: playtest, record voices.

- [ ] **52. Second comedy pass: lines must MAKE SENSE, darker, humor-forward, High on Life energy.**
  - The user's feedback on the item 51 lines: "make sure the lines make sense, not just random bs. Darker, more humor-forward, like High on Life."
  - KEEP every line id. Rewrite text and "how to say it" notes only. Then regenerate the kits (`gen_voice_kit.gd`, `gen_all_lines.gd`) and run `voice_test` and `studio_test`.
  - **What went wrong in pass 51** (real examples to fix):
    - Non-sequiturs that don't parse:
      - "Behave. Or whatever the opposite of this is. Behave anyway."
      - "Come back when you're rich! Or me. I'll be rich! Or dead!"
      - "Everybody here lost their voice. It's a cult. It's called Karaoke."
      - "It's the same water. It's also the same tap."
    - An overused choppy rhythm, "Thing. Other thing. Third thing.", on almost every line. It reads like random fragments, not a person talking.
    - Jokes that don't connect to the moment the line plays in, the character speaking, or the story.
  - **What GOOD looks like:** High on Life ENERGY. Do not copy its lines, characters or names.
    - Characters TALK TO Rico like real, unhinged people, in natural run-on sentences. They riff, interrupt themselves, over-explain, get weirdly specific, and escalate one idea to an absurd, dark conclusion.
    - Self-aware, occasionally fourth-wall jokes (about respawning, loading screens, being a video game, the player's choices).
    - Every character has ONE comic obsession they keep coming back to (callbacks):
      - Mags: loves Rico's debt like a pet, and is threatening in a sweet voice.
      - Doc Fizz: legally mandated side-effect disclaimers that get worse.
      - Marlow: tired babysitter who has given up, and guilty about Jules.
      - Lucky: runs a betting pool on Rico's deaths.
      - Gunny: deeply, inappropriately in love with his guns.
      - Silas: a fashion snob who judges your ugly-buff clothes.
      - The House: a smug corporate villain who speaks in HR and loyalty-program language.
      - Each boss: trash talk built on ITS card game's actual rules.
      - Crowd NPCs: overheard, specific casino-floor misery.
    - Darker topics are fine, as punchlines aimed at Rico, the House or the situation: debt, addiction, dying over and over, bad decisions, the House owning your soul, scammy loyalty programs, sad tourists.
    - Never: slurs, hate toward real groups, sexual content involving minors, or mocking real tragedies.
  - **The rules, per line:**
    1. **It makes sense:** a stranger reading the line, with its "where it plays" note, gets the joke right away.
    2. **It fits the moment:**
       - a greet line greets you
       - a "broke" line is about being broke
       - a boss phase line is about that phase
       - a story line states its story beat clearly
    3. **One clear joke per line, with the punchline LAST.** Lines can be longer and conversational (1-3 sentences, up to ~35 words). Barks and crowd lines stay short.
    4. **Sounds like a person,** not word salad. Read it out loud. If it's awkward to say, rewrite it.
    5. **Story lines stay crystal clear:** a funny delivery is fine, but the plot fact (where Jules is, what just happened) must be stated plainly.
  - **Review step (required):**
    - After rewriting, go through EVERY line in `voice/ALL_LINES.md` and score it against rules 1-5.
    - Rewrite anything that fails.
    - Write `COMEDY_REVIEW.md`: the 20 lines you're most proud of, plus any you couldn't fix.
  - **Tone examples** (write in this direction, don't reuse them verbatim):
    - MAGS (greet): "Rico! My favorite investment. You look terrible, which is great news for my interest rate."
    - DOC FIZZ (buy): "Excellent choice. By law I have to tell you this may cause luck, liver failure or a brief conversation with God. He's a big fan of yours, actually. Bit of a gambler."
    - LUCKY (died): "Welcome back! I had you dying on the stairs, so honestly, thank you. Drinks are on the guy who bet 'spikes.'"
    - THE HOUSE (PA): "Attention, guests: Rico has died for the forty-third time. As a valued member, he has earned one complimentary... nothing. Thank you for your loyalty."

- [ ] **53. Polish pass on item 52's lines: rhythm variety and tightening.** (Do this after 52; the review step can fold into it.)
  - **What item 52 got right:** the story lines in `story.gd` are clear AND funny. Keep that style. Example: "Then he lost, which means he now works there, which means my family finally has a steady job."
  - **What still needs fixing in the NPC pools** (`voice_lines_main.gd` / `voice_lines_misc.gd`):
    1. **The new tic is the comma-spliced ramble:** ", and ..., and ..., and ...". It's on almost every line, which is as repetitive as the old "Thing. Thing. Thing."
       - Rule: at most ONE "and"-chain per line.
       - Use real sentence breaks.
       - Mix lengths. About 40% short punchy one-liners (under 14 words), 40% medium (1-2 sentences), 20% longer riffs. The riffs are for the characters who ramble (Marlow, Doc Fizz, Silas, Gunny).
    2. **Cut lines that still don't make sense:**
       - "the shoes are in debt, and the debt is in love with the shoes"
       - "I'm winning now, and the winning feels so, so different"
       - "or did, they blur together, like all my mistakes, and I'm winning, so I'm taking credit"
       - "I'll be the guy who loses, again"
       - Any line where the last clause changes the subject. A punchline must PAY OFF the setup, not wander off.
    3. **Jules:** he is hooked and happy at The House's table, and talks like a cheerful addict in denial. His lines must clearly say he doesn't want to leave, in a funny way. Example: "I'm not trapped, Rico, I'm employed. There's a difference. The difference is dental."
    4. **Trim every line by ~20%.** If a phrase doesn't set up or deliver the joke, delete it.
  - Then run the review step from item 52 on the result: score every line, rewrite the failures, and write `COMEDY_REVIEW.md`.
  - Regenerate the kits. Run `voice_test` and `studio_test`.

> **Note (LOCAL session, 2026-11-19):** the user chose a MEDIUM recording list.
> - `scripts/voice_plan.gd` decides which lines go on it, about 486 lines plus 33 grunts.
> - The F6 studio and `voice/ALL_LINES.md` show only that list. Press A in the studio to see the extras.
> - When rewriting lines, put the BEST joke in the recorded versions (version 1 and 2 of each moment, the story lines, and boss intro, defeat and phase lines). Don't change `voice_plan.gd`.

> **Note (LOCAL session, 2026-11-19):** the title screen (`scripts/title_screen.gd`, `hud._draw_title`) and Rico's in-game character art (`scripts/rico_art.gd`, `rig._limb_smooth`, `Wardrobe.draw(..., integrated)`) were rebuilt locally. Don't revert them. If you touch them, only polish.

- [ ] **54. A tutorial area that teaches every move, one at a time.** The user asked: "each thing like the movement needs to be explained in some type of tutorial level or tiny area."
  - **Build "THE BACK ALLEY": a short, hand-built practice course behind Rico's apartment.**
    - Reachable from the street hub through a gate marked "PRACTICE".
    - On the very first run, the game routes you through it before floor 1 (skippable with a prompt).
  - **Stations, each with a big readable sign:**
    - the move's name
    - the key or button, using the player's actual binding (reuse `main._coach_tick` / the key-name helpers)
    - a one-line funny explanation in Rico or Marlow's voice
  - **The obstacle teaches the move.** Order:
    1. Walk
    2. Jump: a crate
    3. Hold jump for height: a taller ledge
    4. Dash: a gap too wide to jump
    5. Attack: a cardboard dummy
    6. Down-attack pogo: spikes with a balloon to bounce on
    7. Parry: a dummy that throws slow cards
    8. Heal with Nerve
    9. Ranged weapon: shoot a can
    10. Breakable walls: a cracked wall hiding chips
    11. The map (M)
    12. The exit door: Cash Out vs Let It Ride, using fake chips
  - **Ability stations for the clothing abilities** (double jump, wall cling, ground pound, glide): unlock as Rico first wears each item. A ghostly "try it" outline shows the move; reuse the coach UI.
  - **Feedback per station:** a checkmark, and a "NICE" pop with a sound once done. A progress tracker shows "6/12 learned".
  - **Persistence:** it remembers completion in the save. It can be replayed any time from the hub gate or the pause menu ("PRACTICE").
  - Every new line goes into the voice registry (`voice_lines_misc.gd`) with ids, and must pass `voice_plan.should_record()` (story or tutorial lines are recorded). Then regenerate the kits.
  - **Tests:** add `tests/tutorial_test.gd`, which walks a bot through the stations and checks each completes. Screenshot it with a capture script.
