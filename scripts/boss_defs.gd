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
		"line_intro": "Five cards. Discard what you don't like. I'll start with your face.", "line_defeat": "A... pat hand. I had a pat hand. And a fantasy league. Gone.",
		"rico_intro": "Five Card Draw? I've drawn worse. I drew my last landlord.", "rico_defeat": "You drafted a loser. Mine. I'm keeping him.",
		"music": {"bpm": 150, "root": 55.0, "mode": "minor", "lead": "saw"}},
	{"id": "fandool", "name": "FANDOOL", "title": "Seven Card Stud", "game": "SEVEN CARD STUD", "tier": 1, "hp": 24, "col": Color(0.2, 0.55, 0.95),
		"deal": {"n": 7, "spread": 0.13, "speed": 170.0, "aim": true, "volleys": 2, "label": "SEVEN-STREET!"},
		"deck": [["deal", "charge", "slam"], ["deal", "slam", "deal", "charge"], ["deal", "jackpot", "charge", "deal", "slam"]],
		"line_intro": "Three down, four up. Everything you do is face up, pal. Including the begging.", "line_defeat": "The river... wasn't supposed to... bleed. Replay. Please. Slow-mo.",
		"rico_intro": "Seven Card Stud? Cute. My last seven-card stud was a Tuesday and a cry for help.", "rico_defeat": "Call it. I'll watch the highlight reel. Of me. Winning.",
		"music": {"bpm": 156, "root": 49.0, "mode": "minor", "lead": "square"}},
	{"id": "pokerstarz", "name": "POKERSTARZ", "title": "Omaha Hi-Lo", "game": "OMAHA", "tier": 2, "hp": 30, "col": Color(0.95, 0.35, 0.3),
		"deal": {"n": 4, "spread": 0.5, "speed": 200.0, "aim": false, "volleys": 2, "arc": true, "label": "FOUR HOLE CARDS!"},
		"deck": [["deal", "balls", "slam"], ["deal", "slam", "balls", "charge"], ["deal", "wheel", "slam", "balls", "charge"]],
		"line_intro": "Four hole cards. You must use exactly two. Smash the like button on your own funeral.", "line_defeat": "Split pot... I get nothing. Chat, am I cooked? Chat?",
		"rico_intro": "Omaha? Four hole cards? I've got four problems and a pair of shoes.", "rico_defeat": "Content creator? You're an extra. I'm the main character. Subscribe.",
		"music": {"bpm": 160, "root": 43.65, "mode": "phrygian", "lead": "saw"}},
	{"id": "betmgn", "name": "BETMGN", "title": "Three Card Poker", "game": "THREE CARD POKER", "tier": 2, "hp": 28, "col": Color(0.95, 0.75, 0.2),
		"deal": {"n": 3, "spread": 0.12, "speed": 260.0, "aim": true, "volleys": 3, "label": "PAIR PLUS!"},
		"deck": [["deal", "charge", "deal"], ["deal", "slam", "charge", "deal"], ["deal", "charge", "slam", "deal", "rain"]],
		"line_intro": "Three cards. Ante up. Quick, it's over fast. Like your marriage.", "line_defeat": "Queen high... of course. I had the commission. I HAD the commission.",
		"rico_intro": "Three Card Poker? Fast game. Ideal for a man with no attention span or savings.", "rico_defeat": "Pair plus? I'll take the pair. You take the plus. It's an ambulance.",
		"music": {"bpm": 168, "root": 55.0, "mode": "minor", "lead": "square"}},
	{"id": "steake", "name": "STEAKE.COM", "title": "Razz", "game": "RAZZ", "tier": 1, "hp": 26, "col": Color(0.85, 0.25, 0.2),
		"deal": {"n": 6, "spread": 0.0, "speed": 210.0, "aim": false, "volleys": 1, "floor": true, "label": "LOW HAND WINS!"},
		"deck": [["deal", "slam", "charge"], ["deal", "slam", "deal", "slam", "charge"], ["deal", "rain", "slam", "deal", "charge", "slam"]],
		"line_intro": "In Razz the worst hand wins. You should fit right in. You're a dream.", "line_defeat": "A wheel... the best of the worst. Nice. Not financial advice. Mostly a will.",
		"rico_intro": "Razz? Worst hand wins? I was built for this. I've been the worst since birth.", "rico_defeat": "Stake it all. That's the brand. Stake it, eat it, vomit it.",
		"music": {"bpm": 148, "root": 46.25, "mode": "minor", "lead": "saw"}},
	{"id": "bovadoh", "name": "BOVADOH", "title": "Pai Gow", "game": "PAI GOW", "tier": 2, "hp": 30, "col": Color(0.9, 0.2, 0.3),
		"deal": {"n": 2, "spread": 0.9, "speed": 175.0, "aim": false, "volleys": 2, "label": "TWO HANDS!"},
		"deck": [["deal", "wheel", "slam"], ["deal", "slam", "wheel", "charge"], ["deal", "wheel", "jackpot", "slam", "charge"]],
		"line_intro": "Seven cards, two hands. Beat both or push. You will push. Into a wall.", "line_defeat": "Both hands... lost. Impossible. I'll need a moment. Several moments. A sabbatical.",
		"rico_intro": "Pai Gow? Two hands? Ha. I only have one personality. Both are bad.", "rico_defeat": "Two hands, two wins. Do the math. I did. I was bad at it.",
		"music": {"bpm": 152, "root": 51.9, "mode": "phrygian", "lead": "tri"}},
	{"id": "seezers", "name": "SEEZER'S CLUB", "title": "Blackjack", "game": "BLACKJACK", "tier": 1, "hp": 24, "col": Color(0.3, 0.8, 0.45),
		"deal": {"n": 4, "spread": 0.28, "speed": 190.0, "aim": true, "volleys": 2, "label": "HIT ME!"},
		"deck": [["deal", "charge", "deal", "slam"], ["deal", "slam", "deal", "charge", "rain"], ["deal", "rain", "charge", "deal", "slam", "jackpot"]],
		"line_intro": "Dealer stands on 17. I never stand. Not for you. Not for the Senate.", "line_defeat": "Twenty-two. I busted. How embarrassing. Rome fell on a bad hit.",
		"rico_intro": "Blackjack? I'll hit. I'll hit hard. Hit me, Caesar. Hit me again.", "rico_defeat": "Caesar's palace was a casino. I'd like to buy it. For a drink. One drink.",
		"music": {"bpm": 154, "root": 58.27, "mode": "minor", "lead": "square"}},
	{"id": "wynners", "name": "WYNNER'S CIRCLE", "title": "Baccarat", "game": "BACCARAT", "tier": 2, "hp": 28, "col": Color(0.95, 0.95, 0.9),
		"deal": {"n": 2, "spread": 0.4, "speed": 205.0, "aim": true, "volleys": 3, "label": "BANKER OR PLAYER?"},
		"deck": [["deal", "slam", "balls"], ["deal", "balls", "charge", "slam"], ["deal", "wheel", "balls", "charge", "jackpot"]],
		"line_intro": "Punto. Banco. Tie. Always a tie: you lose either way.", "line_defeat": "Natural nine... and still I fall. The Circle breaks. How gauche.",
		"rico_intro": "Baccarat? Ha. Tuxedo, no money, and a martini. We've met before. At a funeral.", "rico_defeat": "Banker or Player? Put me down for 'tired.' Deal.",
		"music": {"bpm": 150, "root": 61.74, "mode": "phrygian", "lead": "tri"}},
]

const FINAL := {"id": "house", "name": "THE HOUSE", "title": "Texas Hold'em", "game": "TEXAS HOLD'EM", "tier": 3, "hp": 46, "col": Color(1.0, 0.8, 0.3),
	"deal": {"n": 5, "spread": 0.3, "speed": 215.0, "aim": true, "volleys": 2, "label": "THE FLOP!"},
	"deck": [["deal", "charge", "slam", "deal"], ["deal", "slam", "summon", "balls", "charge"], ["deal", "wheel", "jackpot", "slam", "summon", "charge", "rain"]],
	"line_intro": "Hole cards. Flop. Turn. River. And in the pot, your brother. Sit, Rico.", "line_defeat": "The House... folds? I... fold? Is this what it feels like? It feels... expensive.",
	"rico_intro": "Texas Hold'em for my brother. I've bet worse on less. Deal.", "rico_defeat": "Read 'em and weep. Now, where's Jules?",
	"music": {"bpm": 172, "root": 49.0, "mode": "minor", "lead": "saw"}}

## Secret and side bosses (item 15). Same shape; found behind secret rooms.
const SECRET := [
	{"id": "snake_eyes", "name": "SNAKE EYES SAL", "title": "Craps", "game": "CRAPS", "tier": 1, "hp": 20, "col": Color(0.2, 0.9, 0.5),
		"deal": {"n": 2, "spread": 0.1, "speed": 280.0, "aim": true, "volleys": 3, "label": "COME OUT ROLL!"},
		"deck": [["deal", "slam", "deal"], ["deal", "charge", "slam"], ["deal", "slam", "charge", "rain"]],
		"line_intro": "Seven, you lose. Eleven, you lose. Everything's a lose. Also a tax.", "line_defeat": "Boxcars... on my own roll. Of course. Twelve. I hate twelve.",
		"rico_intro": "Craps? Sure. I'm a craps man. I'm also a crap man. Try me.", "rico_defeat": "Rolled it. And the dice rolled you. Same story. Different dice.",
		"music": {"bpm": 160, "root": 65.41, "mode": "phrygian", "lead": "square"}},
	{"id": "rusty_slots", "name": "ONE-ARMED BANDIT", "title": "The Slot Machine", "game": "SLOTS", "tier": 2, "hp": 26, "col": Color(1.0, 0.25, 0.8),
		"deal": {"n": 3, "spread": 0.35, "speed": 190.0, "aim": false, "volleys": 2, "label": "THREE OF A KIND!"},
		"deck": [["deal", "jackpot", "slam"], ["deal", "slam", "jackpot", "charge"], ["deal", "jackpot", "wheel", "slam", "charge"]],
		"line_intro": "Pull my arm. Go on. I dare you. I'm a very lonely arm.", "line_defeat": "Jackpot... for YOU? That's... that's the first time. I'm so proud. I'm so sad.",
		"rico_intro": "A haunted slot machine? Honestly, I've dated worse. Most of them.", "rico_defeat": "You've pulled the arm. The arm's pulled you. Hug it out. Or tilt.",
		"music": {"bpm": 162, "root": 55.0, "mode": "phrygian", "lead": "square"}},
	{"id": "mr_lucky", "name": "KENO KEVIN", "title": "Keno", "game": "KENO", "tier": 3, "hp": 40, "col": Color(0.5, 1.0, 0.4),
		"deal": {"n": 8, "spread": 0.18, "speed": 200.0, "aim": false, "volleys": 2, "label": "PICK YOUR NUMBERS!"},
		"deck": [["deal", "balls", "slam", "charge"], ["deal", "wheel", "slam", "balls", "charge"], ["deal", "wheel", "jackpot", "balls", "charge", "slam", "summon"]],
		"line_intro": "Pick eighty numbers. You'll hit none. I'm Keno Kevin. Welcome. Please don't pick Kevin.", "line_defeat": "Eighty out of eighty... how? How? That's not even possible. I'm Kevin. I'm unlucky. I'm Keno.",
		"rico_intro": "Keno? Hit eighty numbers? Sounds like a Tuesday. A busy one.", "rico_defeat": "Good game, Kevin. May the next hell be less numerical.",
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
