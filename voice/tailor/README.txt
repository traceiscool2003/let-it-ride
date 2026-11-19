VOICE FOLDER: SILAS STITCH  (tailor)
The tailor. Sells clothes (and abilities).

HOW TO PERFORM: Clothes make the man. Clothes make the DASH.
ACTING TIP: Sniff at the player's outfit before each line.
AUDACITY RECIPE: Change Pitch +1 semitones, Bass -2 dB, Treble +1 dB, Mid +2 dB, Reverb 10% (Room Size 40)

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
    SAY: "Do come in, but mind the mannequins. They bite when ignored, and you look like someone who ignores things, including mirrors."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_2.ogg
    SAY: "Ah, a customer, or a stray. Hold still while I find out which, and don't breathe on the silk. It's older than your last three decisions combined."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_3.ogg
    SAY: "Silas Stitch, at your service. Good heavens, there's a lot of waistline here. We'll need the long tape, and possibly a second tailor."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_4.ogg
    SAY: "Welcome, welcome. Do sit down before you offend the mannequins. They have strong opinions about what you've chosen to wear."
    HOW: Greeting the player. In character.  (NPC talk (greet))

farewell_1.ogg
    SAY: "Wear it well, Rico. Or at least wear it. And whatever happens, never put it in a fanny pack."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_2.ogg
    SAY: "Mind the hem on the way out, and the door, and your life choices. Only one of those can be fixed by a tailor."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_3.ogg
    SAY: "Do try not to bleed on the silk, or the wool, or me. I have only one handkerchief and it's a rental."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_4.ogg
    SAY: "Come back for a fitting and a lecture. It's forty minutes long, it starts with your shoes, and it ends with your mother."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

rich_1.ogg
    SAY: "A gentleman with means! Now we can begin the long, lovely lie that you have taste, starting with a very expensive belt."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_2.ogg
    SAY: "Heavy pockets mean lovely hems. I'll bill you for both, and for the emotional labor of looking at you."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_3.ogg
    SAY: "With that fortune we might fix your posture, though I suspect surgery is the only honest option."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_4.ogg
    SAY: "Money, how delightfully vulgar. Spend it on me, and I'll make you a coat so fine the House will ask for my name."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

broke_1.ogg
    SAY: "No funds? Then we tailor in imagination. Imagine a very nice belt. There. That's two dollars."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_2.ogg
    SAY: "I can offer a belt of regret. It's free, it itches, and it clashes with everything, including your skin."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_3.ogg
    SAY: "Poverty is merely fashion in beta, darling. You've been in beta for years, and the reviews are devastating."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_4.ogg
    SAY: "Come back when you can afford sleeves, my dear. Until then you're a vest, and a tragic one, but at least well ventilated."
    HOW: The player is nearly broke.  (NPC talk (broke))

ugly_1.ogg
    SAY: "Dear boy, did you dress yourself in a dumpster? Don't answer. The smell already did."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_2.ogg
    SAY: "That fanny pack is a war crime. I'd gladly testify, in my best suit, the only thing here you haven't offended."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_3.ogg
    SAY: "I won't say what I think. I will faint instead. Watch. There. Now I need water and a different customer."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_4.ogg
    SAY: "You look like a rumor of an outfit, Rico, and a poorly sourced one. Even my mannequins have turned to face the wall."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

sharp_1.ogg
    SAY: "Now that is a proper silhouette, Rico. A murder suspect, but a dapper one, and I'd happily testify to the tailoring."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_2.ogg
    SAY: "Magnificent. I'd hang it in a museum, next to the exhibit of men who died wearing it. It's a very popular wing."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_3.ogg
    SAY: "You're a credit to the craft, Rico, and to my commission. In a rare moment of sincerity, I may even stop judging your shoes."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_4.ogg
    SAY: "I made half that outfit. You made the other half, barely. Squint and it almost works, and I'm taking all the credit."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

died_1.ogg
    SAY: "You died in my wares, Rico? Did it stain? I can fix a hole, but I cannot fix a blood type."
    HOW: The player just died.  (NPC talk (died))

died_2.ogg
    SAY: "A dead client is a quiet client, which I love. A bloody client is a lawsuit, and my lawyer is a mannequin."
    HOW: The player just died.  (NPC talk (died))

died_3.ogg
    SAY: "Bleed on the old stock if you must, but never the new silk. I promised that silk a better life."
    HOW: The player just died.  (NPC talk (died))

died_4.ogg
    SAY: "Hold still, I'll mend the holes. Which are bullet holes and which are style? Don't tell me. I prefer to think they're all style."
    HOW: The player just died.  (NPC talk (died))

boss_1.ogg
    SAY: "You defeated a boss, how marvelous. Then you'll need armor, fashionable armor. Is there any other kind? No."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_2.ogg
    SAY: "Slaying monsters in silk, how delightful. Stains come out with lemon, wine and prayer, in that order, and the prayer is mostly for me."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_3.ogg
    SAY: "Those trophies will need a tasteful frame, Rico, and perhaps a better class of enemy. One who dresses with intention."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_4.ogg
    SAY: "I once made that boss a custom suit. He hated it. Now he's dead, so technically I got the last word."
    HOW: The player just beat a boss.  (NPC talk (boss))

idle_1.ogg
    SAY: "Gloves for gripping, boots for smashing, scarves for gliding. Hats are for nothing. I simply like hats."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_2.ogg
    SAY: "The shoes make the man, Rico. I just wish the man would hold still for a fitting."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_3.ogg
    SAY: "Stand straight, Rico. The cloth knows. It's judging your spine, and it is extremely disappointed."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_4.ogg
    SAY: "Everything I sell grants a talent, mostly vanity, occasionally a double jump. I've never decided which is more useful in this building."
    HOW: Idle chatter. Random.  (NPC talk (idle))

buy_1.ogg
    SAY: "A fine choice. I knew it would suit you. I say that to everyone and it's never true, but this time it's slightly less false."
    HOW: The player just bought something.  (NPC talk (buy))

buy_2.ogg
    SAY: "Wear it with confidence, Rico, or at least with shoes. I'm still not convinced you own any."
    HOW: The player just bought something.  (NPC talk (buy))

buy_3.ogg
    SAY: "I shall tell the thread you said hello. The thread has opinions about you, and none are flattering."
    HOW: The player just bought something.  (NPC talk (buy))

buy_4.ogg
    SAY: "One moment while I finish. The pins are my pride, and also my weapons, and I won't discuss the second part with the authorities."
    HOW: The player just bought something.  (NPC talk (buy))

