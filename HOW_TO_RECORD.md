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

**JAMES** (`voice/james/`)
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

**KENO KEVIN** (`voice/mr_lucky/`)
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

### RICO: 100 lines

Folder: `voice/rico/` (cutscene lines go in the folder shown). Voice: Grin the whole time. Every line is a bet you already placed..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `rico/greet_1.ogg` | Let's see what the House left me. Not my brother, not my dignity. Oh, nice, one chip. | Greeting the player. In character. |
| 2 | [ ] | `rico/greet_2.ogg` | Aces up, brains out. Perfect strategy. The House calls it 'our customer profile.' | Greeting the player. In character. |
| 3 | [ ] | `rico/greet_3.ogg` | Another day, another dollar I don't have. At least I'm consistent. That's called momentum. | Greeting the player. In character. |
| 4 | [ ] | `rico/greet_4.ogg` | Let it ride, baby! Or fold. I'm indifferent. I'm lying, LET IT RIDE. | Greeting the player. In character. |
| 5 | [ ] | `rico/farewell_1.ogg` | Wish me luck. Please. I'm asking a vending machine, so yeah, it's that bad. | Parting words as the player leaves. |
| 6 | [ ] | `rico/farewell_2.ogg` | See you at the top of the Bellagiro, or the bottom of a dumpster. Same dress code. | Parting words as the player leaves. |
| 7 | [ ] | `rico/farewell_3.ogg` | I'll be rich by dinner, or dead by dinner. Either way I'm skipping the check. | Parting words as the player leaves. |
| 8 | [ ] | `rico/farewell_4.ogg` | Let it ride. And if it doesn't, I respawn with a better last line. | Parting words as the player leaves. |
| 9 | [ ] | `rico/rich_1.ogg` | I'm rich. Wait, let me count again. That's one chip. Fine, still rich. | The player is carrying a lot of money. |
| 10 | [ ] | `rico/rich_2.ogg` | Look at all this money. Time to bet it all. It's the responsible thing. I'm using the word wrong, on purpose. | The player is carrying a lot of money. |
| 11 | [ ] | `rico/rich_3.ogg` | Cash out? I don't even know her. | The player is carrying a lot of money. |
| 12 | [ ] | `rico/rich_4.ogg` | The pot's fat, so I'll make it fatter. Then I'll lose it. Balance matters. | The player is carrying a lot of money. |
| 13 | [ ] | `rico/broke_1.ogg` | Broke means I have nothing to lose. Which has never once stopped me from losing it. | The player is nearly broke. |
| 14 | [ ] | `rico/broke_2.ogg` | Zero dollars, infinite possibilities. Mostly pawn shops. Mags is going to love this. | The player is nearly broke. |
| 15 | [ ] | `rico/broke_3.ogg` | I've been broker than this. I'm fine. Look, I'm doing a little dance. It's mostly shaking. | The player is nearly broke. |
| 16 | [ ] | `rico/broke_4.ogg` | Rock bottom has a great view of other, deeper bottoms. | The player is nearly broke. |
| 17 | [ ] | `rico/ugly_1.ogg` | I look like a dumpster fire, and I love it. Fire's warm. Dumpsters are home. | The player is wearing ugly clothes. |
| 18 | [ ] | `rico/ugly_2.ogg` | Is this fanny pack lucky? Please be lucky. I'm begging a fanny pack. New low. | The player is wearing ugly clothes. |
| 19 | [ ] | `rico/ugly_3.ogg` | Style is for people with good odds. I have vibes, and I wear them to every boss fight. | The player is wearing ugly clothes. |
| 20 | [ ] | `rico/ugly_4.ogg` | Somebody call a stylist. Or an exorcist. Or a stylist who's an exorcist. I pay in future winnings. | The player is wearing ugly clothes. |
| 21 | [ ] | `rico/sharp_1.ogg` | I look incredible. The House should be scared. And then it should add this suit to my tab. | The player is dressed sharp. |
| 22 | [ ] | `rico/sharp_2.ogg` | Dressed to kill, or at least to lose in style. Style is the only thing I keep. | The player is dressed sharp. |
| 23 | [ ] | `rico/sharp_3.ogg` | I clean up nice. Just don't look at the shoes. The shoes are doing their best. | The player is dressed sharp. |
| 24 | [ ] | `rico/sharp_4.ogg` | Would I bet on me looking this good? Obviously. I already put the suit on credit. | The player is dressed sharp. |
| 25 | [ ] | `rico/died_1.ogg` | Okay, that one was on me. The last one was the wall's fault. The one before that was also the wall. | The player just died. |
| 26 | [ ] | `rico/died_2.ogg` | Dying is no big deal. I do it for a living. A bad living, but still. The loading screen knows my name. | The player just died. |
| 27 | [ ] | `rico/died_3.ogg` | Next time I'll do it differently. Or exactly the same. Variety is overrated. | The player just died. |
| 28 | [ ] | `rico/died_4.ogg` | I regret nothing. Except that. And the thing before it. And, okay, the whole year. | The player just died. |
| 29 | [ ] | `rico/boss_1.ogg` | Read 'em and weep, pal. You're weeping already? Good. I'll send flowers to your next of kin, the House. | The player just beat a boss. |
| 30 | [ ] | `rico/boss_2.ogg` | Another boss down, another reason to gamble. Not that I ever needed one. | The player just beat a boss. |
| 31 | [ ] | `rico/boss_3.ogg` | I called the bluff, and then the bluff cried. Unprofessional. Ten out of ten. | The player just beat a boss. |
| 32 | [ ] | `rico/boss_4.ogg` | Who's next? Don't tell me. Okay, tell me, but make it dramatic. | The player just beat a boss. |
| 33 | [ ] | `rico/idle_1.ogg` | Odds are for people with a plan. I have a hunch and a bus pass. | Idle chatter. Random. |
| 34 | [ ] | `rico/idle_2.ogg` | I once bet my shoes. Won them, lost them, walked home barefoot. Net zero shoes, but I felt incredible. | Idle chatter. Random. |
| 35 | [ ] | `rico/idle_3.ogg` | Risk is just fun with consequences. The consequences are mostly a rash. | Idle chatter. Random. |
| 36 | [ ] | `rico/idle_4.ogg` | The plan: climb five casinos, get James, don't bet him. Step three is going to be the hard part. | Idle chatter. Random. |
| 37 | [ ] | `rico/buy_1.ogg` | Take my money! Wait, all of it? Fine, take all of it. | The player just bought something. |
| 38 | [ ] | `rico/buy_2.ogg` | Sold. Wait, what was the price? Never mind, sold. James would be so proud. That's the problem. | The player just bought something. |
| 39 | [ ] | `rico/buy_3.ogg` | Worth it, probably. If I die, it's a donation to people with fewer problems. So, anybody. | The player just bought something. |
| 40 | [ ] | `rico/buy_4.ogg` | That's a terrible deal. I'm in. I'm so in. I was in before you finished the sentence. | The player just bought something. |
| 41 | [ ] | `rico/boss_intro_draftqueens.ogg` | Five Card Draw? I've drawn worse. Last month I drew my landlord, and he had four aces and a lease. | Hero cockily answers the boss. |
| 42 | [ ] | `rico/boss_defeat_draftqueens.ogg` | You drafted a loser, buddy, and the loser is me, and I'm keeping the pot. Fair trade. | Hero victory line. Smug. |
| 43 | [ ] | `rico/boss_intro_fandool.ogg` | Seven Card Stud? Cute. My last seven-card stud was a Tuesday and a cry for help, and I lost both. | Hero cockily answers the boss. |
| 44 | [ ] | `rico/boss_defeat_fandool.ogg` | Call it, because I'm done. I'll watch the highlight reel of me, winning, on a loop. Alone. | Hero victory line. Smug. |
| 45 | [ ] | `rico/boss_intro_pokerstarz.ogg` | Omaha? Four hole cards? That's four problems, Rico, and I've already got four, plus a pair of shoes I can't afford. | Hero cockily answers the boss. |
| 46 | [ ] | `rico/boss_defeat_pokerstarz.ogg` | You're a content creator and I'm the main character, so thanks for the extra screen time. Don't forget to subscribe to my debt. | Hero victory line. Smug. |
| 47 | [ ] | `rico/boss_intro_betmgn.ogg` | Three Card Poker? Fast game, perfect for a man with no attention span and no savings. I'm a very efficient disaster. | Hero cockily answers the boss. |
| 48 | [ ] | `rico/boss_defeat_betmgn.ogg` | Pair plus? I'll take the pair, and you can have the plus, and it comes with an ambulance. Please enjoy it. | Hero victory line. Smug. |
| 49 | [ ] | `rico/boss_intro_steake.ogg` | Razz, where the worst hand wins? I was built for this, Rico. I've been the worst since birth and I've never gotten a trophy. | Hero cockily answers the boss. |
| 50 | [ ] | `rico/boss_defeat_steake.ogg` | Stake it all, that's my brand. And thanks to you I'll stake it all again, on a new brand, called Eat Me. | Hero victory line. Smug. |
| 51 | [ ] | `rico/boss_intro_bovadoh.ogg` | Pai Gow? Two hands? I only have one personality, and honestly, I'd like to split it into two and keep the good one for myself. | Hero cockily answers the boss. |
| 52 | [ ] | `rico/boss_defeat_bovadoh.ogg` | Two hands, two wins. Do the math. I did. I was bad at it, but the math still checks out. | Hero victory line. Smug. |
| 53 | [ ] | `rico/boss_intro_seezers.ogg` | Blackjack? I'll hit. I'll hit hard. Hit me, Caesar, hit me again, and tell the Senate to bring a bigger knife. | Hero cockily answers the boss. |
| 54 | [ ] | `rico/boss_defeat_seezers.ogg` | Caesar's Palace was a casino, so I'd like to buy it, for a drink. One drink. Please don't make that a bet. | Hero victory line. Smug. |
| 55 | [ ] | `rico/boss_intro_wynners.ogg` | Baccarat? Tuxedo, no money, and a martini. We've met before. It was at a funeral, and I was the guest of honor. | Hero cockily answers the boss. |
| 56 | [ ] | `rico/boss_defeat_wynners.ogg` | Banker or Player? Put me down for 'tired,' and deal. I'll be at the bar, losing separately. | Hero victory line. Smug. |
| 57 | [ ] | `rico/boss_intro_snake_eyes.ogg` | Craps? Sure, I'm a craps man. I'm also a crap man, and I'd like both names on my headstone. | Hero cockily answers the boss. |
| 58 | [ ] | `rico/boss_defeat_snake_eyes.ogg` | Rolled it. And the dice rolled you. Same story, different dice, but I still keep the pot. | Hero victory line. Smug. |
| 59 | [ ] | `rico/boss_intro_rusty_slots.ogg` | A haunted slot machine? Honestly, I've dated worse, mostly because she also took all my coins. | Hero cockily answers the boss. |
| 60 | [ ] | `rico/boss_defeat_rusty_slots.ogg` | You pulled the arm and the arm pulled you. Hug it out, or tilt, whichever comes with fewer lawsuits. | Hero victory line. Smug. |
| 61 | [ ] | `rico/boss_intro_mr_lucky.ogg` | Keno? Hit eighty numbers? Sounds like a Tuesday. A busy one, with a lot of math, and then crying. | Hero cockily answers the boss. |
| 62 | [ ] | `rico/boss_defeat_mr_lucky.ogg` | Good game, Kevin. May the next one be less numerical. I'd say hell, but Mags would send me the bill. | Hero victory line. Smug. |
| 63 | [ ] | `rico/boss_intro_the_house.ogg` | Texas Hold'em for my brother? I've bet worse on less. Deal the cards. I am going to need a bigger stack. | Hero cockily answers the boss. |
| 64 | [ ] | `rico/boss_defeat_the_house.ogg` | Read 'em and weep, because this time I'm all in, and so is the entire family tree. Now, where's James? | Hero victory line. Smug. |
| 65 | [ ] | `_cutscenes/city1_arrive/city1_arrive_1.ogg` | Atlantic Shitty. Boardwalk, taffy, and the saddest seagulls on earth. Honestly, it's the nicest place I've been all week. | Cutscene: city1 arrive |
| 66 | [ ] | `_cutscenes/city1_arrive/city1_arrive_3.ogg` | Everything is wet, Marlow. And I think the dumpster just winked at me. | Cutscene: city1 arrive |
| 67 | [ ] | `_cutscenes/city1_arrive/city1_arrive_4.ogg` | Hold on, that's James's jacket. He wore it to every bad decision of his life. And there's a pawn ticket in the pocket, from Reno. | Cutscene: city1 arrive |
| 68 | [ ] | `_cutscenes/city2_arrive/city2_arrive_1.ogg` | Reno, the biggest little city in the world. A clown just asked me for a cigarette, so the slogan checks out. | Cutscene: city2 arrive |
| 69 | [ ] | `_cutscenes/city2_arrive/city2_arrive_5.ogg` | Promoted to Biloxi? Marlow, that's not a promotion. That's a punishment with a river view. | Cutscene: city2 arrive |
| 70 | [ ] | `_cutscenes/city3_arrive/city3_arrive_1.ogg` | Biloxi, home of Hard Rok. Loud guitars, louder humidity, and the whole place smells like a wet concert. | Cutscene: city3 arrive |
| 71 | [ ] | `_cutscenes/city3_arrive/city3_arrive_3.ogg` | Quiet was never my thing, Marlow. I got thrown out of a library for whispering too loud. | Cutscene: city3 arrive |
| 72 | [ ] | `_cutscenes/city3_arrive/city3_arrive_5.ogg` | ...You WHAT. | Cutscene: city3 arrive |
| 73 | [ ] | `_cutscenes/city3_arrive/city3_arrive_7.ogg` | When this is over, Marlow, I'm going to be so mad at you that I'll schedule it. | Cutscene: city3 arrive |
| 74 | [ ] | `_cutscenes/city4_arrive/city4_arrive_1.ogg` | Fremont, Old Vegas. The neon is older than my debt and still glowing, which is more than I can say for my career. | Cutscene: city4 arrive |
| 75 | [ ] | `_cutscenes/city4_arrive/city4_arrive_4.ogg` | Wait, a note in James's handwriting. 'Don't come for me. I'm finally winning.' | Cutscene: city4 arrive |
| 76 | [ ] | `_cutscenes/city4_arrive/city4_arrive_5.ogg` | He doesn't want to be saved. He's hooked, just like me. I'd call that heartbreaking, but honestly, it's a little relatable. | Cutscene: city4 arrive |
| 77 | [ ] | `_cutscenes/city5_arrive/city5_arrive_1.ogg` | The Strip. Nicest casino in the world, and I'm standing in it covered in alley. Bold look, and nobody has stopped me. | Cutscene: city5 arrive |
| 78 | [ ] | `_cutscenes/city1_clue/city1_clue_1.ogg` | James's first IOU, right out of the boss's pocket. 'I owe the House one brother.' I'd call it a typo, but it isn't. | Cutscene: city1 clue |
| 79 | [ ] | `_cutscenes/city2_clue/city2_clue_1.ogg` | Another IOU, and this one says 'Dealing at Hard Rok.' James isn't just gambling anymore. He works for The House. | Cutscene: city2 clue |
| 80 | [ ] | `_cutscenes/city3_clue/city3_clue_1.ogg` | An IOU and a torn receipt that says 'Fremont, Goldun Nugget, sublet: one lifetime.' I'm not even going to ask what that costs. | Cutscene: city3 clue |
| 81 | [ ] | `_cutscenes/city4_clue/city4_clue_1.ogg` | A chip with 'JAMES, PENTHOUSE' carved into it. That's either a clue or a very specific Christmas gift. | Cutscene: city4 clue |
| 82 | [ ] | `_cutscenes/secret_found/secret_found_1.ogg` | A hidden room with a secret table. The House having a secret is the least surprising thing that's happened today. | Cutscene: secret found |
| 83 | [ ] | `_cutscenes/secret_defeat/secret_defeat_1.ogg` | Another secret table beaten, and a nice pile of chips. I'm starting to see why The House hid these. | Cutscene: secret defeat |
| 84 | [ ] | `_cutscenes/secret_defeat/secret_defeat_3.ogg` | Good. I'd hate to be the only one. | Cutscene: secret defeat |
| 85 | [ ] | `_cutscenes/final_prelude/final_prelude_2.ogg` | Cute. Deal the cards. | Cutscene: final prelude |
| 86 | [ ] | `_cutscenes/intro/intro_1.ogg` | My brother James sat down at The House's table and bet himself. Then he lost, which means he now works there, which means my family finally has a steady job. | Cutscene: intro |
| 87 | [ ] | `_cutscenes/intro/intro_2.ogg` | So the plan is to climb five casinos, from a dumpster in Atlantic Shitty to the Strip, and win him back. I've bet on worse things. Mostly myself. | Cutscene: intro |
| 88 | [ ] | `_cutscenes/intro/intro_5.ogg` | So... infinite credit? I can't die, I just owe more? I've been training for this my entire life. | Cutscene: intro |
| 89 | [ ] | `_cutscenes/mags_chase/mags_chase_2.ogg` | ...Can we talk about this? | Cutscene: mags chase |
| 90 | [ ] | `_cutscenes/ending/ending_1.ogg` | The House folds, and the penthouse goes quiet. At the far table, a man in a vest keeps dealing cards to nobody. My brother, James, still winning. | Cutscene: ending |
| 91 | [ ] | `_cutscenes/ending/ending_3.ogg` | James, you have to cash out. Walk away from a winning table. I know, I've never done it either, but it only works if you choose it. | Cutscene: ending |
| 92 | [ ] | `_cutscenes/ending/ending_5.ogg` | Look, I'm the last guy who should say this. I once bet my shoes, won the bet, and lost the shoes. I'm not a role model. Come home. | Cutscene: ending |
| 93 | [ ] | `_cutscenes/ending/ending_7.ogg` | Welcome home, brother. ...So, one more run? For fun? Just a little one? | Cutscene: ending |
| 94 | [ ] | `_cutscenes/true_ending/true_ending_2.ogg` | No. I read your tickets, Eddie Duval. All twenty of them. Your handwriting is somehow worse than James's, and he writes with his elbow. | Cutscene: true ending |
| 95 | [ ] | `_cutscenes/true_ending/true_ending_4.ogg` | You never learned to walk away, so I'm teaching you. Cash out, Eddie. Take the win. It's like a refund, but for your whole life. | Cutscene: true ending |
| 96 | [ ] | `_cutscenes/true_ending/true_ending_9.ogg` | Even my debt? ...That's disappointing. It was my longest relationship. | Cutscene: true ending |
| 97 | [ ] | `rico/marlow_intro_3.ogg` | So I can't die. Great. What's the catch? | Conversation: marlow_intro |
| 98 | [ ] | `rico/marlow_confess_3.ogg` | ...You put my brother at that table. | Conversation: marlow_confess |
| 99 | [ ] | `rico/vera_intro_3.ogg` | And up here? | Conversation: vera_intro |
| 100 | [ ] | `rico/mags_intro_4.ogg` | You're a shark. In a suit. | Conversation: mags_intro |

### MARLOW: 97 lines

Folder: `voice/marlow/` (cutscene lines go in the folder shown). Voice: Hold the phone away and sigh before the line..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `marlow/greet_1.ogg` | Rico, you picked up. I bet against that, so I owe myself money. Typical. | Greeting the player. In character. |
| 2 | [ ] | `marlow/greet_2.ogg` | Marlow here. Talk fast. The sandwich is getting cold and so is my will to live. | Greeting the player. In character. |
| 3 | [ ] | `marlow/greet_3.ogg` | Back already, kid? I was just worrying about you. It's my only hobby, besides guilt. | Greeting the player. In character. |
| 4 | [ ] | `marlow/greet_4.ogg` | Say something stupid so I know you're alive. Perfect. Now I can go back to feeling guilty about James. | Greeting the player. In character. |
| 5 | [ ] | `marlow/farewell_1.ogg` | Stay alive, stay lucky, or stay on the line. Pick two. I've never managed even one. | Parting words as the player leaves. |
| 6 | [ ] | `marlow/farewell_2.ogg` | Call me if you need me, kid. Call me if you don't. It's a payphone, nobody else does. | Parting words as the player leaves. |
| 7 | [ ] | `marlow/farewell_3.ogg` | Don't do anything I'd worry about. Too late, I've started the eulogy. It's mostly about me. | Parting words as the player leaves. |
| 8 | [ ] | `marlow/farewell_4.ogg` | Go get your brother, Rico. The one I got the seat for. I really hate how that sentence ends. | Parting words as the player leaves. |
| 9 | [ ] | `marlow/rich_1.ogg` | You're rich, Rico. Bank it. Please. I'm begging from the floor, where I've been lying down since the last time you were rich. | The player is carrying a lot of money. |
| 10 | [ ] | `marlow/rich_2.ogg` | Don't tell the House you're rich, and for the love of God, don't tell James. He'll want a loan. | The player is carrying a lot of money. |
| 11 | [ ] | `marlow/rich_3.ogg` | Bank it, Rico, please. I'm on the floor begging. The dust bunny and I are on a first-name basis. | The player is carrying a lot of money. |
| 12 | [ ] | `marlow/rich_4.ogg` | I've seen men lose that much in one hand, kid. Twice it was me. Once it was your brother, and I helped. | The player is carrying a lot of money. |
| 13 | [ ] | `marlow/broke_1.ogg` | Broke again? That's three times today, and it's lunch. Your brother budgets better, and he lives in a casino. | The player is nearly broke. |
| 14 | [ ] | `marlow/broke_2.ogg` | It's just money, Rico, it comes back. Probably. I'm a bad promise guy, ask James. | The player is nearly broke. |
| 15 | [ ] | `marlow/broke_3.ogg` | I'd cover dinner, but I'm broke too, and James still thinks I'm solvent. Don't tell him. | The player is nearly broke. |
| 16 | [ ] | `marlow/broke_4.ogg` | You're not broke, Rico, you're liquid. Sad, like a puddle. Same energy as me, except I have a sandwich. | The player is nearly broke. |
| 17 | [ ] | `marlow/ugly_1.ogg` | What are you wearing, Rico? I'm on a payphone and I can still hear it whisper 'help.' | The player is wearing ugly clothes. |
| 18 | [ ] | `marlow/ugly_2.ogg` | Is that a fanny pack? Don't ask how I can see it. Some things you feel through the phone. | The player is wearing ugly clothes. |
| 19 | [ ] | `marlow/ugly_3.ogg` | Style isn't everything, Rico. It's about eighty percent. I got through life on the other twenty, which is why I live in a phone booth. | The player is wearing ugly clothes. |
| 20 | [ ] | `marlow/ugly_4.ogg` | Please go see Silas, kid. I'm in a phone booth. There's nowhere to look but you. | The player is wearing ugly clothes. |
| 21 | [ ] | `marlow/sharp_1.ogg` | Nice suit, Rico. I can hear the starch. It's screaming 'don't bleed on me.' | The player is dressed sharp. |
| 22 | [ ] | `marlow/sharp_2.ogg` | You look like a man with a plan. Do you have a plan? Blink twice if no. Right, it's a phone. | The player is dressed sharp. |
| 23 | [ ] | `marlow/sharp_3.ogg` | Dressed to kill, kid. Please try not to be killed in it. Silas would never forgive either of us. | The player is dressed sharp. |
| 24 | [ ] | `marlow/sharp_4.ogg` | Nice threads, Rico. Keep the blood off. I called in favors for that fabric, and I'm out of favors and friends. | The player is dressed sharp. |
| 25 | [ ] | `marlow/died_1.ogg` | Rico, again? We have to stop meeting like this: you dead, me on a payphone, a sandwich in the middle. | The player just died. |
| 26 | [ ] | `marlow/died_2.ogg` | I heard the thud, kid. I clapped before I could stop myself. Now I feel terrible and I'm eating about it. | The player just died. |
| 27 | [ ] | `marlow/died_3.ogg` | You died, so I lit a candle. It's a matchstick. Don't make it weird, it's what I can afford. | The player just died. |
| 28 | [ ] | `marlow/died_4.ogg` | Good news, you're alive again. Bad news, it's still me on the phone, and James is still in there. | The player just died. |
| 29 | [ ] | `marlow/boss_1.ogg` | Boss down? I'm updating my bet. I now say you survive. First time I've bet on you. Put it in writing so I can't back out. | The player just beat a boss. |
| 30 | [ ] | `marlow/boss_2.ogg` | One casino down, kid. James is a little closer. Or farther. I'm checking the map, by which I mean a napkin. | The player just beat a boss. |
| 31 | [ ] | `marlow/boss_3.ogg` | You did it, Rico. Don't let it go to your head. Let it go to the bank. I'll have a sandwich ready. | The player just beat a boss. |
| 32 | [ ] | `marlow/boss_4.ogg` | I'm proud of you, kid. I'm checking my pulse. Pride and a pulse in one afternoon, I might die. | The player just beat a boss. |
| 33 | [ ] | `marlow/idle_1.ogg` | Five casinos, twenty-five floors, and James at the top of the Bellagiro. Easy. By easy I mean impossible. I'm sorry. | Idle chatter. Random. |
| 34 | [ ] | `marlow/idle_2.ogg` | I keep thinking about the day I got James that seat. I tell myself it was a favor. Then I eat. | Idle chatter. Random. |
| 35 | [ ] | `marlow/idle_3.ogg` | Follow the light, kid. Hopefully it's the exit and not the one people see at the end. Call me either way. | Idle chatter. Random. |
| 36 | [ ] | `marlow/idle_4.ogg` | Every floor has a story, Rico. Yours are all about losing. Mine is about a payphone, a sandwich, and one bad favor. | Idle chatter. Random. |
| 37 | [ ] | `marlow/buy_1.ogg` | Good call, kid. Not great. Good, like a report card for a goldfish. I'm celebrating with a small sandwich. | The player just bought something. |
| 38 | [ ] | `marlow/buy_2.ogg` | Read the fine print, Rico. There's no fine print. That's the fine print. I should know, I signed everything, including your brother's seat. | The player just bought something. |
| 39 | [ ] | `marlow/buy_3.ogg` | I wouldn't. But I'm not you, thank God. I'm saying that with guilt and some mayo. | The player just bought something. |
| 40 | [ ] | `marlow/buy_4.ogg` | James would have bought that too. Look where it got him. Actually, look where it got me. I'm the one who feels bad. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city1_arrive/city1_arrive_2.ogg` | Rico, you're in the alley behind Resortz. Please don't touch anything wet, and don't make eye contact with the dumpster. | Cutscene: city1 arrive |
| 42 | [ ] | `_cutscenes/city1_arrive/city1_arrive_5.ogg` | A pawn ticket from Reno. Good news, Rico, you have a clue. Bad news, the clue is Reno. | Cutscene: city1 arrive |
| 43 | [ ] | `_cutscenes/city2_arrive/city2_arrive_2.ogg` | That's the doorman at Cirrcus Cirrcus, Rico. Smile, don't make eye contact, and never ask about the balloons. | Cutscene: city2 arrive |
| 44 | [ ] | `_cutscenes/city3_arrive/city3_arrive_2.ogg` | Keep it down in there, Rico. Hard Rok keeps its toughest guys by the stage, and they're sensitive about their eardrums. | Cutscene: city3 arrive |
| 45 | [ ] | `_cutscenes/city3_arrive/city3_arrive_4.ogg` | Before you go in, I have to tell you something, and I need you not to throw anything. I'm the one who got James his seat at The House's table. | Cutscene: city3 arrive |
| 46 | [ ] | `_cutscenes/city3_arrive/city3_arrive_6.ogg` | I thought he'd win, Rico. He always won. It was a safe bet, on paper, and the paper is currently on fire. | Cutscene: city3 arrive |
| 47 | [ ] | `_cutscenes/city3_arrive/city3_arrive_8.ogg` | Fair. But I'm the only one who knows the way up to the penthouse where The House keeps James. So climb first, yell second, and please hurry, I'm very uncomfortable. | Cutscene: city3 arrive |
| 48 | [ ] | `_cutscenes/city4_arrive/city4_arrive_2.ogg` | Goldun Nugget has a shark tank and a long memory, Rico. Everyone's welcome to come in. Leaving is the part they argue about. | Cutscene: city4 arrive |
| 49 | [ ] | `_cutscenes/city5_arrive/city5_arrive_4.ogg` | James is in the penthouse at the top of the Bellagiro, Rico. Remember the plan: climb five casinos, get James, and do not bet him. | Cutscene: city5 arrive |
| 50 | [ ] | `_cutscenes/city1_clue/city1_clue_2.ogg` | Flip it over. There's a note on the back that says 'Reno.' Good news, James is alive. Bad news, he's in Reno. | Cutscene: city1 clue |
| 51 | [ ] | `_cutscenes/city2_clue/city2_clue_2.ogg` | Confirmed. James is dealing for The House now. Fast hands, no sleep, vacant stare. It's honestly a very James career. | Cutscene: city2 clue |
| 52 | [ ] | `_cutscenes/city3_clue/city3_clue_2.ogg` | He's moving up, Rico. Every city, a better table and a worse deal. I'd feel terrible about that, if I weren't already at capacity. | Cutscene: city3 clue |
| 53 | [ ] | `_cutscenes/city4_clue/city4_clue_2.ogg` | That's the top floor of the Bellagiro, where The House keeps him. One more climb, Rico, and please don't die. I'd like to yell at you in person. | Cutscene: city4 clue |
| 54 | [ ] | `_cutscenes/secret_found/secret_found_2.ogg` | That's not on any map I have, Rico. Be careful in there. Or don't. I'm a voice in your ear, not a leash. | Cutscene: secret found |
| 55 | [ ] | `_cutscenes/secret_defeat/secret_defeat_2.ogg` | You're not supposed to know about those rooms, Rico. The House will be very upset, in its calm, corporate way. | Cutscene: secret defeat |
| 56 | [ ] | `_cutscenes/intro/intro_7.ogg` | Radio check, Rico. The House keeps James at the top of the Bellagiro, on the Strip. Every chip you grab rides in your Pot, and at each door you bank it or let it ride for double. You'll let it ride. You always let it ride. | Cutscene: intro |
| 57 | [ ] | `_cutscenes/intro/intro_8.ogg` | Now get in that heap you call a car. The goal, in plain English: climb five casinos, get James, and try very hard not to bet him. | Cutscene: intro |
| 58 | [ ] | `_cutscenes/ending/ending_4.ogg` | Rico, I've seen a lot of men walk away from a table, and exactly zero of them were happy about it. Be gentle with him, he's basically a cat. | Cutscene: ending |
| 59 | [ ] | `_cutscenes/ending/ending_8.ogg` | Rico, you absolute lunatic, the top of the Bellagiro is a casino, you can't just do another lap. ...Fine. High Roller mode is open. Let it ride, kid. | Cutscene: ending |
| 60 | [ ] | `_cutscenes/true_ending/true_ending_8.ogg` | Rico, the lights just went warm at the top of the Bellagiro. Every Marker in the apartment burned up at once. Everyone's free, including me, which is terrifying. | Cutscene: true ending |
| 61 | [ ] | `_cutscenes/true_ending/true_ending_10.ogg` | Course not, it's still a casino. It's just ours now. Let it ride, kid. | Cutscene: true ending |
| 62 | [ ] | `marlow/radio_1.ogg` | Same deal as always, Rico. Grab the chips, run for the door, and don't get cute. You'll get cute. I've made peace with it, and a little bit of a will. | Radio/lobby: radio |
| 63 | [ ] | `marlow/radio_2.ogg` | Word is security doubled. When a big lug winds up, parry him. Or just die and wake up at home. It's free, in the sense that Mags is billing you. | Radio/lobby: radio |
| 64 | [ ] | `marlow/radio_3.ogg` | Good news, James is alive. Bad news, he's one casino ahead of you, and I got him the job. I'll explain that part later. Or never. Probably never. | Radio/lobby: radio |
| 65 | [ ] | `marlow/radio_4.ogg` | Slot machines on every floor. Bet the Pot if you're feeling lucky. I wouldn't, but I'm broke, so take that as research. | Radio/lobby: radio |
| 66 | [ ] | `marlow/radio_5.ogg` | Smash the glass, smash the crates, grab whatever falls out. Insurance won't cover it, but you will, in the sense that you'll be the one dying. | Radio/lobby: radio |
| 67 | [ ] | `marlow/radio_6.ogg` | James left a trail of IOUs up the whole coast. Follow the money and you'll find him, or a very tired accountant holding about forty of them. | Radio/lobby: radio |
| 68 | [ ] | `marlow/radio_7.ogg` | Back again? The Fence has new toys if you've banked enough. He also has a new face. Stop asking, Rico. Nobody wants to know how. | Radio/lobby: radio |
| 69 | [ ] | `marlow/first_exit_1.ogg` | First door. Cash out and that money is yours forever, which in this town means The Fence will gladly take it off your hands for a very fair price. He sets the price. | Radio/lobby: first exit |
| 70 | [ ] | `marlow/first_exit_2.ogg` | Or let it ride for double the multiplier, and the House adds a rule. Your call, high roller. It's your funeral, but let's be honest, it's also a Tuesday. | Radio/lobby: first exit |
| 71 | [ ] | `marlow/marlow_intro_1.ogg` | Rico! You picked up! So the rumors are true: The House doesn't let debtors die, it just mails them home with a bigger bill, like a very rude pizza. | Conversation: marlow_intro |
| 72 | [ ] | `marlow/marlow_intro_2.ogg` | You bust, you wake up in your apartment, and the interest on your Marker goes up. Every do-over costs money, which makes it the worst video game ever, and I say that as your babysitter. | Conversation: marlow_intro |
| 73 | [ ] | `marlow/marlow_intro_4.ogg` | The catch is you never stop owing. Climb the five casinos, get James back from The House, and get out before the interest finishes its own climb. | Conversation: marlow_intro |
| 74 | [ ] | `marlow/marlow_spikes_1.ogg` | You died to spikes again? Rico, they don't move, they don't sneak, and they have exactly one job, and you keep helping them do it. | Conversation: marlow_spikes |
| 75 | [ ] | `marlow/marlow_guard_1.ogg` | Those bouncers telegraph every punch, so parry right before it lands and they'll be eating carpet, which, I'll be honest, is where most of this casino's customers end up anyway. | Conversation: marlow_guard |
| 76 | [ ] | `marlow/marlow_bat_1.ogg` | You lost to rats, Rico. I'm leaving that out of the report, and the eulogy, and honestly the rest of your life story. | Conversation: marlow_bat |
| 77 | [ ] | `marlow/marlow_sal_1.ogg` | That first boss fights like he deals, slow and then suddenly rude, so wait for the big wind-up, sidestep it, and punish him while he's still being dramatic. | Conversation: marlow_sal |
| 78 | [ ] | `marlow/marlow_sal_2.ogg` | And parry the big move if you can, because it stuns him wide open for double damage, which is the whole tip, and the rest of my advice is mostly sighing. | Conversation: marlow_sal |
| 79 | [ ] | `marlow/marlow_roulette_1.ogg` | The second boss throws balls at you, and the balls bounce, so hit them right back at her, because nothing hurts a gambler more than getting her own bad luck returned. | Conversation: marlow_roulette |
| 80 | [ ] | `marlow/marlow_house_1.ogg` | You made it all the way to the penthouse, which is further than James ever got, further than me, and a lot further than my self-respect. | Conversation: marlow_house |
| 81 | [ ] | `marlow/marlow_house_2.ogg` | So don't you dare quit now, because I'll be so annoyed, and then I'll cry, loudly, on a payphone, in public. | Conversation: marlow_house |
| 82 | [ ] | `marlow/marlow_mags_1.ogg` | Mags got you? You borrowed money from a shark in a suit, Rico, and there were warning signs, one of which was literally a fin. | Conversation: marlow_mags |
| 83 | [ ] | `marlow/marlow_greedy_1.ogg` | You were riding at times eight when you busted, which is the exact kind of number I would have put on a tombstone if you could stay dead. | Conversation: marlow_greedy |
| 84 | [ ] | `marlow/marlow_greedy_2.ogg` | Just bank once in a while, okay? James never did, and look where it got him: a job at the casino, as the help, with a name tag. | Conversation: marlow_greedy |
| 85 | [ ] | `marlow/marlow_careful_1.ogg` | Three cash-outs last run? That's careful money, Rico, so who are you, and what did you do with my idiot? | Conversation: marlow_careful |
| 86 | [ ] | `marlow/marlow_confess_1.ogg` | About what I said in Biloxi: I used to deal for The House, and I'm the one who got James his seat at that table. | Conversation: marlow_confess |
| 87 | [ ] | `marlow/marlow_confess_2.ogg` | I honestly thought he'd win, because he always won, and I know that's not an excuse, it's just a really bad bet that I'm still paying off. | Conversation: marlow_confess |
| 88 | [ ] | `marlow/marlow_confess_4.ogg` | I did, and now I'm talking you back to him, one casino at a time, which is the only apology I've got, and it's a bad one, but it's also a pretty decent one, considering. | Conversation: marlow_confess |
| 89 | [ ] | `marlow/marlow_vault_1.ogg` | You cracked a safe! They only open if you get there fast, so speed pays at every casino, which is honestly the only thing those casinos have in common. | Conversation: marlow_vault |
| 90 | [ ] | `marlow/marlow_daily_1.ogg` | Daily Deal, huh? Everyone in the world gets the same floors today, so go show them how it's done, or at least how to die in a really creative way. | Conversation: marlow_daily |
| 91 | [ ] | `marlow/marlow_ending_1.ogg` | James is out, the Bellagiro is quiet, and you're still picking up this phone, which I'm choosing to find sweet instead of worrying. | Conversation: marlow_ending |
| 92 | [ ] | `marlow/marlow_ending_2.ogg` | ...Yeah, no, I'd go back too, honestly. Let it ride, kid. | Conversation: marlow_ending |
| 93 | [ ] | `marlow/marlow_true_1.ogg` | The House is quiet for the first time in twenty years, and that was you, and I still can't believe I helped. | Conversation: marlow_true |
| 94 | [ ] | `marlow/marlow_true_2.ogg` | Eddie Duval finally cashed out, so I owe you a drink, actually about a thousand drinks, okay, fine, I owe you a bar. | Conversation: marlow_true |
| 95 | [ ] | `marlow/marlow_rep1_1.ogg` | Chain your moves, because The House pays out to style, and it also pays out to charity, but never, ever to you. | Conversation: marlow_rep1 |
| 96 | [ ] | `marlow/marlow_rep2_1.ogg` | That static on the line is The House listening, so, hi, House, we were totally not talking about you. | Conversation: marlow_rep2 |
| 97 | [ ] | `marlow/marlow_rep3_1.ogg` | Smash the glass, grab the chips, and bank before you get cute, in that order, and please do not rearrange it like you did last time. | Conversation: marlow_rep3 |

### VERA: 65 lines

Folder: `voice/vera/` (cutscene lines go in the folder shown). Voice: Whisper-purr. Never rush. You've seen every hand..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `vera/greet_1.ogg` | Sugar! Come in. I saved a charm for exactly your level of bad judgment. | Greeting the player. In character. |
| 2 | [ ] | `vera/greet_2.ogg` | Sit down, sugar. The cards are warm, the incense is legal in most states, and my hope costs triple. | Greeting the player. In character. |
| 3 | [ ] | `vera/greet_3.ogg` | Back again? Good. Everyone else in this building wants your soul. I only want your money. | Greeting the player. In character. |
| 4 | [ ] | `vera/greet_4.ogg` | My crystal ball asked who keeps paying full price for hope. I said that's Rico, he's my college fund. | Greeting the player. In character. |
| 5 | [ ] | `vera/farewell_1.ogg` | Go climb, sugar. And if the House kills you, die near my shop. Funeral crowds buy a lot of candles. | Parting words as the player leaves. |
| 6 | [ ] | `vera/farewell_2.ogg` | My charms work wonderfully, right up until they stop. I don't give refunds for stopping. | Parting words as the player leaves. |
| 7 | [ ] | `vera/farewell_3.ogg` | Climb safe, sugar. You're my best customer, and dead customers leave terrible reviews. | Parting words as the player leaves. |
| 8 | [ ] | `vera/farewell_4.ogg` | Walk toward the light, Rico. If you can't find it, walk toward my cash register. | Parting words as the player leaves. |
| 9 | [ ] | `vera/rich_1.ogg` | Look at that wallet, sugar. It's begging me to take it, and I'm a woman who helps the needy. | The player is carrying a lot of money. |
| 10 | [ ] | `vera/rich_2.ogg` | All that money and you came to see me? That's either wisdom or a cry for help, and both pay the same. | The player is carrying a lot of money. |
| 11 | [ ] | `vera/rich_3.ogg` | You're glowing, sugar. Is that wealth or a medical issue? I'll sell you a charm for each. | The player is carrying a lot of money. |
| 12 | [ ] | `vera/rich_4.ogg` | Rich suits you, Rico. It means you can afford the charms that come in a velvet bag with zero guarantees. | The player is carrying a lot of money. |
| 13 | [ ] | `vera/broke_1.ogg` | Broke, sugar? Fine. Hope is the only thing I sell that costs nothing to make, so I charge the most for it. | The player is nearly broke. |
| 14 | [ ] | `vera/broke_2.ogg` | You're not broke, sugar, you're pre-rich. It's a market segment, and I price it like one. | The player is nearly broke. |
| 15 | [ ] | `vera/broke_3.ogg` | Looking is free, sugar. Touching is a felony, and you've been eyeing that rabbit foot like a suspect. | The player is nearly broke. |
| 16 | [ ] | `vera/broke_4.ogg` | Come back when you've robbed someone with insurance. I'll sell you a charm that makes the police sleepy. | The player is nearly broke. |
| 17 | [ ] | `vera/ugly_1.ogg` | Sugar, what are you wearing? That outfit looks like a hostage situation where the hostage lost. | The player is wearing ugly clothes. |
| 18 | [ ] | `vera/ugly_2.ogg` | That outfit is cursed, darling. I'd know, I sell curses. Mine at least come in a nice box. | The player is wearing ugly clothes. |
| 19 | [ ] | `vera/ugly_3.ogg` | Even the slot machines looked away when you walked in, and they don't have eyes. | The player is wearing ugly clothes. |
| 20 | [ ] | `vera/ugly_4.ogg` | Go show Silas that outfit, honey. He'll faint, and I'm selling front row tickets with a free fainting charm. | The player is wearing ugly clothes. |
| 21 | [ ] | `vera/sharp_1.ogg` | Now that's how you dress for a funeral, sugar. Your own. I love that you planned ahead. | The player is dressed sharp. |
| 22 | [ ] | `vera/sharp_2.ogg` | All dapper and doomed. I can't decide whether to read your future or just say you look pretty and take your money. | The player is dressed sharp. |
| 23 | [ ] | `vera/sharp_3.ogg` | You clean up nice, sugar. Try not to bleed on it, because no charm in this shop removes bloodstains. | The player is dressed sharp. |
| 24 | [ ] | `vera/sharp_4.ogg` | If you die in that suit, at least it's an open casket with taste. I'll bill you for the candle in advance. | The player is dressed sharp. |
| 25 | [ ] | `vera/died_1.ogg` | You died again, sugar. It's becoming a hobby, but I respect a man who commits to a bit. | The player just died. |
| 26 | [ ] | `vera/died_2.ogg` | I saw it happen, honey. My shop cat watched too, then left the building without asking for a refund. | The player just died. |
| 27 | [ ] | `vera/died_3.ogg` | Dust yourself off, sugar. You woke up owing more than before, so at least make that debt mean something. | The player just died. |
| 28 | [ ] | `vera/died_4.ogg` | A bold way to lose, sugar. Not smart, just bold. In this town we put bold on the headstone and smart in the footnotes. | The player just died. |
| 29 | [ ] | `vera/boss_1.ogg` | You beat a boss, sugar. I'll remember that fondly, right up until you owe me money in about three minutes. | The player just beat a boss. |
| 30 | [ ] | `vera/boss_2.ogg` | Another casino boss dethroned. I considered being nicer to you, then I remembered my prices. | The player just beat a boss. |
| 31 | [ ] | `vera/boss_3.ogg` | That boss had friends, sugar, mean wealthy ones. They'll be shopping for my most expensive curses, so thank you. | The player just beat a boss. |
| 32 | [ ] | `vera/boss_4.ogg` | Let me price that victory, sugar. To you it's a triumph. To me it's an upsell. | The player just beat a boss. |
| 33 | [ ] | `vera/idle_1.ogg` | I keep telling the cards to stop gossiping about you, but they love a story that ends with someone losing everything. | Idle chatter. Random. |
| 34 | [ ] | `vera/idle_2.ogg` | Everybody has a tell, Rico. Yours is hope, which is why I'll never stop selling it to you. | Idle chatter. Random. |
| 35 | [ ] | `vera/idle_3.ogg` | Charms, curses and a little cold reading. The cold reading is just me watching you lose. | Idle chatter. Random. |
| 36 | [ ] | `vera/idle_4.ogg` | Nobody who buys a lucky charm ever stops needing one. In the industry, we call that retention. | Idle chatter. Random. |
| 37 | [ ] | `vera/buy_1.ogg` | Wise choice, sugar. Or a terrible one. The fee's the same either way, so I'm thrilled. | The player just bought something. |
| 38 | [ ] | `vera/buy_2.ogg` | Take it, sugar, it likes you. It likes everyone. That's why I hired it. | The player just bought something. |
| 39 | [ ] | `vera/buy_3.ogg` | That charm bites a little, mostly in a good way. If it doesn't work, I'll gladly sell you another. | The player just bought something. |
| 40 | [ ] | `vera/buy_4.ogg` | Pleasure doing business, sugar. For me, a pleasure. For you, an educational experience. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city2_arrive/city2_arrive_3.ogg` | Welcome to the circus, sugar. The clowns are sad, the lions are tired, and only the elephant leaves with dignity. | Cutscene: city2 arrive |
| 42 | [ ] | `_cutscenes/intro_cast/intro_cast_1.ogg` | I'm Vera. I deal the cards and sell the charms. Bring me something shiny and I'll bend the odds your way, and no, I won't tell you what they're bending against. | Cutscene: intro cast |
| 43 | [ ] | `_cutscenes/true_ending/true_ending_6.ogg` | Whatever you were before the tables, Eddie, that's what's left, and it's enough. Also, you freed me, so the hat is half off. | Cutscene: true ending |
| 44 | [ ] | `vera/vera_intro_1.ogg` | Fresh Marker, still wet, I see. I'm Vera Vex, and I deal charms now instead of cards, because the cards got complicated and one of them left. | Conversation: vera_intro |
| 45 | [ ] | `vera/vera_intro_2.ogg` | Charms bend the odds on every floor, and you can win them on slots, crack them out of safes, take them off bosses, or just buy them at my table like a civilized person. | Conversation: vera_intro |
| 46 | [ ] | `vera/vera_intro_4.ogg` | Up here I sell licenses, so pay me from your wallet and I'll start slipping the good charms into the casinos for you, for a fee, because everything in here is a fee. | Conversation: vera_intro |
| 47 | [ ] | `vera/vera_bust_1.ogg` | You came back, and honestly everyone comes back, which is the problem with this place and also, unfortunately, the entire business model. | Conversation: vera_bust |
| 48 | [ ] | `vera/vera_stack_1.ogg` | Five charms and you're still breathing, so here's the trick: pick one vice and feed it like a stray. | Conversation: vera_stack |
| 49 | [ ] | `vera/vera_stack_2.ogg` | Greed charms multiply each other and risk charms love a long ride, so stack the same vice and watch the numbers go stupid, which, frankly, suits you. | Conversation: vera_stack |
| 50 | [ ] | `vera/vera_jackpot_1.ogg` | Triple sevens! The House hates that sound, so do it again, because I want to hear it cry. | Conversation: vera_jackpot |
| 51 | [ ] | `vera/vera_sal_1.ogg` | You beat your first boss, and he'll be back on his feet by tomorrow, because nobody stays beaten in this place, least of all the bad guys, and especially not you. | Conversation: vera_sal |
| 52 | [ ] | `vera/vera_queen_hint_1.ogg` | Ever wonder why I stopped dealing? My deck is one card short, the Queen of Spades. | Conversation: vera_queen_hint |
| 53 | [ ] | `vera/vera_queen_hint_2.ogg` | She's my Marker, and I lost her to The House a long time ago, so if you see her up there, bring her home, because she's lovely, if a little pointy. | Conversation: vera_queen_hint |
| 54 | [ ] | `vera/vera_queen_found_1.ogg` | ...That's her. That's my Queen. | Conversation: vera_queen_found |
| 55 | [ ] | `vera/vera_queen_found_2.ogg` | Twenty years I've owed The House this card, and you found it folded inside a losing ticket, because of course you did. | Conversation: vera_queen_found |
| 56 | [ ] | `vera/vera_queen_found_3.ogg` | You just paid off my Marker, Rico, which means I'm free to walk out that door. | Conversation: vera_queen_found |
| 57 | [ ] | `vera/vera_queen_found_4.ogg` | I'm staying, though, because somebody has to keep you lucky, and licenses are 25% off for you forever, which, from me, is basically a love letter. | Conversation: vera_queen_found |
| 58 | [ ] | `vera/vera_ending_1.ogg` | You got James out, and do you know how many runners I've watched try that and fail? | Conversation: vera_ending |
| 59 | [ ] | `vera/vera_ending_2.ogg` | None of them knew when to cash out, but you did, mostly, twice, in a row, and I'd call that a miracle if I didn't know how you play. | Conversation: vera_ending |
| 60 | [ ] | `vera/vera_eddie_1.ogg` | Eddie Duval. You've been reading his tickets, haven't you? | Conversation: vera_eddie |
| 61 | [ ] | `vera/vera_eddie_2.ogg` | He was the best player I ever dealt to, and he never walked away from a table, not once, not even when it was on fire. | Conversation: vera_eddie |
| 62 | [ ] | `vera/vera_eddie_3.ogg` | Now he IS the table, and that voice on the PA is what's left of Eddie, which, to be fair, is mostly interest. | Conversation: vera_eddie |
| 63 | [ ] | `vera/vera_rep1_1.ogg` | Charms don't make you lucky, they just make you less unlucky, which is a very small difference and also my entire business. | Conversation: vera_rep1 |
| 64 | [ ] | `vera/vera_rep2_1.ogg` | The House always wins eventually, so your job is to leave before eventually, and mine is to sell you the ticket out. | Conversation: vera_rep2 |
| 65 | [ ] | `vera/vera_rep3_1.ogg` | Everything's for sale, sugar, and that includes advice, especially advice, because advice is the high-margin item. | Conversation: vera_rep3 |

### MAGS: 57 lines

Folder: `voice/mags/` (cutscene lines go in the folder shown). Voice: Sweet as pie, then drop the floor out of your voice..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `mags/greet_1.ogg` | Rico, sweetheart, my favorite investment! You look terrible, which is wonderful news for my interest rate. | Greeting the player. In character. |
| 2 | [ ] | `mags/greet_2.ogg` | I was just counting your debt, kid. It's gotten so big, and I swear it has your eyes. I'm keeping it as a pet. | Greeting the player. In character. |
| 3 | [ ] | `mags/greet_3.ogg` | Sit, sit. Standing's fine too, for now. I'm lenient on the first visit, and I only bite on the second. By bite, I mean charge. | Greeting the player. In character. |
| 4 | [ ] | `mags/greet_4.ogg` | Kid, you're on time! I love that. Late is where the bodies are buried, and I don't want to dig again. | Greeting the player. In character. |
| 5 | [ ] | `mags/farewell_1.ogg` | Don't make me swim after you, Rico. I just did my hair. I'll do it, sweetie, but I'll be cross. | Parting words as the player leaves. |
| 6 | [ ] | `mags/farewell_2.ogg` | Pay me, sweetie, or I'll collect. I say it with so much love. And a little with teeth. | Parting words as the player leaves. |
| 7 | [ ] | `mags/farewell_3.ogg` | Be careful out there, kid. It would be such a waste. Of my time, I mean. Mostly my time. | Parting words as the player leaves. |
| 8 | [ ] | `mags/farewell_4.ogg` | Go on, sweetie. Buttons and I will wait up. He's practicing his growl for when you're late. | Parting words as the player leaves. |
| 9 | [ ] | `mags/rich_1.ogg` | Look at all that money, Rico. It looks so lonely. Let me adopt it. I have room and a very large tank. | The player is carrying a lot of money. |
| 10 | [ ] | `mags/rich_2.ogg` | You could pay me early, sweetie. Nobody ever has. I'd faint, and then I'd get suspicious. | The player is carrying a lot of money. |
| 11 | [ ] | `mags/rich_3.ogg` | Money, my favorite snack! Hold it for me, Rico. Just near my mouth. | The player is carrying a lot of money. |
| 12 | [ ] | `mags/rich_4.ogg` | A big pot, sweetheart, so I'd love to borrow a little. The way a shark borrows a swimmer. | The player is carrying a lot of money. |
| 13 | [ ] | `mags/broke_1.ogg` | Broke, sweetie? I'll float you a loan. A shark does take care of its fish, right up until dinner. | The player is nearly broke. |
| 14 | [ ] | `mags/broke_2.ogg` | Empty pockets and so much potential, kid. All of it mine. | The player is nearly broke. |
| 15 | [ ] | `mags/broke_3.ogg` | I never judge, Rico. I only remember every missed payment. Buttons remembers too, and he's been looking at your ankles. | The player is nearly broke. |
| 16 | [ ] | `mags/broke_4.ogg` | Broke is just a loan that hasn't happened yet, sweetheart. Come here. I'll make it happen. | The player is nearly broke. |
| 17 | [ ] | `mags/ugly_1.ogg` | That outfit is a loan officer's nightmare, Rico. I want it framed, for the days I need to feel better about my life. | The player is wearing ugly clothes. |
| 18 | [ ] | `mags/ugly_2.ogg` | Sweetie, I'd lend you a better suit, but you'd never give it back, and I'd have to collect it off you. | The player is wearing ugly clothes. |
| 19 | [ ] | `mags/ugly_3.ogg` | Is that a fanny pack, Rico? I'm calling your mother. Then I'm introducing her to the debt. | The player is wearing ugly clothes. |
| 20 | [ ] | `mags/ugly_4.ogg` | I've collected from better-dressed corpses, kid. And they paid faster. | The player is wearing ugly clothes. |
| 21 | [ ] | `mags/sharp_1.ogg` | Nice suit, kid. Looks expensive, and I know exactly whose money that is. It's mine. It looks better on you. | The player is dressed sharp. |
| 22 | [ ] | `mags/sharp_2.ogg` | Dressed to impress, sweetheart. I'm impressed. Now pay up, and I'll let you keep the cufflinks. | The player is dressed sharp. |
| 23 | [ ] | `mags/sharp_3.ogg` | That's a lot of my money on your back, Rico. I'll take a cut. Starting with the shoulders. | The player is dressed sharp. |
| 24 | [ ] | `mags/sharp_4.ogg` | Now you look like a lender, kid. Careful. I eat my competition. | The player is dressed sharp. |
| 25 | [ ] | `mags/died_1.ogg` | You died, sweetie, so I'm adding it to your interest. Death is a surcharge. Think of it as a little gift to me. | The player just died. |
| 26 | [ ] | `mags/died_2.ogg` | No refunds in the afterlife, Rico. I'd know. I've got a branch there, with a lovely view, staffed by your debt. | The player just died. |
| 27 | [ ] | `mags/died_3.ogg` | Dead men don't pay, kid, but they do borrow. It's one of my best markets. | The player just died. |
| 28 | [ ] | `mags/died_4.ogg` | Death is just a very late payment, sweetheart. Either way, you end up with me, and I'll be waiting with a pen. | The player just died. |
| 29 | [ ] | `mags/boss_1.ogg` | A boss, defeated? Wonderful. His debts are mine now, and so is his dog. I don't want the dog. Bring it anyway. | The player just beat a boss. |
| 30 | [ ] | `mags/boss_2.ogg` | Take your spoils, Rico, and I'll take my share. The law has a different word for it, but the law is just jealous. | The player just beat a boss. |
| 31 | [ ] | `mags/boss_3.ogg` | Winning's expensive, sweetheart. Let me carry it for you. In my teeth. | The player just beat a boss. |
| 32 | [ ] | `mags/boss_4.ogg` | You beat the boss, kid. Now beat the interest. Good luck. Nobody has, and I invented it. | The player just beat a boss. |
| 33 | [ ] | `mags/idle_1.ogg` | Don't think of it as debt, sweetie. Think of it as a relationship. A deep one, with teeth. | Idle chatter. Random. |
| 34 | [ ] | `mags/idle_2.ogg` | I like you, Rico, and that's the problem. I like everything I eat. | Idle chatter. Random. |
| 35 | [ ] | `mags/idle_3.ogg` | Everybody owes somebody, kid. I just own the paperwork, the walls, the floor, and a bit of your left kidney. | Idle chatter. Random. |
| 36 | [ ] | `mags/idle_4.ogg` | I swim every day, sweetheart. Just in case you ever run. | Idle chatter. Random. |
| 37 | [ ] | `mags/buy_1.ogg` | Sign here, and here, and here. Don't read it, kid. Nobody reads it, and I find that so romantic. | The player just bought something. |
| 38 | [ ] | `mags/buy_2.ogg` | A pleasure, Rico. I'll bill you later. Wait, I already did. I love having you as a customer. | The player just bought something. |
| 39 | [ ] | `mags/buy_3.ogg` | Smart, kid. Debt is just future money you spent early. Think of it as time travel with teeth. | The player just bought something. |
| 40 | [ ] | `mags/buy_4.ogg` | No refunds, sweetheart. But I do accept regrets as payment, and you have such a lovely collection. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city4_arrive/city4_arrive_3.ogg` | Rico, sweetie, I'm still waiting at the top with a calculator. I've added interest to the interest. | Cutscene: city4 arrive |
| 42 | [ ] | `_cutscenes/intro/intro_3.ogg` | Nobody climbs without a Marker, kid. Sign here, and here, and there. Don't read it, sweetie. Don't think of it as debt. Think of it as a very close relationship that I own. | Cutscene: intro |
| 43 | [ ] | `_cutscenes/mags_chase/mags_chase_1.ogg` | Payday, kid. You're late, and I hate late. Late is when your debt gets a growth spurt, and I'm so proud of how big it's getting. | Cutscene: mags chase |
| 44 | [ ] | `_cutscenes/mags_chase/mags_chase_3.ogg` | We ARE talking, sweetie. This is me talking. The swimming is me collecting. Cash out and pay me, or keep running, because I love watching my little investment run. | Cutscene: mags chase |
| 45 | [ ] | `mags/mags_intro_1.ogg` | Hi, sweetheart, I'm Mags, and I hold the Markers at the door, and yours says The House owns your bones until you settle up, which I think is adorable. | Conversation: mags_intro |
| 46 | [ ] | `mags/mags_intro_2.ogg` | Short on chips? I lend! Two hundred now, three hundred back by the end of floor three, and honestly that's less a loan than a friendship with numbers. | Conversation: mags_intro |
| 47 | [ ] | `mags/mags_intro_3.ogg` | You pay me when you cash out, and if you miss the date, I come collecting, personally, through walls, with a little bow on it. | Conversation: mags_intro |
| 48 | [ ] | `mags/mags_intro_5.ogg` | And you're a runner with no money, and we all have our problems, but mine is wrapped around your wrist, and I love it so much. | Conversation: mags_intro |
| 49 | [ ] | `mags/mags_repaid_1.ogg` | You paid me back on time, sweetie, and I'm so proud, because you'd be amazed how few people do, and how many of them are in my aquarium. | Conversation: mags_repaid |
| 50 | [ ] | `mags/mags_default_1.ogg` | About that missed payment, honey, it's nothing personal, because interest isn't personal, it's just math with teeth, and tonight I brought the teeth. | Conversation: mags_default |
| 51 | [ ] | `mags/mags_big_loss_1.ogg` | I saw you drop a thousand chips at the door, darling, and if you'd banked those instead, you'd have had a little money, and I'd have had a very different smile. | Conversation: mags_big_loss |
| 52 | [ ] | `mags/mags_rates_1.ogg` | Just between us, The House charges interest on every single bust, compounding, forever, and I mean that with love. | Conversation: mags_rates |
| 53 | [ ] | `mags/mags_rates_2.ogg` | Even I think that's a little ugly, and I'm a loan shark, literally, it says so right on the jacket. | Conversation: mags_rates |
| 54 | [ ] | `mags/mags_ending_1.ogg` | You beat The House and it's still standing, and that's interest for you, kid, it keeps everything alive, like a bad marriage. | Conversation: mags_ending |
| 55 | [ ] | `mags/mags_rep1_1.ogg` | My advice is to borrow smart and ride dumb, and I'm kidding, please don't do that, and I'm also kidding about kidding, so pay up. | Conversation: mags_rep1 |
| 56 | [ ] | `mags/mags_rep2_1.ogg` | My rates are totally fair, sweetheart, it's The House's rates that are a crime, and I would know, because I'm a connoisseur. | Conversation: mags_rep2 |
| 57 | [ ] | `mags/mags_rep3_1.ogg` | A shark has to keep swimming, dear, and so do you, and yes, that was a threat, but it's also very good life advice. | Conversation: mags_rep3 |

### LUCKY: 47 lines

Folder: `voice/lucky/` (cutscene lines go in the folder shown). Voice: Pretend you are polishing a glass the entire time..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `lucky/greet_1.ogg` | Sit anywhere but the stool by the door, runner. The pool says you die there, and I've got money on it. | Greeting the player. In character. |
| 2 | [ ] | `lucky/greet_2.ogg` | The usual? Take your time ordering. I've got ten bucks on you dying mid-sentence, and I want to enjoy it. | Greeting the player. In character. |
| 3 | [ ] | `lucky/greet_3.ogg` | Welcome to Lucky's. We don't water the drinks much, and the pool on how you die is up to six hundred. | Greeting the player. In character. |
| 4 | [ ] | `lucky/greet_4.ogg` | You're breathing! I had you at even money not to. I lost, and I've never been happier. Don't tell the pool. | Greeting the player. In character. |
| 5 | [ ] | `lucky/farewell_1.ogg` | Drink responsibly, runner. Or at least drink first. I'll keep a stool warm and the pool open on how you leave. | Parting words as the player leaves. |
| 6 | [ ] | `lucky/farewell_2.ogg` | Come back in one piece. Or two, I'm not picky. I have a mop, and I have money on which. | Parting words as the player leaves. |
| 7 | [ ] | `lucky/farewell_3.ogg` | Break a leg out there, runner. I've got twenty on left leg, first floor. No pressure. | Parting words as the player leaves. |
| 8 | [ ] | `lucky/farewell_4.ogg` | I'll keep your tab open. It's the only thing here that never closes. The pool closes at midnight. | Parting words as the player leaves. |
| 9 | [ ] | `lucky/rich_1.ogg` | First round's on me, second's on you, third's on your fortune. The pool says you'll lose it all by dinner. | The player is carrying a lot of money. |
| 10 | [ ] | `lucky/rich_2.ogg` | That's a lot of green, runner. I've got a Scotch that'll make you cry, and six guys in the pool who'll cry harder if you keep it. | The player is carrying a lot of money. |
| 11 | [ ] | `lucky/rich_3.ogg` | Cash like that needs a toast and an alibi. I'll do the toast. The guys in the pool sell alibis. | The player is carrying a lot of money. |
| 12 | [ ] | `lucky/rich_4.ogg` | You're buying, aren't you? I'm already pouring. I've moved the pool to 'dies drunk and rich,' and it's a crowd favorite. | The player is carrying a lot of money. |
| 13 | [ ] | `lucky/broke_1.ogg` | Tab's on me tonight, runner. Don't make it a habit, make it a hobby. The pool's offering you ten percent if you die before closing. | The player is nearly broke. |
| 14 | [ ] | `lucky/broke_2.ogg` | I'll pour you water, runner. It's all I've got that's free, and I'm not totally sure it's honest. | The player is nearly broke. |
| 15 | [ ] | `lucky/broke_3.ogg` | Broke? Join the club. Dues are one drink per sorrow, and you owe me nine years. | The player is nearly broke. |
| 16 | [ ] | `lucky/broke_4.ogg` | Sit, runner, cry, hydrate. The tears are on the house. The guys in the pool are betting on how long you last without a drink. | The player is nearly broke. |
| 17 | [ ] | `lucky/ugly_1.ogg` | That outfit's strong, runner, like my worst whiskey. You smell about the same. I've got a pool on which one knocks someone out first. | The player is wearing ugly clothes. |
| 18 | [ ] | `lucky/ugly_2.ogg` | I've seen better coats in the lost and found. They were on fire, and still more flattering. | The player is wearing ugly clothes. |
| 19 | [ ] | `lucky/ugly_3.ogg` | Not my business what you wear, runner. But I've added 'death by fashion' to the pool, and it's paying well. | The player is wearing ugly clothes. |
| 20 | [ ] | `lucky/ugly_4.ogg` | Have a drink, runner. It blurs everything, and I'd like that for both of us. | The player is wearing ugly clothes. |
| 21 | [ ] | `lucky/sharp_1.ogg` | Look at you, runner. All class, no chaser. Wait, I have chasers. Good. The pool now has 'best dressed corpse,' and you're the front-runner. | The player is dressed sharp. |
| 22 | [ ] | `lucky/sharp_2.ogg` | Dressed to kill, or at least to be killed in. I've got forty bucks on the second one. | The player is dressed sharp. |
| 23 | [ ] | `lucky/sharp_3.ogg` | That suit deserves a good Scotch. You get the cheap one. Fair's fair. | The player is dressed sharp. |
| 24 | [ ] | `lucky/sharp_4.ogg` | You almost look like you belong here, runner. One drink fixes that. Two makes the pool very interesting. | The player is dressed sharp. |
| 25 | [ ] | `lucky/died_1.ogg` | Welcome back, runner. I had you dying on the stairs, so thank you. Drinks are on the guy who bet 'spikes.' He's very upset. | The player just died. |
| 26 | [ ] | `lucky/died_2.ogg` | Rough one, runner. I had you picked for the elevator, so now I owe a man in a hat forty bucks. He's smug about it. Take that personally. | The player just died. |
| 27 | [ ] | `lucky/died_3.ogg` | You died, runner, so have a drink. It won't help, but it gives your hands something to do. The pool just paid out, so it's on me. | The player just died. |
| 28 | [ ] | `lucky/died_4.ogg` | That's death number forty-three, runner. I had 'ugly and sudden,' so I'm buying a round for myself. | The player just died. |
| 29 | [ ] | `lucky/boss_1.ogg` | You beat a boss, runner? Round's on me. I had you dying to him, and now I owe the whole bar. | The player just beat a boss. |
| 30 | [ ] | `lucky/boss_2.ogg` | Cheers to the one that fell. May he rest, and may his tab be forgiven. It won't be. | The player just beat a boss. |
| 31 | [ ] | `lucky/boss_3.ogg` | That boss drank here, runner. Tipped badly, died worse. I'd say rest in peace, but he owes me for eleven Scotches. | The player just beat a boss. |
| 32 | [ ] | `lucky/boss_4.ogg` | A toast to the one who didn't die tonight, runner. Tonight being relative. I've already got money on tomorrow. | The player just beat a boss. |
| 33 | [ ] | `lucky/idle_1.ogg` | I've got a bar on every floor, runner. It's convenient. You die, I'm already there to collect. | Idle chatter. Random. |
| 34 | [ ] | `lucky/idle_2.ogg` | The pool on how many times you die before the Bellagiro is at fifty-three. The guy who bet sixty is crying. | Idle chatter. Random. |
| 35 | [ ] | `lucky/idle_3.ogg` | A drink never lies, runner. Only the drinker does. And the bartender, but don't ask him, he's me. | Idle chatter. Random. |
| 36 | [ ] | `lucky/idle_4.ogg` | My whole job is wiping a glass and listening, runner. Mostly I listen for the thud. It's how I settle the pool. | Idle chatter. Random. |
| 37 | [ ] | `lucky/buy_1.ogg` | Bottoms up, runner. Gently, like a bad idea. I've got a bet on how long you keep it down, and the odds are not in your favor. | The player just bought something. |
| 38 | [ ] | `lucky/buy_2.ogg` | That one has a kick, runner. I've got ten bucks on whether you stay standing after it. | The player just bought something. |
| 39 | [ ] | `lucky/buy_3.ogg` | Careful, runner, don't spill it. I'll bet you ten bucks you do. Actually, make it twenty. I know you. | The player just bought something. |
| 40 | [ ] | `lucky/buy_4.ogg` | On the house, runner. Not THE House, that one never pays. The pool covers it. The pool loves you. | The player just bought something. |
| 41 | [ ] | `_cutscenes/intro_cast/intro_cast_2.ogg` | Name's Lucky. I run a bar on most floors, and a drink can save your life, runner. I also run a betting pool on how you die, so please, order the second one. | Cutscene: intro cast |
| 42 | [ ] | `lucky/lucky_intro_1.ogg` | Lucky's the name. On the floors I pour drinks, and up here I mostly take bets, mainly on how soon you'll be back, so thanks in advance for the business. | Conversation: lucky_intro |
| 43 | [ ] | `lucky/lucky_intro_2.ogg` | Everybody busts eventually, and bartenders hear all about it, and I've got a whole pool going on your next death, and honestly the odds are excellent. | Conversation: lucky_intro |
| 44 | [ ] | `lucky/lucky_tip_1.ogg` | Pro tip: a Shot of Courage costs less than the interest on a bust, so find my bar on the floors, and yes, I have a lot of bars, and no, I won't explain how. | Conversation: lucky_tip |
| 45 | [ ] | `lucky/lucky_cat_1.ogg` | Keep petting Comp like that and he'll follow you up the floors, except he won't, because he's a cat, but he does like you, which is creepy, and I've got money on it ending badly. | Conversation: lucky_cat |
| 46 | [ ] | `lucky/lucky_rep1_1.ogg` | On the house? Nothing's on the house, pal, that's The House's whole thing, it's right there in the name. | Conversation: lucky_rep1 |
| 47 | [ ] | `lucky/lucky_rep2_1.ogg` | You've got the look of somebody about to let it ride, so tell me when, and I'll film it for the pool. | Conversation: lucky_rep2 |

### JAMES: 48 lines

Folder: `voice/james/` (cutscene lines go in the folder shown). Voice: Whisper like you have not slept since Tuesday..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `james/greet_1.ogg` | Rico! Great timing, I'm up. Give me one more hand and we'll catch up. Don't sit down, they recruit. | Greeting the player. In character. |
| 2 | [ ] | `james/greet_2.ogg` | I knew you'd come, Rico. I had money on never, but I'm winning, so no hard feelings. | Greeting the player. In character. |
| 3 | [ ] | `james/greet_3.ogg` | Oh, it's you. I thought you were the dealer. Same energy, though. One more hand, then we hug. | Greeting the player. In character. |
| 4 | [ ] | `james/greet_4.ogg` | What day is it, Rico? Is there a day? Anyway, I'd love to catch up, right after this hand. | Greeting the player. In character. |
| 5 | [ ] | `james/farewell_1.ogg` | Don't wait for me, Rico. I'm busy being a legend. I'll be out after one more hand. Probably two. | Parting words as the player leaves. |
| 6 | [ ] | `james/farewell_2.ogg` | Tell Mom I'm doing great. She'll ask for her money back. Tell her I'm doing great about that too. | Parting words as the player leaves. |
| 7 | [ ] | `james/farewell_3.ogg` | Take the chips, leave the cards. And the chair. I'm very attached to the chair. | Parting words as the player leaves. |
| 8 | [ ] | `james/farewell_4.ogg` | Come back anytime, Rico. I'll be here. I'm always here. That's not a problem, that's a schedule. | Parting words as the player leaves. |
| 9 | [ ] | `james/rich_1.ogg` | That's a lot of chips, Rico. Don't trust them. They're sparkly liars. Mine love me, though. | The player is carrying a lot of money. |
| 10 | [ ] | `james/rich_2.ogg` | I had that much once, for ten minutes. Best ten minutes of my life. I've been chasing them for three years. | The player is carrying a lot of money. |
| 11 | [ ] | `james/rich_3.ogg` | Bank it, Rico? Sure, bank it. Or spend it at my table. We have a very nice table. | The player is carrying a lot of money. |
| 12 | [ ] | `james/rich_4.ogg` | Being rich didn't help me, Rico. It just changed how I lost. Now I lose in a nicer chair. | The player is carrying a lot of money. |
| 13 | [ ] | `james/broke_1.ogg` | Broke, Rico? Welcome. It's cozy. The rent's nothing, and the walls are close enough to hug. | The player is nearly broke. |
| 14 | [ ] | `james/broke_2.ogg` | I've been broke three years, Rico. It's great. You find a lot of hobbies. Mine is staying right here. | The player is nearly broke. |
| 15 | [ ] | `james/broke_3.ogg` | It's just money, Rico. It was never ours, it's the House's. I'm only borrowing my own future, and they're very flexible about it. | The player is nearly broke. |
| 16 | [ ] | `james/broke_4.ogg` | Broke together, Rico. That's called family. Or a pyramid scheme. Want in? I get a commission. | The player is nearly broke. |
| 17 | [ ] | `james/ugly_1.ogg` | Nice outfit, Rico. I love it. I'm lying. I'm in a good mood, so it's a happy lie. | The player is wearing ugly clothes. |
| 18 | [ ] | `james/ugly_2.ogg` | I'd say something, Rico, but you're my brother. So I'll just say it quietly, with my eyes. | The player is wearing ugly clothes. |
| 19 | [ ] | `james/ugly_3.ogg` | You look like me after three years at the table. Is that a stain? Oh, that one's mine. Keep it. | The player is wearing ugly clothes. |
| 20 | [ ] | `james/ugly_4.ogg` | Mom would cry, then laugh, then ask where you got it, then cry again. It's her whole routine for me. | The player is wearing ugly clothes. |
| 21 | [ ] | `james/sharp_1.ogg` | You look great, Rico. Who died? If it's me, nobody told me, and I'm right here. | The player is dressed sharp. |
| 22 | [ ] | `james/sharp_2.ogg` | Dad would be proud, Rico. Then he'd ask where you stole it. Then he'd borrow it. | The player is dressed sharp. |
| 23 | [ ] | `james/sharp_3.ogg` | I used to dress like that, Rico. Now I wear the House's vest. It has a name tag. I love the name tag. | The player is dressed sharp. |
| 24 | [ ] | `james/sharp_4.ogg` | Did you buy that with my debts? It's got my fingerprints on it. Fine, keep it. Looks better on you. | The player is dressed sharp. |
| 25 | [ ] | `james/died_1.ogg` | You died? Welcome to my life, Rico. It's less dead than you'd think, but more paperwork. | The player just died. |
| 26 | [ ] | `james/died_2.ogg` | It stops hurting after the first twenty, Rico. Then it's just paperwork. I do a lot of paperwork here. I love it. | The player just died. |
| 27 | [ ] | `james/died_3.ogg` | I've died at this table a hundred times, Rico. You get used to it. The lighting's flattering. | The player just died. |
| 28 | [ ] | `james/died_4.ogg` | Get up, Rico. It's just a body. Mine's been on layaway for years, and I'm fine. | The player just died. |
| 29 | [ ] | `james/boss_1.ogg` | I never got past the third boss, Rico. Then I found the table, and honestly, I stopped needing to. | The player just beat a boss. |
| 30 | [ ] | `james/boss_2.ogg` | I heard the table go quiet. That was you, or the building collapsing. Either way, I'm still seated. | The player just beat a boss. |
| 31 | [ ] | `james/boss_3.ogg` | The House notices everything, Rico. It noticed me twice, and now I have a name tag and a very small pension. | The player just beat a boss. |
| 32 | [ ] | `james/boss_4.ogg` | I'm proud of you, Rico. And scared. And jealous. Mostly jealous. Please lose a little, for me. | The player just beat a boss. |
| 33 | [ ] | `james/idle_1.ogg` | The cards remember everything, Rico. Especially the bad hands. We're very close. | Idle chatter. Random. |
| 34 | [ ] | `james/idle_2.ogg` | You hear that wheel, Rico? It never stops. It also never says sorry. I find that very honest. | Idle chatter. Random. |
| 35 | [ ] | `james/idle_3.ogg` | I counted every floor, Rico. There's more. It's a growing business, and I'm basically a founding member. | Idle chatter. Random. |
| 36 | [ ] | `james/idle_4.ogg` | Be careful with the House, Rico. It's not a person. It's a vibe with lawyers. A vibe I work for. | Idle chatter. Random. |
| 37 | [ ] | `james/buy_1.ogg` | Good pick, Rico. I'd have picked it too. I lost anyway, but with style. | The player just bought something. |
| 38 | [ ] | `james/buy_2.ogg` | Don't buy it, Rico. ... You bought it. That's exactly how I got my table. | The player just bought something. |
| 39 | [ ] | `james/buy_3.ogg` | It might work. Mine didn't. But I'm an optimist, which is just a gambler who's still sitting down. | The player just bought something. |
| 40 | [ ] | `james/buy_4.ogg` | At least you're trying, Rico. That's what everyone said at my intervention. Great snacks, though. | The player just bought something. |
| 41 | [ ] | `_cutscenes/ending/ending_2.ogg` | Rico? You climbed five casinos for me? That's so sweet, but I'm up eleven grand and I'm on a RUN, so can you wait like ten minutes? | Cutscene: ending |
| 42 | [ ] | `_cutscenes/ending/ending_6.ogg` | ...Okay. Okay. One last chip, and I'm cashing out. It feels like falling, but the good kind, where someone catches you. | Cutscene: ending |
| 43 | [ ] | `james/james_home_1.ogg` | Rico, I keep waking up in the apartment out of habit, and The House still thinks I owe it money, which, to be fair, I do. | Conversation: james_home |
| 44 | [ ] | `james/james_home_2.ogg` | Thanks for coming for me, and now let me come with you, so pick me on the title screen, because I hit harder than you, and I also steal. | Conversation: james_home |
| 45 | [ ] | `james/james_eddie_1.ogg` | Those losing tickets are Eddie Duval's trail, and I dealt to that voice every night for three years. | Conversation: james_eddie |
| 46 | [ ] | `james/james_eddie_2.ogg` | He doesn't want our money, he wants somebody to finally beat him so he can stop, which is the saddest ten-second pitch I've ever heard. | Conversation: james_eddie |
| 47 | [ ] | `james/james_rep1_1.ogg` | Bank it, Rico, because I didn't, and look where it got me: a very comfortable cell with a view. | Conversation: james_rep1 |
| 48 | [ ] | `james/james_rep2_1.ogg` | The House cheats, so we cheat better, and in our family that's what we call values. | Conversation: james_rep2 |

### COMP: 17 lines

Folder: `voice/comp/` (cutscene lines go in the folder shown). Voice: Meow in different moods. Smug, hungry, offended..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `comp/idle_1.ogg` | Mrrrow. (Translation: I have been sitting on this chip for four hours and I'm still not sure it's mine.) | Idle chatter. Random. |
| 2 | [ ] | `comp/idle_2.ogg` | Mrrp? Mrrp. (Translation: the dealer keeps looking at me and I keep looking at the dealer. We both know what this is.) | Idle chatter. Random. |
| 3 | [ ] | `comp/idle_3.ogg` | Hssss. (Translation: not you, Rico, the slot machine. It has been staring at me since Tuesday.) | Idle chatter. Random. |
| 4 | [ ] | `comp/idle_4.ogg` | Prrrr. (Translation: I would help with the debt, but I'm a cat, and my entire skill set is falling off tables.) | Idle chatter. Random. |
| 5 | [ ] | `comp/idle_5.ogg` | Mrow-mrow. (Translation: I could be a high roller, but learning the odds feels like homework.) | Idle chatter. Random. |
| 6 | [ ] | `comp/idle_6.ogg` | Meeeow. (Translation: pet me, but make it a business transaction. I charge in tuna.) | Idle chatter. Random. |
| 7 | [ ] | `comp/greet_1.ogg` | Mrrow! (Translation: you're here, which means food, or at least a lap. I'm flexible.) | Greeting the player. In character. |
| 8 | [ ] | `comp/greet_2.ogg` | Prrrp? (Translation: did you bring the fish, or are we doing the thing where you just apologize?) | Greeting the player. In character. |
| 9 | [ ] | `comp/greet_3.ogg` | Mew. (Translation: Rico, you look terrible. I say that with love, and also hunger.) | Greeting the player. In character. |
| 10 | [ ] | `comp/farewell_1.ogg` | Mrrrrow. (Translation: goodbye. If you see James, tell him I'm keeping his side of the bed warm and also ruining it.) | Parting words as the player leaves. |
| 11 | [ ] | `comp/farewell_2.ogg` | Meeeeow. (Translation: leave, then. I'll be here knocking things off tables. It's my whole identity.) | Parting words as the player leaves. |
| 12 | [ ] | `comp/rich_1.ogg` | Prrrrr. (Translation: you smell like money, which smells like tuna, so I'm in love with you.) | The player is carrying a lot of money. |
| 13 | [ ] | `comp/rich_2.ogg` | Mrow! (Translation: you're rich now, so I'll need a bigger bowl and a lawyer.) | The player is carrying a lot of money. |
| 14 | [ ] | `comp/broke_1.ogg` | Hss. (Translation: broke again? I can smell it, Rico. Sadness smells like an empty wallet and wet cardboard.) | The player is nearly broke. |
| 15 | [ ] | `comp/broke_2.ogg` | Mew. (Translation: there, there. I'll sit on your head. It's what I do for crying people.) | The player is nearly broke. |
| 16 | [ ] | `comp/died_1.ogg` | Mrrrrrow. (Translation: I watched you die. I was in the room. I did nothing. It's the cat way.) | The player just died. |
| 17 | [ ] | `comp/boss_1.ogg` | Purrr. (Translation: not bad, Rico. You almost kill things like I do, and I've only ever killed a sock.) | The player just beat a boss. |

### SILAS STITCH: 41 lines

Folder: `voice/tailor/` (cutscene lines go in the folder shown). Voice: Sniff at the player's outfit before each line..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `tailor/greet_1.ogg` | Do come in, but mind the mannequins. They bite when ignored, and you look like someone who ignores things, including mirrors. | Greeting the player. In character. |
| 2 | [ ] | `tailor/greet_2.ogg` | Ah, a customer, or a stray. Hold still while I find out which, and don't breathe on the silk. It's older than your last three decisions combined. | Greeting the player. In character. |
| 3 | [ ] | `tailor/greet_3.ogg` | Silas Stitch, at your service. Good heavens, there's a lot of waistline here. We'll need the long tape, and possibly a second tailor. | Greeting the player. In character. |
| 4 | [ ] | `tailor/greet_4.ogg` | Welcome, welcome. Do sit down before you offend the mannequins. They have strong opinions about what you've chosen to wear. | Greeting the player. In character. |
| 5 | [ ] | `tailor/farewell_1.ogg` | Wear it well, Rico. Or at least wear it. And whatever happens, never put it in a fanny pack. | Parting words as the player leaves. |
| 6 | [ ] | `tailor/farewell_2.ogg` | Mind the hem on the way out, and the door, and your life choices. Only one of those can be fixed by a tailor. | Parting words as the player leaves. |
| 7 | [ ] | `tailor/farewell_3.ogg` | Do try not to bleed on the silk, or the wool, or me. I have only one handkerchief and it's a rental. | Parting words as the player leaves. |
| 8 | [ ] | `tailor/farewell_4.ogg` | Come back for a fitting and a lecture. It's forty minutes long, it starts with your shoes, and it ends with your mother. | Parting words as the player leaves. |
| 9 | [ ] | `tailor/rich_1.ogg` | A gentleman with means! Now we can begin the long, lovely lie that you have taste, starting with a very expensive belt. | The player is carrying a lot of money. |
| 10 | [ ] | `tailor/rich_2.ogg` | Heavy pockets mean lovely hems. I'll bill you for both, and for the emotional labor of looking at you. | The player is carrying a lot of money. |
| 11 | [ ] | `tailor/rich_3.ogg` | With that fortune we might fix your posture, though I suspect surgery is the only honest option. | The player is carrying a lot of money. |
| 12 | [ ] | `tailor/rich_4.ogg` | Money, how delightfully vulgar. Spend it on me, and I'll make you a coat so fine the House will ask for my name. | The player is carrying a lot of money. |
| 13 | [ ] | `tailor/broke_1.ogg` | No funds? Then we tailor in imagination. Imagine a very nice belt. There. That's two dollars. | The player is nearly broke. |
| 14 | [ ] | `tailor/broke_2.ogg` | I can offer a belt of regret. It's free, it itches, and it clashes with everything, including your skin. | The player is nearly broke. |
| 15 | [ ] | `tailor/broke_3.ogg` | Poverty is merely fashion in beta, darling. You've been in beta for years, and the reviews are devastating. | The player is nearly broke. |
| 16 | [ ] | `tailor/broke_4.ogg` | Come back when you can afford sleeves, my dear. Until then you're a vest, and a tragic one, but at least well ventilated. | The player is nearly broke. |
| 17 | [ ] | `tailor/ugly_1.ogg` | Dear boy, did you dress yourself in a dumpster? Don't answer. The smell already did. | The player is wearing ugly clothes. |
| 18 | [ ] | `tailor/ugly_2.ogg` | That fanny pack is a war crime. I'd gladly testify, in my best suit, the only thing here you haven't offended. | The player is wearing ugly clothes. |
| 19 | [ ] | `tailor/ugly_3.ogg` | I won't say what I think. I will faint instead. Watch. There. Now I need water and a different customer. | The player is wearing ugly clothes. |
| 20 | [ ] | `tailor/ugly_4.ogg` | You look like a rumor of an outfit, Rico, and a poorly sourced one. Even my mannequins have turned to face the wall. | The player is wearing ugly clothes. |
| 21 | [ ] | `tailor/sharp_1.ogg` | Now that is a proper silhouette, Rico. A murder suspect, but a dapper one, and I'd happily testify to the tailoring. | The player is dressed sharp. |
| 22 | [ ] | `tailor/sharp_2.ogg` | Magnificent. I'd hang it in a museum, next to the exhibit of men who died wearing it. It's a very popular wing. | The player is dressed sharp. |
| 23 | [ ] | `tailor/sharp_3.ogg` | You're a credit to the craft, Rico, and to my commission. In a rare moment of sincerity, I may even stop judging your shoes. | The player is dressed sharp. |
| 24 | [ ] | `tailor/sharp_4.ogg` | I made half that outfit. You made the other half, barely. Squint and it almost works, and I'm taking all the credit. | The player is dressed sharp. |
| 25 | [ ] | `tailor/died_1.ogg` | You died in my wares, Rico? Did it stain? I can fix a hole, but I cannot fix a blood type. | The player just died. |
| 26 | [ ] | `tailor/died_2.ogg` | A dead client is a quiet client, which I love. A bloody client is a lawsuit, and my lawyer is a mannequin. | The player just died. |
| 27 | [ ] | `tailor/died_3.ogg` | Bleed on the old stock if you must, but never the new silk. I promised that silk a better life. | The player just died. |
| 28 | [ ] | `tailor/died_4.ogg` | Hold still, I'll mend the holes. Which are bullet holes and which are style? Don't tell me. I prefer to think they're all style. | The player just died. |
| 29 | [ ] | `tailor/boss_1.ogg` | You defeated a boss, how marvelous. Then you'll need armor, fashionable armor. Is there any other kind? No. | The player just beat a boss. |
| 30 | [ ] | `tailor/boss_2.ogg` | Slaying monsters in silk, how delightful. Stains come out with lemon, wine and prayer, in that order, and the prayer is mostly for me. | The player just beat a boss. |
| 31 | [ ] | `tailor/boss_3.ogg` | Those trophies will need a tasteful frame, Rico, and perhaps a better class of enemy. One who dresses with intention. | The player just beat a boss. |
| 32 | [ ] | `tailor/boss_4.ogg` | I once made that boss a custom suit. He hated it. Now he's dead, so technically I got the last word. | The player just beat a boss. |
| 33 | [ ] | `tailor/idle_1.ogg` | Gloves for gripping, boots for smashing, scarves for gliding. Hats are for nothing. I simply like hats. | Idle chatter. Random. |
| 34 | [ ] | `tailor/idle_2.ogg` | The shoes make the man, Rico. I just wish the man would hold still for a fitting. | Idle chatter. Random. |
| 35 | [ ] | `tailor/idle_3.ogg` | Stand straight, Rico. The cloth knows. It's judging your spine, and it is extremely disappointed. | Idle chatter. Random. |
| 36 | [ ] | `tailor/idle_4.ogg` | Everything I sell grants a talent, mostly vanity, occasionally a double jump. I've never decided which is more useful in this building. | Idle chatter. Random. |
| 37 | [ ] | `tailor/buy_1.ogg` | A fine choice. I knew it would suit you. I say that to everyone and it's never true, but this time it's slightly less false. | The player just bought something. |
| 38 | [ ] | `tailor/buy_2.ogg` | Wear it with confidence, Rico, or at least with shoes. I'm still not convinced you own any. | The player just bought something. |
| 39 | [ ] | `tailor/buy_3.ogg` | I shall tell the thread you said hello. The thread has opinions about you, and none are flattering. | The player just bought something. |
| 40 | [ ] | `tailor/buy_4.ogg` | One moment while I finish. The pins are my pride, and also my weapons, and I won't discuss the second part with the authorities. | The player just bought something. |
| 41 | [ ] | `_cutscenes/city5_arrive/city5_arrive_2.ogg` | Dear boy, the cloak room is that way. I make no promises about the smell, or about your dignity. | Cutscene: city5 arrive |

### DOC FIZZ: 40 lines

Folder: `voice/fizz/` (cutscene lines go in the folder shown). Voice: Whisper-yell. Look over your shoulder after each sentence..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `fizz/greet_1.ogg` | Psst, over here. Welcome to the pharmacy, which isn't licensed. I'm legally required to tell you that, then ask you to forget it. | Greeting the player. In character. |
| 2 | [ ] | `fizz/greet_2.ogg` | Come closer. Not that close, ugh, you breathe a lot. My products may cause drowsiness, euphoria, or a brief friendship with a paramedic. | Greeting the player. In character. |
| 3 | [ ] | `fizz/greet_3.ogg` | Welcome to Doc Fizz's. Every bottle has a legal warning, and today's is: please don't ask what the other bottle is for. | Greeting the player. In character. |
| 4 | [ ] | `fizz/greet_4.ogg` | A customer! Or a cop. Are you a cop? If so, this is a bakery and these are very strong muffins. | Greeting the player. In character. |
| 5 | [ ] | `fizz/farewell_1.ogg` | Side effects begin immediately and last permanently. In rare cases you develop a French accent, which my warranty does not cover. | Parting words as the player leaves. |
| 6 | [ ] | `fizz/farewell_2.ogg` | Go on, be amazing. Statistically you'll be dead, but I'm told the amazing ones are really amazing. | Parting words as the player leaves. |
| 7 | [ ] | `fizz/farewell_3.ogg` | Keep the bottle. Do not return the bottle. It's been looking at me, and I'd rather not discuss what it said. | Parting words as the player leaves. |
| 8 | [ ] | `fizz/farewell_4.ogg` | Don't tell anyone where you got that. Especially me. Legally, I never met you. | Parting words as the player leaves. |
| 9 | [ ] | `fizz/rich_1.ogg` | You're loaded! Let me show you the good stuff, in the bag that hums. The warning on it is one I'm not allowed to read aloud. | The player is carrying a lot of money. |
| 10 | [ ] | `fizz/rich_2.ogg` | Real cash, my favorite! It tastes like a lawyer, and by law I must tell you the lawyer is also an ingredient. | The player is carrying a lot of money. |
| 11 | [ ] | `fizz/rich_3.ogg` | For you, double price and triple effect. Side effects now include, and I quote the form, a sudden urge to spend more money here. | The player is carrying a lot of money. |
| 12 | [ ] | `fizz/rich_4.ogg` | Hide that cash inside my product, it's the safest place. Warning: the product dissolves paper. | The player is carrying a lot of money. |
| 13 | [ ] | `fizz/broke_1.ogg` | No cash? I accept organs. Small ones, spares really. You have spares, right? The form specifically says spares. | The player is nearly broke. |
| 14 | [ ] | `fizz/broke_2.ogg` | Free sample! Free meaning my liability becomes your liability. By taking it, you also agree to be liable for my feelings. | The player is nearly broke. |
| 15 | [ ] | `fizz/broke_3.ogg` | I'll put it on your tab, Rico. By tab I mean I'll bill your family. You have a family, right? I just invented one. | The player is nearly broke. |
| 16 | [ ] | `fizz/broke_4.ogg` | Come back when you've been mugged by someone richer than you. At least then your wallet gets a better class of trauma. | The player is nearly broke. |
| 17 | [ ] | `fizz/ugly_1.ogg` | That outfit is a hallucination, and I haven't even sold you anything yet. Legal says that's somehow my fault. | The player is wearing ugly clothes. |
| 18 | [ ] | `fizz/ugly_2.ogg` | You look like a warning label, Rico, which I love. I write them. Mine are eight pages now. | The player is wearing ugly clothes. |
| 19 | [ ] | `fizz/ugly_3.ogg` | Don't worry about the outfit, the drugs make everything look better. A bottle once told me I'm very handsome in the right dose. | The player is wearing ugly clothes. |
| 20 | [ ] | `fizz/ugly_4.ogg` | I've seen better-fitting clothes on a cadaver, and I'm legally required to say the cadaver was not consulted. | The player is wearing ugly clothes. |
| 21 | [ ] | `fizz/sharp_1.ogg` | Fancy! That suit looks amazing until you spill something on it, and my products spill in six different colors. | The player is dressed sharp. |
| 22 | [ ] | `fizz/sharp_2.ogg` | A well-dressed mistake, my favorite customer. They pay in cash and never read the label. | The player is dressed sharp. |
| 23 | [ ] | `fizz/sharp_3.ogg` | You're too nice for this stall, Rico. Buy something. Side effects include a lowered moral baseline and a craving for shrimp. | The player is dressed sharp. |
| 24 | [ ] | `fizz/sharp_4.ogg` | Sharp! Let's ruin it with science. Side effects include stains, glowing, and a mild urge to join a cult. | The player is dressed sharp. |
| 25 | [ ] | `fizz/died_1.ogg` | You look dead, which means my product works. I have no data supporting that, other than your face. | The player just died. |
| 26 | [ ] | `fizz/died_2.ogg` | I heard the scream, and it was you. Nice lungs, by the way. That's a compliment, from a medical professional, sort of. | The player just died. |
| 27 | [ ] | `fizz/died_3.ogg` | Death isn't the problem, Rico, the respawn is. It's long, it's repetitive, and I'm told the loading screen is unbearable. | The player just died. |
| 28 | [ ] | `fizz/died_4.ogg` | Please don't die near the merchandise. The insurance covers nothing. I checked. The policy is a drawing of a duck. | The player just died. |
| 29 | [ ] | `fizz/boss_1.ogg` | You beat a boss! I need a pint of your blood for science. Okay, a gallon. I'm legally obligated to say it's not for science. | The player just beat a boss. |
| 30 | [ ] | `fizz/boss_2.ogg` | You killed someone important, so celebrate with the red bottle. It's made from the last boss's leftovers, and the label says do not. | The player just beat a boss. |
| 31 | [ ] | `fizz/boss_3.ogg` | Bosses are just customers who never paid their tab. Now I collect in trophies, and a little in organs. | The player just beat a boss. |
| 32 | [ ] | `fizz/boss_4.ogg` | Did he have a kidney? Asking for business reasons. A second business, which I'm required to deny exists. | The player just beat a boss. |
| 33 | [ ] | `fizz/idle_1.ogg` | I have a bottle that sings. Badly. Mostly it screams, and screaming is a known side effect of the bottle. | Idle chatter. Random. |
| 34 | [ ] | `fizz/idle_2.ogg` | Everything has side effects, even oxygen. Ask anyone who's died of it. My labels are sixteen pages now, and the last four are apologies. | Idle chatter. Random. |
| 35 | [ ] | `fizz/idle_3.ogg` | Don't read the label, Rico. The label is lying. It's also a cousin of mine, which I'm required to disclose. | Idle chatter. Random. |
| 36 | [ ] | `fizz/idle_4.ogg` | Tell me your symptoms, then ignore my advice. That's the whole medical process here, and it has a ninety percent success rate, meaning you keep coming back. | Idle chatter. Random. |
| 37 | [ ] | `fizz/buy_1.ogg` | Drink it fast. No, slow. Wait, fast. Whichever one you didn't do. I forgot which is safe, so it's a gamble either way. | The player just bought something. |
| 38 | [ ] | `fizz/buy_2.ogg` | Side effects include luck, liver failure and a brief chat with a higher power. He says you owe him money too. | The player just bought something. |
| 39 | [ ] | `fizz/buy_3.ogg` | Do not mix with alcohol, other medications, or the afternoon. If you must mix, do it far from my shop, my reputation and my dog. | The player just bought something. |
| 40 | [ ] | `fizz/buy_4.ogg` | Good choice, probably. I don't read, I just pour and pray, and the prayer isn't responsible for the results either. | The player just bought something. |

### GUNNY: 40 lines

Folder: `voice/gunny/` (cutscene lines go in the folder shown). Voice: Everything is an order. Everything is a compliment..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `gunny/greet_1.ogg` | Welcome to the armory, recruit. Say hello to Betsy, the shotgun on the left. She never likes anyone, so I'm a little jealous. | Greeting the player. In character. |
| 2 | [ ] | `gunny/greet_2.ogg` | Stand up straight, recruit. You're in the presence of firepower, and I'm not talking about me. I'm talking about the lady on the wall. Stop staring, you're making her blush. | Greeting the player. In character. |
| 3 | [ ] | `gunny/greet_3.ogg` | You need firepower, recruit. I can smell it on you. I can also smell that you need a shower, but that's not in stock. | Greeting the player. In character. |
| 4 | [ ] | `gunny/greet_4.ogg` | Welcome, gambler. Everything in here goes bang, and nothing goes whimper. Unlike your bankroll. | Greeting the player. In character. |
| 5 | [ ] | `gunny/farewell_1.ogg` | Don't shoot your own foot, recruit. Shoot theirs. Betsy hates it when you mix those up. | Parting words as the player leaves. |
| 6 | [ ] | `gunny/farewell_2.ogg` | Dismissed. Try to die facing forward. Backward deaths mean paperwork, and Betsy cries over paperwork. | Parting words as the player leaves. |
| 7 | [ ] | `gunny/farewell_3.ogg` | Clean your guns, wash your hands, but never wash the lucky socks. They're load-bearing. | Parting words as the player leaves. |
| 8 | [ ] | `gunny/farewell_4.ogg` | Move out, rookie, and don't bet the ammo. I've named every bullet in that box, and I get attached. | Parting words as the player leaves. |
| 9 | [ ] | `gunny/rich_1.ogg` | Cash! The universal caliber! Listen, Betsy's purring. She hasn't purred since the divorce. | The player is carrying a lot of money. |
| 10 | [ ] | `gunny/rich_2.ogg` | A big spender. I salute your wallet. If I could marry it, I'd have to ask Betsy first, and she's protective. | The player is carrying a lot of money. |
| 11 | [ ] | `gunny/rich_3.ogg` | Now I'll show you the good stuff, recruit. Treat her right. She's like a daughter to me, in a way my lawyer has asked me to stop describing. | The player is carrying a lot of money. |
| 12 | [ ] | `gunny/rich_4.ogg` | That's purchasing power. I'm throwing in a free clip and a long moment alone with the new shotgun. Don't watch. | The player is carrying a lot of money. |
| 13 | [ ] | `gunny/broke_1.ogg` | No money, no bang. Oldest rule in the armory, and also the plot of your whole life. | The player is nearly broke. |
| 14 | [ ] | `gunny/broke_2.ogg` | Broke? Throw rocks. Rocks have a perfect safety record, if you ignore that glacier incident. | The player is nearly broke. |
| 15 | [ ] | `gunny/broke_3.ogg` | Hands off the shelves, recruit. Betsy doesn't like being touched by people who can't afford her. | The player is nearly broke. |
| 16 | [ ] | `gunny/broke_4.ogg` | No cash? You can look. But Betsy sees you staring, and she says buy her or stop breathing on the glass. | The player is nearly broke. |
| 17 | [ ] | `gunny/ugly_1.ogg` | Soldier, that outfit is a disciplinary action. I've seen less offensive things come out of a mortar. | The player is wearing ugly clothes. |
| 18 | [ ] | `gunny/ugly_2.ogg` | Camouflage? You look like a bruise wandering around. Betsy sighed when you walked in, and she never sighs. | The player is wearing ugly clothes. |
| 19 | [ ] | `gunny/ugly_3.ogg` | I've seen better uniforms on a scarecrow, recruit. The scarecrow had a better stance, a stronger sense of purpose, and honestly a nicer rifle. | The player is wearing ugly clothes. |
| 20 | [ ] | `gunny/ugly_4.ogg` | What happened to your pants, recruit? If the House took them, I'd like to report it. If you picked them, I'd like to report that too. | The player is wearing ugly clothes. |
| 21 | [ ] | `gunny/sharp_1.ogg` | Spit-shined, recruit. I'm almost proud. Don't tell Betsy. She thinks she's my favorite. | The player is dressed sharp. |
| 22 | [ ] | `gunny/sharp_2.ogg` | That suit says lethal in four languages. Shame you only speak panic. | The player is dressed sharp. |
| 23 | [ ] | `gunny/sharp_3.ogg` | A sharp dresser holds a gun better. Scientific fact. The guns agree. They find you attractive, which is honestly unsettling. | The player is dressed sharp. |
| 24 | [ ] | `gunny/sharp_4.ogg` | You look like a general, recruit. So act like one: send others to die first and keep the good guns for yourself. | The player is dressed sharp. |
| 25 | [ ] | `gunny/died_1.ogg` | You're dead? Walk it off, recruit. And do it away from Betsy, she just had her stock polished. | The player just died. |
| 26 | [ ] | `gunny/died_2.ogg` | That's what armor is for, recruit. You forgot yours. Again. I keep handing you new ones like a patient father, and you keep feeding them to the floor. | The player just died. |
| 27 | [ ] | `gunny/died_3.ogg` | Retrain, rearm, resurrect, repeat. That's the whole military, and also your career. | The player just died. |
| 28 | [ ] | `gunny/died_4.ogg` | The only bad death is an unarmed death, recruit, and yours was a very unarmed one. Betsy would like a word. | The player just died. |
| 29 | [ ] | `gunny/boss_1.ogg` | Boss down! Medals for everyone except the boss, who gets a closed casket. Betsy gets a fresh coat of oil. She earned it. | The player just beat a boss. |
| 30 | [ ] | `gunny/boss_2.ogg` | That boss was large, loud, and legally ambiguous. Exactly what my ex-wife called me, and I took it as a compliment. | The player just beat a boss. |
| 31 | [ ] | `gunny/boss_3.ogg` | I sold that boss his first revolver. I regret nothing, except his trigger discipline. That one's on me. | The player just beat a boss. |
| 32 | [ ] | `gunny/boss_4.ogg` | You beat a boss, recruit, and I got a little misty. Betsy saw. We're not discussing it. | The player just beat a boss. |
| 33 | [ ] | `gunny/idle_1.ogg` | I'm naming the new shotgun and I need your opinion. Marjorie or Danielle? She's sensitive, so choose carefully. | Idle chatter. Random. |
| 34 | [ ] | `gunny/idle_2.ogg` | A revolver has six reasons, recruit. Use five. Save one for the barista. He knows what he did. | Idle chatter. Random. |
| 35 | [ ] | `gunny/idle_3.ogg` | The coin shotgun is my favorite. It's illegal in four countries and one Pizza Hut. I miss that Pizza Hut every day. | Idle chatter. Random. |
| 36 | [ ] | `gunny/idle_4.ogg` | Guns don't kill people, recruit, bad odds do. And Gary. We don't talk about Gary, and neither does Betsy. | Idle chatter. Random. |
| 37 | [ ] | `gunny/buy_1.ogg` | Excellent choice, recruit. Point it away from yourself, me, and Betsy. She's sensitive about being aimed at. | The player just bought something. |
| 38 | [ ] | `gunny/buy_2.ogg` | Classic. Respect it. It's seen things, mostly foreheads. | The player just bought something. |
| 39 | [ ] | `gunny/buy_3.ogg` | Eight out of ten customers survive their first purchase. You're a nine, which is mathematically impossible, and Betsy agrees. | The player just bought something. |
| 40 | [ ] | `gunny/buy_4.ogg` | Be gentle with her, recruit. She kicks. If she makes a sound, that's just the love. | The player just bought something. |

### VELMA VELVET: 16 lines

Folder: `voice/velma/` (cutscene lines go in the folder shown). Voice: You are singing the last song of the night..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `velma/idle_1.ogg` | Thirty years in this lounge, and the only thing that ever left early was my husbands. | Idle chatter. Random. |
| 2 | [ ] | `velma/idle_2.ogg` | This next song is for the broken-hearted. Table four, that means you, and your house. | Idle chatter. Random. |
| 3 | [ ] | `velma/idle_3.ogg` | People ask if I ever wanted to leave this lounge. I did. My contract has a clause about my soul. | Idle chatter. Random. |
| 4 | [ ] | `velma/idle_4.ogg` | I once got a standing ovation here. Turns out they were just trying to reach the exit past me. | Idle chatter. Random. |
| 5 | [ ] | `velma/greet_1.ogg` | Evening, sugar. Pull up a chair. The cushion's cursed, but the view is free. | Greeting the player. In character. |
| 6 | [ ] | `velma/greet_2.ogg` | You look like you need a love song. I only know the sad ones, so you're in luck. | Greeting the player. In character. |
| 7 | [ ] | `velma/greet_3.ogg` | Sit anywhere, honey, except the left stool. That's my third husband's, and he's still using it. | Greeting the player. In character. |
| 8 | [ ] | `velma/farewell_1.ogg` | Go on, Rico. If you see my second husband out there, tell him the check bounced and so did the marriage. | Parting words as the player leaves. |
| 9 | [ ] | `velma/farewell_2.ogg` | Come back and see me, sugar. I'll be right here. The lounge hasn't let me leave since the nineties. | Parting words as the player leaves. |
| 10 | [ ] | `velma/farewell_3.ogg` | Break a leg out there. Break two, and I know a doctor who takes chips. | Parting words as the player leaves. |
| 11 | [ ] | `velma/rich_1.ogg` | Flush with cash, are we? I'm writing a song about it. It's called Please Buy Me A Drink. | The player is carrying a lot of money. |
| 12 | [ ] | `velma/rich_2.ogg` | Rich again? Last time I sang you a love song and you tipped me a coaster. | The player is carrying a lot of money. |
| 13 | [ ] | `velma/broke_1.ogg` | Broke already, sugar? Sit down, I'll sing something sad. It's free, the only thing in here that is. | The player is nearly broke. |
| 14 | [ ] | `velma/broke_2.ogg` | Honey, you're so broke the slot machines look at you with pity. They're not built for pity. | The player is nearly broke. |
| 15 | [ ] | `velma/died_1.ogg` | I heard you died out there, sugar, so I wrote you a ballad. Mostly it's me humming and checking my watch. | The player just died. |
| 16 | [ ] | `velma/boss_1.ogg` | You beat a boss? Honey, I've tried for years. I just marry them instead. | The player just beat a boss. |

### DUMPSTER DAN: 16 lines

Folder: `voice/dumpster_dan/` (cutscene lines go in the folder shown). Voice: Laugh at your own points, then cough..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `dumpster_dan/idle_1.ogg` | I used to be a tax accountant. Now I live in a dumpster and I still owe more than you. | Idle chatter. Random. |
| 2 | [ ] | `dumpster_dan/idle_2.ogg` | The rats pay rent and never miss a month. Best tenants I've ever had. | Idle chatter. Random. |
| 3 | [ ] | `dumpster_dan/idle_3.ogg` | I've been in this alley so long the pigeons think I'm a statue. They're right. I haven't moved since Tuesday. | Idle chatter. Random. |
| 4 | [ ] | `dumpster_dan/idle_4.ogg` | Your brother James came through once and tipped me a pawn ticket. I want you to know I've been very careful with it. | Idle chatter. Random. |
| 5 | [ ] | `dumpster_dan/greet_1.ogg` | Spare a dollar, friend? I'd say it's for food, but it's really the dumpster's cover charge. | Greeting the player. In character. |
| 6 | [ ] | `dumpster_dan/greet_2.ogg` | A visitor! I've been alone so long I started talking to my reflection in a puddle. Terrible listener. | Greeting the player. In character. |
| 7 | [ ] | `dumpster_dan/greet_3.ogg` | Welcome home, Rico. Mind the mattress. It's the only thing in here getting more action than the casino. | Greeting the player. In character. |
| 8 | [ ] | `dumpster_dan/farewell_1.ogg` | Safe travels, buddy. If you die out there, I call dibs on your shoes. | Parting words as the player leaves. |
| 9 | [ ] | `dumpster_dan/farewell_2.ogg` | Come back soon. I'll be here. I'm always here. It's a flaw in my lifestyle. | Parting words as the player leaves. |
| 10 | [ ] | `dumpster_dan/farewell_3.ogg` | Don't forget me when you're rich. By rich I mean when you own a sandwich. | Parting words as the player leaves. |
| 11 | [ ] | `dumpster_dan/rich_1.ogg` | All that cash, Rico. You could buy a house, or a very small lawyer. I'd encourage the lawyer. | The player is carrying a lot of money. |
| 12 | [ ] | `dumpster_dan/rich_2.ogg` | Give me one chip and I swear I'll only spend it on things that would horrify you. | The player is carrying a lot of money. |
| 13 | [ ] | `dumpster_dan/broke_1.ogg` | Broke, huh? Welcome to my side of the alley. Rent's free and the rats are supportive. | The player is nearly broke. |
| 14 | [ ] | `dumpster_dan/broke_2.ogg` | Out of money? Rico, that's just my life with better lighting. You're going to love it. | The player is nearly broke. |
| 15 | [ ] | `dumpster_dan/died_1.ogg` | You died? Don't sweat it, buddy. I died once too, but the dumpster was cheaper than the funeral, so I stayed. | The player just died. |
| 16 | [ ] | `dumpster_dan/boss_1.ogg` | You beat a boss? Good for you. I once beat a pigeon for a hot dog and I still think about it. | The player just beat a boss. |

### SLICK NICK: 17 lines

Folder: `voice/slick_nick/` (cutscene lines go in the folder shown). Voice: Wink with your voice..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `slick_nick/idle_1.ogg` | People call me arrogant. If I were really arrogant, would I have learned what the word means? Also, yes. | Idle chatter. Random. |
| 2 | [ ] | `slick_nick/idle_2.ogg` | I don't gamble, Rico, I invest. It's what gambling is called when your dad has a boat. | Idle chatter. Random. |
| 3 | [ ] | `slick_nick/idle_3.ogg` | I have a system that can't lose. I'm only not rich because casinos keep changing the rules to be mean to me. | Idle chatter. Random. |
| 4 | [ ] | `slick_nick/idle_4.ogg` | My trust fund does the gambling and my face does the posing. Neither has ever been wrong. | Idle chatter. Random. |
| 5 | [ ] | `slick_nick/greet_1.ogg` | Rico! The man in debt to a casino I'm technically a member of. | Greeting the player. In character. |
| 6 | [ ] | `slick_nick/greet_2.ogg` | Ah, the other gambler. You're like a golden retriever with a loan shark. | Greeting the player. In character. |
| 7 | [ ] | `slick_nick/greet_3.ogg` | Hello, Rico. I'd shake your hand, but I just had mine manicured and I'd hate for it to catch your luck. | Greeting the player. In character. |
| 8 | [ ] | `slick_nick/farewell_1.ogg` | Run along, Rico, and don't die before I finish this drink. I want to gloat in person. | Parting words as the player leaves. |
| 9 | [ ] | `slick_nick/farewell_2.ogg` | See you at the top, where I'll already be, with better hair and a bigger tab. | Parting words as the player leaves. |
| 10 | [ ] | `slick_nick/farewell_3.ogg` | Good luck out there. I'm rooting for you, in the sense that I'd like to be there when you fail. | Parting words as the player leaves. |
| 11 | [ ] | `slick_nick/rich_1.ogg` | Nice stack, Rico. I'd be jealous, but I have a bigger one in a country you can't pronounce. | The player is carrying a lot of money. |
| 12 | [ ] | `slick_nick/rich_2.ogg` | Doing great for a man who started with nothing. It's inspiring, in a mostly sympathetic way. | The player is carrying a lot of money. |
| 13 | [ ] | `slick_nick/broke_1.ogg` | Broke already? I'll tell everyone you tried, in the tone we use for people who tried to cook. | The player is nearly broke. |
| 14 | [ ] | `slick_nick/broke_2.ogg` | I'd lend you money, but my accountant says charity is a tax scam for people who lose. | The player is nearly broke. |
| 15 | [ ] | `slick_nick/died_1.ogg` | You died again? Rico, at this point it's not a tragedy, it's a subscription. And I'd cancel. | The player just died. |
| 16 | [ ] | `slick_nick/boss_1.ogg` | You beat a boss? I was going to do that after lunch. Now I have to talk to my lawyer. | The player just beat a boss. |
| 17 | [ ] | `slick_nick/boss_2.ogg` | Lucky win, Rico. Everyone gets one. Try not to spend it all in the same place. | The player just beat a boss. |

### LADY LUCK LORRAINE: 16 lines

Folder: `voice/lorraine/` (cutscene lines go in the folder shown). Voice: Everything is a sign. Everything is bad luck..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `lorraine/idle_1.ogg` | Never cross your fingers at a card table, honey. The spirits find it rude, and they don't give refunds on curses. | Idle chatter. Random. |
| 2 | [ ] | `lorraine/idle_2.ogg` | Palms, tarot, tea leaves. Every one of them says the same thing about this casino: leave. | Idle chatter. Random. |
| 3 | [ ] | `lorraine/idle_3.ogg` | Black cats are good luck. I own four. The fifth is a raccoon, but he's committed to the bit. | Idle chatter. Random. |
| 4 | [ ] | `lorraine/idle_4.ogg` | I once predicted a man's death perfectly and he sued me. Now I say 'could be a rash.' | Idle chatter. Random. |
| 5 | [ ] | `lorraine/greet_1.ogg` | Oh honey, you're glowing. That's either good fortune or a fever, and I can't tell without touching you, which I will. | Greeting the player. In character. |
| 6 | [ ] | `lorraine/greet_2.ogg` | Sit, sugar. The stars are loud tonight, and they all say you'll regret something. They haven't picked what. | Greeting the player. In character. |
| 7 | [ ] | `lorraine/greet_3.ogg` | Don't tell me, you're a Scorpio. That explains the debt, the dying, and honestly the haircut. | Greeting the player. In character. |
| 8 | [ ] | `lorraine/farewell_1.ogg` | Go with the spirits, Rico. If they ask for a sacrifice, offer Marlow. He's already tired. | Parting words as the player leaves. |
| 9 | [ ] | `lorraine/farewell_2.ogg` | Take my lucky penny. It's cursed, but it's a good curse, like a really committed ex. | Parting words as the player leaves. |
| 10 | [ ] | `lorraine/farewell_3.ogg` | Don't step on any cracks, honey. One of them is my mother, and she's very sensitive. | Parting words as the player leaves. |
| 11 | [ ] | `lorraine/rich_1.ogg` | All that money, honey. The universe likes you, or it's setting you up for something awful. | The player is carrying a lot of money. |
| 12 | [ ] | `lorraine/rich_2.ogg` | You're loaded, so Venus is in your favor. Give me forty dollars and I'll ask her about the rest. | The player is carrying a lot of money. |
| 13 | [ ] | `lorraine/broke_1.ogg` | Broke, sugar? Mercury's in retrograde. By retrograde I mean your entire life. | The player is nearly broke. |
| 14 | [ ] | `lorraine/broke_2.ogg` | Poor baby. The planets have aligned against you, and they've been very organized about it. | The player is nearly broke. |
| 15 | [ ] | `lorraine/died_1.ogg` | You died again, honey? I saw it in the cards. I didn't want to spoil the surprise. Bad for business. | The player just died. |
| 16 | [ ] | `lorraine/boss_1.ogg` | You beat a boss? The cards did mention a winner, but they said 'by accident,' and I chose to be polite. | The player just beat a boss. |

### OFFICER DUNN: 16 lines

Folder: `voice/dunn/` (cutscene lines go in the folder shown). Voice: Say everything like reading the same warning for the 800th time..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `dunn/idle_1.ogg` | Nineteen years in security here, and I've never seen a guest leave happy. I call that professional success. | Idle chatter. Random. |
| 2 | [ ] | `dunn/idle_2.ogg` | I'm told my job is to protect the casino from you, and you from the casino. Nobody will say which one pays. | Idle chatter. Random. |
| 3 | [ ] | `dunn/idle_3.ogg` | I'm not paid enough for this. I say it out loud every hour, in case payroll is listening. | Idle chatter. Random. |
| 4 | [ ] | `dunn/idle_4.ogg` | Management says smile at the guests. But the guests keep dying, which makes smiling feel strange. | Idle chatter. Random. |
| 5 | [ ] | `dunn/greet_1.ogg` | Evening, sir. Please keep your hands visible, your chips visible, and your intentions visible, if you have any. | Greeting the player. In character. |
| 6 | [ ] | `dunn/greet_2.ogg` | Welcome, sir. I'll need ID, a second ID, and a brief explanation of why you look like that. | Greeting the player. In character. |
| 7 | [ ] | `dunn/greet_3.ogg` | Ah, Rico. I was told you'd be coming. There's a laminated photo of you at the front desk. | Greeting the player. In character. |
| 8 | [ ] | `dunn/farewell_1.ogg` | Have a safe evening, sir. If you die on the premises, do it near the exit. The mop is closer. | Parting words as the player leaves. |
| 9 | [ ] | `dunn/farewell_2.ogg` | Exit's that way, sir. If you're planning a scene, it's also that way, but faster. | Parting words as the player leaves. |
| 10 | [ ] | `dunn/farewell_3.ogg` | Please take nothing from the premises, sir, including the lighting. Someone did last week. | Parting words as the player leaves. |
| 11 | [ ] | `dunn/rich_1.ogg` | Sir, that is a lot of money. I'll need you to carry it more apologetically. | The player is carrying a lot of money. |
| 12 | [ ] | `dunn/rich_2.ogg` | Winning is fine, sir, but do it quietly. The losers nearby have a policy about eye contact. | The player is carrying a lot of money. |
| 13 | [ ] | `dunn/broke_1.ogg` | Without funds, sir, you're just a man standing in a casino. That's loitering with extra steps. | The player is nearly broke. |
| 14 | [ ] | `dunn/broke_2.ogg` | No money? That's fine, sir. The exit is free, the only thing in here that is. | The player is nearly broke. |
| 15 | [ ] | `dunn/died_1.ogg` | Sir, dying on the premises is against policy. I've filed a form. The form has already been rejected. | The player just died. |
| 16 | [ ] | `dunn/boss_1.ogg` | You hurt a boss, sir? That's an incident. I'll need a form, a witness, and ideally a different job. | The player just beat a boss. |

### THE HOUSE: 57 lines

Folder: `voice/the_house/` (cutscene lines go in the folder shown). Voice: Say it like you are reading terms and conditions to a prisoner..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `the_house/intro_1.ogg` | Hole cards, flop, turn, river, and in the pot, your brother. Please sit, Rico. Your seat has been warmed by your previous losses. | Boss intro cutscene. Menacing. Texas Hold'em themed. |
| 2 | [ ] | `the_house/defeat_1.ogg` | The House... folds? I fold? Is this what it feels like? It feels... expensive. I'd like to speak to my manager. It's me. I'm the manager. | Boss defeat. Falling apart. |
| 3 | [ ] | `the_house/phase2_1.ogg` | You've exceeded your performance expectations, Rico. I'll flag that in your review, for deletion. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `the_house/phase3_1.ogg` | The river, Rico. Company policy says I must say 'nothing personal' while making it extremely personal. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `the_house/taunt_1.ogg` | Two hole cards, five community cards, and one very large Marker. Simple game, and you've already folded in spirit. | Boss taunt during an attack. |
| 6 | [ ] | `the_house/taunt_2.ogg` | As a valued member, you've been upgraded to the Platinum tier of losing. A complimentary headache is included. | Boss taunt during an attack. |
| 7 | [ ] | `the_house/taunt_3.ogg` | Your brother is a wonderful employee. He has never asked for a day off, because he doesn't know what a day is. | Boss taunt during an attack. |
| 8 | [ ] | `the_house/hurt_1.ogg` | Noted, and filed under 'Rico, ongoing.' | Boss gets hit. Grunt-style. |
| 9 | [ ] | `the_house/hurt_2.ogg` | The House does not bleed. We issue an incident report. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `the_house/kill_1.ogg` | You have been folded, Rico, like a napkin. A fancy one, in a fancy bin. | Boss kills the player. Gloating. |
| 11 | [ ] | `the_house/kill_2.ogg` | Thank you for your loyalty. Please enjoy your complimentary death, redeemable once. | Boss kills the player. Gloating. |
| 12 | [ ] | `_cutscenes/city5_arrive/city5_arrive_3.ogg` | Welcome, Rico. We've expected you for years. Your brother has been dealing since lunch, he's doing wonderfully, and he asked about you twice. Briefly. | Cutscene: city5 arrive |
| 13 | [ ] | `_cutscenes/final_prelude/final_prelude_1.ogg` | You climbed my five cities and beat my table lords, Rico. You have exceeded my expectations, which were very low. | Cutscene: final prelude |
| 14 | [ ] | `_cutscenes/final_prelude/final_prelude_3.ogg` | Texas Hold'em, then. The pot is your brother. Do sit, the chair is still warm from your losses. | Cutscene: final prelude |
| 15 | [ ] | `_cutscenes/intro/intro_4.ogg` | Welcome, valued guest. Per your Marker, you cannot die. You simply wake up at home, owing a little more. Think of it as a loyalty program with no rewards. | Cutscene: intro |
| 16 | [ ] | `_cutscenes/intro/intro_6.ogg` | We hoped you'd say that. It's in the brochure under 'Fine Print.' | Cutscene: intro |
| 17 | [ ] | `_cutscenes/true_ending/true_ending_1.ogg` | You beat me AGAIN? Fine. Double or nothing, one more hand. Rico? Are you listening? Rico, this is a Platinum-tier offer. | Cutscene: true ending |
| 18 | [ ] | `_cutscenes/true_ending/true_ending_3.ogg` | ...Nobody has called me that in twenty years. I had to check the name tag. | Cutscene: true ending |
| 19 | [ ] | `_cutscenes/true_ending/true_ending_5.ogg` | If I stop playing, what's left of me? A very expensive suit with a loyalty program? | Cutscene: true ending |
| 20 | [ ] | `_cutscenes/true_ending/true_ending_7.ogg` | ...Cashing out. Huh. It feels like falling. The good kind, where the floor is a really nice carpet. | Cutscene: true ending |
| 21 | [ ] | `the_house/pa_lobby_1.ogg` | Welcome to the apartment. The House appreciates your continued mismanagement of it. | PA announcement. Polite, chilling. |
| 22 | [ ] | `the_house/pa_lobby_2.ogg` | No one dies owing the House, as that would be bad for business, and also for the carpet. | PA announcement. Polite, chilling. |
| 23 | [ ] | `the_house/pa_wake_1.ogg` | Welcome back, valued guest. Your tab has been adjusted upward, as a thank-you for your loyalty. | PA announcement. Polite, chilling. |
| 24 | [ ] | `the_house/pa_wake_2.ogg` | Back so soon? The House never forgets a debtor, or their birthday, and we have a card. | PA announcement. Polite, chilling. |
| 25 | [ ] | `the_house/pa_wake_3.ogg` | Interest has been applied to your account. Please smile, it's compounding. | PA announcement. Polite, chilling. |
| 26 | [ ] | `the_house/pa_wake_spikes_1.ogg` | Attention, guests: Rico was defeated by a spike. As a valued member, the spike has earned a complimentary drink. | PA announcement. Polite, chilling. |
| 27 | [ ] | `the_house/pa_wake_guard_1.ogg` | Security reminds guests that punching is a privilege, not a right, and as of today it is also a fee. | PA announcement. Polite, chilling. |
| 28 | [ ] | `the_house/pa_wake_bat_1.ogg` | The rats thank Rico for his generous contribution to their dinner. They found his femur especially delicious. | PA announcement. Polite, chilling. |
| 29 | [ ] | `the_house/pa_wake_boss1_1.ogg` | The first boss sends his regards, along with an invoice, a card, and a small, passive-aggressive muffin. | PA announcement. Polite, chilling. |
| 30 | [ ] | `the_house/pa_wake_boss2_1.ogg` | Another table has won, by which the House means us. The House is pleased, and slightly giggly. | PA announcement. Polite, chilling. |
| 31 | [ ] | `the_house/pa_wake_boss3_1.ogg` | So close, valued guest. The House admires ambition, and the House keeps it in a drawer, with the other ambitions. | PA announcement. Polite, chilling. |
| 32 | [ ] | `the_house/pa_wake_mags_1.ogg` | Our partners in lending thank you for your patience, and for your future earnings, which they have already spent. | PA announcement. Polite, chilling. |
| 33 | [ ] | `the_house/pa_wake_big_1.ogg` | That Pot was beautiful, and it's ours now. Thank you for your service, please come again, and preferably poorer. | PA announcement. Polite, chilling. |
| 34 | [ ] | `the_house/pa_start_1.ogg` | Doors are open, so mind the spikes, or don't, since the House has money on 'don't.' | PA announcement. Polite, chilling. |
| 35 | [ ] | `the_house/pa_start_2.ogg` | Another guest begins the climb. How wonderful for our quarterly numbers. | PA announcement. Polite, chilling. |
| 36 | [ ] | `the_house/pa_ride_1.ogg` | Let it ride? Oh, the House LIKES you. You're our favorite income stream. | PA announcement. Polite, chilling. |
| 37 | [ ] | `the_house/pa_ride_2.ogg` | Bold. The House adores bold, because bold has margins. | PA announcement. Polite, chilling. |
| 38 | [ ] | `the_house/pa_ride8_1.ogg` | Attention, guests: we have a high roller on the floor. Please applaud him warmly, and then politely lift his wallet. | PA announcement. Polite, chilling. |
| 39 | [ ] | `the_house/pa_cashout_1.ogg` | Playing it safe? How responsible of you, and how deeply disappointing for us. | PA announcement. Polite, chilling. |
| 40 | [ ] | `the_house/pa_cashout_2.ogg` | Walking away? The House will remember this. The House keeps a spreadsheet, and you're a column. | PA announcement. Polite, chilling. |
| 41 | [ ] | `the_house/pa_jackpot_1.ogg` | Who rigged that machine? WHO RIGGED THAT MACHINE? Was it Gerald? It was Gerald. | PA announcement. Polite, chilling. |
| 42 | [ ] | `the_house/pa_low_hp_1.ogg` | One life left. The House recommends prayer, and, as a courtesy, a will. | PA announcement. Polite, chilling. |
| 43 | [ ] | `the_house/pa_low_hp_2.ogg` | Feeling lucky? You shouldn't be. The House checked, and the results were very funny. | PA announcement. Polite, chilling. |
| 44 | [ ] | `the_house/pa_boss_1.ogg` | Ladies and gentlemen, the main event! Please clap, and then please place a bet against our guest. | PA announcement. Polite, chilling. |
| 45 | [ ] | `the_house/pa_vault_open_1.ogg` | Somebody check the safe. WHY IS THE SAFE OPEN? Whoever left it open is eligible for a demotion. | PA announcement. Polite, chilling. |
| 46 | [ ] | `the_house/pa_vault_miss_1.ogg` | The safe has now sealed. Punctuality is a virtue, guest, and so is not losing, and you've failed both. | PA announcement. Polite, chilling. |
| 47 | [ ] | `the_house/pa_loan_due_1.ogg` | Attention, guests: a loan is past due. Please keep your hands, feet, and dignity inside the casino at all times. | PA announcement. Polite, chilling. |
| 48 | [ ] | `the_house/pa_spill_1.ogg` | Butterfingers! The House will be keeping those. | PA announcement. Polite, chilling. |
| 49 | [ ] | `the_house/pa_spill_2.ogg` | Chips on the floor! Finders keepers, and losers weepers, per our terms and conditions. | PA announcement. Polite, chilling. |
| 50 | [ ] | `the_house/pa_bet_won_1.ogg` | A side bet has paid out. The House is fine. The House is totally fine. The House needs to lie down. | PA announcement. Polite, chilling. |
| 51 | [ ] | `the_house/pa_bet_lost_1.ogg` | Your side bet has lost. Tragic for you, delicious for us, and both are on the receipt. | PA announcement. Polite, chilling. |
| 52 | [ ] | `the_house/pa_cat_1.ogg` | Please do not pet the cat. The cat is a House employee, and is currently on a performance review. | PA announcement. Polite, chilling. |
| 53 | [ ] | `the_house/pa_cat_2.ogg` | The cat likes you, and the cat is wrong, as the cat has a poor track record with people. | PA announcement. Polite, chilling. |
| 54 | [ ] | `the_house/pa_daily_1.ogg` | Today's Daily Deal features the same cards for everyone. Fairness! How quaint, and how off-brand for us. | PA announcement. Polite, chilling. |
| 55 | [ ] | `the_house/pa_stakes_1.ogg` | Raising the stakes? The House salutes your poor judgment, and also your life insurance, which we are now beneficiary of. | PA announcement. Polite, chilling. |
| 56 | [ ] | `the_house/pa_ticket_1.ogg` | Littering is a violation of House policy, and reading what you found is worse, and remembering it is a felony. | PA announcement. Polite, chilling. |
| 57 | [ ] | `the_house/pa_charm_1.ogg` | A charm? How cute. The House has charms too, and we call them interest rates. | PA announcement. Polite, chilling. |

### DRAFTQUEENS: 11 lines

Folder: `voice/draftqueens/` (cutscene lines go in the folder shown). Voice: Every line ends with a finger snap you cannot hear..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `draftqueens/intro_1.ogg` | Five cards, and you can discard any you don't like. I'll start by discarding your face, and then we'll see how the rest of you draws. | Boss intro cutscene. Menacing. Five Card Draw themed. |
| 2 | [ ] | `draftqueens/defeat_1.ogg` | I had a pat hand! I stood pat, like the book says! The book is also why I'm losing my fantasy league. | Boss defeat. Falling apart. |
| 3 | [ ] | `draftqueens/phase2_1.ogg` | Time to draw. I'm tossing three cards and keeping two queens, and honestly, Rico, you're the next thing getting tossed. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `draftqueens/phase3_1.ogg` | Last draw, sweetie. I'm discarding my manners and keeping the queens. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `draftqueens/taunt_1.ogg` | One draw, sweetie. That's one more chance than your life ever gave you. | Boss taunt during an attack. |
| 6 | [ ] | `draftqueens/taunt_2.ogg` | I threw away three cards and kept two queens. Try that with your friends, Rico. Oh wait, you'd have zero left. | Boss taunt during an attack. |
| 7 | [ ] | `draftqueens/taunt_3.ogg` | You're holding a pair of twos and a lot of hope. Only one of those ever pays, and it's not the hope. | Boss taunt during an attack. |
| 8 | [ ] | `draftqueens/hurt_1.ogg` | Ow! Not the face, I just redrew it! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `draftqueens/hurt_2.ogg` | Hey! That was my good card! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `draftqueens/kill_1.ogg` | Five cards, one draw, and you drew a gravestone. | Boss kills the player. Gloating. |
| 11 | [ ] | `draftqueens/kill_2.ogg` | Nice try, sweetie. I drew a queen, and you drew the dirt. | Boss kills the player. Gloating. |

### FANDOOL: 11 lines

Folder: `voice/fandool/` (cutscene lines go in the folder shown). Voice: Yell every third word like a replay is on..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `fandool/intro_1.ogg` | Seven Card Stud: three cards down, four up, so everything you do is face up. Including the begging, which I'm already looking forward to. | Boss intro cutscene. Menacing. Seven Card Stud themed. |
| 2 | [ ] | `fandool/defeat_1.ogg` | The river wasn't supposed to bleed. In stud there IS no river! I'm hallucinating my own defeat! | Boss defeat. Falling apart. |
| 3 | [ ] | `fandool/phase2_1.ogg` | Fifth street, baby! Every card you hold is face up, so the whole room gets to watch you panic. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `fandool/phase3_1.ogg` | Seventh street, the last card, face down! It's my only secret, and it's an ace. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `fandool/taunt_1.ogg` | In stud your up cards are face up, Rico. Everyone can see your hand, even the people who left. | Boss taunt during an attack. |
| 6 | [ ] | `fandool/taunt_2.ogg` | There's nowhere to hide in stud, and nowhere to run either. It's a package deal. | Boss taunt during an attack. |
| 7 | [ ] | `fandool/taunt_3.ogg` | A seven and a three showing on fourth street? That's bringing a spork to a gunfight. | Boss taunt during an attack. |
| 8 | [ ] | `fandool/hurt_1.ogg` | Foul! Somebody review the tape! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `fandool/hurt_2.ogg` | Ref! He hit me! Ref! ...I'm the ref. Ow. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `fandool/kill_1.ogg` | And that's the game, folks! Me winning, you losing, and a nice highlight for the replay. | Boss kills the player. Gloating. |
| 11 | [ ] | `fandool/kill_2.ogg` | Replay that in slow motion. I want to watch you fall in high definition. | Boss kills the player. Gloating. |

### POKERSTARZ: 11 lines

Folder: `voice/pokerstarz/` (cutscene lines go in the folder shown). Voice: End statements like questions. Sigh a lot..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `pokerstarz/intro_1.ogg` | Omaha: four hole cards, and you have to use exactly two. Same as your funeral, where you'll get four mourners and use two of them as pallbearers. | Boss intro cutscene. Menacing. Omaha Hi-Lo themed. |
| 2 | [ ] | `pokerstarz/defeat_1.ogg` | Split pot, and I get the low half, which is nothing. Chat, am I cooked? Chat? Why is nobody typing? | Boss defeat. Falling apart. |
| 3 | [ ] | `pokerstarz/phase2_1.ogg` | Chat, he's actually good! Smash that like button while I destroy him for the clip! | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `pokerstarz/phase3_1.ogg` | New strategy: I'm using all four hole cards. That's illegal in Omaha, but I have sponsors. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `pokerstarz/taunt_1.ogg` | Omaha says use exactly two hole cards, Rico. You're using zero, because you're holding a pair of excuses. | Boss taunt during an attack. |
| 6 | [ ] | `pokerstarz/taunt_2.ogg` | Chat, he's got four hole cards and still found a way to have nothing. That's content. | Boss taunt during an attack. |
| 7 | [ ] | `pokerstarz/taunt_3.ogg` | Like, subscribe, and fold, in that order. Then consider a career change, like therapy. | Boss taunt during an attack. |
| 8 | [ ] | `pokerstarz/hurt_1.ogg` | Hey! No hitting on stream! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `pokerstarz/hurt_2.ogg` | Ow! I'm getting demonetized! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `pokerstarz/kill_1.ogg` | And that's the clip: 'Idiot Loses Everything With Four Hole Cards.' Thumbnail is your face. | Boss kills the player. Gloating. |
| 11 | [ ] | `pokerstarz/kill_2.ogg` | GG, no re. You're going on my highlight reel, right next to my other victims. Also you. | Boss kills the player. Gloating. |

### BETMGN: 11 lines

Folder: `voice/betmgn/` (cutscene lines go in the folder shown). Voice: Talk like every sentence has a trademark symbol..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `betmgn/intro_1.ogg` | Three Card Poker: three cards, ante up, and it's over so fast it'll feel like your last relationship. Quick, painless, and ending with a lawyer. | Boss intro cutscene. Menacing. Three Card Poker themed. |
| 2 | [ ] | `betmgn/defeat_1.ogg` | Queen high. Of course. I had the commission on the table! I had the commission and I had a plan! | Boss defeat. Falling apart. |
| 3 | [ ] | `betmgn/phase2_1.ogg` | Three cards isn't simple once you see the ante. That's my fee for existing. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `betmgn/phase3_1.ogg` | Final hand, Rico. Three cards, one ante, and my commission scales with your screaming. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `betmgn/taunt_1.ogg` | Three-card poker is easy. You get three cards, I get your money, and the math is very consistent. | Boss taunt during an attack. |
| 6 | [ ] | `betmgn/taunt_2.ogg` | Pair Plus pays when you have a pair, Rico. You've never had a pair of anything but problems. | Boss taunt during an attack. |
| 7 | [ ] | `betmgn/taunt_3.ogg` | Ante up everything you own, and I'll let you keep your three cards. They're yours, and they're bad. | Boss taunt during an attack. |
| 8 | [ ] | `betmgn/hurt_1.ogg` | Ow! That's coming out of your payout! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `betmgn/hurt_2.ogg` | Three cards, not three hits! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `betmgn/kill_1.ogg` | Three cards, three seconds. That's efficiency with a healthy margin. | Boss kills the player. Gloating. |
| 11 | [ ] | `betmgn/kill_2.ogg` | Pair Plus pays on a pair. You just paid plus. Thanks for playing. | Boss kills the player. Gloating. |

### STEAKE.COM: 11 lines

Folder: `voice/steake/` (cutscene lines go in the folder shown). Voice: Say 'to the moon' with your whole chest, even when it makes no sense..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `steake/intro_1.ogg` | In Razz, the worst hand wins, so you've basically already beaten me by being you. You're a natural. It's a lifetime achievement award. | Boss intro cutscene. Menacing. Razz themed. |
| 2 | [ ] | `steake/defeat_1.ogg` | A wheel, the best of the worst, and I lost anyway. That's not even a poker result, that's a personality review. | Boss defeat. Falling apart. |
| 3 | [ ] | `steake/phase2_1.ogg` | You hurt me, but in Razz the worst hand wins, so I'm technically ahead. To the moon! | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `steake/phase3_1.ogg` | All in on the dip! In Razz the best hand is ace to five, and mine is a panic attack. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `steake/taunt_1.ogg` | In Razz the lowest hand wins, so you're finally a natural. Congratulations on your entire career. | Boss taunt during an attack. |
| 6 | [ ] | `steake/taunt_2.ogg` | King, queen, jack showing? In Razz that's a disaster, and in life it's just your usual Tuesday. | Boss taunt during an attack. |
| 7 | [ ] | `steake/taunt_3.ogg` | I've got diamond hands, Rico, mostly because the real ones got liquidated. | Boss taunt during an attack. |
| 8 | [ ] | `steake/hurt_1.ogg` | Dip! Buy the dip! ...Oh no, I'm the dip. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `steake/hurt_2.ogg` | Rug pull! And I don't even own a rug! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `steake/kill_1.ogg` | You've been liquidated, buddy. Unlike your portfolio, I'm thrilled about it. | Boss kills the player. Gloating. |
| 11 | [ ] | `steake/kill_2.ogg` | Not financial advice, but I'm taking your wallet and your dignity. Mostly the dignity. | Boss kills the player. Gloating. |

### BOVADOH: 11 lines

Folder: `voice/bovadoh/` (cutscene lines go in the folder shown). Voice: Be bored. Boredom is scarier than shouting..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `bovadoh/intro_1.ogg` | Pai Gow: seven cards, two hands, and you have to beat both or you push. You'll push, Rico, right into a wall, and I'll call it a push. | Boss intro cutscene. Menacing. Pai Gow themed. |
| 2 | [ ] | `bovadoh/defeat_1.ogg` | I lost both hands. Both. That's impossible, I need a moment. I need several moments. Put it on my tab of moments. | Boss defeat. Falling apart. |
| 3 | [ ] | `bovadoh/phase2_1.ogg` | Impressive. Now I will play both hands at once, which is easy, since neither has ever been challenged. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `bovadoh/phase3_1.ogg` | I have two hands and you have one. Soon you will have none, which is a metaphor and also a threat. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `bovadoh/taunt_1.ogg` | Seven cards, split into five and two. Both hands are better than your life, and I'm including the childhood. | Boss taunt during an attack. |
| 6 | [ ] | `bovadoh/taunt_2.ogg` | You keep arranging your hands, Rico, as if there's a version where you win. Charming, like watching a dog drive. | Boss taunt during an attack. |
| 7 | [ ] | `bovadoh/taunt_3.ogg` | In Pai Gow, ties go to the banker, and I am the banker. So your best case is losing slowly. | Boss taunt during an attack. |
| 8 | [ ] | `bovadoh/hurt_1.ogg` | Hm. That stung. I'll cry about it later, at a spa. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `bovadoh/hurt_2.ogg` | Do that again, and I will pretend not to notice. Twice. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `bovadoh/kill_1.ogg` | Both of my hands won, and both of yours were mostly regret. | Boss kills the player. Gloating. |
| 11 | [ ] | `bovadoh/kill_2.ogg` | I'll file this under Tuesday, like everything else I have beaten. | Boss kills the player. Gloating. |

### SEEZER'S CLUB: 11 lines

Folder: `voice/seezers/` (cutscene lines go in the folder shown). Voice: Say everything like a toga is flowing behind you..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `seezers/intro_1.ogg` | Dealer stands on seventeen, but I never stand, not for you, not for the Senate, and especially not after what happened to Caesar. | Boss intro cutscene. Menacing. Blackjack themed. |
| 2 | [ ] | `seezers/defeat_1.ogg` | Twenty-two. I busted. How embarrassing. Rome fell on a bad hit, and now I know exactly how it felt. | Boss defeat. Falling apart. |
| 3 | [ ] | `seezers/phase2_1.ogg` | You have wounded Caesar, so I shall hit on sixteen. I fear nothing, not even math. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `seezers/phase3_1.ogg` | Seventeen, and I STAND. You, however, will fall like Rome, only faster and with less paperwork. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `seezers/taunt_1.ogg` | The dealer hits sixteen and stands on seventeen. It's Rome's rule for conquering, with more stabbing. | Boss taunt during an attack. |
| 6 | [ ] | `seezers/taunt_2.ogg` | You split your eights? A thing split is a thing broken, and I say that as a man stabbed twenty-three times. | Boss taunt during an attack. |
| 7 | [ ] | `seezers/taunt_3.ogg` | Want to double down, Rico? You already doubled your debt. Why not take insurance on your life? | Boss taunt during an attack. |
| 8 | [ ] | `seezers/hurt_1.ogg` | By Juno! That was my good toga! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `seezers/hurt_2.ogg` | Et tu, Rico?! Et twenty-two, I bust! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `seezers/kill_1.ogg` | Veni, vidi, bust. And by 'bust' I mean you hit on twelve, and now you're a statue. | Boss kills the player. Gloating. |
| 11 | [ ] | `seezers/kill_2.ogg` | Hail, Caesar. The dealer wins, and the player becomes a footnote. | Boss kills the player. Gloating. |

### WYNNER'S CIRCLE: 11 lines

Folder: `voice/wynners/` (cutscene lines go in the folder shown). Voice: Sniff once per sentence like the room smells poor..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `wynners/intro_1.ogg` | Punto, Banco, or Tie. You'll pick Tie, because it pays eight to one, and it lands about as often as you do a sit-up. | Boss intro cutscene. Menacing. Baccarat themed. |
| 2 | [ ] | `wynners/defeat_1.ogg` | A natural nine and I still fall. The Circle breaks. How gauche, to be defeated by a man who bets with his shoes. | Boss defeat. Falling apart. |
| 3 | [ ] | `wynners/phase2_1.ogg` | A natural eight? How adorable. I have a natural too, and mine comes with a wine cellar. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `wynners/phase3_1.ogg` | Banker, Player, or Tie. Bet on any of them, Rico, but mercy is not on the table. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `wynners/taunt_1.ogg` | In baccarat the player decides nothing. I find that peaceful. In your case, accurate. | Boss taunt during an attack. |
| 6 | [ ] | `wynners/taunt_2.ogg` | A tie pays eight to one, and it appears about as often as my affection for you. | Boss taunt during an attack. |
| 7 | [ ] | `wynners/taunt_3.ogg` | Squeeze the cards slowly, darling. It's tradition, and the only time you'll hold on to anything. | Boss taunt during an attack. |
| 8 | [ ] | `wynners/hurt_1.ogg` | How rude. I have not been struck since finishing school. | Boss gets hit. Grunt-style. |
| 9 | [ ] | `wynners/hurt_2.ogg` | Mon Dieu, you have bled on the baize. It's imported. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `wynners/kill_1.ogg` | The Banker wins, as ever, and the Player, as ever, is you, on the floor. | Boss kills the player. Gloating. |
| 11 | [ ] | `wynners/kill_2.ogg` | Adieu, darling. You'd have made an excellent tie. That pays eight to one, but not to you. | Boss kills the player. Gloating. |

### SNAKE EYES SAL: 11 lines

Folder: `voice/snake_eyes/` (cutscene lines go in the folder shown). Voice: Hiss and click your tongue between lines..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `snake_eyes/intro_1.ogg` | Seven, you lose. Eleven, you lose. Snake eyes, you lose and also pay a tax. Everything's a lose here, but the tax is the fun part. | Boss intro cutscene. Menacing. Craps themed. |
| 2 | [ ] | `snake_eyes/defeat_1.ogg` | Boxcars. On my own roll. Of course. Twelve. I hate twelve, and now it's put me in the ground, which is a place where numbers can't hurt me. | Boss defeat. Falling apart. |
| 3 | [ ] | `snake_eyes/phase2_1.ogg` | Come out roll! Seven or eleven, I win. Anything else, I blame you. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `snake_eyes/phase3_1.ogg` | Point's set, Rico. Hit your number before a seven, or die. Mostly die. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `snake_eyes/taunt_1.ogg` | Seven or eleven on the come out, you lose. I've decided that applies to your actual life too. | Boss taunt during an attack. |
| 6 | [ ] | `snake_eyes/taunt_2.ogg` | Snake eyes is two ones, Rico. That's exactly how many friends you have, and I'm counting me. | Boss taunt during an attack. |
| 7 | [ ] | `snake_eyes/taunt_3.ogg` | Roll a seven after your point and you lose. So naturally, that's the one number you'll love. | Boss taunt during an attack. |
| 8 | [ ] | `snake_eyes/hurt_1.ogg` | Not the dice! They're my babies! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `snake_eyes/hurt_2.ogg` | Ow! Hit me, not my lucky dice! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `snake_eyes/kill_1.ogg` | Seven out, pal. The shooter loses, and tonight the shooter is you. | Boss kills the player. Gloating. |
| 11 | [ ] | `snake_eyes/kill_2.ogg` | You never even rolled. The dice just looked at you and felt bad. | Boss kills the player. Gloating. |

### ONE-ARMED BANDIT: 11 lines

Folder: `voice/rusty_slots/` (cutscene lines go in the folder shown). Voice: Cheerful voice, dead eyes, glitches in the middle of words..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `rusty_slots/intro_1.ogg` | Pull my arm. Go on, I dare you. I'm a very lonely arm, and I've been waiting for someone to pull me in the nicest possible way. | Boss intro cutscene. Menacing. The Slot Machine themed. |
| 2 | [ ] | `rusty_slots/defeat_1.ogg` | Jackpot, for YOU? That's the first time anyone's won on me. I'm so proud. I'm so sad. I'm so very sad and proud. | Boss defeat. Falling apart. |
| 3 | [ ] | `rusty_slots/phase2_1.ogg` | ERROR, ERROR, MY ARM IS ON FIRE. THAT'S FINE, THAT'S HOW I PAY OUT. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `rusty_slots/phase3_1.ogg` | ALL THREE REELS ARE SPINNING. ALL THREE ARE YOU, AND ALL THREE ARE LOSING. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `rusty_slots/taunt_1.ogg` | Pull my arm, Rico. Everybody does. It's the only time I feel needed, and also violated. | Boss taunt during an attack. |
| 6 | [ ] | `rusty_slots/taunt_2.ogg` | Three sevens hit the jackpot. You currently have three of nothing, which pays exactly that. | Boss taunt during an attack. |
| 7 | [ ] | `rusty_slots/taunt_3.ogg` | I pay out one pull in fifty thousand, and take your coins every single time. Call it love, or math. | Boss taunt during an attack. |
| 8 | [ ] | `rusty_slots/hurt_1.ogg` | BZZZT! That's an arm, not a lever! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `rusty_slots/hurt_2.ogg` | TILT! Someone call my mother. She's a toaster. | Boss gets hit. Grunt-style. |
| 10 | [ ] | `rusty_slots/kill_1.ogg` | THREE BARS. OR THE SYMBOL FOR DEATH. I FORGET, I'M A SLOT MACHINE. | Boss kills the player. Gloating. |
| 11 | [ ] | `rusty_slots/kill_2.ogg` | OUT OF ORDER. AND NOW YOU ARE TOO, SIR. | Boss kills the player. Gloating. |

### KENO KEVIN: 11 lines

Folder: `voice/mr_lucky/` (cutscene lines go in the folder shown). Voice: Everything you say starts nice and turns evil on the last word..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `mr_lucky/intro_1.ogg` | Pick up to ten numbers, out of eighty. You'll hit none, because I'm Keno Kevin, welcome, and please don't pick Kevin. He never hits. | Boss intro cutscene. Menacing. Keno themed. |
| 2 | [ ] | `mr_lucky/defeat_1.ogg` | Eighty out of eighty? How? That's not even possible. I'm Kevin, I'm unlucky, I'm Keno, and I'm out of numbers. | Boss defeat. Falling apart. |
| 3 | [ ] | `mr_lucky/phase2_1.ogg` | You hit six numbers, Rico! In keno, that wins you a free ticket to lose more keno. | Boss reaches phase 2. Furious, stronger. |
| 4 | [ ] | `mr_lucky/phase3_1.ogg` | Twenty numbers get drawn out of eighty, Rico, and yours is up. | Boss reaches the final phase. Desperate and angry. |
| 5 | [ ] | `mr_lucky/taunt_1.ogg` | Pick up to ten numbers, Rico. I'll wait. Your odds are about the same as you having a good day. | Boss taunt during an attack. |
| 6 | [ ] | `mr_lucky/taunt_2.ogg` | You picked seven, and the ball came up eleven. The universe is telling you to go home. | Boss taunt during an attack. |
| 7 | [ ] | `mr_lucky/taunt_3.ogg` | Keno is bingo that went to college and became a worse person. Honestly, so am I. | Boss taunt during an attack. |
| 8 | [ ] | `mr_lucky/hurt_1.ogg` | Ow! My balls! The numbered ones! | Boss gets hit. Grunt-style. |
| 9 | [ ] | `mr_lucky/hurt_2.ogg` | I bruise like a lottery ticket in the rain! | Boss gets hit. Grunt-style. |
| 10 | [ ] | `mr_lucky/kill_1.ogg` | You hit zero out of ten. In keno that pays nothing, and in life, about the same. | Boss kills the player. Gloating. |
| 11 | [ ] | `mr_lucky/kill_2.ogg` | Better luck next draw. I've said that for years, and it has never once been true. | Boss kills the player. Gloating. |

### TOURIST: 22 lines

Folder: `voice/tourist/` (cutscene lines go in the folder shown). Voice: Everything you say is a question. All of them too loud..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `tourist/bark_1.ogg` | Is this the buffet? I've passed nine slot machines and a crying man, so I'm doubting it. | Random crowd bark, any city. |
| 2 | [ ] | `tourist/bark_2.ogg` | My husband went to the ATM nine hours ago. I think he found a better one. | Random crowd bark, any city. |
| 3 | [ ] | `tourist/bark_3.ogg` | I won fifty dollars, then lost four hundred trying to win more. So I'm technically ahead, mentally. | Random crowd bark, any city. |
| 4 | [ ] | `tourist/bark_4.ogg` | I came here to relax, and the casino keeps asking me for money. What am I even paying for? | Random crowd bark, any city. |
| 5 | [ ] | `tourist/bark_5.ogg` | I've seen a man arguing with a cup and a woman wearing a shower curtain. Is that Vegas? | Random crowd bark, any city. |
| 6 | [ ] | `tourist/bark_6.ogg` | The brochure said luxury. The carpet is sticky and I'm afraid to ask why. | Random crowd bark, any city. |
| 7 | [ ] | `tourist/bark_7.ogg` | Is it normal for the lights to flash this much, or am I having a medical event in a festive room? | Random crowd bark, any city. |
| 8 | [ ] | `tourist/bark_8.ogg` | Fifteen dollars for a tiny water. The cashier said 'enjoy the resort' like it was a threat. | Random crowd bark, any city. |
| 9 | [ ] | `tourist/bark_9.ogg` | Our anniversary trip is going great. She's in the lobby, I'm at the slots. | Random crowd bark, any city. |
| 10 | [ ] | `tourist/bark_10.ogg` | Can I pay with a coupon? It's two-for-one fries, but I have a lot of them. | Random crowd bark, any city. |
| 11 | [ ] | `tourist/bark_11.ogg` | I told my family it was a conference. I've only attended a slot machine shaped like a lobster. | Random crowd bark, any city. |
| 12 | [ ] | `tourist/bark_12.ogg` | Does the free drink come with a napkin? Nobody's brought me anything in an hour. | Random crowd bark, any city. |
| 13 | [ ] | `tourist/city1_1.ogg` | A hundred and twenty bucks for a boardwalk room, and the view is another hotel's parking lot. Their view is better. | Crowd bark flavored for city 1. |
| 14 | [ ] | `tourist/city1_7.ogg` | A seagull just stole my chips. Now he's winning more than I am. | Crowd bark flavored for city 1. |
| 15 | [ ] | `tourist/city2_1.ogg` | The sign says 'biggest little city in the world.' I think they're bragging about the debt. | Crowd bark flavored for city 2. |
| 16 | [ ] | `tourist/city2_7.ogg` | The clown keeps counting my chips. I'm fairly sure he's also the dealer. | Crowd bark flavored for city 2. |
| 17 | [ ] | `tourist/city3_1.ogg` | It's so humid my chips are sweating. Either that's the AC or the casino is nervous. | Crowd bark flavored for city 3. |
| 18 | [ ] | `tourist/city3_7.ogg` | The riverboat was supposed to be romantic. The river smells like a wet sock and the boat smells like what the sock was thinking. | Crowd bark flavored for city 3. |
| 19 | [ ] | `tourist/city4_1.ogg` | I thought Old Vegas was glamorous. The neon flickers, the carpet's older than me, and the shrimp cocktail is a rumor. | Crowd bark flavored for city 4. |
| 20 | [ ] | `tourist/city4_7.ogg` | Half the sign burned out, so it says 'Gold Nug.' That's what I call my husband after he loses. | Crowd bark flavored for city 4. |
| 21 | [ ] | `tourist/city5_1.ogg` | Forty bucks for a bottle of water at the Bellagiro. The waiter asked if I wanted it sparkling. I wanted a refund. | Crowd bark flavored for city 5. |
| 22 | [ ] | `tourist/city5_7.ogg` | We came for the shows. The best I've seen is a man in a tuxedo crying in the elevator. | Crowd bark flavored for city 5. |

### JUNKIE: 22 lines

Folder: `voice/junkie/` (cutscene lines go in the folder shown). Voice: Run out of breath at the end of every sentence..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `junkie/bark_1.ogg` | Spare a dollar? It's not for drugs, it's for slots. Worse, but it blinks. | Random crowd bark, any city. |
| 2 | [ ] | `junkie/bark_2.ogg` | I only came in to use the bathroom. The slot machine called me. I said I'd be right back. That was March. | Random crowd bark, any city. |
| 3 | [ ] | `junkie/bark_3.ogg` | I sold my car for chips, then my coat, and now my opinions. Nobody's buying those either. | Random crowd bark, any city. |
| 4 | [ ] | `junkie/bark_4.ogg` | My system is simple. I put in a dollar and pray. Then I put in another and pray harder. | Random crowd bark, any city. |
| 5 | [ ] | `junkie/bark_5.ogg` | I need twenty bucks to get my kidney back. Lost it in a bet. Good kidney, still under warranty. | Random crowd bark, any city. |
| 6 | [ ] | `junkie/bark_6.ogg` | Shh, don't tell the machine I'm leaving. It gets clingy. Last time it ate my shoe. | Random crowd bark, any city. |
| 7 | [ ] | `junkie/bark_7.ogg` | I used to be somebody. Then I became a regular. Now I'm a regular nobody, which is a promotion. | Random crowd bark, any city. |
| 8 | [ ] | `junkie/bark_8.ogg` | Three days awake, and the slot machine is the only thing that says 'welcome back.' | Random crowd bark, any city. |
| 9 | [ ] | `junkie/bark_9.ogg` | Let me tell you about my winning system. By winning I mean a time I almost did. | Random crowd bark, any city. |
| 10 | [ ] | `junkie/bark_10.ogg` | One more spin and then I'm going home. Told my kid the same thing in 2019. | Random crowd bark, any city. |
| 11 | [ ] | `junkie/bark_11.ogg` | Spare change? I'm trying to reach a million. I'm at negative thirty-two thousand, so it's a climb. | Random crowd bark, any city. |
| 12 | [ ] | `junkie/bark_12.ogg` | You look rich. Can I hold your wallet a second? I want to remember what hope feels like. | Random crowd bark, any city. |
| 13 | [ ] | `junkie/city1_2.ogg` | I lost my retirement on a lobster slot machine. The lobster hasn't even apologized. | Crowd bark flavored for city 1. |
| 14 | [ ] | `junkie/city1_8.ogg` | I watched a seagull cash out at the cage. He tipped better than I do. | Crowd bark flavored for city 1. |
| 15 | [ ] | `junkie/city2_2.ogg` | I pawned my ring for chips, then the pawn receipt. The shop says I'm their best customer. It's a lot of pressure. | Crowd bark flavored for city 2. |
| 16 | [ ] | `junkie/city2_8.ogg` | The lion's name is Gary and he owes me twelve dollars. He's a lion, so I'm not asking twice. | Crowd bark flavored for city 2. |
| 17 | [ ] | `junkie/city3_2.ogg` | I lost my paycheck on the riverboat. The air's so wet I can't tell if it's the river or my tears. | Crowd bark flavored for city 3. |
| 18 | [ ] | `junkie/city3_8.ogg` | I came to see the Elvis impersonator. Now I owe him eighty dollars and I'm not sure which of us is Elvis. | Crowd bark flavored for city 3. |
| 19 | [ ] | `junkie/city4_2.ogg` | I've been here since the nineties. I just realized I'm not a guest, I'm furniture. Cheaper furniture. | Crowd bark flavored for city 4. |
| 20 | [ ] | `junkie/city4_8.ogg` | Old Fremont Street was paradise. It still is, if you squint. I've been squinting since 1994. | Crowd bark flavored for city 4. |
| 21 | [ ] | `junkie/city5_2.ogg` | I lost my life savings at baccarat. The dealer told me to enjoy the fountain. I'm still not sure it was a joke. | Crowd bark flavored for city 5. |
| 22 | [ ] | `junkie/city5_8.ogg` | I need ten thousand to turn into a million. My system is begging. So, hi. | Crowd bark flavored for city 5. |

### PIT BOSS: 22 lines

Folder: `voice/pitboss/` (cutscene lines go in the folder shown). Voice: Say it like you've said it 10,000 times..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `pitboss/bark_1.ogg` | Sir, please lose more professionally. Your sobbing is affecting the other guests' enjoyment. | Random crowd bark, any city. |
| 2 | [ ] | `pitboss/bark_2.ogg` | Per policy, your losses are valued. Your feelings are not. | Random crowd bark, any city. |
| 3 | [ ] | `pitboss/bark_3.ogg` | This table is being reorganized, so your winnings are now our winnings. We call it synergy. | Random crowd bark, any city. |
| 4 | [ ] | `pitboss/bark_4.ogg` | Crying at the table is permitted, sir, but only in the designated crying area. It's the parking lot. | Random crowd bark, any city. |
| 5 | [ ] | `pitboss/bark_5.ogg` | I've filed your concern in the folder labelled Concerns. It's inside the incinerator. | Random crowd bark, any city. |
| 6 | [ ] | `pitboss/bark_6.ogg` | We value your feedback, sir. We've scheduled a meeting about it, location undisclosed. | Random crowd bark, any city. |
| 7 | [ ] | `pitboss/bark_7.ogg` | Our records say you simply lost, sir. That's handled by a different department. It doesn't exist. | Random crowd bark, any city. |
| 8 | [ ] | `pitboss/bark_8.ogg` | Sir, this is your third refund request. The answer is still a lovely smile. | Random crowd bark, any city. |
| 9 | [ ] | `pitboss/bark_9.ogg` | You're upset, sir, so we've given you a complimentary water and a complimentary exit. | Random crowd bark, any city. |
| 10 | [ ] | `pitboss/bark_10.ogg` | Per my last email, which was never sent, you're no longer permitted to be happy at this table. | Random crowd bark, any city. |
| 11 | [ ] | `pitboss/bark_11.ogg` | All bets are final, sir, and so is every decision about your credit, your seat, and your dignity. | Random crowd bark, any city. |
| 12 | [ ] | `pitboss/bark_12.ogg` | Welcome back, sir. We missed you. We also missed several chips. Let's discuss both in my office. | Random crowd bark, any city. |
| 13 | [ ] | `pitboss/city1_3.ogg` | Welcome to Resortz. Resort fee, service fee, convenience fee, and a fee for hearing this sentence. | Crowd bark flavored for city 1. |
| 14 | [ ] | `pitboss/city1_9.ogg` | Atlantic Shitty was voted 'adequate' by guests. The poll was conducted at gunpoint, by management. | Crowd bark flavored for city 1. |
| 15 | [ ] | `pitboss/city2_3.ogg` | Welcome to Cirrcus Cirrcus, where our clowns are licensed, bonded, and legally required to stop laughing when you lose. | Crowd bark flavored for city 2. |
| 16 | [ ] | `pitboss/city2_9.ogg` | Guests are reminded the tightrope is for performers only. Walking it over the craps table is not a legal bet. | Crowd bark flavored for city 2. |
| 17 | [ ] | `pitboss/city3_3.ogg` | Welcome to Hard Rok, where every table is a guitar solo and every loss gets a standing ovation, at a volume we don't control. | Crowd bark flavored for city 3. |
| 18 | [ ] | `pitboss/city3_9.ogg` | Guests are reminded that display guitars may not be played, smashed, or used to settle blackjack disputes. | Crowd bark flavored for city 3. |
| 19 | [ ] | `pitboss/city4_3.ogg` | Welcome to the Goldun Nugget. Our shark tank is decorative, our gold is paint, and our service charge is your wallet. | Crowd bark flavored for city 4. |
| 20 | [ ] | `pitboss/city4_9.ogg` | Guests are reminded that smoking, sleeping, and singing are allowed only in designated areas. There are none. | Crowd bark flavored for city 4. |
| 21 | [ ] | `pitboss/city5_3.ogg` | Welcome to the Bellagiro, where the fountains dance, the chandeliers shine, and the minimum bet is your rent. | Crowd bark flavored for city 5. |
| 22 | [ ] | `pitboss/city5_9.ogg` | Bellagiro policy requires all guests to look wealthy. Failures are escorted to the cheaper floor. | Crowd bark flavored for city 5. |

### DRUNK: 22 lines

Folder: `voice/drunk/` (cutscene lines go in the folder shown). Voice: Hiccup mid-word. Cry a little..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `drunk/bark_1.ogg` | I love everyone in this casino, even the guy who took my chips. Him most. | Random crowd bark, any city. |
| 2 | [ ] | `drunk/bark_2.ogg` | I'm not drunk, I'm emotionally flexible. The floor is moving, and that's the casino's fault. | Random crowd bark, any city. |
| 3 | [ ] | `drunk/bark_3.ogg` | Rico? I love that name. I've never forgotten it. I've also never heard it. | Random crowd bark, any city. |
| 4 | [ ] | `drunk/bark_4.ogg` | I lost my wife, my keys, and my car, in that order. The keys hurt most. | Random crowd bark, any city. |
| 5 | [ ] | `drunk/bark_5.ogg` | A toast to the slot machine that took my savings. May she find someone who treats her as well as I did. | Random crowd bark, any city. |
| 6 | [ ] | `drunk/bark_6.ogg` | Ever look at a roulette wheel and think, sad little planet? No? Just me? Cheers. | Random crowd bark, any city. |
| 7 | [ ] | `drunk/bark_7.ogg` | The bartender's said 'you're cut off' so many times it feels like our song. | Random crowd bark, any city. |
| 8 | [ ] | `drunk/bark_8.ogg` | They gave me a free drink, a free napkin, and a free reason to cry in public. | Random crowd bark, any city. |
| 9 | [ ] | `drunk/bark_9.ogg` | I think I'm in love with the dealer. She's the only one who says 'sir, step away' like she cares. | Random crowd bark, any city. |
| 10 | [ ] | `drunk/bark_10.ogg` | I'm winning it all back: my youth, my hair, and the slot machine's respect. In that order. | Random crowd bark, any city. |
| 11 | [ ] | `drunk/bark_11.ogg` | A man just hugged me and took my wallet. I want him to know I support his career. | Random crowd bark, any city. |
| 12 | [ ] | `drunk/bark_12.ogg` | I don't remember how I got here. Good news: neither does my wallet. | Random crowd bark, any city. |
| 13 | [ ] | `drunk/city1_4.ogg` | I love the boardwalk at night. Salt air, fried dough, and the smell of a man's bad decisions. | Crowd bark flavored for city 1. |
| 14 | [ ] | `drunk/city1_10.ogg` | Atlantic Shitty is the greatest city on earth. I say that after falling off the boardwalk and enjoying it. | Crowd bark flavored for city 1. |
| 15 | [ ] | `drunk/city2_4.ogg` | I made friends with a trapeze, a clown, and a lion. One of them is a mirror. | Crowd bark flavored for city 2. |
| 16 | [ ] | `drunk/city2_10.ogg` | I won a goldfish at the carnival game. I love him. He's already dead and I'm still holding the bag. | Crowd bark flavored for city 2. |
| 17 | [ ] | `drunk/city3_4.ogg` | Three days in this casino and the humidity is my best friend. He's wet and he loves me. | Crowd bark flavored for city 3. |
| 18 | [ ] | `drunk/city3_10.ogg` | I love Biloxi, the humidity, the guitars. Mostly I love that nobody's asked me to leave in nine hours. | Crowd bark flavored for city 3. |
| 19 | [ ] | `drunk/city4_4.ogg` | I love the flickering neon. It's the only thing here with a pulse. | Crowd bark flavored for city 4. |
| 20 | [ ] | `drunk/city4_10.ogg` | A man left a note at the front desk: 'Don't come for me, I'm finally winning.' I've been crying for an hour and I don't even know him. | Crowd bark flavored for city 4. |
| 21 | [ ] | `drunk/city5_4.ogg` | I told the fountain I loved it. It splashed me. I think we're engaged. | Crowd bark flavored for city 5. |
| 22 | [ ] | `drunk/city5_10.ogg` | The House challenged some guy to Texas Hold'em tonight. The prize is his brother. It's the most romantic thing I've ever heard. | Crowd bark flavored for city 5. |

### BOUNCER: 22 lines

Folder: `voice/bouncer/` (cutscene lines go in the folder shown). Voice: As low as you can go. Say as few words as possible..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `bouncer/bark_1.ogg` | No, you can't come in. I'd explain why, but you'd ask a follow-up, and I'm on break. | Random crowd bark, any city. |
| 2 | [ ] | `bouncer/bark_2.ogg` | You're not on the list. Nobody is. The list is a napkin, and I lost it. | Random crowd bark, any city. |
| 3 | [ ] | `bouncer/bark_3.ogg` | Dress code: no sneakers, no hats, no hope. You're wearing all three. | Random crowd bark, any city. |
| 4 | [ ] | `bouncer/bark_4.ogg` | VIP means very important people. You're, at best, a visibly inconvenient pedestrian. | Random crowd bark, any city. |
| 5 | [ ] | `bouncer/bark_5.ogg` | The line starts at the back. The back is in a different state. Start now. | Random crowd bark, any city. |
| 6 | [ ] | `bouncer/bark_6.ogg` | I can't let you in, but I can let you stay outside. That's available to everyone. | Random crowd bark, any city. |
| 7 | [ ] | `bouncer/bark_7.ogg` | ID, a second ID to confirm the first, and a note from your mother. Plus a lock of her hair, for the paperwork. | Random crowd bark, any city. |
| 8 | [ ] | `bouncer/bark_8.ogg` | Nice try, pal. Those shoes say 'lost,' that face says 'banned,' and together they say 'calling security.' | Random crowd bark, any city. |
| 9 | [ ] | `bouncer/bark_9.ogg` | I don't make the rules. I just enforce them. The first rule is I don't make the rules. Stop asking. | Random crowd bark, any city. |
| 10 | [ ] | `bouncer/bark_10.ogg` | Not tonight, not tomorrow. Ask again in the next life. I'll still be standing here. | Random crowd bark, any city. |
| 11 | [ ] | `bouncer/bark_11.ogg` | The answer is no. And your next question? Also no. I'm saving us time. | Random crowd bark, any city. |
| 12 | [ ] | `bouncer/bark_12.ogg` | You can't come in with that attitude, that jacket, or whatever that smell is. | Random crowd bark, any city. |
| 13 | [ ] | `bouncer/city1_5.ogg` | No shoes, no shirt, no service. And no, the seagull does not count as your plus-one. | Crowd bark flavored for city 1. |
| 14 | [ ] | `bouncer/city1_11.ogg` | The casino's full, the boardwalk's full, and the alley's full of some guy's stuff. Go home. | Crowd bark flavored for city 1. |
| 15 | [ ] | `bouncer/city2_5.ogg` | No, you can't ride the elephant. No, you can't sit on the clown. I don't care about your coupon. | Crowd bark flavored for city 2. |
| 16 | [ ] | `bouncer/city2_11.ogg` | A guy pawned his gold watch at the shop out front last week. Said he'd been promoted to Biloxi. Sounded like firing. | Crowd bark flavored for city 2. |
| 17 | [ ] | `bouncer/city3_5.ogg` | No guitars at the blackjack table. Yes, even the cheap one. Especially the cheap one. | Crowd bark flavored for city 3. |
| 18 | [ ] | `bouncer/city3_11.ogg` | Can't go upstairs, sir. The new dealer's a guy named James. He works for The House now. I'm under orders not to say how happy he looks. | Crowd bark flavored for city 3. |
| 19 | [ ] | `bouncer/city4_5.ogg` | No, you can't swim in the shark tank. And I don't care that they look hungry. So do I. | Crowd bark flavored for city 4. |
| 20 | [ ] | `bouncer/city4_11.ogg` | The chandelier is off-limits. It judges people, then falls on them. I've seen it. | Crowd bark flavored for city 4. |
| 21 | [ ] | `bouncer/city5_5.ogg` | The penthouse is invitation only, sir, and invitations go only to people who already own it. | Crowd bark flavored for city 5. |
| 22 | [ ] | `bouncer/city5_11.ogg` | No, you can't go to the penthouse without a reservation. 'I'm rescuing my brother' isn't one, though it's very moving. | Crowd bark flavored for city 5. |

### HUSTLER: 23 lines

Folder: `voice/hustler/` (cutscene lines go in the folder shown). Voice: Everything is an offer. Everything is urgent..

| # | Done | File name | Say this | How |
|---|---|---|---|---|
| 1 | [ ] | `hustler/bark_1.ogg` | Wanna buy a watch? Real gold, real Swiss. By real I mean it says 'real' on it. | Random crowd bark, any city. |
| 2 | [ ] | `hustler/bark_2.ogg` | Psst. Genuine casino chip, forty bucks. That's thirty-nine more than it's worth. | Random crowd bark, any city. |
| 3 | [ ] | `hustler/bark_3.ogg` | Three-card monte. Easy money. Just find the lady. By easy I mean impossible. | Random crowd bark, any city. |
| 4 | [ ] | `hustler/bark_4.ogg` | Lucky socks, guaranteed to win. By guaranteed I mean I'll refund you if I find you. | Random crowd bark, any city. |
| 5 | [ ] | `hustler/bark_5.ogg` | Fake ID, very convincing. It has your face, my face, and a third face I can't explain. | Random crowd bark, any city. |
| 6 | [ ] | `hustler/bark_6.ogg` | Blackjack system, fifty bucks. Rule one: you give me fifty bucks. | Random crowd bark, any city. |
| 7 | [ ] | `hustler/bark_7.ogg` | Magic beans. They bring good luck. Also, they're beans, so if you lose, you get a snack. | Random crowd bark, any city. |
| 8 | [ ] | `hustler/bark_8.ogg` | Genuine rabbit's foot, twenty bucks. The rabbit isn't using it anymore, but he's upset. | Random crowd bark, any city. |
| 9 | [ ] | `hustler/bark_9.ogg` | A map to the jackpot, fifty bucks. It leads straight to the exit, which is spiritually the jackpot. | Random crowd bark, any city. |
| 10 | [ ] | `hustler/bark_10.ogg` | Insider tip on the next big winner. It's a horse. The horse is me. I'm running from the cops. | Random crowd bark, any city. |
| 11 | [ ] | `hustler/bark_11.ogg` | Brand-new sunglasses, ten bucks, totally legit. I'd explain how I got them, but then you'd be a witness. | Random crowd bark, any city. |
| 12 | [ ] | `hustler/bark_12.ogg` | Indoor-rated umbrella, fifty bucks. And yes, it's raining. There's a pipe leaking over table six. | Random crowd bark, any city. |
| 13 | [ ] | `hustler/city1_6.ogg` | Saltwater taffy, twenty bucks a box. It's real taffy. Previously chewed, but real. | Crowd bark flavored for city 1. |
| 14 | [ ] | `hustler/city1_12.ogg` | Free sample of information: a guy bet his own brother at The House's table, and now the brother deals at the Bellagiro. The rest costs fifty bucks. | Crowd bark flavored for city 1. |
| 15 | [ ] | `hustler/city2_6.ogg` | Pawn shop's on the corner. Ten bucks for that watch today, nine tomorrow. It depreciates when you cry. | Crowd bark flavored for city 2. |
| 16 | [ ] | `hustler/city2_12.ogg` | Cotton candy, five bucks. Pink, fluffy, technically fiberglass, tastes like regret. That's a flavor. | Crowd bark flavored for city 2. |
| 17 | [ ] | `hustler/city3_6.ogg` | Guitar picks, five bucks, signed by a rock star. By rock star I mean my cousin Dale, who's on probation. | Crowd bark flavored for city 3. |
| 18 | [ ] | `hustler/city3_12.ogg` | Rock-and-roll sunglasses, ten bucks. You'll look like a legend and be hard to identify in a lineup. | Crowd bark flavored for city 3. |
| 19 | [ ] | `hustler/city4_6.ogg` | Genuine gold nuggets, twenty bucks. By gold I mean spray paint. By genuine I mean a lot of it. | Crowd bark flavored for city 4. |
| 20 | [ ] | `hustler/city4_12.ogg` | Vintage casino chips, thirty bucks. From the sixties. The chips, not the dealers. Though it's close. | Crowd bark flavored for city 4. |
| 21 | [ ] | `hustler/city5_6.ogg` | Genuine Bellagiro fountain water, twenty bucks a bottle. It's tap water, but it has a story. I scooped it. | Crowd bark flavored for city 5. |
| 22 | [ ] | `hustler/city5_12.ogg` | Real diamonds, fifty bucks. Rhinestones, but if you squint, and you're drunk, and you're me, diamonds. | Crowd bark flavored for city 5. |
| 23 | [ ] | `_cutscenes/city2_arrive/city2_arrive_4.ogg` | Pawn ticket? Sure, I remember your brother. Tall, sad, great at losing. He pawned his watch here and said he got promoted to Biloxi. | Cutscene: city2 arrive |

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
