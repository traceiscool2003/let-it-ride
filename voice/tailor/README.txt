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
    SAY: "Do come in. Mind the pins. And the mannequins, they bite when ignored."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_2.ogg
    SAY: "Ah. A customer. Or a stray. Hold still, I shall find out which."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_3.ogg
    SAY: "Silas Stitch, at your service. And at your waistline. Good heavens, there's a lot of it."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_4.ogg
    SAY: "Good heavens. Sit down before you offend the mannequins. They have feelings. Sadly, no opinions on you."
    HOW: Greeting the player. In character.  (NPC talk (greet))

farewell_1.ogg
    SAY: "Wear it well. Or wear it. Anything. Please do not carry it."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_2.ogg
    SAY: "Mind the hem on the way out. And the door. And your life choices."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_3.ogg
    SAY: "Do try not to bleed on the silk. Or the wool. Or me."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_4.ogg
    SAY: "Come back for a fitting. And a lecture. I've prepared the lecture. It's forty minutes."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

rich_1.ogg
    SAY: "Splendid. A gentleman with means. Let us begin the long lie that you have taste."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_2.ogg
    SAY: "Ah, the pockets are heavy. The hems shall be lovely. I'll bill you for both."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_3.ogg
    SAY: "With that fortune, we might fix your posture. Surgery is also an option."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_4.ogg
    SAY: "Money! How delightfully vulgar. Please, spend it. On me. Beautifully."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

broke_1.ogg
    SAY: "No funds? Then we tailor in imagination. Imagine a very nice belt. There. That's two dollars."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_2.ogg
    SAY: "I can give you a very nice belt of regret. It's free. It's itchy."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_3.ogg
    SAY: "Poverty is just fashion in beta. And you've been in beta for years."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_4.ogg
    SAY: "Come back when you can afford sleeves. Until then, you're a vest. A tragic vest."
    HOW: The player is nearly broke.  (NPC talk (broke))

ugly_1.ogg
    SAY: "Dear boy, did you dress in a dumpster? Don't answer. The smell has answered."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_2.ogg
    SAY: "That fanny pack is a war crime. I'd testify."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_3.ogg
    SAY: "I will not say what I think. I will faint. Watch. There. I'm up. Ugh."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_4.ogg
    SAY: "You look like a rumor of an outfit. And the rumor is bad."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

sharp_1.ogg
    SAY: "Now THAT is a proper silhouette. A murder suspect, but a dapper one."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_2.ogg
    SAY: "Magnificent. I'd put it in a museum. Next to the ones that died in it."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_3.ogg
    SAY: "You are a credit to the craft. And my commission."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_4.ogg
    SAY: "I made half of that. The other half is you. Barely. Squint."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

died_1.ogg
    SAY: "You died in my wares? Did it stain? Please say it didn't stain."
    HOW: The player just died.  (NPC talk (died))

died_2.ogg
    SAY: "A dead client is a quiet client. A bloody client is a lawsuit."
    HOW: The player just died.  (NPC talk (died))

died_3.ogg
    SAY: "Do bleed on the old stock, please. Not the new silk. NOT the silk."
    HOW: The player just died.  (NPC talk (died))

died_4.ogg
    SAY: "Hold still. I'll repair the holes. Which ones are bullet holes and which are style? Don't tell me."
    HOW: The player just died.  (NPC talk (died))

boss_1.ogg
    SAY: "Defeated a boss? Marvelous! Armor, then. Fashionable armor. Is there another kind?"
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_2.ogg
    SAY: "Slaying monsters in silk. Delightful. Stains come out with lemon, wine, and prayer."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_3.ogg
    SAY: "The trophies will need a tasteful frame. And a priest."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_4.ogg
    SAY: "I made that boss a suit. He hated it. He's dead now, so it's a little better."
    HOW: The player just beat a boss.  (NPC talk (boss))

idle_1.ogg
    SAY: "Gloves for gripping. Boots for smashing. Scarves for gliding. Hats for nothing, I just like hats."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_2.ogg
    SAY: "The shoes make the man. The man makes the dash. The dash makes my rent."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_3.ogg
    SAY: "Stand straight. The cloth knows. The cloth is judging your spine."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_4.ogg
    SAY: "Everything I sell grants a talent. Mostly vanity. Sometimes a double jump."
    HOW: Idle chatter. Random.  (NPC talk (idle))

buy_1.ogg
    SAY: "A fine choice. I knew it'd suit you. I say that to everyone. It's never true."
    HOW: The player just bought something.  (NPC talk (buy))

buy_2.ogg
    SAY: "Wear it with confidence. Or at least shoes. Shoes are the minimum."
    HOW: The player just bought something.  (NPC talk (buy))

buy_3.ogg
    SAY: "I shall tell the thread you said hello. The thread has opinions."
    HOW: The player just bought something.  (NPC talk (buy))

buy_4.ogg
    SAY: "One moment. The pins are my pride. And my weapons."
    HOW: The player just bought something.  (NPC talk (buy))

