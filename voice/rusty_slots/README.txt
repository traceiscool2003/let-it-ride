VOICE FOLDER: ONE-ARMED BANDIT  (rusty_slots)
Secret boss: a haunted slot machine.

HOW TO PERFORM: Pull my arm. Go on. I dare you.
ACTING TIP: Cheerful voice, dead eyes, glitches in the middle of words.
AUDACITY RECIPE: Change Pitch +1 semitones, Bass -4 dB, Treble +3 dB, Mid +5 dB, Distortion 50%, Reverb 10% (Room Size 40), Chorus / Phaser 50%

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

FILES EXPECTED (.ogg, 44.1 kHz, mono). 11 lines:

intro_1.ogg
    SAY: "Pull my arm. Go on. I dare you. I'm a very lonely arm."
    HOW: Boss intro cutscene. Menacing. The Slot Machine themed.  (Boss intro)

defeat_1.ogg
    SAY: "Jackpot... for YOU? That's... that's the first time. I'm so proud. I'm so sad."
    HOW: Boss defeat. Falling apart.  (Boss defeat)

phase2_1.ogg
    SAY: "JACKPOT. JACKPOT. JACKPOT. Please insert your life savings."
    HOW: Boss reaches phase 2. Furious, stronger.  (Boss fight (phase2))

phase3_1.ogg
    SAY: "ERROR. ERROR. LUCKY SEVEN. ERROR. YOU ARE A SEVEN. ERROR."
    HOW: Boss reaches the final phase. Desperate and angry.  (Boss fight (phase3))

taunt_1.ogg
    SAY: "Insert coin to continue dying. No coin? Continue dying anyway."
    HOW: Boss taunt during an attack.  (Boss fight (taunt))

taunt_2.ogg
    SAY: "Spin. Spin. Spin. I'm not a machine. I'm an addiction with a handle."
    HOW: Boss taunt during an attack.  (Boss fight (taunt))

taunt_3.ogg
    SAY: "Pull my arm. Go on. I dare you. It's the only thing I've ever wanted."
    HOW: Boss taunt during an attack.  (Boss fight (taunt))

hurt_1.ogg
    SAY: "BZZZT. Ow. BZZZT. Is that my arm? Is that YOUR arm?"
    HOW: Boss gets hit. Grunt-style.  (Boss fight (hurt))

hurt_2.ogg
    SAY: "Tilt. Tilt. Tilt. Someone call my mother. She's a toaster."
    HOW: Boss gets hit. Grunt-style.  (Boss fight (hurt))

kill_1.ogg
    SAY: "Three bars. You lose. Three bars. You also lose. Three."
    HOW: Boss kills the player. Gloating.  (Boss fight (kill))

kill_2.ogg
    SAY: "OUT OF ORDER. OUT OF ORDER. HOPE: OUT OF ORDER."
    HOW: Boss kills the player. Gloating.  (Boss fight (kill))


GRUNTS (optional): grunt_hurt_1.ogg .. grunt_hurt_3.ogg (when hit, about 1 in 3 hits) and grunt_death_1.ogg (when defeated), in this boss's voice. See HOW_TO_RECORD.md, section "Grunts".
