# LET IT RIDE

A 2D parkour-and-brawling roguelike heist through The Pit, an illegal casino buried under the city. Built in Godot 4.7 with GDScript only. It needs no asset files: the art is drawn in code, and the sound effects and music are synthesized live.

**Story:** Rook breaks into The Pit to get their brother Jules back. There are twelve floors and a boss every 4th floor (Big Sal, Madame Roulette, The House). Marlow talks you through it over the radio. Beating The House unlocks the ending and High Roller mode, where the floors keep going down.

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
  - Big Sal: card fans, charges and ground slams
  - Madame Roulette: adds bouncing roulette balls
  - The House: adds summoned guards
- **Economy:**
  - Pot, Flow multiplier, and the Cash Out vs Let It Ride choice at each door
  - the House Rules list grows while you ride
- **Casino:** playable slot machines, blackjack and roulette, all bet from your Pot.
- **Lucky the bartender:** sells drinks mid-run.
- **Environment:**
  - real-time 2D lights with shadows, neon signs, slot cabinets and god rays
  - breakables: glass you can smash through, cracked secret walls, crumbling floors, and crates, urns and display cases full of chips
  - grass that reacts to you, swinging vines and glowing mushrooms
  - a post-processing pass (bloom, vignette and an iris transition)
- **Animation:** a procedural IK rig for every character, a physics scarf and afterimages.
- **Music:** calm generative piano while exploring; it crossfades into an intense drum-and-bass battle track near enemies and in boss fights.
- **Meta:**
  - The Fence skill tree: 3 branches and 12 skills, paid for with banked cash
  - 3 playable runners: Rook; Dice, unlocked by beating Big Sal; Jules, unlocked by finishing the story
  - 14 trophies
  - saved settings and stats

## Tuning
- **Feel:** edit `config/movement.tres` in the Inspector.
- **Flow, economy and boss frequency:** select the `Main` node in `scenes/main.tscn`.
- **Story text:** `scripts/story.gd`.
- **Skills, runners and trophies:** the `SKILLS`, `CHARACTERS` and `TROPHIES` tables at the top of `scripts/main.gd`.

## Tests
- `godot --headless --path . --script res://tests/smoke.gd` runs generation, combat, a boss, the casino, skills and death.
- `godot --path . --script res://tests/capture.gd` saves screenshots to `user://`.
- `godot --path . --script res://tests/poses.gd` saves a gallery of every animation pose.
