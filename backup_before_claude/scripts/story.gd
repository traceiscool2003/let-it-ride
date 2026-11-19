extends RefCounted
## Story text. Speakers: ROOK (you), MARLOW (your fixer, on the radio),
## and the three bosses of The Pit. Each line is [speaker, text].

const INTRO := [
	["ROOK", "They call it The Pit. Twelve floors of dirty money, buried under the city."],
	["ROOK", "Three years ago my brother Jules sat down at its tables. He never came back up."],
	["MARLOW", "Radio check. You hear me, Rook? Every chip you grab rides in your Pot."],
	["MARLOW", "At each door you bank it, or you let it ride for double. Bust down there and it's gone."],
	["MARLOW", "Keep moving. Chain your moves. The House pays out to style."],
	["ROOK", "Twelve floors. Three bosses. One brother. Deal me in."],
]

const RADIO := [
	["MARLOW", "Same deal as always, Rook. Grab, run, don't get cute."],
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
		["ROOK", "Your boss took my brother. I'm taking it back. With interest."],
		["BIG SAL", "Cute. Let's see you dance."],
	],
	2: [
		["MADAME ROULETTE", "Round and round, little runner. Where it stops... nobody knows."],
		["ROOK", "Where's Jules?"],
		["MADAME ROULETTE", "Spin the wheel and find out, darling."],
	],
	3: [
		["THE HOUSE", "Every gambler comes home to me eventually. Your brother did."],
		["THE HOUSE", "He bet everything. He lost. Now he deals at my tables, forever."],
		["ROOK", "Then I'm cashing him out."],
	],
}

const BOSS_PHASE := {
	1: "NOBODY makes Sal sweat!",
	2: "Faites vos jeux! Place your final bets!",
	3: "The odds were never in your favor.",
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
	["ROOK", "The vault door groans open. Behind it, a man shuffling cards in the dark."],
	["JULES", "...Rook? You came down here? For me?"],
	["ROOK", "Somebody had to cash you out. Come on. We're going home."],
	["MARLOW", "Rook... the floor's still going down. There's more Pit below The Pit."],
	["ROOK", "...Let it ride."],
]

const DEATH_QUIPS := [
	"\"You'll be back. They always come back.\" - Marlow",
	"\"Should've banked it, kid.\" - Marlow",
	"\"The House thanks you for your business.\"",
	"\"Greed's a heavy coat. Hard to run in.\" - Marlow",
	"\"Dust yourself off. Jules is still down there.\" - Marlow",
	"\"Every bust is a lesson. Expensive lesson.\" - Marlow",
]

const WHISPERS := [
	"The chips are still warm here.",
	"Somewhere below, a roulette wheel is spinning.",
	"The air smells like cigars and bad decisions.",
	"A slot machine sings to nobody.",
	"Footsteps. Heavy ones.",
	"Someone carved JULES WAS HERE into the wall.",
	"The deeper you go, the louder the House gets.",
]
