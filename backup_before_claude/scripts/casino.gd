extends RefCounted
## Playable casino games, bet out of the Pot: slots, blackjack, roulette.
## The game owns logic + drawing; main feeds it input and applies pot deltas.

const SYMS := ["CHERRY", "LEMON", "BELL", "BAR", "CHIP", "SEVEN"]
const BASE_W := [30.0, 25.0, 18.0, 14.0, 9.0, 4.0]
const PAY3 := {"CHERRY": 5, "LEMON": 8, "BELL": 15, "BAR": 25, "CHIP": 40, "SEVEN": 100}
const BETS := [5, 25, 100, -1]
const REDS := [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
const WHEEL := [0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26]

var game := "slots"
var step := "bet"
var bet_i := 0
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
const DRINKS := [["shot", "SHOT OF COURAGE", "+1 life", 60], ["flow", "LIQUID FLOW", "Max out your Flow", 35], ["lucky", "LUCKY CHARM", "Chips worth x2 this floor", 80]]

var reel_final := [0, 0, 0]
var reel_shown := [0, 0, 0]

var deck: Array = []
var ph: Array = []
var dh: Array = []
var bj_sel := 0
var dealer_t := 0.0

var pick := 0
var wheel_a := 0.0
var wheel_v := 0.0
var result_n := -1


func open(g: String, lucky: int, floor_num := 1) -> void:
	price_scale = 1 + floor_num / 3
	game = g
	luck = lucky
	step = "bet"
	msg = ""
	done = false
	if g == "bar":
		step = "bar"
		msg = "Lucky: \"What'll it be, runner? Paid from the Pot.\""
		msg_col = Color(0.6, 1, 0.65)
	t = 0.0


func bet_amount(pot: int) -> int:
	var b: int = BETS[bet_i]
	return pot if b < 0 else b


func title() -> String:
	match game:
		"slots": return "LUCKY SEVENS"
		"bar": return "LUCKY'S BAR"
		"blackjack": return "BLACKJACK"
	return "ROULETTE"


## Handle a just-pressed action. Returns the pot delta to apply now.
func press(action: String, pot: int) -> int:
	if step == "bar":
		return _bar_press(action, pot)
	match step:
		"bet":
			if action == "left":
				bet_i = (bet_i + BETS.size() - 1) % BETS.size()
				Sfx.play("tick")
			elif action == "right":
				bet_i = (bet_i + 1) % BETS.size()
				Sfx.play("tick")
			elif action == "back":
				done = true
			elif action == "confirm":
				var b := bet_amount(pot)
				if pot <= 0 or b <= 0:
					msg = "Your Pot is empty. Go win something."
					msg_col = Color(1, 0.5, 0.4)
				elif b > pot:
					msg = "Not enough in the Pot for that bet."
					msg_col = Color(1, 0.5, 0.4)
				else:
					bet = b
					_start()
					return -b
		"bj":
			if action == "left" or action == "right":
				bj_sel = 1 - bj_sel
				Sfx.play("tick")
			elif action == "confirm":
				if bj_sel == 0:
					ph.append(_draw_card())
					Sfx.play("tick", 1.4)
					if hand_value(ph) > 21:
						return _finish(0, "BUST", Color(1, 0.4, 0.4))
					if hand_value(ph) == 21:
						step = "dealer"
						dealer_t = 0.0
				else:
					step = "dealer"
					dealer_t = 0.0
		"pick":
			if action == "left":
				pick = (pick + 2) % 3
				Sfx.play("tick")
			elif action == "right":
				pick = (pick + 1) % 3
				Sfx.play("tick")
			elif action == "confirm":
				step = "spin"
				t = 0.0
				wheel_v = randf_range(9.0, 12.0)
				result_n = WHEEL[randi() % WHEEL.size()]
				Sfx.play("swing", 0.6)
			elif action == "back":
				step = "bet"
				return bet
		"result":
			if action == "confirm":
				step = "bet"
				msg = ""
			elif action == "back":
				done = true
	return 0


func _start() -> void:
	msg = ""
	win = 0
	big_win = false
	t = 0.0
	match game:
		"slots":
			for i in 3:
				reel_final[i] = _roll_sym()
			step = "spin"
			Sfx.play("swing", 0.8)
		"blackjack":
			deck = range(52)
			deck.shuffle()
			ph = [_draw_card(), _draw_card()]
			dh = [_draw_card(), _draw_card()]
			bj_sel = 0
			step = "bj"
			if hand_value(ph) == 21:
				step = "dealer"
				dealer_t = 0.0
		"roulette":
			step = "pick"


func _roll_sym() -> int:
	var w := BASE_W.duplicate()
	w[4] += luck * 2.0
	w[5] += luck * 1.5
	var total := 0.0
	for x in w:
		total += x
	var r := randf() * total
	for i in w.size():
		r -= w[i]
		if r <= 0.0:
			return i
	return 0


func _draw_card() -> int:
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


func _finish(payout: int, text: String, col: Color) -> int:
	win = payout
	step = "result"
	msg = text
	msg_col = col
	big_win = payout >= bet * 10 and payout > 0
	if payout > bet:
		Sfx.play("chip_big")
	elif payout == 0:
		Sfx.play("hurt", 1.6)
	return payout


## Advance animations. Returns the pot delta to apply (payouts).
func update(delta: float) -> int:
	t += delta
	match step:
		"spin":
			if game == "slots":
				for i in 3:
					if t < 0.8 + i * 0.45:
						reel_shown[i] = randi() % SYMS.size()
					else:
						if reel_shown[i] != reel_final[i]:
							Sfx.play("tick", 0.8)
						reel_shown[i] = reel_final[i]
				if t > 0.8 + 2 * 0.45 + 0.3:
					return _eval_slots()
			else:
				wheel_v = maxf(0.0, wheel_v - delta * 3.2)
				wheel_a += wheel_v * delta
				if wheel_v <= 0.0 and t > 1.0:
					return _eval_roulette()
		"dealer":
			dealer_t += delta
			if dealer_t > 0.6:
				dealer_t = 0.0
				if hand_value(dh) < 17:
					dh.append(_draw_card())
					Sfx.play("tick", 1.2)
				else:
					return _eval_bj()
	return 0


func _eval_slots() -> int:
	var a: String = SYMS[reel_final[0]]
	var b: String = SYMS[reel_final[1]]
	var c: String = SYMS[reel_final[2]]
	if a == "SEVEN" and b == "SEVEN" and c == "SEVEN":
		achievement = "jackpot"
	if a == b and b == c:
		var m: int = PAY3[a]
		return _finish(bet * m, ("JACKPOT!!  " if a == "SEVEN" else "THREE %sS!  " % a) + "x%d" % m, Color(1, 0.85, 0.3))
	var cherries := [a, b, c].count("CHERRY")
	if cherries == 2:
		return _finish(bet * 2, "TWO CHERRIES  x2", Color(0.6, 1, 0.6))
	return _finish(0, "NO DICE", Color(1, 0.5, 0.45))


func _eval_bj() -> int:
	var p := hand_value(ph)
	var d := hand_value(dh)
	if p == 21 and ph.size() == 2 and not (d == 21 and dh.size() == 2):
		achievement = "blackjack"
		return _finish(int(bet * 2.5), "BLACKJACK!  x2.5", Color(1, 0.85, 0.3))
	if d > 21 or p > d:
		return _finish(bet * 2, "YOU WIN  %d vs %d" % [p, d], Color(0.6, 1, 0.6))
	if p == d:
		return _finish(bet, "PUSH  %d" % p, Color(0.85, 0.85, 0.9))
	return _finish(0, "HOUSE WINS  %d vs %d" % [d, p], Color(1, 0.5, 0.45))


func _eval_roulette() -> int:
	var col := 2 if result_n == 0 else (0 if REDS.has(result_n) else 1)
	var names := ["RED", "BLACK", "GREEN"]
	if col == pick:
		var m := 36 if pick == 2 else 2
		return _finish(bet * m, "%d %s!  x%d" % [result_n, names[col], m], Color(1, 0.85, 0.3) if pick == 2 else Color(0.6, 1, 0.6))
	return _finish(0, "%d %s. House wins." % [result_n, names[col]], Color(1, 0.5, 0.45))


# ---------------------------------------------------------------- drawing

func draw(ci: CanvasItem, f: Font, pot: int) -> void:
	ci.draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.0, 0.04, 0.8))
	var panel := Rect2(240, 90, 800, 540)
	ci.draw_rect(panel.grow(6), Color(0.55, 0.4, 0.15))
	ci.draw_rect(panel, Color(0.05, 0.28, 0.17))
	for i in 12:
		ci.draw_rect(Rect2(panel.position.x, panel.position.y + i * 45, panel.size.x, 1), Color(0, 0, 0, 0.12))
	_txt(ci, f, Vector2(240, 142), title(), 44, Color(1, 0.85, 0.35), 800)
	_txt(ci, f, Vector2(240, 176), "Betting from your Pot:  $%d" % pot, 20, Color(0.85, 0.95, 0.85), 800)
	match game:
		"slots":
			_draw_slots(ci, f)
		"blackjack":
			_draw_bj(ci, f)
		"roulette":
			_draw_roulette(ci, f)
		"bar":
			_draw_bar(ci, f)
	if step == "bar":
		_txt(ci, f, Vector2(240, 560), msg, 20, msg_col, 800)
	elif step == "bet":
		_txt(ci, f, Vector2(240, 520), "BET", 20, Color(0.8, 0.9, 0.8), 800)
		for i in BETS.size():
			var r := Rect2(380 + i * 135, 535, 115, 46)
			var sel := i == bet_i
			ci.draw_rect(r, Color(1, 0.85, 0.3, 0.25) if sel else Color(0, 0, 0, 0.3))
			ci.draw_rect(r, Color(1, 0.85, 0.3) if sel else Color(0.4, 0.5, 0.4), false, 3.0 if sel else 1.0)
			var label := "ALL IN" if BETS[i] < 0 else "$%d" % BETS[i]
			_txt(ci, f, Vector2(r.position.x, r.position.y + 32), label, 24, Color.WHITE, r.size.x)
		_txt(ci, f, Vector2(240, 610), "< > bet     JUMP play     DOWN walk away", 18, Color(0.75, 0.85, 0.75), 800)
	elif step == "result":
		_txt(ci, f, Vector2(240, 560), msg, 40 if big_win else 32, msg_col, 800)
		if win > 0:
			_txt(ci, f, Vector2(240, 592), "+$%d to the Pot" % win, 22, Color(1, 0.9, 0.5), 800)
		_txt(ci, f, Vector2(240, 615), "JUMP play again     DOWN walk away", 18, Color(0.75, 0.85, 0.75), 800)
	elif msg != "":
		_txt(ci, f, Vector2(240, 560), msg, 22, msg_col, 800)


func _txt(ci: CanvasItem, f: Font, pos: Vector2, s: String, sz: int, col: Color, width: float) -> void:
	ci.draw_string_outline(f, pos, s, HORIZONTAL_ALIGNMENT_CENTER, width, sz, maxi(4, sz / 5), Color(0, 0, 0, 0.85))
	ci.draw_string(f, pos, s, HORIZONTAL_ALIGNMENT_CENTER, width, sz, col)


func _draw_slots(ci: CanvasItem, f: Font) -> void:
	var cab := Rect2(430, 200, 420, 290)
	ci.draw_rect(cab, Color(0.35, 0.06, 0.12))
	ci.draw_rect(cab, Color(1, 0.8, 0.3), false, 4.0)
	for i in 3:
		var r := Rect2(455 + i * 130, 240, 110, 150)
		ci.draw_rect(r, Color(0.97, 0.95, 0.88))
		ci.draw_rect(r, Color(0.1, 0.05, 0.08), false, 3.0)
		_symbol(ci, f, r.get_center(), reel_shown[i] if step != "bet" else reel_final[i], step == "spin" and t < 0.8 + i * 0.45)
	ci.draw_rect(Rect2(450, 312, 380, 3), Color(1, 0.2, 0.3, 0.6))
	_txt(ci, f, Vector2(430, 430), "777 x100   CHIP x40   BAR x25   BELL x15", 16, Color(1, 0.9, 0.6), 420)
	_txt(ci, f, Vector2(430, 455), "LEMON x8   CHERRY x5   two cherries x2", 16, Color(1, 0.9, 0.6), 420)
	var lights := int(t * 8.0)
	for i in 14:
		var on := (i + lights) % 3 == 0
		ci.draw_circle(Vector2(442 + i * 30, 214), 5.0, Color(1, 0.85, 0.3) if on else Color(0.4, 0.2, 0.1))


func _symbol(ci: CanvasItem, f: Font, c: Vector2, s: int, blur: bool) -> void:
	var a := 0.5 if blur else 1.0
	match SYMS[s]:
		"CHERRY":
			ci.draw_line(c + Vector2(-12, 10), c + Vector2(4, -26), Color(0.2, 0.5, 0.2, a), 4.0)
			ci.draw_line(c + Vector2(14, 6), c + Vector2(4, -26), Color(0.2, 0.5, 0.2, a), 4.0)
			ci.draw_circle(c + Vector2(-12, 14), 13.0, Color(0.85, 0.08, 0.15, a))
			ci.draw_circle(c + Vector2(14, 10), 13.0, Color(0.85, 0.08, 0.15, a))
			ci.draw_circle(c + Vector2(-16, 9), 3.0, Color(1, 1, 1, 0.7 * a))
		"LEMON":
			ci.draw_set_transform(c, 0.3, Vector2(1.4, 1.0))
			ci.draw_circle(Vector2.ZERO, 22.0, Color(1, 0.9, 0.2, a))
			ci.draw_set_transform(Vector2.ZERO)
		"BELL":
			ci.draw_colored_polygon(PackedVector2Array([c + Vector2(-26, 22), c + Vector2(-18, -6), c + Vector2(-10, -24), c + Vector2(10, -24), c + Vector2(18, -6), c + Vector2(26, 22)]), Color(1, 0.8, 0.2, a))
			ci.draw_circle(c + Vector2(0, 26), 6.0, Color(0.8, 0.55, 0.1, a))
		"BAR":
			ci.draw_rect(Rect2(c + Vector2(-42, -18), Vector2(84, 36)), Color(0.1, 0.1, 0.12, a))
			_txt(ci, f, c + Vector2(-42, 11), "BAR", 30, Color(1, 1, 1, a), 84)
		"CHIP":
			ci.draw_circle(c, 28.0, Color(0.55, 0.25, 0.85, a))
			ci.draw_circle(c, 19.0, Color(0.35, 0.12, 0.6, a))
			ci.draw_circle(c, 10.0, Color(0.8, 0.6, 1, a))
		"SEVEN":
			_txt(ci, f, c + Vector2(-50, 26), "7", 80, Color(0.9, 0.1, 0.15, a), 100)


func _card(ci: CanvasItem, f: Font, pos: Vector2, c: int, hidden: bool) -> void:
	var r := Rect2(pos, Vector2(70, 100))
	ci.draw_rect(r.grow(2), Color(0.05, 0.02, 0.05))
	if hidden:
		ci.draw_rect(r, Color(0.6, 0.08, 0.15))
		ci.draw_rect(r.grow(-8), Color(0.85, 0.65, 0.25), false, 2.0)
		return
	ci.draw_rect(r, Color(0.98, 0.97, 0.93))
	var suit := c / 13
	var red := suit == 1 or suit == 2
	var col := Color(0.85, 0.1, 0.15) if red else Color(0.08, 0.08, 0.1)
	var ranks := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
	ci.draw_string(f, pos + Vector2(6, 26), ranks[c % 13], HORIZONTAL_ALIGNMENT_LEFT, -1, 24, col)
	var sc := pos + Vector2(35, 62)
	match suit:
		0:
			ci.draw_circle(sc + Vector2(-7, 0), 8.0, col)
			ci.draw_circle(sc + Vector2(7, 0), 8.0, col)
			ci.draw_colored_polygon(PackedVector2Array([sc + Vector2(-15, -14), sc + Vector2(15, -14), sc + Vector2(0, -26)]), col)
			ci.draw_colored_polygon(PackedVector2Array([sc + Vector2(-14, 2), sc + Vector2(14, 2), sc + Vector2(0, -18)]), col)
			ci.draw_rect(Rect2(sc + Vector2(-2, 4), Vector2(4, 12)), col)
		1:
			ci.draw_circle(sc + Vector2(-7, -6), 8.0, col)
			ci.draw_circle(sc + Vector2(7, -6), 8.0, col)
			ci.draw_colored_polygon(PackedVector2Array([sc + Vector2(-15, -3), sc + Vector2(15, -3), sc + Vector2(0, 16)]), col)
		2:
			ci.draw_colored_polygon(PackedVector2Array([sc + Vector2(0, -18), sc + Vector2(13, 0), sc + Vector2(0, 18), sc + Vector2(-13, 0)]), col)
		3:
			ci.draw_circle(sc + Vector2(0, -9), 7.0, col)
			ci.draw_circle(sc + Vector2(-8, 3), 7.0, col)
			ci.draw_circle(sc + Vector2(8, 3), 7.0, col)
			ci.draw_rect(Rect2(sc + Vector2(-2, 4), Vector2(4, 13)), col)


func _draw_bj(ci: CanvasItem, f: Font) -> void:
	if step == "bet" and ph.is_empty():
		_txt(ci, f, Vector2(240, 330), "Beat the dealer to 21. Blackjack pays x2.5.", 22, Color(0.9, 0.95, 0.9), 800)
		return
	var reveal := step == "dealer" or step == "result"
	_txt(ci, f, Vector2(240, 214), "DEALER" + ("  %d" % hand_value(dh) if reveal else ""), 20, Color(0.9, 0.95, 0.9), 800)
	for i in dh.size():
		_card(ci, f, Vector2(640 - dh.size() * 40 + i * 80, 228), dh[i], i == 1 and not reveal)
	_txt(ci, f, Vector2(240, 368), "YOU  %d" % hand_value(ph), 20, Color(1, 0.9, 0.6), 800)
	for i in ph.size():
		_card(ci, f, Vector2(640 - ph.size() * 40 + i * 80, 382), ph[i], false)
	if step == "bj":
		for i in 2:
			var r := Rect2(470 + i * 190, 500, 160, 44)
			var sel := i == bj_sel
			ci.draw_rect(r, Color(1, 0.85, 0.3, 0.25) if sel else Color(0, 0, 0, 0.3))
			ci.draw_rect(r, Color(1, 0.85, 0.3) if sel else Color(0.4, 0.5, 0.4), false, 3.0 if sel else 1.0)
			_txt(ci, f, Vector2(r.position.x, r.position.y + 31), "HIT" if i == 0 else "STAND", 24, Color.WHITE, r.size.x)


func _draw_roulette(ci: CanvasItem, f: Font) -> void:
	var c := Vector2(640, 340)
	var rr := 120.0
	ci.draw_circle(c, rr + 12.0, Color(0.35, 0.2, 0.08))
	for i in WHEEL.size():
		var a0 := wheel_a + i * TAU / WHEEL.size()
		var a1 := a0 + TAU / WHEEL.size()
		var n: int = WHEEL[i]
		var col := Color(0.1, 0.55, 0.2) if n == 0 else (Color(0.8, 0.08, 0.14) if REDS.has(n) else Color(0.08, 0.08, 0.1))
		ci.draw_colored_polygon(PackedVector2Array([c, c + Vector2.from_angle(a0) * rr, c + Vector2.from_angle(a1) * rr]), col)
	ci.draw_circle(c, rr * 0.55, Color(0.4, 0.25, 0.1))
	ci.draw_circle(c, rr * 0.2, Color(0.85, 0.65, 0.25))
	if step == "spin" or step == "result":
		var idx: int = WHEEL.find(result_n)
		var settle := clampf(1.0 - wheel_v / 9.0, 0.0, 1.0)
		var ball_a := lerpf(-t * 9.0, wheel_a + (idx + 0.5) * TAU / WHEEL.size(), settle)
		ci.draw_circle(c + Vector2.from_angle(ball_a) * rr * lerpf(1.05, 0.85, settle), 6.0, Color.WHITE)
	if step == "pick" or step == "bet":
		var names := ["RED  x2", "BLACK  x2", "GREEN  x36"]
		var cols := [Color(0.8, 0.1, 0.15), Color(0.1, 0.1, 0.12), Color(0.1, 0.55, 0.2)]
		for i in 3:
			var r := Rect2(390 + i * 175, 476, 150, 40)
			var sel := i == pick and step == "pick"
			ci.draw_rect(r, cols[i])
			ci.draw_rect(r, Color(1, 0.85, 0.3) if sel else Color(0.5, 0.5, 0.5), false, 4.0 if sel else 1.0)
			_txt(ci, f, Vector2(r.position.x, r.position.y + 28), names[i], 20, Color.WHITE, r.size.x)
		if step == "pick":
			_txt(ci, f, Vector2(240, 560), "< > pick a color     JUMP spin", 18, Color(0.8, 0.9, 0.8), 800)


# ---------------------------------------------------------------- Lucky's bar

func drink_cost(i: int) -> int:
	return int(DRINKS[i][3]) * price_scale


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
		var r := Rect2(290 + i * 240, 230, 220, 250)
		var sel := i == bar_i
		ci.draw_rect(r, Color(0.2, 0.1, 0.06) if not sel else Color(0.35, 0.2, 0.1))
		ci.draw_rect(r, Color(1, 0.85, 0.3) if sel else Color(0.5, 0.4, 0.3), false, 3.0 if sel else 1.0)
		var c := r.position + Vector2(110, 90)
		var cols := [Color(0.9, 0.2, 0.25), Color(0.3, 0.8, 1), Color(0.5, 1, 0.5)]
		ci.draw_colored_polygon(PackedVector2Array([c + Vector2(-26, -40), c + Vector2(26, -40), c + Vector2(14, 30), c + Vector2(-14, 30)]), Color(0.85, 0.95, 1, 0.35))
		ci.draw_colored_polygon(PackedVector2Array([c + Vector2(-21, -15), c + Vector2(21, -15), c + Vector2(13, 26), c + Vector2(-13, 26)]), cols[i])
		ci.draw_rect(Rect2(c + Vector2(-18, -13), Vector2(36, 3)), Color(1, 1, 1, 0.4))
		_txt(ci, f, Vector2(r.position.x, r.position.y + 170), DRINKS[i][1], 20, Color.WHITE, r.size.x)
		_txt(ci, f, Vector2(r.position.x, r.position.y + 198), DRINKS[i][2], 15, Color(0.85, 0.8, 0.7), r.size.x)
		_txt(ci, f, Vector2(r.position.x, r.position.y + 232), "$%d" % drink_cost(i), 24, Color(1, 0.85, 0.35), r.size.x)
	_txt(ci, f, Vector2(240, 610), "< > choose     JUMP buy     DOWN leave", 18, Color(0.75, 0.85, 0.75), 800)
