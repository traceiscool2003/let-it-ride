# HOW TO RECORD THE VOICES

---

## The in-game Voice Studio (the easiest way)

You don't need Audacity at all. The game can record you itself.

1. Plug in your mic, open the project in Godot and press **F5**.
2. Press **F6** at any time. The Voice Studio opens and the game pauses.
3. The screen shows the character card (their quote, pitch, speed and attitude), the **line to say** in big letters, and a note on **how to say it**.
4. Press **R** and say the line. Press **R** again to stop. The level meter turns red if you're too loud.
5. Your take saves automatically and plays back **through that character's voice filter**, so you hear how it will sound in the game.
6. Happy with it? Press **ENTER** for the next line. Not happy? Press **R** to redo it.

| Key | What it does |
|---|---|
| R | Record / stop (saves automatically) |
| SPACE | Play the current take |
| ENTER / DOWN | Next line |
| UP | Previous line |
| N | Jump to the next line you haven't recorded |
| LEFT / RIGHT | Show one character only (or all of them) |
| U | Show only the lines you still need to record |
| DEL | Delete this take |
| F6 / ESC | Close the studio |

- **Where takes go:** studio takes save into `voice/all/` in your project. Grunts go into each character's folder.
- **Progress:** the top of the screen shows how many lines on your recording list you've done (about 486 lines plus 33 grunts). Press **A** to also see the optional extra lines.
- **The whole list on paper:** `voice/ALL_LINES.md` has every line, numbered, in the same order as the studio.
- **Prefer your own app?** Save everything into the single folder `voice/all/`, using the names in `voice/ALL_LINES.md`.

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
| 1 | [ ] | `rico/greet_1.ogg` | Let's see what the House has left. Besides my brother. And my dignity. | Greeting the player. In character. |
| 2 | [ ] | `rico/greet_2.ogg` | Aces up. Brains down. Perfect. That's the whole strategy. | Greeting the player. In character. |
| 3 | [ ] | `rico/greet_3.ogg` | Another day, another dollar I don't have. And will never have. Hey, momentum. | Greeting the player. In character. |
| 4 | [ ] | `rico/greet_4.ogg` | Let it ride, baby! Or let it flop. I'm indifferent. I'm lying. LET IT RIDE. | Greeting the player. In character. |
| 5 | [ ] | `rico/farewell_1.ogg` | Wish me luck. Not that I need it. I need it so much. Please. | Parting words as the player leaves. |
| 6 | [ ] | `rico/farewell_2.ogg` | See you at the top of the Bellagiro. Or the bottom of a dumpster. Same energy. | Parting words as the player leaves. |
| 7 | [ ] | `rico/farewell_3.ogg` | I'll be rich by dinner. Or dead. Honestly? Both are on the menu. | Parting words as the player leaves. |
| 8 | [ ] | `rico/farewell_4.ogg` | Let it ride! And if it doesn't, let it die! Dramatically! | Parting words as the player leaves. |
| 9 | [ ] | `rico/rich_1.ogg` | I'm RICH! Wait. Let me count again. I'm RICH! Wait. That's one chip. Fine. Still RICH! | The player is carrying a lot of money. |
| 10 | [ ] | `rico/rich_2.ogg` | Look at all this! I'll bet it. All of it. It's the only responsible thing. | The player is carrying a lot of money. |
| 11 | [ ] | `rico/rich_3.ogg` | Money? That's just ammunition. For the House. They're armed with my debts. | The player is carrying a lot of money. |
| 12 | [ ] | `rico/rich_4.ogg` | Pot's fat. Time to make it fatter. And then lose it. For balance. | The player is carrying a lot of money. |
| 13 | [ ] | `rico/broke_1.ogg` | Broke? That's just a free roll. With a funeral. Same thing. | The player is nearly broke. |
| 14 | [ ] | `rico/broke_2.ogg` | Zero dollars. Infinite possibilities. Mostly bad ones. Mostly involving a pawn shop. | The player is nearly broke. |
| 15 | [ ] | `rico/broke_3.ogg` | I've been broker. I'm fine. I'm fine. I'm fine. Does this look fine? Don't answer. | The player is nearly broke. |
| 16 | [ ] | `rico/broke_4.ogg` | Rock bottom's got a nice view. Of other, deeper bottoms. | The player is nearly broke. |
| 17 | [ ] | `rico/ugly_1.ogg` | I look like a dumpster fire and I LOVE it. Fire's warm. Dumpsters are home. | The player is wearing ugly clothes. |
| 18 | [ ] | `rico/ugly_2.ogg` | Is this fanny pack lucky? It's lucky. It's lucky. Please be lucky. | The player is wearing ugly clothes. |
| 19 | [ ] | `rico/ugly_3.ogg` | Style is for people with odds. I have vibes. And a belt of regret. | The player is wearing ugly clothes. |
| 20 | [ ] | `rico/ugly_4.ogg` | Somebody call a stylist. Or a priest. Or an exorcist. A stylist who is also an exorcist. | The player is wearing ugly clothes. |
| 21 | [ ] | `rico/sharp_1.ogg` | I look incredible. The House should be scared. The House should also be on a payment plan. | The player is dressed sharp. |
| 22 | [ ] | `rico/sharp_2.ogg` | Dressed to kill. Or at least to lose in style. Style is the only thing I keep. | The player is dressed sharp. |
| 23 | [ ] | `rico/sharp_3.ogg` | Hey, I clean up nice. I mean it. Don't look at the shoes. The shoes are in debt. | The player is dressed sharp. |
| 24 | [ ] | `rico/sharp_4.ogg` | Would you bet on me? I would. I do. I did. That's the whole problem. | The player is dressed sharp. |
| 25 | [ ] | `rico/died_1.ogg` | Okay. That one was on me. The one before that was on a wall. Fine. | The player just died. |
| 26 | [ ] | `rico/died_2.ogg` | Death? Barely noticed. I do it for a living. A bad one. A living-ish one. | The player just died. |
| 27 | [ ] | `rico/died_3.ogg` | I'll do it differently next time. Or exactly the same. Variety is overrated. | The player just died. |
| 28 | [ ] | `rico/died_4.ogg` | I regret nothing. Except that. And the thing before. And the entire year. | The player just died. |
| 29 | [ ] | `rico/boss_1.ogg` | Read 'em and weep, pal! You're weeping already. Good. Good for you. | The player just beat a boss. |
| 30 | [ ] | `rico/boss_2.ogg` | Another table down. Another reason to gamble! I mean, ANOTHER reason. The first was my entire personality. | The player just beat a boss. |
| 31 | [ ] | `rico/boss_3.ogg` | I called the bluff. And the bluff folded. And then it cried. Which was unprofessional. | The player just beat a boss. |
| 32 | [ ] | `rico/boss_4.ogg` | Who's next? Don't answer. I don't want to know. Okay, answer. | The player just beat a boss. |
| 33 | [ ] | `rico/idle_1.ogg` | Odds are for people who don't have a gun. Or a plan. Or a savings. | Idle chatter. Random. |
| 34 | [ ] | `rico/idle_2.ogg` | I once bet my shoes. Won. Lost the shoes. Same thing. Zero net shoes. | Idle chatter. Random. |
| 35 | [ ] | `rico/idle_3.ogg` | Risk is just fun with consequences. And a rash. Mostly the rash. | Idle chatter. Random. |
| 36 | [ ] | `rico/idle_4.ogg` | Climb five casinos, get Jules, don't bet him. Three steps. I've only failed step three. In theory. | Idle chatter. Random. |
| 37 | [ ] | `rico/buy_1.ogg` | Take my money. Take all of it! Wait, not all of it. Ah. Fine. All of it. | The player just bought something. |
| 38 | [ ] | `rico/buy_2.ogg` | Sold! Wait, what was the price? Never mind. Sold. Sold, sold, sold. | The player just bought something. |
| 39 | [ ] | `rico/buy_3.ogg` | Worth it. Probably. If I die, it's a charitable donation to someone with fewer problems. | The player just bought something. |
| 40 | [ ] | `rico/buy_4.ogg` | That's a terrible deal. I'm in. I'm so in. I'm already in the pool. | The player just bought something. |
| 41 | [ ] | `rico/boss_intro_draftqueens.ogg` | Five Card Draw? I've drawn worse. I drew my last landlord. | Hero cockily answers the boss. |
| 42 | [ ] | `rico/boss_defeat_draftqueens.ogg` | You drafted a loser. Mine. I'm keeping him. | Hero victory line. Smug. |
| 43 | [ ] | `rico/boss_intro_fandool.ogg` | Seven Card Stud? Cute. My last seven-card stud was a Tuesday and a cry for help. | Hero cockily answers the boss. |
| 44 | [ ] | `rico/boss_defeat_fandool.ogg` | Call it. I'll watch the highlight reel. Of me. Winning. | Hero victory line. Smug. |
| 45 | [ ] | `rico/boss_intro_pokerstarz.ogg` | Omaha? Four hole cards? I've got four problems and a pair of shoes. | Hero cockily answers the boss. |
| 46 | [ ] | `rico/boss_defeat_pokerstarz.ogg` | Content creator? You're an extra. I'm the main character. Subscribe. | Hero victory line. Smug. |
| 47 | [ ] | `rico/boss_intro_betmgn.ogg` | Three Card Poker? Fast game. Ideal for a man with no attention span or savings. | Hero cockily answers the boss. |
| 48 | [ ] | `rico/boss_defeat_betmgn.ogg` | Pair plus? I'll take the pair. You take the plus. It's an ambulance. | Hero victory line. Smug. |
| 49 | [ ] | `rico/boss_intro_steake.ogg` | Razz? Worst hand wins? I was built for this. I've been the worst since birth. | Hero cockily answers the boss. |
| 50 | [ ] | `rico/boss_defeat_steake.ogg` | Stake it all. That's the brand. Stake it, eat it, vomit it. | Hero victory line. Smug. |
| 51 | [ ] | `rico/boss_intro_bovadoh.ogg` | Pai Gow? Two hands? Ha. I only have one personality. Both are bad. | Hero cockily answers the boss. |
| 52 | [ ] | `rico/boss_defeat_bovadoh.ogg` | Two hands, two wins. Do the math. I did. I was bad at it. | Hero victory line. Smug. |
| 53 | [ ] | `rico/boss_intro_seezers.ogg` | Blackjack? I'll hit. I'll hit hard. Hit me, Caesar. Hit me again. | Hero cockily answers the boss. |
| 54 | [ ] | `rico/boss_defeat_seezers.ogg` | Caesar's palace was a casino. I'd like to buy it. For a drink. One drink. | Hero victory line. Smug. |
| 55 | [ ] | `rico/boss_intro_wynners.ogg` | Baccarat? Ha. Tuxedo, no money, and a martini. We've met before. At a funeral. | Hero cockily answers the boss. |
| 56 | [ ] | `rico/boss_defeat_wynners.ogg` | Banker or Player? Put me down for 'tired.' Deal. | Hero victory line. Smug. |
| 57 | [ ] | `rico/boss_intro_snake_eyes.ogg` | Craps? Sure. I'm a craps man. I'm also a crap man. Try me. | Hero cockily answers the boss. |
| 58 | [ ] | `rico/boss_defeat_snake_eyes.ogg` | Rolled it. And the dice rolled you. Same story. Different dice. | Hero victory line. Smug. |
| 59 | [ ] | `rico/boss_intro_rusty_slots.ogg` | A haunted slot machine? Honestly, I've dated worse. Most of them. | Hero cockily answers the boss. |
| 60 | [ ] | `rico/boss_defeat_rusty_slots.ogg` | You've pulled the arm. The arm's pulled you. Hug it out. Or tilt. | Hero victory line. Smug. |
| 61 | [ ] | `rico/boss_intro_mr_lucky.ogg` | Keno? Hit eighty numbers? Sounds like a Tuesday. A busy one. | Hero cockily answers the boss. |
| 62 | [ ] | `rico/boss_defeat_mr_lucky.ogg` | Good game, Kevin. May the next hell be less numerical. | Hero victory line. Smug. |
| 63 | [ ] | `rico/boss_intro_the_house.ogg` | Texas Hold'em for my brother. I've bet worse on less. Deal. | Hero cockily answers the boss. |
| 64 | [ ] | `rico/boss_defeat_the_house.ogg` | Read 'em and weep. Now, where's Jules? | Hero victory line. Smug. |
| 65 | [ ] | `_cutscenes/city1_arrive/city1_arrive_1.ogg` | Atlantic Shitty. Salt, rust and slot machines. I love it already. | Cutscene: city1 arrive |
| 66 | [ ] | `_cutscenes/city1_arrive/city1_arrive_3.ogg` | Everything's wet, Marlow. That's the whole city. | Cutscene: city1 arrive |
| 68 | [ ] | `_cutscenes/city2_arrive/city2_arrive_1.ogg` | Reno. The biggest little city. And that's a clown. | Cutscene: city2 arrive |
| 70 | [ ] | `_cutscenes/city3_arrive/city3_arrive_1.ogg` | Biloxi. Sharks in the lobby. Guitars on the wall. This is my kind of mistake. | Cutscene: city3 arrive |
| 71 | [ ] | `_cutscenes/city3_arrive/city3_arrive_3.ogg` | Quiet's not really my instrument. | Cutscene: city3 arrive |
| 74 | [ ] | `_cutscenes/city4_arrive/city4_arrive_1.ogg` | Fremont, Old Vegas. Neon older than my debt. | Cutscene: city4 arrive |
| 77 | [ ] | `_cutscenes/city5_arrive/city5_arrive_1.ogg` | The Strip. The nicest casino in the world. And I'm covered in alley. | Cutscene: city5 arrive |
| 82 | [ ] | `_cutscenes/secret_found/secret_found_1.ogg` | A hidden room? A secret table? The House is hiding something. | Cutscene: secret found |
| 83 | [ ] | `_cutscenes/secret_defeat/secret_defeat_1.ogg` | Another secret down. Another stack of chips. | Cutscene: secret defeat |
| 84 | [ ] | `_cutscenes/secret_defeat/secret_defeat_3.ogg` | Good. | Cutscene: secret defeat |
| 85 | [ ] | `_cutscenes/final_prelude/final_prelude_2.ogg` | And I still got a bet on you. | Cutscene: final prelude |
| 86 | [ ] | `_cutscenes/intro/intro_1.ogg` | My brother Jules sat down at The House's table and bet himself. And lost. Now he works there. It's the most Jules thing that has ever happened. | Cutscene: intro |
| 87 | [ ] | `_cutscenes/intro/intro_2.ogg` | So here's the plan: climb five casinos, from a dumpster to the Vegas Strip, and win him back. I've bet on worse. I've bet on myself. That was worse. | Cutscene: intro |
| 88 | [ ] | `_cutscenes/intro/intro_5.ogg` | So... infinite credit? Can't die, just owe more. I've been training for this my whole life. | Cutscene: intro |
| 89 | [ ] | `_cutscenes/mags_chase/mags_chase_2.ogg` | ...Can we talk about this? | Cutscene: mags chase |
| 90 | [ ] | `_cutscenes/ending/ending_1.ogg` | The House folds. The penthouse goes quiet. At the far table, a man in a vest keeps dealing to nobody. My brother. Still winning. | Cutscene: ending |
| 91 | [ ] | `_cutscenes/ending/ending_3.ogg` | Jules. Cash out. Walk away from a winning table. I know. I've never done it either. Do it for me. | Cutscene: ending |
| 92 | [ ] | `_cutscenes/ending/ending_5.ogg` | Look, I'm the last guy who gets to say this. I once bet my shoes. Won the bet. Lost the shoes. I'm not a role model. Come home. | Cutscene: ending |
| 94 | [ ] | `_cutscenes/true_ending/true_ending_2.ogg` | No. I read your tickets, Eddie. All twenty of them. Your handwriting's worse than Jules's. | Cutscene: true ending |
| 95 | [ ] | `_cutscenes/true_ending/true_ending_4.ogg` | You never learned to walk away. So I'm teaching you. Cash out, Eddie. Take the win. | Cutscene: true ending |
| 96 | [ ] | `_cutscenes/true_ending/true_ending_9.ogg` | Even my debt? ...That's disappointing. It was my longest relationship. | Cutscene: true ending |
| 97 | [ ] | `rico/marlow_intro_3.ogg` | So I can't die. Great. What's the catch? | Conversation: marlow_intro |
| 98 | [ ] | `rico/marlow_confess_3.ogg` | ...You put my brother at that table. | Conversation: marlow_confess |
| 99 | [ ] | `rico/vera_intro_3.ogg` | And up here? | Conversation: vera_intro |
| 100 | [ ] | `rico/mags_intro_4.ogg` | You're a shark. In a suit. | Conversation: mags_intro |

### MARLOW: 87 lines

Folder: `voice/marlow/` (cutscene lines go in the folder shown). Voice: Hold the phone away and sigh before the line..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `marlow/greet_1.ogg` | Rico. You picked up. Good. I had a bet going. I lost. Good. | Greeting the player. In character. |
| 2 | [ ] | `marlow/greet_2.ogg` | Marlow here. Talk fast, the line's got ears. And mold. Mostly mold. | Greeting the player. In character. |
| 3 | [ ] | `marlow/greet_3.ogg` | Back already? I was just worrying. Constructively. With snacks. | Greeting the player. In character. |
| 4 | [ ] | `marlow/greet_4.ogg` | Hey. You alive? Say something stupid. There. Alive. | Greeting the player. In character. |
| 5 | [ ] | `marlow/farewell_1.ogg` | Stay alive. Stay lucky. Stay on the line. Pick any two. Never three. | Parting words as the player leaves. |
| 6 | [ ] | `marlow/farewell_2.ogg` | Call if you need me. Call if you don't. I'm lonely. That's classified. | Parting words as the player leaves. |
| 7 | [ ] | `marlow/farewell_3.ogg` | Don't do anything I'd worry about. Too late. I'm already composing the eulogy. | Parting words as the player leaves. |
| 8 | [ ] | `marlow/farewell_4.ogg` | Let it ride, kid. Preferably into a wall that's padded. | Parting words as the player leaves. |
| 9 | [ ] | `marlow/rich_1.ogg` | Look at that pot. Resist the urge. Resist it. Resist it. You didn't resist it. | The player is carrying a lot of money. |
| 10 | [ ] | `marlow/rich_2.ogg` | You're rich. Don't tell the House. Don't tell yourself, either. | The player is carrying a lot of money. |
| 11 | [ ] | `marlow/rich_3.ogg` | Bank it, Rico. Please. Bank it. I'm begging. I'm on the floor. That's a dust bunny. | The player is carrying a lot of money. |
| 12 | [ ] | `marlow/rich_4.ogg` | I've seen guys lose that in one hand. I've also been one of them. | The player is carrying a lot of money. |
| 13 | [ ] | `marlow/broke_1.ogg` | Broke again? That's the third time today. And it's lunch. | The player is nearly broke. |
| 14 | [ ] | `marlow/broke_2.ogg` | Hey. It's money. It comes back. Mostly. Maybe. Look, it's a hope, not a promise. | The player is nearly broke. |
| 15 | [ ] | `marlow/broke_3.ogg` | I'll cover dinner. Just don't tell your brother. He still thinks I'm solvent. | The player is nearly broke. |
| 16 | [ ] | `marlow/broke_4.ogg` | You're not broke. You're liquid. In a sad way. Like a puddle. | The player is nearly broke. |
| 17 | [ ] | `marlow/ugly_1.ogg` | What are you wearing? I can hear it. It's whispering 'help.' | The player is wearing ugly clothes. |
| 18 | [ ] | `marlow/ugly_2.ogg` | Is that a fanny pack? On the phone? I can SEE it. Don't ask how. | The player is wearing ugly clothes. |
| 19 | [ ] | `marlow/ugly_3.ogg` | Look, style isn't everything. It's most things. It's, like, 80%. | The player is wearing ugly clothes. |
| 20 | [ ] | `marlow/ugly_4.ogg` | Please. Go see Silas. For my sake. I can't unsee it and I'm on a payphone. | The player is wearing ugly clothes. |
| 21 | [ ] | `marlow/sharp_1.ogg` | Hey, nice suit. I can hear the starch. It's screaming 'don't bleed.' | The player is dressed sharp. |
| 22 | [ ] | `marlow/sharp_2.ogg` | You look like a man with a plan. Do you have a plan? Blink twice if no. You can't blink. It's a phone. | The player is dressed sharp. |
| 23 | [ ] | `marlow/sharp_3.ogg` | Dressed to kill. Try not to be killed. It's a fine line and your tailor knows it. | The player is dressed sharp. |
| 24 | [ ] | `marlow/sharp_4.ogg` | Nice threads. Don't get blood on 'em. I charged a lot of favors for those. | The player is dressed sharp. |
| 25 | [ ] | `marlow/died_1.ogg` | Rico. Again? We have to stop meeting like this. In a morgue. Via payphone. | The player just died. |
| 26 | [ ] | `marlow/died_2.ogg` | I heard the thud. It was a loud one. I clapped. Don't judge me. | The player just died. |
| 27 | [ ] | `marlow/died_3.ogg` | You died. I'll light a candle. A small one. A very small one. It's a matchstick. | The player just died. |
| 28 | [ ] | `marlow/died_4.ogg` | Good news, Rico: you're alive. Bad news: it's me, and the phone, and Jules is still missing. | The player just died. |
| 29 | [ ] | `marlow/boss_1.ogg` | A boss! I'm updating my bet. I'm betting you survive. A first. | The player just beat a boss. |
| 30 | [ ] | `marlow/boss_2.ogg` | That's one more casino down. Jules is a little closer. Or a little farther. I'm still checking the map. | The player just beat a boss. |
| 31 | [ ] | `marlow/boss_3.ogg` | You did it. Don't let it go to your head. Let it go to your knees. Then bank. | The player just beat a boss. |
| 32 | [ ] | `marlow/boss_4.ogg` | I'm proud. I hate that. I'm checking my pulse. | The player just beat a boss. |
| 33 | [ ] | `marlow/idle_1.ogg` | Five casinos. Twenty-five floors. Jules at the top of the Bellagiro. Easy. By which I mean impossible. In order. | Idle chatter. Random. |
| 34 | [ ] | `marlow/idle_2.ogg` | Secrets everywhere. Walls that break. Doors that don't exist. Like my career. | Idle chatter. Random. |
| 35 | [ ] | `marlow/idle_3.ogg` | Follow the light. It leads somewhere. Hopefully not a morgue. | Idle chatter. Random. |
| 36 | [ ] | `marlow/idle_4.ogg` | Every floor has a story. Some bleed. Most are about you losing. | Idle chatter. Random. |
| 37 | [ ] | `marlow/buy_1.ogg` | Good call. Not great. Good. Like 'good' on a report card for a goldfish. | The player just bought something. |
| 38 | [ ] | `marlow/buy_2.ogg` | I hope you read the fine print. There's no fine print. That's the fine print. | The player just bought something. |
| 39 | [ ] | `marlow/buy_3.ogg` | I wouldn't. But I'm not you. Thank God. Thank all of the gods. | The player just bought something. |
| 40 | [ ] | `marlow/buy_4.ogg` | That's the one Jules would've bought. And look where that got him. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city1_arrive/city1_arrive_2.ogg` | Rico, you're in an alley. The casino's a block up. Start walking, and don't touch anything wet. | Cutscene: city1 arrive |
| 43 | [ ] | `_cutscenes/city2_arrive/city2_arrive_2.ogg` | That's the doorman. Smile. Don't get close. | Cutscene: city2 arrive |
| 44 | [ ] | `_cutscenes/city3_arrive/city3_arrive_2.ogg` | Hard Rok keeps the heavies near the stage. Stay quiet. | Cutscene: city3 arrive |
| 48 | [ ] | `_cutscenes/city4_arrive/city4_arrive_2.ogg` | Goldun Nugget's got a shark tank and a long memory. Everyone wants in. Nobody gets out. | Cutscene: city4 arrive |
| 54 | [ ] | `_cutscenes/secret_found/secret_found_2.ogg` | That's not on the map, Rico. Be careful in there. By which I mean: be reckless. It's a secret table. | Cutscene: secret found |
| 55 | [ ] | `_cutscenes/secret_defeat/secret_defeat_2.ogg` | You're not supposed to know about those rooms. The House won't like it. | Cutscene: secret defeat |
| 56 | [ ] | `_cutscenes/intro/intro_7.ogg` | Radio check, Rico. Jules is at the top of the Bellagiro, on the Strip. Every chip you grab rides in your Pot. At each door you bank it, or let it ride for double. You'll let it ride. You always let it ride. | Cutscene: intro |
| 57 | [ ] | `_cutscenes/intro/intro_8.ogg` | Wear something. Anything. Then get in that heap you call a car. The goal, in plain English: climb five casinos, get Jules, try not to bet him. | Cutscene: intro |
| 58 | [ ] | `_cutscenes/ending/ending_4.ogg` | Rico, I've seen a lot of men walk away from a table. Zero of them were happy about it. Be gentle. | Cutscene: ending |
| 60 | [ ] | `_cutscenes/true_ending/true_ending_8.ogg` | Rico, the lights just went warm at the top of the Bellagiro. Every Marker in the apartment burned up at once. Everyone's free. | Cutscene: true ending |
| 61 | [ ] | `_cutscenes/true_ending/true_ending_10.ogg` | Course not. It's still a casino. Now it's ours. Let it ride, kid. | Cutscene: true ending |
| 62 | [ ] | `marlow/radio_1.ogg` | Same deal as always, Rico. Grab, run, don't get cute. You'll get cute. I've made peace with it. | Radio/lobby: radio |
| 63 | [ ] | `marlow/radio_2.ogg` | Word is security doubled. Parry the big lugs when they wind up. Or just die. It's free. | Radio/lobby: radio |
| 64 | [ ] | `marlow/radio_3.ogg` | You know what they say: the House always wins. So stop being the House's favorite guest. | Radio/lobby: radio |
| 65 | [ ] | `marlow/radio_4.ogg` | Slot machines on every floor. Bet the Pot if you're feeling lucky. I wouldn't. I'm broke. Correlation. | Radio/lobby: radio |
| 66 | [ ] | `marlow/radio_5.ogg` | Smash the glass, smash the crates. Insurance won't cover it, but you will. Barely. | Radio/lobby: radio |
| 67 | [ ] | `marlow/radio_6.ogg` | Jules left a trail of IOUs up the whole coast. Follow the money and you'll find him. Or a very sad accountant. | Radio/lobby: radio |
| 68 | [ ] | `marlow/radio_7.ogg` | Back again? The Fence has new toys if you've banked enough. Also the Fence has a new face. Stop looking. | Radio/lobby: radio |
| 69 | [ ] | `marlow/first_exit_1.ogg` | First door. Cash out and that money is yours forever, and The Fence will take it. Yes, that's the joke. | Radio/lobby: first exit |
| 70 | [ ] | `marlow/first_exit_2.ogg` | Or let it ride: double the multiplier, but the House adds a rule. Your call, high roller. Your funeral. Your call. | Radio/lobby: first exit |
| 71 | [ ] | `marlow/marlow_intro_1.ogg` | Rico! You picked up. So the rumors are true: The House doesn't let debtors die. It just sends them home with a bigger bill. | Conversation: marlow_intro |
| 72 | [ ] | `marlow/marlow_intro_2.ogg` | You bust, you wake up here, and the interest on your Marker goes up. Every run is a do-over. Every do-over is a bill. | Conversation: marlow_intro |
| 73 | [ ] | `marlow/marlow_intro_4.ogg` | The catch is you never stop owing. Climb the five casinos, get Jules, and get out before the interest gets out first. | Conversation: marlow_intro |
| 74 | [ ] | `marlow/marlow_spikes_1.ogg` | Spikes again? They don't move, Rico. That's kind of their whole thing. It's the only thing they do. | Conversation: marlow_spikes |
| 75 | [ ] | `marlow/marlow_guard_1.ogg` | Those bouncers telegraph every punch. Parry right before it lands and they'll be eating carpet. Dry carpet. Hard carpet. | Conversation: marlow_guard |
| 76 | [ ] | `marlow/marlow_bat_1.ogg` | Rats. You lost to rats. I'm leaving that out of the report. And the eulogy. | Conversation: marlow_bat |
| 77 | [ ] | `marlow/marlow_sal_1.ogg` | That first boss fights like he deals: slow, then rude. Wait for the big wind-up, sidestep, then punish. | Conversation: marlow_sal |
| 78 | [ ] | `marlow/marlow_sal_2.ogg` | Parry the big move and he's stunned wide open. Double damage. That's the whole tip. The rest is vibes. | Conversation: marlow_sal |
| 79 | [ ] | `marlow/marlow_roulette_1.ogg` | The second table's thrown balls bounce. Hit them back at the boss. They hate that more than losing. They hate it more than their mothers. | Conversation: marlow_roulette |
| 80 | [ ] | `marlow/marlow_house_1.ogg` | You made it all the way to the penthouse. That's further than Jules ever got. Further than me. Further than my self-respect. | Conversation: marlow_house |
| 81 | [ ] | `marlow/marlow_house_2.ogg` | Don't you dare quit now. I'll be so annoyed. I'll cry. Loudly. | Conversation: marlow_house |
| 82 | [ ] | `marlow/marlow_mags_1.ogg` | Mags got you? You borrowed from a SHARK, Rico. In a SUIT. There were signs. There was literally a fin. | Conversation: marlow_mags |
| 83 | [ ] | `marlow/marlow_greedy_1.ogg` | You were riding at times eight when you went down. Times eight. EIGHT. | Conversation: marlow_greedy |
| 84 | [ ] | `marlow/marlow_greedy_2.ogg` | Breathe. Bank once in a while. Jules never did, and look where it got him. A job. At a casino. As the help. | Conversation: marlow_greedy |
| 85 | [ ] | `marlow/marlow_careful_1.ogg` | Three cash-outs last run. Careful money. Who are you and what did you do with my idiot? | Conversation: marlow_careful |
| 86 | [ ] | `marlow/marlow_confess_1.ogg` | About what I said in Biloxi. I used to deal for The House. I got Jules his seat at the table. | Conversation: marlow_confess |
| 87 | [ ] | `marlow/marlow_confess_2.ogg` | I thought he'd win. He always won. That's not an excuse. It's a prior bad bet. | Conversation: marlow_confess |
| 88 | [ ] | `marlow/marlow_confess_4.ogg` | And I'm talking you back to him, one floor at a time. It's the only apology I've got. It's a bad one. It's also, considering, a pretty good one. | Conversation: marlow_confess |
| 89 | [ ] | `marlow/marlow_vault_1.ogg` | You cracked a safe! They only open if you get there fast. Speed pays at every casino. That's the only thing they have in common. | Conversation: marlow_vault |
| 90 | [ ] | `marlow/marlow_daily_1.ogg` | Daily Deal, huh? Same floors for everyone today. Show the rest of the world how it's done. Or how not. | Conversation: marlow_daily |
| 91 | [ ] | `marlow/marlow_ending_1.ogg` | Jules is out, the Bellagiro is quiet, and you're still picking up this phone. | Conversation: marlow_ending |
| 92 | [ ] | `marlow/marlow_ending_2.ogg` | ...Yeah. I'd go back too. Let it ride, kid. | Conversation: marlow_ending |
| 93 | [ ] | `marlow/marlow_true_1.ogg` | The House is quiet. First time in twenty years. You did that. | Conversation: marlow_true |
| 94 | [ ] | `marlow/marlow_true_2.ogg` | Eddie Duval finally cashed out. I owe you a drink. I owe you about a thousand drinks. Okay, I owe you a bar. | Conversation: marlow_true |
| 95 | [ ] | `marlow/marlow_rep1_1.ogg` | Chain your moves. The House pays out to style. The House also pays out to charity. Never to you. | Conversation: marlow_rep1 |
| 96 | [ ] | `marlow/marlow_rep2_1.ogg` | Static on the line... that's the House listening. Hi, House. We're not talking about you. | Conversation: marlow_rep2 |
| 97 | [ ] | `marlow/marlow_rep3_1.ogg` | Smash the glass, grab the chips, bank before you get cute. In that order. Do not rearrange. | Conversation: marlow_rep3 |

### VERA: 65 lines

Folder: `voice/vera/` (cutscene lines go in the folder shown). Voice: Whisper-purr. Never rush. You've seen every hand..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `vera/greet_1.ogg` | Look who crawled back to my table. Mind the carpet, it's seen things. | Greeting the player. In character. |
| 2 | [ ] | `vera/greet_2.ogg` | Sit, sugar. The cards are warm and your odds are not. | Greeting the player. In character. |
| 3 | [ ] | `vera/greet_3.ogg` | Back for charms? Of course. Nobody comes here for my personality. | Greeting the player. In character. |
| 4 | [ ] | `vera/greet_4.ogg` | I was just thinking about you. Mostly about your wallet. Mostly its funeral. | Greeting the player. In character. |
| 5 | [ ] | `vera/farewell_1.ogg` | Go on. Lose gracefully. Or lose loudly, it's better for tips. | Parting words as the player leaves. |
| 6 | [ ] | `vera/farewell_2.ogg` | Come back with something shiny. Or someone's teeth. I'm not picky. | Parting words as the player leaves. |
| 7 | [ ] | `vera/farewell_3.ogg` | Climb safe. I mean that. You're my only repeat customer. | Parting words as the player leaves. |
| 8 | [ ] | `vera/farewell_4.ogg` | Don't die. It's bad for my numbers. And mildly sad. | Parting words as the player leaves. |
| 9 | [ ] | `vera/rich_1.ogg` | That's a heavy pocket. Let me help you with it. It's what I do. | The player is carrying a lot of money. |
| 10 | [ ] | `vera/rich_2.ogg` | Money like that makes my charms blush. They've never seen a wallet that thick. | The player is carrying a lot of money. |
| 11 | [ ] | `vera/rich_3.ogg` | You're glowing, sugar. That's either gold or a medical issue. | The player is carrying a lot of money. |
| 12 | [ ] | `vera/rich_4.ogg` | Rich suits you. Poor suited you better. Poor was honest. | The player is carrying a lot of money. |
| 13 | [ ] | `vera/broke_1.ogg` | Empty pockets. I can sell you hope. Wholesale. Nonrefundable. | The player is nearly broke. |
| 14 | [ ] | `vera/broke_2.ogg` | Aw. Sit. Look at the charms. Looking's free. Everything else is a felony. | The player is nearly broke. |
| 15 | [ ] | `vera/broke_3.ogg` | You're broke, not dead. Yet. Those are two separate payment plans. | The player is nearly broke. |
| 16 | [ ] | `vera/broke_4.ogg` | Come back when you've robbed someone. Someone rich. I have standards. | The player is nearly broke. |
| 17 | [ ] | `vera/ugly_1.ogg` | Honey, what are you wearing? Blink twice if it's a hostage situation. | The player is wearing ugly clothes. |
| 18 | [ ] | `vera/ugly_2.ogg` | That outfit is a cry for help. In a language nobody speaks. | The player is wearing ugly clothes. |
| 19 | [ ] | `vera/ugly_3.ogg` | Even the slot machines looked away. And they have no eyes. | The player is wearing ugly clothes. |
| 20 | [ ] | `vera/ugly_4.ogg` | Silas will have a stroke. I'll sell tickets. Front row. | The player is wearing ugly clothes. |
| 21 | [ ] | `vera/sharp_1.ogg` | Now THAT is how you dress for a loss. Beautiful. Doomed. Fitted. | The player is dressed sharp. |
| 22 | [ ] | `vera/sharp_2.ogg` | Look at you. Dapper doom, with pockets. | The player is dressed sharp. |
| 23 | [ ] | `vera/sharp_3.ogg` | You clean up nice, sugar. Try not to bleed on it. Try. | The player is dressed sharp. |
| 24 | [ ] | `vera/sharp_4.ogg` | If you die in that, at least it's an open casket with taste. | The player is dressed sharp. |
| 25 | [ ] | `vera/died_1.ogg` | You died. Again. It's becoming a hobby. A bad one, but yours. | The player just died. |
| 26 | [ ] | `vera/died_2.ogg` | I saw it. Everyone saw it. The cat saw it and left the room. | The player just died. |
| 27 | [ ] | `vera/died_3.ogg` | Dust off, sugar. Jules is still up there and you're still down here. | The player just died. |
| 28 | [ ] | `vera/died_4.ogg` | That was a bold way to lose. Not smart. Bold. We'll call it bold. | The player just died. |
| 29 | [ ] | `vera/boss_1.ogg` | You beat a boss! I'll remember that when you owe me. Which is soon. | The player just beat a boss. |
| 30 | [ ] | `vera/boss_2.ogg` | Impressive. Terrifying, but impressive. Mostly terrifying. | The player just beat a boss. |
| 31 | [ ] | `vera/boss_3.ogg` | Another table down. Those people had friends. Mean, wealthy friends. | The player just beat a boss. |
| 32 | [ ] | `vera/boss_4.ogg` | Sit. Let me price that victory. It's worth a lot. To me. To you, nothing, ha. | The player just beat a boss. |
| 33 | [ ] | `vera/idle_1.ogg` | Charms don't pick themselves. They pick pockets. Same thing. | Idle chatter. Random. |
| 34 | [ ] | `vera/idle_2.ogg` | I know a secret. It costs extra. So does the silence. | Idle chatter. Random. |
| 35 | [ ] | `vera/idle_3.ogg` | Everybody's got a tell. Yours is hope. It's disgusting. | Idle chatter. Random. |
| 36 | [ ] | `vera/idle_4.ogg` | Cards, charms, chaos. Pick two. You've picked all three. Twice. | Idle chatter. Random. |
| 37 | [ ] | `vera/buy_1.ogg` | Wise choice. Or a terrible one. Same fee either way. | The player just bought something. |
| 38 | [ ] | `vera/buy_2.ogg` | Take it. It likes you. It likes everyone. It's a charm. Attention-seeking is the job. | The player just bought something. |
| 39 | [ ] | `vera/buy_3.ogg` | That one bites, sugar. In a good way. Mostly. | The player just bought something. |
| 40 | [ ] | `vera/buy_4.ogg` | Pleasure doing business. Mostly mine. All mine, actually. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city2_arrive/city2_arrive_3.ogg` | Welcome to the circus, sugar. Nobody leaves with their dignity. | Cutscene: city2 arrive |
| 42 | [ ] | `_cutscenes/intro_cast/intro_cast_1.ogg` | New face. I deal the cards and sell the charms. Bring me something shiny and I'll make the odds lean your way. Don't ask what they're leaning on. | Cutscene: intro cast |
| 43 | [ ] | `_cutscenes/true_ending/true_ending_6.ogg` | Whatever you were before the tables, Eddie. That's what's left. It's enough. And I'll sell you a hat. | Cutscene: true ending |
| 44 | [ ] | `vera/vera_intro_1.ogg` | Fresh Marker, still wet. I'm Vera Vex. I deal charms now, not cards. The cards got complicated. | Conversation: vera_intro |
| 45 | [ ] | `vera/vera_intro_2.ogg` | Charms bend the odds on every floor. Win them on slots, crack them out of safes, take them off bosses, or buy them at my table. | Conversation: vera_intro |
| 46 | [ ] | `vera/vera_intro_4.ogg` | Up here I sell licenses. Pay me from your wallet and I'll start slipping the good charms into the casinos. For a fee. Everything's a fee. | Conversation: vera_intro |
| 47 | [ ] | `vera/vera_bust_1.ogg` | You came back. Everyone comes back. That's the problem with this place. It's also the business model. | Conversation: vera_bust |
| 48 | [ ] | `vera/vera_stack_1.ogg` | Five charms and still breathing. Here's the trick: pick a vice and feed it. | Conversation: vera_stack |
| 49 | [ ] | `vera/vera_stack_2.ogg` | Greed charms multiply each other. Risk charms love a long ride. Stack the same vice and watch the numbers go stupid. Like you. | Conversation: vera_stack |
| 50 | [ ] | `vera/vera_jackpot_1.ogg` | Triple sevens. The House hates that sound. Do it again. I want to hear it cry. | Conversation: vera_jackpot |
| 51 | [ ] | `vera/vera_sal_1.ogg` | You took down your first table. He'll be back on his feet tomorrow. Nobody stays down here. Not even the bad guys. Especially not the bad guys. | Conversation: vera_sal |
| 52 | [ ] | `vera/vera_queen_hint_1.ogg` | Ever wonder why I stopped dealing? My deck's one card short. The Queen of Spades. | Conversation: vera_queen_hint |
| 53 | [ ] | `vera/vera_queen_hint_2.ogg` | She's my Marker. Lost her to The House a long time ago. If you see her up there... bring her home. She's lovely. Bit pointy. | Conversation: vera_queen_hint |
| 54 | [ ] | `vera/vera_queen_found_1.ogg` | ...That's her. That's my Queen. | Conversation: vera_queen_found |
| 55 | [ ] | `vera/vera_queen_found_2.ogg` | Twenty years I've owed The House this card, and you found it folded in a losing ticket. Of course you did. | Conversation: vera_queen_found |
| 56 | [ ] | `vera/vera_queen_found_3.ogg` | You just paid my Marker, Rico. I'm free to walk out that door. | Conversation: vera_queen_found |
| 57 | [ ] | `vera/vera_queen_found_4.ogg` | I'm staying. Somebody has to keep you lucky. Licenses are 25% off for you, forever. That's romance, for me. | Conversation: vera_queen_found |
| 58 | [ ] | `vera/vera_ending_1.ogg` | You got Jules out. Do you know how many runners I've watched try that? | Conversation: vera_ending |
| 59 | [ ] | `vera/vera_ending_2.ogg` | None of them knew when to cash out. You did. Mostly. Twice. In a row. It's a miracle. Don't push it. | Conversation: vera_ending |
| 60 | [ ] | `vera/vera_eddie_1.ogg` | Eddie Duval. You've been reading his tickets, haven't you. | Conversation: vera_eddie |
| 61 | [ ] | `vera/vera_eddie_2.ogg` | Best player I ever dealt to. Never walked away from a table. Not once. Not even when it caught fire. | Conversation: vera_eddie |
| 62 | [ ] | `vera/vera_eddie_3.ogg` | Now he IS the table. That voice on the PA? That's what's left of Eddie. It's mostly interest. | Conversation: vera_eddie |
| 63 | [ ] | `vera/vera_rep1_1.ogg` | Charms don't make you lucky. They make you less unlucky. It's a very small difference. It's the whole business. | Conversation: vera_rep1 |
| 64 | [ ] | `vera/vera_rep2_1.ogg` | The House always wins. Eventually. Your job is to leave before eventually. Mine's to sell you a ticket. | Conversation: vera_rep2 |
| 65 | [ ] | `vera/vera_rep3_1.ogg` | Everything's for sale, sugar. Advice included. Advice especially. Advice is the high-margin item. | Conversation: vera_rep3 |

### MAGS: 57 lines

Folder: `voice/mags/` (cutscene lines go in the folder shown). Voice: Sweet as pie, then drop the floor out of your voice..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `mags/greet_1.ogg` | Kid. Good. You're on time. I hate late. Late is where the bodies are. | Greeting the player. In character. |
| 2 | [ ] | `mags/greet_2.ogg` | I was just counting. Your debt. It's lovely. It's grown so much. It has your eyes. | Greeting the player. In character. |
| 3 | [ ] | `mags/greet_3.ogg` | Sit. No, standing's fine. For now. I'm lenient on the first visit. | Greeting the player. In character. |
| 4 | [ ] | `mags/greet_4.ogg` | Ah. My favorite investment. And my favorite mistake. Mostly the first one. | Greeting the player. In character. |
| 5 | [ ] | `mags/farewell_1.ogg` | Don't make me swim after you. I just did my hair. Well. The scalp. | Parting words as the player leaves. |
| 6 | [ ] | `mags/farewell_2.ogg` | I'll see you soon. You'll see me sooner. That's just physics. | Parting words as the player leaves. |
| 7 | [ ] | `mags/farewell_3.ogg` | Pay me. Or I'll collect. Ha. No, really. Ha. | Parting words as the player leaves. |
| 8 | [ ] | `mags/farewell_4.ogg` | Be careful out there. It would be a waste. Of my time. Mostly of my time. | Parting words as the player leaves. |
| 9 | [ ] | `mags/rich_1.ogg` | Look at all that. It looks lonely. Let me adopt it. | The player is carrying a lot of money. |
| 10 | [ ] | `mags/rich_2.ogg` | A big pot. A bigger interest. A biggest me. | The player is carrying a lot of money. |
| 11 | [ ] | `mags/rich_3.ogg` | You can afford to pay me early. You won't. But you can. That's the spirit I love in you: none. | The player is carrying a lot of money. |
| 12 | [ ] | `mags/rich_4.ogg` | Money. My favorite chewable. Tastes like retirement. | The player is carrying a lot of money. |
| 13 | [ ] | `mags/broke_1.ogg` | Broke? I'll float you. A shark takes care of its fish. Briefly. Then, dinner. | The player is nearly broke. |
| 14 | [ ] | `mags/broke_2.ogg` | Empty pockets. Full of potential. Mine. | The player is nearly broke. |
| 15 | [ ] | `mags/broke_3.ogg` | I never judge. I just remember. Every dollar. Every missed call. Every pet name. | The player is nearly broke. |
| 16 | [ ] | `mags/broke_4.ogg` | A loan keeps the family together. My family. Yours is optional. | The player is nearly broke. |
| 17 | [ ] | `mags/ugly_1.ogg` | That outfit is a loan officer's nightmare. I want it framed. | The player is wearing ugly clothes. |
| 18 | [ ] | `mags/ugly_2.ogg` | I'd lend you a suit. Interest only. Forever. Look at the cuffs, they're already forever. | The player is wearing ugly clothes. |
| 19 | [ ] | `mags/ugly_3.ogg` | Is that a fanny pack? I'm calling your mother. I'm calling all your mothers. | The player is wearing ugly clothes. |
| 20 | [ ] | `mags/ugly_4.ogg` | I've collected from better dressed corpses. Not by much. They were better dressed by a lot. | The player is wearing ugly clothes. |
| 21 | [ ] | `mags/sharp_1.ogg` | Nice suit. It looks expensive. I know whose. It's mine. You're wearing my money. | The player is dressed sharp. |
| 22 | [ ] | `mags/sharp_2.ogg` | Dressed to impress? I'm impressed. Pay up. | The player is dressed sharp. |
| 23 | [ ] | `mags/sharp_3.ogg` | That's a lot of money on your back. I'll take a cut. Of the back. | The player is dressed sharp. |
| 24 | [ ] | `mags/sharp_4.ogg` | Now you look like a lender. Good news: you're not. Better news: neither am I. I'm a relationship. | The player is dressed sharp. |
| 25 | [ ] | `mags/died_1.ogg` | You died. I'm adding that to the interest. Death's a surcharge. | The player just died. |
| 26 | [ ] | `mags/died_2.ogg` | No refunds in the afterlife. I'd know. I've got a branch there. | The player just died. |
| 27 | [ ] | `mags/died_3.ogg` | Dead men don't pay. But they do borrow. I've seen it. It's a whole thing. | The player just died. |
| 28 | [ ] | `mags/died_4.ogg` | Death is just a late payment. Of a different sort. Both lead to me. | The player just died. |
| 29 | [ ] | `mags/boss_1.ogg` | A boss? Their debt belongs to me now. Their dog too. I don't want the dog. | The player just beat a boss. |
| 30 | [ ] | `mags/boss_2.ogg` | Take your spoils. I take my share. We call it a share. The law calls it something else. | The player just beat a boss. |
| 31 | [ ] | `mags/boss_3.ogg` | Winning's expensive. Let me carry it. In my teeth. | The player just beat a boss. |
| 32 | [ ] | `mags/boss_4.ogg` | You beat the boss. Now beat the interest. Good luck. Nobody has. Not even me. | The player just beat a boss. |
| 33 | [ ] | `mags/idle_1.ogg` | Don't think of it as debt, sweetie. Think of it as a relationship. | Idle chatter. Random. |
| 34 | [ ] | `mags/idle_2.ogg` | I like you. That's the problem. I like everything I eat. | Idle chatter. Random. |
| 35 | [ ] | `mags/idle_3.ogg` | Everybody owes somebody. I just own the paperwork. And the walls. And the floor. | Idle chatter. Random. |
| 36 | [ ] | `mags/idle_4.ogg` | I swim every day. Just in case. In case of you. | Idle chatter. Random. |
| 37 | [ ] | `mags/buy_1.ogg` | Sign here. And here. And... there. Don't read it. Nobody reads it. Nobody lives. | The player just bought something. |
| 38 | [ ] | `mags/buy_2.ogg` | A pleasure. I'll bill you later. And later. And now, actually. Now I billed you. | The player just bought something. |
| 39 | [ ] | `mags/buy_3.ogg` | Smart. Debt is just future money you spent early. Think of it as time travel with teeth. | The player just bought something. |
| 40 | [ ] | `mags/buy_4.ogg` | No refunds. No regrets. Some regrets. Almost all regrets. They're yours. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city4_arrive/city4_arrive_3.ogg` | I'll see you at the top, kid. With a calculator. | Cutscene: city4 arrive |
| 42 | [ ] | `_cutscenes/intro/intro_3.ogg` | Nobody climbs without a Marker, kid. Sign here. And here. And... there. Don't read it. Don't think of it as debt, sweetie. Think of it as a relationship. | Cutscene: intro |
| 43 | [ ] | `_cutscenes/mags_chase/mags_chase_1.ogg` | Payday, kid. You're late. I hate late. Late is where I grow. | Cutscene: mags chase |
| 44 | [ ] | `_cutscenes/mags_chase/mags_chase_3.ogg` | We ARE talking. This is me talking. The swimming is me collecting. Cash out and pay me, or keep running. I like running. It builds appetite. | Cutscene: mags chase |
| 45 | [ ] | `mags/mags_intro_1.ogg` | Name's Mags. I hold the Markers at the door, and yours says The House owns your bones until you settle up. | Conversation: mags_intro |
| 46 | [ ] | `mags/mags_intro_2.ogg` | Short on chips? I lend. Two hundred now, three hundred back by the end of floor three. It's a friendship with numbers. | Conversation: mags_intro |
| 47 | [ ] | `mags/mags_intro_3.ogg` | Pay me when you cash out. Miss the date and I come collecting. Personally. Through walls. | Conversation: mags_intro |
| 48 | [ ] | `mags/mags_intro_5.ogg` | And you're a runner with no money. We all have our problems. Mine are on your wrist. | Conversation: mags_intro |
| 49 | [ ] | `mags/mags_repaid_1.ogg` | You paid me back on time. Respect. You'd be amazed how few do. Most of them are in the aquarium. | Conversation: mags_repaid |
| 50 | [ ] | `mags/mags_default_1.ogg` | About that chase. Nothing personal. Interest isn't personal, kid. It's just math with teeth. And, tonight, a little fin. | Conversation: mags_default |
| 51 | [ ] | `mags/mags_big_loss_1.ogg` | Saw you drop a thousand at the door. If you'd banked that, you'd have... well. You'd have me. Nodding. Slowly. | Conversation: mags_big_loss |
| 52 | [ ] | `mags/mags_rates_1.ogg` | Between you and me? The House charges interest on every bust. Compounding. Forever. | Conversation: mags_rates |
| 53 | [ ] | `mags/mags_rates_2.ogg` | Even I think that's ugly. And I'm a loan shark. Literally. It says so on the jacket. | Conversation: mags_rates |
| 54 | [ ] | `mags/mags_ending_1.ogg` | You beat The House and it's still standing. That's interest for you, kid. It keeps things alive. Like a bad marriage. | Conversation: mags_ending |
| 55 | [ ] | `mags/mags_rep1_1.ogg` | Borrow smart. Ride dumb. That's a joke. Don't do that. That's also a joke. Pay up. | Conversation: mags_rep1 |
| 56 | [ ] | `mags/mags_rep2_1.ogg` | My rates are fair. The House's rates are a crime. I would know. I'm a connoisseur. | Conversation: mags_rep2 |
| 57 | [ ] | `mags/mags_rep3_1.ogg` | A shark has to keep swimming. So do you. It's a threat. It's also a life tip. | Conversation: mags_rep3 |

### LUCKY: 47 lines

Folder: `voice/lucky/` (cutscene lines go in the folder shown). Voice: Pretend you are polishing a glass the entire time..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `lucky/greet_1.ogg` | Pull up a stool, runner. Mind the one with the stain. It's fond of you. | Greeting the player. In character. |
| 2 | [ ] | `lucky/greet_2.ogg` | The usual? Whatever that was. You never finish your sentences. | Greeting the player. In character. |
| 3 | [ ] | `lucky/greet_3.ogg` | Lucky's. We don't water it down. Much. We definitely don't change the ice. | Greeting the player. In character. |
| 4 | [ ] | `lucky/greet_4.ogg` | Good to see you breathing. I had you at even money for 'not.' | Greeting the player. In character. |
| 5 | [ ] | `lucky/farewell_1.ogg` | Drink responsibly. Or at least first. That's the whole policy. | Parting words as the player leaves. |
| 6 | [ ] | `lucky/farewell_2.ogg` | Come back in one piece. Two pieces. I'm not picky, I have a mop. | Parting words as the player leaves. |
| 7 | [ ] | `lucky/farewell_3.ogg` | I'll keep your seat warm. And your tab open. It's the only thing that never closes. | Parting words as the player leaves. |
| 8 | [ ] | `lucky/farewell_4.ogg` | Break a leg. Not your own. Someone else's. Nicer. | Parting words as the player leaves. |
| 9 | [ ] | `lucky/rich_1.ogg` | First round's on me. Second on you. And your fortune. And your remaining dignity. | The player is carrying a lot of money. |
| 10 | [ ] | `lucky/rich_2.ogg` | That's a lot of green. I've a Scotch that'll cry. A good cry. It's earned it. | The player is carrying a lot of money. |
| 11 | [ ] | `lucky/rich_3.ogg` | Cash like that needs a toast. And an alibi. | The player is carrying a lot of money. |
| 12 | [ ] | `lucky/rich_4.ogg` | You're buying, aren't you. It's not a question. I'm getting the glasses. | The player is carrying a lot of money. |
| 13 | [ ] | `lucky/broke_1.ogg` | Tab's on me. Don't make it a habit. Make it a hobby. A small one. | The player is nearly broke. |
| 14 | [ ] | `lucky/broke_2.ogg` | I'll pour you water. It's all I've got that's free. It's also all I've got that's honest. | The player is nearly broke. |
| 15 | [ ] | `lucky/broke_3.ogg` | Broke? Join the club. I'm the president. Dues are one drink. Per sorrow. | The player is nearly broke. |
| 16 | [ ] | `lucky/broke_4.ogg` | Not a problem. Sit. Cry. Hydrate. The tears are on the house. | The player is nearly broke. |
| 17 | [ ] | `lucky/ugly_1.ogg` | That outfit's strong. Like my worst whiskey. And you smell similar. | The player is wearing ugly clothes. |
| 18 | [ ] | `lucky/ugly_2.ogg` | Not my business what you wear. It's my business that it hurts. | The player is wearing ugly clothes. |
| 19 | [ ] | `lucky/ugly_3.ogg` | I've seen better coats in the lost and found. The coats were also on fire. | The player is wearing ugly clothes. |
| 20 | [ ] | `lucky/ugly_4.ogg` | A drink might help. Or at least blur it. For both of us. | The player is wearing ugly clothes. |
| 21 | [ ] | `lucky/sharp_1.ogg` | Look at you. All class and no chaser. Wait, I have chasers. Oh good. | The player is dressed sharp. |
| 22 | [ ] | `lucky/sharp_2.ogg` | Dressed to kill. Or at least be killed in. It's a good look either way. | The player is dressed sharp. |
| 23 | [ ] | `lucky/sharp_3.ogg` | That suit deserves a good Scotch. You deserve a cheap one. Fair? | The player is dressed sharp. |
| 24 | [ ] | `lucky/sharp_4.ogg` | You almost look like you belong here. Don't worry. A drink will fix that. | The player is dressed sharp. |
| 25 | [ ] | `lucky/died_1.ogg` | Ah, you died. Have a drink. It helps. It doesn't, but it's something to do with your hands. | The player just died. |
| 26 | [ ] | `lucky/died_2.ogg` | Rough one. I'll keep the stool warm. And the bleach handy. | The player just died. |
| 27 | [ ] | `lucky/died_3.ogg` | I've buried better drunks than you. And worse. Mostly worse. Mostly me. | The player just died. |
| 28 | [ ] | `lucky/died_4.ogg` | A drink can save your life, runner. A second can end it. A third is the Marker. | The player just died. |
| 29 | [ ] | `lucky/boss_1.ogg` | You beat a boss? The next round's mine. And the one after. And the funeral. | The player just beat a boss. |
| 30 | [ ] | `lucky/boss_2.ogg` | Cheers to the one that fell! May he rest, and may his tab be forgiven! It won't be! | The player just beat a boss. |
| 31 | [ ] | `lucky/boss_3.ogg` | That boss drank here. Tipped badly. Died worse. | The player just beat a boss. |
| 32 | [ ] | `lucky/boss_4.ogg` | A toast: to the one who didn't die tonight. Tonight being relative. | The player just beat a boss. |
| 33 | [ ] | `lucky/idle_1.ogg` | I keep a bar on most floors. Out of spite. And grief. Mostly grief. Spite's a bonus. | Idle chatter. Random. |
| 34 | [ ] | `lucky/idle_2.ogg` | I know a guy who knows a guy. I'm the guy. The other guy is also me. | Idle chatter. Random. |
| 35 | [ ] | `lucky/idle_3.ogg` | A drink never lies. Only the drinker does. And the bartender. Ask me about the bartender. | Idle chatter. Random. |
| 36 | [ ] | `lucky/idle_4.ogg` | Wipe the glass. Listen. That's the whole job. Also, apologize. Constantly. | Idle chatter. Random. |
| 37 | [ ] | `lucky/buy_1.ogg` | Down the hatch. Gently. Like a bad idea. | The player just bought something. |
| 38 | [ ] | `lucky/buy_2.ogg` | That one has a kick. And a story. Neither has an ending. | The player just bought something. |
| 39 | [ ] | `lucky/buy_3.ogg` | Careful. Don't spill your luck. Spill your guts. Different thing. | The player just bought something. |
| 40 | [ ] | `lucky/buy_4.ogg` | On the house. Sort of. I mean, the House won't cover it. It never does. | The player just bought something. |
| 41 | [ ] | `_cutscenes/intro_cast/intro_cast_2.ogg` | Lucky's the name. I keep a bar on most floors. A drink can save your life, runner. A second one can end it. I'm a bartender, not a prophet. | Cutscene: intro cast |
| 42 | [ ] | `lucky/lucky_intro_1.ogg` | Lucky's the name. On the floors I pour drinks. Up here I just listen. | Conversation: lucky_intro |
| 43 | [ ] | `lucky/lucky_intro_2.ogg` | Everybody busts eventually. Barkeeps hear all about it. It's the worst part of the job and the only part. | Conversation: lucky_intro |
| 44 | [ ] | `lucky/lucky_tip_1.ogg` | Pro tip: a Shot of Courage costs less than the interest on a bust. Find my bar on the floors. I have a lot of bars. I have trust issues. | Conversation: lucky_tip |
| 45 | [ ] | `lucky/lucky_cat_1.ogg` | Keep petting Comp like that and he'll follow you up. ...He won't. He's a cat. But he likes you. It's creepy. | Conversation: lucky_cat |
| 46 | [ ] | `lucky/lucky_rep1_1.ogg` | On the house? Nothing's on the house. That's the House's whole thing. It's in the name. | Conversation: lucky_rep1 |
| 47 | [ ] | `lucky/lucky_rep2_1.ogg` | You've got the look of somebody about to let it ride. Tell me when. I'll film it. | Conversation: lucky_rep2 |

### JULES: 47 lines

Folder: `voice/jules/` (cutscene lines go in the folder shown). Voice: Whisper like you have not slept since Tuesday..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `jules/greet_1.ogg` | Rico? Is it really you? I've had that hallucination before. He's usually taller. | Greeting the player. In character. |
| 2 | [ ] | `jules/greet_2.ogg` | I knew you'd come. I just didn't know when. I did bet on 'never,' though. | Greeting the player. In character. |
| 3 | [ ] | `jules/greet_3.ogg` | One more hand. Just one. Oh. It's you. You can have the hand. | Greeting the player. In character. |
| 4 | [ ] | `jules/greet_4.ogg` | Is it morning? What day is it? Is there a day? Who has the clock? | Greeting the player. In character. |
| 5 | [ ] | `jules/farewell_1.ogg` | Don't wait for me. Go. I'm busy being a cautionary tale. | Parting words as the player leaves. |
| 6 | [ ] | `jules/farewell_2.ogg` | Say hi to Mom. Or don't. She'll worry. Then she'll ask for the money back. | Parting words as the player leaves. |
| 7 | [ ] | `jules/farewell_3.ogg` | Take the money. Leave the cards. And the dice. And the chair. I'm attached to the chair. | Parting words as the player leaves. |
| 8 | [ ] | `jules/farewell_4.ogg` | Come back. I'll be here. I'm always here. It's, like, a whole problem. | Parting words as the player leaves. |
| 9 | [ ] | `jules/rich_1.ogg` | That's a lot of chips. I know the feeling. Don't trust it. It's a lie told by a sparkly liar. | The player is carrying a lot of money. |
| 10 | [ ] | `jules/rich_2.ogg` | I had that much once. For ten minutes. Then I had a dealer's smile. | The player is carrying a lot of money. |
| 11 | [ ] | `jules/rich_3.ogg` | Bank it. I'm begging. I'm not above begging. I'm below it. Watch. | The player is carrying a lot of money. |
| 12 | [ ] | `jules/rich_4.ogg` | I was rich once. It didn't help. It just changed how I lost. | The player is carrying a lot of money. |
| 13 | [ ] | `jules/broke_1.ogg` | Broke? Welcome. It's cozy. The walls are close and the rent is nothing. | The player is nearly broke. |
| 14 | [ ] | `jules/broke_2.ogg` | I've been broke for three years. It's fine. I have a lot of hobbies. Mostly regret. | The player is nearly broke. |
| 15 | [ ] | `jules/broke_3.ogg` | It's just money. It was never ours. It was the House's. Look at the logo. | The player is nearly broke. |
| 16 | [ ] | `jules/broke_4.ogg` | At least we're broke together. That's called family. Or a pyramid scheme. | The player is nearly broke. |
| 17 | [ ] | `jules/ugly_1.ogg` | Nice outfit. I love it. I'm lying. I'm so lying. | The player is wearing ugly clothes. |
| 18 | [ ] | `jules/ugly_2.ogg` | I'd say something. But you're my brother. I'd just say it more quietly. | The player is wearing ugly clothes. |
| 19 | [ ] | `jules/ugly_3.ogg` | You look like me. After three years. And one stain. Is that mine? | The player is wearing ugly clothes. |
| 20 | [ ] | `jules/ugly_4.ogg` | Mom would cry. Then laugh. Then ask where you got it. Then cry again. | The player is wearing ugly clothes. |
| 21 | [ ] | `jules/sharp_1.ogg` | You look great. Suspiciously great. Who died? Is it me? Is it me? | The player is dressed sharp. |
| 22 | [ ] | `jules/sharp_2.ogg` | Look at you. Dad would be proud. Dad would also ask where you stole it. | The player is dressed sharp. |
| 23 | [ ] | `jules/sharp_3.ogg` | I used to dress like that. Before. Now I dress like 'before.' | The player is dressed sharp. |
| 24 | [ ] | `jules/sharp_4.ogg` | Did you buy that with my debts? It's got my fingerprints. And my interest. | The player is dressed sharp. |
| 25 | [ ] | `jules/died_1.ogg` | You died? Welcome to my life. It's less dead than you'd think. More dead than I'd like. | The player just died. |
| 26 | [ ] | `jules/died_2.ogg` | It doesn't hurt after the first twenty. Then it's just administrative. | The player just died. |
| 27 | [ ] | `jules/died_3.ogg` | I've died here a hundred times. You get used to it. And the lighting. | The player just died. |
| 28 | [ ] | `jules/died_4.ogg` | Get up, Rico. It's just money. And a body. And a soul. And a deposit. | The player just died. |
| 29 | [ ] | `jules/boss_1.ogg` | You beat a boss? I never got past the third. Or did. They blur together. Like all my mistakes. | The player just beat a boss. |
| 30 | [ ] | `jules/boss_2.ogg` | I heard the table go quiet. It was you. Or the building collapsing. Both are fine. | The player just beat a boss. |
| 31 | [ ] | `jules/boss_3.ogg` | The House is going to notice. It notices everything. It noticed me twice. | The player just beat a boss. |
| 32 | [ ] | `jules/boss_4.ogg` | I'm proud. And scared. And a little jealous. Mostly jealous. Win more, loser. | The player just beat a boss. |
| 33 | [ ] | `jules/idle_1.ogg` | The cards remember everything. Especially the bad ones. Especially me. | Idle chatter. Random. |
| 34 | [ ] | `jules/idle_2.ogg` | You hear that? The wheel. It never stops. It also never says sorry. | Idle chatter. Random. |
| 35 | [ ] | `jules/idle_3.ogg` | I counted every floor. There's more. Always more. It's a growing business. | Idle chatter. Random. |
| 36 | [ ] | `jules/idle_4.ogg` | Be careful with the House. It's not a person. It's a vibe with lawyers. | Idle chatter. Random. |
| 37 | [ ] | `jules/buy_1.ogg` | Good pick. I'd have picked it too. I lost anyway. Eventually, with style. | The player just bought something. |
| 38 | [ ] | `jules/buy_2.ogg` | Take my advice: don't. Take my advice again: don't. You're not listening. Brother. | The player just bought something. |
| 39 | [ ] | `jules/buy_3.ogg` | It might work. Mine didn't. But I'm an optimist. By which I mean broke. | The player just bought something. |
| 40 | [ ] | `jules/buy_4.ogg` | At least you're trying. That's what I said. Right before the funeral. | The player just bought something. |
| 41 | [ ] | `_cutscenes/ending/ending_2.ogg` | ...Rico? You climbed five casinos for me? I'm up eleven grand! I'm on a RUN! | Cutscene: ending |
| 43 | [ ] | `jules/jules_home_1.ogg` | Rico. I keep waking up in the apartment. Old habits. The House still thinks I owe it. Which, to be fair, I do. | Conversation: jules_home |
| 44 | [ ] | `jules/jules_home_2.ogg` | Thanks for coming for me. Now let me come with you. Pick me on the title screen. I hit harder than you. I also steal. | Conversation: jules_home |
| 45 | [ ] | `jules/jules_eddie_1.ogg` | Those losing tickets are Eddie Duval's trail. I dealt to that voice every night for three years. | Conversation: jules_eddie |
| 46 | [ ] | `jules/jules_eddie_2.ogg` | He doesn't want our money. He wants somebody to finally beat him so he can stop. It's the saddest ten-second pitch I've ever heard. | Conversation: jules_eddie |
| 47 | [ ] | `jules/jules_rep1_1.ogg` | Bank it, Rico. I didn't. Look where it got me. A very comfortable cell with a view. | Conversation: jules_rep1 |
| 48 | [ ] | `jules/jules_rep2_1.ogg` | The House cheats. So we cheat better. That's called family values. | Conversation: jules_rep2 |

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
| 10 | [ ] | `comp/farewell_1.ogg` | Mrrrrow. (Goodbye. And bring fish. Or Jules.) | Parting words as the player leaves. |
| 11 | [ ] | `comp/farewell_2.ogg` | Meeeeow. | Parting words as the player leaves. |
| 12 | [ ] | `comp/rich_1.ogg` | Prrrrr. (You smell like money.) | The player is carrying a lot of money. |
| 13 | [ ] | `comp/rich_2.ogg` | Mrow! (Share.) | The player is carrying a lot of money. |
| 14 | [ ] | `comp/broke_1.ogg` | Hss. (Bad.) | The player is nearly broke. |
| 15 | [ ] | `comp/broke_2.ogg` | Mew. (There, there.) | The player is nearly broke. |
| 16 | [ ] | `comp/died_1.ogg` | Mrrrrrow. (I saw that. I'm telling no one. I'm a cat.) | The player just died. |
| 17 | [ ] | `comp/boss_1.ogg` | Purrr. (Not bad, human.) | The player just beat a boss. |

### SILAS STITCH: 41 lines

Folder: `voice/tailor/` (cutscene lines go in the folder shown). Voice: Sniff at the player's outfit before each line..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `tailor/greet_1.ogg` | Do come in. Mind the pins. And the mannequins, they bite when ignored. | Greeting the player. In character. |
| 2 | [ ] | `tailor/greet_2.ogg` | Ah. A customer. Or a stray. Hold still, I shall find out which. | Greeting the player. In character. |
| 3 | [ ] | `tailor/greet_3.ogg` | Silas Stitch, at your service. And at your waistline. Good heavens, there's a lot of it. | Greeting the player. In character. |
| 4 | [ ] | `tailor/greet_4.ogg` | Good heavens. Sit down before you offend the mannequins. They have feelings. Sadly, no opinions on you. | Greeting the player. In character. |
| 5 | [ ] | `tailor/farewell_1.ogg` | Wear it well. Or wear it. Anything. Please do not carry it. | Parting words as the player leaves. |
| 6 | [ ] | `tailor/farewell_2.ogg` | Mind the hem on the way out. And the door. And your life choices. | Parting words as the player leaves. |
| 7 | [ ] | `tailor/farewell_3.ogg` | Do try not to bleed on the silk. Or the wool. Or me. | Parting words as the player leaves. |
| 8 | [ ] | `tailor/farewell_4.ogg` | Come back for a fitting. And a lecture. I've prepared the lecture. It's forty minutes. | Parting words as the player leaves. |
| 9 | [ ] | `tailor/rich_1.ogg` | Splendid. A gentleman with means. Let us begin the long lie that you have taste. | The player is carrying a lot of money. |
| 10 | [ ] | `tailor/rich_2.ogg` | Ah, the pockets are heavy. The hems shall be lovely. I'll bill you for both. | The player is carrying a lot of money. |
| 11 | [ ] | `tailor/rich_3.ogg` | With that fortune, we might fix your posture. Surgery is also an option. | The player is carrying a lot of money. |
| 12 | [ ] | `tailor/rich_4.ogg` | Money! How delightfully vulgar. Please, spend it. On me. Beautifully. | The player is carrying a lot of money. |
| 13 | [ ] | `tailor/broke_1.ogg` | No funds? Then we tailor in imagination. Imagine a very nice belt. There. That's two dollars. | The player is nearly broke. |
| 14 | [ ] | `tailor/broke_2.ogg` | I can give you a very nice belt of regret. It's free. It's itchy. | The player is nearly broke. |
| 15 | [ ] | `tailor/broke_3.ogg` | Poverty is just fashion in beta. And you've been in beta for years. | The player is nearly broke. |
| 16 | [ ] | `tailor/broke_4.ogg` | Come back when you can afford sleeves. Until then, you're a vest. A tragic vest. | The player is nearly broke. |
| 17 | [ ] | `tailor/ugly_1.ogg` | Dear boy, did you dress in a dumpster? Don't answer. The smell has answered. | The player is wearing ugly clothes. |
| 18 | [ ] | `tailor/ugly_2.ogg` | That fanny pack is a war crime. I'd testify. | The player is wearing ugly clothes. |
| 19 | [ ] | `tailor/ugly_3.ogg` | I will not say what I think. I will faint. Watch. There. I'm up. Ugh. | The player is wearing ugly clothes. |
| 20 | [ ] | `tailor/ugly_4.ogg` | You look like a rumor of an outfit. And the rumor is bad. | The player is wearing ugly clothes. |
| 21 | [ ] | `tailor/sharp_1.ogg` | Now THAT is a proper silhouette. A murder suspect, but a dapper one. | The player is dressed sharp. |
| 22 | [ ] | `tailor/sharp_2.ogg` | Magnificent. I'd put it in a museum. Next to the ones that died in it. | The player is dressed sharp. |
| 23 | [ ] | `tailor/sharp_3.ogg` | You are a credit to the craft. And my commission. | The player is dressed sharp. |
| 24 | [ ] | `tailor/sharp_4.ogg` | I made half of that. The other half is you. Barely. Squint. | The player is dressed sharp. |
| 25 | [ ] | `tailor/died_1.ogg` | You died in my wares? Did it stain? Please say it didn't stain. | The player just died. |
| 26 | [ ] | `tailor/died_2.ogg` | A dead client is a quiet client. A bloody client is a lawsuit. | The player just died. |
| 27 | [ ] | `tailor/died_3.ogg` | Do bleed on the old stock, please. Not the new silk. NOT the silk. | The player just died. |
| 28 | [ ] | `tailor/died_4.ogg` | Hold still. I'll repair the holes. Which ones are bullet holes and which are style? Don't tell me. | The player just died. |
| 29 | [ ] | `tailor/boss_1.ogg` | Defeated a boss? Marvelous! Armor, then. Fashionable armor. Is there another kind? | The player just beat a boss. |
| 30 | [ ] | `tailor/boss_2.ogg` | Slaying monsters in silk. Delightful. Stains come out with lemon, wine, and prayer. | The player just beat a boss. |
| 31 | [ ] | `tailor/boss_3.ogg` | The trophies will need a tasteful frame. And a priest. | The player just beat a boss. |
| 32 | [ ] | `tailor/boss_4.ogg` | I made that boss a suit. He hated it. He's dead now, so it's a little better. | The player just beat a boss. |
| 33 | [ ] | `tailor/idle_1.ogg` | Gloves for gripping. Boots for smashing. Scarves for gliding. Hats for nothing, I just like hats. | Idle chatter. Random. |
| 34 | [ ] | `tailor/idle_2.ogg` | The shoes make the man. The man makes the dash. The dash makes my rent. | Idle chatter. Random. |
| 35 | [ ] | `tailor/idle_3.ogg` | Stand straight. The cloth knows. The cloth is judging your spine. | Idle chatter. Random. |
| 36 | [ ] | `tailor/idle_4.ogg` | Everything I sell grants a talent. Mostly vanity. Sometimes a double jump. | Idle chatter. Random. |
| 37 | [ ] | `tailor/buy_1.ogg` | A fine choice. I knew it'd suit you. I say that to everyone. It's never true. | The player just bought something. |
| 38 | [ ] | `tailor/buy_2.ogg` | Wear it with confidence. Or at least shoes. Shoes are the minimum. | The player just bought something. |
| 39 | [ ] | `tailor/buy_3.ogg` | I shall tell the thread you said hello. The thread has opinions. | The player just bought something. |
| 40 | [ ] | `tailor/buy_4.ogg` | One moment. The pins are my pride. And my weapons. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city5_arrive/city5_arrive_2.ogg` | Dear boy, the cloak room is that way. We shall do what we can. | Cutscene: city5 arrive |

### DOC FIZZ: 40 lines

Folder: `voice/fizz/` (cutscene lines go in the folder shown). Voice: Whisper-yell. Look over your shoulder after each sentence..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `fizz/greet_1.ogg` | Psst. Hey. You. Want a pick-me-up? Side effects include being picked up. By paramedics. | Greeting the player. In character. |
| 2 | [ ] | `fizz/greet_2.ogg` | Quiet. Come closer. Closer. NOT that close. Ugh, you breathe a lot. | Greeting the player. In character. |
| 3 | [ ] | `fizz/greet_3.ogg` | Welcome to the pharmacy. We're not licensed. We're barely lichen. | Greeting the player. In character. |
| 4 | [ ] | `fizz/greet_4.ogg` | Finally. A customer. Or a cop. Are you a cop? Blink if you're a cop. Don't blink. | Greeting the player. In character. |
| 5 | [ ] | `fizz/farewell_1.ogg` | Don't tell anyone. Especially me. I've already forgotten. | Parting words as the player leaves. |
| 6 | [ ] | `fizz/farewell_2.ogg` | Side effects begin immediately. And permanently. And, rarely, in French. | Parting words as the player leaves. |
| 7 | [ ] | `fizz/farewell_3.ogg` | Go! Run! Be amazing! Or dead! Statistically it's dead! | Parting words as the player leaves. |
| 8 | [ ] | `fizz/farewell_4.ogg` | Keep the bottle. I don't want it back. It's looking at me. | Parting words as the player leaves. |
| 9 | [ ] | `fizz/rich_1.ogg` | Oh, you're LOADED. I have the GOOD stuff. It's in the other, worse bag. | The player is carrying a lot of money. |
| 10 | [ ] | `fizz/rich_2.ogg` | Cash! Real cash! My favorite flavor! Tastes like a lawyer! | The player is carrying a lot of money. |
| 11 | [ ] | `fizz/rich_3.ogg` | For you, double price, triple effect, quadruple lawsuit. | The player is carrying a lot of money. |
| 12 | [ ] | `fizz/rich_4.ogg` | Hide that money. Spend it HERE. Where it's safe from your future. | The player is carrying a lot of money. |
| 13 | [ ] | `fizz/broke_1.ogg` | No cash? I accept organs. Small ones. Spares. You've got spares, right? | The player is nearly broke. |
| 14 | [ ] | `fizz/broke_2.ogg` | Broke? Free sample! Free as in 'my liability is now your liability.' | The player is nearly broke. |
| 15 | [ ] | `fizz/broke_3.ogg` | I trust you. I'll bill your family. Do you have a family? They do now: me. | The player is nearly broke. |
| 16 | [ ] | `fizz/broke_4.ogg` | Come back when you've been mugged by someone richer than you. Aim high. | The player is nearly broke. |
| 17 | [ ] | `fizz/ugly_1.ogg` | That outfit? It's already a hallucination. I haven't even sold you anything. | The player is wearing ugly clothes. |
| 18 | [ ] | `fizz/ugly_2.ogg` | You look like a warning label. In a good font, though. | The player is wearing ugly clothes. |
| 19 | [ ] | `fizz/ugly_3.ogg` | Don't worry, the drugs make it look better. The drugs make EVERYTHING look better. Even me. | The player is wearing ugly clothes. |
| 20 | [ ] | `fizz/ugly_4.ogg` | I've seen better fits on a cadaver. And that cadaver was DEAD. | The player is wearing ugly clothes. |
| 21 | [ ] | `fizz/sharp_1.ogg` | Fancy! The stuff will clash with your suit. Beautifully. Violently. | The player is dressed sharp. |
| 22 | [ ] | `fizz/sharp_2.ogg` | Look at you. A well-dressed mistake. My favorite kind. | The player is dressed sharp. |
| 23 | [ ] | `fizz/sharp_3.ogg` | You're too nice for this stall. Buy something. Get less nice. | The player is dressed sharp. |
| 24 | [ ] | `fizz/sharp_4.ogg` | Sharp! Let's ruin it. With science. And bile. | The player is dressed sharp. |
| 25 | [ ] | `fizz/died_1.ogg` | You look dead. Great sign. Means the product works. Try this. | The player just died. |
| 26 | [ ] | `fizz/died_2.ogg` | I heard the scream. Was it you? It was you. Good lungs. Really, great lungs. | The player just died. |
| 27 | [ ] | `fizz/died_3.ogg` | Death's not so bad. Mostly it's the sequel that's worse. I've seen the sequel. Don't see the sequel. | The player just died. |
| 28 | [ ] | `fizz/died_4.ogg` | Don't die near the merchandise. The insurance covers nothing. Literally nothing. | The player just died. |
| 29 | [ ] | `fizz/boss_1.ogg` | A boss! Down! Give me your blood for science. Just a pint. Okay, a gallon. | The player just beat a boss. |
| 30 | [ ] | `fizz/boss_2.ogg` | You killed someone big? Buy something to celebrate. Their leftovers are in the red bottle. | The player just beat a boss. |
| 31 | [ ] | `fizz/boss_3.ogg` | Bosses are just customers who never learned to share. I sold that one his last drink. | The player just beat a boss. |
| 32 | [ ] | `fizz/boss_4.ogg` | Did he have a pulse? A tooth? A kidney? Asking for... business. Not for the business. | The player just beat a boss. |
| 33 | [ ] | `fizz/idle_1.ogg` | I have a bottle that sings. It's a bad singer. It's mostly a scream. | Idle chatter. Random. |
| 34 | [ ] | `fizz/idle_2.ogg` | Everything has side effects. Even oxygen. Ask anyone who's died. | Idle chatter. Random. |
| 35 | [ ] | `fizz/idle_3.ogg` | Don't read the label. The label is lying. The label is also a bit of a coward. | Idle chatter. Random. |
| 36 | [ ] | `fizz/idle_4.ogg` | Tell me your symptoms. Then ignore my advice. That's the process. That's the whole process. | Idle chatter. Random. |
| 37 | [ ] | `fizz/buy_1.ogg` | Drink it fast. No, SLOW. Wait. FAST. Whichever one you didn't do. | The player just bought something. |
| 38 | [ ] | `fizz/buy_2.ogg` | Side effects include luck, death, and a strong opinion about jazz. | The player just bought something. |
| 39 | [ ] | `fizz/buy_3.ogg` | Do not mix with anything. I mean it. Mix it. I'm joking. Mix it. | The player just bought something. |
| 40 | [ ] | `fizz/buy_4.ogg` | A good choice! Probably! I don't read. I just pour and pray. | The player just bought something. |

### GUNNY: 40 lines

Folder: `voice/gunny/` (cutscene lines go in the folder shown). Voice: Everything is an order. Everything is a compliment..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `gunny/greet_1.ogg` | Welcome to the armory, recruit. Spit out the gum. And the teeth. Whatever that is. | Greeting the player. In character. |
| 2 | [ ] | `gunny/greet_2.ogg` | Stand up straight! That's a weapon you're holding. Your face. Terrifying. For the wrong reasons. | Greeting the player. In character. |
| 3 | [ ] | `gunny/greet_3.ogg` | Rack 'em and stack 'em, gamblers! Anything that goes bang, we have! Anything that goes whimper, that's you. | Greeting the player. In character. |
| 4 | [ ] | `gunny/greet_4.ogg` | You need firepower. I can smell it. And a shower. I can smell that too. | Greeting the player. In character. |
| 5 | [ ] | `gunny/farewell_1.ogg` | Don't shoot your foot. Shoot THEIRS. It's a different foot. Concentrate. | Parting words as the player leaves. |
| 6 | [ ] | `gunny/farewell_2.ogg` | Dismissed. Try to die forward. Dying backward is how you lose the deposit. | Parting words as the player leaves. |
| 7 | [ ] | `gunny/farewell_3.ogg` | Clean your guns. Wash your hands. Never your lucky socks. They're load-bearing. | Parting words as the player leaves. |
| 8 | [ ] | `gunny/farewell_4.ogg` | Move out, rookie. And don't bet the ammo. I know you. I KNOW you. | Parting words as the player leaves. |
| 9 | [ ] | `gunny/rich_1.ogg` | Cash! The universal caliber! | The player is carrying a lot of money. |
| 10 | [ ] | `gunny/rich_2.ogg` | A big spender! I salute your wallet. And your wallet's tiny spine. | The player is carrying a lot of money. |
| 11 | [ ] | `gunny/rich_3.ogg` | Now THAT is purchasing power. Also, the power of someone with no plan. | The player is carrying a lot of money. |
| 12 | [ ] | `gunny/rich_4.ogg` | I'll throw in a free ammo clip. And a salute. And a hug. No. Not the hug. Not the hug. | The player is carrying a lot of money. |
| 13 | [ ] | `gunny/broke_1.ogg` | No money, no bang. It's simple. It's also the plot of your life. | The player is nearly broke. |
| 14 | [ ] | `gunny/broke_2.ogg` | Broke? Throw rocks. It's a classic. Rocks have a perfect safety record. Mostly. | The player is nearly broke. |
| 15 | [ ] | `gunny/broke_3.ogg` | A recruit with no cash. It's a start. It's also a funeral. | The player is nearly broke. |
| 16 | [ ] | `gunny/broke_4.ogg` | I'm not a charity. I'm a battle store. The difference is the screaming. | The player is nearly broke. |
| 17 | [ ] | `gunny/ugly_1.ogg` | Soldier, that outfit is a disciplinary action. And a warcrime. And a Tuesday. | The player is wearing ugly clothes. |
| 18 | [ ] | `gunny/ugly_2.ogg` | Camouflage? You look like a bruise. A sad, wandering bruise. | The player is wearing ugly clothes. |
| 19 | [ ] | `gunny/ugly_3.ogg` | I've seen better uniforms on a scarecrow. Scarecrow had a better stance, too. | The player is wearing ugly clothes. |
| 20 | [ ] | `gunny/ugly_4.ogg` | What happened to your pants, recruit? Did you lose them to the House? Did the House want them? | The player is wearing ugly clothes. |
| 21 | [ ] | `gunny/sharp_1.ogg` | Spit-shined! I'm almost proud. I'm also a little emotional. Moving on! | The player is dressed sharp. |
| 22 | [ ] | `gunny/sharp_2.ogg` | That suit says 'I'm lethal in four languages.' Shame you only speak panic. | The player is dressed sharp. |
| 23 | [ ] | `gunny/sharp_3.ogg` | You look like a general. Behave like one. Send others to die. It's the job. | The player is dressed sharp. |
| 24 | [ ] | `gunny/sharp_4.ogg` | A sharp dresser holds a gun better. A dead one holds it worst. | The player is dressed sharp. |
| 25 | [ ] | `gunny/died_1.ogg` | You're dead? Walk it off! Or crawl it off! Either way, off! | The player just died. |
| 26 | [ ] | `gunny/died_2.ogg` | That's what the armor's for, rookie. You forgot the armor. You always forget the armor. | The player just died. |
| 27 | [ ] | `gunny/died_3.ogg` | Retrain. Rearm. Resurrect. Repeat. That's the whole military. And your whole career. | The player just died. |
| 28 | [ ] | `gunny/died_4.ogg` | The only bad death is the unarmed one. Yours was the second kind. | The player just died. |
| 29 | [ ] | `gunny/boss_1.ogg` | A boss down! Medals for everyone! Except the boss! He gets a closed casket! | The player just beat a boss. |
| 30 | [ ] | `gunny/boss_2.ogg` | That's the kind of firepower I like! Large, loud, and legally ambiguous! | The player just beat a boss. |
| 31 | [ ] | `gunny/boss_3.ogg` | I sold that boss his first revolver. I regret nothing. I regret his trigger discipline. | The player just beat a boss. |
| 32 | [ ] | `gunny/boss_4.ogg` | You make me proud. Don't make it weird. Too late. It's weird. | The player just beat a boss. |
| 33 | [ ] | `gunny/idle_1.ogg` | Chip flick. Card fan. Dice bomb. Pick one. Pick all. Pick a fight. | Idle chatter. Random. |
| 34 | [ ] | `gunny/idle_2.ogg` | A revolver has six reasons. Use five. Save one for the barista. | Idle chatter. Random. |
| 35 | [ ] | `gunny/idle_3.ogg` | Coin shotgun's the favorite. Don't ask why. It's illegal in four countries and a Pizza Hut. | Idle chatter. Random. |
| 36 | [ ] | `gunny/idle_4.ogg` | Weapons don't kill people. Bad odds do. And pointy things. And Gary. | Idle chatter. Random. |
| 37 | [ ] | `gunny/buy_1.ogg` | Excellent! Point it away from yourself! And me! And the cat! | The player just bought something. |
| 38 | [ ] | `gunny/buy_2.ogg` | That's a classic. Respect it. It's seen things. Mostly foreheads. | The player just bought something. |
| 39 | [ ] | `gunny/buy_3.ogg` | Eight out of ten customers survive. Not you. You're a nine. Of ten. Out of eight. | The player just bought something. |
| 40 | [ ] | `gunny/buy_4.ogg` | Good choice, recruit. It kicks. Mostly the person holding it. Hold it tighter. | The player just bought something. |

### VELMA VELVET: 16 lines

Folder: `voice/velma/` (cutscene lines go in the folder shown). Voice: You are singing the last song of the night..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `velma/idle_1.ogg` | Honey, I've lost more than you've bet. And I got a standing ovation. | Idle chatter. Random. |
| 2 | [ ] | `velma/idle_2.ogg` | This next one's for the broken-hearted. And the broke. And the broken-hearted broke. Table four. | Idle chatter. Random. |
| 3 | [ ] | `velma/idle_3.ogg` | Dim the lights. The odds are shy. So is my husband. He's in a trunk. | Idle chatter. Random. |
| 4 | [ ] | `velma/idle_4.ogg` | Last call for love. Everything's last call. Except the ones with a lawyer. | Idle chatter. Random. |
| 5 | [ ] | `velma/greet_1.ogg` | Evening, sugar. Pull up a shadow. They're cheaper than chairs. | Greeting the player. In character. |
| 6 | [ ] | `velma/greet_2.ogg` | You look like a song I forgot the end of. A sad one. In a minor key. Mostly a minor key. | Greeting the player. In character. |
| 7 | [ ] | `velma/greet_3.ogg` | Take a seat. Take a chance. Take a breath. Not all three. You'll pass out. | Greeting the player. In character. |
| 8 | [ ] | `velma/farewell_1.ogg` | Don't be a stranger. Be a legend. Or a stranger with a legend. I'm not picky. | Parting words as the player leaves. |
| 9 | [ ] | `velma/farewell_2.ogg` | The stage'll be here. So will I. So will the debt. | Parting words as the player leaves. |
| 10 | [ ] | `velma/farewell_3.ogg` | Go. Win something. Lose something prettier. Bring a hat. | Parting words as the player leaves. |
| 11 | [ ] | `velma/rich_1.ogg` | Oh, you're in the money. Sing with me. I'll do the money. You do the dying. | The player is carrying a lot of money. |
| 12 | [ ] | `velma/rich_2.ogg` | Diamonds are a girl's best chips. Chips are a girl's best diamonds. Hand them over. | The player is carrying a lot of money. |
| 13 | [ ] | `velma/broke_1.ogg` | Broke and brave. My favorite lyric. It rhymes with 'sleep outside.' | The player is nearly broke. |
| 14 | [ ] | `velma/broke_2.ogg` | Come sit. The blues are free. It's the encore that costs. | The player is nearly broke. |
| 15 | [ ] | `velma/died_1.ogg` | I wrote a song about you. It's mostly a sigh. With a bridge. The bridge is you, falling off one. | The player just died. |
| 16 | [ ] | `velma/boss_1.ogg` | I'll sing about that one. Twice. Once for the win, once for the funeral. | The player just beat a boss. |

### DUMPSTER DAN: 16 lines

Folder: `voice/dumpster_dan/` (cutscene lines go in the folder shown). Voice: Laugh at your own points, then cough..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `dumpster_dan/idle_1.ogg` | Got any change? Got any WISDOM? I'll take either. I'll take a sandwich. | Idle chatter. Random. |
| 2 | [ ] | `dumpster_dan/idle_2.ogg` | The rats pay rent. Do you? Because Rattigan hasn't missed a month. | Idle chatter. Random. |
| 3 | [ ] | `dumpster_dan/idle_3.ogg` | I used to teach economics. Now I eat economics. It's mostly gristle. | Idle chatter. Random. |
| 4 | [ ] | `dumpster_dan/idle_4.ogg` | The walls have secrets. Some are loose. Some are Jules's. He pawned a jacket. Ask the jacket. | Idle chatter. Random. |
| 5 | [ ] | `dumpster_dan/greet_1.ogg` | Hey there, friend. Spare a smile? I'll take a molar. | Greeting the player. In character. |
| 6 | [ ] | `dumpster_dan/greet_2.ogg` | Ooh, a visitor! Or a hallucination. Both are nice. Both tip the same. | Greeting the player. In character. |
| 7 | [ ] | `dumpster_dan/greet_3.ogg` | You look like a man with a destiny and a wallet. One of them is lying. | Greeting the player. In character. |
| 8 | [ ] | `dumpster_dan/farewell_1.ogg` | Come back when you're rich! Or me. I'll be rich! Or dead! | Parting words as the player leaves. |
| 9 | [ ] | `dumpster_dan/farewell_2.ogg` | Mind the third brick. It likes to move. It was my wife. | Parting words as the player leaves. |
| 10 | [ ] | `dumpster_dan/farewell_3.ogg` | Don't forget me. Everybody does. It's a whole thing. I do a bit about it. | Parting words as the player leaves. |
| 11 | [ ] | `dumpster_dan/rich_1.ogg` | Look at you! The Midas of the alley! Touch me. Not like that. Pay me. | The player is carrying a lot of money. |
| 12 | [ ] | `dumpster_dan/rich_2.ogg` | That's more than I've seen since 1998. I had a good '98. A year, not a person. | The player is carrying a lot of money. |
| 13 | [ ] | `dumpster_dan/broke_1.ogg` | Ha! Welcome to the club. We've got cardboard. And a mildew sauna. | The player is nearly broke. |
| 14 | [ ] | `dumpster_dan/broke_2.ogg` | Poor! It's honest. It's also drafty. | The player is nearly broke. |
| 15 | [ ] | `dumpster_dan/died_1.ogg` | Don't worry. Death's mostly paperwork. I've done the paperwork. They said it was fine. They didn't say it was good. | The player just died. |
| 16 | [ ] | `dumpster_dan/boss_1.ogg` | The boss? I raised him. He was a lovely child. Strangled the cat. A lovely child. | The player just beat a boss. |

### SLICK NICK: 17 lines

Folder: `voice/slick_nick/` (cutscene lines go in the folder shown). Voice: Wink with your voice..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `slick_nick/idle_1.ogg` | I'm smarter than you and twice as handsome. Your brother had the third thing. Ha. Debt. | Idle chatter. Random. |
| 2 | [ ] | `slick_nick/idle_2.ogg` | Luck? I don't need luck. I have hair. And a trust fund. And hair. | Idle chatter. Random. |
| 3 | [ ] | `slick_nick/idle_3.ogg` | I read the odds. And then I rewrite them. In crayon. | Idle chatter. Random. |
| 4 | [ ] | `slick_nick/idle_4.ogg` | Don't take it personally. Take it to the bank. They'll laugh. In your face. Take it anyway. | Idle chatter. Random. |
| 5 | [ ] | `slick_nick/greet_1.ogg` | Well, well. If it isn't my favorite sucker. Wait, you're the only one. Wow, dismal. | Greeting the player. In character. |
| 6 | [ ] | `slick_nick/greet_2.ogg` | Ah, the other gambler. Cute. Like a puppy. A puppy with a Marker. | Greeting the player. In character. |
| 7 | [ ] | `slick_nick/greet_3.ogg` | Looking for a rival? You found one. I'm excellent. Also: expensive. | Greeting the player. In character. |
| 8 | [ ] | `slick_nick/farewell_1.ogg` | Don't lose too early. I want to win later. Ideally on your grave. | Parting words as the player leaves. |
| 9 | [ ] | `slick_nick/farewell_2.ogg` | See you at the top. I'll be there. First. In a better suit. | Parting words as the player leaves. |
| 10 | [ ] | `slick_nick/farewell_3.ogg` | Try not to embarrass yourself. I'll be watching. With popcorn. | Parting words as the player leaves. |
| 11 | [ ] | `slick_nick/rich_1.ogg` | Nice pot. I have a bigger one. I always have a bigger one. It's genetic. | The player is carrying a lot of money. |
| 12 | [ ] | `slick_nick/rich_2.ogg` | You're doing great! For you. For a normal person you're doing 'whoa, buddy.' | The player is carrying a lot of money. |
| 13 | [ ] | `slick_nick/broke_1.ogg` | Oof. Broke? Must be rough being you. I hear it's also a smell. | The player is nearly broke. |
| 14 | [ ] | `slick_nick/broke_2.ogg` | I'd buy you a drink. But no. I'd buy you the idea of a drink. Cheers. | The player is nearly broke. |
| 15 | [ ] | `slick_nick/died_1.ogg` | You died? I won. Again. I didn't even play. It's that easy. | The player just died. |
| 16 | [ ] | `slick_nick/boss_1.ogg` | A boss? I was about to do that. Today. After lunch. And brunch. | The player just beat a boss. |
| 17 | [ ] | `slick_nick/boss_2.ogg` | Lucky shot. Everyone's lucky once. You've been lucky twice. Statistically suspicious. | The player just beat a boss. |

### LADY LUCK LORRAINE: 16 lines

Folder: `voice/lorraine/` (cutscene lines go in the folder shown). Voice: Everything is a sign. Everything is bad luck..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `lorraine/idle_1.ogg` | Never cross your fingers. Cross a fortune-teller. They bleed less. | Idle chatter. Random. |
| 2 | [ ] | `lorraine/idle_2.ogg` | Don't whistle at a table. It summons the House. And its lawyers. Different whistles. | Idle chatter. Random. |
| 3 | [ ] | `lorraine/idle_3.ogg` | A black cat? I own three. That's the secret. Also a lot of dander. | Idle chatter. Random. |
| 4 | [ ] | `lorraine/idle_4.ogg` | Throw salt. Throw sage. Throw chips. Throw a fit. I do all four before breakfast. | Idle chatter. Random. |
| 5 | [ ] | `lorraine/greet_1.ogg` | Oh honey! You're glowing! That's either luck or fever. Let me check. It's fever. | Greeting the player. In character. |
| 6 | [ ] | `lorraine/greet_2.ogg` | Come sit, sugar. The stars are loud tonight. They're saying 'no.' | Greeting the player. In character. |
| 7 | [ ] | `lorraine/greet_3.ogg` | Wait, don't tell me. You're a Scorpio. Bad news. For you. And your stuff. | Greeting the player. In character. |
| 8 | [ ] | `lorraine/farewell_1.ogg` | Knock on wood. Knock on your own head. It's more reliable. | Parting words as the player leaves. |
| 9 | [ ] | `lorraine/farewell_2.ogg` | Take my lucky penny. It's cursed. You'll love it. It's a good curse. A hobby curse. | Parting words as the player leaves. |
| 10 | [ ] | `lorraine/farewell_3.ogg` | Go with God. And with a rabbit's foot. The rabbit's not using it. | Parting words as the player leaves. |
| 11 | [ ] | `lorraine/rich_1.ogg` | Money! It's a sign! A big sign! It says 'send me some.' | The player is carrying a lot of money. |
| 12 | [ ] | `lorraine/rich_2.ogg` | You're blessed. Or cursed. Same sparkle. Different invoice. | The player is carrying a lot of money. |
| 13 | [ ] | `lorraine/broke_1.ogg` | Broke? That's just Mercury being rude. He's always been a dick, that planet. | The player is nearly broke. |
| 14 | [ ] | `lorraine/broke_2.ogg` | Poor baby. Retrograde again. Retrograde's been going on for nine years. It's not retrograde. It's you. | The player is nearly broke. |
| 15 | [ ] | `lorraine/died_1.ogg` | Dying? Bad omen. I'll light a candle. A big one. For you. And for the fire marshal. | The player just died. |
| 16 | [ ] | `lorraine/boss_1.ogg` | A boss? Mercury's with you! Mercury's a flaky ally, but yes! | The player just beat a boss. |

### OFFICER DUNN: 16 lines

Folder: `voice/dunn/` (cutscene lines go in the folder shown). Voice: Say everything like reading the same warning for the 800th time..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `dunn/idle_1.ogg` | Sir, you can't do that here. I don't know what you're doing. But you can't. | Idle chatter. Random. |
| 2 | [ ] | `dunn/idle_2.ogg` | I'm just doing my job. Which is you. All of you. Your whole life. | Idle chatter. Random. |
| 3 | [ ] | `dunn/idle_3.ogg` | Please keep your hands where I can see them. And your chips. And your guilt. | Idle chatter. Random. |
| 4 | [ ] | `dunn/idle_4.ogg` | Management reserves the right to refuse. Everything. Including, today, me. | Idle chatter. Random. |
| 5 | [ ] | `dunn/greet_1.ogg` | Evening, sir. Behave. Or whatever the opposite of this is. Behave anyway. | Greeting the player. In character. |
| 6 | [ ] | `dunn/greet_2.ogg` | ID, please. And your life story. And a character reference. And a note from the House. | Greeting the player. In character. |
| 7 | [ ] | `dunn/greet_3.ogg` | Move along, citizen. Or stand still. I'm confused. Pick one. Either. | Greeting the player. In character. |
| 8 | [ ] | `dunn/farewell_1.ogg` | Have a nice day. Or don't. It's not my department. My department is paperwork. | Parting words as the player leaves. |
| 9 | [ ] | `dunn/farewell_2.ogg` | Exit's that way. Not that way. That way. No, THAT way. That's a window. Oh well. | Parting words as the player leaves. |
| 10 | [ ] | `dunn/farewell_3.ogg` | Enjoy your stay. Quietly. Or loudly. It's not like I'll remember. | Parting words as the player leaves. |
| 11 | [ ] | `dunn/rich_1.ogg` | That's a lot of money, sir. I'll be watching. I'll be sweating. I'll be watching. | The player is carrying a lot of money. |
| 12 | [ ] | `dunn/rich_2.ogg` | Winning is fine. Winning loudly is a violation. Winning while smiling is a felony. | The player is carrying a lot of money. |
| 13 | [ ] | `dunn/broke_1.ogg` | No funds? The exit's that way. The exit's always that way. It's my favorite sentence. | The player is nearly broke. |
| 14 | [ ] | `dunn/broke_2.ogg` | Loitering without chips is discouraged. Loitering with chips is slightly less discouraged. | The player is nearly broke. |
| 15 | [ ] | `dunn/died_1.ogg` | Sir, you can't die here. It's against policy. Policy 47: 'No dying before nine.' | The player just died. |
| 16 | [ ] | `dunn/boss_1.ogg` | You hit a boss? That's... that's an incident. I'll need a form. And a bandage. For me. | The player just beat a boss. |

### THE HOUSE: 57 lines

Folder: `voice/the_house/` (cutscene lines go in the folder shown). Voice: Say it like you are reading terms and conditions to a prisoner..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `the_house/intro_1.ogg` | Hole cards. Flop. Turn. River. And in the pot, your brother. Sit, Rico. | Boss intro cutscene. Menacing. Texas Hold'em themed. |
| 2 | [ ] | `the_house/defeat_1.ogg` | The House... folds? I... fold? Is this what it feels like? It feels... expensive. | Boss defeat. Falling apart. |
| 3 | [ ] | `the_house/phase2_1.ogg` | Interesting. The odds adjust. Mildly. Like a thermostat. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `the_house/phase3_1.ogg` | I do not lose. I RESET. You, however, will be reset. Permanently. Per the Marker. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `the_house/taunt_1.ogg` | Hole cards. Flop. Turn. River. Rico. Always the same sequence. It ends with you. | Boss taunt during an attack. |
| 6 | [ ] | `the_house/taunt_2.ogg` | The House always wins. It's not a boast. It's arithmetic. It's also your brother. | Boss taunt during an attack. |
| 7 | [ ] | `the_house/taunt_3.ogg` | Every chip you hold is already mine. So is that shirt. So is your sense of purpose. | Boss taunt during an attack. |
| 8 | [ ] | `the_house/hurt_1.ogg` | A scratch. The House endures. The House has dental insurance. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `the_house/hurt_2.ogg` | That was... noted. In a file. Titled 'Rico: ongoing.' | Boss gets hit. Grunt-style. |
| 10 | [ ] | `the_house/kill_1.ogg` | You've been folded. Like a napkin. A fancy one. Then used. | Boss kills the player. Gloating. |
| 11 | [ ] | `the_house/kill_2.ogg` | Terms and conditions apply. They always did. Page 400. Paragraph 'Jules.' | Boss kills the player. Gloating. |
| 12 | [ ] | `_cutscenes/city5_arrive/city5_arrive_3.ogg` | Welcome, Rico. We've been expecting you. For years. Your brother's been dealing since lunch. | Cutscene: city5 arrive |
| 13 | [ ] | `_cutscenes/final_prelude/final_prelude_1.ogg` | You climbed my five cities. You beat my table-lords. You wore my clothes. | Cutscene: final prelude |
| 14 | [ ] | `_cutscenes/final_prelude/final_prelude_3.ogg` | Then sit. Hole cards. Flop. Turn. River. And the pot, Rico, is your brother. | Cutscene: final prelude |
| 15 | [ ] | `_cutscenes/intro/intro_4.ogg` | Welcome, valued guest. House rules: you can't die. You simply wake up back at home, owing a little more. With interest. | Cutscene: intro |
| 16 | [ ] | `_cutscenes/intro/intro_6.ogg` | Now you're getting it. | Cutscene: intro |
| 17 | [ ] | `_cutscenes/true_ending/true_ending_1.ogg` | Again? You beat me AGAIN? Fine. Double or nothing. One more hand. Rico? Are you listening? Rico? | Cutscene: true ending |
| 18 | [ ] | `_cutscenes/true_ending/true_ending_3.ogg` | ...Nobody has called me that in twenty years. | Cutscene: true ending |
| 19 | [ ] | `_cutscenes/true_ending/true_ending_5.ogg` | If I stop playing... what's left of me? A very expensive suit? | Cutscene: true ending |
| 20 | [ ] | `_cutscenes/true_ending/true_ending_7.ogg` | ...Cashing out. Huh. It feels like falling. The good kind. | Cutscene: true ending |
| 21 | [ ] | `the_house/pa_lobby_1.ogg` | Welcome to the apartment. The House appreciates your continued mismanagement. | PA announcement. Polite, chilling. |
| 22 | [ ] | `the_house/pa_lobby_2.ogg` | No one dies owing the House. That would be bad for business. And for the carpet. | PA announcement. Polite, chilling. |
| 23 | [ ] | `the_house/pa_wake_1.ogg` | Welcome back, valued guest. Your tab has been adjusted. Upward. | PA announcement. Polite, chilling. |
| 24 | [ ] | `the_house/pa_wake_2.ogg` | Back so soon? The House never forgets a debtor. Or their birthday. | PA announcement. Polite, chilling. |
| 25 | [ ] | `the_house/pa_wake_3.ogg` | Interest applied. Smile, it's compounding. | PA announcement. Polite, chilling. |
| 26 | [ ] | `the_house/pa_wake_spikes_1.ogg` | Attention guests: Rico was defeated by a spike. The spike's drinks are on the house. | PA announcement. Polite, chilling. |
| 27 | [ ] | `the_house/pa_wake_guard_1.ogg` | Security reminds guests that punching is a privilege, not a right. It's also a fee. | PA announcement. Polite, chilling. |
| 28 | [ ] | `the_house/pa_wake_bat_1.ogg` | The rats thank you for your generous contribution. Your femur was delicious. | PA announcement. Polite, chilling. |
| 29 | [ ] | `the_house/pa_wake_boss1_1.ogg` | The first table sends its regards. And an invoice. And a card. | PA announcement. Polite, chilling. |
| 30 | [ ] | `the_house/pa_wake_boss2_1.ogg` | Another table won. By us. The House is pleased. The House is a little giggly. | PA announcement. Polite, chilling. |
| 31 | [ ] | `the_house/pa_wake_boss3_1.ogg` | So close. The House admires ambition. The House also keeps it. In a drawer. | PA announcement. Polite, chilling. |
| 32 | [ ] | `the_house/pa_wake_mags_1.ogg` | Our partners in lending thank you for your patience. And your future. | PA announcement. Polite, chilling. |
| 33 | [ ] | `the_house/pa_wake_big_1.ogg` | That Pot was beautiful. It's mine now. Thank you. Please come again. Please come poorer. | PA announcement. Polite, chilling. |
| 34 | [ ] | `the_house/pa_start_1.ogg` | Doors are open. Mind the spikes. Or don't. The House has a bet on 'don't.' | PA announcement. Polite, chilling. |
| 35 | [ ] | `the_house/pa_start_2.ogg` | Another guest begins the climb. How wonderful for me. | PA announcement. Polite, chilling. |
| 36 | [ ] | `the_house/pa_ride_1.ogg` | Let it ride? Oh, I LIKE you. You're my favorite income stream. | PA announcement. Polite, chilling. |
| 37 | [ ] | `the_house/pa_ride_2.ogg` | Bold. The House adores bold. Bold has margins. | PA announcement. Polite, chilling. |
| 38 | [ ] | `the_house/pa_ride8_1.ogg` | Attention guests: we have a high roller on the floor! Please applaud and then pick his pockets! | PA announcement. Polite, chilling. |
| 39 | [ ] | `the_house/pa_cashout_1.ogg` | Playing it safe. How... responsible. Ugh. Disgusting. | PA announcement. Polite, chilling. |
| 40 | [ ] | `the_house/pa_cashout_2.ogg` | Walking away? The House will remember this. The House has a spreadsheet. | PA announcement. Polite, chilling. |
| 41 | [ ] | `the_house/pa_jackpot_1.ogg` | Who rigged that machine? WHO RIGGED THAT MACHINE? Was it Gerald? It was Gerald. | PA announcement. Polite, chilling. |
| 42 | [ ] | `the_house/pa_low_hp_1.ogg` | One life left. The House recommends praying. The House recommends a will. | PA announcement. Polite, chilling. |
| 43 | [ ] | `the_house/pa_low_hp_2.ogg` | Feeling lucky? You shouldn't. The House checked. | PA announcement. Polite, chilling. |
| 44 | [ ] | `the_house/pa_boss_1.ogg` | Ladies and gentlemen... the main event. Please clap. Please bet. | PA announcement. Polite, chilling. |
| 45 | [ ] | `the_house/pa_vault_open_1.ogg` | Somebody check the safe. WHY IS THE SAFE OPEN. WHO WANTS A DEMOTION. | PA announcement. Polite, chilling. |
| 46 | [ ] | `the_house/pa_vault_miss_1.ogg` | The safe has sealed. Punctuality is a virtue, guest. So is not losing. | PA announcement. Polite, chilling. |
| 47 | [ ] | `the_house/pa_loan_due_1.ogg` | Attention guests: a loan is past due. Please keep hands, feet and dignity inside the casino. | PA announcement. Polite, chilling. |
| 48 | [ ] | `the_house/pa_spill_1.ogg` | Butterfingers! | PA announcement. Polite, chilling. |
| 49 | [ ] | `the_house/pa_spill_2.ogg` | Chips on the floor! Finders keepers. And losers weepers. | PA announcement. Polite, chilling. |
| 50 | [ ] | `the_house/pa_bet_won_1.ogg` | A side bet paid out. The House is fine. Totally fine. The House needs to lie down. | PA announcement. Polite, chilling. |
| 51 | [ ] | `the_house/pa_bet_lost_1.ogg` | Side bet lost. Tragic. Delicious. Both at once. | PA announcement. Polite, chilling. |
| 52 | [ ] | `the_house/pa_cat_1.ogg` | Please do not pet the cat. The cat is a House employee. He's on a performance review. | PA announcement. Polite, chilling. |
| 53 | [ ] | `the_house/pa_cat_2.ogg` | The cat likes you. The cat is wrong. The cat has a bad track record with people. | PA announcement. Polite, chilling. |
| 54 | [ ] | `the_house/pa_daily_1.ogg` | Today's Daily Deal: the same cards for everyone. Fairness! How quaint. How off-brand. | PA announcement. Polite, chilling. |
| 55 | [ ] | `the_house/pa_stakes_1.ogg` | Raising the stakes? The House salutes your poor judgment. And your life insurance. | PA announcement. Polite, chilling. |
| 56 | [ ] | `the_house/pa_ticket_1.ogg` | Littering is a violation of House policy. Reading it is worse. Remembering it is murder. | PA announcement. Polite, chilling. |
| 57 | [ ] | `the_house/pa_charm_1.ogg` | A charm? Cute. The House has charms too. They're called interest rates. | PA announcement. Polite, chilling. |

### DRAFTQUEENS: 11 lines

Folder: `voice/draftqueens/` (cutscene lines go in the folder shown). Voice: Every line ends with a finger snap you cannot hear..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `draftqueens/intro_1.ogg` | Five cards. Discard what you don't like. I'll start with your face. | Boss intro cutscene. Menacing. Five Card Draw themed. |
| 2 | [ ] | `draftqueens/defeat_1.ogg` | A... pat hand. I had a pat hand. And a fantasy league. Gone. | Boss defeat. Falling apart. |
| 3 | [ ] | `draftqueens/phase2_1.ogg` | Discard? Honey, I'm just getting started. And I'm drafting YOU. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `draftqueens/phase3_1.ogg` | Oh, now it's personal. Full house, sweetie. My lineup, my rules, your funeral. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `draftqueens/taunt_1.ogg` | Is that the best you can draw? My fantasy team would roast you. | Boss taunt during an attack. |
| 6 | [ ] | `draftqueens/taunt_2.ogg` | I read you at the flop. You looked boring. Still do. | Boss taunt during an attack. |
| 7 | [ ] | `draftqueens/taunt_3.ogg` | Cards don't lie. Neither does my eyeliner. Both are perfect. | Boss taunt during an attack. |
| 8 | [ ] | `draftqueens/hurt_1.ogg` | Ow! That's a three-hundred-dollar blazer! Also my face! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `draftqueens/hurt_2.ogg` | Not the hair! My hair has a better record than your whole bloodline! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `draftqueens/kill_1.ogg` | Better luck next season, sweetie. | Boss kills the player. Gloating. |
| 11 | [ ] | `draftqueens/kill_2.ogg` | That's a fold. Pack it up. We'll draft you next year. | Boss kills the player. Gloating. |

### FANDOOL: 11 lines

Folder: `voice/fandool/` (cutscene lines go in the folder shown). Voice: Yell every third word like a replay is on..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `fandool/intro_1.ogg` | Three down, four up. Everything you do is face up, pal. Including the begging. | Boss intro cutscene. Menacing. Seven Card Stud themed. |
| 2 | [ ] | `fandool/defeat_1.ogg` | The river... wasn't supposed to... bleed. Replay. Please. Slow-mo. | Boss defeat. Falling apart. |
| 3 | [ ] | `fandool/phase2_1.ogg` | Now it's a REAL game! Strap in, rookie! | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `fandool/phase3_1.ogg` | FINAL QUARTER! LET'S GOOOOO! Somebody call a timeout on this idiot! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `fandool/taunt_1.ogg` | Everything's face up, buddy! Including your mistakes! Including that haircut! | Boss taunt during an attack. |
| 6 | [ ] | `fandool/taunt_2.ogg` | I've seen your hole cards. They're shaking. They want a trade. | Boss taunt during an attack. |
| 7 | [ ] | `fandool/taunt_3.ogg` | Replay that! Replay it! Slow-mo! Look at that guy fall! | Boss taunt during an attack. |
| 8 | [ ] | `fandool/hurt_1.ogg` | Foul! That's a foul! I'm calling a foul on the whole building! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `fandool/hurt_2.ogg` | REF! REF! I'M BLEEDING, REF! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `fandool/kill_1.ogg` | Another one bites the dust! Insert horn noise! | Boss kills the player. Gloating. |
| 11 | [ ] | `fandool/kill_2.ogg` | Sudden death. For you. The commercial break's mine. | Boss kills the player. Gloating. |

### POKERSTARZ: 11 lines

Folder: `voice/pokerstarz/` (cutscene lines go in the folder shown). Voice: End statements like questions. Sigh a lot..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `pokerstarz/intro_1.ogg` | Four hole cards. You must use exactly two. Smash the like button on your own funeral. | Boss intro cutscene. Menacing. Omaha Hi-Lo themed. |
| 2 | [ ] | `pokerstarz/defeat_1.ogg` | Split pot... I get nothing. Chat, am I cooked? Chat? | Boss defeat. Falling apart. |
| 3 | [ ] | `pokerstarz/phase2_1.ogg` | Okay, that actually hurt. Smash that like button. Smash it better than you smashed me. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `pokerstarz/phase3_1.ogg` | Chat, he's cheating! Ban him! BAN HIM! Where are the mods?! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `pokerstarz/taunt_1.ogg` | Four hole cards. You have none. You have a mortgage. | Boss taunt during an attack. |
| 6 | [ ] | `pokerstarz/taunt_2.ogg` | Don't forget to subscribe to my wins. Don't forget to unsubscribe from yours. | Boss taunt during an attack. |
| 7 | [ ] | `pokerstarz/taunt_3.ogg` | This is content. You're content. You're basically a thumbnail. | Boss taunt during an attack. |
| 8 | [ ] | `pokerstarz/hurt_1.ogg` | Rude. I'm demonetized. I'm DEMONETIZED. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `pokerstarz/hurt_2.ogg` | Oh my god, stop. Stop! I'm streaming! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `pokerstarz/kill_1.ogg` | GG. No re. I'm clipping this. For the highlight reel of you losing. | Boss kills the player. Gloating. |
| 11 | [ ] | `pokerstarz/kill_2.ogg` | That's the clip of the day. Title: 'Idiot Dies.' | Boss kills the player. Gloating. |

### BETMGN: 11 lines

Folder: `voice/betmgn/` (cutscene lines go in the folder shown). Voice: Talk like every sentence has a trademark symbol..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `betmgn/intro_1.ogg` | Three cards. Ante up. Quick, it's over fast. Like your marriage. | Boss intro cutscene. Menacing. Three Card Poker themed. |
| 2 | [ ] | `betmgn/defeat_1.ogg` | Queen high... of course. I had the commission. I HAD the commission. | Boss defeat. Falling apart. |
| 3 | [ ] | `betmgn/phase2_1.ogg` | Alright, let's raise the ante. The ante's your dignity. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `betmgn/phase3_1.ogg` | Three cards. Three seconds. You're done. The clock's mine. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `betmgn/taunt_1.ogg` | Pair plus? Pair minus. You owe me a pair. Of kneecaps. | Boss taunt during an attack. |
| 6 | [ ] | `betmgn/taunt_2.ogg` | Ante up, folks! The ante is everything! The ante is also my yacht! | Boss taunt during an attack. |
| 7 | [ ] | `betmgn/taunt_3.ogg` | That's a Straight Flush of bad ideas. A royal one. | Boss taunt during an attack. |
| 8 | [ ] | `betmgn/hurt_1.ogg` | Ouch! That's a bad beat! Where do I file a complaint?! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `betmgn/hurt_2.ogg` | No no no, my commission! That's MY commission! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `betmgn/kill_1.ogg` | Quick, wasn't it? The house edge says hi. It also says 'bye.' | Boss kills the player. Gloating. |
| 11 | [ ] | `betmgn/kill_2.ogg` | The house edge says hi. It's always the house edge. That's the pitch. | Boss kills the player. Gloating. |

### STEAKE.COM: 11 lines

Folder: `voice/steake/` (cutscene lines go in the folder shown). Voice: Say 'to the moon' with your whole chest, even when it makes no sense..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `steake/intro_1.ogg` | In Razz the worst hand wins. You should fit right in. You're a dream. | Boss intro cutscene. Menacing. Razz themed. |
| 2 | [ ] | `steake/defeat_1.ogg` | A wheel... the best of the worst. Nice. Not financial advice. Mostly a will. | Boss defeat. Falling apart. |
| 3 | [ ] | `steake/phase2_1.ogg` | Nice hit. We're STILL going to the moon. The moon is a dumpster, but it's OUR dumpster. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `steake/phase3_1.ogg` | To the MOOOON! Or the floor! Whichever pays out! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `steake/taunt_1.ogg` | Worst hand wins, friend. Congrats on yours. It's a masterpiece of dogshit. | Boss taunt during an attack. |
| 6 | [ ] | `steake/taunt_2.ogg` | Diamond hands! Diamond everything! Diamond-flavored ulcer! | Boss taunt during an attack. |
| 7 | [ ] | `steake/taunt_3.ogg` | Not financial advice. But you're done. That is legal advice. From a clown. | Boss taunt during an attack. |
| 8 | [ ] | `steake/hurt_1.ogg` | Buy the dip! Oh, that's me. That's me buying the dip. Painfully. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `steake/hurt_2.ogg` | Rug pull! Rug PULL! Somebody's pulling MY rug! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `steake/kill_1.ogg` | HODL this, loser. HODL a feeling. A bad one. In a coffin. | Boss kills the player. Gloating. |
| 11 | [ ] | `steake/kill_2.ogg` | Liquidated. All of you. Every dollar. Every organ. | Boss kills the player. Gloating. |

### BOVADOH: 11 lines

Folder: `voice/bovadoh/` (cutscene lines go in the folder shown). Voice: Be bored. Boredom is scarier than shouting..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `bovadoh/intro_1.ogg` | Seven cards, two hands. Beat both or push. You will push. Into a wall. | Boss intro cutscene. Menacing. Pai Gow themed. |
| 2 | [ ] | `bovadoh/defeat_1.ogg` | Both hands... lost. Impossible. I'll need a moment. Several moments. A sabbatical. | Boss defeat. Falling apart. |
| 3 | [ ] | `bovadoh/phase2_1.ogg` | ...Impressive. Marginally. Like a cold bath. In a good way. I'm lying. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `bovadoh/phase3_1.ogg` | Both hands. Now. At once. As expected. You'll fail at once. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `bovadoh/taunt_1.ogg` | Two hands. Two defeats. Do the math. I have, and you're negative. | Boss taunt during an attack. |
| 6 | [ ] | `bovadoh/taunt_2.ogg` | You push, I take. It's called Pai Gow. It's called your problem. | Boss taunt during an attack. |
| 7 | [ ] | `bovadoh/taunt_3.ogg` | Dull. Everything's dull. You, too. Especially the dying. | Boss taunt during an attack. |
| 8 | [ ] | `bovadoh/hurt_1.ogg` | Hm. That stung. I shall feel it later. In a spa. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `bovadoh/hurt_2.ogg` | Interesting. Do it again. I'll ignore it. Twice. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `bovadoh/kill_1.ogg` | Predictable. Like water. Like taxes. Like you, losing. | Boss kills the player. Gloating. |
| 11 | [ ] | `bovadoh/kill_2.ogg` | As expected. I'll file this under 'Tuesday.' | Boss kills the player. Gloating. |

### SEEZER'S CLUB: 11 lines

Folder: `voice/seezers/` (cutscene lines go in the folder shown). Voice: Say everything like a toga is flowing behind you..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `seezers/intro_1.ogg` | Dealer stands on 17. I never stand. Not for you. Not for the Senate. | Boss intro cutscene. Menacing. Blackjack themed. |
| 2 | [ ] | `seezers/defeat_1.ogg` | Twenty-two. I busted. How embarrassing. Rome fell on a bad hit. | Boss defeat. Falling apart. |
| 3 | [ ] | `seezers/phase2_1.ogg` | You have wounded Caesar. Splendid. I shall stab you later. In the Senate. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `seezers/phase3_1.ogg` | THIS IS THE END OF THE EMPIRE! AND THE START OF A BETTER BUFFET! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `seezers/taunt_1.ogg` | Dealer stands. YOU do not. You will lie down. Like a Roman. Dead. | Boss taunt during an attack. |
| 6 | [ ] | `seezers/taunt_2.ogg` | I'd hit you on 16. And on 17. And on a Friday. | Boss taunt during an attack. |
| 7 | [ ] | `seezers/taunt_3.ogg` | Et tu, gambler? Et tu? Et DOUBLE-DOWN, brute! | Boss taunt during an attack. |
| 8 | [ ] | `seezers/hurt_1.ogg` | A mere scratch on the marble! Marble's expensive. I'm taking it out of your hide! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `seezers/hurt_2.ogg` | By Jupiter! By Juno! By whoever I owe money to! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `seezers/kill_1.ogg` | Veni, vidi, bust. You came, you saw, you busted. I'll write it on a tablet. A tablet computer. | Boss kills the player. Gloating. |
| 11 | [ ] | `seezers/kill_2.ogg` | Hail, Caesar. And farewell. Hail is complimentary. Farewell costs extra. | Boss kills the player. Gloating. |

### WYNNER'S CIRCLE: 11 lines

Folder: `voice/wynners/` (cutscene lines go in the folder shown). Voice: Sniff once per sentence like the room smells poor..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `wynners/intro_1.ogg` | Punto. Banco. Tie. Always a tie: you lose either way. | Boss intro cutscene. Menacing. Baccarat themed. |
| 2 | [ ] | `wynners/defeat_1.ogg` | Natural nine... and still I fall. The Circle breaks. How gauche. | Boss defeat. Falling apart. |
| 3 | [ ] | `wynners/phase2_1.ogg` | A natural eight. Perhaps it's your turn. Perhaps it's mine. It's mine. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `wynners/phase3_1.ogg` | Banker. Player. Tie. Doom. Doom always beats the other three. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `wynners/taunt_1.ogg` | The shoe is cold. The room is colder. My heart is a fridge. | Boss taunt during an attack. |
| 6 | [ ] | `wynners/taunt_2.ogg` | Place your bets on the inevitable. The inevitable has a 1.06% house edge. | Boss taunt during an attack. |
| 7 | [ ] | `wynners/taunt_3.ogg` | Pinky out, darling. This will hurt. Mostly your pride. Also your ribs. | Boss taunt during an attack. |
| 8 | [ ] | `wynners/hurt_1.ogg` | How... rude. I shall tell my aunts. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `wynners/hurt_2.ogg` | Mon Dieu. Mon Dieu, that's a lot of blood on the baize. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `wynners/kill_1.ogg` | The Circle closes. Again. It always closes. On you. With a click. | Boss kills the player. Gloating. |
| 11 | [ ] | `wynners/kill_2.ogg` | Adieu. Un-adieu. Bonne chance in the next life. You'll need it. | Boss kills the player. Gloating. |

### SNAKE EYES SAL: 11 lines

Folder: `voice/snake_eyes/` (cutscene lines go in the folder shown). Voice: Hiss and click your tongue between lines..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `snake_eyes/intro_1.ogg` | Seven, you lose. Eleven, you lose. Everything's a lose. Also a tax. | Boss intro cutscene. Menacing. Craps themed. |
| 2 | [ ] | `snake_eyes/defeat_1.ogg` | Boxcars... on my own roll. Of course. Twelve. I hate twelve. | Boss defeat. Falling apart. |
| 3 | [ ] | `snake_eyes/phase2_1.ogg` | Boxcars! BOXCARS! Twelve! You hate twelve! I love twelve! | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `snake_eyes/phase3_1.ogg` | Natural! Natural! You hear that? That's my natural. It sings! | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `snake_eyes/taunt_1.ogg` | Seven! You lose! Seven always loses! That's the rule I just invented! | Boss taunt during an attack. |
| 6 | [ ] | `snake_eyes/taunt_2.ogg` | Snake eyes! Ssssnake EYES! You don't even want to know what's in my pocket! | Boss taunt during an attack. |
| 7 | [ ] | `snake_eyes/taunt_3.ogg` | Come out roll! Come OUT! Come out, come out, wherever you suck! | Boss taunt during an attack. |
| 8 | [ ] | `snake_eyes/hurt_1.ogg` | Hsss! Careful! Venom's expensive! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `snake_eyes/hurt_2.ogg` | Ow, ow, ow! My dice! My lucky dice! Why are you hitting them?! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `snake_eyes/kill_1.ogg` | Sevennn! Sevennn! Your lucky number's dead! | Boss kills the player. Gloating. |
| 11 | [ ] | `snake_eyes/kill_2.ogg` | House pays. House always pays. Sometimes in teeth. | Boss kills the player. Gloating. |

### ONE-ARMED BANDIT: 11 lines

Folder: `voice/rusty_slots/` (cutscene lines go in the folder shown). Voice: Cheerful voice, dead eyes, glitches in the middle of words..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `rusty_slots/intro_1.ogg` | Pull my arm. Go on. I dare you. I'm a very lonely arm. | Boss intro cutscene. Menacing. The Slot Machine themed. |
| 2 | [ ] | `rusty_slots/defeat_1.ogg` | Jackpot... for YOU? That's... that's the first time. I'm so proud. I'm so sad. | Boss defeat. Falling apart. |
| 3 | [ ] | `rusty_slots/phase2_1.ogg` | JACKPOT. JACKPOT. JACKPOT. Please insert your life savings. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `rusty_slots/phase3_1.ogg` | ERROR. ERROR. LUCKY SEVEN. ERROR. YOU ARE A SEVEN. ERROR. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `rusty_slots/taunt_1.ogg` | Insert coin to continue dying. No coin? Continue dying anyway. | Boss taunt during an attack. |
| 6 | [ ] | `rusty_slots/taunt_2.ogg` | Spin. Spin. Spin. I'm not a machine. I'm an addiction with a handle. | Boss taunt during an attack. |
| 7 | [ ] | `rusty_slots/taunt_3.ogg` | Pull my arm. Go on. I dare you. It's the only thing I've ever wanted. | Boss taunt during an attack. |
| 8 | [ ] | `rusty_slots/hurt_1.ogg` | BZZZT. Ow. BZZZT. Is that my arm? Is that YOUR arm? | Boss gets hit. Grunt-style. |
| 9 | [ ] | `rusty_slots/hurt_2.ogg` | Tilt. Tilt. Tilt. Someone call my mother. She's a toaster. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `rusty_slots/kill_1.ogg` | Three bars. You lose. Three bars. You also lose. Three. | Boss kills the player. Gloating. |
| 11 | [ ] | `rusty_slots/kill_2.ogg` | OUT OF ORDER. OUT OF ORDER. HOPE: OUT OF ORDER. | Boss kills the player. Gloating. |

### MR. LUCKY: 11 lines

Folder: `voice/mr_lucky/` (cutscene lines go in the folder shown). Voice: Everything you say starts nice and turns evil on the last word..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `mr_lucky/intro_1.ogg` | Pick eighty numbers. You'll hit none. I'm Keno Kevin. Welcome. Please don't pick Kevin. | Boss intro cutscene. Menacing. Keno themed. |
| 2 | [ ] | `mr_lucky/defeat_1.ogg` | Eighty out of eighty... how? How? That's not even possible. I'm Kevin. I'm unlucky. I'm Keno. | Boss defeat. Falling apart. |
| 3 | [ ] | `mr_lucky/phase2_1.ogg` | My, my. You ARE lucky. Statistically unnerving. Please stop. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `mr_lucky/phase3_1.ogg` | Now, now. Pick a number. Any number. Wrong. I'm a little hurt. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `mr_lucky/taunt_1.ogg` | Pick eighty numbers. Hit none. I've done the math. Your odds are 'sorry.' | Boss taunt during an attack. |
| 6 | [ ] | `mr_lucky/taunt_2.ogg` | Luck is just a lie told by the winning. I'm a very honest liar. | Boss taunt during an attack. |
| 7 | [ ] | `mr_lucky/taunt_3.ogg` | Are you having fun? You will. Fun's a lottery. Of pain. | Boss taunt during an attack. |
| 8 | [ ] | `mr_lucky/hurt_1.ogg` | Ow! Oh dear. I'm a very fragile gentleman. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `mr_lucky/hurt_2.ogg` | That was unkind. I shall mention it. To someone. I'm a ghost, but still. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `mr_lucky/kill_1.ogg` | Never lucky. Always careful. Careful is just luck's older, scarier brother. | Boss kills the player. Gloating. |
| 11 | [ ] | `mr_lucky/kill_2.ogg` | Better luck next time. Always. That's the slogan. Print it on the casket. | Boss kills the player. Gloating. |

### TOURIST: 22 lines

Folder: `voice/tourist/` (cutscene lines go in the folder shown). Voice: Everything you say is a question. All of them too loud..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `tourist/bark_1.ogg` | Is this the buffet? Because I've been to the cage and they sent me here. | Random crowd bark, any city. |
| 2 | [ ] | `tourist/bark_2.ogg` | Honey! Come look! Slot machines! Honey? Honey? He's gone. Slot machine. | Random crowd bark, any city. |
| 3 | [ ] | `tourist/bark_3.ogg` | Does the free drink come with an umbrella? Does it come with a wallet? | Random crowd bark, any city. |
| 4 | [ ] | `tourist/bark_4.ogg` | I lost five dollars! I'm RUINED! Five! Dollars! It was Tuesday's! | Random crowd bark, any city. |
| 5 | [ ] | `tourist/bark_5.ogg` | Wait, is it a one-armed bandit or a no-armed bandit? Because mine just took my watch. | Random crowd bark, any city. |
| 6 | [ ] | `tourist/bark_6.ogg` | Hey, buddy! Which way to the pool? I've been walking for two days. | Random crowd bark, any city. |
| 7 | [ ] | `tourist/bark_7.ogg` | I've never seen so many lights in my life! Is that the exit? Is that a seizure? | Random crowd bark, any city. |
| 8 | [ ] | `tourist/bark_8.ogg` | Can I pay with a coupon? A coupon for coupons? | Random crowd bark, any city. |
| 9 | [ ] | `tourist/bark_9.ogg` | Where's the fountain? Is that it? It's very small. And full of coins. And a man. | Random crowd bark, any city. |
| 10 | [ ] | `tourist/bark_10.ogg` | Why is everyone so serious? My husband's at the roulette table, he's smiling, he's also unconscious. | Random crowd bark, any city. |
| 11 | [ ] | `tourist/bark_11.ogg` | My husband is in a coma at the roulette table. He says he's 'up.' | Random crowd bark, any city. |
| 12 | [ ] | `tourist/bark_12.ogg` | It's so clean! Except for that. And that. And that man. | Random crowd bark, any city. |
| 13 | [ ] | `tourist/city1_1.ogg` | The boardwalk smells like regret and funnel cake. And a little like regret on funnel cake. | Crowd bark flavored for city 1. |
| 14 | [ ] | `tourist/city1_7.ogg` | Don't drink the water. Don't drink the drinks. Don't drink. It's a casino. Drink. | Crowd bark flavored for city 1. |
| 15 | [ ] | `tourist/city2_1.ogg` | Reno! The biggest little city with the smallest chances. It says so on the shirt. | Crowd bark flavored for city 2. |
| 16 | [ ] | `tourist/city2_7.ogg` | Come see the world's smallest elephant. It's a dog. In a hat. He's very sad. | Crowd bark flavored for city 2. |
| 17 | [ ] | `tourist/city3_1.ogg` | Biloxi! Where the sharks are gentlemen. And the gentlemen are sharks. | Crowd bark flavored for city 3. |
| 18 | [ ] | `tourist/city3_7.ogg` | Everybody here lost their voice. It's a cult. It's called Karaoke. | Crowd bark flavored for city 3. |
| 19 | [ ] | `tourist/city4_1.ogg` | Fremont! Old Vegas! Old money! Old vice! Old everything! Old me! | Crowd bark flavored for city 4. |
| 20 | [ ] | `tourist/city4_7.ogg` | I lost a gold bar. I wasn't even playing. I was just standing. It left. | Crowd bark flavored for city 4. |
| 21 | [ ] | `tourist/city5_1.ogg` | The Strip! The nicest casino in the nicest town! It's also a lobster with a lawsuit! | Crowd bark flavored for city 5. |
| 22 | [ ] | `tourist/city5_7.ogg` | Sir, this is a Wendy's. Just kidding. It's a palace. It's a very expensive Wendy's. | Crowd bark flavored for city 5. |

### JUNKIE: 22 lines

Folder: `voice/junkie/` (cutscene lines go in the folder shown). Voice: Run out of breath at the end of every sentence..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `junkie/bark_1.ogg` | You got a... you got a dollar? I'll pay you back. In stories. | Random crowd bark, any city. |
| 2 | [ ] | `junkie/bark_2.ogg` | I swear I put it somewhere... somewhere. My kidney, maybe. | Random crowd bark, any city. |
| 3 | [ ] | `junkie/bark_3.ogg` | Don't tell them I'm here. Don't tell them anything. Don't tell me, either. | Random crowd bark, any city. |
| 4 | [ ] | `junkie/bark_4.ogg` | I'm fine. I'm just... resting. Standing. Resting upright. In a hallway. | Random crowd bark, any city. |
| 5 | [ ] | `junkie/bark_5.ogg` | Hey. Hey. Do you hear the bugs? They're singing. They're good. They're in a band. | Random crowd bark, any city. |
| 6 | [ ] | `junkie/bark_6.ogg` | I've got nine lives. Six of them are used. Two are in pawn. | Random crowd bark, any city. |
| 7 | [ ] | `junkie/bark_7.ogg` | The walls are breathing. Nice walls. They're my friends. They owe me. | Random crowd bark, any city. |
| 8 | [ ] | `junkie/bark_8.ogg` | Got a light? Got a... got a fix? Got a Wi-Fi password? | Random crowd bark, any city. |
| 9 | [ ] | `junkie/bark_9.ogg` | Whoa. Where'd you come from? Did you fall from the ceiling? That's cool. I did that Tuesday. | Random crowd bark, any city. |
| 10 | [ ] | `junkie/bark_10.ogg` | I'm clean. Mostly. Sort of. Clean-ish. Like a ketchup bottle. | Random crowd bark, any city. |
| 11 | [ ] | `junkie/bark_11.ogg` | Everything's shiny. Everything's shiny! I love shiny! Shiny is my life partner! | Random crowd bark, any city. |
| 12 | [ ] | `junkie/bark_12.ogg` | Shh. The floor is listening. The floor has a tab on me. | Random crowd bark, any city. |
| 13 | [ ] | `junkie/city1_2.ogg` | Atlantic Shitty, where dreams go to evaporate. And pay a resort fee. | Crowd bark flavored for city 1. |
| 14 | [ ] | `junkie/city1_8.ogg` | Welcome to Resortz. Lower your standards. They're already on the floor. | Crowd bark flavored for city 1. |
| 15 | [ ] | `junkie/city2_2.ogg` | Cirrcus Cirrcus: where the clowns run the tables. And the clowns run on spite. | Crowd bark flavored for city 2. |
| 16 | [ ] | `junkie/city2_8.ogg` | I'm a clown. I'm sad. I'm broke. I'm also double-jointed. But mostly sad. | Crowd bark flavored for city 2. |
| 17 | [ ] | `junkie/city3_2.ogg` | Hard Rok: it's loud, it's pricey, it's a guitar. It's also a mild stroke. | Crowd bark flavored for city 3. |
| 18 | [ ] | `junkie/city3_8.ogg` | I came for the show. I stayed for the cover charge. I'll be here forever. | Crowd bark flavored for city 3. |
| 19 | [ ] | `junkie/city4_2.ogg` | The Goldun Nugget's got a shark tank. It's decorative. It's also hungry. | Crowd bark flavored for city 4. |
| 20 | [ ] | `junkie/city4_8.ogg` | A glass of champagne? That's a hundred. Please. Don't make me say it twice. | Crowd bark flavored for city 4. |
| 21 | [ ] | `junkie/city5_2.ogg` | The Bellagiro fountain! It dances! It judges! It's the only thing here with rhythm! | Crowd bark flavored for city 5. |
| 22 | [ ] | `junkie/city5_8.ogg` | The chandelier is a quarter-million. Don't sneeze. Don't blink. Don't think near it. | Crowd bark flavored for city 5. |

### PIT BOSS: 22 lines

Folder: `voice/pitboss/` (cutscene lines go in the folder shown). Voice: Say it like you've said it 10,000 times..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `pitboss/bark_1.ogg` | Place your bets. Place them quietly. Place them with remorse. | Random crowd bark, any city. |
| 2 | [ ] | `pitboss/bark_2.ogg` | Cards on the table. Hands where I can see 'em. Heart where I can step on it. | Random crowd bark, any city. |
| 3 | [ ] | `pitboss/bark_3.ogg` | No cameras. No phones. No joy. | Random crowd bark, any city. |
| 4 | [ ] | `pitboss/bark_4.ogg` | Watch your chips, sir. They're the only thing here that loves you. And they're leaving. | Random crowd bark, any city. |
| 5 | [ ] | `pitboss/bark_5.ogg` | That's a violation. And a threat. And a Tuesday. | Random crowd bark, any city. |
| 6 | [ ] | `pitboss/bark_6.ogg` | Pit to floor, we have a loser. Repeat: a loser. Bring a mop. | Random crowd bark, any city. |
| 7 | [ ] | `pitboss/bark_7.ogg` | Please keep the noise to a minimum. The losing should be silent. | Random crowd bark, any city. |
| 8 | [ ] | `pitboss/bark_8.ogg` | That table's closed. Permanently. We had an incident. It's a shrine now. | Random crowd bark, any city. |
| 9 | [ ] | `pitboss/bark_9.ogg` | The House appreciates your patronage. And your kneecaps. Thank you for both. | Random crowd bark, any city. |
| 10 | [ ] | `pitboss/bark_10.ogg` | All bets are final. Unlike your life. That has a rematch clause. | Random crowd bark, any city. |
| 11 | [ ] | `pitboss/bark_11.ogg` | Don't make me call the floor. The floor's already here. It's under you. | Random crowd bark, any city. |
| 12 | [ ] | `pitboss/bark_12.ogg` | Sir, that was a poor decision. Well, it was poor. It was also a decision. Don't get cocky. | Random crowd bark, any city. |
| 13 | [ ] | `pitboss/city1_3.ogg` | I lost my retirement on a slot shaped like a lobster. The lobster won. | Crowd bark flavored for city 1. |
| 14 | [ ] | `pitboss/city1_9.ogg` | A mascot ate my sandwich. The mascot's a crab. The crab was on a break. | Crowd bark flavored for city 1. |
| 15 | [ ] | `pitboss/city2_3.ogg` | I lost a bet to a juggler. He was juggling my kidneys. Allegedly. | Crowd bark flavored for city 2. |
| 16 | [ ] | `pitboss/city2_9.ogg` | The cotton candy is a lie. It's insulation. We eat it anyway. | Crowd bark flavored for city 2. |
| 17 | [ ] | `pitboss/city3_3.ogg` | I paid fifteen bucks for a pick. I don't play. I don't know what it is. I wear it as a hat. | Crowd bark flavored for city 3. |
| 18 | [ ] | `pitboss/city3_9.ogg` | Rock and roll never dies. My bankroll did. At the show. | Crowd bark flavored for city 3. |
| 19 | [ ] | `pitboss/city4_3.ogg` | Gold! Everything's gold! Even the toilets! Even the plumbing! Even the sadness! | Crowd bark flavored for city 4. |
| 20 | [ ] | `pitboss/city4_9.ogg` | Welcome to the old days. They weren't better. They were just louder. And more flammable. | Crowd bark flavored for city 4. |
| 21 | [ ] | `pitboss/city5_3.ogg` | I lost a diamond ring on a hand of blackjack. Technically I lost the hand. The ring just fell off. | Crowd bark flavored for city 5. |
| 22 | [ ] | `pitboss/city5_9.ogg` | Welcome to the top. It's lonely. The elevator also stinks. | Crowd bark flavored for city 5. |

### DRUNK: 22 lines

Folder: `voice/drunk/` (cutscene lines go in the folder shown). Voice: Hiccup mid-word. Cry a little..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `drunk/bark_1.ogg` | I love you, man. I love everybody! I love that lamp! | Random crowd bark, any city. |
| 2 | [ ] | `drunk/bark_2.ogg` | Shhhh. The slot machine is sleeping. It's had a long night. Bless it. | Random crowd bark, any city. |
| 3 | [ ] | `drunk/bark_3.ogg` | I'm not drunk. The floor is spinning. It's the floor's fault. It's the floor's drinking problem. | Random crowd bark, any city. |
| 4 | [ ] | `drunk/bark_4.ogg` | One more. Just one more. Hic. Just one. Then one. Then one more. | Random crowd bark, any city. |
| 5 | [ ] | `drunk/bark_5.ogg` | Where's my wife? Where's my shirt? Where's the wife who owned the shirt? | Random crowd bark, any city. |
| 6 | [ ] | `drunk/bark_6.ogg` | I used to be somebody. Now I'm... everybody. A group of somebodies. A drunken committee. | Random crowd bark, any city. |
| 7 | [ ] | `drunk/bark_7.ogg` | Cheers! To whatever that was! May it never come back! May it come back with a snack! | Random crowd bark, any city. |
| 8 | [ ] | `drunk/bark_8.ogg` | Never bet on red. Always bet on whiskey. Whiskey's got better odds. Whiskey's got me. | Random crowd bark, any city. |
| 9 | [ ] | `drunk/bark_9.ogg` | I think I'm in the wrong casino. I think I'm in the wrong marriage. | Random crowd bark, any city. |
| 10 | [ ] | `drunk/bark_10.ogg` | I lost my keys. Or my car. Or my wife. One of them was in the lake. I think it was the lake. | Random crowd bark, any city. |
| 11 | [ ] | `drunk/bark_11.ogg` | Don't tell my kids. Don't tell my kids' kids. Don't tell my kids' kids' accountants. | Random crowd bark, any city. |
| 12 | [ ] | `drunk/bark_12.ogg` | Everything's fine. Fine. FINE. Is that a bear? That's a bear. Everything's fine. | Random crowd bark, any city. |
| 13 | [ ] | `drunk/city1_4.ogg` | Saltwater taffy and bad decisions! Both stick to your teeth for years! | Crowd bark flavored for city 1. |
| 14 | [ ] | `drunk/city1_10.ogg` | This casino was voted 'adequate.' By the casino. At gunpoint. | Crowd bark flavored for city 1. |
| 15 | [ ] | `drunk/city2_4.ogg` | The trapeze is for the high rollers. Literally. They roll. They fall. We clap. | Crowd bark flavored for city 2. |
| 16 | [ ] | `drunk/city2_10.ogg` | Don't take the lion's tickets. He has a temper. And a lawyer. | Crowd bark flavored for city 2. |
| 17 | [ ] | `drunk/city3_4.ogg` | The drums are for decoration. Mostly. Also for the cops. | Crowd bark flavored for city 3. |
| 18 | [ ] | `drunk/city3_10.ogg` | They serve a burger shaped like an amp. It's loud. Also lethal. | Crowd bark flavored for city 3. |
| 19 | [ ] | `drunk/city4_4.ogg` | I haven't seen daylight since the Clinton administration. It's fine. I'm tan from the slots. | Crowd bark flavored for city 4. |
| 20 | [ ] | `drunk/city4_10.ogg` | A note was left at the front desk, handwritten. 'Don't come for me. I'm finally winning.' Looks like a gambler's brother. | Crowd bark flavored for city 4. |
| 21 | [ ] | `drunk/city5_4.ogg` | Everything here costs a hundred dollars. Even the air. Even the apologies. | Crowd bark flavored for city 5. |
| 22 | [ ] | `drunk/city5_10.ogg` | The House challenged some guy to a hand. Jules is the pot. Pot's a person. Allegedly. | Crowd bark flavored for city 5. |

### BOUNCER: 22 lines

Folder: `voice/bouncer/` (cutscene lines go in the folder shown). Voice: As low as you can go. Say as few words as possible..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `bouncer/bark_1.ogg` | Not tonight, pal. Not tomorrow. Not in this lifetime. Not in the next, either. | Random crowd bark, any city. |
| 2 | [ ] | `bouncer/bark_2.ogg` | Name's not on the list. Nobody's name is on the list. The list is a lie. | Random crowd bark, any city. |
| 3 | [ ] | `bouncer/bark_3.ogg` | Move along. Move along or move on. Either way you're moving. | Random crowd bark, any city. |
| 4 | [ ] | `bouncer/bark_4.ogg` | I don't care who you know. I care who I punch. You're up. | Random crowd bark, any city. |
| 5 | [ ] | `bouncer/bark_5.ogg` | ID. And a birth certificate. And a signed apology from your mother. | Random crowd bark, any city. |
| 6 | [ ] | `bouncer/bark_6.ogg` | Dress code. You're in violation. You're in violation of several. Of many codes. | Random crowd bark, any city. |
| 7 | [ ] | `bouncer/bark_7.ogg` | Step outside. Please. Not really a request. Mostly a countdown. | Random crowd bark, any city. |
| 8 | [ ] | `bouncer/bark_8.ogg` | You have the wrong shoes. And the wrong face. Also the wrong shoes. | Random crowd bark, any city. |
| 9 | [ ] | `bouncer/bark_9.ogg` | VIP only. You're not. You'll never be. Not even in death. The dead have a velvet rope. | Random crowd bark, any city. |
| 10 | [ ] | `bouncer/bark_10.ogg` | Keep walking. Eyes forward. Heart in your throat. That's the rule. | Random crowd bark, any city. |
| 11 | [ ] | `bouncer/bark_11.ogg` | The line starts at the back. The back's in a different state. | Random crowd bark, any city. |
| 12 | [ ] | `bouncer/bark_12.ogg` | No. That's the entire policy. It's very concise. | Random crowd bark, any city. |
| 13 | [ ] | `bouncer/city1_5.ogg` | The seagulls steal chips here. They're the only ones winning. | Crowd bark flavored for city 1. |
| 14 | [ ] | `bouncer/city1_11.ogg` | I came for the ocean. I stayed for the debt. Also the ocean smells. | Crowd bark flavored for city 1. |
| 15 | [ ] | `bouncer/city2_5.ogg` | Mind the clown. The clown bites. The clown is also the manager. | Crowd bark flavored for city 2. |
| 16 | [ ] | `bouncer/city2_11.ogg` | Some guy pawned a gold watch here last week. Sad story. Said he was 'getting promoted.' To Biloxi, I think. | Crowd bark flavored for city 2. |
| 17 | [ ] | `bouncer/city3_5.ogg` | A bad beat sounds like a power chord. And looks like a rhinestone jacket. | Crowd bark flavored for city 3. |
| 18 | [ ] | `bouncer/city3_11.ogg` | Word is the new dealer upstairs is some guy named Jules. Dealing for The House. Doing great. Unsettlingly great. | Crowd bark flavored for city 3. |
| 19 | [ ] | `bouncer/city4_5.ogg` | The neon is older than I am. And it's in better shape. I'm furious. | Crowd bark flavored for city 4. |
| 20 | [ ] | `bouncer/city4_11.ogg` | Don't stare at the chandelier. It judges. And then it falls on the people it judged. | Crowd bark flavored for city 4. |
| 21 | [ ] | `bouncer/city5_5.ogg` | Don't stare at the High Roller. He bites. He bites the poor ones. I've seen it. | Crowd bark flavored for city 5. |
| 22 | [ ] | `bouncer/city5_11.ogg` | They serve a hundred-dollar water. It's the same water. It's also the same tap. | Crowd bark flavored for city 5. |

### HUSTLER: 22 lines

Folder: `voice/hustler/` (cutscene lines go in the folder shown). Voice: Everything is an offer. Everything is urgent..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `hustler/bark_1.ogg` | Hey. Hey you. Wanna buy a watch? It's yours. Technically. By yours I mean mine. | Random crowd bark, any city. |
| 2 | [ ] | `hustler/bark_2.ogg` | I got a guy. He's got a guy. You want the guy. Don't ask which guy. | Random crowd bark, any city. |
| 3 | [ ] | `hustler/bark_3.ogg` | Psst. Free money. It's a scam. But free. And the scam's free too. | Random crowd bark, any city. |
| 4 | [ ] | `hustler/bark_4.ogg` | Wanna see a magic trick? It's a wallet. Now it's gone. Ta-da. | Random crowd bark, any city. |
| 5 | [ ] | `hustler/bark_5.ogg` | Everything's for sale. Even me. I'm on sale. Today only. Limited time. | Random crowd bark, any city. |
| 6 | [ ] | `hustler/bark_6.ogg` | You look lucky. You look LOST. Same thing here. | Random crowd bark, any city. |
| 7 | [ ] | `hustler/bark_7.ogg` | Three-card monte! Find the lady! The lady's in the cab. She's left. She had enough. | Random crowd bark, any city. |
| 8 | [ ] | `hustler/bark_8.ogg` | Cheap chips! Authentic! Probably! Not chewable! Not edible! Not mine! | Random crowd bark, any city. |
| 9 | [ ] | `hustler/bark_9.ogg` | Ten bucks. No questions. Eleven bucks and I answer all of them. | Random crowd bark, any city. |
| 10 | [ ] | `hustler/bark_10.ogg` | That's a nice jacket. I'll take it. Joke. I'll take it. Not a joke. | Random crowd bark, any city. |
| 11 | [ ] | `hustler/bark_11.ogg` | Business is slow. Be my business. Please. I have kids. In a van. | Random crowd bark, any city. |
| 12 | [ ] | `hustler/bark_12.ogg` | Don't look at me. I didn't do it. Whatever it was. I was at lunch. In a cell. | Random crowd bark, any city. |
| 13 | [ ] | `hustler/city1_6.ogg` | This place has seen better decades. And better beaches. And better hepatitis. | Crowd bark flavored for city 1. |
| 14 | [ ] | `hustler/city1_12.ogg` | I heard a man bet his brother at The House. Never came back. Now they say he deals in Bellagiro. Sad stuff. | Crowd bark flavored for city 1. |
| 15 | [ ] | `hustler/city2_6.ogg` | Everything here is sticky. Don't ask. Don't touch. Don't sit. | Crowd bark flavored for city 2. |
| 16 | [ ] | `hustler/city2_12.ogg` | Please do not feed the acrobats. They'll follow you home. They do not have homes. | Crowd bark flavored for city 2. |
| 17 | [ ] | `hustler/city3_6.ogg` | Hey! Don't touch the Elvis suit! He's still in it! | Crowd bark flavored for city 3. |
| 18 | [ ] | `hustler/city3_12.ogg` | The coat check costs more than the room. The room's a closet. The closet's a coat check. | Crowd bark flavored for city 3. |
| 19 | [ ] | `hustler/city4_6.ogg` | They don't make casinos like this anymore. Thank God. And the health department. | Crowd bark flavored for city 4. |
| 20 | [ ] | `hustler/city4_12.ogg` | Ten thousand dollars on red. On red! He's dead now. It was black. | Crowd bark flavored for city 4. |
| 21 | [ ] | `hustler/city5_6.ogg` | Fine art. Fine wine. Fine print. Mostly fine print. All fine print. | Crowd bark flavored for city 5. |
| 22 | [ ] | `hustler/city5_12.ogg` | The House is watching. Behave. Or don't. I've bet against you. | Crowd bark flavored for city 5. |


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
