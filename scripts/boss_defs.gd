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
		"line_intro": "Five cards. Discard what you don't like. I'll start with YOU.", "line_defeat": "A... pat hand. I had a pat hand.",
		"music": {"bpm": 150, "root": 55.0, "mode": "minor", "lead": "saw"}},
	{"id": "fandool", "name": "FANDOOL", "title": "Seven Card Stud", "game": "SEVEN CARD STUD", "tier": 1, "hp": 24, "col": Color(0.2, 0.55, 0.95),
		"deal": {"n": 7, "spread": 0.13, "speed": 170.0, "aim": true, "volleys": 2, "label": "SEVEN-STREET!"},
		"deck": [["deal", "charge", "slam"], ["deal", "slam", "deal", "charge"], ["deal", "jackpot", "charge", "deal", "slam"]],
		"line_intro": "Three down, four up. Everything you do is face up, pal.", "line_defeat": "The river... wasn't supposed to... bleed.",
		"music": {"bpm": 156, "root": 49.0, "mode": "minor", "lead": "square"}},
	{"id": "pokerstarz", "name": "POKERSTARZ", "title": "Omaha Hi-Lo", "game": "OMAHA", "tier": 2, "hp": 30, "col": Color(0.95, 0.35, 0.3),
		"deal": {"n": 4, "spread": 0.5, "speed": 200.0, "aim": false, "volleys": 2, "arc": true, "label": "FOUR HOLE CARDS!"},
		"deck": [["deal", "balls", "slam"], ["deal", "slam", "balls", "charge"], ["deal", "wheel", "slam", "balls", "charge"]],
		"line_intro": "Four hole cards. You must use exactly two. Good luck with the other two.", "line_defeat": "Split pot... I get nothing.",
		"music": {"bpm": 160, "root": 43.65, "mode": "phrygian", "lead": "saw"}},
	{"id": "betmgn", "name": "BETMGN", "title": "Three Card Poker", "game": "THREE CARD POKER", "tier": 2, "hp": 28, "col": Color(0.95, 0.75, 0.2),
		"deal": {"n": 3, "spread": 0.12, "speed": 260.0, "aim": true, "volleys": 3, "label": "PAIR PLUS!"},
		"deck": [["deal", "charge", "deal"], ["deal", "slam", "charge", "deal"], ["deal", "charge", "slam", "deal", "rain"]],
		"line_intro": "Three cards. Ante up. Quick, it's over fast.", "line_defeat": "Queen high... of course.",
		"music": {"bpm": 168, "root": 55.0, "mode": "minor", "lead": "square"}},
	{"id": "steake", "name": "STEAKE.COM", "title": "Razz", "game": "RAZZ", "tier": 1, "hp": 26, "col": Color(0.85, 0.25, 0.2),
		"deal": {"n": 6, "spread": 0.0, "speed": 210.0, "aim": false, "volleys": 1, "floor": true, "label": "LOW HAND WINS!"},
		"deck": [["deal", "slam", "charge"], ["deal", "slam", "deal", "slam", "charge"], ["deal", "rain", "slam", "deal", "charge", "slam"]],
		"line_intro": "In Razz the worst hand wins. You should fit right in.", "line_defeat": "A wheel... the best of the worst. Nice.",
		"music": {"bpm": 148, "root": 46.25, "mode": "minor", "lead": "saw"}},
	{"id": "bovadoh", "name": "BOVADOH", "title": "Pai Gow", "game": "PAI GOW", "tier": 2, "hp": 30, "col": Color(0.9, 0.2, 0.3),
		"deal": {"n": 2, "spread": 0.9, "speed": 175.0, "aim": false, "volleys": 2, "label": "TWO HANDS!"},
		"deck": [["deal", "wheel", "slam"], ["deal", "slam", "wheel", "charge"], ["deal", "wheel", "jackpot", "slam", "charge"]],
		"line_intro": "Seven cards, two hands. Beat both or push. You will push. Into a wall.", "line_defeat": "Both hands... lost. Impossible.",
		"music": {"bpm": 152, "root": 51.9, "mode": "phrygian", "lead": "tri"}},
	{"id": "seezers", "name": "SEEZER'S CLUB", "title": "Blackjack", "game": "BLACKJACK", "tier": 1, "hp": 24, "col": Color(0.3, 0.8, 0.45),
		"deal": {"n": 4, "spread": 0.28, "speed": 190.0, "aim": true, "volleys": 2, "label": "HIT ME!"},
		"deck": [["deal", "charge", "deal", "slam"], ["deal", "slam", "deal", "charge", "rain"], ["deal", "rain", "charge", "deal", "slam", "jackpot"]],
		"line_intro": "Dealer stands on 17. I never stand. Not for you.", "line_defeat": "Twenty-two. I busted. How embarrassing.",
		"music": {"bpm": 154, "root": 58.27, "mode": "minor", "lead": "square"}},
	{"id": "wynners", "name": "WYNNER'S CIRCLE", "title": "Baccarat", "game": "BACCARAT", "tier": 2, "hp": 28, "col": Color(0.95, 0.95, 0.9),
		"deal": {"n": 2, "spread": 0.4, "speed": 205.0, "aim": true, "volleys": 3, "label": "BANKER OR PLAYER?"},
		"deck": [["deal", "slam", "balls"], ["deal", "balls", "charge", "slam"], ["deal", "wheel", "balls", "charge", "jackpot"]],
		"line_intro": "Punto. Banco. Tie. Always a tie: you lose either way.", "line_defeat": "Natural nine... and still I fall.",
		"music": {"bpm": 150, "root": 61.74, "mode": "phrygian", "lead": "tri"}},
]

const FINAL := {"id": "house", "name": "THE HOUSE", "title": "Texas Hold'em", "game": "TEXAS HOLD'EM", "tier": 3, "hp": 46, "col": Color(1.0, 0.8, 0.3),
	"deal": {"n": 5, "spread": 0.3, "speed": 215.0, "aim": true, "volleys": 2, "label": "THE FLOP!"},
	"deck": [["deal", "charge", "slam", "deal"], ["deal", "slam", "summon", "balls", "charge"], ["deal", "wheel", "jackpot", "slam", "summon", "charge", "rain"]],
	"line_intro": "Hole cards. Flop. Turn. River. And at the end, the House always wins.", "line_defeat": "The House... folds?",
	"music": {"bpm": 172, "root": 49.0, "mode": "minor", "lead": "saw"}}

## Secret and side bosses (item 15). Same shape; found behind secret rooms.
const SECRET := [
	{"id": "snake_eyes", "name": "SNAKE EYES SAL", "title": "Craps", "game": "CRAPS", "tier": 1, "hp": 20, "col": Color(0.2, 0.9, 0.5),
		"deal": {"n": 2, "spread": 0.1, "speed": 280.0, "aim": true, "volleys": 3, "label": "COME OUT ROLL!"},
		"deck": [["deal", "slam", "deal"], ["deal", "charge", "slam"], ["deal", "slam", "charge", "rain"]],
		"line_intro": "Seven, you lose. Eleven, you lose. Everything's a lose.", "line_defeat": "Boxcars... on my own roll.",
		"music": {"bpm": 160, "root": 65.41, "mode": "phrygian", "lead": "square"}},
	{"id": "rusty_slots", "name": "ONE-ARMED BANDIT", "title": "The Slot Machine", "game": "SLOTS", "tier": 2, "hp": 26, "col": Color(1.0, 0.25, 0.8),
		"deal": {"n": 3, "spread": 0.35, "speed": 190.0, "aim": false, "volleys": 2, "label": "THREE OF A KIND!"},
		"deck": [["deal", "jackpot", "slam"], ["deal", "slam", "jackpot", "charge"], ["deal", "jackpot", "wheel", "slam", "charge"]],
		"line_intro": "Pull my arm. Go on. I dare you.", "line_defeat": "Jackpot... for YOU?",
		"music": {"bpm": 162, "root": 55.0, "mode": "phrygian", "lead": "square"}},
	{"id": "mr_lucky", "name": "MR. LUCKY", "title": "Keno", "game": "KENO", "tier": 3, "hp": 40, "col": Color(0.5, 1.0, 0.4),
		"deal": {"n": 8, "spread": 0.18, "speed": 200.0, "aim": false, "volleys": 2, "label": "PICK YOUR NUMBERS!"},
		"deck": [["deal", "balls", "slam", "charge"], ["deal", "wheel", "slam", "balls", "charge"], ["deal", "wheel", "jackpot", "balls", "charge", "slam", "summon"]],
		"line_intro": "Pick eighty numbers. You'll hit none. I'm Mr. Lucky.", "line_defeat": "Eighty out of eighty... how?",
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
