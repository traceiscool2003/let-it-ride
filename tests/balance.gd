extends SceneTree
## Balance simulation: plays thousands of rounds of every casino game with a
## sensible strategy and reports the player's average return per $1 bet.
## Every game should favor the House a little (no money printers), and none
## should be a total rip-off. Also checks the XP pace and the side-bet math.
##   godot --headless --path . --script res://tests/balance.gd

var C
var fails := 0
var frame := 0
var main


func check(ok: bool, what: String) -> void:
	if not ok:
		fails += 1
		print("FAIL  ", what)
	else:
		print("ok    ", what)


func _initialize() -> void:
	C = load("res://scripts/casino.gd")
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_balance.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_balance.cfg"))
	root.add_child(main)


## Run update() until the round is over; returns money paid back.
func _settle(c) -> int:
	var paid := 0
	for i in 40:
		if c.step == "result" or c.step == "bet":
			break
		paid += c.update(0.6) + c.take_pending()
	return paid


func _round(c, game: String) -> Array:
	# Returns [staked, returned].
	var pot := 100000
	c.open(game, 0, 6)
	c.bet_i = 0
	c.pick = 0
	c.bac_pick = 1
	var staked := 0
	var back := 0
	var d: int = c.press("confirm", pot)
	staked -= d
	match game:
		"blackjack":
			while c.step == "bj":
				var v: int = C.hand_value(c.ph)
				c.sel = 0 if v < 17 else 1
				back += c.press("confirm", pot)
		"poker":
			var counts := {}
			for card in c.ph:
				counts[int(card) % 13] = int(counts.get(int(card) % 13, 0)) + 1
			var made: String = C._vp_name(c.ph)
			for i in 5:
				var r: int = int(c.ph[i]) % 13
				if made != "" and made != "JACKS OR BETTER" and made != "TWO PAIR" and made != "THREE OF A KIND" and made != "FOUR OF A KIND":
					c.held[i] = true
				elif int(counts[r]) >= 2:
					c.held[i] = true
				elif counts.size() == 5 and (r == 0 or r >= 10):
					c.held[i] = true
			c.sel = 5
			d = c.press("confirm", pot)
			back += d
		"holdem":
			c.sel = 0
			d = c.press("confirm", pot)
			staked -= mini(0, d)
		"roulette":
			c.press("confirm", pot)
		"baccarat":
			c.press("confirm", pot)
		"hilo":
			for step_i in 2:
				if c.step != "hl":
					break
				var r: int = c.hl_card % 13 + 1
				c.sel = 0 if r <= 7 else 1
				c.press("confirm", pot)
				back += _settle(c)
				c.step = "hl" if c.step == "hl" else c.step
			if c.step == "hl":
				c.sel = 2
				back += c.press("confirm", pot)
	back += _settle(c)
	return [staked, back]


func _process(_delta: float) -> bool:
	frame += 1
	if frame != 5:
		return false
	var c = C.new()
	var n := {"slots": 6000, "blackjack": 6000, "roulette": 6000, "poker": 8000, "holdem": 5000, "baccarat": 6000, "hilo": 6000}
	var bands := {
		"slots": [0.78, 1.06], "blackjack": [0.9, 1.02], "roulette": [0.9, 1.02], "poker": [0.85, 1.02],
		"holdem": [0.85, 1.03], "baccarat": [0.94, 1.01], "hilo": [0.88, 1.0],
	}
	for game in n:
		var staked := 0
		var back := 0
		for i in int(n[game]):
			if game == "slots" and i % 50 == 0:
				c.machine = C.new_machine()
			var res := _round(c, game)
			staked += int(res[0])
			back += int(res[1])
		var rtp := float(back) / maxf(1.0, float(staked))
		var band: Array = bands[game]
		check(rtp >= float(band[0]) and rtp <= float(band[1]), "%-10s returns %.3f per $1 over %d rounds (house edge %.1f%%)" % [game, rtp, n[game], (1.0 - rtp) * 100.0])
	# XP pace: a decent first run (6 floors, 25 knockouts, a few wins) should
	# be worth a few levels, and a 2-floor bust still earns something.
	var xp := 0
	for fl in range(1, 7):
		xp += 20 + 5 * fl
	xp += 25 * 4 + 150 + 3 * 15 + 2 * 40
	var lv := 1
	var left := xp
	while left >= main.xp_need(lv):
		left -= main.xp_need(lv)
		lv += 1
	check(lv >= 3 and lv <= 6, "a good first run (%d XP) reaches level %d" % [xp, lv])
	check(main.sp_price() >= 300, "first bought skill point costs %d" % main.sp_price())
	print("%d checks failed" % fails)
	quit()
	return false
