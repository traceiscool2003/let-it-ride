VOICE FOLDER: FANDOOL  (fandool)
Boss: Seven Card Stud.

HOW TO PERFORM: Everything you do is face up, pal.
ACTING TIP: Yell every third word like a replay is on.
AUDACITY RECIPE: Change Pitch -1 semitones, Bass +2 dB, Mid +3 dB, Distortion 20%, Reverb 10% (Room Size 40)

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
    SAY: "Three down, four up. Everything you do is face up, pal."
    HOW: Boss intro cutscene. Menacing. Seven Card Stud themed.  (Boss intro)

defeat_1.ogg
    SAY: "The river... wasn't supposed to... bleed."
    HOW: Boss defeat. Falling apart.  (Boss defeat)

phase2_1.ogg
    SAY: "Now it's a REAL game!"
    HOW: Boss reaches phase 2. Furious, stronger.  (Boss fight (phase2))

phase3_1.ogg
    SAY: "FINAL QUARTER! LET'S GOOOOO!"
    HOW: Boss reaches the final phase. Desperate and angry.  (Boss fight (phase3))

taunt_1.ogg
    SAY: "Everything's face up, buddy!"
    HOW: Boss taunt during an attack.  (Boss fight (taunt))

taunt_2.ogg
    SAY: "I've seen your hole cards. They're shaking."
    HOW: Boss taunt during an attack.  (Boss fight (taunt))

taunt_3.ogg
    SAY: "Replay that! Replay it!"
    HOW: Boss taunt during an attack.  (Boss fight (taunt))

hurt_1.ogg
    SAY: "Foul! That's a foul!"
    HOW: Boss gets hit. Grunt-style.  (Boss fight (hurt))

hurt_2.ogg
    SAY: "REF!"
    HOW: Boss gets hit. Grunt-style.  (Boss fight (hurt))

kill_1.ogg
    SAY: "Another one bites the dust!"
    HOW: Boss kills the player. Gloating.  (Boss fight (kill))

kill_2.ogg
    SAY: "Sudden death. For you."
    HOW: Boss kills the player. Gloating.  (Boss fight (kill))


GRUNTS (optional): grunt_hurt_1.ogg .. grunt_hurt_3.ogg (when hit, about 1 in 3 hits) and grunt_death_1.ogg (when defeated), in this boss's voice. See HOW_TO_RECORD.md, section "Grunts".
