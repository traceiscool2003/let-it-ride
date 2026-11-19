# HOW TO RECORD THE VOICES

You are the voice of EVERY character. This guide is for a total beginner. Short steps, no jargon.

Files you will use:
- `VOICE_CAST.md`: how each character should sound.
- `VOICE_SCRIPT.md`: every line to record.
- This file: step-by-step instructions, one recipe card per character, and a tick-box list.

---

## PART 1: Set up (10 minutes, once)

1. Go to https://www.audacityteam.org and download **Audacity**. It is free.
2. Install it. Open it.
3. Plug in your microphone (a headset mic or phone earbuds mic is fine).
4. In Audacity, look at the top bar. Pick your mic in the box that shows a microphone icon.
5. Set the channels box to **1 (Mono) Recording Channel**.
6. Click the big red **Record** button. Say "testing one two three". Click **Stop** (black square).
7. Click the **Play** button. If you can hear yourself clearly, you are ready.

Mic tips:
- Record in a quiet room. A closet full of clothes is a great free studio.
- Keep your mouth about a hand-width (10 cm) from the mic.
- Do not touch the mic while you talk. Turn off fans.
- If the green bar hits the right edge, you are too loud: move back.

## PART 2: Record one line (the loop)

Do this for every line.

1. Open `VOICE_SCRIPT.md` or the checklist below. Find the line.
2. Click **Record**. Count "one, two" in your head. Say the line with the acting direction.
3. Click **Stop**.
4. If it was bad, press **Ctrl+Z** and record again. Do not worry about perfect: the game is funny anyway.
5. Cut the silence: click and drag across the quiet part at the start, press **Delete**. Do the same at the end. Leave a tiny gap (a blink).
6. Click **File > Export > Export as OGG**.
7. In the export window: choose the folder `voice/<character>/` inside the game folder. Type the file name from the table, for example `greet_1`. Click **Save**. If it asks for metadata, click **OK**.
8. Click **File > New** and do the next line.

Export settings (if Audacity asks): **OGG Vorbis, quality 5, 44100 Hz, mono**.

TIP: record ten lines in a row in ONE long take with pauses, then **Analyze > Label Sounds**, then **File > Export > Export Multiple** to chop them. Only try this when the basic loop feels easy.

---

## PART 3: Making one person sound like many (super simple)

You have TWO ways. Pick one and stick with it.

### Way A (the easy way): record clean, let the game do the effect
1. Record every line in your normal voice, but ACT it (see the card: slow, gruff, fast, high...).
2. Do not use any effect in Audacity.
3. Drop the files in. The game gives every character a different pitch, EQ, grit and echo automatically (`scripts/voice_profiles.gd`).
4. In the game: **Settings > Audio > Voice Filters = On** (it is On by default).

This is the easier way because you never touch an effect and you can change a character's filter later without re-recording.

### Way B: bake the effect into the file with Audacity
1. Do the recording steps from Part 2.
2. Before you export, press **Ctrl+A** (select all).
3. Use the recipe card for the character (Part 5). Click the effect menus exactly as below:
   - **Effect > Pitch and Tempo > Change Pitch**: type the semitones in "Semitones (half-steps)". Click **Apply**.
   - **Effect > EQ and Filters > Bass and Treble**: set the Bass and Treble numbers (dB). **Apply**.
   - **Effect > Distortion and Modulation > Distortion**: set the percent from the card (use the "Hard Clipping" type). **Apply**.
   - **Effect > Delay and Reverb > Reverb**: set "Reverb" to the percent on the card, Room Size 40. **Apply**.
4. Export as OGG.
5. In the game: **Settings > Audio > Voice Filters = Off**, otherwise the effect is applied twice.

### Optional: hear the voice LIVE while you act
You can use a real-time voice changer so you hear the character while you perform. A good FREE one for Windows is **Clownfish Voice Changer** (https://clownfish-translator.com). It is free, needs no account and sits in the system tray: right-click it, choose **Set Voice Changer**, pick a voice (like Robot or Deep) and record in Audacity with the mic set to Clownfish's output. Its limit: it has only about a dozen basic presets. **Voicemod** (https://www.voicemod.net) also has a free tier, but its free version only offers a rotating selection of voices and locks the rest to Pro, so check what is free that day. You do NOT need either tool: the game's filters do the same job.

---

## PART 4: Test it in the game

1. Put the file in the right folder, for example `voice/vera/greet_1.ogg`.
2. Open the project in **Godot** (the editor). Wait for it to import the new files (a bar at the bottom).
3. Press **F5** to run the game.
4. Press **F3** at any time to open the **Voice Test** menu. Left/Right picks a character, Up/Down picks a line, **Enter** plays it. A `[x]` means the game found your file. `[ ]` means not found (check the name and folder).
5. To hear a line in a real scene: talk to the character in the Lobby, or start a run and reach the place named in the "where" column.
6. If you do not hear your file: check the spelling, check that it is `.ogg`, and press Enter again in the test menu.

---

## PART 5: Recipe cards (one per character)

Each card: the Audacity settings to bake in (Way B), and an acting tip. If you use Way A, ignore the numbers and just read the tip.

**RICO** (`voice/rico/`)
- Audacity: Pitch: leave it alone, Treble +1 dB, Mid +2 dB
- Acting tip: Grin the whole time. Every line is a bet you already placed.
- Sound like: a charming pool-hall hustler who has never once been told no

**MARLOW** (`voice/marlow/`)
- Audacity: Change Pitch -2 semitones, Bass -3 dB, Treble -6 dB, Mid +4 dB, Distortion 35%
- Acting tip: Hold the phone away and sigh before the line.
- Sound like: an old detective on his third coffee

**VERA** (`voice/vera/`)
- Audacity: Change Pitch +2 semitones, Bass +2 dB, Treble -2 dB, Reverb 18% (Room Size 40)
- Acting tip: Whisper-purr. Never rush. You've seen every hand.
- Sound like: a jazz-club singer after midnight

**MAGS** (`voice/mags/`)
- Audacity: Change Pitch -4 semitones, Bass +5 dB, Treble -3 dB, Mid -2 dB, Distortion 10%, Reverb 10% (Room Size 40)
- Acting tip: Sweet as pie, then drop the floor out of your voice.
- Sound like: a friendly grandmother who breaks legs

**LUCKY** (`voice/lucky/`)
- Audacity: Change Pitch +1 semitones, Bass +1 dB, Mid +1 dB, Reverb 12% (Room Size 40)
- Acting tip: Pretend you are polishing a glass the entire time.
- Sound like: the bartender who remembers your order

**JULES** (`voice/jules/`)
- Audacity: Change Pitch +0 semitones, Bass -2 dB, Treble -1 dB, Mid +2 dB, Reverb 30% (Room Size 40)
- Acting tip: Whisper like you have not slept since Tuesday.
- Sound like: a college dropout after three days awake

**COMP** (`voice/comp/`)
- Audacity: Change Pitch +7 semitones, Bass -4 dB, Treble +3 dB, Mid +2 dB
- Acting tip: Meow in different moods. Smug, hungry, offended.
- Sound like: a very judgmental cat

**SILAS STITCH** (`voice/tailor/`)
- Audacity: Change Pitch +1 semitones, Bass -2 dB, Treble +1 dB, Mid +2 dB, Reverb 10% (Room Size 40)
- Acting tip: Sniff at the player's outfit before each line.
- Sound like: a Savile Row tailor with pins in his mouth

**DOC FIZZ** (`voice/fizz/`)
- Audacity: Change Pitch +2 semitones, Bass -3 dB, Treble +3 dB, Mid +3 dB, Distortion 10%, Reverb 15% (Room Size 40), Chorus / Phaser 30%
- Acting tip: Whisper-yell. Look over your shoulder after each sentence.
- Sound like: a back-alley pharmacist who sniffs the product

**GUNNY** (`voice/gunny/`)
- Audacity: Change Pitch -4 semitones, Bass +3 dB, Treble -1 dB, Mid +2 dB, Distortion 15%
- Acting tip: Everything is an order. Everything is a compliment.
- Sound like: a retired sergeant selling surplus

**VELMA VELVET** (`voice/velma/`)
- Audacity: Change Pitch +1 semitones, Bass +2 dB, Treble -1 dB, Reverb 40% (Room Size 40), Chorus / Phaser 20%
- Acting tip: You are singing the last song of the night.
- Sound like: a lounge singer at last call

**DUMPSTER DAN** (`voice/dumpster_dan/`)
- Audacity: Change Pitch -2 semitones, Bass -2 dB, Treble -3 dB, Mid +3 dB, Distortion 25%, Reverb 15% (Room Size 40)
- Acting tip: Laugh at your own points, then cough.
- Sound like: a bum who used to be a professor

**SLICK NICK** (`voice/slick_nick/`)
- Audacity: Change Pitch +1 semitones, Bass -1 dB, Treble +3 dB, Mid +2 dB, Reverb 10% (Room Size 40)
- Acting tip: Wink with your voice.
- Sound like: a guy who says 'bro' to waiters

**LADY LUCK LORRAINE** (`voice/lorraine/`)
- Audacity: Change Pitch +3 semitones, Bass -2 dB, Treble +2 dB, Mid +2 dB, Reverb 10% (Room Size 40), Chorus / Phaser 10%
- Acting tip: Everything is a sign. Everything is bad luck.
- Sound like: a church-lady with a bingo problem

**OFFICER DUNN** (`voice/dunn/`)
- Audacity: Change Pitch -3 semitones, Treble -4 dB, Mid +4 dB, Distortion 45%
- Acting tip: Say everything like reading the same warning for the 800th time.
- Sound like: a mall cop at the end of his shift

**THE HOUSE** (`voice/the_house/`)
- Audacity: Change Pitch -6 semitones, Bass +4 dB, Treble -2 dB, Mid -3 dB, Distortion 8%, Reverb 55% (Room Size 40), Chorus / Phaser 25%
- Acting tip: Say it like you are reading terms and conditions to a prisoner.
- Sound like: an elevator voice that owns the building

**DRAFTQUEENS** (`voice/draftqueens/`)
- Audacity: Change Pitch +3 semitones, Bass -2 dB, Treble +3 dB, Mid +3 dB, Reverb 20% (Room Size 40), Chorus / Phaser 15%
- Acting tip: Every line ends with a finger snap you cannot hear.
- Sound like: a talk-show host at a roast

**FANDOOL** (`voice/fandool/`)
- Audacity: Change Pitch -1 semitones, Bass +2 dB, Mid +3 dB, Distortion 20%, Reverb 10% (Room Size 40)
- Acting tip: Yell every third word like a replay is on.
- Sound like: a guy yelling at a TV in a bar

**POKERSTARZ** (`voice/pokerstarz/`)
- Audacity: Change Pitch +2 semitones, Bass -3 dB, Treble +2 dB, Mid +1 dB, Reverb 10% (Room Size 40), Chorus / Phaser 10%
- Acting tip: End statements like questions. Sigh a lot.
- Sound like: a streamer with a ring light

**BETMGN** (`voice/betmgn/`)
- Audacity: Change Pitch -2 semitones, Bass +3 dB, Treble +1 dB, Mid +2 dB, Distortion 5%, Reverb 25% (Room Size 40)
- Acting tip: Talk like every sentence has a trademark symbol.
- Sound like: a game-show host selling a timeshare

**STEAKE.COM** (`voice/steake/`)
- Audacity: Change Pitch +1 semitones, Treble +2 dB, Mid +3 dB, Distortion 10%
- Acting tip: Say 'to the moon' with your whole chest, even when it makes no sense.
- Sound like: someone pitching a coin that is definitely not a scam

**BOVADOH** (`voice/bovadoh/`)
- Audacity: Change Pitch -3 semitones, Bass +2 dB, Treble -2 dB, Reverb 15% (Room Size 40)
- Acting tip: Be bored. Boredom is scarier than shouting.
- Sound like: a poker pro who has seen it all

**SEEZER'S CLUB** (`voice/seezers/`)
- Audacity: Change Pitch -3 semitones, Bass +3 dB, Treble -1 dB, Mid +1 dB, Reverb 40% (Room Size 40), Chorus / Phaser 10%
- Acting tip: Say everything like a toga is flowing behind you.
- Sound like: an emperor reading a decree from a balcony

**WYNNER'S CIRCLE** (`voice/wynners/`)
- Audacity: Pitch: leave it alone, Bass -1 dB, Treble +1 dB, Mid +2 dB, Reverb 35% (Room Size 40), Chorus / Phaser 10%
- Acting tip: Sniff once per sentence like the room smells poor.
- Sound like: a count at a cocktail party

**SNAKE EYES SAL** (`voice/snake_eyes/`)
- Audacity: Change Pitch -3 semitones, Treble +2 dB, Mid +4 dB, Distortion 15%, Reverb 15% (Room Size 40)
- Acting tip: Hiss and click your tongue between lines.
- Sound like: a snake who also runs numbers

**ONE-ARMED BANDIT** (`voice/rusty_slots/`)
- Audacity: Change Pitch +1 semitones, Bass -4 dB, Treble +3 dB, Mid +5 dB, Distortion 50%, Reverb 10% (Room Size 40), Chorus / Phaser 50%
- Acting tip: Cheerful voice, dead eyes, glitches in the middle of words.
- Sound like: a malfunctioning arcade cabinet

**MR. LUCKY** (`voice/mr_lucky/`)
- Audacity: Change Pitch +1 semitones, Treble +1 dB, Mid +1 dB, Reverb 25% (Room Size 40), Chorus / Phaser 20%
- Acting tip: Everything you say starts nice and turns evil on the last word.
- Sound like: a children's TV host who knows too much

**TOURIST** (`voice/tourist/`)
- Audacity: Pitch: leave it alone, Mid +1 dB, Reverb 20% (Room Size 40)
- Acting tip: Everything you say is a question. All of them too loud.
- Sound like: a dad in a Hawaiian shirt

**JUNKIE** (`voice/junkie/`)
- Audacity: Change Pitch -1 semitones, Bass -2 dB, Treble -2 dB, Mid +3 dB, Distortion 20%, Reverb 10% (Room Size 40), Chorus / Phaser 10%
- Acting tip: Run out of breath at the end of every sentence.
- Sound like: someone who has not slept in four days

**PIT BOSS** (`voice/pitboss/`)
- Audacity: Change Pitch -2 semitones, Bass +1 dB, Treble -1 dB, Mid +2 dB
- Acting tip: Say it like you've said it 10,000 times.
- Sound like: a floor manager with a headset

**DRUNK** (`voice/drunk/`)
- Audacity: Change Pitch -1 semitones, Bass +2 dB, Treble -3 dB, Reverb 20% (Room Size 40), Chorus / Phaser 35%
- Acting tip: Hiccup mid-word. Cry a little.
- Sound like: your uncle at a wedding

**BOUNCER** (`voice/bouncer/`)
- Audacity: Change Pitch -6 semitones, Bass +5 dB, Treble -3 dB, Distortion 5%
- Acting tip: As low as you can go. Say as few words as possible.
- Sound like: a huge man guarding a velvet rope

**HUSTLER** (`voice/hustler/`)
- Audacity: Change Pitch +1 semitones, Bass -1 dB, Treble +1 dB, Mid +2 dB, Reverb 10% (Room Size 40)
- Acting tip: Everything is an offer. Everything is urgent.
- Sound like: a guy selling DVDs on a corner

---

## PART 6: Recording checklist (go down the list)

Record one character's whole list in one sitting: same voice, same energy. Tick the box when the file is exported. The filename is the Line ID plus `.ogg`.

### RICO: 89 lines

Folder: `voice/rico/` (cutscene lines go in the folder shown). Voice: Grin the whole time. Every line is a bet you already placed..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `rico/greet_1.ogg` | Let's see what the House has left. | Greeting the player. In character. |
| 2 | [ ] | `rico/greet_2.ogg` | Aces up. Brains down. Perfect. | Greeting the player. In character. |
| 3 | [ ] | `rico/greet_3.ogg` | Another day, another dollar I don't have. | Greeting the player. In character. |
| 4 | [ ] | `rico/greet_4.ogg` | Let it ride, baby! | Greeting the player. In character. |
| 5 | [ ] | `rico/farewell_1.ogg` | Wish me luck. Not that I need it. | Parting words as the player leaves. |
| 6 | [ ] | `rico/farewell_2.ogg` | See you at the top. Or the bottom. | Parting words as the player leaves. |
| 7 | [ ] | `rico/farewell_3.ogg` | I'll be rich by dinner. Or dead. | Parting words as the player leaves. |
| 8 | [ ] | `rico/farewell_4.ogg` | Let it ride! | Parting words as the player leaves. |
| 9 | [ ] | `rico/rich_1.ogg` | I'm RICH! Wait. Let me count again. I'm RICH! | The player is carrying a lot of money. |
| 10 | [ ] | `rico/rich_2.ogg` | Look at all this! I'll bet it. All of it. | The player is carrying a lot of money. |
| 11 | [ ] | `rico/rich_3.ogg` | Money? That's just ammunition. | The player is carrying a lot of money. |
| 12 | [ ] | `rico/rich_4.ogg` | Pot's fat. Time to make it fatter. | The player is carrying a lot of money. |
| 13 | [ ] | `rico/broke_1.ogg` | Broke? That's just a free roll. | The player is nearly broke. |
| 14 | [ ] | `rico/broke_2.ogg` | Zero dollars. Infinite possibilities. | The player is nearly broke. |
| 15 | [ ] | `rico/broke_3.ogg` | I've been broker. I'm fine. I'm fine. | The player is nearly broke. |
| 16 | [ ] | `rico/broke_4.ogg` | Rock bottom's got a nice view. | The player is nearly broke. |
| 17 | [ ] | `rico/ugly_1.ogg` | I look like a dumpster fire and I LOVE it. | The player is wearing ugly clothes. |
| 18 | [ ] | `rico/ugly_2.ogg` | Is this fanny pack lucky? It's lucky. | The player is wearing ugly clothes. |
| 19 | [ ] | `rico/ugly_3.ogg` | Style is for people with odds. | The player is wearing ugly clothes. |
| 20 | [ ] | `rico/ugly_4.ogg` | Somebody call a stylist. Or a priest. | The player is wearing ugly clothes. |
| 21 | [ ] | `rico/sharp_1.ogg` | I look incredible. The House should be scared. | The player is dressed sharp. |
| 22 | [ ] | `rico/sharp_2.ogg` | Dressed to kill. Or at least to lose in style. | The player is dressed sharp. |
| 23 | [ ] | `rico/sharp_3.ogg` | Hey, I clean up nice. | The player is dressed sharp. |
| 24 | [ ] | `rico/sharp_4.ogg` | Would you bet on me? I would. | The player is dressed sharp. |
| 25 | [ ] | `rico/died_1.ogg` | Okay. That one was on me. | The player just died. |
| 26 | [ ] | `rico/died_2.ogg` | Death? Barely noticed. | The player just died. |
| 27 | [ ] | `rico/died_3.ogg` | I'll do it differently next time. Or exactly the same. | The player just died. |
| 28 | [ ] | `rico/died_4.ogg` | I regret nothing. Except that. | The player just died. |
| 29 | [ ] | `rico/boss_1.ogg` | Read 'em and weep, pal! | The player just beat a boss. |
| 30 | [ ] | `rico/boss_2.ogg` | Another table down. Another reason to gamble! | The player just beat a boss. |
| 31 | [ ] | `rico/boss_3.ogg` | I called the bluff. And the bluff folded. | The player just beat a boss. |
| 32 | [ ] | `rico/boss_4.ogg` | Who's next? | The player just beat a boss. |
| 33 | [ ] | `rico/idle_1.ogg` | Odds are for people who don't have a gun. | Idle chatter. Random. |
| 34 | [ ] | `rico/idle_2.ogg` | I once bet my shoes. Won. Lost the shoes. Same thing. | Idle chatter. Random. |
| 35 | [ ] | `rico/idle_3.ogg` | Risk is just fun with consequences. | Idle chatter. Random. |
| 36 | [ ] | `rico/idle_4.ogg` | I think I left the stove on. Ha, I don't have a stove. | Idle chatter. Random. |
| 37 | [ ] | `rico/buy_1.ogg` | Take my money. Take all of it! | The player just bought something. |
| 38 | [ ] | `rico/buy_2.ogg` | Sold! Wait, what was the price? | The player just bought something. |
| 39 | [ ] | `rico/buy_3.ogg` | Worth it. Probably. | The player just bought something. |
| 40 | [ ] | `rico/buy_4.ogg` | That's a terrible deal. I'm in. | The player just bought something. |
| 41 | [ ] | `rico/boss_intro_draftqueens.ogg` | Five Card Draw? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 42 | [ ] | `rico/boss_defeat_draftqueens.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 43 | [ ] | `rico/boss_intro_fandool.ogg` | Seven Card Stud? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 44 | [ ] | `rico/boss_defeat_fandool.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 45 | [ ] | `rico/boss_intro_pokerstarz.ogg` | Omaha? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 46 | [ ] | `rico/boss_defeat_pokerstarz.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 47 | [ ] | `rico/boss_intro_betmgn.ogg` | Three Card Poker? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 48 | [ ] | `rico/boss_defeat_betmgn.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 49 | [ ] | `rico/boss_intro_steake.ogg` | Razz? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 50 | [ ] | `rico/boss_defeat_steake.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 51 | [ ] | `rico/boss_intro_bovadoh.ogg` | Pai Gow? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 52 | [ ] | `rico/boss_defeat_bovadoh.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 53 | [ ] | `rico/boss_intro_seezers.ogg` | Blackjack? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 54 | [ ] | `rico/boss_defeat_seezers.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 55 | [ ] | `rico/boss_intro_wynners.ogg` | Baccarat? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 56 | [ ] | `rico/boss_defeat_wynners.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 57 | [ ] | `rico/boss_intro_snake_eyes.ogg` | Craps? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 58 | [ ] | `rico/boss_defeat_snake_eyes.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 59 | [ ] | `rico/boss_intro_rusty_slots.ogg` | Slots? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 60 | [ ] | `rico/boss_defeat_rusty_slots.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 61 | [ ] | `rico/boss_intro_mr_lucky.ogg` | Keno? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 62 | [ ] | `rico/boss_defeat_mr_lucky.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 63 | [ ] | `rico/boss_intro_the_house.ogg` | Texas Hold'em? I've lost bigger pots to dumber tables. Deal me in. | Hero cockily answers the boss. |
| 64 | [ ] | `rico/boss_defeat_the_house.ogg` | Read 'em and weep, pal. | Hero victory line. Smug. |
| 65 | [ ] | `_cutscenes/city1_arrive/city1_arrive_1.ogg` | Atlantic Shitty. Salt, rust and slot machines. I love it already. | Cutscene: city1 arrive |
| 66 | [ ] | `_cutscenes/city1_arrive/city1_arrive_3.ogg` | Everything's wet, Marlow. That's the whole city. | Cutscene: city1 arrive |
| 67 | [ ] | `_cutscenes/city2_arrive/city2_arrive_1.ogg` | Reno. The biggest little city. And that's a clown. | Cutscene: city2 arrive |
| 68 | [ ] | `_cutscenes/city3_arrive/city3_arrive_1.ogg` | Biloxi. Sharks in the lobby. Guitars on the wall. This is my kind of mistake. | Cutscene: city3 arrive |
| 69 | [ ] | `_cutscenes/city3_arrive/city3_arrive_3.ogg` | Quiet's not really my instrument. | Cutscene: city3 arrive |
| 70 | [ ] | `_cutscenes/city4_arrive/city4_arrive_1.ogg` | Fremont, Old Vegas. Neon older than my debt. | Cutscene: city4 arrive |
| 71 | [ ] | `_cutscenes/city5_arrive/city5_arrive_1.ogg` | The Strip. The nicest casino in the world. And I'm covered in alley. | Cutscene: city5 arrive |
| 72 | [ ] | `_cutscenes/secret_found/secret_found_1.ogg` | A hidden room? A secret table? The House is hiding something. | Cutscene: secret found |
| 73 | [ ] | `_cutscenes/secret_defeat/secret_defeat_1.ogg` | Another secret down. Another stack of chips. | Cutscene: secret defeat |
| 74 | [ ] | `_cutscenes/secret_defeat/secret_defeat_3.ogg` | Good. | Cutscene: secret defeat |
| 75 | [ ] | `_cutscenes/final_prelude/final_prelude_2.ogg` | And I still got a bet on you. | Cutscene: final prelude |
| 76 | [ ] | `_cutscenes/intro/intro_1.ogg` | Five cities. Twenty-five floors. One long climb from a dumpster to the nicest casino in Vegas. I've bet on worse. | Cutscene: intro |
| 77 | [ ] | `_cutscenes/intro/intro_2.ogg` | My brother Jules sat down at the House's table three years ago. He never got up. Somebody has to cash him out. Might as well be the guy with no impulse control. | Cutscene: intro |
| 78 | [ ] | `_cutscenes/intro/intro_5.ogg` | So I can't die. I just owe you forever. Honestly? Best terms I've ever been offered. | Cutscene: intro |
| 79 | [ ] | `_cutscenes/mags_chase/mags_chase_2.ogg` | ...Can we talk about this? | Cutscene: mags chase |
| 80 | [ ] | `_cutscenes/ending/ending_1.ogg` | The vault door groans open. Behind it, a man shuffling cards in the dark. | Cutscene: ending |
| 81 | [ ] | `_cutscenes/ending/ending_3.ogg` | Somebody had to cash you out. Come on. We're going home. | Cutscene: ending |
| 82 | [ ] | `_cutscenes/ending/ending_5.ogg` | ...Let it ride. | Cutscene: ending |
| 83 | [ ] | `_cutscenes/true_ending/true_ending_2.ogg` | No. I read your tickets, Eddie. All twenty of them. | Cutscene: true ending |
| 84 | [ ] | `_cutscenes/true_ending/true_ending_4.ogg` | You never learned to walk away. So I'm teaching you. Cash out, Eddie. Take the win. | Cutscene: true ending |
| 85 | [ ] | `_cutscenes/true_ending/true_ending_9.ogg` | The floors are still down there, though. | Cutscene: true ending |
| 86 | [ ] | `rico/marlow_intro_3.ogg` | So I can't die. Great. What's the catch? | Conversation: marlow_intro |
| 87 | [ ] | `rico/marlow_confess_3.ogg` | ...You sent my brother down there. | Conversation: marlow_confess |
| 88 | [ ] | `rico/vera_intro_3.ogg` | And up here? | Conversation: vera_intro |
| 89 | [ ] | `rico/mags_intro_4.ogg` | You're a shark. In a suit. | Conversation: mags_intro |

### MARLOW: 87 lines

Folder: `voice/marlow/` (cutscene lines go in the folder shown). Voice: Hold the phone away and sigh before the line..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `marlow/greet_1.ogg` | Rico. You picked up. Good. | Greeting the player. In character. |
| 2 | [ ] | `marlow/greet_2.ogg` | Marlow here. Talk fast, the line's got ears. | Greeting the player. In character. |
| 3 | [ ] | `marlow/greet_3.ogg` | Back already? I was just worrying. | Greeting the player. In character. |
| 4 | [ ] | `marlow/greet_4.ogg` | Hey. You alive? Say something stupid. | Greeting the player. In character. |
| 5 | [ ] | `marlow/farewell_1.ogg` | Stay alive. Stay lucky. Stay on the line. | Parting words as the player leaves. |
| 6 | [ ] | `marlow/farewell_2.ogg` | Call if you need me. Call if you don't. | Parting words as the player leaves. |
| 7 | [ ] | `marlow/farewell_3.ogg` | Don't do anything I'd worry about. Too late. | Parting words as the player leaves. |
| 8 | [ ] | `marlow/farewell_4.ogg` | Let it ride, kid. | Parting words as the player leaves. |
| 9 | [ ] | `marlow/rich_1.ogg` | Look at that pot. Resist the urge. Resist it. | The player is carrying a lot of money. |
| 10 | [ ] | `marlow/rich_2.ogg` | You're rich. Don't tell the House. | The player is carrying a lot of money. |
| 11 | [ ] | `marlow/rich_3.ogg` | Bank it, Rico. Please. Bank it. | The player is carrying a lot of money. |
| 12 | [ ] | `marlow/rich_4.ogg` | I've seen guys lose that in one hand. Be smarter. | The player is carrying a lot of money. |
| 13 | [ ] | `marlow/broke_1.ogg` | Broke again? That's the third time today. | The player is nearly broke. |
| 14 | [ ] | `marlow/broke_2.ogg` | Hey. It's money. It comes back. Mostly. | The player is nearly broke. |
| 15 | [ ] | `marlow/broke_3.ogg` | I'll cover dinner. Just don't tell your brother. | The player is nearly broke. |
| 16 | [ ] | `marlow/broke_4.ogg` | You're not broke. You're liquid. In a sad way. | The player is nearly broke. |
| 17 | [ ] | `marlow/ugly_1.ogg` | What are you wearing? I can hear it. | The player is wearing ugly clothes. |
| 18 | [ ] | `marlow/ugly_2.ogg` | Is that a fanny pack? On the phone? I can SEE it. | The player is wearing ugly clothes. |
| 19 | [ ] | `marlow/ugly_3.ogg` | Look, style isn't everything. It's most things. | The player is wearing ugly clothes. |
| 20 | [ ] | `marlow/ugly_4.ogg` | Please. Go see Silas. For my sake. | The player is wearing ugly clothes. |
| 21 | [ ] | `marlow/sharp_1.ogg` | Hey, nice suit. I can hear the starch. | The player is dressed sharp. |
| 22 | [ ] | `marlow/sharp_2.ogg` | You look like a man with a plan. Do you have a plan? | The player is dressed sharp. |
| 23 | [ ] | `marlow/sharp_3.ogg` | Dressed to kill. Try not to be killed. | The player is dressed sharp. |
| 24 | [ ] | `marlow/sharp_4.ogg` | Nice threads. Don't get blood on 'em. | The player is dressed sharp. |
| 25 | [ ] | `marlow/died_1.ogg` | Rico. Again? We have to stop meeting like this. | The player just died. |
| 26 | [ ] | `marlow/died_2.ogg` | I heard the thud. It was a loud one. | The player just died. |
| 27 | [ ] | `marlow/died_3.ogg` | You died. I'll light a candle. A small one. | The player just died. |
| 28 | [ ] | `marlow/died_4.ogg` | Every death is a lesson. Expensive. | The player just died. |
| 29 | [ ] | `marlow/boss_1.ogg` | A boss! I'm updating my bet. | The player just beat a boss. |
| 30 | [ ] | `marlow/boss_2.ogg` | That's one more down. How many left? | The player just beat a boss. |
| 31 | [ ] | `marlow/boss_3.ogg` | You did it. Don't let it go to your head. | The player just beat a boss. |
| 32 | [ ] | `marlow/boss_4.ogg` | I'm proud. I hate that. | The player just beat a boss. |
| 33 | [ ] | `marlow/idle_1.ogg` | The Pit's a loop. Learn the pattern. | Idle chatter. Random. |
| 34 | [ ] | `marlow/idle_2.ogg` | Secrets everywhere. Walls that break. Doors that don't exist. | Idle chatter. Random. |
| 35 | [ ] | `marlow/idle_3.ogg` | Follow the light. It leads somewhere. | Idle chatter. Random. |
| 36 | [ ] | `marlow/idle_4.ogg` | Every floor has a story. Some bleed. | Idle chatter. Random. |
| 37 | [ ] | `marlow/buy_1.ogg` | Good call. Not great. Good. | The player just bought something. |
| 38 | [ ] | `marlow/buy_2.ogg` | I hope you read the fine print. | The player just bought something. |
| 39 | [ ] | `marlow/buy_3.ogg` | I wouldn't. But I'm not you. | The player just bought something. |
| 40 | [ ] | `marlow/buy_4.ogg` | That's the one Jules would've bought. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city1_arrive/city1_arrive_2.ogg` | Rico, you're in an alley. The casino's a block up. Start walking, and don't touch anything wet. | Cutscene: city1 arrive |
| 42 | [ ] | `_cutscenes/city2_arrive/city2_arrive_2.ogg` | That's the doorman. Smile. Don't get close. | Cutscene: city2 arrive |
| 43 | [ ] | `_cutscenes/city3_arrive/city3_arrive_2.ogg` | Hard Rok keeps the heavies near the stage. Stay quiet. | Cutscene: city3 arrive |
| 44 | [ ] | `_cutscenes/city4_arrive/city4_arrive_2.ogg` | Goldun Nugget's got a vault down below. Everyone wants in. Nobody gets out. | Cutscene: city4 arrive |
| 45 | [ ] | `_cutscenes/secret_found/secret_found_2.ogg` | That's not on the map, Rico. Be careful in there. | Cutscene: secret found |
| 46 | [ ] | `_cutscenes/secret_defeat/secret_defeat_2.ogg` | You're not supposed to know about those rooms. The House won't like it. | Cutscene: secret defeat |
| 47 | [ ] | `_cutscenes/intro/intro_7.ogg` | Radio check, Rico. Every chip you grab rides in your Pot. At each door you bank it, or let it ride for double. You'll let it ride. You always let it ride. | Cutscene: intro |
| 48 | [ ] | `_cutscenes/intro/intro_8.ogg` | Talk to the folks up here between runs. Wear something. Anything. When you're ready, take the DESCEND door. And Rico: please don't bet the shoes. | Cutscene: intro |
| 49 | [ ] | `_cutscenes/ending/ending_4.ogg` | Rico... the floor's still going down. There's more Pit below The Pit. | Cutscene: ending |
| 50 | [ ] | `_cutscenes/true_ending/true_ending_8.ogg` | Rico, the lights just went warm up here. Every Marker in the Lobby burned up at once. Everyone's free. | Cutscene: true ending |
| 51 | [ ] | `_cutscenes/true_ending/true_ending_10.ogg` | Course they are. It's still a casino. Now it's ours. Let it ride, kid. | Cutscene: true ending |
| 52 | [ ] | `marlow/radio_1.ogg` | Same deal as always, Rico. Grab, run, don't get cute. | Radio/lobby: radio |
| 53 | [ ] | `marlow/radio_2.ogg` | Word is Sal's been doubling security. Parry the big lugs when they wind up. | Radio/lobby: radio |
| 54 | [ ] | `marlow/radio_3.ogg` | You know what they say: the House always wins. So stop being the House's guest. | Radio/lobby: radio |
| 55 | [ ] | `marlow/radio_4.ogg` | Slot machines on every floor. Bet the Pot if you're feeling lucky. I wouldn't. | Radio/lobby: radio |
| 56 | [ ] | `marlow/radio_5.ogg` | Smash the glass, smash the crates. Insurance won't cover it, but you will. | Radio/lobby: radio |
| 57 | [ ] | `marlow/radio_6.ogg` | Jules left a trail of IOUs down there. Follow the money and you'll find him. | Radio/lobby: radio |
| 58 | [ ] | `marlow/radio_7.ogg` | Back again? The Fence has new toys if you've banked enough. | Radio/lobby: radio |
| 59 | [ ] | `marlow/first_exit_1.ogg` | First door. Cash out and that money is yours forever, and The Fence will take it. | Radio/lobby: first exit |
| 60 | [ ] | `marlow/first_exit_2.ogg` | Or let it ride: double the multiplier, but the House adds a rule. Your call, high roller. | Radio/lobby: first exit |
| 61 | [ ] | `marlow/marlow_intro_1.ogg` | Rico! You picked up. So the rumors are true: the House doesn't let debtors die down there. | Conversation: marlow_intro |
| 62 | [ ] | `marlow/marlow_intro_2.ogg` | You bust, it drags you back up to the Lobby and adds interest to your Marker. Every run is a do-over. | Conversation: marlow_intro |
| 63 | [ ] | `marlow/marlow_intro_4.ogg` | The catch is you never stop owing. Learn the floors, find Jules, and get out before the interest eats you. | Conversation: marlow_intro |
| 64 | [ ] | `marlow/marlow_spikes_1.ogg` | Spikes again? They don't move, Rico. That's kind of their whole thing. | Conversation: marlow_spikes |
| 65 | [ ] | `marlow/marlow_guard_1.ogg` | Those bouncers telegraph every punch. Parry right before it lands and they'll be eating carpet. | Conversation: marlow_guard |
| 66 | [ ] | `marlow/marlow_bat_1.ogg` | Bats. You lost to bats. I'm leaving that out of the report. | Conversation: marlow_bat |
| 67 | [ ] | `marlow/marlow_sal_1.ogg` | Sal fights like he talks: big and slow. Wait for the charge, sidestep, then punish. | Conversation: marlow_sal |
| 68 | [ ] | `marlow/marlow_sal_2.ogg` | Parry the charge itself and he's stunned wide open. Double damage. | Conversation: marlow_sal |
| 69 | [ ] | `marlow/marlow_roulette_1.ogg` | Madame Roulette's balls bounce. Hit them back at her. She hates that more than losing. | Conversation: marlow_roulette |
| 70 | [ ] | `marlow/marlow_house_1.ogg` | You made it all the way to the House. That's further than Jules ever got. | Conversation: marlow_house |
| 71 | [ ] | `marlow/marlow_house_2.ogg` | Don't you dare quit now. | Conversation: marlow_house |
| 72 | [ ] | `marlow/marlow_mags_1.ogg` | Mags got you? You borrowed from a SHARK, Rico. In a SUIT. There were signs. | Conversation: marlow_mags |
| 73 | [ ] | `marlow/marlow_greedy_1.ogg` | You were riding at times eight when you went down. Times eight. | Conversation: marlow_greedy |
| 74 | [ ] | `marlow/marlow_greedy_2.ogg` | Breathe. Bank once in a while. Jules never did, and look where he ended up. | Conversation: marlow_greedy |
| 75 | [ ] | `marlow/marlow_careful_1.ogg` | Three cash-outs last run. Careful money. Jules never knew when to walk away. Glad one of you does. | Conversation: marlow_careful |
| 76 | [ ] | `marlow/marlow_confess_1.ogg` | There's something I should've told you before you went in. | Conversation: marlow_confess |
| 77 | [ ] | `marlow/marlow_confess_2.ogg` | I used to deal for the House. I'm the one who got Jules a seat at its table. I thought he'd win. He always won. | Conversation: marlow_confess |
| 78 | [ ] | `marlow/marlow_confess_4.ogg` | And I'm talking you back out of it, one floor at a time. That's the only apology I've got that's worth anything. | Conversation: marlow_confess |
| 79 | [ ] | `marlow/marlow_vault_1.ogg` | You cracked a Vault Door! They only open if you get there fast. Speed pays down there. Remember that. | Conversation: marlow_vault |
| 80 | [ ] | `marlow/marlow_daily_1.ogg` | Daily Deal, huh? Same floors for everyone today. Show the rest of the Pit how it's done. | Conversation: marlow_daily |
| 81 | [ ] | `marlow/marlow_ending_1.ogg` | Jules is out and the floors keep going down. And you're still picking up this phone. | Conversation: marlow_ending |
| 82 | [ ] | `marlow/marlow_ending_2.ogg` | ...Yeah. I'd go back too. Let it ride, kid. | Conversation: marlow_ending |
| 83 | [ ] | `marlow/marlow_true_1.ogg` | The House is quiet. First time in twenty years. You did that. | Conversation: marlow_true |
| 84 | [ ] | `marlow/marlow_true_2.ogg` | Eddie Duval finally cashed out. I owe you a drink. I owe you about a thousand drinks. | Conversation: marlow_true |
| 85 | [ ] | `marlow/marlow_rep1_1.ogg` | Chain your moves. The House pays out to style. | Conversation: marlow_rep1 |
| 86 | [ ] | `marlow/marlow_rep2_1.ogg` | Static on the line... that's the House listening. Hi, House. | Conversation: marlow_rep2 |
| 87 | [ ] | `marlow/marlow_rep3_1.ogg` | Smash the glass, grab the chips, bank before you get cute. | Conversation: marlow_rep3 |

### VERA: 65 lines

Folder: `voice/vera/` (cutscene lines go in the folder shown). Voice: Whisper-purr. Never rush. You've seen every hand..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `vera/greet_1.ogg` | Well, look who crawled back to my table. | Greeting the player. In character. |
| 2 | [ ] | `vera/greet_2.ogg` | Sit down, sugar. The cards are warm. | Greeting the player. In character. |
| 3 | [ ] | `vera/greet_3.ogg` | Back for more charms? Of course you are. | Greeting the player. In character. |
| 4 | [ ] | `vera/greet_4.ogg` | I was just thinking about you. Mostly your wallet. | Greeting the player. In character. |
| 5 | [ ] | `vera/farewell_1.ogg` | Go on. Lose gracefully. | Parting words as the player leaves. |
| 6 | [ ] | `vera/farewell_2.ogg` | Come back with something shiny. | Parting words as the player leaves. |
| 7 | [ ] | `vera/farewell_3.ogg` | The odds will miss you. I won't. | Parting words as the player leaves. |
| 8 | [ ] | `vera/farewell_4.ogg` | Don't die. It's bad for my numbers. | Parting words as the player leaves. |
| 9 | [ ] | `vera/rich_1.ogg` | Oh, that's a heavy pocket. Let me help you with it. | The player is carrying a lot of money. |
| 10 | [ ] | `vera/rich_2.ogg` | Money like that makes my charms blush. | The player is carrying a lot of money. |
| 11 | [ ] | `vera/rich_3.ogg` | You're glowing, sugar. It's the gold. | The player is carrying a lot of money. |
| 12 | [ ] | `vera/rich_4.ogg` | Rich suits you. Poor suited you better. | The player is carrying a lot of money. |
| 13 | [ ] | `vera/broke_1.ogg` | Empty pockets. I can sell you hope. Wholesale. | The player is nearly broke. |
| 14 | [ ] | `vera/broke_2.ogg` | Aw. Sit. I'll let you look. | The player is nearly broke. |
| 15 | [ ] | `vera/broke_3.ogg` | You're broke, not dead. Yet. | The player is nearly broke. |
| 16 | [ ] | `vera/broke_4.ogg` | Come back when you've robbed someone. | The player is nearly broke. |
| 17 | [ ] | `vera/ugly_1.ogg` | Honey. What are you wearing? | The player is wearing ugly clothes. |
| 18 | [ ] | `vera/ugly_2.ogg` | That outfit is a cry for help. | The player is wearing ugly clothes. |
| 19 | [ ] | `vera/ugly_3.ogg` | Even the slot machines looked away. | The player is wearing ugly clothes. |
| 20 | [ ] | `vera/ugly_4.ogg` | Silas will have a stroke. I'll sell tickets. | The player is wearing ugly clothes. |
| 21 | [ ] | `vera/sharp_1.ogg` | Now THAT is how you dress for a loss. | The player is dressed sharp. |
| 22 | [ ] | `vera/sharp_2.ogg` | Look at you. Dapper doom. | The player is dressed sharp. |
| 23 | [ ] | `vera/sharp_3.ogg` | You clean up nice, sugar. Don't bleed on it. | The player is dressed sharp. |
| 24 | [ ] | `vera/sharp_4.ogg` | If you lose in that, at least it'll be stylish. | The player is dressed sharp. |
| 25 | [ ] | `vera/died_1.ogg` | You died. Again. It's becoming a hobby. | The player just died. |
| 26 | [ ] | `vera/died_2.ogg` | I saw. Everyone saw. The cat saw. | The player just died. |
| 27 | [ ] | `vera/died_3.ogg` | Dust off, sugar. The House is still watching. | The player just died. |
| 28 | [ ] | `vera/died_4.ogg` | That was a bold way to lose. | The player just died. |
| 29 | [ ] | `vera/boss_1.ogg` | You beat a boss! I'll remember it when you owe me. | The player just beat a boss. |
| 30 | [ ] | `vera/boss_2.ogg` | Impressive. Terrifying, but impressive. | The player just beat a boss. |
| 31 | [ ] | `vera/boss_3.ogg` | Another table down. They are going to hate you. | The player just beat a boss. |
| 32 | [ ] | `vera/boss_4.ogg` | Sit. Let me price that victory. | The player just beat a boss. |
| 33 | [ ] | `vera/idle_1.ogg` | Charms don't pick themselves. | Idle chatter. Random. |
| 34 | [ ] | `vera/idle_2.ogg` | I know a secret. It costs extra. | Idle chatter. Random. |
| 35 | [ ] | `vera/idle_3.ogg` | Everybody's got a tell. Yours is hope. | Idle chatter. Random. |
| 36 | [ ] | `vera/idle_4.ogg` | Cards, charms, chaos. Pick two. | Idle chatter. Random. |
| 37 | [ ] | `vera/buy_1.ogg` | Wise choice. Or a terrible one. Same fee. | The player just bought something. |
| 38 | [ ] | `vera/buy_2.ogg` | Take it. It likes you. | The player just bought something. |
| 39 | [ ] | `vera/buy_3.ogg` | That one bites, sugar. In a good way. | The player just bought something. |
| 40 | [ ] | `vera/buy_4.ogg` | Pleasure doing business. Mostly mine. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city2_arrive/city2_arrive_3.ogg` | Welcome to the circus, sugar. Nobody leaves with their dignity. | Cutscene: city2 arrive |
| 42 | [ ] | `_cutscenes/intro_cast/intro_cast_1.ogg` | New face. I deal the cards and sell the charms. Bring me something shiny and I'll make the odds lean your way. | Cutscene: intro cast |
| 43 | [ ] | `_cutscenes/true_ending/true_ending_6.ogg` | Whatever you were before the tables, Eddie. That's what's left. It's enough. | Cutscene: true ending |
| 44 | [ ] | `vera/vera_intro_1.ogg` | Fresh Marker, still wet. I'm Vera Vex. I deal charms now, not cards. | Conversation: vera_intro |
| 45 | [ ] | `vera/vera_intro_2.ogg` | Charms bend the odds down there. Win them on slots, crack them out of vaults, take them off bosses, or buy them at my table on the floors. | Conversation: vera_intro |
| 46 | [ ] | `vera/vera_intro_4.ogg` | Up here I sell licenses. Pay me from your wallet and I'll start slipping the good charms into the Pit. | Conversation: vera_intro |
| 47 | [ ] | `vera/vera_bust_1.ogg` | You came back. Everyone comes back. That's the problem with this place. | Conversation: vera_bust |
| 48 | [ ] | `vera/vera_stack_1.ogg` | Five charms and still breathing. Here's the trick: pick a vice and feed it. | Conversation: vera_stack |
| 49 | [ ] | `vera/vera_stack_2.ogg` | Greed charms multiply each other. Risk charms love a long ride. Stack the same vice and watch the numbers go stupid. | Conversation: vera_stack |
| 50 | [ ] | `vera/vera_jackpot_1.ogg` | Triple sevens. The House hates that sound. Do it again. | Conversation: vera_jackpot |
| 51 | [ ] | `vera/vera_sal_1.ogg` | Big Sal went down. He'll be back on his feet tomorrow. Down here nobody stays down. Not even the bad guys. | Conversation: vera_sal |
| 52 | [ ] | `vera/vera_queen_hint_1.ogg` | Ever wonder why I stopped dealing? My deck's one card short. The Queen of Spades. | Conversation: vera_queen_hint |
| 53 | [ ] | `vera/vera_queen_hint_2.ogg` | She's my Marker. Lost her to the House a long time ago. If you see her down there... bring her home. | Conversation: vera_queen_hint |
| 54 | [ ] | `vera/vera_queen_found_1.ogg` | ...That's her. That's my Queen. | Conversation: vera_queen_found |
| 55 | [ ] | `vera/vera_queen_found_2.ogg` | Twenty years I've owed the House this card, and you found it folded in a losing ticket. Of course you did. | Conversation: vera_queen_found |
| 56 | [ ] | `vera/vera_queen_found_3.ogg` | You just paid my Marker, Rico. I'm free to walk out that door. | Conversation: vera_queen_found |
| 57 | [ ] | `vera/vera_queen_found_4.ogg` | I'm staying. Somebody has to keep you lucky. Licenses are 25% off for you, forever. | Conversation: vera_queen_found |
| 58 | [ ] | `vera/vera_ending_1.ogg` | You got Jules out. Do you know how many runners I've watched try that? | Conversation: vera_ending |
| 59 | [ ] | `vera/vera_ending_2.ogg` | None of them knew when to cash out. You did. Mostly. | Conversation: vera_ending |
| 60 | [ ] | `vera/vera_eddie_1.ogg` | Eddie Duval. You've been reading his tickets, haven't you. | Conversation: vera_eddie |
| 61 | [ ] | `vera/vera_eddie_2.ogg` | Best player I ever dealt to. Never walked away from a table. Not once. | Conversation: vera_eddie |
| 62 | [ ] | `vera/vera_eddie_3.ogg` | Now he IS the table. That voice on the PA? That's what's left of Eddie. | Conversation: vera_eddie |
| 63 | [ ] | `vera/vera_rep1_1.ogg` | Charms don't make you lucky. They make you less unlucky. | Conversation: vera_rep1 |
| 64 | [ ] | `vera/vera_rep2_1.ogg` | The House always wins. Eventually. Your job is to leave before eventually. | Conversation: vera_rep2 |
| 65 | [ ] | `vera/vera_rep3_1.ogg` | Everything's for sale, sugar. Advice included. Advice especially. | Conversation: vera_rep3 |

### MAGS: 57 lines

Folder: `voice/mags/` (cutscene lines go in the folder shown). Voice: Sweet as pie, then drop the floor out of your voice..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `mags/greet_1.ogg` | Kid. Good. You're on time. I hate late. | Greeting the player. In character. |
| 2 | [ ] | `mags/greet_2.ogg` | I was just counting. Your debt. It's lovely. | Greeting the player. In character. |
| 3 | [ ] | `mags/greet_3.ogg` | Sit. No, standing's fine. For now. | Greeting the player. In character. |
| 4 | [ ] | `mags/greet_4.ogg` | Ah. My favorite investment. | Greeting the player. In character. |
| 5 | [ ] | `mags/farewell_1.ogg` | Don't make me swim after you. | Parting words as the player leaves. |
| 6 | [ ] | `mags/farewell_2.ogg` | I'll see you soon. You'll see me sooner. | Parting words as the player leaves. |
| 7 | [ ] | `mags/farewell_3.ogg` | Pay me. Or I'll collect. Ha. No, really. | Parting words as the player leaves. |
| 8 | [ ] | `mags/farewell_4.ogg` | Be careful out there. It would be a waste. | Parting words as the player leaves. |
| 9 | [ ] | `mags/rich_1.ogg` | Look at all that. It looks lonely. Let me adopt it. | The player is carrying a lot of money. |
| 10 | [ ] | `mags/rich_2.ogg` | A big pot. A bigger interest. | The player is carrying a lot of money. |
| 11 | [ ] | `mags/rich_3.ogg` | You can afford to pay me early. You won't. But you can. | The player is carrying a lot of money. |
| 12 | [ ] | `mags/rich_4.ogg` | Money. My favorite chewable. | The player is carrying a lot of money. |
| 13 | [ ] | `mags/broke_1.ogg` | Broke? I'll float you. A shark takes care of its fish. | The player is nearly broke. |
| 14 | [ ] | `mags/broke_2.ogg` | Empty pockets. Full of potential. Mine. | The player is nearly broke. |
| 15 | [ ] | `mags/broke_3.ogg` | I never judge. I just remember. | The player is nearly broke. |
| 16 | [ ] | `mags/broke_4.ogg` | A loan keeps the family together. My family. | The player is nearly broke. |
| 17 | [ ] | `mags/ugly_1.ogg` | That outfit is a loan officer's nightmare. | The player is wearing ugly clothes. |
| 18 | [ ] | `mags/ugly_2.ogg` | I'd lend you a suit. Interest only. | The player is wearing ugly clothes. |
| 19 | [ ] | `mags/ugly_3.ogg` | Is that a fanny pack? I'm calling your mother. | The player is wearing ugly clothes. |
| 20 | [ ] | `mags/ugly_4.ogg` | I've collected from better dressed corpses. | The player is wearing ugly clothes. |
| 21 | [ ] | `mags/sharp_1.ogg` | Nice suit. It looks expensive. I know whose. | The player is dressed sharp. |
| 22 | [ ] | `mags/sharp_2.ogg` | Dressed to impress? I'm impressed. Pay up. | The player is dressed sharp. |
| 23 | [ ] | `mags/sharp_3.ogg` | That's a lot of money on your back. I'll take a cut. | The player is dressed sharp. |
| 24 | [ ] | `mags/sharp_4.ogg` | Now you look like a lender. Good news: you're not. | The player is dressed sharp. |
| 25 | [ ] | `mags/died_1.ogg` | You died. I'm adding that to the interest. | The player just died. |
| 26 | [ ] | `mags/died_2.ogg` | No refunds in the afterlife. | The player just died. |
| 27 | [ ] | `mags/died_3.ogg` | Dead men don't pay. But they do borrow. | The player just died. |
| 28 | [ ] | `mags/died_4.ogg` | Death is just a late payment. | The player just died. |
| 29 | [ ] | `mags/boss_1.ogg` | A boss? Their debt belongs to me now. | The player just beat a boss. |
| 30 | [ ] | `mags/boss_2.ogg` | Take your spoils. I take my share. | The player just beat a boss. |
| 31 | [ ] | `mags/boss_3.ogg` | Winning's expensive. Let me carry it. | The player just beat a boss. |
| 32 | [ ] | `mags/boss_4.ogg` | You beat the boss. Now beat the interest. | The player just beat a boss. |
| 33 | [ ] | `mags/idle_1.ogg` | Interest compounds. So does my patience. | Idle chatter. Random. |
| 34 | [ ] | `mags/idle_2.ogg` | I like you. That's the problem. | Idle chatter. Random. |
| 35 | [ ] | `mags/idle_3.ogg` | Everybody owes somebody. I just own the paperwork. | Idle chatter. Random. |
| 36 | [ ] | `mags/idle_4.ogg` | I swim every day. Just in case. | Idle chatter. Random. |
| 37 | [ ] | `mags/buy_1.ogg` | Sign here. And here. And... there. | The player just bought something. |
| 38 | [ ] | `mags/buy_2.ogg` | A pleasure. I'll bill you later. | The player just bought something. |
| 39 | [ ] | `mags/buy_3.ogg` | Smart. Debt is just future money you spent early. | The player just bought something. |
| 40 | [ ] | `mags/buy_4.ogg` | No refunds. No regrets. Some regrets. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city4_arrive/city4_arrive_3.ogg` | I'll see you at the vault, kid. With a calculator. | Cutscene: city4 arrive |
| 42 | [ ] | `_cutscenes/intro/intro_3.ogg` | Nobody climbs without a Marker, kid. Sign here. And here. And... there. Don't read it. Nobody reads it. | Cutscene: intro |
| 43 | [ ] | `_cutscenes/mags_chase/mags_chase_1.ogg` | Payday, kid. You're late. I hate late. | Cutscene: mags chase |
| 44 | [ ] | `_cutscenes/mags_chase/mags_chase_3.ogg` | We ARE talking. This is me talking. The swimming is me collecting. Cash out and pay me, or keep running. | Cutscene: mags chase |
| 45 | [ ] | `mags/mags_intro_1.ogg` | Name's Mags. I hold the Markers at the door, and yours says the House owns your bones until you settle up. | Conversation: mags_intro |
| 46 | [ ] | `mags/mags_intro_2.ogg` | Short on chips? I lend. Two hundred now, three hundred back by the end of floor three. | Conversation: mags_intro |
| 47 | [ ] | `mags/mags_intro_3.ogg` | Pay me when you cash out. Miss the date and I come collecting. Personally. Through walls. | Conversation: mags_intro |
| 48 | [ ] | `mags/mags_intro_5.ogg` | And you're a runner with no money. We all have our problems. | Conversation: mags_intro |
| 49 | [ ] | `mags/mags_repaid_1.ogg` | You paid me back on time. Respect. You'd be amazed how few do. | Conversation: mags_repaid |
| 50 | [ ] | `mags/mags_default_1.ogg` | About that chase. Nothing personal. Interest isn't personal, kid. It's just math with teeth. | Conversation: mags_default |
| 51 | [ ] | `mags/mags_big_loss_1.ogg` | Saw you drop a thousand at the door. If you'd banked that, you'd have... well. You know what you'd have. | Conversation: mags_big_loss |
| 52 | [ ] | `mags/mags_rates_1.ogg` | Between you and me? The House charges interest on every bust. Compounding. Forever. | Conversation: mags_rates |
| 53 | [ ] | `mags/mags_rates_2.ogg` | Even I think that's ugly. And I'm a loan shark. Literally. | Conversation: mags_rates |
| 54 | [ ] | `mags/mags_ending_1.ogg` | You beat the House and it's still standing. That's interest for you, kid. It keeps things alive. | Conversation: mags_ending |
| 55 | [ ] | `mags/mags_rep1_1.ogg` | Borrow smart. Ride dumb. That's a joke. Don't do that. | Conversation: mags_rep1 |
| 56 | [ ] | `mags/mags_rep2_1.ogg` | My rates are fair. The House's rates are a crime. I would know. | Conversation: mags_rep2 |
| 57 | [ ] | `mags/mags_rep3_1.ogg` | A shark has to keep swimming. So do you. | Conversation: mags_rep3 |

### LUCKY: 47 lines

Folder: `voice/lucky/` (cutscene lines go in the folder shown). Voice: Pretend you are polishing a glass the entire time..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `lucky/greet_1.ogg` | Pull up a stool, runner. | Greeting the player. In character. |
| 2 | [ ] | `lucky/greet_2.ogg` | The usual? Whatever that was. | Greeting the player. In character. |
| 3 | [ ] | `lucky/greet_3.ogg` | Lucky's. We don't water it down. Much. | Greeting the player. In character. |
| 4 | [ ] | `lucky/greet_4.ogg` | Good to see you breathing. | Greeting the player. In character. |
| 5 | [ ] | `lucky/farewell_1.ogg` | Drink responsibly. Or at least first. | Parting words as the player leaves. |
| 6 | [ ] | `lucky/farewell_2.ogg` | Come back in one piece. | Parting words as the player leaves. |
| 7 | [ ] | `lucky/farewell_3.ogg` | I'll keep your seat warm. And your tab open. | Parting words as the player leaves. |
| 8 | [ ] | `lucky/farewell_4.ogg` | Break a leg. Not your own. | Parting words as the player leaves. |
| 9 | [ ] | `lucky/rich_1.ogg` | First round's on me. Second on you. And your fortune. | The player is carrying a lot of money. |
| 10 | [ ] | `lucky/rich_2.ogg` | That's a lot of green. I've a Scotch that'll cry. | The player is carrying a lot of money. |
| 11 | [ ] | `lucky/rich_3.ogg` | Cash like that needs a toast. | The player is carrying a lot of money. |
| 12 | [ ] | `lucky/rich_4.ogg` | You're buying, aren't you. | The player is carrying a lot of money. |
| 13 | [ ] | `lucky/broke_1.ogg` | Tab's on me. Don't make it a habit. | The player is nearly broke. |
| 14 | [ ] | `lucky/broke_2.ogg` | I'll pour you water. It's all I've got that's free. | The player is nearly broke. |
| 15 | [ ] | `lucky/broke_3.ogg` | Broke? Join the club. I'm the president. | The player is nearly broke. |
| 16 | [ ] | `lucky/broke_4.ogg` | Not a problem. Sit. Cry. Hydrate. | The player is nearly broke. |
| 17 | [ ] | `lucky/ugly_1.ogg` | That outfit's strong. Like my worst whiskey. | The player is wearing ugly clothes. |
| 18 | [ ] | `lucky/ugly_2.ogg` | Not my business what you wear. It's my business that it hurts. | The player is wearing ugly clothes. |
| 19 | [ ] | `lucky/ugly_3.ogg` | I've seen better coats in the lost and found. | The player is wearing ugly clothes. |
| 20 | [ ] | `lucky/ugly_4.ogg` | A drink might help. Or at least blur it. | The player is wearing ugly clothes. |
| 21 | [ ] | `lucky/sharp_1.ogg` | Look at you. All class and no chaser. | The player is dressed sharp. |
| 22 | [ ] | `lucky/sharp_2.ogg` | Dressed to kill. Or at least be killed in. | The player is dressed sharp. |
| 23 | [ ] | `lucky/sharp_3.ogg` | That suit deserves a good Scotch. | The player is dressed sharp. |
| 24 | [ ] | `lucky/sharp_4.ogg` | You almost look like you belong here. | The player is dressed sharp. |
| 25 | [ ] | `lucky/died_1.ogg` | Ah, you died. Have a drink. It helps. | The player just died. |
| 26 | [ ] | `lucky/died_2.ogg` | Rough one. I'll keep the stool warm. | The player just died. |
| 27 | [ ] | `lucky/died_3.ogg` | I've buried better drunks than you. | The player just died. |
| 28 | [ ] | `lucky/died_4.ogg` | A drink can save your life, runner. A second can end it. | The player just died. |
| 29 | [ ] | `lucky/boss_1.ogg` | You beat a boss? The next round's mine. | The player just beat a boss. |
| 30 | [ ] | `lucky/boss_2.ogg` | Cheers to the one that fell! | The player just beat a boss. |
| 31 | [ ] | `lucky/boss_3.ogg` | That boss drank here. Tipped badly. | The player just beat a boss. |
| 32 | [ ] | `lucky/boss_4.ogg` | A toast: to the one who didn't die tonight. | The player just beat a boss. |
| 33 | [ ] | `lucky/idle_1.ogg` | I keep a bar on most floors. Out of spite. | Idle chatter. Random. |
| 34 | [ ] | `lucky/idle_2.ogg` | I know a guy who knows a guy. I'm the guy. | Idle chatter. Random. |
| 35 | [ ] | `lucky/idle_3.ogg` | A drink never lies. Only the drinker does. | Idle chatter. Random. |
| 36 | [ ] | `lucky/idle_4.ogg` | Wipe the glass. Listen. That's the whole job. | Idle chatter. Random. |
| 37 | [ ] | `lucky/buy_1.ogg` | Down the hatch. | The player just bought something. |
| 38 | [ ] | `lucky/buy_2.ogg` | That one has a kick. And a story. | The player just bought something. |
| 39 | [ ] | `lucky/buy_3.ogg` | Careful. Don't spill your luck. | The player just bought something. |
| 40 | [ ] | `lucky/buy_4.ogg` | On the house. Sort of. | The player just bought something. |
| 41 | [ ] | `_cutscenes/intro_cast/intro_cast_2.ogg` | Lucky's the name. Down there I keep a bar on most floors. A drink can save your life, runner. | Cutscene: intro cast |
| 42 | [ ] | `lucky/lucky_intro_1.ogg` | Lucky's the name. Down on the floors I pour drinks. Up here I just listen. | Conversation: lucky_intro |
| 43 | [ ] | `lucky/lucky_intro_2.ogg` | Everybody busts eventually. Barkeeps hear all about it. | Conversation: lucky_intro |
| 44 | [ ] | `lucky/lucky_tip_1.ogg` | Pro tip: a Shot of Courage costs less than the interest on a bust. Find my bar on the floors. | Conversation: lucky_tip |
| 45 | [ ] | `lucky/lucky_cat_1.ogg` | Keep petting Comp like that and he'll follow you down. ...He won't. He's a cat. But he likes you. | Conversation: lucky_cat |
| 46 | [ ] | `lucky/lucky_rep1_1.ogg` | On the house? Nothing's on the house. That's the House's whole thing. | Conversation: lucky_rep1 |
| 47 | [ ] | `lucky/lucky_rep2_1.ogg` | You've got the look of somebody about to let it ride. | Conversation: lucky_rep2 |

### JULES: 47 lines

Folder: `voice/jules/` (cutscene lines go in the folder shown). Voice: Whisper like you have not slept since Tuesday..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `jules/greet_1.ogg` | Rico? Is it really you? | Greeting the player. In character. |
| 2 | [ ] | `jules/greet_2.ogg` | I knew you'd come. I just didn't know when. | Greeting the player. In character. |
| 3 | [ ] | `jules/greet_3.ogg` | One more hand. Just one. Oh. It's you. | Greeting the player. In character. |
| 4 | [ ] | `jules/greet_4.ogg` | Is it morning? What day is it? | Greeting the player. In character. |
| 5 | [ ] | `jules/farewell_1.ogg` | Don't wait for me. Go. | Parting words as the player leaves. |
| 6 | [ ] | `jules/farewell_2.ogg` | Say hi to Mom. Or don't. She'll worry. | Parting words as the player leaves. |
| 7 | [ ] | `jules/farewell_3.ogg` | Take the money. Leave the cards. | Parting words as the player leaves. |
| 8 | [ ] | `jules/farewell_4.ogg` | Come back. I'll be here. I'm always here. | Parting words as the player leaves. |
| 9 | [ ] | `jules/rich_1.ogg` | That's a lot of chips. I know the feeling. Don't trust it. | The player is carrying a lot of money. |
| 10 | [ ] | `jules/rich_2.ogg` | I had that much once. For ten minutes. | The player is carrying a lot of money. |
| 11 | [ ] | `jules/rich_3.ogg` | Bank it. I'm begging. | The player is carrying a lot of money. |
| 12 | [ ] | `jules/rich_4.ogg` | I was rich once. It didn't help. | The player is carrying a lot of money. |
| 13 | [ ] | `jules/broke_1.ogg` | Broke? Welcome. It's cozy. | The player is nearly broke. |
| 14 | [ ] | `jules/broke_2.ogg` | I've been broke for three years. It's fine. | The player is nearly broke. |
| 15 | [ ] | `jules/broke_3.ogg` | It's just money. It was never ours. | The player is nearly broke. |
| 16 | [ ] | `jules/broke_4.ogg` | At least we're broke together. | The player is nearly broke. |
| 17 | [ ] | `jules/ugly_1.ogg` | Nice outfit. I love it. I'm lying. | The player is wearing ugly clothes. |
| 18 | [ ] | `jules/ugly_2.ogg` | I'd say something. But you're my brother. | The player is wearing ugly clothes. |
| 19 | [ ] | `jules/ugly_3.ogg` | You look like me. After three years. | The player is wearing ugly clothes. |
| 20 | [ ] | `jules/ugly_4.ogg` | Mom would cry. Then laugh. | The player is wearing ugly clothes. |
| 21 | [ ] | `jules/sharp_1.ogg` | You look great. Suspiciously great. | The player is dressed sharp. |
| 22 | [ ] | `jules/sharp_2.ogg` | Look at you. Dad would be proud. | The player is dressed sharp. |
| 23 | [ ] | `jules/sharp_3.ogg` | I used to dress like that. Before. | The player is dressed sharp. |
| 24 | [ ] | `jules/sharp_4.ogg` | Did you buy that with my debts? | The player is dressed sharp. |
| 25 | [ ] | `jules/died_1.ogg` | You died? Welcome to my life. | The player just died. |
| 26 | [ ] | `jules/died_2.ogg` | It doesn't hurt after the first twenty. | The player just died. |
| 27 | [ ] | `jules/died_3.ogg` | I've died here a hundred times. You get used to it. | The player just died. |
| 28 | [ ] | `jules/died_4.ogg` | Get up, Rico. It's just money. | The player just died. |
| 29 | [ ] | `jules/boss_1.ogg` | You beat a boss? I never got past the third. | The player just beat a boss. |
| 30 | [ ] | `jules/boss_2.ogg` | I heard the table go quiet. It was you. | The player just beat a boss. |
| 31 | [ ] | `jules/boss_3.ogg` | The House is going to notice. | The player just beat a boss. |
| 32 | [ ] | `jules/boss_4.ogg` | I'm proud. And scared. | The player just beat a boss. |
| 33 | [ ] | `jules/idle_1.ogg` | The cards remember everything. | Idle chatter. Random. |
| 34 | [ ] | `jules/idle_2.ogg` | You hear that? The wheel. It never stops. | Idle chatter. Random. |
| 35 | [ ] | `jules/idle_3.ogg` | I counted every floor. There's more. | Idle chatter. Random. |
| 36 | [ ] | `jules/idle_4.ogg` | Be careful with the House. It's not a person. | Idle chatter. Random. |
| 37 | [ ] | `jules/buy_1.ogg` | Good pick. I'd have picked it too. I lost anyway. | The player just bought something. |
| 38 | [ ] | `jules/buy_2.ogg` | Take my advice: don't. | The player just bought something. |
| 39 | [ ] | `jules/buy_3.ogg` | It might work. Mine didn't. | The player just bought something. |
| 40 | [ ] | `jules/buy_4.ogg` | At least you're trying. | The player just bought something. |
| 41 | [ ] | `_cutscenes/ending/ending_2.ogg` | ...Rico? You came down here? For me? | Cutscene: ending |
| 42 | [ ] | `jules/jules_home_1.ogg` | Rico. I keep waking up in this Lobby. Old habits. The House still thinks I owe it. | Conversation: jules_home |
| 43 | [ ] | `jules/jules_home_2.ogg` | Thanks for coming for me. Now let me come with you. Pick me on the title screen. I hit harder than you. | Conversation: jules_home |
| 44 | [ ] | `jules/jules_eddie_1.ogg` | Those losing tickets are Eddie Duval's trail. I dealt to that voice every night for three years. | Conversation: jules_eddie |
| 45 | [ ] | `jules/jules_eddie_2.ogg` | He doesn't want our money. He wants somebody to finally beat him so he can stop. | Conversation: jules_eddie |
| 46 | [ ] | `jules/jules_rep1_1.ogg` | Bank it, Rico. I didn't. Look where it got me. | Conversation: jules_rep1 |
| 47 | [ ] | `jules/jules_rep2_1.ogg` | The House cheats. So we cheat better. | Conversation: jules_rep2 |

### COMP: 17 lines

Folder: `voice/comp/` (cutscene lines go in the folder shown). Voice: Meow in different moods. Smug, hungry, offended..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `comp/idle_1.ogg` | Mrrrow. | Idle chatter. Random. |
| 2 | [ ] | `comp/idle_2.ogg` | Mrrp? Mrrp. | Idle chatter. Random. |
| 3 | [ ] | `comp/idle_3.ogg` | Hssss. (Not at you. Probably.) | Idle chatter. Random. |
| 4 | [ ] | `comp/idle_4.ogg` | Prrrr. | Idle chatter. Random. |
| 5 | [ ] | `comp/idle_5.ogg` | Mrow-mrow. | Idle chatter. Random. |
| 6 | [ ] | `comp/idle_6.ogg` | Meeeow. (Pet me. Not like that.) | Idle chatter. Random. |
| 7 | [ ] | `comp/greet_1.ogg` | Mrrow! | Greeting the player. In character. |
| 8 | [ ] | `comp/greet_2.ogg` | Prrrp? | Greeting the player. In character. |
| 9 | [ ] | `comp/greet_3.ogg` | Mew. | Greeting the player. In character. |
| 10 | [ ] | `comp/farewell_1.ogg` | Mrrrrow. (Goodbye. And bring fish.) | Parting words as the player leaves. |
| 11 | [ ] | `comp/farewell_2.ogg` | Meeeeow. | Parting words as the player leaves. |
| 12 | [ ] | `comp/rich_1.ogg` | Prrrrr. (You smell like money.) | The player is carrying a lot of money. |
| 13 | [ ] | `comp/rich_2.ogg` | Mrow! (Share.) | The player is carrying a lot of money. |
| 14 | [ ] | `comp/broke_1.ogg` | Hss. (Bad.) | The player is nearly broke. |
| 15 | [ ] | `comp/broke_2.ogg` | Mew. (There, there.) | The player is nearly broke. |
| 16 | [ ] | `comp/died_1.ogg` | Mrrrrrow. (I saw that.) | The player just died. |
| 17 | [ ] | `comp/boss_1.ogg` | Purrr. (Not bad, human.) | The player just beat a boss. |

### SILAS STITCH: 41 lines

Folder: `voice/tailor/` (cutscene lines go in the folder shown). Voice: Sniff at the player's outfit before each line..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `tailor/greet_1.ogg` | Do come in. Mind the pins. | Greeting the player. In character. |
| 2 | [ ] | `tailor/greet_2.ogg` | Ah. A customer. Or a stray. Hold still. | Greeting the player. In character. |
| 3 | [ ] | `tailor/greet_3.ogg` | Silas Stitch, at your service. And at your waistline. | Greeting the player. In character. |
| 4 | [ ] | `tailor/greet_4.ogg` | Good heavens. Sit down before you offend the mannequins. | Greeting the player. In character. |
| 5 | [ ] | `tailor/farewell_1.ogg` | Wear it well. Or wear it. Anything. | Parting words as the player leaves. |
| 6 | [ ] | `tailor/farewell_2.ogg` | Mind the hem on the way out. | Parting words as the player leaves. |
| 7 | [ ] | `tailor/farewell_3.ogg` | Do try not to bleed on the silk. | Parting words as the player leaves. |
| 8 | [ ] | `tailor/farewell_4.ogg` | Come back for a fitting. And a lecture. | Parting words as the player leaves. |
| 9 | [ ] | `tailor/rich_1.ogg` | Splendid. A gentleman with means. Let us begin. | The player is carrying a lot of money. |
| 10 | [ ] | `tailor/rich_2.ogg` | Ah, the pockets are heavy. The hems shall be lovely. | The player is carrying a lot of money. |
| 11 | [ ] | `tailor/rich_3.ogg` | With that fortune, we might fix your posture. | The player is carrying a lot of money. |
| 12 | [ ] | `tailor/rich_4.ogg` | Money! How delightfully vulgar. Please, spend it. | The player is carrying a lot of money. |
| 13 | [ ] | `tailor/broke_1.ogg` | No funds? Then we tailor in imagination. | The player is nearly broke. |
| 14 | [ ] | `tailor/broke_2.ogg` | I can give you a very nice belt of regret. | The player is nearly broke. |
| 15 | [ ] | `tailor/broke_3.ogg` | Poverty is just fashion in beta. | The player is nearly broke. |
| 16 | [ ] | `tailor/broke_4.ogg` | Come back when you can afford sleeves. | The player is nearly broke. |
| 17 | [ ] | `tailor/ugly_1.ogg` | Dear boy, did you dress in a dumpster? | The player is wearing ugly clothes. |
| 18 | [ ] | `tailor/ugly_2.ogg` | That fanny pack is a war crime. | The player is wearing ugly clothes. |
| 19 | [ ] | `tailor/ugly_3.ogg` | I will not say what I think. I will faint. | The player is wearing ugly clothes. |
| 20 | [ ] | `tailor/ugly_4.ogg` | You look like a rumor of an outfit. | The player is wearing ugly clothes. |
| 21 | [ ] | `tailor/sharp_1.ogg` | Now THAT is a proper silhouette. | The player is dressed sharp. |
| 22 | [ ] | `tailor/sharp_2.ogg` | Magnificent. I'd put it in a museum. | The player is dressed sharp. |
| 23 | [ ] | `tailor/sharp_3.ogg` | You are a credit to the craft. | The player is dressed sharp. |
| 24 | [ ] | `tailor/sharp_4.ogg` | I made half of that. The other half is you. Barely. | The player is dressed sharp. |
| 25 | [ ] | `tailor/died_1.ogg` | You died in my wares? Did it stain? | The player just died. |
| 26 | [ ] | `tailor/died_2.ogg` | A dead client is a quiet client. | The player just died. |
| 27 | [ ] | `tailor/died_3.ogg` | Do bleed on the old stock, please. | The player just died. |
| 28 | [ ] | `tailor/died_4.ogg` | Hold still. I'll repair the holes. | The player just died. |
| 29 | [ ] | `tailor/boss_1.ogg` | Defeated a boss? Marvelous! Armor, then. | The player just beat a boss. |
| 30 | [ ] | `tailor/boss_2.ogg` | Slaying monsters in silk. Delightful. | The player just beat a boss. |
| 31 | [ ] | `tailor/boss_3.ogg` | The trophies will need a tasteful frame. | The player just beat a boss. |
| 32 | [ ] | `tailor/boss_4.ogg` | I made that boss a suit. He hated it. | The player just beat a boss. |
| 33 | [ ] | `tailor/idle_1.ogg` | Gloves for gripping. Boots for smashing. Scarves for gliding. | Idle chatter. Random. |
| 34 | [ ] | `tailor/idle_2.ogg` | The shoes make the man. The man makes the dash. | Idle chatter. Random. |
| 35 | [ ] | `tailor/idle_3.ogg` | Stand straight. The cloth knows. | Idle chatter. Random. |
| 36 | [ ] | `tailor/idle_4.ogg` | Everything I sell grants a talent. Mostly vanity. | Idle chatter. Random. |
| 37 | [ ] | `tailor/buy_1.ogg` | A fine choice. I knew it'd suit you. | The player just bought something. |
| 38 | [ ] | `tailor/buy_2.ogg` | Wear it with confidence. Or at least shoes. | The player just bought something. |
| 39 | [ ] | `tailor/buy_3.ogg` | I shall tell the thread you said hello. | The player just bought something. |
| 40 | [ ] | `tailor/buy_4.ogg` | One moment. The pins are my pride. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city5_arrive/city5_arrive_2.ogg` | Dear boy, the cloak room is that way. We shall do what we can. | Cutscene: city5 arrive |

### DOC FIZZ: 40 lines

Folder: `voice/fizz/` (cutscene lines go in the folder shown). Voice: Whisper-yell. Look over your shoulder after each sentence..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `fizz/greet_1.ogg` | Psst. Hey. You. Yes you. Want a pick-me-up? | Greeting the player. In character. |
| 2 | [ ] | `fizz/greet_2.ogg` | Quiet. Come closer. Closer. NOT that close. | Greeting the player. In character. |
| 3 | [ ] | `fizz/greet_3.ogg` | Welcome to the pharmacy. We're not licensed. | Greeting the player. In character. |
| 4 | [ ] | `fizz/greet_4.ogg` | Finally. A customer. Or a cop. Are you a cop? | Greeting the player. In character. |
| 5 | [ ] | `fizz/farewell_1.ogg` | Don't tell anyone. Especially me. | Parting words as the player leaves. |
| 6 | [ ] | `fizz/farewell_2.ogg` | Side effects begin immediately. | Parting words as the player leaves. |
| 7 | [ ] | `fizz/farewell_3.ogg` | Go! Run! Be amazing! Or dead! | Parting words as the player leaves. |
| 8 | [ ] | `fizz/farewell_4.ogg` | Keep the bottle. I don't want it back. | Parting words as the player leaves. |
| 9 | [ ] | `fizz/rich_1.ogg` | Oh, you're LOADED. I have the GOOD stuff. | The player is carrying a lot of money. |
| 10 | [ ] | `fizz/rich_2.ogg` | Cash! Real cash! My favorite flavor! | The player is carrying a lot of money. |
| 11 | [ ] | `fizz/rich_3.ogg` | For you, double price, triple effect. | The player is carrying a lot of money. |
| 12 | [ ] | `fizz/rich_4.ogg` | Hide that money. Spend it HERE. | The player is carrying a lot of money. |
| 13 | [ ] | `fizz/broke_1.ogg` | No cash? I accept organs. Small ones. | The player is nearly broke. |
| 14 | [ ] | `fizz/broke_2.ogg` | Broke? Have a free sample. Free as in my liability. | The player is nearly broke. |
| 15 | [ ] | `fizz/broke_3.ogg` | I trust you. I'll bill your family. | The player is nearly broke. |
| 16 | [ ] | `fizz/broke_4.ogg` | Come back when you've been mugged by someone richer. | The player is nearly broke. |
| 17 | [ ] | `fizz/ugly_1.ogg` | That outfit? It's already a hallucination. | The player is wearing ugly clothes. |
| 18 | [ ] | `fizz/ugly_2.ogg` | You look like a warning label. | The player is wearing ugly clothes. |
| 19 | [ ] | `fizz/ugly_3.ogg` | Don't worry, the drugs make it look better. | The player is wearing ugly clothes. |
| 20 | [ ] | `fizz/ugly_4.ogg` | I've seen better fits on a cadaver. | The player is wearing ugly clothes. |
| 21 | [ ] | `fizz/sharp_1.ogg` | Fancy! The stuff will clash with your suit. | The player is dressed sharp. |
| 22 | [ ] | `fizz/sharp_2.ogg` | Look at you. A well-dressed mistake. | The player is dressed sharp. |
| 23 | [ ] | `fizz/sharp_3.ogg` | You're too nice for this alley. Buy something. | The player is dressed sharp. |
| 24 | [ ] | `fizz/sharp_4.ogg` | Sharp! Let's ruin it. | The player is dressed sharp. |
| 25 | [ ] | `fizz/died_1.ogg` | You look dead. Great sign. Try this. | The player just died. |
| 26 | [ ] | `fizz/died_2.ogg` | I heard the scream. Was it you? It was you. | The player just died. |
| 27 | [ ] | `fizz/died_3.ogg` | Death's not so bad. Mostly the sequel is worse. | The player just died. |
| 28 | [ ] | `fizz/died_4.ogg` | Don't die near the merchandise. | The player just died. |
| 29 | [ ] | `fizz/boss_1.ogg` | A boss! Down! Give me your blood for science. | The player just beat a boss. |
| 30 | [ ] | `fizz/boss_2.ogg` | You killed someone big? Buy something to celebrate. | The player just beat a boss. |
| 31 | [ ] | `fizz/boss_3.ogg` | Bosses are just customers who never learned to share. | The player just beat a boss. |
| 32 | [ ] | `fizz/boss_4.ogg` | I sold that boss his last drink. | The player just beat a boss. |
| 33 | [ ] | `fizz/idle_1.ogg` | I have a bottle that sings. It's a bad singer. | Idle chatter. Random. |
| 34 | [ ] | `fizz/idle_2.ogg` | Everything has side effects. Even oxygen. | Idle chatter. Random. |
| 35 | [ ] | `fizz/idle_3.ogg` | Don't read the label. The label is lying. | Idle chatter. Random. |
| 36 | [ ] | `fizz/idle_4.ogg` | Tell me your symptoms. Then ignore my advice. | Idle chatter. Random. |
| 37 | [ ] | `fizz/buy_1.ogg` | Drink it fast. No, SLOW. Wait. FAST. | The player just bought something. |
| 38 | [ ] | `fizz/buy_2.ogg` | That's a classic. Nobody's ever sued me. Yet. | The player just bought something. |
| 39 | [ ] | `fizz/buy_3.ogg` | Do not mix with anything. I mean it. Mix it. | The player just bought something. |
| 40 | [ ] | `fizz/buy_4.ogg` | A good choice! Probably! I don't read. | The player just bought something. |

### GUNNY: 40 lines

Folder: `voice/gunny/` (cutscene lines go in the folder shown). Voice: Everything is an order. Everything is a compliment..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `gunny/greet_1.ogg` | Welcome to the armory, recruit. | Greeting the player. In character. |
| 2 | [ ] | `gunny/greet_2.ogg` | Stand up straight! That's a weapon you're holding. Your face. | Greeting the player. In character. |
| 3 | [ ] | `gunny/greet_3.ogg` | Rack 'em and stack 'em, gamblers! | Greeting the player. In character. |
| 4 | [ ] | `gunny/greet_4.ogg` | You need firepower. I can smell it. | Greeting the player. In character. |
| 5 | [ ] | `gunny/farewell_1.ogg` | Don't shoot your foot. Shoot THEIRS. | Parting words as the player leaves. |
| 6 | [ ] | `gunny/farewell_2.ogg` | Dismissed. Try to die forward. | Parting words as the player leaves. |
| 7 | [ ] | `gunny/farewell_3.ogg` | Clean your guns. Wash your hands. Never your lucky socks. | Parting words as the player leaves. |
| 8 | [ ] | `gunny/farewell_4.ogg` | Move out, rookie. | Parting words as the player leaves. |
| 9 | [ ] | `gunny/rich_1.ogg` | Cash! The universal caliber! | The player is carrying a lot of money. |
| 10 | [ ] | `gunny/rich_2.ogg` | A big spender! I salute your wallet. | The player is carrying a lot of money. |
| 11 | [ ] | `gunny/rich_3.ogg` | Now THAT is purchasing power. | The player is carrying a lot of money. |
| 12 | [ ] | `gunny/rich_4.ogg` | I'll throw in a free ammo clip. And a salute. | The player is carrying a lot of money. |
| 13 | [ ] | `gunny/broke_1.ogg` | No money, no bang. It's simple. | The player is nearly broke. |
| 14 | [ ] | `gunny/broke_2.ogg` | Broke? Throw rocks. It's a classic. | The player is nearly broke. |
| 15 | [ ] | `gunny/broke_3.ogg` | A recruit with no cash. It's a start. | The player is nearly broke. |
| 16 | [ ] | `gunny/broke_4.ogg` | I'm not a charity. I'm a battle store. | The player is nearly broke. |
| 17 | [ ] | `gunny/ugly_1.ogg` | Soldier, that outfit is a disciplinary action. | The player is wearing ugly clothes. |
| 18 | [ ] | `gunny/ugly_2.ogg` | Camouflage? You look like a bruise. | The player is wearing ugly clothes. |
| 19 | [ ] | `gunny/ugly_3.ogg` | I've seen better uniforms on a scarecrow. | The player is wearing ugly clothes. |
| 20 | [ ] | `gunny/ugly_4.ogg` | What happened to your pants, recruit? | The player is wearing ugly clothes. |
| 21 | [ ] | `gunny/sharp_1.ogg` | Spit-shined! I'm almost proud. | The player is dressed sharp. |
| 22 | [ ] | `gunny/sharp_2.ogg` | That suit says 'I'm lethal in four languages.' | The player is dressed sharp. |
| 23 | [ ] | `gunny/sharp_3.ogg` | You look like a general. Behave like one. | The player is dressed sharp. |
| 24 | [ ] | `gunny/sharp_4.ogg` | A sharp dresser holds a gun better. | The player is dressed sharp. |
| 25 | [ ] | `gunny/died_1.ogg` | You're dead? Walk it off! | The player just died. |
| 26 | [ ] | `gunny/died_2.ogg` | That's what the armor's for, rookie. | The player just died. |
| 27 | [ ] | `gunny/died_3.ogg` | Retrain. Rearm. Resurrect. Repeat. | The player just died. |
| 28 | [ ] | `gunny/died_4.ogg` | The only bad death is the unarmed one. | The player just died. |
| 29 | [ ] | `gunny/boss_1.ogg` | A boss down! Medals for everyone! | The player just beat a boss. |
| 30 | [ ] | `gunny/boss_2.ogg` | That's the kind of firepower I like! | The player just beat a boss. |
| 31 | [ ] | `gunny/boss_3.ogg` | I sold that boss his first revolver. I regret nothing. | The player just beat a boss. |
| 32 | [ ] | `gunny/boss_4.ogg` | You make me proud. Don't make it weird. | The player just beat a boss. |
| 33 | [ ] | `gunny/idle_1.ogg` | Chip flick. Card fan. Dice bomb. Pick one. | Idle chatter. Random. |
| 34 | [ ] | `gunny/idle_2.ogg` | A revolver has six reasons. Use five. | Idle chatter. Random. |
| 35 | [ ] | `gunny/idle_3.ogg` | Coin shotgun's the favorite. Don't ask why. | Idle chatter. Random. |
| 36 | [ ] | `gunny/idle_4.ogg` | Weapons don't kill people. Bad odds do. | Idle chatter. Random. |
| 37 | [ ] | `gunny/buy_1.ogg` | Excellent! Point it away from yourself! | The player just bought something. |
| 38 | [ ] | `gunny/buy_2.ogg` | That's a classic. Respect it. | The player just bought something. |
| 39 | [ ] | `gunny/buy_3.ogg` | Eight out of ten customers survive. | The player just bought something. |
| 40 | [ ] | `gunny/buy_4.ogg` | Good choice, recruit. It kicks. | The player just bought something. |

### VELMA VELVET: 16 lines

Folder: `voice/velma/` (cutscene lines go in the folder shown). Voice: You are singing the last song of the night..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `velma/idle_1.ogg` | Honey, I've lost more than you've bet. | Idle chatter. Random. |
| 2 | [ ] | `velma/idle_2.ogg` | This next one's for the broken-hearted. And the broke. | Idle chatter. Random. |
| 3 | [ ] | `velma/idle_3.ogg` | Dim the lights. The odds are shy. | Idle chatter. Random. |
| 4 | [ ] | `velma/idle_4.ogg` | Last call for love. Everything's last call. | Idle chatter. Random. |
| 5 | [ ] | `velma/greet_1.ogg` | Evening, sugar. Pull up a shadow. | Greeting the player. In character. |
| 6 | [ ] | `velma/greet_2.ogg` | You look like a song I forgot the end of. | Greeting the player. In character. |
| 7 | [ ] | `velma/greet_3.ogg` | Take a seat. Take a chance. Take a breath. | Greeting the player. In character. |
| 8 | [ ] | `velma/farewell_1.ogg` | Don't be a stranger. Be a legend. | Parting words as the player leaves. |
| 9 | [ ] | `velma/farewell_2.ogg` | The stage'll be here. So will I. | Parting words as the player leaves. |
| 10 | [ ] | `velma/farewell_3.ogg` | Go. Win something. Lose something prettier. | Parting words as the player leaves. |
| 11 | [ ] | `velma/rich_1.ogg` | Oh, you're in the money. Sing with me. | The player is carrying a lot of money. |
| 12 | [ ] | `velma/rich_2.ogg` | Diamonds are a girl's best chips. | The player is carrying a lot of money. |
| 13 | [ ] | `velma/broke_1.ogg` | Broke and brave. My favorite lyric. | The player is nearly broke. |
| 14 | [ ] | `velma/broke_2.ogg` | Come sit. The blues are free. | The player is nearly broke. |
| 15 | [ ] | `velma/died_1.ogg` | I wrote a song about you. It's mostly a sigh. | The player just died. |
| 16 | [ ] | `velma/boss_1.ogg` | I'll sing about that one. Twice. | The player just beat a boss. |

### DUMPSTER DAN: 16 lines

Folder: `voice/dumpster_dan/` (cutscene lines go in the folder shown). Voice: Laugh at your own points, then cough..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `dumpster_dan/idle_1.ogg` | Got any change? Got any WISDOM? | Idle chatter. Random. |
| 2 | [ ] | `dumpster_dan/idle_2.ogg` | The rats pay rent. Do you? | Idle chatter. Random. |
| 3 | [ ] | `dumpster_dan/idle_3.ogg` | I used to teach economics. Now I eat economics. | Idle chatter. Random. |
| 4 | [ ] | `dumpster_dan/idle_4.ogg` | The walls have secrets. Some are loose. | Idle chatter. Random. |
| 5 | [ ] | `dumpster_dan/greet_1.ogg` | Hey there, friend. Spare a smile? | Greeting the player. In character. |
| 6 | [ ] | `dumpster_dan/greet_2.ogg` | Ooh, a visitor! Or a hallucination. Both are nice. | Greeting the player. In character. |
| 7 | [ ] | `dumpster_dan/greet_3.ogg` | You look like a man with a destiny and a wallet. | Greeting the player. In character. |
| 8 | [ ] | `dumpster_dan/farewell_1.ogg` | Come back when you're rich! Or me. | Parting words as the player leaves. |
| 9 | [ ] | `dumpster_dan/farewell_2.ogg` | Mind the third brick. It likes to move. | Parting words as the player leaves. |
| 10 | [ ] | `dumpster_dan/farewell_3.ogg` | Don't forget me. Everybody does. | Parting words as the player leaves. |
| 11 | [ ] | `dumpster_dan/rich_1.ogg` | Look at you! The Midas of the alley! | The player is carrying a lot of money. |
| 12 | [ ] | `dumpster_dan/rich_2.ogg` | That's more than I've seen since 1998. | The player is carrying a lot of money. |
| 13 | [ ] | `dumpster_dan/broke_1.ogg` | Ha! Welcome to the club. We've got cardboard. | The player is nearly broke. |
| 14 | [ ] | `dumpster_dan/broke_2.ogg` | Poor! It's honest. | The player is nearly broke. |
| 15 | [ ] | `dumpster_dan/died_1.ogg` | Don't worry. Death's mostly paperwork. | The player just died. |
| 16 | [ ] | `dumpster_dan/boss_1.ogg` | The boss? I raised him. He was a lovely child. | The player just beat a boss. |

### SLICK NICK: 17 lines

Folder: `voice/slick_nick/` (cutscene lines go in the folder shown). Voice: Wink with your voice..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `slick_nick/idle_1.ogg` | I'm smarter than you and twice as handsome. | Idle chatter. Random. |
| 2 | [ ] | `slick_nick/idle_2.ogg` | Luck? I don't need luck. I have hair. | Idle chatter. Random. |
| 3 | [ ] | `slick_nick/idle_3.ogg` | I read the odds. And then I rewrite them. | Idle chatter. Random. |
| 4 | [ ] | `slick_nick/idle_4.ogg` | Don't take it personally. Take it to the bank. | Idle chatter. Random. |
| 5 | [ ] | `slick_nick/greet_1.ogg` | Well, well. If it isn't my favorite sucker. | Greeting the player. In character. |
| 6 | [ ] | `slick_nick/greet_2.ogg` | Ah, the other gambler. Cute. | Greeting the player. In character. |
| 7 | [ ] | `slick_nick/greet_3.ogg` | Looking for a rival? You found one. I'm excellent. | Greeting the player. In character. |
| 8 | [ ] | `slick_nick/farewell_1.ogg` | Don't lose too early. I want to win later. | Parting words as the player leaves. |
| 9 | [ ] | `slick_nick/farewell_2.ogg` | See you at the top. I'll be there. First. | Parting words as the player leaves. |
| 10 | [ ] | `slick_nick/farewell_3.ogg` | Try not to embarrass yourself. I'll be watching. | Parting words as the player leaves. |
| 11 | [ ] | `slick_nick/rich_1.ogg` | Nice pot. I have a bigger one. I always have a bigger one. | The player is carrying a lot of money. |
| 12 | [ ] | `slick_nick/rich_2.ogg` | You're doing great! For you. | The player is carrying a lot of money. |
| 13 | [ ] | `slick_nick/broke_1.ogg` | Oof. Broke? Must be rough being you. | The player is nearly broke. |
| 14 | [ ] | `slick_nick/broke_2.ogg` | I'd buy you a drink. But no. | The player is nearly broke. |
| 15 | [ ] | `slick_nick/died_1.ogg` | You died? I won. Again. | The player just died. |
| 16 | [ ] | `slick_nick/boss_1.ogg` | A boss? I was about to do that. Today. | The player just beat a boss. |
| 17 | [ ] | `slick_nick/boss_2.ogg` | Lucky shot. Everyone's lucky once. | The player just beat a boss. |

### LADY LUCK LORRAINE: 16 lines

Folder: `voice/lorraine/` (cutscene lines go in the folder shown). Voice: Everything is a sign. Everything is bad luck..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `lorraine/idle_1.ogg` | Never cross your fingers. Cross a fortune-teller. | Idle chatter. Random. |
| 2 | [ ] | `lorraine/idle_2.ogg` | Don't whistle at a table. It summons the House. | Idle chatter. Random. |
| 3 | [ ] | `lorraine/idle_3.ogg` | A black cat? I own three. That's the secret. | Idle chatter. Random. |
| 4 | [ ] | `lorraine/idle_4.ogg` | Throw salt. Throw sage. Throw chips. | Idle chatter. Random. |
| 5 | [ ] | `lorraine/greet_1.ogg` | Oh honey! You're glowing! That's either luck or fever. | Greeting the player. In character. |
| 6 | [ ] | `lorraine/greet_2.ogg` | Come sit, sugar. The stars are loud tonight. | Greeting the player. In character. |
| 7 | [ ] | `lorraine/greet_3.ogg` | Wait, don't tell me. You're a Scorpio. Bad news. | Greeting the player. In character. |
| 8 | [ ] | `lorraine/farewell_1.ogg` | Knock on wood. Knock on your own head. | Parting words as the player leaves. |
| 9 | [ ] | `lorraine/farewell_2.ogg` | Take my lucky penny. It's cursed. You'll love it. | Parting words as the player leaves. |
| 10 | [ ] | `lorraine/farewell_3.ogg` | Go with God. And with a rabbit's foot. | Parting words as the player leaves. |
| 11 | [ ] | `lorraine/rich_1.ogg` | Money! It's a sign! A big sign! | The player is carrying a lot of money. |
| 12 | [ ] | `lorraine/rich_2.ogg` | You're blessed. Or cursed. Same sparkle. | The player is carrying a lot of money. |
| 13 | [ ] | `lorraine/broke_1.ogg` | Broke? That's just Mercury being rude. | The player is nearly broke. |
| 14 | [ ] | `lorraine/broke_2.ogg` | Poor baby. Retrograde again. | The player is nearly broke. |
| 15 | [ ] | `lorraine/died_1.ogg` | Dying? Bad omen. I'll light a candle. | The player just died. |
| 16 | [ ] | `lorraine/boss_1.ogg` | A boss? Mercury's with you! | The player just beat a boss. |

### OFFICER DUNN: 16 lines

Folder: `voice/dunn/` (cutscene lines go in the folder shown). Voice: Say everything like reading the same warning for the 800th time..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `dunn/idle_1.ogg` | Sir, you can't do that here. | Idle chatter. Random. |
| 2 | [ ] | `dunn/idle_2.ogg` | I'm just doing my job. Which is you. | Idle chatter. Random. |
| 3 | [ ] | `dunn/idle_3.ogg` | Please keep your hands where I can see them. And your chips. | Idle chatter. Random. |
| 4 | [ ] | `dunn/idle_4.ogg` | Management reserves the right to refuse. Everything. | Idle chatter. Random. |
| 5 | [ ] | `dunn/greet_1.ogg` | Evening, sir. Behave. | Greeting the player. In character. |
| 6 | [ ] | `dunn/greet_2.ogg` | ID, please. And your life story. | Greeting the player. In character. |
| 7 | [ ] | `dunn/greet_3.ogg` | Move along, citizen. Or stand still. I'm confused. | Greeting the player. In character. |
| 8 | [ ] | `dunn/farewell_1.ogg` | Have a nice day. Or don't. It's not my department. | Parting words as the player leaves. |
| 9 | [ ] | `dunn/farewell_2.ogg` | Exit's that way. Not that way. That way. | Parting words as the player leaves. |
| 10 | [ ] | `dunn/farewell_3.ogg` | Enjoy your stay. Quietly. | Parting words as the player leaves. |
| 11 | [ ] | `dunn/rich_1.ogg` | That's a lot of money, sir. I'll be watching. | The player is carrying a lot of money. |
| 12 | [ ] | `dunn/rich_2.ogg` | Winning is fine. Winning loudly is a violation. | The player is carrying a lot of money. |
| 13 | [ ] | `dunn/broke_1.ogg` | No funds? The exit's that way. | The player is nearly broke. |
| 14 | [ ] | `dunn/broke_2.ogg` | Loitering without chips is discouraged. | The player is nearly broke. |
| 15 | [ ] | `dunn/died_1.ogg` | Sir, you can't die here. It's against policy. | The player just died. |
| 16 | [ ] | `dunn/boss_1.ogg` | You hit a boss? That's... that's an incident. | The player just beat a boss. |

### THE HOUSE: 57 lines

Folder: `voice/the_house/` (cutscene lines go in the folder shown). Voice: Say it like you are reading terms and conditions to a prisoner..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `the_house/intro_1.ogg` | Hole cards. Flop. Turn. River. And at the end, the House always wins. | Boss intro cutscene. Menacing. Texas Hold'em themed. |
| 2 | [ ] | `the_house/defeat_1.ogg` | The House... folds? | Boss defeat. Falling apart. |
| 3 | [ ] | `the_house/phase2_1.ogg` | Interesting. The odds adjust. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `the_house/phase3_1.ogg` | I do not lose. I RESET. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `the_house/taunt_1.ogg` | Hole cards. Flop. Turn. River. | Boss taunt during an attack. |
| 6 | [ ] | `the_house/taunt_2.ogg` | The House always wins. It's not a boast. It's arithmetic. | Boss taunt during an attack. |
| 7 | [ ] | `the_house/taunt_3.ogg` | Every chip you hold is already mine. | Boss taunt during an attack. |
| 8 | [ ] | `the_house/hurt_1.ogg` | A scratch. The House endures. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `the_house/hurt_2.ogg` | That was... noted. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `the_house/kill_1.ogg` | You've been folded. | Boss kills the player. Gloating. |
| 11 | [ ] | `the_house/kill_2.ogg` | Terms and conditions apply. | Boss kills the player. Gloating. |
| 12 | [ ] | `_cutscenes/city5_arrive/city5_arrive_3.ogg` | Welcome, Rico. We've been expecting you. For years. | Cutscene: city5 arrive |
| 13 | [ ] | `_cutscenes/final_prelude/final_prelude_1.ogg` | You climbed my five cities. You beat my table-lords. You wore my clothes. | Cutscene: final prelude |
| 14 | [ ] | `_cutscenes/final_prelude/final_prelude_3.ogg` | Then sit. Hole cards. Flop. Turn. River. | Cutscene: final prelude |
| 15 | [ ] | `_cutscenes/intro/intro_4.ogg` | Welcome, valued guest. House rules: no one dies owing the House. Bust, and you wake up right here. With interest. | Cutscene: intro |
| 16 | [ ] | `_cutscenes/intro/intro_6.ogg` | Now you're getting it. | Cutscene: intro |
| 17 | [ ] | `_cutscenes/true_ending/true_ending_1.ogg` | Again? You beat me AGAIN? Fine. Double or nothing. One more hand. | Cutscene: true ending |
| 18 | [ ] | `_cutscenes/true_ending/true_ending_3.ogg` | ...Nobody has called me that in twenty years. | Cutscene: true ending |
| 19 | [ ] | `_cutscenes/true_ending/true_ending_5.ogg` | If I stop playing... what's left of me? | Cutscene: true ending |
| 20 | [ ] | `_cutscenes/true_ending/true_ending_7.ogg` | ...Cashing out. Huh. It feels like falling. The good kind. | Cutscene: true ending |
| 21 | [ ] | `the_house/pa_lobby_1.ogg` | Welcome to the Lobby of The Pit. Your Marker is our pleasure. | PA announcement. Polite, chilling. |
| 22 | [ ] | `the_house/pa_lobby_2.ogg` | No one dies owing the House. That would be bad for business. | PA announcement. Polite, chilling. |
| 23 | [ ] | `the_house/pa_wake_1.ogg` | Welcome back, valued guest. Your tab has been adjusted. | PA announcement. Polite, chilling. |
| 24 | [ ] | `the_house/pa_wake_2.ogg` | Back so soon? The House never forgets a debtor. | PA announcement. Polite, chilling. |
| 25 | [ ] | `the_house/pa_wake_3.ogg` | Interest applied. Smile, it's compounding. | PA announcement. Polite, chilling. |
| 26 | [ ] | `the_house/pa_wake_spikes_1.ogg` | Attention guests: Rico was defeated by a spike. The spike's drinks are on the house. | PA announcement. Polite, chilling. |
| 27 | [ ] | `the_house/pa_wake_guard_1.ogg` | Security reminds guests that punching is a privilege, not a right. | PA announcement. Polite, chilling. |
| 28 | [ ] | `the_house/pa_wake_bat_1.ogg` | The bats thank you for your generous contribution. | PA announcement. Polite, chilling. |
| 29 | [ ] | `the_house/pa_wake_boss1_1.ogg` | Big Sal sends his regards. And an invoice. | PA announcement. Polite, chilling. |
| 30 | [ ] | `the_house/pa_wake_boss2_1.ogg` | Madame Roulette spun. You lost. Round and round we go. | PA announcement. Polite, chilling. |
| 31 | [ ] | `the_house/pa_wake_boss3_1.ogg` | So close. The House admires ambition. The House also keeps it. | PA announcement. Polite, chilling. |
| 32 | [ ] | `the_house/pa_wake_mags_1.ogg` | Our partners in lending thank you for your patience. | PA announcement. Polite, chilling. |
| 33 | [ ] | `the_house/pa_wake_big_1.ogg` | That Pot was beautiful. It's mine now. Thank you. | PA announcement. Polite, chilling. |
| 34 | [ ] | `the_house/pa_start_1.ogg` | Doors are open. Mind the spikes. Or don't. | PA announcement. Polite, chilling. |
| 35 | [ ] | `the_house/pa_start_2.ogg` | Another guest descends. How wonderful for me. | PA announcement. Polite, chilling. |
| 36 | [ ] | `the_house/pa_ride_1.ogg` | Let it ride? Oh, I LIKE you. | PA announcement. Polite, chilling. |
| 37 | [ ] | `the_house/pa_ride_2.ogg` | Bold. The House adores bold. | PA announcement. Polite, chilling. |
| 38 | [ ] | `the_house/pa_ride8_1.ogg` | Attention guests: we have a high roller on the floor! | PA announcement. Polite, chilling. |
| 39 | [ ] | `the_house/pa_cashout_1.ogg` | Playing it safe. How... responsible. Ugh. | PA announcement. Polite, chilling. |
| 40 | [ ] | `the_house/pa_cashout_2.ogg` | Walking away? The House will remember this. | PA announcement. Polite, chilling. |
| 41 | [ ] | `the_house/pa_jackpot_1.ogg` | Who rigged that machine? WHO RIGGED THAT MACHINE? | PA announcement. Polite, chilling. |
| 42 | [ ] | `the_house/pa_low_hp_1.ogg` | One life left. The House recommends praying. | PA announcement. Polite, chilling. |
| 43 | [ ] | `the_house/pa_low_hp_2.ogg` | Feeling lucky? You shouldn't. | PA announcement. Polite, chilling. |
| 44 | [ ] | `the_house/pa_boss_1.ogg` | Ladies and gentlemen... the main event. | PA announcement. Polite, chilling. |
| 45 | [ ] | `the_house/pa_vault_open_1.ogg` | Somebody check the vault. WHY IS THE VAULT OPEN. | PA announcement. Polite, chilling. |
| 46 | [ ] | `the_house/pa_vault_miss_1.ogg` | The vault has sealed. Punctuality is a virtue, guest. | PA announcement. Polite, chilling. |
| 47 | [ ] | `the_house/pa_loan_due_1.ogg` | Attention guests: a loan is past due. Please keep hands and feet inside the Pit. | PA announcement. Polite, chilling. |
| 48 | [ ] | `the_house/pa_spill_1.ogg` | Butterfingers! | PA announcement. Polite, chilling. |
| 49 | [ ] | `the_house/pa_spill_2.ogg` | Chips on the floor! Finders keepers. | PA announcement. Polite, chilling. |
| 50 | [ ] | `the_house/pa_bet_won_1.ogg` | A side bet paid out. The House is fine. Totally fine. | PA announcement. Polite, chilling. |
| 51 | [ ] | `the_house/pa_bet_lost_1.ogg` | Side bet lost. Tragic. Delicious. | PA announcement. Polite, chilling. |
| 52 | [ ] | `the_house/pa_cat_1.ogg` | Please do not pet the cat. The cat is a House employee. | PA announcement. Polite, chilling. |
| 53 | [ ] | `the_house/pa_cat_2.ogg` | The cat likes you. The cat is wrong. | PA announcement. Polite, chilling. |
| 54 | [ ] | `the_house/pa_daily_1.ogg` | Today's Daily Deal: the same cards for everyone. Fairness! How quaint. | PA announcement. Polite, chilling. |
| 55 | [ ] | `the_house/pa_stakes_1.ogg` | Raising the stakes? The House salutes your poor judgment. | PA announcement. Polite, chilling. |
| 56 | [ ] | `the_house/pa_ticket_1.ogg` | Littering is a violation of House policy. Reading it is worse. | PA announcement. Polite, chilling. |
| 57 | [ ] | `the_house/pa_charm_1.ogg` | A charm? Cute. The House has charms too. They're called interest rates. | PA announcement. Polite, chilling. |

### DRAFTQUEENS: 11 lines

Folder: `voice/draftqueens/` (cutscene lines go in the folder shown). Voice: Every line ends with a finger snap you cannot hear..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `draftqueens/intro_1.ogg` | Five cards. Discard what you don't like. I'll start with YOU. | Boss intro cutscene. Menacing. Five Card Draw themed. |
| 2 | [ ] | `draftqueens/defeat_1.ogg` | A... pat hand. I had a pat hand. | Boss defeat. Falling apart. |
| 3 | [ ] | `draftqueens/phase2_1.ogg` | Discard? Honey, I'm just getting started. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `draftqueens/phase3_1.ogg` | Oh, now it's personal. Five of a kind, bitch. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `draftqueens/taunt_1.ogg` | Is that the best you can draw? | Boss taunt during an attack. |
| 6 | [ ] | `draftqueens/taunt_2.ogg` | I read you at the flop. You looked boring. | Boss taunt during an attack. |
| 7 | [ ] | `draftqueens/taunt_3.ogg` | Cards don't lie. Neither does my eyeliner. | Boss taunt during an attack. |
| 8 | [ ] | `draftqueens/hurt_1.ogg` | Ow! That's a three-hundred-dollar blazer! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `draftqueens/hurt_2.ogg` | Not the hair! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `draftqueens/kill_1.ogg` | Better luck next time, sweetie. | Boss kills the player. Gloating. |
| 11 | [ ] | `draftqueens/kill_2.ogg` | That's a fold. Pack it up. | Boss kills the player. Gloating. |

### FANDOOL: 11 lines

Folder: `voice/fandool/` (cutscene lines go in the folder shown). Voice: Yell every third word like a replay is on..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `fandool/intro_1.ogg` | Three down, four up. Everything you do is face up, pal. | Boss intro cutscene. Menacing. Seven Card Stud themed. |
| 2 | [ ] | `fandool/defeat_1.ogg` | The river... wasn't supposed to... bleed. | Boss defeat. Falling apart. |
| 3 | [ ] | `fandool/phase2_1.ogg` | Now it's a REAL game! | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `fandool/phase3_1.ogg` | FINAL QUARTER! LET'S GOOOOO! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `fandool/taunt_1.ogg` | Everything's face up, buddy! | Boss taunt during an attack. |
| 6 | [ ] | `fandool/taunt_2.ogg` | I've seen your hole cards. They're shaking. | Boss taunt during an attack. |
| 7 | [ ] | `fandool/taunt_3.ogg` | Replay that! Replay it! | Boss taunt during an attack. |
| 8 | [ ] | `fandool/hurt_1.ogg` | Foul! That's a foul! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `fandool/hurt_2.ogg` | REF! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `fandool/kill_1.ogg` | Another one bites the dust! | Boss kills the player. Gloating. |
| 11 | [ ] | `fandool/kill_2.ogg` | Sudden death. For you. | Boss kills the player. Gloating. |

### POKERSTARZ: 11 lines

Folder: `voice/pokerstarz/` (cutscene lines go in the folder shown). Voice: End statements like questions. Sigh a lot..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `pokerstarz/intro_1.ogg` | Four hole cards. You must use exactly two. Good luck with the other two. | Boss intro cutscene. Menacing. Omaha Hi-Lo themed. |
| 2 | [ ] | `pokerstarz/defeat_1.ogg` | Split pot... I get nothing. | Boss defeat. Falling apart. |
| 3 | [ ] | `pokerstarz/phase2_1.ogg` | Okay, that actually hurt. Smash that like button. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `pokerstarz/phase3_1.ogg` | Chat, he's cheating! Ban him! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `pokerstarz/taunt_1.ogg` | Four hole cards. You have none. | Boss taunt during an attack. |
| 6 | [ ] | `pokerstarz/taunt_2.ogg` | Don't forget to subscribe to my wins. | Boss taunt during an attack. |
| 7 | [ ] | `pokerstarz/taunt_3.ogg` | This is content. You're content. | Boss taunt during an attack. |
| 8 | [ ] | `pokerstarz/hurt_1.ogg` | Rude. I'm demonetized. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `pokerstarz/hurt_2.ogg` | Oh my god, stop. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `pokerstarz/kill_1.ogg` | GG. No re. | Boss kills the player. Gloating. |
| 11 | [ ] | `pokerstarz/kill_2.ogg` | That's the clip of the day. | Boss kills the player. Gloating. |

### BETMGN: 11 lines

Folder: `voice/betmgn/` (cutscene lines go in the folder shown). Voice: Talk like every sentence has a trademark symbol..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `betmgn/intro_1.ogg` | Three cards. Ante up. Quick, it's over fast. | Boss intro cutscene. Menacing. Three Card Poker themed. |
| 2 | [ ] | `betmgn/defeat_1.ogg` | Queen high... of course. | Boss defeat. Falling apart. |
| 3 | [ ] | `betmgn/phase2_1.ogg` | Alright, let's raise the ante. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `betmgn/phase3_1.ogg` | Three cards. Three seconds. You're done. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `betmgn/taunt_1.ogg` | Pair plus? Pair minus. | Boss taunt during an attack. |
| 6 | [ ] | `betmgn/taunt_2.ogg` | Ante up, folks! | Boss taunt during an attack. |
| 7 | [ ] | `betmgn/taunt_3.ogg` | That's a Straight Flush of bad ideas. | Boss taunt during an attack. |
| 8 | [ ] | `betmgn/hurt_1.ogg` | Ouch! That's a bad beat! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `betmgn/hurt_2.ogg` | No no no, my commission! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `betmgn/kill_1.ogg` | Quick, wasn't it? | Boss kills the player. Gloating. |
| 11 | [ ] | `betmgn/kill_2.ogg` | The house edge says hi. | Boss kills the player. Gloating. |

### STEAKE.COM: 11 lines

Folder: `voice/steake/` (cutscene lines go in the folder shown). Voice: Say 'to the moon' with your whole chest, even when it makes no sense..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `steake/intro_1.ogg` | In Razz the worst hand wins. You should fit right in. | Boss intro cutscene. Menacing. Razz themed. |
| 2 | [ ] | `steake/defeat_1.ogg` | A wheel... the best of the worst. Nice. | Boss defeat. Falling apart. |
| 3 | [ ] | `steake/phase2_1.ogg` | Nice hit. We're STILL going to the moon. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `steake/phase3_1.ogg` | To the MOOOON! Or the floor! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `steake/taunt_1.ogg` | Worst hand wins, friend. Congrats on yours. | Boss taunt during an attack. |
| 6 | [ ] | `steake/taunt_2.ogg` | Diamond hands! Diamond everything! | Boss taunt during an attack. |
| 7 | [ ] | `steake/taunt_3.ogg` | Not financial advice. But you're done. | Boss taunt during an attack. |
| 8 | [ ] | `steake/hurt_1.ogg` | Buy the dip! Oh, that's me. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `steake/hurt_2.ogg` | Rug pull! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `steake/kill_1.ogg` | HODL this, loser. | Boss kills the player. Gloating. |
| 11 | [ ] | `steake/kill_2.ogg` | Liquidated. | Boss kills the player. Gloating. |

### BOVADOH: 11 lines

Folder: `voice/bovadoh/` (cutscene lines go in the folder shown). Voice: Be bored. Boredom is scarier than shouting..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `bovadoh/intro_1.ogg` | Seven cards, two hands. Beat both or push. You will push. Into a wall. | Boss intro cutscene. Menacing. Pai Gow themed. |
| 2 | [ ] | `bovadoh/defeat_1.ogg` | Both hands... lost. Impossible. | Boss defeat. Falling apart. |
| 3 | [ ] | `bovadoh/phase2_1.ogg` | ...Impressive. Marginally. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `bovadoh/phase3_1.ogg` | Both hands. Now. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `bovadoh/taunt_1.ogg` | Two hands. Two defeats. Do the math. | Boss taunt during an attack. |
| 6 | [ ] | `bovadoh/taunt_2.ogg` | You push, I take. | Boss taunt during an attack. |
| 7 | [ ] | `bovadoh/taunt_3.ogg` | Dull. Everything's dull. You, too. | Boss taunt during an attack. |
| 8 | [ ] | `bovadoh/hurt_1.ogg` | Hm. That stung. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `bovadoh/hurt_2.ogg` | Interesting. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `bovadoh/kill_1.ogg` | Predictable. | Boss kills the player. Gloating. |
| 11 | [ ] | `bovadoh/kill_2.ogg` | As expected. | Boss kills the player. Gloating. |

### SEEZER'S CLUB: 11 lines

Folder: `voice/seezers/` (cutscene lines go in the folder shown). Voice: Say everything like a toga is flowing behind you..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `seezers/intro_1.ogg` | Dealer stands on 17. I never stand. Not for you. | Boss intro cutscene. Menacing. Blackjack themed. |
| 2 | [ ] | `seezers/defeat_1.ogg` | Twenty-two. I busted. How embarrassing. | Boss defeat. Falling apart. |
| 3 | [ ] | `seezers/phase2_1.ogg` | You have wounded Caesar. Splendid. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `seezers/phase3_1.ogg` | THIS IS THE END OF THE EMPIRE! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `seezers/taunt_1.ogg` | Dealer stands. YOU do not. | Boss taunt during an attack. |
| 6 | [ ] | `seezers/taunt_2.ogg` | I'd hit you on 16. | Boss taunt during an attack. |
| 7 | [ ] | `seezers/taunt_3.ogg` | Et tu, gambler? | Boss taunt during an attack. |
| 8 | [ ] | `seezers/hurt_1.ogg` | A mere scratch on the marble! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `seezers/hurt_2.ogg` | By Jupiter! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `seezers/kill_1.ogg` | Veni, vidi, bust. | Boss kills the player. Gloating. |
| 11 | [ ] | `seezers/kill_2.ogg` | Hail, Caesar. And farewell. | Boss kills the player. Gloating. |

### WYNNER'S CIRCLE: 11 lines

Folder: `voice/wynners/` (cutscene lines go in the folder shown). Voice: Sniff once per sentence like the room smells poor..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `wynners/intro_1.ogg` | Punto. Banco. Tie. Always a tie: you lose either way. | Boss intro cutscene. Menacing. Baccarat themed. |
| 2 | [ ] | `wynners/defeat_1.ogg` | Natural nine... and still I fall. | Boss defeat. Falling apart. |
| 3 | [ ] | `wynners/phase2_1.ogg` | A natural eight. Perhaps it's your turn. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `wynners/phase3_1.ogg` | Banker. Player. Tie. Doom. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `wynners/taunt_1.ogg` | The shoe is cold. The room is colder. | Boss taunt during an attack. |
| 6 | [ ] | `wynners/taunt_2.ogg` | Place your bets on the inevitable. | Boss taunt during an attack. |
| 7 | [ ] | `wynners/taunt_3.ogg` | Pinky out, darling. This will hurt. | Boss taunt during an attack. |
| 8 | [ ] | `wynners/hurt_1.ogg` | How... rude. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `wynners/hurt_2.ogg` | Mon Dieu. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `wynners/kill_1.ogg` | The Circle closes. Again. | Boss kills the player. Gloating. |
| 11 | [ ] | `wynners/kill_2.ogg` | Adieu. | Boss kills the player. Gloating. |

### SNAKE EYES SAL: 11 lines

Folder: `voice/snake_eyes/` (cutscene lines go in the folder shown). Voice: Hiss and click your tongue between lines..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `snake_eyes/intro_1.ogg` | Seven, you lose. Eleven, you lose. Everything's a lose. | Boss intro cutscene. Menacing. Craps themed. |
| 2 | [ ] | `snake_eyes/defeat_1.ogg` | Boxcars... on my own roll. | Boss defeat. Falling apart. |
| 3 | [ ] | `snake_eyes/phase2_1.ogg` | Boxcars! BOXCARS! | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `snake_eyes/phase3_1.ogg` | Natural! Natural! You hear that? | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `snake_eyes/taunt_1.ogg` | Seven! You lose! | Boss taunt during an attack. |
| 6 | [ ] | `snake_eyes/taunt_2.ogg` | Snake eyes! Ssssnake EYES! | Boss taunt during an attack. |
| 7 | [ ] | `snake_eyes/taunt_3.ogg` | Come out roll! Come OUT! | Boss taunt during an attack. |
| 8 | [ ] | `snake_eyes/hurt_1.ogg` | Hsss! Careful! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `snake_eyes/hurt_2.ogg` | Ow, ow, ow! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `snake_eyes/kill_1.ogg` | Sevennn! | Boss kills the player. Gloating. |
| 11 | [ ] | `snake_eyes/kill_2.ogg` | House pays. House always pays. | Boss kills the player. Gloating. |

### ONE-ARMED BANDIT: 11 lines

Folder: `voice/rusty_slots/` (cutscene lines go in the folder shown). Voice: Cheerful voice, dead eyes, glitches in the middle of words..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `rusty_slots/intro_1.ogg` | Pull my arm. Go on. I dare you. | Boss intro cutscene. Menacing. The Slot Machine themed. |
| 2 | [ ] | `rusty_slots/defeat_1.ogg` | Jackpot... for YOU? | Boss defeat. Falling apart. |
| 3 | [ ] | `rusty_slots/phase2_1.ogg` | JACKPOT. JACKPOT. JACKPOT. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `rusty_slots/phase3_1.ogg` | ERROR. ERROR. LUCKY SEVEN. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `rusty_slots/taunt_1.ogg` | Insert coin to continue dying. | Boss taunt during an attack. |
| 6 | [ ] | `rusty_slots/taunt_2.ogg` | Spin. Spin. Spin. | Boss taunt during an attack. |
| 7 | [ ] | `rusty_slots/taunt_3.ogg` | Pull my arm. Go on. I dare you. | Boss taunt during an attack. |
| 8 | [ ] | `rusty_slots/hurt_1.ogg` | BZZZT. Ow. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `rusty_slots/hurt_2.ogg` | Tilt. Tilt. Tilt. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `rusty_slots/kill_1.ogg` | Three bars. You lose. | Boss kills the player. Gloating. |
| 11 | [ ] | `rusty_slots/kill_2.ogg` | OUT OF ORDER. | Boss kills the player. Gloating. |

### MR. LUCKY: 11 lines

Folder: `voice/mr_lucky/` (cutscene lines go in the folder shown). Voice: Everything you say starts nice and turns evil on the last word..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `mr_lucky/intro_1.ogg` | Pick eighty numbers. You'll hit none. I'm Mr. Lucky. | Boss intro cutscene. Menacing. Keno themed. |
| 2 | [ ] | `mr_lucky/defeat_1.ogg` | Eighty out of eighty... how? | Boss defeat. Falling apart. |
| 3 | [ ] | `mr_lucky/phase2_1.ogg` | My, my. You ARE lucky. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `mr_lucky/phase3_1.ogg` | Now, now. Pick a number. Any number. Wrong. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `mr_lucky/taunt_1.ogg` | Pick eighty numbers. Hit none. | Boss taunt during an attack. |
| 6 | [ ] | `mr_lucky/taunt_2.ogg` | Luck is just a lie told by the winning. | Boss taunt during an attack. |
| 7 | [ ] | `mr_lucky/taunt_3.ogg` | Are you having fun? You will. | Boss taunt during an attack. |
| 8 | [ ] | `mr_lucky/hurt_1.ogg` | Ow! Oh dear. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `mr_lucky/hurt_2.ogg` | That was unkind. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `mr_lucky/kill_1.ogg` | Never lucky. Always careful. | Boss kills the player. Gloating. |
| 11 | [ ] | `mr_lucky/kill_2.ogg` | Better luck next time. Always. | Boss kills the player. Gloating. |

### TOURIST: 22 lines

Folder: `voice/tourist/` (cutscene lines go in the folder shown). Voice: Everything you say is a question. All of them too loud..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `tourist/bark_1.ogg` | Is this the buffet? | Random crowd bark, any city. |
| 2 | [ ] | `tourist/bark_2.ogg` | Honey! Come look! Slot machines! | Random crowd bark, any city. |
| 3 | [ ] | `tourist/bark_3.ogg` | Does the free drink come with an umbrella? | Random crowd bark, any city. |
| 4 | [ ] | `tourist/bark_4.ogg` | I lost five dollars! I'm RUINED! | Random crowd bark, any city. |
| 5 | [ ] | `tourist/bark_5.ogg` | Wait, is it a one-armed bandit or a no-armed bandit? | Random crowd bark, any city. |
| 6 | [ ] | `tourist/bark_6.ogg` | Hey, buddy! Which way to the pool? | Random crowd bark, any city. |
| 7 | [ ] | `tourist/bark_7.ogg` | I've never seen so many lights in my life! | Random crowd bark, any city. |
| 8 | [ ] | `tourist/bark_8.ogg` | Can I pay with a coupon? | Random crowd bark, any city. |
| 9 | [ ] | `tourist/bark_9.ogg` | Where's the fountain? Is that it? It's very small. | Random crowd bark, any city. |
| 10 | [ ] | `tourist/bark_10.ogg` | Why is everyone so serious? | Random crowd bark, any city. |
| 11 | [ ] | `tourist/bark_11.ogg` | My husband is in a coma at the roulette table. | Random crowd bark, any city. |
| 12 | [ ] | `tourist/bark_12.ogg` | It's so clean! Except for that. | Random crowd bark, any city. |
| 13 | [ ] | `tourist/city1_1.ogg` | The boardwalk smells like regret and funnel cake. | Crowd bark flavored for city 1. |
| 14 | [ ] | `tourist/city1_7.ogg` | Don't drink the water. Don't drink the drinks. | Crowd bark flavored for city 1. |
| 15 | [ ] | `tourist/city2_1.ogg` | Reno! The biggest little city with the smallest chances. | Crowd bark flavored for city 2. |
| 16 | [ ] | `tourist/city2_7.ogg` | Come see the world's smallest elephant. It's a dog. | Crowd bark flavored for city 2. |
| 17 | [ ] | `tourist/city3_1.ogg` | Biloxi! Where the sharks are gentlemen. | Crowd bark flavored for city 3. |
| 18 | [ ] | `tourist/city3_7.ogg` | Everybody here lost their voice. | Crowd bark flavored for city 3. |
| 19 | [ ] | `tourist/city4_1.ogg` | Fremont! Old Vegas! Old money! Old vice! | Crowd bark flavored for city 4. |
| 20 | [ ] | `tourist/city4_7.ogg` | I lost a gold bar. I wasn't even playing. | Crowd bark flavored for city 4. |
| 21 | [ ] | `tourist/city5_1.ogg` | The Strip! The nicest casino in the nicest town! | Crowd bark flavored for city 5. |
| 22 | [ ] | `tourist/city5_7.ogg` | Sir, this is a Wendy's. Just kidding. It's a palace. | Crowd bark flavored for city 5. |

### JUNKIE: 22 lines

Folder: `voice/junkie/` (cutscene lines go in the folder shown). Voice: Run out of breath at the end of every sentence..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `junkie/bark_1.ogg` | You got a... you got a dollar? | Random crowd bark, any city. |
| 2 | [ ] | `junkie/bark_2.ogg` | I swear I put it somewhere... somewhere. | Random crowd bark, any city. |
| 3 | [ ] | `junkie/bark_3.ogg` | Don't tell them I'm here. Don't tell them anything. | Random crowd bark, any city. |
| 4 | [ ] | `junkie/bark_4.ogg` | I'm fine. I'm just... resting. | Random crowd bark, any city. |
| 5 | [ ] | `junkie/bark_5.ogg` | Hey. Hey. Do you hear the bugs? | Random crowd bark, any city. |
| 6 | [ ] | `junkie/bark_6.ogg` | I've got nine lives. Six of them are used. | Random crowd bark, any city. |
| 7 | [ ] | `junkie/bark_7.ogg` | The walls are breathing. Nice walls. | Random crowd bark, any city. |
| 8 | [ ] | `junkie/bark_8.ogg` | Got a light? Got a... got a fix? | Random crowd bark, any city. |
| 9 | [ ] | `junkie/bark_9.ogg` | Whoa. Where'd you come from? | Random crowd bark, any city. |
| 10 | [ ] | `junkie/bark_10.ogg` | I'm clean. Mostly. Sort of. | Random crowd bark, any city. |
| 11 | [ ] | `junkie/bark_11.ogg` | Everything's shiny. Everything's shiny! | Random crowd bark, any city. |
| 12 | [ ] | `junkie/bark_12.ogg` | Shh. The floor is listening. | Random crowd bark, any city. |
| 13 | [ ] | `junkie/city1_2.ogg` | Atlantic Shitty, where dreams go to evaporate. | Crowd bark flavored for city 1. |
| 14 | [ ] | `junkie/city1_8.ogg` | Welcome to Resortz. Lower your standards. | Crowd bark flavored for city 1. |
| 15 | [ ] | `junkie/city2_2.ogg` | Cirrcus Cirrcus: where the clowns run the tables. | Crowd bark flavored for city 2. |
| 16 | [ ] | `junkie/city2_8.ogg` | I'm a clown. I'm sad. I'm broke. | Crowd bark flavored for city 2. |
| 17 | [ ] | `junkie/city3_2.ogg` | Hard Rok: it's loud, it's pricey, it's a guitar. | Crowd bark flavored for city 3. |
| 18 | [ ] | `junkie/city3_8.ogg` | I came for the show. I stayed for the cover charge. | Crowd bark flavored for city 3. |
| 19 | [ ] | `junkie/city4_2.ogg` | The Goldun Nugget's got a shark tank. It's decorative. | Crowd bark flavored for city 4. |
| 20 | [ ] | `junkie/city4_8.ogg` | A glass of champagne? That's a hundred. Please. | Crowd bark flavored for city 4. |
| 21 | [ ] | `junkie/city5_2.ogg` | The Bellagiro fountain! It dances! It judges! | Crowd bark flavored for city 5. |
| 22 | [ ] | `junkie/city5_8.ogg` | The chandelier is a quarter-million. Don't sneeze. | Crowd bark flavored for city 5. |

### PIT BOSS: 22 lines

Folder: `voice/pitboss/` (cutscene lines go in the folder shown). Voice: Say it like you've said it 10,000 times..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `pitboss/bark_1.ogg` | Place your bets. | Random crowd bark, any city. |
| 2 | [ ] | `pitboss/bark_2.ogg` | Cards on the table. Hands where I can see 'em. | Random crowd bark, any city. |
| 3 | [ ] | `pitboss/bark_3.ogg` | No cameras. No phones. No joy. | Random crowd bark, any city. |
| 4 | [ ] | `pitboss/bark_4.ogg` | Watch your chips, sir. | Random crowd bark, any city. |
| 5 | [ ] | `pitboss/bark_5.ogg` | That's a violation. And a threat. | Random crowd bark, any city. |
| 6 | [ ] | `pitboss/bark_6.ogg` | Pit to floor, we have a loser. | Random crowd bark, any city. |
| 7 | [ ] | `pitboss/bark_7.ogg` | Please keep the noise to a minimum. | Random crowd bark, any city. |
| 8 | [ ] | `pitboss/bark_8.ogg` | That table's closed. Permanently. | Random crowd bark, any city. |
| 9 | [ ] | `pitboss/bark_9.ogg` | The House appreciates your patronage. | Random crowd bark, any city. |
| 10 | [ ] | `pitboss/bark_10.ogg` | All bets are final. Unlike your life. | Random crowd bark, any city. |
| 11 | [ ] | `pitboss/bark_11.ogg` | Don't make me call the floor. | Random crowd bark, any city. |
| 12 | [ ] | `pitboss/bark_12.ogg` | Sir, that was a poor decision. | Random crowd bark, any city. |
| 13 | [ ] | `pitboss/city1_3.ogg` | I lost my retirement on a slot shaped like a lobster. | Crowd bark flavored for city 1. |
| 14 | [ ] | `pitboss/city1_9.ogg` | A mascot ate my sandwich. | Crowd bark flavored for city 1. |
| 15 | [ ] | `pitboss/city2_3.ogg` | I lost a bet to a juggler. | Crowd bark flavored for city 2. |
| 16 | [ ] | `pitboss/city2_9.ogg` | The cotton candy is a lie. | Crowd bark flavored for city 2. |
| 17 | [ ] | `pitboss/city3_3.ogg` | I paid fifteen bucks for a pick. I don't play. | Crowd bark flavored for city 3. |
| 18 | [ ] | `pitboss/city3_9.ogg` | Rock and roll never dies. My bankroll did. | Crowd bark flavored for city 3. |
| 19 | [ ] | `pitboss/city4_3.ogg` | Gold! Everything's gold! Even the toilets! | Crowd bark flavored for city 4. |
| 20 | [ ] | `pitboss/city4_9.ogg` | Welcome to the old days. They weren't better. | Crowd bark flavored for city 4. |
| 21 | [ ] | `pitboss/city5_3.ogg` | I lost a diamond ring on a hand of blackjack. | Crowd bark flavored for city 5. |
| 22 | [ ] | `pitboss/city5_9.ogg` | Welcome to the top. It's lonely. | Crowd bark flavored for city 5. |

### DRUNK: 22 lines

Folder: `voice/drunk/` (cutscene lines go in the folder shown). Voice: Hiccup mid-word. Cry a little..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `drunk/bark_1.ogg` | I love you, man. I love everybody! | Random crowd bark, any city. |
| 2 | [ ] | `drunk/bark_2.ogg` | Shhhh. The slot machine is sleeping. | Random crowd bark, any city. |
| 3 | [ ] | `drunk/bark_3.ogg` | I'm not drunk. The floor is spinning. | Random crowd bark, any city. |
| 4 | [ ] | `drunk/bark_4.ogg` | One more. Just one more. Hic. | Random crowd bark, any city. |
| 5 | [ ] | `drunk/bark_5.ogg` | Where's my wife? Where's my shirt? | Random crowd bark, any city. |
| 6 | [ ] | `drunk/bark_6.ogg` | I used to be somebody. Now I'm... everybody. | Random crowd bark, any city. |
| 7 | [ ] | `drunk/bark_7.ogg` | Cheers! To whatever that was! | Random crowd bark, any city. |
| 8 | [ ] | `drunk/bark_8.ogg` | Never bet on red. Always bet on whiskey. | Random crowd bark, any city. |
| 9 | [ ] | `drunk/bark_9.ogg` | I think I'm in the wrong casino. | Random crowd bark, any city. |
| 10 | [ ] | `drunk/bark_10.ogg` | I lost my keys. Or my car. Or my wife. | Random crowd bark, any city. |
| 11 | [ ] | `drunk/bark_11.ogg` | Don't tell my kids. Don't tell my kids' kids. | Random crowd bark, any city. |
| 12 | [ ] | `drunk/bark_12.ogg` | Everything's fine. Fine. FINE. | Random crowd bark, any city. |
| 13 | [ ] | `drunk/city1_4.ogg` | Saltwater taffy and bad decisions! | Crowd bark flavored for city 1. |
| 14 | [ ] | `drunk/city1_10.ogg` | This casino was voted 'adequate'. | Crowd bark flavored for city 1. |
| 15 | [ ] | `drunk/city2_4.ogg` | The trapeze is for the high rollers. Literally. | Crowd bark flavored for city 2. |
| 16 | [ ] | `drunk/city2_10.ogg` | Don't take the lion's tickets. | Crowd bark flavored for city 2. |
| 17 | [ ] | `drunk/city3_4.ogg` | The drums are for decoration. Mostly. | Crowd bark flavored for city 3. |
| 18 | [ ] | `drunk/city3_10.ogg` | They serve a burger shaped like an amp. | Crowd bark flavored for city 3. |
| 19 | [ ] | `drunk/city4_4.ogg` | I haven't seen daylight since the Clinton administration. | Crowd bark flavored for city 4. |
| 20 | [ ] | `drunk/city4_10.ogg` | The nugget in the lobby is fake. So is the man guarding it. | Crowd bark flavored for city 4. |
| 21 | [ ] | `drunk/city5_4.ogg` | Everything here costs a hundred dollars. Even the air. | Crowd bark flavored for city 5. |
| 22 | [ ] | `drunk/city5_10.ogg` | I haven't seen my family in six years. The poker's good. | Crowd bark flavored for city 5. |

### BOUNCER: 22 lines

Folder: `voice/bouncer/` (cutscene lines go in the folder shown). Voice: As low as you can go. Say as few words as possible..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `bouncer/bark_1.ogg` | Not tonight, pal. | Random crowd bark, any city. |
| 2 | [ ] | `bouncer/bark_2.ogg` | Name's not on the list. | Random crowd bark, any city. |
| 3 | [ ] | `bouncer/bark_3.ogg` | Move along. | Random crowd bark, any city. |
| 4 | [ ] | `bouncer/bark_4.ogg` | I don't care who you know. | Random crowd bark, any city. |
| 5 | [ ] | `bouncer/bark_5.ogg` | ID. | Random crowd bark, any city. |
| 6 | [ ] | `bouncer/bark_6.ogg` | Dress code. You're in violation. | Random crowd bark, any city. |
| 7 | [ ] | `bouncer/bark_7.ogg` | Step outside. Please. Not really a request. | Random crowd bark, any city. |
| 8 | [ ] | `bouncer/bark_8.ogg` | You have the wrong shoes. | Random crowd bark, any city. |
| 9 | [ ] | `bouncer/bark_9.ogg` | VIP only. You're not. | Random crowd bark, any city. |
| 10 | [ ] | `bouncer/bark_10.ogg` | Keep walking. | Random crowd bark, any city. |
| 11 | [ ] | `bouncer/bark_11.ogg` | The line starts at the back. | Random crowd bark, any city. |
| 12 | [ ] | `bouncer/bark_12.ogg` | No. | Random crowd bark, any city. |
| 13 | [ ] | `bouncer/city1_5.ogg` | The seagulls steal chips here. | Crowd bark flavored for city 1. |
| 14 | [ ] | `bouncer/city1_11.ogg` | I came for the ocean. I stayed for the debt. | Crowd bark flavored for city 1. |
| 15 | [ ] | `bouncer/city2_5.ogg` | Mind the clown. The clown bites. | Crowd bark flavored for city 2. |
| 16 | [ ] | `bouncer/city2_11.ogg` | Welcome to the circus. You're the show. | Crowd bark flavored for city 2. |
| 17 | [ ] | `bouncer/city3_5.ogg` | A bad beat sounds like a power chord. | Crowd bark flavored for city 3. |
| 18 | [ ] | `bouncer/city3_11.ogg` | This riff is a threat. | Crowd bark flavored for city 3. |
| 19 | [ ] | `bouncer/city4_5.ogg` | The neon is older than I am. | Crowd bark flavored for city 4. |
| 20 | [ ] | `bouncer/city4_11.ogg` | Don't stare at the chandelier. It judges. | Crowd bark flavored for city 4. |
| 21 | [ ] | `bouncer/city5_5.ogg` | Don't stare at the High Roller. He bites. | Crowd bark flavored for city 5. |
| 22 | [ ] | `bouncer/city5_11.ogg` | They serve a hundred-dollar water. It's the same water. | Crowd bark flavored for city 5. |

### HUSTLER: 22 lines

Folder: `voice/hustler/` (cutscene lines go in the folder shown). Voice: Everything is an offer. Everything is urgent..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `hustler/bark_1.ogg` | Hey. Hey you. Wanna buy a watch? | Random crowd bark, any city. |
| 2 | [ ] | `hustler/bark_2.ogg` | I got a guy. He's got a guy. You want the guy. | Random crowd bark, any city. |
| 3 | [ ] | `hustler/bark_3.ogg` | Psst. Free money. It's a scam. But free. | Random crowd bark, any city. |
| 4 | [ ] | `hustler/bark_4.ogg` | Wanna see a magic trick? It's a wallet. | Random crowd bark, any city. |
| 5 | [ ] | `hustler/bark_5.ogg` | Everything's for sale. Even me. | Random crowd bark, any city. |
| 6 | [ ] | `hustler/bark_6.ogg` | You look lucky. You look LOST. | Random crowd bark, any city. |
| 7 | [ ] | `hustler/bark_7.ogg` | Three-card monte! Find the lady! | Random crowd bark, any city. |
| 8 | [ ] | `hustler/bark_8.ogg` | Cheap chips! Authentic! Probably! | Random crowd bark, any city. |
| 9 | [ ] | `hustler/bark_9.ogg` | Ten bucks. No questions. | Random crowd bark, any city. |
| 10 | [ ] | `hustler/bark_10.ogg` | That's a nice jacket. I'll take it. Joke. | Random crowd bark, any city. |
| 11 | [ ] | `hustler/bark_11.ogg` | Business is slow. Be my business. | Random crowd bark, any city. |
| 12 | [ ] | `hustler/bark_12.ogg` | Don't look at me. I didn't do it. | Random crowd bark, any city. |
| 13 | [ ] | `hustler/city1_6.ogg` | This place has seen better decades. | Crowd bark flavored for city 1. |
| 14 | [ ] | `hustler/city1_12.ogg` | The carpet here hasn't been cleaned since the nineties. | Crowd bark flavored for city 1. |
| 15 | [ ] | `hustler/city2_6.ogg` | Everything here is sticky. Don't ask. | Crowd bark flavored for city 2. |
| 16 | [ ] | `hustler/city2_12.ogg` | Please do not feed the acrobats. | Crowd bark flavored for city 2. |
| 17 | [ ] | `hustler/city3_6.ogg` | Hey! Don't touch the Elvis suit! | Crowd bark flavored for city 3. |
| 18 | [ ] | `hustler/city3_12.ogg` | The coat check costs more than the room. | Crowd bark flavored for city 3. |
| 19 | [ ] | `hustler/city4_6.ogg` | They don't make casinos like this anymore. Thank God. | Crowd bark flavored for city 4. |
| 20 | [ ] | `hustler/city4_12.ogg` | Ten thousand dollars on red. On red! | Crowd bark flavored for city 4. |
| 21 | [ ] | `hustler/city5_6.ogg` | Fine art. Fine wine. Fine print. | Crowd bark flavored for city 5. |
| 22 | [ ] | `hustler/city5_12.ogg` | The House is watching. Behave. | Crowd bark flavored for city 5. |


---

## Grunts and effort sounds (optional, but they make combat feel real)

The game already has synthesized sound effects for everything: punches, whooshes, landings, glass and chips. Grunts are **your voice layered on top**, like in a real action game.

### How it works
1. Record short grunts, roughly half a second each. One grunt per file.
2. Name them `grunt_<slot>_<number>.ogg`. The number goes from 1 to 5. Record 2-3 versions of each, and the game picks one at random so it never sounds repetitive.
3. Drop them into the folder for that character, as in the table below.
4. That's it. No code changes. Files can be `.ogg`, `.wav` or `.mp3`.

### Rico (`voice/rico/`)
| File name | When it plays | How to perform it |
|---|---|---|
| `grunt_jump_1.ogg`, `_2`, `_3` | Jumping, double jump, wall jump | A short "hup!" or "hah!". Light, quick, from the chest. |
| `grunt_attack_1.ogg` ... `_3` | Swinging (about half the swings) | A sharp "hyah!", "hnn!" or "ha!". Punchy, under half a second. |
| `grunt_dash_1.ogg`, `_2` | Dashing | A quick exhale: "hff!" |
| `grunt_effort_1.ogg`, `_2` | Vaults, ledge grabs, stomps | A strained "nngh!" |
| `grunt_slide_1.ogg` | Sliding | "Whoa!" or a quick "ha!" |
| `grunt_land_1.ogg` | Big falls and hard landings | "Oof!" |
| `grunt_hurt_1.ogg` ... `_3` | Taking a hit (every time) | "Agh!", "Ugh!", "Oof!". Make it sound like it hurt. |
| `grunt_death_1.ogg`, `_2` | Busting (dying) | A longer, dramatic groan: "Nooo... my chips..." |
| `grunt_parry_1.ogg`, `_2` | A perfect parry | A cocky "Ha!" or "Nope!" |
| `grunt_heal_1.ogg` | Healing with Nerve | A relieved sigh: "Ahhh, that's better." |

### Regular enemies (`voice/enemy/`)
| File name | When it plays | How to perform it |
|---|---|---|
| `grunt_death_1.ogg` ... `_5` | An enemy goes down | A mix: "Ugh!", "Argh!", "Not again...". Vary your pitch on each one so they sound like different people. |

### Bosses (`voice/<boss folder>/`, e.g. `voice/draftqueens/`, `voice/the_house/`)
| File name | When it plays | How to perform it |
|---|---|---|
| `grunt_hurt_1.ogg` ... `_3` | The boss takes a hit (about 1 in 3 hits) | In that boss's voice (see VOICE_CAST.md): "Hngh!" or "You little...!" |
| `grunt_death_1.ogg` | The boss is defeated | A big, dramatic defeat cry. |

### Tips for grunts
- **Record a lot, then keep the best.** Do 10 jump grunts in a row, then keep the 3 best.
- **Keep them short.** Trim the silence before and after in Audacity (select the silence, then press Delete).
- **Don't clip.** Grunts are loud. Back off the mic a little, or lower your input volume, so the waveform doesn't hit the top.
- **The in-game voice filter applies to grunts too.** Rico's filter is light; boss filters change your voice more. Record clean, and the game makes each one sound different.
- **To hear them:** press F5 in Godot and jump, attack, get hit.
