extends RefCounted
## Story text. Speakers: RICO (you), MARLOW (your fixer, on the radio),
## and the three bosses of The Pit. Each line is [speaker, text].

## Plays the first time you enter the Lobby.
const INTRO := [
	["RICO", "Five cities. Twenty-five floors. One long climb from a dumpster to the nicest casino in Vegas. I've bet on worse."],
	["RICO", "My brother Jules sat down at the House's table three years ago. He never got up. Somebody has to cash him out. Might as well be the guy with no impulse control."],
	["MAGS", "Nobody climbs without a Marker, kid. Sign here. And here. And... there. Don't read it. Nobody reads it."],
	["THE HOUSE", "Welcome, valued guest. House rules: no one dies owing the House. Bust, and you wake up right here. With interest."],
	["RICO", "So I can't die. I just owe you forever. Honestly? Best terms I've ever been offered."],
	["THE HOUSE", "Now you're getting it."],
	["MARLOW", "Radio check, Rico. Every chip you grab rides in your Pot. At each door you bank it, or let it ride for double. You'll let it ride. You always let it ride."],
	["MARLOW", "Talk to the folks up here between runs. Wear something. Anything. When you're ready, get in that heap you call a car at the end of the block. And Rico: please don't bet the shoes."],
]

## Character introductions during the opening cutscene.
const CAST := {
	"VERA": ["VERA", "New face. I deal the cards and sell the charms. Bring me something shiny and I'll make the odds lean your way."],
	"LUCKY": ["LUCKY", "Lucky's the name. Down there I keep a bar on most floors. A drink can save your life, runner."],
}

const RADIO := [
	["MARLOW", "Same deal as always, Rico. Grab, run, don't get cute."],
	["MARLOW", "Word is Sal's been doubling security. Parry the big lugs when they wind up."],
	["MARLOW", "You know what they say: the House always wins. So stop being the House's guest."],
	["MARLOW", "Slot machines on every floor. Bet the Pot if you're feeling lucky. I wouldn't."],
	["MARLOW", "Smash the glass, smash the crates. Insurance won't cover it, but you will."],
	["MARLOW", "Jules left a trail of IOUs down there. Follow the money and you'll find him."],
	["MARLOW", "Back again? The Fence has new toys if you've banked enough."],
]

const FIRST_EXIT := [
	["MARLOW", "First door. Cash out and that money is yours forever, and The Fence will take it."],
	["MARLOW", "Or let it ride: double the multiplier, but the House adds a rule. Your call, high roller."],
]

const BOSS_INTRO := {
	1: [
		["BIG SAL", "So you're the rat tripping my alarms. Nobody walks outta The Pit, kid."],
		["RICO", "Your boss took my brother. I'm taking it back. With interest."],
		["BIG SAL", "Cute. Let's see you dance."],
	],
	2: [
		["MADAME ROULETTE", "Round and round, little runner. Where it stops... nobody knows."],
		["RICO", "Where's Jules?"],
		["MADAME ROULETTE", "Spin the wheel and find out, darling."],
	],
	3: [
		["THE HOUSE", "Every gambler comes home to me eventually. Your brother did."],
		["THE HOUSE", "He bet everything. He lost. Now he deals at my tables, forever."],
		["RICO", "Then I'm cashing him out."],
	],
}

const BOSS_PHASE := {
	1: "NOBODY makes Sal sweat!",
	2: "Faites vos jeux! Place your final bets!",
	3: "The odds were never in your favor.",
}

## Shouted when a boss drops below a quarter health (phase 3).
const BOSS_PHASE3 := {
	1: "That's it! NO MORE MR. NICE SAL!",
	2: "Rien ne va plus! No more bets!",
	3: "You want to see what's under the mask? JACKPOT.",
}

const BOSS_DEFEAT := {
	1: [
		["BIG SAL", "Ugh... the Croupier... she'll deal you out..."],
		["MARLOW", "Sal's down! Grab what he dropped and get to the door."],
	],
	2: [
		["MADAME ROULETTE", "Black... it was always going to be black..."],
		["MADAME ROULETTE", "The House is watching, darling. It always is."],
	],
	3: [
		["THE HOUSE", "Impossible... the House... always... wins..."],
	],
}

const ENDING := [
	["RICO", "The vault door groans open. Behind it, a man shuffling cards in the dark."],
	["JULES", "...Rico? You came down here? For me?"],
	["RICO", "Somebody had to cash you out. Come on. We're going home."],
	["MARLOW", "Rico... the floor's still going down. There's more Pit below The Pit."],
	["RICO", "...Let it ride."],
]

## The first time Mags comes collecting on a late loan.
const MAGS_CHASE := [
	["MAGS", "Payday, kid. You're late. I hate late."],
	["RICO", "...Can we talk about this?"],
	["MAGS", "We ARE talking. This is me talking. The swimming is me collecting. Cash out and pay me, or keep running."],
]

## Plays when you beat The House again after finding every Losing Ticket,
## freeing Vera, and hearing Marlow's confession.
const TRUE_ENDING := [
	["THE HOUSE", "Again? You beat me AGAIN? Fine. Double or nothing. One more hand."],
	["RICO", "No. I read your tickets, Eddie. All twenty of them."],
	["THE HOUSE", "...Nobody has called me that in twenty years."],
	["RICO", "You never learned to walk away. So I'm teaching you. Cash out, Eddie. Take the win."],
	["THE HOUSE", "If I stop playing... what's left of me?"],
	["VERA", "Whatever you were before the tables, Eddie. That's what's left. It's enough."],
	["THE HOUSE", "...Cashing out. Huh. It feels like falling. The good kind."],
	["MARLOW", "Rico, the lights just went warm up here. Every Marker in the Lobby burned up at once. Everyone's free."],
	["RICO", "The floors are still down there, though."],
	["MARLOW", "Course they are. It's still a casino. Now it's ours. Let it ride, kid."],
]

const DEATH_QUIPS := [
	"\"Dying's just a bad beat with extra steps.\" - Rico",
	"\"Next time I go all in on a better plan. Or the same plan.\" - Rico",
	"\"You'll be back. They always come back.\" - Marlow",
	"\"Should've banked it, kid.\" - Marlow",
	"\"The House thanks you for your business.\"",
	"\"Greed's a heavy coat. Hard to run in.\" - Marlow",
	"\"Dust yourself off. Jules is still down there.\" - Marlow",
	"\"Every bust is a lesson. Expensive lesson.\" - Marlow",
]

const WHISPERS := [
	"Somewhere, someone is losing their shirt. Maybe yours.",
	"The odds are 1 in 3. You've never once believed that.",
	"The chips are still warm here.",
	"Somewhere below, a roulette wheel is spinning.",
	"The air smells like cigars and bad decisions.",
	"A slot machine sings to nobody.",
	"Footsteps. Heavy ones.",
	"Someone carved JULES WAS HERE into the wall.",
	"The deeper you go, the louder the House gets.",
]
