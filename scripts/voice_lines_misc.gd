extends RefCounted
## Minor NPCs (16 lines each), bosses (phase/taunt/hurt/kill barks), crowd barks
## (shared pools + one pool per city), and the new cutscene scripts.
## Line id = "<context>_<n>"; crowd and cutscene ids are listed in VOICE_SCRIPT.md.

const MINOR := {
	"velma": {"idle": ["Honey, I've lost more than you've bet.", "This next one's for the broken-hearted. And the broke.", "Dim the lights. The odds are shy.", "Last call for love. Everything's last call."],
		"greet": ["Evening, sugar. Pull up a shadow.", "You look like a song I forgot the end of.", "Take a seat. Take a chance. Take a breath."],
		"farewell": ["Don't be a stranger. Be a legend.", "The stage'll be here. So will I.", "Go. Win something. Lose something prettier."],
		"rich": ["Oh, you're in the money. Sing with me.", "Diamonds are a girl's best chips."],
		"broke": ["Broke and brave. My favorite lyric.", "Come sit. The blues are free."],
		"died": ["I wrote a song about you. It's mostly a sigh."], "boss": ["I'll sing about that one. Twice."]},
	"dumpster_dan": {"idle": ["Got any change? Got any WISDOM?", "The rats pay rent. Do you?", "I used to teach economics. Now I eat economics.", "The walls have secrets. Some are loose."],
		"greet": ["Hey there, friend. Spare a smile?", "Ooh, a visitor! Or a hallucination. Both are nice.", "You look like a man with a destiny and a wallet."],
		"farewell": ["Come back when you're rich! Or me.", "Mind the third brick. It likes to move.", "Don't forget me. Everybody does."],
		"rich": ["Look at you! The Midas of the alley!", "That's more than I've seen since 1998."],
		"broke": ["Ha! Welcome to the club. We've got cardboard.", "Poor! It's honest."],
		"died": ["Don't worry. Death's mostly paperwork."], "boss": ["The boss? I raised him. He was a lovely child."]},
	"slick_nick": {"idle": ["I'm smarter than you and twice as handsome.", "Luck? I don't need luck. I have hair.", "I read the odds. And then I rewrite them.", "Don't take it personally. Take it to the bank."],
		"greet": ["Well, well. If it isn't my favorite sucker.", "Ah, the other gambler. Cute.", "Looking for a rival? You found one. I'm excellent."],
		"farewell": ["Don't lose too early. I want to win later.", "See you at the top. I'll be there. First.", "Try not to embarrass yourself. I'll be watching."],
		"rich": ["Nice pot. I have a bigger one. I always have a bigger one.", "You're doing great! For you."],
		"broke": ["Oof. Broke? Must be rough being you.", "I'd buy you a drink. But no."],
		"died": ["You died? I won. Again."], "boss": ["A boss? I was about to do that. Today.", "Lucky shot. Everyone's lucky once."]},
	"lorraine": {"idle": ["Never cross your fingers. Cross a fortune-teller.", "Don't whistle at a table. It summons the House.", "A black cat? I own three. That's the secret.", "Throw salt. Throw sage. Throw chips."],
		"greet": ["Oh honey! You're glowing! That's either luck or fever.", "Come sit, sugar. The stars are loud tonight.", "Wait, don't tell me. You're a Scorpio. Bad news."],
		"farewell": ["Knock on wood. Knock on your own head.", "Take my lucky penny. It's cursed. You'll love it.", "Go with God. And with a rabbit's foot."],
		"rich": ["Money! It's a sign! A big sign!", "You're blessed. Or cursed. Same sparkle."],
		"broke": ["Broke? That's just Mercury being rude.", "Poor baby. Retrograde again."],
		"died": ["Dying? Bad omen. I'll light a candle."], "boss": ["A boss? Mercury's with you!"]},
	"dunn": {"idle": ["Sir, you can't do that here.", "I'm just doing my job. Which is you.", "Please keep your hands where I can see them. And your chips.", "Management reserves the right to refuse. Everything."],
		"greet": ["Evening, sir. Behave.", "ID, please. And your life story.", "Move along, citizen. Or stand still. I'm confused."],
		"farewell": ["Have a nice day. Or don't. It's not my department.", "Exit's that way. Not that way. That way.", "Enjoy your stay. Quietly."],
		"rich": ["That's a lot of money, sir. I'll be watching.", "Winning is fine. Winning loudly is a violation."],
		"broke": ["No funds? The exit's that way.", "Loitering without chips is discouraged."],
		"died": ["Sir, you can't die here. It's against policy."], "boss": ["You hit a boss? That's... that's an incident."]},
	"comp": {"idle": ["Mrrrow.", "Mrrp? Mrrp.", "Hssss. (Not at you. Probably.)", "Prrrr.", "Mrow-mrow.", "Meeeow. (Pet me. Not like that.)"],
		"greet": ["Mrrow!", "Prrrp?", "Mew."],
		"farewell": ["Mrrrrow. (Goodbye. And bring fish.)", "Meeeeow."],
		"rich": ["Prrrrr. (You smell like money.)", "Mrow! (Share.)"],
		"broke": ["Hss. (Bad.)", "Mew. (There, there.)"],
		"died": ["Mrrrrrow. (I saw that.)"], "boss": ["Purrr. (Not bad, human.)"]},
}

## Bosses: [phase2, phase3, taunt1, taunt2, taunt3, hurt1, hurt2, kill1, kill2]
const BOSS := {
	"draftqueens": ["Discard? Honey, I'm just getting started.", "Oh, now it's personal. Five of a kind, bitch.", "Is that the best you can draw?", "I read you at the flop. You looked boring.", "Cards don't lie. Neither does my eyeliner.", "Ow! That's a three-hundred-dollar blazer!", "Not the hair!", "Better luck next time, sweetie.", "That's a fold. Pack it up."],
	"fandool": ["Now it's a REAL game!", "FINAL QUARTER! LET'S GOOOOO!", "Everything's face up, buddy!", "I've seen your hole cards. They're shaking.", "Replay that! Replay it!", "Foul! That's a foul!", "REF!", "Another one bites the dust!", "Sudden death. For you."],
	"pokerstarz": ["Okay, that actually hurt. Smash that like button.", "Chat, he's cheating! Ban him!", "Four hole cards. You have none.", "Don't forget to subscribe to my wins.", "This is content. You're content.", "Rude. I'm demonetized.", "Oh my god, stop.", "GG. No re.", "That's the clip of the day."],
	"betmgn": ["Alright, let's raise the ante.", "Three cards. Three seconds. You're done.", "Pair plus? Pair minus.", "Ante up, folks!", "That's a Straight Flush of bad ideas.", "Ouch! That's a bad beat!", "No no no, my commission!", "Quick, wasn't it?", "The house edge says hi."],
	"steake": ["Nice hit. We're STILL going to the moon.", "To the MOOOON! Or the floor!", "Worst hand wins, friend. Congrats on yours.", "Diamond hands! Diamond everything!", "Not financial advice. But you're done.", "Buy the dip! Oh, that's me.", "Rug pull!", "HODL this, loser.", "Liquidated."],
	"bovadoh": ["...Impressive. Marginally.", "Both hands. Now.", "Two hands. Two defeats. Do the math.", "You push, I take.", "Dull. Everything's dull. You, too.", "Hm. That stung.", "Interesting.", "Predictable.", "As expected."],
	"seezers": ["You have wounded Caesar. Splendid.", "THIS IS THE END OF THE EMPIRE!", "Dealer stands. YOU do not.", "I'd hit you on 16.", "Et tu, gambler?", "A mere scratch on the marble!", "By Jupiter!", "Veni, vidi, bust.", "Hail, Caesar. And farewell."],
	"wynners": ["A natural eight. Perhaps it's your turn.", "Banker. Player. Tie. Doom.", "The shoe is cold. The room is colder.", "Place your bets on the inevitable.", "Pinky out, darling. This will hurt.", "How... rude.", "Mon Dieu.", "The Circle closes. Again.", "Adieu."],
	"snake_eyes": ["Boxcars! BOXCARS!", "Natural! Natural! You hear that?", "Seven! You lose!", "Snake eyes! Ssssnake EYES!", "Come out roll! Come OUT!", "Hsss! Careful!", "Ow, ow, ow!", "Sevennn!", "House pays. House always pays."],
	"rusty_slots": ["JACKPOT. JACKPOT. JACKPOT.", "ERROR. ERROR. LUCKY SEVEN.", "Insert coin to continue dying.", "Spin. Spin. Spin.", "Pull my arm. Go on. I dare you.", "BZZZT. Ow.", "Tilt. Tilt. Tilt.", "Three bars. You lose.", "OUT OF ORDER."],
	"mr_lucky": ["My, my. You ARE lucky.", "Now, now. Pick a number. Any number. Wrong.", "Pick eighty numbers. Hit none.", "Luck is just a lie told by the winning.", "Are you having fun? You will.", "Ow! Oh dear.", "That was unkind.", "Never lucky. Always careful.", "Better luck next time. Always."],
	"the_house": ["Interesting. The odds adjust.", "I do not lose. I RESET.", "Hole cards. Flop. Turn. River.", "The House always wins. It's not a boast. It's arithmetic.", "Every chip you hold is already mine.", "A scratch. The House endures.", "That was... noted.", "You've been folded.", "Terms and conditions apply."],
}
const BOSS_CTX := ["phase2", "phase3", "taunt", "taunt", "taunt", "hurt", "hurt", "kill", "kill"]

## Crowd barks: shared (type -> 12 lines) and per-city flavor (city index -> 12 lines, any type).
const CROWD := {
	"tourist": ["Is this the buffet?", "Honey! Come look! Slot machines!", "Does the free drink come with an umbrella?", "I lost five dollars! I'm RUINED!", "Wait, is it a one-armed bandit or a no-armed bandit?", "Hey, buddy! Which way to the pool?", "I've never seen so many lights in my life!", "Can I pay with a coupon?", "Where's the fountain? Is that it? It's very small.", "Why is everyone so serious?", "My husband is in a coma at the roulette table.", "It's so clean! Except for that."],
	"junkie": ["You got a... you got a dollar?", "I swear I put it somewhere... somewhere.", "Don't tell them I'm here. Don't tell them anything.", "I'm fine. I'm just... resting.", "Hey. Hey. Do you hear the bugs?", "I've got nine lives. Six of them are used.", "The walls are breathing. Nice walls.", "Got a light? Got a... got a fix?", "Whoa. Where'd you come from?", "I'm clean. Mostly. Sort of.", "Everything's shiny. Everything's shiny!", "Shh. The floor is listening."],
	"pitboss": ["Place your bets.", "Cards on the table. Hands where I can see 'em.", "No cameras. No phones. No joy.", "Watch your chips, sir.", "That's a violation. And a threat.", "Pit to floor, we have a loser.", "Please keep the noise to a minimum.", "That table's closed. Permanently.", "The House appreciates your patronage.", "All bets are final. Unlike your life.", "Don't make me call the floor.", "Sir, that was a poor decision."],
	"drunk": ["I love you, man. I love everybody!", "Shhhh. The slot machine is sleeping.", "I'm not drunk. The floor is spinning.", "One more. Just one more. Hic.", "Where's my wife? Where's my shirt?", "I used to be somebody. Now I'm... everybody.", "Cheers! To whatever that was!", "Never bet on red. Always bet on whiskey.", "I think I'm in the wrong casino.", "I lost my keys. Or my car. Or my wife.", "Don't tell my kids. Don't tell my kids' kids.", "Everything's fine. Fine. FINE."],
	"bouncer": ["Not tonight, pal.", "Name's not on the list.", "Move along.", "I don't care who you know.", "ID.", "Dress code. You're in violation.", "Step outside. Please. Not really a request.", "You have the wrong shoes.", "VIP only. You're not.", "Keep walking.", "The line starts at the back.", "No."],
	"hustler": ["Hey. Hey you. Wanna buy a watch?", "I got a guy. He's got a guy. You want the guy.", "Psst. Free money. It's a scam. But free.", "Wanna see a magic trick? It's a wallet.", "Everything's for sale. Even me.", "You look lucky. You look LOST.", "Three-card monte! Find the lady!", "Cheap chips! Authentic! Probably!", "Ten bucks. No questions.", "That's a nice jacket. I'll take it. Joke.", "Business is slow. Be my business.", "Don't look at me. I didn't do it."],
}
const CITY_CROWD := [
	["The boardwalk smells like regret and funnel cake.", "Atlantic Shitty, where dreams go to evaporate.", "I lost my retirement on a slot shaped like a lobster.", "Saltwater taffy and bad decisions!", "The seagulls steal chips here.", "This place has seen better decades.", "Don't drink the water. Don't drink the drinks.", "Welcome to Resortz. Lower your standards.", "A mascot ate my sandwich.", "This casino was voted 'adequate'.", "I came for the ocean. I stayed for the debt.", "The carpet here hasn't been cleaned since the nineties."],
	["Reno! The biggest little city with the smallest chances.", "Cirrcus Cirrcus: where the clowns run the tables.", "I lost a bet to a juggler.", "The trapeze is for the high rollers. Literally.", "Mind the clown. The clown bites.", "Everything here is sticky. Don't ask.", "Come see the world's smallest elephant. It's a dog.", "I'm a clown. I'm sad. I'm broke.", "The cotton candy is a lie.", "Don't take the lion's tickets.", "Welcome to the circus. You're the show.", "Please do not feed the acrobats."],
	["Biloxi! Where the sharks are gentlemen.", "Hard Rok: it's loud, it's pricey, it's a guitar.", "I paid fifteen bucks for a pick. I don't play.", "The drums are for decoration. Mostly.", "A bad beat sounds like a power chord.", "Hey! Don't touch the Elvis suit!", "Everybody here lost their voice.", "I came for the show. I stayed for the cover charge.", "Rock and roll never dies. My bankroll did.", "They serve a burger shaped like an amp.", "This riff is a threat.", "The coat check costs more than the room."],
	["Fremont! Old Vegas! Old money! Old vice!", "The Goldun Nugget's got a shark tank. It's decorative.", "Gold! Everything's gold! Even the toilets!", "I haven't seen daylight since the Clinton administration.", "The neon is older than I am.", "They don't make casinos like this anymore. Thank God.", "I lost a gold bar. I wasn't even playing.", "A glass of champagne? That's a hundred. Please.", "Welcome to the old days. They weren't better.", "The nugget in the lobby is fake. So is the man guarding it.", "Don't stare at the chandelier. It judges.", "Ten thousand dollars on red. On red!"],
	["The Strip! The nicest casino in the nicest town!", "The Bellagiro fountain! It dances! It judges!", "I lost a diamond ring on a hand of blackjack.", "Everything here costs a hundred dollars. Even the air.", "Don't stare at the High Roller. He bites.", "Fine art. Fine wine. Fine print.", "Sir, this is a Wendy's. Just kidding. It's a palace.", "The chandelier is a quarter-million. Don't sneeze.", "Welcome to the top. It's lonely.", "I haven't seen my family in six years. The poker's good.", "They serve a hundred-dollar water. It's the same water.", "The House is watching. Behave."],
]

## Extra scripted scenes (cutscene id -> lines [speaker, text]). Voice files live in
## voice/_cutscenes/<scene>/<scene>_<n>.ogg. The game plays these when you arrive in a
## new city, and in the secret-boss and ending beats.
const SCENES := {
	"city1_arrive": [["RICO", "Atlantic Shitty. Salt, rust and slot machines. I love it already."], ["MARLOW", "Rico, you're in an alley. The casino's a block up. Start walking, and don't touch anything wet."], ["RICO", "Everything's wet, Marlow. That's the whole city."]],
	"city2_arrive": [["RICO", "Reno. The biggest little city. And that's a clown."], ["MARLOW", "That's the doorman. Smile. Don't get close."], ["VERA", "Welcome to the circus, sugar. Nobody leaves with their dignity."]],
	"city3_arrive": [["RICO", "Biloxi. Sharks in the lobby. Guitars on the wall. This is my kind of mistake."], ["MARLOW", "Hard Rok keeps the heavies near the stage. Stay quiet."], ["RICO", "Quiet's not really my instrument."]],
	"city4_arrive": [["RICO", "Fremont, Old Vegas. Neon older than my debt."], ["MARLOW", "Goldun Nugget's got a vault down below. Everyone wants in. Nobody gets out."], ["MAGS", "I'll see you at the vault, kid. With a calculator."]],
	"city5_arrive": [["RICO", "The Strip. The nicest casino in the world. And I'm covered in alley."], ["SILAS", "Dear boy, the cloak room is that way. We shall do what we can."], ["THE HOUSE", "Welcome, Rico. We've been expecting you. For years."]],
	"secret_found": [["RICO", "A hidden room? A secret table? The House is hiding something."], ["MARLOW", "That's not on the map, Rico. Be careful in there."]],
	"secret_defeat": [["RICO", "Another secret down. Another stack of chips."], ["MARLOW", "You're not supposed to know about those rooms. The House won't like it."], ["RICO", "Good."]],
	"final_prelude": [["THE HOUSE", "You climbed my five cities. You beat my table-lords. You wore my clothes."], ["RICO", "And I still got a bet on you."], ["THE HOUSE", "Then sit. Hole cards. Flop. Turn. River."]],
}
