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


func setup(floor_num: int, lvl, pl) -> void:
	var n := floor_num / 4
	tier = (n - 1) % 3 + 1
	loop = (n - 1) / 3
	bname = NAMES[tier - 1][0]
	title = NAMES[tier - 1][1]
	if loop > 0:
		title += "  (High Roller x%d)" % (loop + 1)
	max_hp = [24, 32, 44][tier - 1] + loop * 12
	hp = max_hp
	level = lvl
	player = pl
	rig = Rig.new(Rig.boss_style(tier))
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
	hp = maxi(0, hp - dmg)
	flash = 0.12
	iframes = 0.16
	if phase == 1 and hp <= max_hp / 2:
		phase = 2
		speed_mult = 1.3 + loop * 0.1
		phase_changed.emit(2)
	if hp <= 0:
		state = "dead"
		st = 0.0
		collision_layer = 0
		defeated.emit()
	return dmg


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


func _pick_attack() -> String:
	var opts: Array = ["cards", "charge", "slam"]
	if tier >= 2:
		opts.append("balls")
	if tier >= 3 and summoned_phase < phase:
		opts.append("summon")
	opts.erase(last_attack)
	var a: String = opts[randi() % opts.size()]
	last_attack = a
	return a


func _physics_process(delta: float) -> void:
	t += delta
	st += delta
	flash = maxf(0.0, flash - delta)
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
		"cards", "balls":
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
		"summon":
			tp["hand_f"] = sh + Vector2(3, -9)
			tp["head"] = -0.3
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
	rig.draw(self, Transform2D(0.0, Vector2(dir * SCALE, SCALE), 0.0, feet))
	draw_set_transform(Vector2.ZERO)
	if flash > 0.0:
		draw_rect(Rect2(-size * 0.5, size), Color(1, 1, 1, 0.55))
	if state == "stun":
		for i in 4:
			var a := t * 5.0 + i * TAU / 4.0
			draw_circle(Vector2(cos(a) * 10.0, -size.y * 0.5 - 6 + sin(a) * 3.0), 1.8, Color(1, 0.9, 0.3))
	if (state == "charge" and st < 0.6) or (state == "slam" and fired == 0):
		draw_string(ThemeDB.fallback_font, Vector2(-8, -size.y * 0.5 - 8), "!!", HORIZONTAL_ALIGNMENT_CENTER, 16, 14, Color(1, 0.25, 0.2))
