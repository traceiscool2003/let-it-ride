extends RefCounted
## Bosses are table games. Bosses 1-4 are drawn at random each run from POOL;
## the final boss is always THE HOUSE playing Texas Hold'em (floor 25).
## Every boss has a FIXED, learnable attack cycle per phase ("deck"). Attacks are
## named after hands in its game; each telegraphs with a label and the "!".
##
## Attack ids (boss.gd): deal (the game's card volley), charge, slam, balls, summon,
## rain, wheel, jackpot. `deal` uses the boss's "deal" params:
##   n cards, spread (rad), speed, aim (bool), volleys, arc (lobbed), floor (low shots)
## Parody names only: the site names are deliberately a little off.

const POOL := [
	{"id": "draftqueens", "name": "DRAFTQUEENS", "title": "Five Card Draw", "game": "FIVE CARD DRAW", "tier": 1, "hp": 22, "col": Color(0.75, 0.2, 0.85),
		"deal": {"n": 5, "spread": 0.2, "speed": 185.0, "aim": true, "volleys": 1, "label": "DRAW FIVE!"},
		"deck": [["deal", "slam", "deal", "charge"], ["deal", "charge", "deal", "slam", "rain"], ["deal", "rain", "charge", "deal", "slam", "rain"]],
		"line_intro": "Five cards, and you can discard any you don't like. I'll start by discarding your face, and then we'll see how the rest of you draws.", "line_defeat": "I had a pat hand! I stood pat, like the book says! The book is also why I'm losing my fantasy league.",
			"rico_intro": "Five Card Draw? I've drawn worse. Last month I drew my landlord, and he had four aces and a lease.", "rico_defeat": "You drafted a loser, buddy, and the loser is me, and I'm keeping the pot. Fair trade.",
		"music": {"bpm": 150, "root": 55.0, "mode": "minor", "lead": "saw"}},
	{"id": "fandool", "name": "FANDOOL", "title": "Seven Card Stud", "game": "SEVEN CARD STUD", "tier": 1, "hp": 24, "col": Color(0.2, 0.55, 0.95),
		"deal": {"n": 7, "spread": 0.13, "speed": 170.0, "aim": true, "volleys": 2, "label": "SEVEN-STREET!"},
		"deck": [["deal", "charge", "slam"], ["deal", "slam", "deal", "charge"], ["deal", "jackpot", "charge", "deal", "slam"]],
		"line_intro": "Seven Card Stud: three cards down, four up, so everything you do is face up. Including the begging, which I'm already looking forward to.", "line_defeat": "The river wasn't supposed to bleed. In stud there IS no river! I'm hallucinating my own defeat!",
			"rico_intro": "Seven Card Stud? Cute. My last seven-card stud was a Tuesday and a cry for help, and I lost both.", "rico_defeat": "Call it, because I'm done. I'll watch the highlight reel of me, winning, on a loop. Alone.",
		"music": {"bpm": 156, "root": 49.0, "mode": "minor", "lead": "square"}},
	{"id": "pokerstarz", "name": "POKERSTARZ", "title": "Omaha Hi-Lo", "game": "OMAHA", "tier": 2, "hp": 30, "col": Color(0.95, 0.35, 0.3),
		"deal": {"n": 4, "spread": 0.5, "speed": 200.0, "aim": false, "volleys": 2, "arc": true, "label": "FOUR HOLE CARDS!"},
		"deck": [["deal", "balls", "slam"], ["deal", "slam", "balls", "charge"], ["deal", "wheel", "slam", "balls", "charge"]],
		"line_intro": "Omaha: four hole cards, and you have to use exactly two. Same as your funeral, where you'll get four mourners and use two of them as pallbearers.", "line_defeat": "Split pot, and I get the low half, which is nothing. Chat, am I cooked? Chat? Why is nobody typing?",
			"rico_intro": "Omaha? Four hole cards? That's four problems, Rico, and I've already got four, plus a pair of shoes I can't afford.", "rico_defeat": "You're a content creator and I'm the main character, so thanks for the extra screen time. Don't forget to subscribe to my debt.",
		"music": {"bpm": 160, "root": 43.65, "mode": "phrygian", "lead": "saw"}},
	{"id": "betmgn", "name": "BETMGN", "title": "Three Card Poker", "game": "THREE CARD POKER", "tier": 2, "hp": 28, "col": Color(0.95, 0.75, 0.2),
		"deal": {"n": 3, "spread": 0.12, "speed": 260.0, "aim": true, "volleys": 3, "label": "PAIR PLUS!"},
		"deck": [["deal", "charge", "deal"], ["deal", "slam", "charge", "deal"], ["deal", "charge", "slam", "deal", "rain"]],
		"line_intro": "Three Card Poker: three cards, ante up, and it's over so fast it'll feel like your last relationship. Quick, painless, and ending with a lawyer.", "line_defeat": "Queen high. Of course. I had the commission on the table! I had the commission and I had a plan!",
			"rico_intro": "Three Card Poker? Fast game, perfect for a man with no attention span and no savings. I'm a very efficient disaster.", "rico_defeat": "Pair plus? I'll take the pair, and you can have the plus, and it comes with an ambulance. Please enjoy it.",
		"music": {"bpm": 168, "root": 55.0, "mode": "minor", "lead": "square"}},
	{"id": "steake", "name": "STEAKE.COM", "title": "Razz", "game": "RAZZ", "tier": 1, "hp": 26, "col": Color(0.85, 0.25, 0.2),
		"deal": {"n": 6, "spread": 0.0, "speed": 210.0, "aim": false, "volleys": 1, "floor": true, "label": "LOW HAND WINS!"},
		"deck": [["deal", "slam", "charge"], ["deal", "slam", "deal", "slam", "charge"], ["deal", "rain", "slam", "deal", "charge", "slam"]],
		"line_intro": "In Razz, the worst hand wins, so you've basically already beaten me by being you. You're a natural. It's a lifetime achievement award.", "line_defeat": "A wheel, the best of the worst, and I lost anyway. That's not even a poker result, that's a personality review.",
			"rico_intro": "Razz, where the worst hand wins? I was built for this, Rico. I've been the worst since birth and I've never gotten a trophy.", "rico_defeat": "Stake it all, that's my brand. And thanks to you I'll stake it all again, on a new brand, called Eat Me.",
		"music": {"bpm": 148, "root": 46.25, "mode": "minor", "lead": "saw"}},
	{"id": "bovadoh", "name": "BOVADOH", "title": "Pai Gow", "game": "PAI GOW", "tier": 2, "hp": 30, "col": Color(0.9, 0.2, 0.3),
		"deal": {"n": 2, "spread": 0.9, "speed": 175.0, "aim": false, "volleys": 2, "label": "TWO HANDS!"},
		"deck": [["deal", "wheel", "slam"], ["deal", "slam", "wheel", "charge"], ["deal", "wheel", "jackpot", "slam", "charge"]],
		"line_intro": "Pai Gow: seven cards, two hands, and you have to beat both or you push. You'll push, Rico, right into a wall, and I'll call it a push.", "line_defeat": "I lost both hands. Both. That's impossible, I need a moment. I need several moments. Put it on my tab of moments.",
			"rico_intro": "Pai Gow? Two hands? I only have one personality, and honestly, I'd like to split it into two and keep the good one for myself.", "rico_defeat": "Two hands, two wins. Do the math. I did. I was bad at it, but the math still checks out.",
		"music": {"bpm": 152, "root": 51.9, "mode": "phrygian", "lead": "tri"}},
	{"id": "seezers", "name": "SEEZER'S CLUB", "title": "Blackjack", "game": "BLACKJACK", "tier": 1, "hp": 24, "col": Color(0.3, 0.8, 0.45),
		"deal": {"n": 4, "spread": 0.28, "speed": 190.0, "aim": true, "volleys": 2, "label": "HIT ME!"},
		"deck": [["deal", "charge", "deal", "slam"], ["deal", "slam", "deal", "charge", "rain"], ["deal", "rain", "charge", "deal", "slam", "jackpot"]],
		"line_intro": "Dealer stands on seventeen, but I never stand, not for you, not for the Senate, and especially not after what happened to Caesar.", "line_defeat": "Twenty-two. I busted. How embarrassing. Rome fell on a bad hit, and now I know exactly how it felt.",
			"rico_intro": "Blackjack? I'll hit. I'll hit hard. Hit me, Caesar, hit me again, and tell the Senate to bring a bigger knife.", "rico_defeat": "Caesar's Palace was a casino, so I'd like to buy it, for a drink. One drink. Please don't make that a bet.",
		"music": {"bpm": 154, "root": 58.27, "mode": "minor", "lead": "square"}},
	{"id": "wynners", "name": "WYNNER'S CIRCLE", "title": "Baccarat", "game": "BACCARAT", "tier": 2, "hp": 28, "col": Color(0.95, 0.95, 0.9),
		"deal": {"n": 2, "spread": 0.4, "speed": 205.0, "aim": true, "volleys": 3, "label": "BANKER OR PLAYER?"},
		"deck": [["deal", "slam", "balls"], ["deal", "balls", "charge", "slam"], ["deal", "wheel", "balls", "charge", "jackpot"]],
		"line_intro": "Punto, Banco, or Tie. You'll pick Tie, because it pays eight to one, and it lands about as often as you do a sit-up.", "line_defeat": "A natural nine and I still fall. The Circle breaks. How gauche, to be defeated by a man who bets with his shoes.",
			"rico_intro": "Baccarat? Tuxedo, no money, and a martini. We've met before. It was at a funeral, and I was the guest of honor.", "rico_defeat": "Banker or Player? Put me down for 'tired,' and deal. I'll be at the bar, losing separately.",
		"music": {"bpm": 150, "root": 61.74, "mode": "phrygian", "lead": "tri"}},
]

const FINAL := {"id": "house", "name": "THE HOUSE", "title": "Texas Hold'em", "game": "TEXAS HOLD'EM", "tier": 3, "hp": 46, "col": Color(1.0, 0.8, 0.3),
	"deal": {"n": 5, "spread": 0.3, "speed": 215.0, "aim": true, "volleys": 2, "label": "THE FLOP!"},
	"deck": [["deal", "charge", "slam", "deal"], ["deal", "slam", "summon", "balls", "charge"], ["deal", "wheel", "jackpot", "slam", "summon", "charge", "rain"]],
	"line_intro": "Hole cards, flop, turn, river, and in the pot, your brother. Please sit, Rico. Your seat has been warmed by your previous losses.", "line_defeat": "The House... folds? I fold? Is this what it feels like? It feels... expensive. I'd like to speak to my manager. It's me. I'm the manager.",
		"rico_intro": "Texas Hold'em for my brother? I've bet worse on less. Deal the cards. I am going to need a bigger stack.", "rico_defeat": "Read 'em and weep, because this time I'm all in, and so is the entire family tree. Now, where's Jules?",
	"music": {"bpm": 172, "root": 49.0, "mode": "minor", "lead": "saw"}}

## Secret and side bosses (item 15). Same shape; found behind secret rooms.
const SECRET := [
	{"id": "snake_eyes", "name": "SNAKE EYES SAL", "title": "Craps", "game": "CRAPS", "tier": 1, "hp": 20, "col": Color(0.2, 0.9, 0.5),
		"deal": {"n": 2, "spread": 0.1, "speed": 280.0, "aim": true, "volleys": 3, "label": "COME OUT ROLL!"},
		"deck": [["deal", "slam", "deal"], ["deal", "charge", "slam"], ["deal", "slam", "charge", "rain"]],
		"line_intro": "Seven, you lose. Eleven, you lose. Snake eyes, you lose and also pay a tax. Everything's a lose here, but the tax is the fun part.", "line_defeat": "Boxcars. On my own roll. Of course. Twelve. I hate twelve, and now it's put me in the ground, which is a place where numbers can't hurt me.",
			"rico_intro": "Craps? Sure, I'm a craps man. I'm also a crap man, and I'd like both names on my headstone.", "rico_defeat": "Rolled it. And the dice rolled you. Same story, different dice, but I still keep the pot.",
		"music": {"bpm": 160, "root": 65.41, "mode": "phrygian", "lead": "square"}},
	{"id": "rusty_slots", "name": "ONE-ARMED BANDIT", "title": "The Slot Machine", "game": "SLOTS", "tier": 2, "hp": 26, "col": Color(1.0, 0.25, 0.8),
		"deal": {"n": 3, "spread": 0.35, "speed": 190.0, "aim": false, "volleys": 2, "label": "THREE OF A KIND!"},
		"deck": [["deal", "jackpot", "slam"], ["deal", "slam", "jackpot", "charge"], ["deal", "jackpot", "wheel", "slam", "charge"]],
		"line_intro": "Pull my arm. Go on, I dare you. I'm a very lonely arm, and I've been waiting for someone to pull me in the nicest possible way.", "line_defeat": "Jackpot, for YOU? That's the first time anyone's won on me. I'm so proud. I'm so sad. I'm so very sad and proud.",
			"rico_intro": "A haunted slot machine? Honestly, I've dated worse, mostly because she also took all my coins.", "rico_defeat": "You pulled the arm and the arm pulled you. Hug it out, or tilt, whichever comes with fewer lawsuits.",
		"music": {"bpm": 162, "root": 55.0, "mode": "phrygian", "lead": "square"}},
	{"id": "mr_lucky", "name": "KENO KEVIN", "title": "Keno", "game": "KENO", "tier": 3, "hp": 40, "col": Color(0.5, 1.0, 0.4),
		"deal": {"n": 8, "spread": 0.18, "speed": 200.0, "aim": false, "volleys": 2, "label": "PICK YOUR NUMBERS!"},
		"deck": [["deal", "balls", "slam", "charge"], ["deal", "wheel", "slam", "balls", "charge"], ["deal", "wheel", "jackpot", "balls", "charge", "slam", "summon"]],
		"line_intro": "Pick up to ten numbers, out of eighty. You'll hit none, because I'm Keno Kevin, welcome, and please don't pick Kevin. He never hits.", "line_defeat": "Eighty out of eighty? How? That's not even possible. I'm Kevin, I'm unlucky, I'm Keno, and I'm out of numbers.",
			"rico_intro": "Keno? Hit eighty numbers? Sounds like a Tuesday. A busy one, with a lot of math, and then crying.", "rico_defeat": "Good game, Kevin. May the next one be less numerical. I'd say hell, but Mags would send me the bill.",
		"music": {"bpm": 170, "root": 41.2, "mode": "phrygian", "lead": "saw"}},
]


static func final_def() -> Dictionary:
	return FINAL


## The 4 randomized bosses for a run (boss floors 5, 10, 15, 20), picked by seed.
static func roll_order(seed_: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_
	var pool: Array = POOL.duplicate()
	var out: Array = []
	for i in 4:
		out.append((pool.pop_at(rng.randi_range(0, pool.size() - 1)) as Dictionary)["id"])
	return out


static func by_id(id: String) -> Dictionary:
	for d in POOL:
		if d["id"] == id:
			return d
	for d in SECRET:
		if d["id"] == id:
			return d
	return FINAL
