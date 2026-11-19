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
    SAY: "Welcome to the armory, recruit. Say hello to Betsy, the shotgun on the left. She never likes anyone, so I'm a little jealous."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_2.ogg
    SAY: "Stand up straight, recruit. You're in the presence of firepower, and I'm not talking about me. I'm talking about the lady on the wall. Stop staring, you're making her blush."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_3.ogg
    SAY: "You need firepower, recruit. I can smell it on you. I can also smell that you need a shower, but that's not in stock."
    HOW: Greeting the player. In character.  (NPC talk (greet))

greet_4.ogg
    SAY: "Welcome, gambler. Everything in here goes bang, and nothing goes whimper. Unlike your bankroll."
    HOW: Greeting the player. In character.  (NPC talk (greet))

farewell_1.ogg
    SAY: "Don't shoot your own foot, recruit. Shoot theirs. Betsy hates it when you mix those up."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_2.ogg
    SAY: "Dismissed. Try to die facing forward. Backward deaths mean paperwork, and Betsy cries over paperwork."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_3.ogg
    SAY: "Clean your guns, wash your hands, but never wash the lucky socks. They're load-bearing."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

farewell_4.ogg
    SAY: "Move out, rookie, and don't bet the ammo. I've named every bullet in that box, and I get attached."
    HOW: Parting words as the player leaves.  (NPC talk (farewell))

rich_1.ogg
    SAY: "Cash! The universal caliber! Listen, Betsy's purring. She hasn't purred since the divorce."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_2.ogg
    SAY: "A big spender. I salute your wallet. If I could marry it, I'd have to ask Betsy first, and she's protective."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_3.ogg
    SAY: "Now I'll show you the good stuff, recruit. Treat her right. She's like a daughter to me, in a way my lawyer has asked me to stop describing."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

rich_4.ogg
    SAY: "That's purchasing power. I'm throwing in a free clip and a long moment alone with the new shotgun. Don't watch."
    HOW: The player is carrying a lot of money.  (NPC talk (rich))

broke_1.ogg
    SAY: "No money, no bang. Oldest rule in the armory, and also the plot of your whole life."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_2.ogg
    SAY: "Broke? Throw rocks. Rocks have a perfect safety record, if you ignore that glacier incident."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_3.ogg
    SAY: "Hands off the shelves, recruit. Betsy doesn't like being touched by people who can't afford her."
    HOW: The player is nearly broke.  (NPC talk (broke))

broke_4.ogg
    SAY: "No cash? You can look. But Betsy sees you staring, and she says buy her or stop breathing on the glass."
    HOW: The player is nearly broke.  (NPC talk (broke))

ugly_1.ogg
    SAY: "Soldier, that outfit is a disciplinary action. I've seen less offensive things come out of a mortar."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_2.ogg
    SAY: "Camouflage? You look like a bruise wandering around. Betsy sighed when you walked in, and she never sighs."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_3.ogg
    SAY: "I've seen better uniforms on a scarecrow, recruit. The scarecrow had a better stance, a stronger sense of purpose, and honestly a nicer rifle."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

ugly_4.ogg
    SAY: "What happened to your pants, recruit? If the House took them, I'd like to report it. If you picked them, I'd like to report that too."
    HOW: The player is wearing ugly clothes.  (NPC talk (ugly))

sharp_1.ogg
    SAY: "Spit-shined, recruit. I'm almost proud. Don't tell Betsy. She thinks she's my favorite."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_2.ogg
    SAY: "That suit says lethal in four languages. Shame you only speak panic."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_3.ogg
    SAY: "A sharp dresser holds a gun better. Scientific fact. The guns agree. They find you attractive, which is honestly unsettling."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

sharp_4.ogg
    SAY: "You look like a general, recruit. So act like one: send others to die first and keep the good guns for yourself."
    HOW: The player is dressed sharp.  (NPC talk (sharp))

died_1.ogg
    SAY: "You're dead? Walk it off, recruit. And do it away from Betsy, she just had her stock polished."
    HOW: The player just died.  (NPC talk (died))

died_2.ogg
    SAY: "That's what armor is for, recruit. You forgot yours. Again. I keep handing you new ones like a patient father, and you keep feeding them to the floor."
    HOW: The player just died.  (NPC talk (died))

died_3.ogg
    SAY: "Retrain, rearm, resurrect, repeat. That's the whole military, and also your career."
    HOW: The player just died.  (NPC talk (died))

died_4.ogg
    SAY: "The only bad death is an unarmed death, recruit, and yours was a very unarmed one. Betsy would like a word."
    HOW: The player just died.  (NPC talk (died))

boss_1.ogg
    SAY: "Boss down! Medals for everyone except the boss, who gets a closed casket. Betsy gets a fresh coat of oil. She earned it."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_2.ogg
    SAY: "That boss was large, loud, and legally ambiguous. Exactly what my ex-wife called me, and I took it as a compliment."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_3.ogg
    SAY: "I sold that boss his first revolver. I regret nothing, except his trigger discipline. That one's on me."
    HOW: The player just beat a boss.  (NPC talk (boss))

boss_4.ogg
    SAY: "You beat a boss, recruit, and I got a little misty. Betsy saw. We're not discussing it."
    HOW: The player just beat a boss.  (NPC talk (boss))

idle_1.ogg
    SAY: "I'm naming the new shotgun and I need your opinion. Marjorie or Danielle? She's sensitive, so choose carefully."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_2.ogg
    SAY: "A revolver has six reasons, recruit. Use five. Save one for the barista. He knows what he did."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_3.ogg
    SAY: "The coin shotgun is my favorite. It's illegal in four countries and one Pizza Hut. I miss that Pizza Hut every day."
    HOW: Idle chatter. Random.  (NPC talk (idle))

idle_4.ogg
    SAY: "Guns don't kill people, recruit, bad odds do. And Gary. We don't talk about Gary, and neither does Betsy."
    HOW: Idle chatter. Random.  (NPC talk (idle))

buy_1.ogg
    SAY: "Excellent choice, recruit. Point it away from yourself, me, and Betsy. She's sensitive about being aimed at."
    HOW: The player just bought something.  (NPC talk (buy))

buy_2.ogg
    SAY: "Classic. Respect it. It's seen things, mostly foreheads."
    HOW: The player just bought something.  (NPC talk (buy))

buy_3.ogg
    SAY: "Eight out of ten customers survive their first purchase. You're a nine, which is mathematically impossible, and Betsy agrees."
    HOW: The player just bought something.  (NPC talk (buy))

buy_4.ogg
    SAY: "Be gentle with her, recruit. She kicks. If she makes a sound, that's just the love."
    HOW: The player just bought something.  (NPC talk (buy))

