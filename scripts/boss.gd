extends CharacterBody2D
## Boss fights. Tier 1 Big Sal (cards, charge, slam), tier 2 Madame Roulette
## (+ bouncing roulette balls), tier 3 The House (+ summons, faster).
## Charge into a wall = long stun (double damage). Parry the charge to stun
## it instantly. Phase 2 at half health: faster, nastier patterns.

signal fire(kind: String, pos: Vector2, vel: Vector2)
signal summon(pos: Vector2)
signal slammed(pos: Vector2)
signal phase_changed(phase: int)
signal defeated

const Rig := preload("res://scripts/rig.gd")
const Art := preload("res://scripts/art.gd")
const BossDefs := preload("res://scripts/boss_defs.gd")
## Signature attacks, unlocked from phase 2.
const SIGNATURE := {1: "rain", 2: "wheel", 3: "jackpot"}
const NAMES := [["BIG SAL", "The Pit Boss"], ["MADAME ROULETTE", "The Croupier"], ["THE HOUSE", "Owner of The Pit"]]
const SCALE := 1.75

var tier := 1
var loop := 0
var bname := ""
var title := ""
var hp := 24
var max_hp := 24
var level
var player
var state := "intro"
var st := 0.0
var dir := -1
var size := Vector2(20, 36)
var rig
var flash := 0.0
var iframes := 0.0
var phase := 1
var speed_mult := 1.0
var last_attack := ""
var fired := 0
var summoned_phase := 0
var walk_phase := 0.0
var t := 0.0
var dead_t := 0.0
var rain_xs: Array = []
## Boss definition (boss_defs.gd): its game, fixed attack deck per phase, music.
var def: Dictionary = {}
var deck_i := 0
var attack_label := ""
var label_t := 0.0
## Spend chips at the table: the player's Raise multiplies damage for a phase.
var dmg_mult := 1.0
var stagger_t := 0.0


func setup(floor_num: int, lvl, pl, boss_def := {}) -> void:
	var n := floor_num / 5
	def = boss_def if not boss_def.is_empty() else (BossDefs.final_def() if floor_num % 25 == 0 else BossDefs.POOL[(n - 1) % BossDefs.POOL.size()])
	tier = int(def["tier"])
	loop = maxi(0, (floor_num - 1) / 25)
	bname = String(def["name"])
	title = String(def["title"])
	if loop > 0:
		title += "  (High Roller x%d)" % (loop + 1)
	max_hp = int(def["hp"]) + loop * 14
	hp = max_hp
	level = lvl
	player = pl
	var style: Dictionary = Rig.boss_style(tier)
	var ov: Dictionary = Art.boss_style_overrides(tier)
	for k in ov:
		style[k] = ov[k]
	rig = Rig.new(style)
	collision_layer = 4
	collision_mask = 1
	var rs := RectangleShape2D.new()
	rs.size = size
	var cs := CollisionShape2D.new()
	cs.shape = rs
	add_child(cs)
	z_index = 1


func get_rect() -> Rect2:
	return Rect2(global_position - size * 0.5, size)


func alive() -> bool:
	return state != "dead"


func is_stunned() -> bool:
	return state == "stun"


func dangerous() -> bool:
	return state != "dead" and state != "stun" and state != "intro"


func charging() -> bool:
	return state == "charge" and st > 0.6


## Returns damage actually dealt.
func hurt(dmg: int) -> int:
	if iframes > 0.0 or state == "intro" or state == "dead":
		return 0
	if state == "stun":
		dmg *= 2
	dmg = maxi(1, int(round(dmg * dmg_mult)))
	hp = maxi(0, hp - dmg)
	flash = 0.12
	iframes = 0.16
	if phase == 1 and hp <= max_hp / 2:
		phase = 2
		speed_mult = 1.3 + loop * 0.1
		if tier == 1:
			rig.s["arm"] = Color(0.93, 0.92, 0.88)
		phase_changed.emit(2)
		_stagger()
	elif phase == 2 and hp <= max_hp / 4 and hp > 0:
		phase = 3
		speed_mult = 1.5 + loop * 0.1
		phase_changed.emit(3)
		_stagger()
	if hp <= 0:
		state = "dead"
		st = 0.0
		collision_layer = 0
		defeated.emit()
	return dmg


## Phase change: the boss reels for a beat (a free window, and the Raise prompt).
func _stagger() -> void:
	state = "stun"
	st = 0.0
	_stun_time = 1.4
	deck_i = 0


func stun(time: float) -> void:
	if state == "dead":
		return
	state = "stun"
	st = 0.0
	_stun_time = time


var _stun_time := 1.6


func _face_player() -> void:
	var dx: float = player.global_position.x - global_position.x
	if absf(dx) > 4.0:
		dir = int(signf(dx))


## Fixed, learnable pattern: the deck for the current phase plays in order and loops.
func _pick_attack() -> String:
	var decks: Array = def["deck"]
	var d: Array = decks[clampi(phase - 1, 0, decks.size() - 1)]
	var a: String = d[deck_i % d.size()]
	deck_i += 1
	last_attack = a
	if a == "deal":
		attack_label = String(def["deal"]["label"])
	else:
		attack_label = {"charge": "ALL IN!", "slam": "RAISE!", "balls": "SPIN!", "wheel": "WHEEL OF FATE!", "rain": "CASH OUT!", "jackpot": "JACKPOT!", "summon": "SECURITY!"}.get(a, "")
	label_t = 1.1
	return a


func _physics_process(delta: float) -> void:
	t += delta
	st += delta
	flash = maxf(0.0, flash - delta)
	label_t = maxf(0.0, label_t - delta)
	iframes = maxf(0.0, iframes - delta)
	velocity.y = minf(velocity.y + 1100.0 * delta, 600.0)
	var sm := speed_mult
	match state:
		"intro":
			velocity.x = 0.0
			_face_player()
			if st > 1.6:
				_go("idle")
		"idle":
			_face_player()
			velocity.x = dir * 38.0 * sm
			if st > 0.9 / sm:
				_go(_pick_attack())
		"cards":
			velocity.x = 0.0
			var volleys := 2 if phase == 2 else 1
			if fired < volleys and st > 0.45 / sm + fired * 0.45:
				_throw_cards()
				fired += 1
			if st > 0.5 / sm + volleys * 0.45:
				_go("idle")
		"deal":
			velocity.x = 0.0
			_face_player()
			var dp: Dictionary = def["deal"]
			var vol := int(dp.get("volleys", 1)) + (1 if phase >= 3 else 0)
			if fired < vol and st > 0.55 / sm + fired * 0.5:
				_deal_volley(dp)
				fired += 1
			if st > 0.6 / sm + vol * 0.5:
				_go("idle")
		"balls":
			velocity.x = 0.0
			if fired == 0 and st > 0.4 / sm:
				fired = 1
				var n := 2 + phase
				for i in n:
					fire.emit("ball", global_position + Vector2(dir * 10, -14), Vector2(dir * randf_range(70, 190), -randf_range(220, 340)))
				Sfx.play("swing", 0.7)
			if st > 1.0:
				_go("idle")
		"charge":
			if st < 0.6:
				velocity.x = 0.0
				_face_player()
			else:
				velocity.x = dir * 260.0 * sm
				if is_on_wall():
					slammed.emit(global_position + Vector2(dir * 12, 0))
					stun(1.7)
				elif st > 3.0:
					_go("idle")
		"slam":
			if fired == 0:
				velocity.x = 0.0
				if st > 0.35 / sm:
					fired = 1
					var dx: float = player.global_position.x - global_position.x
					velocity = Vector2(clampf(dx * 1.4, -260.0, 260.0), -560.0)
			elif st > 0.5 and is_on_floor():
				slammed.emit(global_position + Vector2(0, size.y * 0.5))
				var spd := 170.0 * sm
				fire.emit("wave", global_position + Vector2(-12, size.y * 0.5), Vector2(-spd, 0))
				fire.emit("wave", global_position + Vector2(12, size.y * 0.5), Vector2(spd, 0))
				_go("recover")
		"rain", "jackpot":
			# Telegraphed rain of cash / jackpot coins from the ceiling.
			velocity.x = 0.0
			if fired == 0 and st > 0.25:
				fired = 1
				rain_xs.clear()
				var n := 5 + phase * 2
				var w: float = level.w * 16
				for i in n:
					rain_xs.append(randf_range(40.0, w - 40.0))
				rain_xs.append(player.global_position.x)
				Sfx.play("windup", 0.8)
			elif fired == 1 and st > 1.0:
				fired = 2
				for x in rain_xs:
					fire.emit("card", Vector2(x, 26.0), Vector2(randf_range(-10, 10), 210.0 + 20.0 * phase))
				if state == "jackpot":
					var spd := 170.0 * sm
					fire.emit("wave", global_position + Vector2(-12, size.y * 0.5), Vector2(-spd, 0))
					fire.emit("wave", global_position + Vector2(12, size.y * 0.5), Vector2(spd, 0))
				Sfx.play("coins", 0.7)
				rain_xs.clear()
			if st > 1.7:
				_go("idle")
		"wheel":
			# Madame Roulette spins and fans roulette balls across the arena.
			velocity.x = 0.0
			if fired == 0 and st > 0.5:
				fired = 1
				var n := 5 + phase * 2
				for i in n:
					var a := lerpf(-PI + 0.25, -0.25, float(i) / float(n - 1))
					fire.emit("ball", global_position + Vector2(0, -14), Vector2.from_angle(a) * (230.0 + 20.0 * phase))
				Sfx.play("swing", 0.6)
			if st > 1.4:
				_go("idle")
		"summon":
			velocity.x = 0.0
			if fired == 0 and st > 0.5:
				fired = 1
				summoned_phase = phase
				summon.emit(Vector2(level.w * 16 * 0.25, (level.h - 2) * 16 - 2))
				summon.emit(Vector2(level.w * 16 * 0.75, (level.h - 2) * 16 - 2))
			if st > 1.0:
				_go("idle")
		"recover":
			velocity.x = 0.0
			if st > 0.6 / sm:
				_go("idle")
		"stun":
			velocity.x = 0.0
			if st > _stun_time:
				_go("idle")
		"dead":
			velocity.x = 0.0
			dead_t += delta
			modulate.a = clampf(2.2 - dead_t, 0.0, 1.0)
			if dead_t > 2.3:
				queue_free()
	move_and_slide()
	queue_redraw()


func _go(s: String) -> void:
	state = s
	st = 0.0
	fired = 0


## The game's signature volley (see boss_defs deal params).
func _deal_volley(dp: Dictionary) -> void:
	var n := int(dp["n"]) + (1 if phase >= 2 and int(dp["n"]) < 8 else 0)
	var spd: float = float(dp["speed"]) * (1.0 + 0.06 * (phase - 1)) + loop * 10.0
	var origin: Vector2 = global_position + Vector2(dir * 12, -12)
	var base: float = ((player.global_position as Vector2) - origin).angle() if dp.get("aim", false) else (-0.5 * PI + dir * 0.9)
	for i in n:
		var frac: float = float(i) / maxf(1.0, n - 1.0)
		if dp.get("floor", false):
			# Razz: low cards skid along the floor from both sides at staggered speeds.
			var side := -1.0 if i % 2 == 0 else 1.0
			fire.emit("wave", global_position + Vector2(side * 14, size.y * 0.5), Vector2(side * spd * (0.7 + 0.12 * i), 0))
			continue
		var a: float = base + (frac - 0.5) * float(dp["spread"]) * (n - 1) if dp.get("aim", false) else (-PI + 0.3 + frac * (PI - 0.6) if dp.get("arc", false) else base + (frac - 0.5) * float(dp["spread"]) * 2.0)
		fire.emit("card", origin, Vector2.from_angle(a) * spd)
	Sfx.play("swing", 1.3)


func _throw_cards() -> void:
	var n := 2 + tier + (1 if phase == 2 else 0)
	var to: Vector2 = (player.global_position as Vector2) - (global_position + Vector2(0, -12))
	var base := to.angle()
	var spread := 0.22
	for i in n:
		var a := base + (i - (n - 1) * 0.5) * spread
		fire.emit("card", global_position + Vector2(dir * 12, -12), Vector2.from_angle(a) * (190.0 + 20.0 * tier))
	Sfx.play("swing", 1.3)


func _process(delta: float) -> void:
	if rig == null:
		return
	walk_phase += delta * absf(velocity.x) * 0.22
	var ph := walk_phase
	var cf := cos(ph)
	var sf := sin(ph)
	var hip := Vector2(0.3, -7.5 - absf(cf) * 0.6)
	var sh: Vector2 = rig.shoulder_of(hip, 0.08)
	var tp: Dictionary = Rig.make(hip, 0.08, 0.0,
		Vector2(cf * 3.2 + 0.3, -maxf(0.0, -sf) * 2.2), Vector2(-cf * 3.2 + 0.3, -maxf(0.0, sf) * 2.2),
		sh + Vector2(-cf * 2.2 + 0.8, 6.4), sh + Vector2(cf * 2.2 + 0.2, 6.4))
	match state:
		"intro":
			tp["hand_f"] = sh + Vector2(6, -4)
			tp["hand_b"] = sh + Vector2(-6, -4)
			tp["head"] = -0.15
		"cards", "balls", "deal":
			var k := clampf(st / 0.45, 0.0, 1.0)
			tp["hand_f"] = sh + Vector2(lerpf(-6.0, 8.0, k * k), lerpf(-5.0, 0.0, k))
			tp["torso"] = lerpf(-0.25, 0.3, k * k)
		"charge":
			if st < 0.6:
				tp["torso"] = -0.2 + sin(t * 40.0) * 0.05
				tp["hip"] = hip + Vector2(0, 1.5)
			else:
				tp["torso"] = 0.6
				tp["head"] = -0.4
				tp["hand_f"] = sh + Vector2(7, 2)
				tp["hand_b"] = sh + Vector2(6, 3)
		"slam":
			if is_on_floor():
				tp["hip"] = hip + Vector2(0, 2.5)
				tp["hand_f"] = sh + Vector2(3, 6)
			else:
				tp["hand_f"] = sh + Vector2(2, -8)
				tp["hand_b"] = sh + Vector2(-2, -8)
				tp["foot_f"] = Vector2(3, -4)
				tp["foot_b"] = Vector2(-3, -3)
		"summon", "rain", "jackpot":
			tp["hand_f"] = sh + Vector2(3, -9)
			tp["hand_b"] = sh + Vector2(-2, -9)
			tp["head"] = -0.3
		"wheel":
			var a := st * 14.0
			tp["hand_f"] = sh + Vector2(cos(a) * 7.0, sin(a) * 3.0 - 3.0)
			tp["hand_b"] = sh + Vector2(-cos(a) * 7.0, -sin(a) * 3.0 - 3.0)
			tp["torso"] = sin(a) * 0.2
		"stun":
			tp["torso"] = -0.3 + sin(t * 7.0) * 0.12
			tp["head"] = 0.45
			tp["hand_f"] = sh + Vector2(1, 7)
			tp["hand_b"] = sh + Vector2(-1, 7)
			tp["hip"] = hip + Vector2(0, 1.5)
		"dead":
			tp["torso"] = -1.2
			tp["hip"] = Vector2(-2, -3)
			tp["head"] = 0.6
			tp["foot_f"] = Vector2(6, 0)
			tp["foot_b"] = Vector2(4, 0)
			tp["hand_f"] = Vector2(-6, 0)
			tp["hand_b"] = Vector2(-9, 0)
	rig.blend(tp, 30.0, delta)


func _draw() -> void:
	var feet := Vector2(0, size.y * 0.5)
	draw_set_transform(feet, 0.0, Vector2(1.0, 0.28))
	draw_circle(Vector2.ZERO, 14.0, Color(0, 0, 0, 0.45))
	draw_set_transform(Vector2.ZERO)
	if state == "charge" and st < 0.6 and int(t * 20.0) % 2 == 0:
		draw_circle(Vector2(0, -2), 26.0, Color(1, 0.2, 0.2, 0.18))
	if state == "stun":
		draw_circle(Vector2(0, -2), 24.0, Color(1, 0.9, 0.3, 0.1 + 0.08 * sin(t * 10.0)))
	if phase >= 3 and state != "dead":
		var auras := [Color(1, 0.3, 0.15), Color(1, 0.6, 0.2), Color(1, 0.85, 0.35)]
		var ac: Color = auras[tier - 1]
		for i in 3:
			draw_circle(Vector2(0, -4), 22.0 + i * 5.0 + sin(t * 6.0 + i) * 2.0, Color(ac, 0.06))
	var xf := Transform2D(0.0, Vector2(dir * SCALE, SCALE), 0.0, feet)
	Art.boss_back(self, xf, rig, tier, phase, t)
	rig.draw(self, xf, 1.0, func(ci, x2, r, _a): Art.boss_body(ci, x2, r, tier, phase, t, 1.0), tier == 2)
	Art.boss_front(self, xf, rig, tier, phase, t)
	draw_set_transform(Vector2.ZERO)
	# Warning markers where cash/coins are about to fall.
	if rain_xs.size() > 0:
		var top: float = 24.0 - global_position.y
		var bottom: float = level.h * 16 - 16.0 - global_position.y
		var a := 0.35 + 0.35 * sin(t * 30.0)
		for x in rain_xs:
			var lx: float = (x - global_position.x)
			draw_line(Vector2(lx, top), Vector2(lx, bottom), Color(1, 0.3, 0.2, a * 0.5), 2.0)
			draw_string(ThemeDB.fallback_font, Vector2(lx - 10, top + 14), "!", HORIZONTAL_ALIGNMENT_CENTER, 20, 14, Color(1, 0.4, 0.3, a + 0.3))
	if flash > 0.0:
		draw_rect(Rect2(-size * 0.5, size), Color(1, 1, 1, 0.55))
	if state == "stun":
		for i in 4:
			var a := t * 5.0 + i * TAU / 4.0
			draw_circle(Vector2(cos(a) * 10.0, -size.y * 0.5 - 6 + sin(a) * 3.0), 1.8, Color(1, 0.9, 0.3))
	if label_t > 0.0 and attack_label != "" and state != "dead":
		var fa := clampf(label_t / 0.4, 0.0, 1.0)
		draw_string_outline(ThemeDB.fallback_font, Vector2(-60, -size.y * 0.5 - 22), attack_label, HORIZONTAL_ALIGNMENT_CENTER, 120, 10, 3, Color(0, 0, 0, fa))
		draw_string(ThemeDB.fallback_font, Vector2(-60, -size.y * 0.5 - 22), attack_label, HORIZONTAL_ALIGNMENT_CENTER, 120, 10, Color(def.get("col", Color.WHITE), fa))
	if state == "deal" and fired == 0:
		var nn := int(def["deal"]["n"])
		for i in nn:
			var px := (i - (nn - 1) * 0.5) * 6.0
			draw_rect(Rect2(px - 2, -size.y * 0.5 - 12 - sin(t * 20.0 + i) , 4, 6), Color(1, 1, 1, 0.9))
	if (state == "charge" and st < 0.6) or (state == "slam" and fired == 0) or (state == "wheel" and fired == 0) or (state == "deal" and fired == 0):
		draw_string(ThemeDB.fallback_font, Vector2(-8, -size.y * 0.5 - 8), "!!", HORIZONTAL_ALIGNMENT_CENTER, 16, 14, Color(1, 0.25, 0.2))
