VOICE FOLDER: OFFICER DUNN  (dunn)
Casino security.

HOW TO PERFORM: Sir, you can't do that here.
ACTING TIP: Say everything like reading the same warning for the 800th time.
AUDACITY RECIPE: Change Pitch -3 semitones, Treble -4 dB, Mid +4 dB, Distortion 45%

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

FILES EXPECTED (.ogg, 44.1 kHz, mono). 16 lines:

idle_1.ogg
    SAY: "Sir, you can't do that here."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_2.ogg
    SAY: "I'm just doing my job. Which is you."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_3.ogg
    SAY: "Please keep your hands where I can see them. And your chips."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_4.ogg
    SAY: "Management reserves the right to refuse. Everything."
    HOW: Idle chatter. Random.  (NPC talk (idle))

greet_1.ogg
    SAY: "Evening, sir. Behave."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_2.ogg
    SAY: "ID, please. And your life story."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_3.ogg
    SAY: "Move along, citizen. Or stand still. I'm confused."
    HOW: Greeting the player. In character.  (NPC talk (greet))

farewell_1.ogg
    SAY: "Have a nice day. Or don't. It's not my department."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_2.ogg
    SAY: "Exit's that way. Not that way. That way."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_3.ogg
    SAY: "Enjoy your stay. Quietly."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

rich_1.ogg
    SAY: "That's a lot of money, sir. I'll be watching."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_2.ogg
    SAY: "Winning is fine. Winning loudly is a violation."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

broke_1.ogg
    SAY: "No funds? The exit's that way."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_2.ogg
    SAY: "Loitering without chips is discouraged."
    HOW: The player is nearly broke.  (NPC talk (broke))

died_1.ogg
    SAY: "Sir, you can't die here. It's against policy."
    HOW: The player just died.  (NPC talk (died))

boss_1.ogg
    SAY: "You hit a boss? That's... that's an incident."
    HOW: The player just beat a boss.  (NPC talk (boss))

