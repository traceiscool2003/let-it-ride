extends SceneTree
## Casino, odds and progression checks:
##   godot --headless --path . --script res://tests/casino_test.gd
## Hand evaluators, baccarat third-card rules, slot RTP bands, Hi-Lo math,
## roulette bets, every game played start to finish, Double or Nothing,
## XP / skill points and side-bet payouts.

var C

var fails := 0
var main
var frame := 0


func check(ok: bool, what: String) -> void:
	if not ok:
		fails += 1
		print("FAIL  ", what)
	else:
		print("ok    ", what)


## Card helper: rank "A","2".."10","J","Q","K", suit 0..3.
func cd(rank: String, suit: int) -> int:
	return suit * 13 + (C.RANKS as Array).find(rank)


func _initialize() -> void:
	C = load("res://scripts/casino.gd")
	# --- Poker hand ranking.
	var royal := [cd("A", 0), cd("K", 0), cd("Q", 0), cd("J", 0), cd("10", 0)]
	var sf := [cd("9", 1), cd("8", 1), cd("7", 1), cd("6", 1), cd("5", 1)]
	var quads := [cd("7", 0), cd("7", 1), cd("7", 2), cd("7", 3), cd("2", 0)]
	var boat := [cd("K", 0), cd("K", 1), cd("K", 2), cd("4", 3), cd("4", 0)]
	var flush := [cd("2", 2), cd("9", 2), cd("J", 2), cd("4", 2), cd("6", 2)]
	var straight := [cd("9", 0), cd("8", 1), cd("7", 2), cd("6", 3), cd("5", 0)]
	var wheel := [cd("A", 0), cd("2", 1), cd("3", 2), cd("4", 3), cd("5", 0)]
	var trips := [cd("Q", 0), cd("Q", 1), cd("Q", 2), cd("4", 3), cd("9", 0)]
	var twop := [cd("Q", 0), cd("Q", 1), cd("4", 2), cd("4", 3), cd("9", 0)]
	var jacks := [cd("J", 0), cd("J", 1), cd("4", 2), cd("8", 3), cd("9", 0)]
	var low_pair := [cd("5", 0), cd("5", 1), cd("K", 2), cd("8", 3), cd("9", 0)]
	var high := [cd("A", 0), cd("3", 1), cd("K", 2), cd("8", 3), cd("9", 0)]
	check(C.hand_name(C.score5(royal)) == "ROYAL FLUSH", "royal flush")
	check(C.hand_name(C.score5(sf)) == "STRAIGHT FLUSH", "straight flush")
	check(C.hand_name(C.score5(quads)) == "FOUR OF A KIND", "four of a kind")
	check(C.hand_name(C.score5(boat)) == "FULL HOUSE", "full house")
	check(C.hand_name(C.score5(flush)) == "FLUSH", "flush")
	check(C.hand_name(C.score5(straight)) == "STRAIGHT", "straight")
	check(C.hand_name(C.score5(wheel)) == "STRAIGHT", "wheel A-2-3-4-5 is a straight")
	check(C.score5(wheel) < C.score5(straight), "wheel ranks below a 9-high straight")
	check(C.hand_name(C.score5(trips)) == "THREE OF A KIND", "three of a kind")
	check(C.hand_name(C.score5(twop)) == "TWO PAIR", "two pair")
	check(C.hand_name(C.score5(high)) == "HIGH CARD", "high card")
	var order := [royal, sf, quads, boat, flush, straight, trips, twop, jacks, high]
	var sorted_ok := true
	for i in order.size() - 1:
		if C.score5(order[i]) <= C.score5(order[i + 1]):
			sorted_ok = false
	check(sorted_ok, "hand categories rank in the right order")
	check(C.score5([cd("A", 0), cd("A", 1), cd("2", 2), cd("3", 3), cd("4", 0)]) > C.score5([cd("K", 0), cd("K", 1), cd("Q", 2), cd("J", 3), cd("9", 0)]), "pair of aces beats pair of kings")
	check(C._vp_name(jacks) == "JACKS OR BETTER", "video poker: jacks pay")
	check(C._vp_name(low_pair) == "", "video poker: low pair doesn't pay")
	check(C._vp_name(royal) == "ROYAL FLUSH", "video poker: royal")
	var seven := [cd("A", 3), cd("K", 3), cd("2", 1), cd("Q", 3), cd("J", 3), cd("10", 3), cd("5", 0)]
	check(C.hand_name(C.best_of(seven)) == "ROYAL FLUSH", "best of 7 finds the royal")
	# --- Baccarat third-card rules.
	# Natural 8 for the player: nobody draws.
	var r1: Array = C.bac_play([cd("8", 0), cd("2", 1), cd("K", 0), cd("3", 1), cd("4", 0), cd("4", 1)])
	check((r1[0] as Array).size() == 2 and (r1[1] as Array).size() == 2, "baccarat natural: no third cards")
	# Player 5 draws; banker 3 stands only when the player's third card is an 8.
	var r2: Array = C.bac_play([cd("2", 0), cd("A", 1), cd("3", 0), cd("2", 1), cd("8", 0), cd("4", 1)])
	check((r2[0] as Array).size() == 3 and (r2[1] as Array).size() == 2, "baccarat: banker 3 stands on player's 8")
	var r3: Array = C.bac_play([cd("2", 0), cd("A", 1), cd("3", 0), cd("2", 1), cd("7", 0), cd("4", 1)])
	check((r3[1] as Array).size() == 3, "baccarat: banker 3 draws on player's 7")
	# Player stands on 7; banker draws on 5 or less.
	var r4: Array = C.bac_play([cd("3", 0), cd("2", 1), cd("4", 0), cd("3", 1), cd("9", 0), cd("4", 1)])
	check((r4[0] as Array).size() == 2 and (r4[1] as Array).size() == 3, "baccarat: player stands on 7, banker draws on 5")
	check(C.bac_total([cd("K", 0), cd("9", 1)]) == 9 and C.bac_total([cd("7", 0), cd("8", 1)]) == 5, "baccarat totals")
	# --- Blackjack values.
	check(C.hand_value([cd("A", 0), cd("K", 1)]) == 21, "A+K = 21")
	check(C.hand_value([cd("A", 0), cd("A", 1), cd("9", 2)]) == 21, "A+A+9 = 21")
	check(C.hand_value([cd("K", 0), cd("Q", 1), cd("5", 2)]) == 25, "bust counts over 21")
	# --- Roulette bets.
	check(C.rbet_wins("red", 1, 0) and not C.rbet_wins("red", 2, 0), "red / black")
	check(not C.rbet_wins("even", 0, 0) and not C.rbet_wins("odd", 0, 0), "zero loses odd and even")
	check(C.rbet_wins("d2", 13, 0) and C.rbet_wins("d3", 36, 0) and not C.rbet_wins("d1", 13, 0), "dozens")
	check(C.rbet_wins("num", 17, 17) and not C.rbet_wins("num", 18, 17), "single number")
	# --- Hi-Lo multipliers: 96% of fair odds.
	check(absf(C.hl_mult(7, true) - 0.97 * 13.0 / 6.0) < 0.001, "hi-lo x from a 7")
	check(C.hl_mult(13, true) == 0.0 and C.hl_mult(1, false) == 0.0, "can't go higher than K or lower than A")
	# --- Slot machines: random, hidden, but always inside the payback band.
	var lo := 9.0
	var hi := 0.0
	var vols := {}
	var themes := {}
	for i in 300:
		var m: Dictionary = C.new_machine()
		var r: float = C.line_rtp(m["w"], m["pays"])[0]
		lo = minf(lo, r)
		hi = maxf(hi, r)
		vols[m["vol"]] = true
		themes[m["theme"]] = true
	check(lo >= 0.81 and hi <= 1.05, "300 machines: payback between %.3f and %.3f" % [lo, hi])
	check(vols.size() >= 2 and themes.size() >= 4, "machines vary in volatility (%d) and theme (%d)" % [vols.size(), themes.size()])
	var m1: Dictionary = C.new_machine()
	var m2: Dictionary = C.new_machine()
	check(m1["pays"]["SEVEN"] != m2["pays"]["SEVEN"], "two machines never share a paytable")
	# Monte Carlo a machine with the heat frozen: realized payback near the math.
	var g = C.new()
	g.machine = C.new_machine()
	var target: float = C.line_rtp(g.machine["w"], g.machine["pays"])[0]
	var paid := 0
	var spins := 20000
	for i in spins:
		g.machine["heat"] = 0.0
		g.bet = 100
		g._roll_grid()
		var pays: Dictionary = g.machine["pays"]
		for li in C.LINES.size():
			var rows: Array = C.LINES[li]
			var lv: Array = C.line_value([g.grid[0][rows[0]], g.grid[1][rows[1]], g.grid[2][rows[2]]], pays)
			paid += int(round(100.0 / 5.0 * float(lv[0])))
	var real := float(paid) / float(spins * 100)
	check(absf(real - target) < 0.12, "simulated payback %.3f vs math %.3f" % [real, target])
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_casino.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_casino.cfg"))
	root.add_child(main)


func _play(game: String, pot: int, presses: Array, ticks := 80) -> int:
	var c = main.casino
	if game == "slots":
		c.machine = C.new_machine()
	c.open(game, 0, 6)
	c.bet_i = 0
	c.pick = 0
	var p := pot
	for a in presses:
		p += c.press(a, p)
		for i in ticks:
			p += c.update(0.05) + c.take_pending()
	return p


func _process(_delta: float) -> bool:
	frame += 1
	if frame == 5:
		var c = main.casino
		# Every game, start to finish, with the Pot staying sane.
		for game in ["slots", "blackjack", "roulette", "poker", "holdem", "baccarat", "hilo"]:
			var ok := true
			for rnd in 25:
				var presses: Array = ["confirm"]
				match game:
					"blackjack": presses = ["confirm", ["right", "confirm"][rnd % 2], "confirm"]
					"roulette": presses = ["confirm", "right", "right", "confirm"]
					"poker": presses = ["confirm", "left", "confirm", "right", "confirm"]
					"holdem": presses = ["confirm", "confirm"]
					"baccarat": presses = ["confirm", "right", "confirm"]
					"hilo": presses = ["confirm", "confirm", "confirm", "right", "right", "confirm"]
				var after := _play(game, 1000, presses)
				if after < 0 or after > 1000 + 5 * 250 * 10:
					ok = false
				if c.step != "result" and c.step != "bet" and c.step != "hl" and c.step != "bj":
					ok = false
			check(ok, "%s plays start to finish (last: %s)" % [game, c.msg])
		# Roulette single number.
		c.open("roulette", 0, 1)
		c.bet_i = 0
		var p := 100
		p += c.press("confirm", p)
		c.pick = C.RBETS.size() - 1
		c.press("confirm", p)
		check(c.step == "num", "number bet opens the number picker")
		c.press("right", p)
		c.press("confirm", p)
		for i in 100:
			p += c.update(0.05)
		check(c.step == "result" and (p == 95 or p == 95 + 5 * 36), "number bet resolves to x36 or nothing")
		# Blackjack double down takes a second stake.
		c.open("blackjack", 0, 1)
		c.bet_i = 1
		p = 500
		p += c.press("confirm", p)
		if c.step == "bj" and c.ph.size() == 2:
			c.sel = 2
			var before := p
			p += c.press("confirm", p)
			check(c.doubled and before - p == 25 and c.bet == 50, "double down doubles the stake")
		# Double or nothing.
		c.open("hilo", 0, 1)
		c.step = "result"
		c.win = 100
		c.gambles = 0
		p = 1000
		p += c.press("up", p)
		check(c.step == "gamble" and p == 900, "double or nothing takes the win back off the table")
		c.press("confirm", p)
		for i in 30:
			p += c.update(0.05)
		check(c.step == "result" and (p == 900 or p == 1100), "double or nothing pays x2 or nothing")
		# Hold'em needs 3x the ante.
		c.open("holdem", 0, 1)
		c.bet_i = 2
		var d: int = c.press("confirm", 200)
		check(d == 0 and c.step == "bet", "hold'em refuses an ante you can't call")
		# --- XP, levels and skill points.
		main.xp = 0
		main.level_num = 1
		main.skill_points = 0
		main._gain_xp(100)
		check(main.level_num == 2 and main.skill_points == 1, "100 XP = level 2 and a skill point")
		main._gain_xp(main.xp_need(2) + main.xp_need(3) + main.xp_need(4))
		check(main.level_num == 5 and main.skill_points == 5, "level 5 pays two points (total 5)")
		check(main.SKILLS.size() == 20, "20 skills in 5 branches")
		var ids := {}
		for sk in main.SKILLS:
			ids[sk["id"]] = true
		check(ids.size() == 20, "skill ids are unique")
		# Spend points.
		main.perks = {}
		main.state = "skills"
		main.skill_sel = 0
		main.skill_points = 1
		Input.action_press("jump")
		main._skills_tick()
		Input.action_release("jump")
		check(main.has_skill("skin1") and main.skill_points == 0, "learning a skill spends its points")
		var price: int = main.sp_price()
		main.wallet = price
		Input.action_press("attack")
		main._skills_tick()
		Input.action_release("attack")
		check(main.skill_points == 1 and main.wallet == 0 and main.sp_price() > price, "The Fence sells points, price climbs")
		# Threat: gentle first floor, tougher with level and skills.
		main.runs = 1
		main.floor_num = 1
		main.is_daily = false
		main.in_hub = false
		check(main.threat() < 0.7, "first floor ever is gentle")
		main.runs = 5
		var t1: float = main.threat()
		main.level_num = 15
		check(main.threat() > t1, "difficulty rises with level")
		# Side bets: deeper and bigger pays more.
		main.floor_num = 1
		var a: float = main._bet_pay(2.0, 0)
		var b: float = main._bet_pay(2.0, 2)
		main.floor_num = 9
		check(b > a and main._bet_pay(2.0, 0) > a, "side bets pay more all-in and deeper down")
		print("%d checks failed" % fails)
		quit()
	return false
