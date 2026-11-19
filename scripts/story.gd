extends RefCounted
## Story text. Speakers: RICO (you), MARLOW (your fixer, on the radio), MAGS, THE HOUSE.
## THE STORY: Rico climbs five casinos (Atlantic Shitty -> Bellagiro) to win back his
## brother Jules from The House. Each line is [speaker, text].

## Plays the first time you enter the Lobby (Rico's apartment). KEEP the speaker order.
const INTRO := [
	["RICO", "My brother Jules sat down at The House's table and bet himself. And lost. Now he works there. It's the most Jules thing that has ever happened."],
	["RICO", "So here's the plan: climb five casinos, from a dumpster to the Vegas Strip, and win him back. I've bet on worse. I've bet on myself. That was worse."],
	["MAGS", "Nobody climbs without a Marker, kid. Sign here. And here. And... there. Don't read it. Don't think of it as debt, sweetie. Think of it as a relationship."],
	["THE HOUSE", "Welcome, valued guest. House rules: you can't die. You simply wake up back at home, owing a little more. With interest."],
	["RICO", "So... infinite credit? Can't die, just owe more. I've been training for this my whole life."],
	["THE HOUSE", "Now you're getting it."],
	["MARLOW", "Radio check, Rico. Jules is at the top of the Bellagiro, on the Strip. Every chip you grab rides in your Pot. At each door you bank it, or let it ride for double. You'll let it ride. You always let it ride."],
	["MARLOW", "Wear something. Anything. Then get in that heap you call a car. The goal, in plain English: climb five casinos, get Jules, try not to bet him."],
]

## Character introductions during the opening cutscene.
const CAST := {
	"VERA": ["VERA", "New face. I deal the cards and sell the charms. Bring me something shiny and I'll make the odds lean your way. Don't ask what they're leaning on."],
	"LUCKY": ["LUCKY", "Lucky's the name. I keep a bar on most floors. A drink can save your life, runner. A second one can end it. I'm a bartender, not a prophet."],
}

## Random radio chatter between floors (one recap per city is in STORY_SO_FAR).
const RADIO := [
	["MARLOW", "Same deal as always, Rico. Grab, run, don't get cute. You'll get cute. I've made peace with it."],
	["MARLOW", "Word is security doubled. Parry the big lugs when they wind up. Or just die. It's free."],
	["MARLOW", "You know what they say: the House always wins. So stop being the House's favorite guest."],
	["MARLOW", "Slot machines on every floor. Bet the Pot if you're feeling lucky. I wouldn't. I'm broke. Correlation."],
	["MARLOW", "Smash the glass, smash the crates. Insurance won't cover it, but you will. Barely."],
	["MARLOW", "Jules left a trail of IOUs up the whole coast. Follow the money and you'll find him. Or a very sad accountant."],
	["MARLOW", "Back again? The Fence has new toys if you've banked enough. Also the Fence has a new face. Stop looking."],
]

const FIRST_EXIT := [
	["MARLOW", "First door. Cash out and that money is yours forever, and The Fence will take it. Yes, that's the joke."],
	["MARLOW", "Or let it ride: double the multiplier, but the House adds a rule. Your call, high roller. Your funeral. Your call."],
]

## Boss intros/defeats per tier are generated per boss from boss_defs.gd. These are the
## FALLBACKS only (used when a def has no lines). Bosses are randomized every run.
const BOSS_INTRO := {
	1: [
		["BOSS", "A new gambler at my table. How refreshing. How edible."],
		["RICO", "I'm looking for my brother. And a quick win. Mostly the brother."],
		["BOSS", "Everyone's looking for something. Most of them find me."],
	],
	2: [
		["BOSS", "You made it past my floor guards. Impressive. Also, an HR nightmare."],
		["RICO", "Where's Jules?"],
		["BOSS", "Win and I'll tell you. Lose and I'll tell your landlord."],
	],
	3: [
		["THE HOUSE", "Every gambler comes home to me eventually. Your brother did."],
		["THE HOUSE", "He bet himself. He lost. Now he deals at my tables. At the top of my casino."],
		["RICO", "Then I'm cashing him out."],
	],
}

## Generic (non-final) boss phase-change shouts.
const BOSS_PHASE := {
	1: "You'll NEVER leave this table!",
	2: "Place your final bets, rookie!",
	3: "I fold. YOUR face. Into the carpet.",
}

## Shouted when a boss drops below a quarter health (phase 3).
const BOSS_PHASE3 := {
	1: "That's it! NO MORE MR. NICE DEALER!",
	2: "Nobody walks away from my table, rookie!",
	3: "All in, Rico. All of it. Including him.",
}

const BOSS_DEFEAT := {
	1: [
		["BOSS", "Ugh... the next casino... they'll bury you..."],
		["MARLOW", "That's the boss down! Grab what he dropped and get to the door."],
	],
	2: [
		["BOSS", "Tell the House... I did my best... on a decent salary..."],
		["MARLOW", "Two for two. Now keep climbing."],
	],
	3: [
		["THE HOUSE", "Impossible... the House... always... wins..."],
	],
}

## The story beat each city tells (spoken in the city's _arrive and _clue scenes).
## Shown as one line in the pause menu, per city reached.
const STORY_SO_FAR := [
	"Jules bet himself at The House's table and lost. Rico climbs five casinos to win him back. Start: Atlantic Shitty.",
	"Jules's jacket turned up in Atlantic Shitty. The IOU says: he went to Reno.",
	"Jules pawned his watch in Reno and got 'promoted' to Biloxi. He's dealing for The House now.",
	"Marlow got Jules his seat at The House. He confessed in Biloxi. Rico's still mad. Rico still needs him.",
	"A note in Jules's handwriting in Fremont: 'Don't come for me. I'm finally winning.' Rico: that's relatable.",
	"The penthouse. The House put Jules up as the pot. Texas Hold'em, top of the Bellagiro.",
]

const ENDING := [
	["RICO", "The House folds. The penthouse goes quiet. At the far table, a man in a vest keeps dealing to nobody. My brother. Still winning."],
	["JULES", "...Rico? You climbed five casinos for me? I'm up eleven grand! I'm on a RUN!"],
	["RICO", "Jules. Cash out. Walk away from a winning table. I know. I've never done it either. Do it for me."],
	["MARLOW", "Rico, I've seen a lot of men walk away from a table. Zero of them were happy about it. Be gentle."],
	["RICO", "Look, I'm the last guy who gets to say this. I once bet my shoes. Won the bet. Lost the shoes. I'm not a role model. Come home."],
	["JULES", "...Okay. Okay. One last chip. I'm cashing out. It feels like falling. The good kind."],
	["RICO", "Welcome home. ...So, one more run? For fun?"],
	["MARLOW", "Rico, you absolute lunatic. The top of the Bellagiro is a casino. You can't just do another lap. ...Fine. Let it ride, kid."],
]

## The first time Mags comes collecting on a late loan.
const MAGS_CHASE := [
	["MAGS", "Payday, kid. You're late. I hate late. Late is where I grow."],
	["RICO", "...Can we talk about this?"],
	["MAGS", "We ARE talking. This is me talking. The swimming is me collecting. Cash out and pay me, or keep running. I like running. It builds appetite."],
]

## Plays when you beat The House again after finding every Losing Ticket,
## freeing Vera, and hearing Marlow's confession. (Top of the Bellagiro.)
const TRUE_ENDING := [
	["THE HOUSE", "Again? You beat me AGAIN? Fine. Double or nothing. One more hand. Rico? Are you listening? Rico?"],
	["RICO", "No. I read your tickets, Eddie. All twenty of them. Your handwriting's worse than Jules's."],
	["THE HOUSE", "...Nobody has called me that in twenty years."],
	["RICO", "You never learned to walk away. So I'm teaching you. Cash out, Eddie. Take the win."],
	["THE HOUSE", "If I stop playing... what's left of me? A very expensive suit?"],
	["VERA", "Whatever you were before the tables, Eddie. That's what's left. It's enough. And I'll sell you a hat."],
	["THE HOUSE", "...Cashing out. Huh. It feels like falling. The good kind."],
	["MARLOW", "Rico, the lights just went warm at the top of the Bellagiro. Every Marker in the apartment burned up at once. Everyone's free."],
	["RICO", "Even my debt? ...That's disappointing. It was my longest relationship."],
	["MARLOW", "Course not. It's still a casino. Now it's ours. Let it ride, kid."],
]

const DEATH_QUIPS := [
	"\"Dying's just a bad beat with extra steps.\" - Rico",
	"\"Next time I go all in on a better plan. Or the same plan.\" - Rico",
	"\"You'll be back. They always come back. It's mostly the Marker.\" - Marlow",
	"\"Should've banked it, kid. You'll never bank it. Bank it.\" - Marlow",
	"\"The House thanks you for your business. And your teeth.\"",
	"\"Greed's a heavy coat. Hard to run in. Easy to die in.\" - Marlow",
	"\"Dust yourself off. Jules is still at the top of the Bellagiro.\" - Marlow",
	"\"Every bust is a lesson. Expensive lesson. Tuition's your organs.\" - Marlow",
	"\"Rico: 1 life, 0 savings, infinite credit.\" - The Marker",
	"\"You wake up at home. Owing more. That's not a bug.\" - Mags",
]

const WHISPERS := [
	"Somewhere, someone is losing their shirt. Maybe yours.",
	"The odds are 1 in 3. You've never once believed that.",
	"The chips are still warm here. So is a nearby corpse.",
	"Somewhere above you, a roulette wheel is spinning. It's mocking you in French.",
	"The air smells like cigars and bad decisions.",
	"A slot machine sings to nobody. A very sad little jingle.",
	"Footsteps. Heavy ones. Probably security. Probably a clown.",
	"Someone carved JULES WAS HERE into the wall. Underneath: 'AND HE LOST.'",
	"The higher you climb, the louder the House gets.",
	"Your Marker whispers: 'Hey. About that interest.'",
]
