extends RefCounted
## One data table for every voice in the game (item 38). The user performs EVERY
## character; these presets make one voice sound like many.
##
## preset: pitch (semitones), eq_low / eq_mid / eq_high (dB), dist (0..1 radio/phone
## grit), reverb (0..1), chorus (0..1). blip: base Hz, wave, rate (chars per blip).
## The tools/gen_voice_kit.gd script turns this table into VOICE_CAST.md, the
## per-character recipe cards in HOW_TO_RECORD.md and the voice/ folders.

const P := {
	"rico": {"name": "RICO", "role": "The Hero. A degenerate gambler who loves risk.", "quote": "Let it ride, baby!",
		"age": "30s", "accent": "Jersey-ish, cocky", "pitch": "mid", "speed": "fast", "energy": "high", "attitude": "reckless, grinning, self-aware",
		"ref": "a charming pool-hall hustler who has never once been told no", "mouth": "smile while you talk, lazy 'dese' and 'dose'",
		"tip": "Grin the whole time. Every line is a bet you already placed.",
		"preset": {"pitch": 0.0, "eq_low": 0.0, "eq_mid": 2.0, "eq_high": 1.0, "dist": 0.0, "reverb": 0.05, "chorus": 0.0}, "blip": {"hz": 420.0, "wave": "square", "rate": 2}},
	"marlow": {"name": "MARLOW", "role": "Your fixer, heard over a payphone/radio.", "quote": "Don't you dare quit now.",
		"age": "50s", "accent": "tired New York", "pitch": "low-mid", "speed": "medium", "energy": "low", "attitude": "weary, caring, guilty",
		"ref": "an old detective on his third coffee", "mouth": "slight rasp, talk through your nose a little",
		"tip": "Hold the phone away and sigh before the line.",
		"preset": {"pitch": -2.0, "eq_low": -3.0, "eq_mid": 4.0, "eq_high": -6.0, "dist": 0.35, "reverb": 0.0, "chorus": 0.0}, "blip": {"hz": 300.0, "wave": "tri", "rate": 3}},
	"vera": {"name": "VERA", "role": "Dealer. Sells charms. Knows more than she says.", "quote": "Bring me something shiny, sugar.",
		"age": "40s", "accent": "smoky Southern", "pitch": "low", "speed": "slow", "energy": "low", "attitude": "knowing, amused, flirty",
		"ref": "a jazz-club singer after midnight", "mouth": "breathy, drag the vowels, smile with half your mouth",
		"tip": "Whisper-purr. Never rush. You've seen every hand.",
		"preset": {"pitch": 2.0, "eq_low": 2.0, "eq_mid": 0.0, "eq_high": -2.0, "dist": 0.0, "reverb": 0.18, "chorus": 0.0}, "blip": {"hz": 350.0, "wave": "tri", "rate": 3}},
	"mags": {"name": "MAGS", "role": "The loan shark. Swims through walls to collect.", "quote": "This is me talking. The swimming is me collecting.",
		"age": "50s", "accent": "gravel-voiced Brooklyn", "pitch": "low", "speed": "slow", "energy": "medium", "attitude": "calm menace, polite",
		"ref": "a friendly grandmother who breaks legs", "mouth": "gravel in the throat, drop the pitch at the end of sentences",
		"tip": "Sweet as pie, then drop the floor out of your voice.",
		"preset": {"pitch": -4.0, "eq_low": 5.0, "eq_mid": -2.0, "eq_high": -3.0, "dist": 0.1, "reverb": 0.1, "chorus": 0.0}, "blip": {"hz": 190.0, "wave": "saw", "rate": 2}},
	"lucky": {"name": "LUCKY", "role": "The bartender. Pours drinks that keep you breathing.", "quote": "A drink can save your life, runner.",
		"age": "40s", "accent": "friendly Irish-American", "pitch": "mid", "speed": "medium", "energy": "medium", "attitude": "warm, chatty, wipes the same glass",
		"ref": "the bartender who remembers your order", "mouth": "smile, roll the Rs a little",
		"tip": "Pretend you are polishing a glass the entire time.",
		"preset": {"pitch": 1.0, "eq_low": 1.0, "eq_mid": 1.0, "eq_high": 0.0, "dist": 0.0, "reverb": 0.12, "chorus": 0.0}, "blip": {"hz": 380.0, "wave": "square", "rate": 3}},
	"jules": {"name": "JULES", "role": "Your missing brother. Lost at the tables.", "quote": "One more hand. Just one.",
		"age": "late 20s", "accent": "same as the hero, but hoarse", "pitch": "mid", "speed": "medium", "energy": "low", "attitude": "haunted, sheepish, proud",
		"ref": "a college dropout after three days awake", "mouth": "dry mouth, crack on the high words",
		"tip": "Whisper like you have not slept since Tuesday.",
		"preset": {"pitch": 0.5, "eq_low": -2.0, "eq_mid": 2.0, "eq_high": -1.0, "dist": 0.0, "reverb": 0.3, "chorus": 0.0}, "blip": {"hz": 400.0, "wave": "tri", "rate": 3}},
	"comp": {"name": "COMP", "role": "The casino cat. Good luck, probably.", "quote": "Mrrrow.",
		"age": "9 lives", "accent": "cat", "pitch": "high", "speed": "slow", "energy": "low", "attitude": "smug",
		"ref": "a very judgmental cat", "mouth": "meow, purr, trill; no real words",
		"tip": "Meow in different moods. Smug, hungry, offended.",
		"preset": {"pitch": 7.0, "eq_low": -4.0, "eq_mid": 2.0, "eq_high": 3.0, "dist": 0.0, "reverb": 0.05, "chorus": 0.0}, "blip": {"hz": 800.0, "wave": "tri", "rate": 2}},
	"the_house": {"name": "THE HOUSE", "role": "Final boss. Owner of everything. Plays Texas Hold'em.", "quote": "The House always wins.",
		"age": "ageless", "accent": "polished, no accent", "pitch": "very low", "speed": "slow", "energy": "low", "attitude": "cold, amused, corporate",
		"ref": "an elevator voice that owns the building", "mouth": "perfect diction, no smile, huge slow breaths",
		"tip": "Say it like you are reading terms and conditions to a prisoner.",
		"preset": {"pitch": -6.0, "eq_low": 4.0, "eq_mid": -3.0, "eq_high": -2.0, "dist": 0.08, "reverb": 0.55, "chorus": 0.25}, "blip": {"hz": 120.0, "wave": "saw", "rate": 2}},
	"draftqueens": {"name": "DRAFTQUEENS", "role": "Boss: Five Card Draw.", "quote": "Five cards. Discard what you don't like.",
		"age": "30s", "accent": "glamorous drag-queen sass", "pitch": "mid-high", "speed": "fast", "energy": "high", "attitude": "fabulous, bitchy",
		"ref": "a talk-show host at a roast", "mouth": "snap the consonants, hold the vowels",
		"tip": "Every line ends with a finger snap you cannot hear.",
		"preset": {"pitch": 3.0, "eq_low": -2.0, "eq_mid": 3.0, "eq_high": 3.0, "dist": 0.0, "reverb": 0.2, "chorus": 0.15}, "blip": {"hz": 520.0, "wave": "square", "rate": 2}},
	"fandool": {"name": "FANDOOL", "role": "Boss: Seven Card Stud.", "quote": "Everything you do is face up, pal.",
		"age": "30s", "accent": "sports-bar bro", "pitch": "mid", "speed": "fast", "energy": "high", "attitude": "loud, overconfident",
		"ref": "a guy yelling at a TV in a bar", "mouth": "bark, talk from the chest, spit your Ts",
		"tip": "Yell every third word like a replay is on.",
		"preset": {"pitch": -1.0, "eq_low": 2.0, "eq_mid": 3.0, "eq_high": 0.0, "dist": 0.2, "reverb": 0.1, "chorus": 0.0}, "blip": {"hz": 330.0, "wave": "square", "rate": 2}},
	"pokerstarz": {"name": "POKERSTARZ", "role": "Boss: Omaha.", "quote": "Four hole cards. Good luck with the other two.",
		"age": "20s", "accent": "influencer vocal fry", "pitch": "mid-high", "speed": "medium", "energy": "medium", "attitude": "bored, smug",
		"ref": "a streamer with a ring light", "mouth": "vocal fry, upspeak?",
		"tip": "End statements like questions. Sigh a lot.",
		"preset": {"pitch": 2.0, "eq_low": -3.0, "eq_mid": 1.0, "eq_high": 2.0, "dist": 0.0, "reverb": 0.1, "chorus": 0.1}, "blip": {"hz": 480.0, "wave": "tri", "rate": 2}},
	"betmgn": {"name": "BETMGN", "role": "Boss: Three Card Poker.", "quote": "Three cards. Ante up. It's over fast.",
		"age": "40s", "accent": "Vegas lounge announcer", "pitch": "low-mid", "speed": "fast", "energy": "high", "attitude": "slick, rehearsed",
		"ref": "a game-show host selling a timeshare", "mouth": "big radio voice, toothy",
		"tip": "Talk like every sentence has a trademark symbol.",
		"preset": {"pitch": -2.0, "eq_low": 3.0, "eq_mid": 2.0, "eq_high": 1.0, "dist": 0.05, "reverb": 0.25, "chorus": 0.0}, "blip": {"hz": 280.0, "wave": "square", "rate": 2}},
	"steake": {"name": "STEAKE.COM", "role": "Boss: Razz.", "quote": "In Razz the worst hand wins. You fit right in.",
		"age": "30s", "accent": "crypto-bro", "pitch": "mid", "speed": "fast", "energy": "high", "attitude": "hyped, scammy",
		"ref": "someone pitching a coin that is definitely not a scam", "mouth": "talk too fast, laugh at your own jokes",
		"tip": "Say 'to the moon' with your whole chest, even when it makes no sense.",
		"preset": {"pitch": 1.0, "eq_low": 0.0, "eq_mid": 3.0, "eq_high": 2.0, "dist": 0.1, "reverb": 0.05, "chorus": 0.0}, "blip": {"hz": 440.0, "wave": "square", "rate": 2}},
	"bovadoh": {"name": "BOVADOH", "role": "Boss: Pai Gow.", "quote": "Beat both hands or push. You will push. Into a wall.",
		"age": "50s", "accent": "calm, dry, cruel", "pitch": "low", "speed": "slow", "energy": "low", "attitude": "deadpan",
		"ref": "a poker pro who has seen it all", "mouth": "barely move your lips",
		"tip": "Be bored. Boredom is scarier than shouting.",
		"preset": {"pitch": -3.0, "eq_low": 2.0, "eq_mid": 0.0, "eq_high": -2.0, "dist": 0.0, "reverb": 0.15, "chorus": 0.0}, "blip": {"hz": 220.0, "wave": "tri", "rate": 3}},
	"seezers": {"name": "SEEZER'S CLUB", "role": "Boss: Blackjack.", "quote": "Dealer stands on 17. I never stand. Not for you.",
		"age": "50s", "accent": "pompous Roman emperor", "pitch": "low-mid", "speed": "slow", "energy": "high", "attitude": "grand, theatrical",
		"ref": "an emperor reading a decree from a balcony", "mouth": "project from the diaphragm, roll the Rs",
		"tip": "Say everything like a toga is flowing behind you.",
		"preset": {"pitch": -3.0, "eq_low": 3.0, "eq_mid": 1.0, "eq_high": -1.0, "dist": 0.0, "reverb": 0.4, "chorus": 0.1}, "blip": {"hz": 240.0, "wave": "saw", "rate": 2}},
	"wynners": {"name": "WYNNER'S CIRCLE", "role": "Boss: Baccarat.", "quote": "Punto. Banco. Tie. You lose either way.",
		"age": "60s", "accent": "elegant, vaguely European", "pitch": "mid", "speed": "slow", "energy": "low", "attitude": "aristocratic, bored",
		"ref": "a count at a cocktail party", "mouth": "tight lips, pinky out",
		"tip": "Sniff once per sentence like the room smells poor.",
		"preset": {"pitch": 0.0, "eq_low": -1.0, "eq_mid": 2.0, "eq_high": 1.0, "dist": 0.0, "reverb": 0.35, "chorus": 0.1}, "blip": {"hz": 360.0, "wave": "tri", "rate": 3}},
	"snake_eyes": {"name": "SNAKE EYES SAL", "role": "Secret boss: Craps.", "quote": "Seven, you lose. Eleven, you lose.",
		"age": "60s", "accent": "back-alley hiss", "pitch": "low", "speed": "fast", "energy": "medium", "attitude": "twitchy, mean",
		"ref": "a snake who also runs numbers", "mouth": "hiss your S's",
		"tip": "Hiss and click your tongue between lines.",
		"preset": {"pitch": -3.0, "eq_low": 0.0, "eq_mid": 4.0, "eq_high": 2.0, "dist": 0.15, "reverb": 0.15, "chorus": 0.0}, "blip": {"hz": 260.0, "wave": "saw", "rate": 2}},
	"rusty_slots": {"name": "ONE-ARMED BANDIT", "role": "Secret boss: a haunted slot machine.", "quote": "Pull my arm. Go on. I dare you.",
		"age": "machine", "accent": "robot with a cold", "pitch": "mid", "speed": "medium", "energy": "medium", "attitude": "creepy cheerful",
		"ref": "a malfunctioning arcade cabinet", "mouth": "monotone with random beeps",
		"tip": "Cheerful voice, dead eyes, glitches in the middle of words.",
		"preset": {"pitch": 1.0, "eq_low": -4.0, "eq_mid": 5.0, "eq_high": 3.0, "dist": 0.5, "reverb": 0.1, "chorus": 0.5}, "blip": {"hz": 600.0, "wave": "square", "rate": 1}},
	"mr_lucky": {"name": "KENO KEVIN", "role": "Secret boss: Keno. Everyone's lucky charm.", "quote": "Pick eighty numbers. You'll hit none.",
		"age": "70s", "accent": "kindly old magician", "pitch": "mid", "speed": "medium", "energy": "medium", "attitude": "sweet, sinister",
		"ref": "a children's TV host who knows too much", "mouth": "warm smile, then a cold line",
		"tip": "Everything you say starts nice and turns evil on the last word.",
		"preset": {"pitch": 1.0, "eq_low": 0.0, "eq_mid": 1.0, "eq_high": 1.0, "dist": 0.0, "reverb": 0.25, "chorus": 0.2}, "blip": {"hz": 440.0, "wave": "tri", "rate": 2}},
	"tailor": {"name": "SILAS STITCH", "role": "The tailor. Sells clothes (and abilities).", "quote": "Clothes make the man. Clothes make the DASH.",
		"age": "60s", "accent": "fussy British", "pitch": "mid", "speed": "medium", "energy": "medium", "attitude": "snobby, fussy, secretly kind",
		"ref": "a Savile Row tailor with pins in his mouth", "mouth": "talk through pursed lips like holding pins",
		"tip": "Sniff at the player's outfit before each line.",
		"preset": {"pitch": 1.0, "eq_low": -2.0, "eq_mid": 2.0, "eq_high": 1.0, "dist": 0.0, "reverb": 0.1, "chorus": 0.0}, "blip": {"hz": 400.0, "wave": "tri", "rate": 3}},
	"fizz": {"name": "DOC FIZZ", "role": "The sketchy vendor. Drugs and booze with random effects.", "quote": "Side effects may include... everything.",
		"age": "40s", "accent": "jittery, wired", "pitch": "mid-high", "speed": "very fast", "energy": "very high", "attitude": "paranoid, helpful",
		"ref": "a back-alley pharmacist who sniffs the product", "mouth": "talk fast, glance around, sniff",
		"tip": "Whisper-yell. Look over your shoulder after each sentence.",
		"preset": {"pitch": 2.0, "eq_low": -3.0, "eq_mid": 3.0, "eq_high": 3.0, "dist": 0.1, "reverb": 0.15, "chorus": 0.3}, "blip": {"hz": 560.0, "wave": "square", "rate": 1}},
	"gunny": {"name": "GUNNY", "role": "The weapons vendor.", "quote": "Everything goes bang. Some things go BANG.",
		"age": "50s", "accent": "gruff drill sergeant", "pitch": "low", "speed": "fast", "energy": "high", "attitude": "gruff, proud of his stock",
		"ref": "a retired sergeant selling surplus", "mouth": "bark from the chest, clip every word",
		"tip": "Everything is an order. Everything is a compliment.",
		"preset": {"pitch": -4.0, "eq_low": 3.0, "eq_mid": 2.0, "eq_high": -1.0, "dist": 0.15, "reverb": 0.05, "chorus": 0.0}, "blip": {"hz": 200.0, "wave": "square", "rate": 2}},
	"velma": {"name": "VELMA VELVET", "role": "The lounge singer.", "quote": "Honey, I've lost more than you've bet.",
		"age": "50s", "accent": "velvet torch singer", "pitch": "low", "speed": "slow", "energy": "low", "attitude": "tragic, glamorous",
		"ref": "a lounge singer at last call", "mouth": "breathy, hum between words",
		"tip": "You are singing the last song of the night.",
		"preset": {"pitch": 1.0, "eq_low": 2.0, "eq_mid": 0.0, "eq_high": -1.0, "dist": 0.0, "reverb": 0.4, "chorus": 0.2}, "blip": {"hz": 330.0, "wave": "tri", "rate": 3}},
	"dumpster_dan": {"name": "DUMPSTER DAN", "role": "Alley bum. Knows secrets.", "quote": "Got any change? Got any WISDOM?",
		"age": "60s", "accent": "wheezy rasp", "pitch": "low", "speed": "slow", "energy": "low", "attitude": "cheerful, delusional",
		"ref": "a bum who used to be a professor", "mouth": "gravel, wheeze, missing teeth lisp",
		"tip": "Laugh at your own points, then cough.",
		"preset": {"pitch": -2.0, "eq_low": -2.0, "eq_mid": 3.0, "eq_high": -3.0, "dist": 0.25, "reverb": 0.15, "chorus": 0.0}, "blip": {"hz": 230.0, "wave": "saw", "rate": 3}},
	"slick_nick": {"name": "SLICK NICK", "role": "Rival gambler.", "quote": "I'm smarter than you and twice as handsome.",
		"age": "30s", "accent": "smarmy Hollywood", "pitch": "mid", "speed": "fast", "energy": "high", "attitude": "arrogant, hair gel",
		"ref": "a guy who says 'bro' to waiters", "mouth": "teeth showing, chin up",
		"tip": "Wink with your voice.",
		"preset": {"pitch": 1.0, "eq_low": -1.0, "eq_mid": 2.0, "eq_high": 3.0, "dist": 0.0, "reverb": 0.1, "chorus": 0.0}, "blip": {"hz": 450.0, "wave": "square", "rate": 2}},
	"lorraine": {"name": "LADY LUCK LORRAINE", "role": "Rival gambler. Superstitious.", "quote": "Never cross your fingers. Cross a fortune-teller.",
		"age": "60s", "accent": "brassy Texan", "pitch": "mid-high", "speed": "fast", "energy": "high", "attitude": "bubbly, superstitious",
		"ref": "a church-lady with a bingo problem", "mouth": "big smile, talk through lipstick",
		"tip": "Everything is a sign. Everything is bad luck.",
		"preset": {"pitch": 3.0, "eq_low": -2.0, "eq_mid": 2.0, "eq_high": 2.0, "dist": 0.0, "reverb": 0.1, "chorus": 0.1}, "blip": {"hz": 500.0, "wave": "square", "rate": 2}},
	"dunn": {"name": "OFFICER DUNN", "role": "Casino security.", "quote": "Sir, you can't do that here.",
		"age": "40s", "accent": "flat, bureaucratic", "pitch": "low", "speed": "medium", "energy": "low", "attitude": "robotic, by-the-book",
		"ref": "a mall cop at the end of his shift", "mouth": "monotone, sigh a lot",
		"tip": "Say everything like reading the same warning for the 800th time.",
		"preset": {"pitch": -3.0, "eq_low": 0.0, "eq_mid": 4.0, "eq_high": -4.0, "dist": 0.45, "reverb": 0.05, "chorus": 0.0}, "blip": {"hz": 250.0, "wave": "square", "rate": 3}},
	"tourist": {"name": "TOURIST", "role": "Crowd: drunk tourists.", "quote": "Is this the buffet?",
		"age": "40s", "accent": "loud Midwestern", "pitch": "mid", "speed": "medium", "energy": "high", "attitude": "oblivious, loud",
		"ref": "a dad in a Hawaiian shirt", "mouth": "slur a little, laugh a lot",
		"tip": "Everything you say is a question. All of them too loud.",
		"preset": {"pitch": 0.0, "eq_low": 0.0, "eq_mid": 1.0, "eq_high": 0.0, "dist": 0.0, "reverb": 0.2, "chorus": 0.0}, "blip": {"hz": 380.0, "wave": "square", "rate": 3}},
	"junkie": {"name": "JUNKIE", "role": "Crowd: shaky addicts.", "quote": "You got a... you got a dollar?",
		"age": "30s", "accent": "shaky mumble", "pitch": "mid", "speed": "slow", "energy": "low", "attitude": "jittery, sad",
		"ref": "someone who has not slept in four days", "mouth": "mumble, trail off",
		"tip": "Run out of breath at the end of every sentence.",
		"preset": {"pitch": -1.0, "eq_low": -2.0, "eq_mid": 3.0, "eq_high": -2.0, "dist": 0.2, "reverb": 0.1, "chorus": 0.1}, "blip": {"hz": 310.0, "wave": "tri", "rate": 3}},
	"pitboss": {"name": "PIT BOSS", "role": "Crowd: pit bosses and dealers.", "quote": "Place your bets.",
		"age": "40s", "accent": "professional", "pitch": "low-mid", "speed": "medium", "energy": "medium", "attitude": "stern, polite",
		"ref": "a floor manager with a headset", "mouth": "crisp, flat",
		"tip": "Say it like you've said it 10,000 times.",
		"preset": {"pitch": -2.0, "eq_low": 1.0, "eq_mid": 2.0, "eq_high": -1.0, "dist": 0.0, "reverb": 0.08, "chorus": 0.0}, "blip": {"hz": 270.0, "wave": "square", "rate": 3}},
	"drunk": {"name": "DRUNK", "role": "Crowd: bar patrons.", "quote": "I love you, man. I love everybody!",
		"age": "any", "accent": "slurred", "pitch": "mid", "speed": "slow", "energy": "medium", "attitude": "emotional",
		"ref": "your uncle at a wedding", "mouth": "slur, hiccup, trail off",
		"tip": "Hiccup mid-word. Cry a little.",
		"preset": {"pitch": -1.0, "eq_low": 2.0, "eq_mid": 0.0, "eq_high": -3.0, "dist": 0.0, "reverb": 0.2, "chorus": 0.35}, "blip": {"hz": 340.0, "wave": "tri", "rate": 3}},
	"bouncer": {"name": "BOUNCER", "role": "Crowd: bouncers and goons.", "quote": "Not tonight, pal.",
		"age": "30s", "accent": "bass-heavy tough guy", "pitch": "very low", "speed": "slow", "energy": "medium", "attitude": "bored, threatening",
		"ref": "a huge man guarding a velvet rope", "mouth": "chest voice, never smile",
		"tip": "As low as you can go. Say as few words as possible.",
		"preset": {"pitch": -6.0, "eq_low": 5.0, "eq_mid": 0.0, "eq_high": -3.0, "dist": 0.05, "reverb": 0.05, "chorus": 0.0}, "blip": {"hz": 150.0, "wave": "square", "rate": 3}},
	"hustler": {"name": "HUSTLER", "role": "Crowd: street hustlers and alley thugs.", "quote": "Hey. Hey you. Wanna buy a watch?",
		"age": "20s", "accent": "street fast-talk", "pitch": "mid", "speed": "fast", "energy": "high", "attitude": "pushy, charming",
		"ref": "a guy selling DVDs on a corner", "mouth": "talk out of the side of your mouth",
		"tip": "Everything is an offer. Everything is urgent.",
		"preset": {"pitch": 1.0, "eq_low": -1.0, "eq_mid": 2.0, "eq_high": 1.0, "dist": 0.0, "reverb": 0.1, "chorus": 0.0}, "blip": {"hz": 430.0, "wave": "square", "rate": 2}},
}

## Speaker names used in existing dialogue -> character id.
const NAME_TO_ID := {
	"RICO": "rico", "MARLOW": "marlow", "VERA": "vera", "MAGS": "mags", "LUCKY": "lucky", "JULES": "jules",
	"COMP": "comp", "THE HOUSE": "the_house", 
	"DRAFTQUEENS": "draftqueens", "FANDOOL": "fandool", "POKERSTARZ": "pokerstarz", "BETMGN": "betmgn", "STEAKE.COM": "steake",
	"BOVADOH": "bovadoh", "SEEZER'S CLUB": "seezers", "WYNNER'S CIRCLE": "wynners", "SNAKE EYES SAL": "snake_eyes",
	"ONE-ARMED BANDIT": "rusty_slots", "MR. LUCKY": "mr_lucky", "KENO KEVIN": "mr_lucky", "HUSTLER": "hustler", "SILAS": "tailor", "DOC FIZZ": "fizz", "GUNNY": "gunny",
	"VELMA": "velma", "DAN": "dumpster_dan", "NICK": "slick_nick", "LORRAINE": "lorraine", "DUNN": "dunn", "EDDIE": "the_house",
}

## Order used in documents.
const ORDER := ["rico", "marlow", "vera", "mags", "lucky", "jules", "comp", "tailor", "fizz", "gunny", "velma", "dumpster_dan", "slick_nick",
	"lorraine", "dunn", "the_house", "draftqueens", "fandool", "pokerstarz", "betmgn", "steake", "bovadoh", "seezers", "wynners",
	"snake_eyes", "rusty_slots", "mr_lucky", "tourist", "junkie", "pitboss", "drunk", "bouncer", "hustler"]


static func id_for(speaker: String) -> String:
	var up := speaker.strip_edges().to_upper()
	if NAME_TO_ID.has(up):
		return NAME_TO_ID[up]
	for k in P:
		if String(P[k]["name"]).to_upper() == up:
			return k
	return ""


## Semitones to a pitch_scale for AudioEffectPitchShift.
static func scale_of(semitones: float) -> float:
	return pow(2.0, semitones / 12.0)


## A plain-English Audacity recipe for a character, from its preset.
static func recipe(id: String) -> String:
	var pr: Dictionary = P[id]["preset"]
	var parts: Array = []
	var pt := float(pr["pitch"])
	parts.append("Change Pitch %s%.0f semitones" % ["+" if pt >= 0.0 else "", pt] if absf(pt) >= 0.5 else "Pitch: leave it alone")
	if absf(float(pr["eq_low"])) >= 1.0:
		parts.append("Bass %s%.0f dB" % ["+" if float(pr["eq_low"]) > 0.0 else "", float(pr["eq_low"])])
	if absf(float(pr["eq_high"])) >= 1.0:
		parts.append("Treble %s%.0f dB" % ["+" if float(pr["eq_high"]) > 0.0 else "", float(pr["eq_high"])])
	if absf(float(pr["eq_mid"])) >= 1.0:
		parts.append("Mid %s%.0f dB" % ["+" if float(pr["eq_mid"]) > 0.0 else "", float(pr["eq_mid"])])
	if float(pr["dist"]) > 0.0:
		parts.append("Distortion %d%%" % int(float(pr["dist"]) * 100.0))
	if float(pr["reverb"]) >= 0.1:
		parts.append("Reverb %d%% (Room Size 40)" % int(float(pr["reverb"]) * 100.0))
	if float(pr["chorus"]) > 0.0:
		parts.append("Chorus / Phaser %d%%" % int(float(pr["chorus"]) * 100.0))
	return ", ".join(parts)
