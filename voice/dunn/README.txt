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
    SAY: "Nineteen years in security here, and I've never seen a guest leave happy. I call that professional success."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_2.ogg
    SAY: "I'm told my job is to protect the casino from you, and you from the casino. Nobody will say which one pays."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_3.ogg
    SAY: "I'm not paid enough for this. I say it out loud every hour, in case payroll is listening."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_4.ogg
    SAY: "Management says smile at the guests. But the guests keep dying, which makes smiling feel strange."
    HOW: Idle chatter. Random.  (NPC talk (idle))

greet_1.ogg
    SAY: "Evening, sir. Please keep your hands visible, your chips visible, and your intentions visible, if you have any."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_2.ogg
    SAY: "Welcome, sir. I'll need ID, a second ID, and a brief explanation of why you look like that."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_3.ogg
    SAY: "Ah, Rico. I was told you'd be coming. There's a laminated photo of you at the front desk."
    HOW: Greeting the player. In character.  (NPC talk (greet))

farewell_1.ogg
    SAY: "Have a safe evening, sir. If you die on the premises, do it near the exit. The mop is closer."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_2.ogg
    SAY: "Exit's that way, sir. If you're planning a scene, it's also that way, but faster."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_3.ogg
    SAY: "Please take nothing from the premises, sir, including the lighting. Someone did last week."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

rich_1.ogg
    SAY: "Sir, that is a lot of money. I'll need you to carry it more apologetically."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_2.ogg
    SAY: "Winning is fine, sir, but do it quietly. The losers nearby have a policy about eye contact."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

broke_1.ogg
    SAY: "Without funds, sir, you're just a man standing in a casino. That's loitering with extra steps."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_2.ogg
    SAY: "No money? That's fine, sir. The exit is free, the only thing in here that is."
    HOW: The player is nearly broke.  (NPC talk (broke))

died_1.ogg
    SAY: "Sir, dying on the premises is against policy. I've filed a form. The form has already been rejected."
    HOW: The player just died.  (NPC talk (died))

boss_1.ogg
    SAY: "You hurt a boss, sir? That's an incident. I'll need a form, a witness, and ideally a different job."
    HOW: The player just beat a boss.  (NPC talk (boss))

