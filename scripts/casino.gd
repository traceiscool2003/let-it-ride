extends RefCounted
## Playable casino games, all bet out of the Pot:
##   slots      3 reels x 3 rows, 5 paylines, wild chips. Every cabinet rolls
##              its own hidden reel weights, paytable and payback, and a
##              hidden "heat" drifts every spin, so machines run hot and cold.
##   blackjack  hit, stand, double down. Blackjack pays 3:2.
##   roulette   full board: colors, odd/even, halves, dozens, green, one number.
##   poker      Video Poker, Jacks or Better.
##   holdem     High Roller Hold'em: ante, then call 2x or fold, vs the dealer.
##   baccarat   Player, Banker or Tie with the real third-card rules.
##   hilo       Hi-Lo ladder: each right guess multiplies the pot; cash out
##              whenever you like.
##   bar        Lucky's drinks.
## After any win: DOUBLE OR NOTHING on one card (red or black).
## The game owns logic + drawing. press() and update() return the change to
## apply to the Pot (negative = stake taken, positive = payout).

const SYMS := ["CHERRY", "LEMON", "BELL", "BAR", "CHIP", "SEVEN"]
const WILD := 4
const BASE_W := [30.0, 24.0, 18.0, 13.0, 6.0, 4.0]
const BASE_PAY := {"CHERRY": 8.0, "LEMON": 10.0, "BELL": 20.0, "BAR": 40.0, "CHIP": 100.0, "SEVEN": 200.0, "PAIR": 2.0}
## Paylines: the row used on each of the three reels.
const LINES := [[1, 1, 1], [0, 0, 0], [2, 2, 2], [0, 1, 2], [2, 1, 0]]
const LINE_COLS := [Color(1, 0.3, 0.35), Color(0.45, 0.9, 1), Color(0.55, 1, 0.5), Color(1, 0.85, 0.3), Color(0.85, 0.5, 1)]
const THEMES := [
	{"name": "LUCKY SEVENS", "body": Color(0.45, 0.06, 0.12), "trim": Color(1, 0.8, 0.3)},
	{"name": "DIAMOND RUSH", "body": Color(0.06, 0.2, 0.42), "trim": Color(0.5, 0.9, 1)},
	{"name": "FRUIT FRENZY", "body": Color(0.1, 0.36, 0.14), "trim": Color(0.75, 1, 0.4)},
	{"name": "DEVIL'S DOZEN", "body": Color(0.2, 0.03, 0.22), "trim": Color(1, 0.3, 0.45)},
	{"name": "GOLD RUSH", "body": Color(0.36, 0.25, 0.05), "trim": Color(1, 0.92, 0.55)},
]
const REDS := [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
const WHEEL := [0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26]
## Roulette bets: [label, kind, total return multiple].
const RBETS := [
	["RED", "red", 2], ["BLACK", "black", 2], ["ODD", "odd", 2], ["EVEN", "even", 2],
	["1 - 18", "low", 2], ["19 - 36", "high", 2], ["1st 12", "d1", 3], ["2nd 12", "d2", 3],
	["3rd 12", "d3", 3], ["GREEN 0", "zero", 36], ["NUMBER", "num", 36],
]
## Video poker (Jacks or Better) total return per hand category.
const VP_PAY := {"ROYAL FLUSH": 250, "STRAIGHT FLUSH": 50, "FOUR OF A KIND": 25, "FULL HOUSE": 9, "FLUSH": 6, "STRAIGHT": 4, "THREE OF A KIND": 3, "TWO PAIR": 2, "JACKS OR BETTER": 1}
const VP_ORDER := ["ROYAL FLUSH", "STRAIGHT FLUSH", "FOUR OF A KIND", "FULL HOUSE", "FLUSH", "STRAIGHT", "THREE OF A KIND", "TWO PAIR", "JACKS OR BETTER"]
const HAND_NAMES := ["HIGH CARD", "PAIR", "TWO PAIR", "THREE OF A KIND", "STRAIGHT", "FLUSH", "FULL HOUSE", "FOUR OF A KIND", "STRAIGHT FLUSH"]
## Hold'em ante bonus (extra multiple of the ante) by hand category.
const HE_BONUS := {4: 1, 5: 2, 6: 3, 7: 10, 8: 20}
const RANKS := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
const DRINKS := [["shot", "SHOT OF COURAGE", "+1 life", 60], ["flow", "LIQUID FLOW", "Max out your Flow", 35], ["lucky", "LUCKY CHARM", "Chips worth x2 this floor", 80]]
const MAX_GAMBLES := 5

var game := "slots"
var step := "bet"
var bet_i := 0
var bets: Array = [5, 25, 100, -2, -1]
var bet := 0
var msg := ""
var msg_col := Color.WHITE
var win := 0
var t := 0.0
var luck := 0
var done := false
var big_win := false
var achievement := ""
var bought := ""
var bar_i := 0
var price_scale := 1
var floor_num := 1
## Skills that change the tables (set by main before open()).
var high_limit := false
var card_sense := false
var pay_bonus := 0.0
## Price multiplier for Lucky's drinks (charms and Table Limits change it).
var discount := 1.0
## Set when a result awards a charm: "common", "uncommon", "rare" or
## "jackpot". main.gd reads it, rolls a charm and clears it.
var charm_tier := ""
var rng := RandomNumberGenerator.new()

# Slots.
var machine: Dictionary = {}
var grid: Array = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
var shown: Array = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
var win_lines: Array = []

# Cards.
var deck: Array = []
var ph: Array = []
var dh: Array = []
var sel := 0
var dealer_t := 0.0
var doubled := false

# Roulette.
var pick := 0
var number := 17
var wheel_a := 0.0
var wheel_v := 0.0
var result_n := -1

# Video poker.
var held: Array = [false, false, false, false, false]
var vp_hand := ""

# Hold'em.
var board: Array = []
var he_reveal := 0
var he_text := ""

# Baccarat.
var bac_pick := 0
var bac_p: Array = []
var bac_b: Array = []
var bac_order: Array = []
var bac_shown := 0

# Hi-Lo.
var hl_card := 0
var hl_next := 0
var hl_value := 0.0
var hl_rung := 0
var hl_guess := ""
var hl_history: Array = []

# Double or nothing.
var gambles := 0
var gamble_pick := 0
var gamble_card := -1
var gamble_t := 0.0


func _init() -> void:
	rng.randomize()


func open(g: String, lucky: int, floor_n := 1) -> void:
	floor_num = floor_n
	price_scale = 1 + floor_n / 3
	game = g
	luck = lucky
	step = "bet"
	msg = ""
	done = false
	win = 0
	gambles = 0
	ph.clear()
	dh.clear()
	board.clear()
	bets = [5, 25, 100]
	if floor_n >= 3 or high_limit:
		bets.append(250)
	if floor_n >= 5 or high_limit:
		bets.append(500)
	if high_limit:
		bets.append_array([1000, 2500])
	bets.append_array([-2, -1])
	bet_i = clampi(bet_i, 0, bets.size() - 1)
	if g == "bar":
		step = "bar"
		msg = "Lucky: \"What'll it be, runner? Paid from the Pot.\""
		msg_col = Color(0.6, 1, 0.65)
	t = 0.0


func bet_amount(pot: int) -> int:
	var b: int = bets[bet_i]
	if b == -1:
		return pot
	if b == -2:
		return maxi(1, pot / 2)
	return b


func bet_label(i: int) -> String:
	var b: int = bets[i]
	if b == -1:
		return "ALL IN"
	if b == -2:
		return "HALF"
	return "$%d" % b


func title() -> String:
	match game:
		"slots": return String(THEMES[int(machine.get("theme", 0))]["name"]) if not machine.is_empty() else "SLOTS"
		"bar": return "LUCKY'S BAR"
		"blackjack": return "BLACKJACK"
		"poker": return "VIDEO POKER"
		"holdem": return "HIGH ROLLER HOLD'EM"
		"baccarat": return "BACCARAT"
		"hilo": return "HI-LO LADDER"
	return "ROULETTE"


static func how_to(g: String) -> String:
	match g:
		"slots": return "5 paylines. Chips are WILD. Three of a kind on any line wins a charm. Every machine has its own hidden odds."
		"blackjack": return "Beat the dealer to 21. DOUBLE DOWN for one card at twice the bet. Blackjack pays 3:2."
		"poker": return "Jacks or Better. Hold the cards you want, then DRAW once. Royal Flush pays x250."
		"holdem": return "Ante up. See your two cards and the flop, then CALL (2x ante) or FOLD. Best five cards wins."
		"baccarat": return "Bet PLAYER, BANKER or TIE. Closest to 9 wins. Banker pays 0.95, Tie pays 8 to 1."
		"hilo": return "Guess if the next card is HIGHER or LOWER. Every right guess climbs the ladder. Cash out any time."
		"roulette": return "Colors and halves pay x2, dozens x3, a single number x36."
	return ""


# ================================================================ input

## Handle a just-pressed action ("left", "right", "up", "confirm", "back").
## Returns the Pot delta to apply now.
func press(action: String, pot: int) -> int:
	if step == "bar":
		return _bar_press(action, pot)
	match step:
		"bet":
			if action == "left":
				bet_i = (bet_i + bets.size() - 1) % bets.size()
				Sfx.play("tick")
			elif action == "right":
				bet_i = (bet_i + 1) % bets.size()
				Sfx.play("tick")
			elif action == "back":
				done = true
			elif action == "confirm":
				var b := bet_amount(pot)
				if pot <= 0 or b <= 0:
					_say("Your Pot is empty. Go win something.", Color(1, 0.5, 0.4))
				elif b > pot:
					_say("Not enough in the Pot for that bet.", Color(1, 0.5, 0.4))
				elif game == "holdem" and b * 3 > pot:
					_say("Hold'em needs 3x the ante in your Pot (ante + call).", Color(1, 0.5, 0.4))
				else:
					bet = b
					_start()
					return -b
		"bj":
			var n := 3 if ph.size() == 2 else 2
			if action == "left":
				sel = (sel + n - 1) % n
				Sfx.play("tick")
			elif action == "right":
				sel = (sel + 1) % n
				Sfx.play("tick")
			elif action == "confirm":
				match sel:
					0:
						ph.append(_deal())
						Sfx.play("tick", 1.4)
						if hand_value(ph) > 21:
							return _finish(0, "BUST  %d" % hand_value(ph), Color(1, 0.4, 0.4))
						if hand_value(ph) == 21:
							_to_dealer()
						sel = mini(sel, 1)
					1:
						_to_dealer()
					2:
						if pot < bet:
							_say("Not enough in the Pot to double.", Color(1, 0.5, 0.4))
						else:
							var extra := bet
							bet *= 2
							doubled = true
							ph.append(_deal())
							Sfx.play("chip_big", 0.8)
							if hand_value(ph) > 21:
								step = "result"
								_finish(0, "BUST  %d" % hand_value(ph), Color(1, 0.4, 0.4))
								return -extra
							_to_dealer()
							return -extra
		"pick":
			if action == "left":
				pick = (pick + RBETS.size() - 1) % RBETS.size()
				Sfx.play("tick")
			elif action == "right":
				pick = (pick + 1) % RBETS.size()
				Sfx.play("tick")
			elif action == "up" and RBETS[pick][1] == "num":
				number = number % 36 + 1
				Sfx.play("tick", 1.3)
			elif action == "confirm":
				if RBETS[pick][1] == "num" and step == "pick":
					step = "num"
					Sfx.play("tick", 1.2)
				else:
					_spin_wheel()
			elif action == "back":
				step = "bet"
				return bet
		"num":
			if action == "left":
				number = (number + 34) % 36 + 1
				Sfx.play("tick")
			elif action == "right" or action == "up":
				number = number % 36 + 1
				Sfx.play("tick")
			elif action == "confirm":
				_spin_wheel()
			elif action == "back":
				step = "pick"
		"vp":
			if action == "left":
				sel = (sel + 5) % 6
				Sfx.play("tick")
			elif action == "right":
				sel = (sel + 1) % 6
				Sfx.play("tick")
			elif action == "up" and sel < 5:
				held[sel] = not held[sel]
				Sfx.play("tick", 1.5)
			elif action == "confirm":
				if sel < 5:
					held[sel] = not held[sel]
					Sfx.play("tick", 1.5)
				else:
					return _vp_draw()
		"he":
			if action == "left" or action == "right":
				sel = 1 - sel
				Sfx.play("tick")
			elif action == "confirm":
				if sel == 0:
					if pot < bet * 2:
						_say("Not enough in the Pot to call. Fold or win more.", Color(1, 0.5, 0.4))
						return 0
					step = "he_show"
					he_reveal = 3
					dealer_t = 0.0
					Sfx.play("chip_big", 0.9)
					return -bet * 2
				else:
					return _finish(0, "FOLDED. The ante stays with the House.", Color(1, 0.6, 0.5))
		"bac_pick":
			if action == "left":
				bac_pick = (bac_pick + 2) % 3
				Sfx.play("tick")
			elif action == "right":
				bac_pick = (bac_pick + 1) % 3
				Sfx.play("tick")
			elif action == "confirm":
				_bac_deal()
			elif action == "back":
				step = "bet"
				return bet
		"hl":
			if action == "left":
				sel = (sel + 2) % 3
				Sfx.play("tick")
			elif action == "right":
				sel = (sel + 1) % 3
				Sfx.play("tick")
			elif action == "confirm":
				var r := hl_card % 13 + 1
				if sel == 2:
					if hl_rung == 0:
						step = "bet"
						return bet
					var pay := int(round(hl_value))
					_finish_quiet(pay, "CASHED OUT  $%d" % pay, Color(0.6, 1, 0.6))
					return pay
				if (sel == 0 and r == 13) or (sel == 1 and r == 1):
					_say("Can't go %s than that. Pick the other way." % ("higher" if sel == 0 else "lower"), Color(1, 0.6, 0.5))
					return 0
				hl_guess = "hi" if sel == 0 else "lo"
				hl_next = rng.randi_range(0, 51)
				step = "hl_flip"
				dealer_t = 0.0
				Sfx.play("swing", 1.4)
		"gamble":
			if action == "left" or action == "right":
				gamble_pick = 1 - gamble_pick
				Sfx.play("tick")
			elif action == "confirm" and gamble_card < 0:
				gamble_card = rng.randi_range(0, 51)
				gamble_t = 0.0
				Sfx.play("swing", 1.2)
			elif action == "back" and gamble_card < 0:
				# Changed your mind: take the money.
				step = "result"
				msg = "Kept $%d" % win
				msg_col = Color(0.6, 1, 0.6)
				return win
		"result":
			if action == "confirm":
				step = "bet"
				msg = ""
				win = 0
				gambles = 0
			elif action == "up" and win > 0 and gambles < MAX_GAMBLES and game != "bar":
				step = "gamble"
				gamble_card = -1
				gamble_pick = 0
				Sfx.play("door", 1.3)
				return -win
			elif action == "back":
				done = true
	return 0


func _say(s: String, col: Color) -> void:
	msg = s
	msg_col = col
	Sfx.play("deny")


func _start() -> void:
	msg = ""
	win = 0
	charm_tier = ""
	big_win = false
	t = 0.0
	sel = 0
	doubled = false
	gambles = 0
	match game:
		"slots":
			_roll_grid()
			step = "spin"
			Sfx.play("swing", 0.8)
		"blackjack":
			_shuffle()
			ph = [_deal(), _deal()]
			dh = [_deal(), _deal()]
			step = "bj"
			if hand_value(dh) == 21 or hand_value(ph) == 21:
				_to_dealer()
		"roulette":
			step = "pick"
		"poker":
			_shuffle()
			ph = [_deal(), _deal(), _deal(), _deal(), _deal()]
			held = [false, false, false, false, false]
			sel = 5
			step = "vp"
			vp_hand = _vp_name(ph)
			Sfx.play("tick", 1.2)
		"holdem":
			_shuffle()
			ph = [_deal(), _deal()]
			dh = [_deal(), _deal()]
			board = [_deal(), _deal(), _deal(), _deal(), _deal()]
			he_reveal = 3
			he_text = ""
			step = "he"
		"baccarat":
			step = "bac_pick"
		"hilo":
			hl_card = rng.randi_range(0, 51)
			hl_value = float(bet)
			hl_rung = 0
			hl_history = [hl_card]
			sel = 0
			step = "hl"


# ================================================================ cards

func _shuffle() -> void:
	deck = range(52)
	for i in range(deck.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = deck[i]
		deck[i] = deck[j]
		deck[j] = tmp


func _deal() -> int:
	if deck.is_empty():
		_shuffle()
	return deck.pop_back()


static func card_val(c: int) -> int:
	var r := c % 13
	if r == 0:
		return 11
	return mini(10, r + 1)


static func hand_value(hand: Array) -> int:
	var v := 0
	var aces := 0
	for c in hand:
		v += card_val(c)
		if c % 13 == 0:
			aces += 1
	while v > 21 and aces > 0:
		v -= 10
		aces -= 1
	return v


## Score a 5-card poker hand. Higher is better; category = score / 15^5.
static func score5(cards: Array) -> int:
	var rs: Array[int] = []
	var suits := {}
	for c in cards:
		var r: int = int(c) % 13
		rs.append(14 if r == 0 else r + 1)
		suits[int(c) / 13] = true
	rs.sort()
	rs.reverse()
	var counts := {}
	for r in rs:
		counts[r] = int(counts.get(r, 0)) + 1
	var flush := suits.size() == 1
	var uniq: Array = counts.keys()
	var straight := false
	var high := 0
	if uniq.size() == 5:
		if rs[0] - rs[4] == 4:
			straight = true
			high = rs[0]
		elif rs[0] == 14 and rs[1] == 5 and rs[2] == 4 and rs[3] == 3 and rs[4] == 2:
			straight = true
			high = 5
	# Ranks ordered by (count, rank), highest first.
	uniq.sort_custom(func(a, b): return int(counts[a]) > int(counts[b]) or (int(counts[a]) == int(counts[b]) and int(a) > int(b)))
	var cnt: Array = []
	for r in uniq:
		cnt.append(counts[r])
	var cat := 0
	var tb: Array = uniq.duplicate()
	if straight and flush:
		cat = 8
		tb = [high]
	elif cnt[0] == 4:
		cat = 7
	elif cnt[0] == 3 and cnt[1] == 2:
		cat = 6
	elif flush:
		cat = 5
	elif straight:
		cat = 4
		tb = [high]
	elif cnt[0] == 3:
		cat = 3
	elif cnt[0] == 2 and cnt[1] == 2:
		cat = 2
	elif cnt[0] == 2:
		cat = 1
	var score := cat
	for i in 5:
		score = score * 15 + (int(tb[i]) if i < tb.size() else 0)
	return score


static func category(score: int) -> int:
	return score / 759375


## Best 5-card score from up to 7 cards.
static func best_of(cards: Array) -> int:
	if cards.size() <= 5:
		return score5(cards)
	var best := -1
	var n := cards.size()
	for a in n:
		for b in range(a + 1, n):
			var hand: Array = []
			for i in n:
				if i != a and i != b:
					hand.append(cards[i])
			if hand.size() == 5:
				best = maxi(best, score5(hand))
			else:
				best = maxi(best, best_of(hand))
	return best


static func hand_name(score: int) -> String:
	var cat := category(score)
	if cat == 8 and (score / 50625) % 15 == 14:
		return "ROYAL FLUSH"
	return HAND_NAMES[cat]


static func _vp_name(cards: Array) -> String:
	var s := score5(cards)
	var cat := category(s)
	match cat:
		8:
			return "ROYAL FLUSH" if (s / 50625) % 15 == 14 else "STRAIGHT FLUSH"
		7: return "FOUR OF A KIND"
		6: return "FULL HOUSE"
		5: return "FLUSH"
		4: return "STRAIGHT"
		3: return "THREE OF A KIND"
		2: return "TWO PAIR"
		1:
			var pair_rank := (s / 50625) % 15
			return "JACKS OR BETTER" if pair_rank >= 11 else ""
	return ""


# ================================================================ resolve

func _finish(payout: int, text: String, col: Color) -> int:
	if payout > 0 and pay_bonus > 0.0 and payout > bet:
		payout += int((payout - bet) * pay_bonus)
	win = payout
	step = "result"
	msg = text
	msg_col = col
	big_win = payout >= bet * 10 and payout > 0
	if payout > bet:
		Sfx.play("chip_big")
	elif charm_tier != "":
		Sfx.play("buy")
	elif payout == 0:
		Sfx.play("hurt", 1.6)
	return payout


## A payout already returned by press() (cash outs): no bonus math, no sound.
func _finish_quiet(payout: int, text: String, col: Color) -> void:
	win = payout
	step = "result"
	msg = text
	msg_col = col
	big_win = payout >= bet * 10
	Sfx.play("chip_big" if payout > bet else "coins")


func _to_dealer() -> void:
	step = "dealer"
	dealer_t = 0.0


## Advance animations. Returns the Pot delta to apply (payouts).
func update(delta: float) -> int:
	t += delta
	match step:
		"spin":
			if game == "slots":
				for r in 3:
					var stop := 0.7 + r * 0.42
					if t < stop:
						for y in 3:
							shown[r][y] = rng.randi_range(0, SYMS.size() - 1)
					else:
						if shown[r][1] != grid[r][1] or shown[r][0] != grid[r][0]:
							Sfx.play("tick", 0.8)
						for y in 3:
							shown[r][y] = grid[r][y]
				if t > 0.7 + 2 * 0.42 + 0.3:
					return _eval_slots()
			else:
				wheel_v = maxf(0.0, wheel_v - delta * 3.2)
				wheel_a += wheel_v * delta
				if wheel_v <= 0.0 and t > 1.0:
					return _eval_roulette()
		"dealer":
			dealer_t += delta
			if dealer_t > 0.55:
				dealer_t = 0.0
				if hand_value(ph) <= 21 and hand_value(dh) < 17 and not (ph.size() == 2 and hand_value(ph) == 21):
					dh.append(_deal())
					Sfx.play("tick", 1.2)
				else:
					return _eval_bj()
		"he_show":
			dealer_t += delta
			if dealer_t > 0.55:
				dealer_t = 0.0
				if he_reveal < 5:
					he_reveal += 1
					Sfx.play("tick", 1.2)
				else:
					return _eval_holdem()
		"bac_deal":
			dealer_t += delta
			if dealer_t > 0.5:
				dealer_t = 0.0
				if bac_shown < bac_order.size():
					bac_shown += 1
					Sfx.play("tick", 1.2)
				else:
					return _eval_baccarat()
		"hl_flip":
			dealer_t += delta
			if dealer_t > 0.6:
				_eval_hilo()
		"gamble":
			if gamble_card >= 0:
				gamble_t += delta
				if gamble_t > 0.7:
					return _eval_gamble()
	return 0


func _eval_bj() -> int:
	var p := hand_value(ph)
	var d := hand_value(dh)
	var p_bj := p == 21 and ph.size() == 2 and not doubled
	var d_bj := d == 21 and dh.size() == 2
	if p_bj and not d_bj:
		achievement = "blackjack"
		return _finish(int(bet * 2.5), "BLACKJACK!  pays 3:2", Color(1, 0.85, 0.3))
	if d_bj and not p_bj:
		return _finish(0, "DEALER BLACKJACK", Color(1, 0.5, 0.45))
	if p > 21:
		return _finish(0, "BUST  %d" % p, Color(1, 0.4, 0.4))
	if d > 21 or p > d:
		return _finish(bet * 2, ("DOUBLED AND WON!  %d vs %d" if doubled else "YOU WIN  %d vs %d") % [p, d], Color(0.6, 1, 0.6))
	if p == d:
		return _finish(bet, "PUSH  %d" % p, Color(0.85, 0.85, 0.9))
	return _finish(0, "HOUSE WINS  %d vs %d" % [d, p], Color(1, 0.5, 0.45))


# ---------------------------------------------------------------- slots

## A fresh slot machine with hidden, randomly generated odds.
static func new_machine() -> Dictionary:
	var r := RandomNumberGenerator.new()
	r.randomize()
	var w: Array = []
	for i in BASE_W.size():
		w.append(float(BASE_W[i]) * r.randf_range(0.5, 1.7))
	var pays := {}
	for k in BASE_PAY:
		pays[k] = float(BASE_PAY[k]) * r.randf_range(0.7, 1.4)
	var target := r.randf_range(0.82, 1.04)
	var parts := line_rtp(w, pays)
	var k := target / maxf(0.01, parts[0])
	for key in pays.keys():
		pays[key] = float(pays[key]) * k
	var top_share: float = parts[1] / maxf(0.001, parts[0])
	var vol := "LOW"
	if top_share > 0.5:
		vol = "HIGH"
	elif top_share > 0.3:
		vol = "MEDIUM"
	return {"theme": r.randi_range(0, THEMES.size() - 1), "w": w, "pays": pays, "rtp": target,
		"heat": r.randf_range(-0.6, 0.6), "vol": vol, "spins": 0}


## Expected return of one payline as a multiple of the line bet:
## [total, share from SEVEN/CHIP lines].
static func line_rtp(w: Array, pays: Dictionary) -> Array:
	var tot := 0.0
	for x in w:
		tot += float(x)
	var e := 0.0
	var top := 0.0
	for a in 6:
		for b in 6:
			for c in 6:
				var p: float = float(w[a]) * float(w[b]) * float(w[c]) / (tot * tot * tot)
				var lv := line_value([a, b, c], pays)
				e += p * float(lv[0])
				if lv[1] == "SEVEN" or lv[1] == "CHIP":
					top += p * float(lv[0])
	return [e, top]


## Pay multiple for one line of three symbols: [multiple, symbol name].
static func line_value(s: Array, pays: Dictionary) -> Array:
	var first := -1
	var same := true
	for x in s:
		if int(x) == WILD:
			continue
		if first < 0:
			first = int(x)
		elif int(x) != first:
			same = false
	if first < 0:
		return [float(pays["CHIP"]), "CHIP"]
	if same:
		return [float(pays[SYMS[first]]), SYMS[first]]
	if s.count(0) == 2:
		return [float(pays["PAIR"]), ""]
	return [0.0, ""]


func _roll_grid() -> void:
	if machine.is_empty():
		machine = new_machine()
	var w: Array = (machine["w"] as Array).duplicate()
	var heat: float = machine["heat"]
	w[3] = float(w[3]) * (1.0 + 0.25 * heat)
	w[4] = float(w[4]) * (1.0 + 0.4 * heat) + luck * 1.2
	w[5] = float(w[5]) * (1.0 + 0.4 * heat) + luck * 0.8
	var tot := 0.0
	for x in w:
		tot += float(x)
	for r in 3:
		for y in 3:
			var roll := rng.randf() * tot
			var pickd := 0
			for i in w.size():
				roll -= float(w[i])
				if roll <= 0.0:
					pickd = i
					break
			grid[r][y] = pickd
	# The machine's mood drifts every spin.
	machine["heat"] = clampf(heat + rng.randf_range(-0.3, 0.3) - heat * 0.08, -1.0, 1.0)
	machine["spins"] = int(machine["spins"]) + 1


func _eval_slots() -> int:
	var pays: Dictionary = machine["pays"]
	var total := 0.0
	var best_sym := ""
	var best_pay := 0.0
	win_lines.clear()
	for li in LINES.size():
		var rows: Array = LINES[li]
		var s := [grid[0][rows[0]], grid[1][rows[1]], grid[2][rows[2]]]
		var lv := line_value(s, pays)
		var m: float = lv[0]
		if m > 0.0:
			win_lines.append(li)
			total += float(bet) / 5.0 * m
			if lv[1] != "" and m > best_pay:
				best_pay = m
				best_sym = lv[1]
	var payout := int(round(total))
	if best_sym == "SEVEN":
		achievement = "jackpot"
	match best_sym:
		"CHERRY", "LEMON":
			charm_tier = "common"
		"BELL", "BAR":
			charm_tier = "uncommon"
		"CHIP":
			charm_tier = "rare"
		"SEVEN":
			charm_tier = "jackpot"
	if payout >= bet * 20:
		machine["heat"] = float(machine["heat"]) - 0.6
	if payout == 0 and charm_tier == "":
		return _finish(0, "NO DICE", Color(1, 0.5, 0.45))
	var head := "JACKPOT!!" if best_sym == "SEVEN" else ("THREE %sS" % best_sym if best_sym != "" else "WINNER")
	var lines_txt := "%d LINE%s" % [win_lines.size(), "S" if win_lines.size() != 1 else ""]
	return _finish(payout, "%s   %s   $%d%s" % [head, lines_txt, payout, "  + CHARM" if charm_tier != "" else ""], Color(1, 0.85, 0.3) if best_sym != "" else Color(0.6, 1, 0.6))


# ---------------------------------------------------------------- roulette

func _spin_wheel() -> void:
	step = "spin"
	t = 0.0
	wheel_v = rng.randf_range(9.0, 12.0)
	result_n = WHEEL[rng.randi_range(0, WHEEL.size() - 1)]
	Sfx.play("swing", 0.6)


static func rbet_wins(kind: String, n: int, num: int) -> bool:
	match kind:
		"red": return REDS.has(n)
		"black": return n != 0 and not REDS.has(n)
		"odd": return n != 0 and n % 2 == 1
		"even": return n != 0 and n % 2 == 0
		"low": return n >= 1 and n <= 18
		"high": return n >= 19
		"d1": return n >= 1 and n <= 12
		"d2": return n >= 13 and n <= 24
		"d3": return n >= 25
		"zero": return n == 0
		"num": return n == num
	return false


func _eval_roulette() -> int:
	var kind: String = RBETS[pick][1]
	var m: int = RBETS[pick][2]
	var col := "GREEN" if result_n == 0 else ("RED" if REDS.has(result_n) else "BLACK")
	if rbet_wins(kind, result_n, number):
		return _finish(bet * m, "%d %s!  pays x%d" % [result_n, col, m], Color(1, 0.85, 0.3) if m >= 36 else Color(0.6, 1, 0.6))
	return _finish(0, "%d %s.  House wins." % [result_n, col], Color(1, 0.5, 0.45))


# ---------------------------------------------------------------- video poker

func _vp_draw() -> int:
	for i in 5:
		if not held[i]:
			ph[i] = _deal()
	Sfx.play("tick", 1.3)
	vp_hand = _vp_name(ph)
	if vp_hand == "":
		return _finish(0, "NOTHING.  Hold pairs, chase flushes.", Color(1, 0.5, 0.45))
	var m: int = VP_PAY[vp_hand]
	if m >= 25:
		charm_tier = "rare" if m < 250 else "jackpot"
		if m >= 250:
			achievement = "royal"
	elif m >= 6:
		charm_tier = "common"
	return _finish(bet * m, "%s  x%d%s" % [vp_hand, m, "  + CHARM" if charm_tier != "" else ""], Color(1, 0.85, 0.3) if m >= 6 else Color(0.6, 1, 0.6))


# ---------------------------------------------------------------- hold'em

func _eval_holdem() -> int:
	var ps := best_of(ph + board)
	var ds := best_of(dh + board)
	var pname := hand_name(ps)
	var dname := hand_name(ds)
	var pc := category(ps)
	var bonus := int(HE_BONUS.get(pc, 1)) if pc >= 4 else 1
	if pname == "ROYAL FLUSH":
		bonus = 100
	he_text = "You: %s     Dealer: %s" % [pname, dname]
	if pc >= 5:
		charm_tier = "uncommon" if pc < 7 else "rare"
	# Dealer needs a pair of 4s or better to qualify.
	var d_qual := category(ds) >= 2 or (category(ds) == 1 and (ds / 50625) % 15 >= 4)
	if not d_qual:
		return _finish(bet + bet * bonus + bet * 2, "DEALER DOESN'T QUALIFY.  Ante pays, call pushes.", Color(0.6, 1, 0.6))
	if ps > ds:
		return _finish(bet + bet * bonus + bet * 4, "YOU WIN WITH %s" % pname, Color(1, 0.85, 0.3) if pc >= 4 else Color(0.6, 1, 0.6))
	if ps == ds:
		return _finish(bet * 3, "SPLIT POT", Color(0.85, 0.85, 0.9))
	return _finish(0, "DEALER WINS WITH %s" % dname, Color(1, 0.5, 0.45))


# ---------------------------------------------------------------- baccarat

static func bac_val(c: int) -> int:
	var r := c % 13 + 1
	return r if r < 10 else 0


static func bac_total(hand: Array) -> int:
	var s := 0
	for c in hand:
		s += bac_val(c)
	return s % 10


## Real third-card rules. Returns [player cards, banker cards].
static func bac_play(cards: Array) -> Array:
	var p: Array = [cards[0], cards[2]]
	var b: Array = [cards[1], cards[3]]
	var i := 4
	var pt := bac_total(p)
	var bt := bac_total(b)
	if pt >= 8 or bt >= 8:
		return [p, b]
	var p3 := -1
	if pt <= 5:
		p.append(cards[i])
		p3 = bac_val(cards[i])
		i += 1
	var draw := false
	if p3 < 0:
		draw = bt <= 5
	else:
		match bt:
			0, 1, 2: draw = true
			3: draw = p3 != 8
			4: draw = p3 >= 2 and p3 <= 7
			5: draw = p3 >= 4 and p3 <= 7
			6: draw = p3 == 6 or p3 == 7
	if draw:
		b.append(cards[i])
	return [p, b]


func _bac_deal() -> void:
	_shuffle()
	var cards: Array = []
	for i in 6:
		cards.append(_deal())
	var res := bac_play(cards)
	bac_p = res[0]
	bac_b = res[1]
	# Reveal order: P, B, P, B, then any third cards.
	bac_order = [["p", 0], ["b", 0], ["p", 1], ["b", 1]]
	if bac_p.size() > 2:
		bac_order.append(["p", 2])
	if bac_b.size() > 2:
		bac_order.append(["b", 2])
	bac_shown = 0
	dealer_t = 0.0
	step = "bac_deal"
	Sfx.play("swing", 1.3)


func _eval_baccarat() -> int:
	var pt := bac_total(bac_p)
	var bt := bac_total(bac_b)
	var who := "TIE" if pt == bt else ("PLAYER" if pt > bt else "BANKER")
	var head := "%s WINS  %d - %d" % [who, pt, bt] if who != "TIE" else "TIE  %d - %d" % [pt, bt]
	match bac_pick:
		0:
			if who == "PLAYER":
				return _finish(bet * 2, head, Color(0.6, 1, 0.6))
		1:
			if who == "BANKER":
				# Banker wins pay 0.95. Odd cents are settled with a coin flip
				# weighted by the fraction, so small bets stay fair on average.
				var exact := bet * 0.95
				var pay := int(floor(exact)) + (1 if rng.randf() < exact - floor(exact) else 0)
				return _finish(bet + pay, head + "  (5% commission)", Color(0.6, 1, 0.6))
		2:
			if who == "TIE":
				charm_tier = "uncommon"
				return _finish(bet * 9, head + "  pays 8 to 1!", Color(1, 0.85, 0.3))
	if who == "TIE":
		return _finish(bet, head + "  (push)", Color(0.85, 0.85, 0.9))
	return _finish(0, head, Color(1, 0.5, 0.45))


# ---------------------------------------------------------------- hi-lo

## Multiplier for a correct guess from rank r (1..13): 97% of fair odds.
static func hl_mult(r: int, hi: bool) -> float:
	var wins := (13 - r) if hi else (r - 1)
	if wins <= 0:
		return 0.0
	return 0.97 * 13.0 / float(wins)


func _eval_hilo() -> void:
	var r := hl_card % 13 + 1
	var n := hl_next % 13 + 1
	var ok := (hl_guess == "hi" and n > r) or (hl_guess == "lo" and n < r)
	hl_history.append(hl_next)
	hl_card = hl_next
	if ok:
		hl_value *= hl_mult(r, hl_guess == "hi")
		hl_rung += 1
		step = "hl"
		msg = "RIGHT!  Ladder: $%d" % int(round(hl_value))
		msg_col = Color(0.6, 1, 0.6)
		Sfx.play("coins", 1.0 + hl_rung * 0.06)
		if hl_rung == 5:
			charm_tier = "uncommon"
		elif hl_rung == 8:
			charm_tier = "rare"
		if hl_rung == 6:
			achievement = "ladder"
		if hl_rung >= 10:
			var pay := int(round(hl_value))
			_finish_quiet(pay, "TOP OF THE LADDER!  $%d" % pay, Color(1, 0.85, 0.3))
			pending_payout = pay
	else:
		_finish(0, ("SAME CARD. House wins." if n == r else "WRONG WAY.  The ladder falls."), Color(1, 0.5, 0.45))


## Payout produced inside update() that has to reach the Pot.
var pending_payout := 0


# ---------------------------------------------------------------- double or nothing

func _eval_gamble() -> int:
	var red := gamble_card / 13 == 1 or gamble_card / 13 == 2
	var ok := (gamble_pick == 0 and red) or (gamble_pick == 1 and not red)
	gambles += 1
	gamble_card = -1
	if ok:
		win *= 2
		if gambles >= 3:
			achievement = "doubler"
		step = "result"
		msg = "DOUBLED!  $%d   (UP to go again)" % win if gambles < MAX_GAMBLES else "DOUBLED!  $%d" % win
		msg_col = Color(1, 0.85, 0.3)
		big_win = win >= bet * 10
		Sfx.play("chip_big", 1.1)
		return win
	win = 0
	step = "result"
	msg = "NOTHING.  Should've walked."
	msg_col = Color(1, 0.45, 0.4)
	Sfx.play("hurt", 1.6)
	return 0


## main.gd calls this every frame after update() to collect any extra payout.
func take_pending() -> int:
	var p := pending_payout
	pending_payout = 0
	return p


# ================================================================ drawing

const PANEL := Rect2(140, 46, 1000, 628)


func draw(ci: CanvasItem, f: Font, pot: int) -> void:
	ci.draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.0, 0.04, 0.82))
	var felt := Color(0.05, 0.28, 0.17)
	if game == "slots" or game == "poker":
		felt = Color(0.07, 0.03, 0.1)
	elif game == "bar":
		felt = Color(0.12, 0.06, 0.04)
	ci.draw_rect(PANEL.grow(8), Color(0.12, 0.06, 0.03))
	ci.draw_rect(PANEL.grow(5), Color(0.62, 0.45, 0.17))
	ci.draw_rect(PANEL, felt)
	for i in 14:
		ci.draw_rect(Rect2(PANEL.position.x, PANEL.position.y + i * 45, PANEL.size.x, 1), Color(0, 0, 0, 0.1))
	ci.draw_rect(Rect2(PANEL.position, Vector2(PANEL.size.x, 2)), Color(1, 0.85, 0.45, 0.6))
	_txt(ci, f, Vector2(140, 96), title(), 40, Color(1, 0.85, 0.35), 1000)
	_txt(ci, f, Vector2(140, 126), "YOUR POT  $%d" % pot, 19, Color(0.85, 0.95, 0.85), 1000)
	match game:
		"slots": _draw_slots(ci, f)
		"blackjack": _draw_bj(ci, f)
		"roulette": _draw_roulette(ci, f)
		"poker": _draw_vp(ci, f)
		"holdem": _draw_holdem(ci, f)
		"baccarat": _draw_baccarat(ci, f)
		"hilo": _draw_hilo(ci, f)
		"bar": _draw_bar(ci, f)
	if step == "gamble":
		_draw_gamble(ci, f)
	_draw_footer(ci, f, pot)


func _draw_footer(ci: CanvasItem, f: Font, pot: int) -> void:
	var y := 600.0
	match step:
		"bar":
			_txt(ci, f, Vector2(140, 590), msg, 20, msg_col, 1000)
			_txt(ci, f, Vector2(140, 650), "< > choose     JUMP buy     DOWN leave", 18, Color(0.75, 0.85, 0.75), 1000)
		"bet":
			if msg != "":
				_txt(ci, f, Vector2(140, 548), msg, 19, msg_col, 1000)
			var n := bets.size()
			var bw := 112.0
			var x0 := 640.0 - n * (bw + 10.0) * 0.5
			for i in n:
				var r := Rect2(x0 + i * (bw + 10.0), 566, bw, 44)
				var s := i == bet_i
				var amt := bet_amount(pot)
				var afford: bool = int(bets[i]) < 0 or int(bets[i]) <= pot
				ci.draw_rect(r, Color(1, 0.85, 0.3, 0.25) if s else Color(0, 0, 0, 0.35))
				ci.draw_rect(r, Color(1, 0.85, 0.3) if s else Color(0.4, 0.5, 0.4), false, 3.0 if s else 1.0)
				_txt(ci, f, Vector2(r.position.x, r.position.y + 30), bet_label(i), 21, Color.WHITE if afford else Color(1, 1, 1, 0.3), r.size.x)
				if s and int(bets[i]) < 0:
					_txt(ci, f, Vector2(r.position.x, r.position.y + 62), "$%d" % amt, 15, Color(1, 0.9, 0.6), r.size.x)
			_txt(ci, f, Vector2(140, 652), "< > bet size     JUMP play     DOWN walk away", 17, Color(0.75, 0.85, 0.75), 1000)
		"result":
			_txt(ci, f, Vector2(140, 576), msg, 34 if big_win else 28, msg_col, 1000)
			if win > 0:
				_txt(ci, f, Vector2(140, 610), "+$%d to the Pot" % win, 21, Color(1, 0.9, 0.5), 1000)
			var g_txt := "     UP  DOUBLE OR NOTHING" if win > 0 and gambles < MAX_GAMBLES else ""
			_txt(ci, f, Vector2(140, 652), "JUMP play again" + g_txt + "     DOWN walk away", 17, Color(0.75, 0.85, 0.75), 1000)
		"gamble":
			pass
		_:
			if msg != "":
				_txt(ci, f, Vector2(140, y), msg, 21, msg_col, 1000)


func _txt(ci: CanvasItem, f: Font, pos: Vector2, s: String, sz: int, col: Color, width: float) -> void:
	ci.draw_string_outline(f, pos, s, HORIZONTAL_ALIGNMENT_CENTER, width, sz, maxi(4, sz / 5), Color(0, 0, 0, 0.85 * col.a))
	ci.draw_string(f, pos, s, HORIZONTAL_ALIGNMENT_CENTER, width, sz, col)


func _button(ci: CanvasItem, f: Font, r: Rect2, label: String, selected: bool, col := Color(0, 0, 0, 0.35), sz := 22) -> void:
	ci.draw_rect(r, Color(1, 0.85, 0.3, 0.28) if selected else col)
	ci.draw_rect(r, Color(1, 0.85, 0.3) if selected else Color(0.45, 0.5, 0.45), false, 3.0 if selected else 1.0)
	_txt(ci, f, Vector2(r.position.x, r.position.y + r.size.y * 0.5 + sz * 0.36), label, sz, Color.WHITE, r.size.x)


func _how(ci: CanvasItem, f: Font) -> void:
	if step == "bet":
		ci.draw_multiline_string(f, Vector2(240, 160), how_to(game), HORIZONTAL_ALIGNMENT_CENTER, 800, 17, 2, Color(0.85, 0.95, 0.85, 0.85))


# ---------------------------------------------------------------- slots

func _draw_slots(ci: CanvasItem, f: Font) -> void:
	var th: Dictionary = THEMES[int(machine.get("theme", 0))]
	var body: Color = th["body"]
	var trim: Color = th["trim"]
	var cab := Rect2(330, 140, 620, 400)
	ci.draw_rect(cab.grow(6), body.darkened(0.5))
	ci.draw_rect(cab, body)
	ci.draw_rect(cab, trim, false, 4.0)
	var lights := int(t * 8.0)
	for i in 20:
		var on := (i + lights) % 3 == 0
		ci.draw_circle(Vector2(cab.position.x + 16 + i * 31, cab.position.y + 14), 5.0, trim if on else trim.darkened(0.7))
	_txt(ci, f, Vector2(cab.position.x, cab.position.y + 44), "VOLATILITY: " + String(machine.get("vol", "?")) + "      ODDS: ???", 15, Color(trim, 0.9), cab.size.x)
	var win_rect := Rect2(cab.position.x + 70, cab.position.y + 58, 480, 252)
	ci.draw_rect(win_rect.grow(4), Color(0.05, 0.02, 0.05))
	for r in 3:
		var col_r := Rect2(win_rect.position.x + r * 160, win_rect.position.y, 156, win_rect.size.y)
		ci.draw_rect(col_r, Color(0.97, 0.95, 0.88))
		var spinning := step == "spin" and t < 0.7 + r * 0.42
		for y in 3:
			var cc := col_r.position + Vector2(78, 42 + y * 84)
			if spinning:
				cc.y += fposmod(t * 900.0, 84.0) - 42.0
			_symbol(ci, f, cc, int(shown[r][y]) if step != "bet" else int(grid[r][y]), spinning)
		Scenery_vshade(ci, col_r)
	# Paylines that won.
	if step == "result" or (step == "gamble"):
		for li in win_lines:
			var rows: Array = LINES[li]
			var pts := PackedVector2Array()
			for r in 3:
				pts.append(win_rect.position + Vector2(78 + r * 160, 42 + int(rows[r]) * 84))
			var pulse := 0.6 + 0.4 * sin(t * 8.0)
			ci.draw_polyline(pts, Color(LINE_COLS[li], pulse), 5.0, true)
	for li in 5:
		var rows2: Array = LINES[li]
		var yl: float = win_rect.position.y + 42 + int(rows2[0]) * 84
		ci.draw_circle(Vector2(win_rect.position.x - 16, yl + (li - 2) * 3.0 if li >= 3 else yl), 7.0, LINE_COLS[li])
	# Paytable (per line; bet is split across 5 lines).
	var pays: Dictionary = machine.get("pays", {})
	if not pays.is_empty():
		var txt := "777 x%d   CHIP x%d   BAR x%d   BELL x%d   LEMON x%d   CHERRY x%d   two cherries x%.1f" % [
			int(pays["SEVEN"]), int(pays["CHIP"]), int(pays["BAR"]), int(pays["BELL"]), int(pays["LEMON"]), int(pays["CHERRY"]), float(pays["PAIR"])]
		_txt(ci, f, Vector2(cab.position.x, cab.position.y + 340), txt, 15, Color(1, 0.92, 0.65), cab.size.x)
		_txt(ci, f, Vector2(cab.position.x, cab.position.y + 364), "Pays per line. Your bet is split across 5 lines. CHIP is wild.", 14, Color(0.75, 0.95, 1.0), cab.size.x)
		_txt(ci, f, Vector2(cab.position.x, cab.position.y + 386), "Three of a kind on any line wins a charm.", 14, Color(0.75, 0.95, 1.0), cab.size.x)


## Reel curvature shading (kept local so casino.gd has no extra dependency).
func Scenery_vshade(ci: CanvasItem, r: Rect2) -> void:
	var top := Rect2(r.position, Vector2(r.size.x, 50))
	var bot := Rect2(Vector2(r.position.x, r.end.y - 50), Vector2(r.size.x, 50))
	ci.draw_polygon(PackedVector2Array([top.position, Vector2(top.end.x, top.position.y), top.end, Vector2(top.position.x, top.end.y)]),
			PackedColorArray([Color(0, 0, 0, 0.55), Color(0, 0, 0, 0.55), Color(0, 0, 0, 0), Color(0, 0, 0, 0)]))
	ci.draw_polygon(PackedVector2Array([bot.position, Vector2(bot.end.x, bot.position.y), bot.end, Vector2(bot.position.x, bot.end.y)]),
			PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0), Color(0, 0, 0, 0.55), Color(0, 0, 0, 0.55)]))


func _symbol(ci: CanvasItem, f: Font, c: Vector2, s: int, blur: bool) -> void:
	var a := 0.45 if blur else 1.0
	match SYMS[s]:
		"CHERRY":
			ci.draw_line(c + Vector2(-12, 8), c + Vector2(4, -26), Color(0.2, 0.5, 0.2, a), 4.0)
			ci.draw_line(c + Vector2(14, 4), c + Vector2(4, -26), Color(0.2, 0.5, 0.2, a), 4.0)
			ci.draw_circle(c + Vector2(-12, 12), 13.0, Color(0.85, 0.08, 0.15, a))
			ci.draw_circle(c + Vector2(14, 8), 13.0, Color(0.85, 0.08, 0.15, a))
			ci.draw_circle(c + Vector2(-16, 7), 3.0, Color(1, 1, 1, 0.7 * a))
			ci.draw_circle(c + Vector2(10, 3), 3.0, Color(1, 1, 1, 0.7 * a))
		"LEMON":
			ci.draw_set_transform(c, 0.3, Vector2(1.4, 1.0))
			ci.draw_circle(Vector2.ZERO, 22.0, Color(0.85, 0.7, 0.1, a))
			ci.draw_circle(Vector2(-2, -2), 19.0, Color(1, 0.9, 0.2, a))
			ci.draw_set_transform(Vector2.ZERO)
			ci.draw_circle(c + Vector2(-10, -8), 4.0, Color(1, 1, 0.8, 0.6 * a))
		"BELL":
			ci.draw_colored_polygon(PackedVector2Array([c + Vector2(-26, 22), c + Vector2(-18, -6), c + Vector2(-10, -24), c + Vector2(10, -24), c + Vector2(18, -6), c + Vector2(26, 22)]), Color(1, 0.75, 0.15, a))
			ci.draw_colored_polygon(PackedVector2Array([c + Vector2(-16, 18), c + Vector2(-10, -6), c + Vector2(-5, -20), c + Vector2(-2, -20), c + Vector2(-6, 18)]), Color(1, 0.95, 0.6, 0.6 * a))
			ci.draw_circle(c + Vector2(0, 26), 6.0, Color(0.8, 0.55, 0.1, a))
		"BAR":
			ci.draw_rect(Rect2(c + Vector2(-44, -18), Vector2(88, 36)), Color(0.1, 0.1, 0.12, a))
			ci.draw_rect(Rect2(c + Vector2(-44, -18), Vector2(88, 36)), Color(1, 0.85, 0.3, a), false, 2.0)
			ci.draw_string(f, c + Vector2(-44, 11), "BAR", HORIZONTAL_ALIGNMENT_CENTER, 88, 30, Color(1, 1, 1, a))
		"CHIP":
			ci.draw_circle(c, 29.0, Color(0.4, 0.12, 0.6, a))
			ci.draw_circle(c, 26.0, Color(0.6, 0.25, 0.9, a))
			for i in 6:
				var p := c + Vector2.from_angle(TAU * i / 6.0 + t * (0.0 if blur else 1.0)) * 21.0
				ci.draw_rect(Rect2(p - Vector2(3, 3), Vector2(6, 6)), Color(1, 1, 1, 0.85 * a))
			ci.draw_circle(c, 14.0, Color(0.85, 0.7, 1, a))
			ci.draw_string(f, c + Vector2(-20, 6), "WILD", HORIZONTAL_ALIGNMENT_CENTER, 40, 13, Color(0.3, 0.05, 0.4, a))
		"SEVEN":
			ci.draw_string_outline(f, c + Vector2(-50, 28), "7", HORIZONTAL_ALIGNMENT_CENTER, 100, 78, 6, Color(0.4, 0.0, 0.05, a))
			ci.draw_string(f, c + Vector2(-50, 28), "7", HORIZONTAL_ALIGNMENT_CENTER, 100, 78, Color(0.92, 0.1, 0.15, a))


# ---------------------------------------------------------------- cards

func _card(ci: CanvasItem, f: Font, pos: Vector2, c: int, hidden: bool, sc := 1.0) -> void:
	var w := 70.0 * sc
	var h := 100.0 * sc
	var r := Rect2(pos, Vector2(w, h))
	ci.draw_rect(Rect2(pos + Vector2(3, 4), r.size), Color(0, 0, 0, 0.35))
	ci.draw_rect(r.grow(2), Color(0.05, 0.02, 0.05))
	if hidden:
		ci.draw_rect(r, Color(0.6, 0.08, 0.15))
		ci.draw_rect(r.grow(-7 * sc), Color(0.85, 0.65, 0.25), false, 2.0)
		var cc := r.get_center()
		ci.draw_colored_polygon(PackedVector2Array([cc + Vector2(0, -18) * sc, cc + Vector2(12, 0) * sc, cc + Vector2(0, 18) * sc, cc + Vector2(-12, 0) * sc]), Color(0.85, 0.65, 0.25))
		return
	ci.draw_rect(r, Color(0.98, 0.97, 0.93))
	var suit := c / 13
	var red := suit == 1 or suit == 2
	var col := Color(0.85, 0.1, 0.15) if red else Color(0.08, 0.08, 0.1)
	ci.draw_string(f, pos + Vector2(6, 26) * sc, RANKS[c % 13], HORIZONTAL_ALIGNMENT_LEFT, -1, int(24 * sc), col)
	_pip(ci, pos + Vector2(14, 38) * sc, suit, col, 0.42 * sc)
	_pip(ci, pos + Vector2(38, 64) * sc, suit, col, 1.0 * sc)


func _pip(ci: CanvasItem, sc: Vector2, suit: int, col: Color, s: float) -> void:
	match suit:
		0:
			ci.draw_circle(sc + Vector2(-7, 2) * s, 8.0 * s, col)
			ci.draw_circle(sc + Vector2(7, 2) * s, 8.0 * s, col)
			ci.draw_colored_polygon(PackedVector2Array([sc + Vector2(-14, 0) * s, sc + Vector2(14, 0) * s, sc + Vector2(0, -20) * s]), col)
			ci.draw_rect(Rect2(sc + Vector2(-2, 4) * s, Vector2(4, 12) * s), col)
		1:
			ci.draw_circle(sc + Vector2(-7, -6) * s, 8.0 * s, col)
			ci.draw_circle(sc + Vector2(7, -6) * s, 8.0 * s, col)
			ci.draw_colored_polygon(PackedVector2Array([sc + Vector2(-15, -3) * s, sc + Vector2(15, -3) * s, sc + Vector2(0, 16) * s]), col)
		2:
			ci.draw_colored_polygon(PackedVector2Array([sc + Vector2(0, -18) * s, sc + Vector2(13, 0) * s, sc + Vector2(0, 18) * s, sc + Vector2(-13, 0) * s]), col)
		3:
			ci.draw_circle(sc + Vector2(0, -9) * s, 7.0 * s, col)
			ci.draw_circle(sc + Vector2(-8, 3) * s, 7.0 * s, col)
			ci.draw_circle(sc + Vector2(8, 3) * s, 7.0 * s, col)
			ci.draw_rect(Rect2(sc + Vector2(-2, 4) * s, Vector2(4, 13) * s), col)


func _hand(ci: CanvasItem, f: Font, cx: float, y: float, cards: Array, hide_from := 99, sc := 1.0) -> void:
	var w := 80.0 * sc
	for i in cards.size():
		_card(ci, f, Vector2(cx - cards.size() * w * 0.5 + i * w + 5 * sc, y), cards[i], i >= hide_from, sc)


func _draw_bj(ci: CanvasItem, f: Font) -> void:
	_how(ci, f)
	if step == "bet" and ph.is_empty():
		return
	var reveal := step == "dealer" or step == "result" or step == "gamble"
	_txt(ci, f, Vector2(140, 178), "DEALER" + ("  %d" % hand_value(dh) if reveal else ""), 20, Color(0.9, 0.95, 0.9), 1000)
	_hand(ci, f, 640, 192, dh, 99 if reveal else 1)
	if card_sense and not reveal and dh.size() > 1:
		_txt(ci, f, Vector2(140, 312), "CARD SENSE: hole card is %s" % ("10-value" if card_val(dh[1]) == 10 else ("an ACE" if dh[1] % 13 == 0 else "low")), 15, Color(0.6, 0.95, 1.0), 1000)
	_txt(ci, f, Vector2(140, 346), "YOU  %d" % hand_value(ph) + ("   (DOUBLED)" if doubled else ""), 20, Color(1, 0.9, 0.6), 1000)
	_hand(ci, f, 640, 360, ph)
	if step == "bj":
		var labels := ["HIT", "STAND"]
		if ph.size() == 2:
			labels.append("DOUBLE")
		for i in labels.size():
			var r := Rect2(640 - labels.size() * 95 + i * 190, 486, 170, 46)
			_button(ci, f, r, labels[i], i == sel)


func _draw_vp(ci: CanvasItem, f: Font) -> void:
	# Paytable.
	var pr := Rect2(250, 140, 780, 150)
	ci.draw_rect(pr, Color(0.03, 0.02, 0.15))
	ci.draw_rect(pr, Color(1, 0.85, 0.3, 0.7), false, 2.0)
	for i in VP_ORDER.size():
		var col_i := i / 5
		var row := i % 5
		var nm: String = VP_ORDER[i]
		var hit := (step == "result" or step == "gamble") and vp_hand == nm
		var y := pr.position.y + 26 + row * 26
		var x := pr.position.x + 20 + col_i * 390
		if hit:
			ci.draw_rect(Rect2(x - 8, y - 19, 370, 25), Color(1, 0.85, 0.3, 0.3 + 0.2 * sin(t * 8.0)))
		ci.draw_string(f, Vector2(x, y), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color(1, 0.9, 0.4) if hit else Color(1, 1, 0.75))
		ci.draw_string(f, Vector2(x, y), "x%d" % VP_PAY[nm], HORIZONTAL_ALIGNMENT_RIGHT, 340, 17, Color(1, 0.9, 0.4) if hit else Color(1, 1, 0.75))
	if step == "bet" and ph.is_empty():
		_how(ci, f)
		return
	var sc := 1.4
	for i in ph.size():
		var pos := Vector2(640 - 5 * 52 + i * 104, 322)
		_card(ci, f, pos, ph[i], false, sc)
		if held[i]:
			_txt(ci, f, Vector2(pos.x, pos.y - 8), "HELD", 18, Color(1, 0.85, 0.3), 98)
		if step == "vp" and sel == i:
			ci.draw_rect(Rect2(pos - Vector2(6, 6), Vector2(98 + 12, 140 + 12)), Color(1, 0.85, 0.3, 0.6 + 0.4 * sin(t * 8.0)), false, 3.0)
	if step == "vp":
		_button(ci, f, Rect2(560, 488, 160, 44), "DRAW", sel == 5, Color(0.5, 0.08, 0.12))
		_txt(ci, f, Vector2(140, 548), ("Now holding: " + vp_hand) if vp_hand != "" else "< > pick a card    JUMP hold / draw", 17, Color(0.8, 0.95, 0.8), 1000)


func _draw_holdem(ci: CanvasItem, f: Font) -> void:
	_how(ci, f)
	if step == "bet" and ph.is_empty():
		_txt(ci, f, Vector2(140, 260), "ANTE BONUS:  Straight 1:1   Flush 2:1   Full House 3:1   Quads 10:1   Straight Flush 20:1   Royal 100:1", 15, Color(1, 0.9, 0.6), 1000)
		return
	var reveal := step == "result" or step == "gamble"
	_txt(ci, f, Vector2(140, 160), "DEALER", 18, Color(0.9, 0.95, 0.9), 1000)
	_hand(ci, f, 640, 170, dh, 99 if reveal else 0, 0.85)
	var shown_n := he_reveal if step != "he" else 3
	if reveal:
		shown_n = 5
	for i in 5:
		_card(ci, f, Vector2(640 - 5 * 40 + i * 80, 272), board[i], i >= shown_n, 0.95)
	_txt(ci, f, Vector2(140, 400), "YOU" + ("   " + hand_name(best_of(ph + board.slice(0, shown_n))) if shown_n >= 3 else ""), 18, Color(1, 0.9, 0.6), 1000)
	_hand(ci, f, 640, 410, ph, 99, 0.85)
	_txt(ci, f, Vector2(140, 542), "ANTE $%d%s" % [bet, ("     CALL $%d" % (bet * 2)) if step != "he" else ""], 15, Color(0.85, 0.95, 0.85), 1000)
	if step == "he":
		_button(ci, f, Rect2(420, 488, 200, 44), "CALL  $%d" % (bet * 2), sel == 0)
		_button(ci, f, Rect2(660, 488, 200, 44), "FOLD", sel == 1, Color(0.35, 0.05, 0.08))
	if reveal and he_text != "":
		_txt(ci, f, Vector2(140, 520), he_text, 17, Color(1, 1, 1, 0.9), 1000)


func _draw_baccarat(ci: CanvasItem, f: Font) -> void:
	_how(ci, f)
	var labels := ["PLAYER  x2", "BANKER  x1.95", "TIE  x9"]
	if step == "bet" or step == "bac_pick":
		for i in 3:
			var r := Rect2(300 + i * 240, 300, 200, 60)
			_button(ci, f, r, labels[i], step == "bac_pick" and i == bac_pick, [Color(0.1, 0.2, 0.5), Color(0.5, 0.08, 0.1), Color(0.1, 0.4, 0.2)][i])
		if step == "bac_pick":
			_txt(ci, f, Vector2(140, 410), "< > pick a side     JUMP deal     DOWN change bet", 17, Color(0.8, 0.9, 0.8), 1000)
		return
	_txt(ci, f, Vector2(220, 186), "PLAYER", 26, Color(0.55, 0.75, 1), 400)
	_txt(ci, f, Vector2(660, 186), "BANKER", 26, Color(1, 0.55, 0.55), 400)
	var pshow: Array = []
	var bshow: Array = []
	for i in bac_shown:
		var o: Array = bac_order[i]
		if o[0] == "p":
			pshow.append(bac_p[o[1]])
		else:
			bshow.append(bac_b[o[1]])
	_hand(ci, f, 420, 210, pshow)
	_hand(ci, f, 860, 210, bshow)
	_txt(ci, f, Vector2(220, 360), str(bac_total(pshow)), 54, Color.WHITE, 400)
	_txt(ci, f, Vector2(660, 360), str(bac_total(bshow)), 54, Color.WHITE, 400)
	_txt(ci, f, Vector2(140, 420), "Your bet: " + labels[bac_pick].split(" ")[0], 18, Color(1, 0.9, 0.6), 1000)


func _draw_hilo(ci: CanvasItem, f: Font) -> void:
	_how(ci, f)
	if step == "bet" and hl_history.is_empty():
		return
	if step == "bet":
		return
	# Recent cards along the top.
	var hist: Array = hl_history.slice(maxi(0, hl_history.size() - 8))
	for i in hist.size():
		_card(ci, f, Vector2(250 + i * 50, 150), hist[i], false, 0.55)
	var cc := Vector2(470, 240)
	_card(ci, f, cc, hl_card, false, 1.9)
	if step == "hl_flip":
		var k := clampf(dealer_t / 0.6, 0.0, 1.0)
		_card(ci, f, Vector2(cc.x + 180, cc.y), hl_next, k < 0.5, 1.9)
	var r := hl_card % 13 + 1
	# The ladder.
	var lx := 930.0
	_txt(ci, f, Vector2(lx - 40, 172), "LADDER", 18, Color(1, 0.85, 0.35), 220)
	for i in 10:
		var ry := 500.0 - i * 32.0
		var reached := i < hl_rung
		var cur := i == hl_rung
		ci.draw_rect(Rect2(lx, ry, 140, 26), Color(1, 0.85, 0.3, 0.35) if reached else (Color(1, 1, 1, 0.12) if cur else Color(0, 0, 0, 0.3)))
		ci.draw_rect(Rect2(lx, ry, 140, 26), Color(1, 0.85, 0.3, 0.7), false, 1.0)
		ci.draw_string(f, Vector2(lx + 8, ry + 19), "RUNG %d" % (i + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
	_txt(ci, f, Vector2(140, 478), "LADDER  $%d" % int(round(hl_value)), 28, Color(1, 0.9, 0.5), 680)
	if step == "hl":
		var mh := hl_mult(r, true)
		var ml := hl_mult(r, false)
		var labels := ["HIGHER" + ("  x%.2f" % mh if mh > 0.0 else ""), "LOWER" + ("  x%.2f" % ml if ml > 0.0 else ""), "CASH OUT" if hl_rung > 0 else "BACK OUT"]
		for i in 3:
			_button(ci, f, Rect2(250 + i * 200, 500, 186, 44), labels[i], sel == i, Color(0.35, 0.05, 0.08) if i == 2 else Color(0, 0, 0, 0.35), 18)


func _draw_roulette(ci: CanvasItem, f: Font) -> void:
	var c := Vector2(380, 330)
	var rr := 130.0
	ci.draw_circle(c, rr + 16.0, Color(0.3, 0.17, 0.07))
	ci.draw_circle(c, rr + 9.0, Color(0.85, 0.65, 0.25))
	for i in WHEEL.size():
		var a0 := wheel_a + i * TAU / WHEEL.size()
		var a1 := a0 + TAU / WHEEL.size()
		var n: int = WHEEL[i]
		var col := Color(0.1, 0.55, 0.2) if n == 0 else (Color(0.8, 0.08, 0.14) if REDS.has(n) else Color(0.08, 0.08, 0.1))
		ci.draw_colored_polygon(PackedVector2Array([c + Vector2.from_angle(a0) * rr * 0.6, c + Vector2.from_angle(a0) * rr, c + Vector2.from_angle(a1) * rr, c + Vector2.from_angle(a1) * rr * 0.6]), col)
	ci.draw_circle(c, rr * 0.6, Color(0.4, 0.25, 0.1))
	for i in 4:
		var a := -wheel_a * 0.5 + i * PI * 0.5
		ci.draw_line(c, c + Vector2.from_angle(a) * rr * 0.5, Color(0.95, 0.8, 0.4), 4.0)
	ci.draw_circle(c, rr * 0.14, Color(0.95, 0.8, 0.4))
	if step == "spin" or step == "result" or step == "gamble":
		var idx: int = WHEEL.find(result_n)
		var settle := clampf(1.0 - wheel_v / 9.0, 0.0, 1.0)
		var ball_a := lerpf(-t * 9.0, wheel_a + (idx + 0.5) * TAU / WHEEL.size(), settle)
		ci.draw_circle(c + Vector2.from_angle(ball_a) * rr * lerpf(1.05, 0.82, settle), 7.0, Color.WHITE)
		if step != "spin":
			var col2 := Color(0.1, 0.55, 0.2) if result_n == 0 else (Color(0.8, 0.08, 0.14) if REDS.has(result_n) else Color(0.08, 0.08, 0.1))
			ci.draw_circle(c, 30.0, col2)
			_txt(ci, f, Vector2(c.x - 40, c.y + 12), str(result_n), 32, Color.WHITE, 80)
	# Betting board.
	for i in RBETS.size():
		var col_i := i % 3
		var row := i / 3
		var r := Rect2(600 + col_i * 172, 168 + row * 66, 160, 54)
		var kind: String = RBETS[i][1]
		var bg := Color(0, 0, 0, 0.35)
		match kind:
			"red": bg = Color(0.65, 0.06, 0.12)
			"black": bg = Color(0.06, 0.06, 0.08)
			"zero": bg = Color(0.08, 0.45, 0.2)
		var label: String = RBETS[i][0]
		if kind == "num":
			label = "NUMBER %d" % number
		var chosen := i == pick and step != "bet"
		_button(ci, f, r, label, chosen, bg, 18)
		_txt(ci, f, Vector2(r.position.x, r.end.y - 4), "x%d" % RBETS[i][2], 12, Color(1, 0.9, 0.6, 0.85), r.size.x)
	if step == "pick":
		_txt(ci, f, Vector2(140, 560), "< > choose a bet     JUMP spin" + ("     UP change number" if RBETS[pick][1] == "num" else ""), 17, Color(0.8, 0.9, 0.8), 1000)
	elif step == "num":
		_txt(ci, f, Vector2(140, 560), "< > pick your number (1-36)     JUMP spin     DOWN back", 17, Color(1, 0.9, 0.6), 1000)
	elif step == "bet":
		_txt(ci, f, Vector2(140, 156), how_to("roulette"), 16, Color(0.85, 0.95, 0.85, 0.85), 1000)


func _draw_gamble(ci: CanvasItem, f: Font) -> void:
	ci.draw_rect(PANEL, Color(0.02, 0.0, 0.04, 0.82))
	_txt(ci, f, Vector2(140, 200), "DOUBLE OR NOTHING", 46, Color(1, 0.85, 0.3), 1000)
	_txt(ci, f, Vector2(140, 240), "On the line:  $%d     Win it and it's $%d" % [win, win * 2], 22, Color.WHITE, 1000)
	var flipping := gamble_card >= 0
	var k := clampf(gamble_t / 0.5, 0.0, 1.0)
	_card(ci, f, Vector2(570, 270), gamble_card if flipping and k >= 0.5 else 0, not (flipping and k >= 0.5), 2.0)
	_button(ci, f, Rect2(380, 510, 220, 54), "RED", gamble_pick == 0, Color(0.6, 0.06, 0.12), 26)
	_button(ci, f, Rect2(680, 510, 220, 54), "BLACK", gamble_pick == 1, Color(0.06, 0.06, 0.08), 26)
	_txt(ci, f, Vector2(140, 606), "< > pick a color     JUMP flip     DOWN keep the money", 17, Color(0.8, 0.9, 0.8), 1000)
	_txt(ci, f, Vector2(140, 636), "Round %d of %d" % [gambles + 1, MAX_GAMBLES], 15, Color(1, 1, 1, 0.6), 1000)


# ---------------------------------------------------------------- Lucky's bar

func drink_cost(i: int) -> int:
	return int(round(int(DRINKS[i][3]) * price_scale * discount))


func _bar_press(action: String, pot: int) -> int:
	match action:
		"left":
			bar_i = (bar_i + DRINKS.size() - 1) % DRINKS.size()
			Sfx.play("tick")
		"right":
			bar_i = (bar_i + 1) % DRINKS.size()
			Sfx.play("tick")
		"back":
			done = true
		"confirm":
			var c := drink_cost(bar_i)
			if pot < c:
				msg = "Lucky: \"Your Pot's light, pal. Come back richer.\""
				msg_col = Color(1, 0.5, 0.45)
				Sfx.play("deny")
			else:
				bought = DRINKS[bar_i][0]
				msg = "Lucky: \"%s, coming right up.\"" % String(DRINKS[bar_i][1]).capitalize()
				msg_col = Color(0.6, 1, 0.65)
				Sfx.play("buy")
				return -c
	return 0


func _draw_bar(ci: CanvasItem, f: Font) -> void:
	for i in DRINKS.size():
		var r := Rect2(290 + i * 240, 190, 220, 300)
		var s := i == bar_i
		ci.draw_rect(r, Color(0.2, 0.1, 0.06) if not s else Color(0.35, 0.2, 0.1))
		ci.draw_rect(r, Color(1, 0.85, 0.3) if s else Color(0.5, 0.4, 0.3), false, 3.0 if s else 1.0)
		var c := r.position + Vector2(110, 100)
		var cols := [Color(0.9, 0.2, 0.25), Color(0.3, 0.8, 1), Color(0.5, 1, 0.5)]
		ci.draw_colored_polygon(PackedVector2Array([c + Vector2(-26, -40), c + Vector2(26, -40), c + Vector2(14, 30), c + Vector2(-14, 30)]), Color(0.85, 0.95, 1, 0.35))
		ci.draw_colored_polygon(PackedVector2Array([c + Vector2(-21, -15), c + Vector2(21, -15), c + Vector2(13, 26), c + Vector2(-13, 26)]), cols[i])
		ci.draw_rect(Rect2(c + Vector2(-18, -13), Vector2(36, 3)), Color(1, 1, 1, 0.4))
		_txt(ci, f, Vector2(r.position.x, r.position.y + 190), DRINKS[i][1], 20, Color.WHITE, r.size.x)
		_txt(ci, f, Vector2(r.position.x, r.position.y + 220), DRINKS[i][2], 15, Color(0.85, 0.8, 0.7), r.size.x)
		_txt(ci, f, Vector2(r.position.x, r.position.y + 268), "$%d" % drink_cost(i), 26, Color(1, 0.85, 0.35), r.size.x)
