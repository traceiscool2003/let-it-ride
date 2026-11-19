VOICE FOLDER: GUNNY  (gunny)
The weapons vendor.

HOW TO PERFORM: Everything goes bang. Some things go BANG.
ACTING TIP: Everything is an order. Everything is a compliment.
AUDACITY RECIPE: Change Pitch -4 semitones, Bass +3 dB, Treble -1 dB, Mid +2 dB, Distortion 15%

SUPER SIMPLE VOICE-CHANGING GUIDE (beginner):
 1. Install Audacity (free): audacityteam.org.
 2. Click the red Record button and say a line. Click Stop.
 3. Trim the silence at both ends (drag, press Delete).
 4. EASY WAY: skip effects. Just act the voice using the tip above, export, done.
 5. BAKED WAY: press Ctrl+A, then use Effect > Pitch and Tempo > Change Pitch, Effect > EQ and Filters > Bass and Treble,
    Effect > Distortion and Modulation > Distortion, Effect > Delay and Reverb > Reverb with the recipe below.
 6. File > Export > Export as OGG. Name the file exactly like the ID. Save it in this folder.
 7. Test: open Godot, press F5, press F3 (Voice Test), pick this character, press Enter.
 Live voice changer (optional, free): Clownfish Voice Changer. Free version has basic presets only.

SIMPLE VERSION: record each line CLEAN (no effects), name it like the ID, drop it here. The game adds this character's voice filter for you.
Or bake the recipe in with Audacity, then turn OFF Settings > Audio > Voice Filters.

FILES EXPECTED (.ogg, 44.1 kHz, mono). 40 lines:

greet_1.ogg
    SAY: "Welcome to the armory, recruit."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_2.ogg
    SAY: "Stand up straight! That's a weapon you're holding. Your face."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_3.ogg
    SAY: "Rack 'em and stack 'em, gamblers!"
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_4.ogg
    SAY: "You need firepower. I can smell it."
    HOW: Greeting the player. In character.  (NPC talk (greet))

farewell_1.ogg
    SAY: "Don't shoot your foot. Shoot THEIRS."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_2.ogg
    SAY: "Dismissed. Try to die forward."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_3.ogg
    SAY: "Clean your guns. Wash your hands. Never your lucky socks."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_4.ogg
    SAY: "Move out, rookie."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

rich_1.ogg
    SAY: "Cash! The universal caliber!"
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_2.ogg
    SAY: "A big spender! I salute your wallet."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_3.ogg
    SAY: "Now THAT is purchasing power."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_4.ogg
    SAY: "I'll throw in a free ammo clip. And a salute."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

broke_1.ogg
    SAY: "No money, no bang. It's simple."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_2.ogg
    SAY: "Broke? Throw rocks. It's a classic."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_3.ogg
    SAY: "A recruit with no cash. It's a start."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_4.ogg
    SAY: "I'm not a charity. I'm a battle store."
    HOW: The player is nearly broke.  (NPC talk (broke))

ugly_1.ogg
    SAY: "Soldier, that outfit is a disciplinary action."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_2.ogg
    SAY: "Camouflage? You look like a bruise."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_3.ogg
    SAY: "I've seen better uniforms on a scarecrow."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_4.ogg
    SAY: "What happened to your pants, recruit?"
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

sharp_1.ogg
    SAY: "Spit-shined! I'm almost proud."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_2.ogg
    SAY: "That suit says 'I'm lethal in four languages.'"
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_3.ogg
    SAY: "You look like a general. Behave like one."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_4.ogg
    SAY: "A sharp dresser holds a gun better."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

died_1.ogg
    SAY: "You're dead? Walk it off!"
    HOW: The player just died.  (NPC talk (died))

died_2.ogg
    SAY: "That's what the armor's for, rookie."
    HOW: The player just died.  (NPC talk (died))

died_3.ogg
    SAY: "Retrain. Rearm. Resurrect. Repeat."
    HOW: The player just died.  (NPC talk (died))

died_4.ogg
    SAY: "The only bad death is the unarmed one."
    HOW: The player just died.  (NPC talk (died))

boss_1.ogg
    SAY: "A boss down! Medals for everyone!"
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_2.ogg
    SAY: "That's the kind of firepower I like!"
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_3.ogg
    SAY: "I sold that boss his first revolver. I regret nothing."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_4.ogg
    SAY: "You make me proud. Don't make it weird."
    HOW: The player just beat a boss.  (NPC talk (boss))

idle_1.ogg
    SAY: "Chip flick. Card fan. Dice bomb. Pick one."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_2.ogg
    SAY: "A revolver has six reasons. Use five."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_3.ogg
    SAY: "Coin shotgun's the favorite. Don't ask why."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_4.ogg
    SAY: "Weapons don't kill people. Bad odds do."
    HOW: Idle chatter. Random.  (NPC talk (idle))

buy_1.ogg
    SAY: "Excellent! Point it away from yourself!"
    HOW: The player just bought something.  (NPC talk (buy))

buy_2.ogg
    SAY: "That's a classic. Respect it."
    HOW: The player just bought something.  (NPC talk (buy))

buy_3.ogg
    SAY: "Eight out of ten customers survive."
    HOW: The player just bought something.  (NPC talk (buy))

buy_4.ogg
    SAY: "Good choice, recruit. It kicks."
    HOW: The player just bought something.  (NPC talk (buy))

