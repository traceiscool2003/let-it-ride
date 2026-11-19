extends RefCounted
## Story text. Speakers: RICO (you), MARLOW (your fixer, on the radio), MAGS, THE HOUSE.
## THE STORY: Rico climbs five casinos (Atlantic Shitty -> Bellagiro) to win back his
## brother Jules from The House. Each line is [speaker, text].

## Plays the first time you enter the Lobby (Rico's apartment). KEEP the speaker order.
const INTRO := [
	["RICO", "My brother Jules sat down at The House's table and bet himself. Then he lost, which means he now works there, which means my family finally has a steady job."],
	["RICO", "So the plan is to climb five casinos, from a dumpster in Atlantic Shitty to the Strip, and win him back. I've bet on worse things. Mostly myself."],
	["MAGS", "Nobody climbs without a Marker, kid. Sign here, and here, and there. Don't read it, sweetie. Don't think of it as debt. Think of it as a very close relationship that I own."],
	["THE HOUSE", "Welcome, valued guest. Per your Marker, you cannot die. You simply wake up at home, owing a little more. Think of it as a loyalty program with no rewards."],
	["RICO", "So... infinite credit? I can't die, I just owe more? I've been training for this my entire life."],
	["THE HOUSE", "We hoped you'd say that. It's in the brochure under 'Fine Print.'"],
	["MARLOW", "Radio check, Rico. The House keeps Jules at the top of the Bellagiro, on the Strip. Every chip you grab rides in your Pot, and at each door you bank it or let it ride for double. You'll let it ride. You always let it ride."],
	["MARLOW", "Now get in that heap you call a car. The goal, in plain English: climb five casinos, get Jules, and try very hard not to bet him."],
]

## Character introductions during the opening cutscene.
const CAST := {
	"VERA": ["VERA", "I'm Vera. I deal the cards and sell the charms. Bring me something shiny and I'll bend the odds your way, and no, I won't tell you what they're bending against."],
	"LUCKY": ["LUCKY", "Name's Lucky. I run a bar on most floors, and a drink can save your life, runner. I also run a betting pool on how you die, so please, order the second one."],
}

## Random radio chatter between floors (one recap per city is in STORY_SO_FAR).
const RADIO := [
	["MARLOW", "Same deal as always, Rico. Grab the chips, run for the door, and don't get cute. You'll get cute. I've made peace with it, and a little bit of a will."],
	["MARLOW", "Word is security doubled. When a big lug winds up, parry him. Or just die and wake up at home. It's free, in the sense that Mags is billing you."],
	["MARLOW", "Good news, Jules is alive. Bad news, he's one casino ahead of you, and I got him the job. I'll explain that part later. Or never. Probably never."],
	["MARLOW", "Slot machines on every floor. Bet the Pot if you're feeling lucky. I wouldn't, but I'm broke, so take that as research."],
	["MARLOW", "Smash the glass, smash the crates, grab whatever falls out. Insurance won't cover it, but you will, in the sense that you'll be the one dying."],
	["MARLOW", "Jules left a trail of IOUs up the whole coast. Follow the money and you'll find him, or a very tired accountant holding about forty of them."],
	["MARLOW", "Back again? The Fence has new toys if you've banked enough. He also has a new face. Stop asking, Rico. Nobody wants to know how."],
]

const FIRST_EXIT := [
	["MARLOW", "First door. Cash out and that money is yours forever, which in this town means The Fence will gladly take it off your hands for a very fair price. He sets the price."],
	["MARLOW", "Or let it ride for double the multiplier, and the House adds a rule. Your call, high roller. It's your funeral, but let's be honest, it's also a Tuesday."],
]

## Boss intros/defeats per tier are generated per boss from boss_defs.gd. These are the
## FALLBACKS only (used when a def has no lines). Bosses are randomized every run.
const BOSS_INTRO := {
	1: [
		["BOSS", "A fresh gambler at my table. How refreshing. I was getting so bored of winning slowly."],
		["RICO", "I'm looking for my brother, and a quick win. Mostly the brother, but the win would really help."],
		["BOSS", "Everyone's looking for something, pal. Most of them find me, and then they stop looking for anything."],
	],
	2: [
		["BOSS", "You made it past my floor guards. Impressive. Also, a huge HR problem, because I'm the one who has to file the paperwork."],
		["RICO", "Where's Jules?"],
		["BOSS", "Beat me and I'll tell you. Lose and I'll tell your landlord, and he's way scarier than me, because he's owed money by you."],
	],
	3: [
		["THE HOUSE", "Every gambler comes home to me eventually, Rico. Your brother did, and he was so excited to sign up."],
		["THE HOUSE", "He bet himself and lost, so now he deals at my tables, at the top of my casino. His performance reviews are stellar, by the way."],
		["RICO", "Then I'm cashing him out. Hope your return policy is better than your carpets."],
	],
}

## Generic (non-final) boss phase-change shouts.
const BOSS_PHASE := {
	1: "You'll never leave this table! It's in your Marker, page nine!",
	2: "Place your final bets, rookie! Your first ones were already terrible!",
	3: "I fold! Your face! Into the carpet!",
}

## Shouted when a boss drops below a quarter health (phase 3).
const BOSS_PHASE3 := {
	1: "That's it! No more Mr. Nice Dealer! I'm cutting you off from the free drinks!",
	2: "Nobody walks away from my table, rookie! That's a policy! It's laminated!",
	3: "All in, Rico! All of it! Including him! Especially him!",
}

const BOSS_DEFEAT := {
	1: [
		["BOSS", "Ugh... the next casino will bury you... and they have much better dental..."],
		["MARLOW", "That's the boss down! Grab what he dropped and get to the door before he files an appeal."],
	],
	2: [
		["BOSS", "Tell the House I did my best... on a very decent salary... with no dental..."],
		["MARLOW", "Two for two. Now keep climbing, and try not to celebrate by gambling. You'll celebrate by gambling."],
	],
	3: [
		["THE HOUSE", "Impossible. The House always wins. It's in the name. It's on the mugs."],
	],
}

## The story beat each city tells (spoken in the city's _arrive and _clue scenes).
## Shown as one line in the pause menu, per city reached.
const STORY_SO_FAR := [
	"Jules bet himself at The House's table and lost, and now he works for The House. Rico climbs five casinos to win him back. Start: Atlantic Shitty.",
	"Jules's jacket turned up in Atlantic Shitty with a Reno pawn ticket in the pocket, and the boss was holding his first IOU. The trail says: he went to Reno.",
	"Jules pawned his watch in Reno and got 'promoted' to Biloxi. The House has him on the payroll, apparently with a dental plan.",
	"Marlow admitted in Biloxi that he got Jules his seat at The House's table. Rico is furious, and also still needs him on the radio.",
	"In Fremont, Rico found a note in Jules's handwriting: 'Don't come for me. I'm finally winning.' Rico read it twice. It was relatable.",
	"The Bellagiro penthouse. The House challenges Rico to Texas Hold'em, with Jules as the pot. No pressure.",
]

const ENDING := [
	["RICO", "The House folds, and the penthouse goes quiet. At the far table, a man in a vest keeps dealing cards to nobody. My brother, Jules, still winning."],
	["JULES", "Rico? You climbed five casinos for me? That's so sweet, but I'm up eleven grand and I'm on a RUN, so can you wait like ten minutes?"],
	["RICO", "Jules, you have to cash out. Walk away from a winning table. I know, I've never done it either, but it only works if you choose it."],
	["MARLOW", "Rico, I've seen a lot of men walk away from a table, and exactly zero of them were happy about it. Be gentle with him, he's basically a cat."],
	["RICO", "Look, I'm the last guy who should say this. I once bet my shoes, won the bet, and lost the shoes. I'm not a role model. Come home."],
	["JULES", "...Okay. Okay. One last chip, and I'm cashing out. It feels like falling, but the good kind, where someone catches you."],
	["RICO", "Welcome home, brother. ...So, one more run? For fun? Just a little one?"],
	["MARLOW", "Rico, you absolute lunatic, the top of the Bellagiro is a casino, you can't just do another lap. ...Fine. High Roller mode is open. Let it ride, kid."],
]

## The first time Mags comes collecting on a late loan.
const MAGS_CHASE := [
	["MAGS", "Payday, kid. You're late, and I hate late. Late is when your debt gets a growth spurt, and I'm so proud of how big it's getting."],
	["RICO", "...Can we talk about this?"],
	["MAGS", "We ARE talking, sweetie. This is me talking. The swimming is me collecting. Cash out and pay me, or keep running, because I love watching my little investment run."],
]

## Plays when you beat The House again after finding every Losing Ticket,
## freeing Vera, and hearing Marlow's confession. (Top of the Bellagiro.)
const TRUE_ENDING := [
	["THE HOUSE", "You beat me AGAIN? Fine. Double or nothing, one more hand. Rico? Are you listening? Rico, this is a Platinum-tier offer."],
	["RICO", "No. I read your tickets, Eddie Duval. All twenty of them. Your handwriting is somehow worse than Jules's, and he writes with his elbow."],
	["THE HOUSE", "...Nobody has called me that in twenty years. I had to check the name tag."],
	["RICO", "You never learned to walk away, so I'm teaching you. Cash out, Eddie. Take the win. It's like a refund, but for your whole life."],
	["THE HOUSE", "If I stop playing, what's left of me? A very expensive suit with a loyalty program?"],
	["VERA", "Whatever you were before the tables, Eddie, that's what's left, and it's enough. Also, you freed me, so the hat is half off."],
	["THE HOUSE", "...Cashing out. Huh. It feels like falling. The good kind, where the floor is a really nice carpet."],
	["MARLOW", "Rico, the lights just went warm at the top of the Bellagiro. Every Marker in the apartment burned up at once. Everyone's free, including me, which is terrifying."],
	["RICO", "Even my debt? ...That's disappointing. It was my longest relationship."],
	["MARLOW", "Course not, it's still a casino. It's just ours now. Let it ride, kid."],
]

const DEATH_QUIPS := [
	"\"Dying's just a bad beat with extra steps.\" - Rico",
	"\"Next time I go all in on a better plan. Or the same plan, but louder.\" - Rico",
	"\"You'll be back. They always come back. It's the Marker, not your charm.\" - Marlow",
	"\"You should've banked it, kid. You'll never bank it. Next time, bank it.\" - Marlow",
	"\"The House thanks you for your business. And your teeth. Mostly your teeth.\"",
	"\"Greed's a heavy coat. It's hard to run in and easy to die in.\" - Marlow",
	"\"Dust yourself off. Jules is still at the top of the Bellagiro, and he's still not leaving.\" - Marlow",
	"\"Every bust is a lesson, and the tuition is your organs.\" - Marlow",
	"\"Rico: 1 life, 0 savings, infinite credit.\" - The Marker",
	"\"You wake up at home, owing more. That's not a bug, sweetie, that's my favorite feature.\" - Mags",
]

const WHISPERS := [
	"Somewhere on this floor, someone is losing their shirt. Statistically, it's yours.",
	"The odds are 1 in 3, and you have never once believed that, which is why you keep playing.",
	"The chips on the floor are still warm. So is the guy next to them.",
	"Somewhere above you, a roulette wheel is spinning, and it sounds like it's mocking you in French.",
	"The air smells like cigars and bad decisions, and one of them is yours.",
	"A slot machine sings to nobody. It's a very sad little jingle about a man named Dave.",
	"Heavy footsteps are coming. It's probably security. It's possibly a clown. Both are armed.",
	"Someone carved JULES WAS HERE into the wall. Underneath, in different handwriting: 'AND HE LOST.'",
	"The higher you climb, the louder the House gets, and the more it sounds like it's reading your credit report.",
	"Your Marker whispers: 'Hey. About that interest. No rush. Rush a little.'",
]
