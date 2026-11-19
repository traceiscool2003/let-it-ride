extends CharacterBody2D
## Pit security. kind 0 = Guard (patrols, telegraphs a punch you can parry),
## kind 1 = Bat (hangs, then swoops), kind 2 = Dealer (throws cards from range),
## kind 3 = Heavy (riot shield blocks frontal strikes; flank, stomp or parry).

signal fire(kind: String, pos: Vector2, vel: Vector2)

const Sprites := preload("res://scripts/sprites.gd")
const Rig := preload("res://scripts/rig.gd")
const ET := preload("res://scripts/enemy_types.gd")

var rig
var walk_phase := 0.0
var kind := 0
var level
var player
var alive := true
var dir := 1
var speed := 40.0
var size := Vector2(12, 14)
var awake := false
var t := 0.0
var dead_t := 0.0
var spin := 0.0
var hp := 1
var max_hp := 1
var ai := "walk"     # walk / windup / punch / recover / stun
var ai_t := 0.0
var punch_cd := 0.0
var flash := 0.0
var knock := 0.0
## Per-instance moveset variation (rolled in setup): speed, burst size, aim lead, cooldown.
var T := {}
var beh := ""
var v_speed := 1.0
var v_shots := 0
var v_lead := 0.0
var v_cd := 1.0
var shot_cd := 1.5
var ground_y := 0.0


## Elite security: gold trim, double health, a bit faster, pays double.
var elite := false


func setup(k: int, lvl, pl, floor_num: int, threat := 1.0, elite_ := false) -> void:
	kind = k
	level = lvl
	player = pl
	collision_layer = 4
	collision_mask = 1
	T = ET.info(kind)
	beh = String(T.get("beh", ""))
	if kind == 13:
		kind = 1
		T = {}
	v_speed = randf_range(0.85, 1.2)
	v_lead = randf_range(0.0, 1.0)
	v_cd = randf_range(0.8, 1.25)
	if beh != "":
		size = T.get("size", Vector2(12, 21))
		speed = float(T["speed"]) * v_speed + floor_num * 0.6
		hp = int(T["hp"]) + floor_num / 10
		v_shots = int(T.get("shots", 1)) + (1 if randf() < 0.3 and beh == "burst" else 0)
		if beh != "rat":
			rig = Rig.new(Rig.enemy_style(kind))
		if bool(T.get("air", false)):
			size = Vector2(12, 10)
		shot_cd = randf_range(0.8, 2.0)
	elif kind == 1:
		size = Vector2(10, 8)
		speed = 68.0 + floor_num * 4.0
		hp = 1
	else:
		speed = 36.0 + floor_num * 4.0
		size = Vector2(12, 21)
		rig = Rig.new(Rig.guard_style() if kind == 0 else Rig.enemy_style(kind))
		if kind == 3:
			size = Vector2(16, 27)
			speed *= 0.6
		elif kind == 2:
			speed *= 0.8
		hp = (5 if kind == 3 else 2) + floor_num / 4
	# Difficulty: tougher and quicker as your level and skills grow.
	hp = maxi(1, int(round(hp * (0.8 + 0.2 * threat))))
	speed *= 0.9 + 0.1 * threat
	elite = elite_ and kind != 1
	if elite:
		hp *= 2
		speed *= 1.15
	max_hp = hp
	dir = 1 if randf() < 0.5 else -1
	t = randf() * 10.0
	punch_cd = randf_range(0.5, 1.5)
	var rs := RectangleShape2D.new()
	rs.size = size
	var cs := CollisionShape2D.new()
	cs.shape = rs
	add_child(cs)


func get_rect() -> Rect2:
	return Rect2(global_position - size * 0.5, size)


func punch_rect() -> Rect2:
	if (kind != 0 and kind != 3) or ai != "punch" or not alive:
		return Rect2()
	if kind == 3:
		return Rect2(global_position.x + (2.0 if dir > 0 else -28.0), global_position.y - 12.0, 26.0, 20.0)
	if false:
		return Rect2()
	return Rect2(global_position.x + (4.0 if dir > 0 else -22.0), global_position.y - 8.0, 18.0, 12.0)


func is_dangerous() -> bool:
	return alive and ai != "stun"


func is_aggro() -> bool:
	if not alive or player == null:
		return false
	var d: float = (player.global_position as Vector2).distance_to(global_position)
	return (kind == 1 and awake and d < 160.0) or (kind != 1 and d < (170.0 if kind == 2 else 110.0))


## Returns true if this killed it.
func hurt(dmg: int, from_x: float) -> bool:
	if not alive:
		return false
	hp -= dmg
	flash = 0.12
	var d := signf(global_position.x - from_x)
	if d == 0.0:
		d = 1.0
	knock = d * 150.0
	if kind == 1:
		awake = true
		velocity = Vector2(d * 160.0, -60.0)
	if hp <= 0:
		kill(d)
		return true
	if ai == "windup":
		ai = "recover"
		ai_t = 0.3
	return false


func stun(time: float, from_x: float) -> void:
	ai = "stun"
	ai_t = time
	knock = signf(global_position.x - from_x) * 170.0
	flash = 0.15


func kill(k: float) -> void:
	alive = false
	collision_layer = 0
	collision_mask = 0
	velocity = Vector2(k * 170.0 if k != 0.0 else randf_range(-60.0, 60.0), -230.0)
	spin = randf_range(-14.0, 14.0)


func _physics_process(delta: float) -> void:
	t += delta
	flash = maxf(0.0, flash - delta)
	queue_redraw()
	if not alive:
		dead_t += delta
		velocity.y += 900.0 * delta
		position += velocity * delta
		rotation += spin * delta
		modulate.a = clampf(1.2 - dead_t, 0.0, 1.0)
		if dead_t > 1.2:
			queue_free()
		return
	if beh != "":
		_ranged(delta)
	elif kind == 1:
		_bat(delta)
	else:
		_guard(delta)


## Heavies block strikes that come from the front.
func blocking(from_x: float) -> bool:
	return kind == 3 and alive and ai != "stun" and int(signf(from_x - global_position.x)) == dir


func _guard(delta: float) -> void:
	velocity.y = minf(velocity.y + 900.0 * delta, 400.0)
	ai_t -= delta
	punch_cd -= delta
	knock = move_toward(knock, 0.0, 600.0 * delta)
	var to: Vector2 = player.global_position - global_position
	match ai:
		"walk":
			velocity.x = dir * speed
			if is_on_floor():
				var ahead := global_position + Vector2(dir * (size.x * 0.5 + 2.0), 0)
				var below := ahead + Vector2(0, size.y * 0.5 + 4.0)
				var feet := ahead + Vector2(0, size.y * 0.5 - 2.0)
				if level.solid_at(ahead) or not level.solid_at(below) or level.get_cell(floori(feet.x / 16.0), floori(feet.y / 16.0)) == 2:
					dir = -dir
					velocity.x = dir * speed
			if kind == 2:
				if punch_cd <= 0.0 and absf(to.x) < 170.0 and absf(to.y) < 50.0 and player.state != 7:
					dir = int(signf(to.x)) if to.x != 0.0 else dir
					ai = "aim"
					ai_t = 0.55
					Sfx.play("windup", 1.5)
			elif punch_cd <= 0.0 and absf(to.x) < (44.0 if kind == 3 else 34.0) and absf(to.y) < 18.0 and player.state != 7:
				dir = int(signf(to.x)) if to.x != 0.0 else dir
				ai = "windup"
				ai_t = 0.65 if kind == 3 else 0.42
				Sfx.play("windup", 0.7 if kind == 3 else 1.0)
		"windup", "aim":
			velocity.x = 0.0
		"punch":
			velocity.x = dir * (110.0 if kind == 3 else 170.0)
		"recover", "stun":
			velocity.x = 0.0
	if ai_t <= 0.0:
		match ai:
			"aim":
				var aim_at: Vector2 = player.global_position + Vector2(0, -4)
				fire.emit("card", global_position + Vector2(dir * 8, -6), (aim_at - global_position).normalized() * 175.0)
				Sfx.play("swing", 1.3)
				ai = "recover"
				ai_t = 0.5
			"windup":
				ai = "punch"
				ai_t = 0.2 if kind == 3 else 0.16
				Sfx.play("punch", 0.7 if kind == 3 else 1.0)
			"punch":
				ai = "recover"
				ai_t = 0.45
			"recover", "stun":
				ai = "walk"
				punch_cd = randf_range(1.8, 2.6) if kind == 2 else randf_range(0.9, 1.6)
	velocity.x += knock
	move_and_slide()
	if ai == "walk" and is_on_wall():
		dir = -dir


## Ranged / pattern enemies (see enemy_types.gd). Every attack has a visible
## telegraph ("aim" state, the "!" marker, and a laser line for snipers).
func _ranged(delta: float) -> void:
	ai_t -= delta
	shot_cd -= delta
	knock = move_toward(knock, 0.0, 600.0 * delta)
	var to: Vector2 = player.global_position - global_position
	if beh == "drone":
		var hover: Vector2 = player.global_position + Vector2(signf(sin(t * 0.7)) * 70.0, -48.0)
		velocity = velocity.move_toward((hover - global_position).limit_length(speed) + Vector2(0, sin(t * 4.0) * 14.0), 200.0 * delta)
		if ai == "walk" and shot_cd <= 0.0 and to.length() < 200.0:
			_begin_aim()
		_ranged_ai()
		dir = 1 if to.x >= 0.0 else -1
		move_and_slide()
		return
	velocity.y = minf(velocity.y + 900.0 * delta, 400.0)
	match ai:
		"walk":
			if beh == "rat":
				dir = 1 if to.x >= 0.0 else -1
				velocity.x = dir * (speed if absf(to.x) < 150.0 else speed * 0.4) * (1.0 if int(t * 2.0) % 3 != 0 else 0.3)
			elif beh == "snipe":
				velocity.x = 0.0
				dir = 1 if to.x >= 0.0 else -1
			else:
				# Keep a comfortable distance: back off when close, edge in when far.
				var want := 90.0 if beh in ["lob", "needle"] else 120.0
				dir = 1 if to.x >= 0.0 else -1
				var dist := absf(to.x)
				velocity.x = -dir * speed if dist < want * 0.6 else (dir * speed * 0.6 if dist > want * 1.5 else 0.0)
			if is_on_floor() and velocity.x != 0.0:
				var mv := int(signf(velocity.x))
				var ahead := global_position + Vector2(mv * (size.x * 0.5 + 2.0), 0)
				var below := ahead + Vector2(0, size.y * 0.5 + 4.0)
				if level.solid_at(ahead) or not level.solid_at(below):
					velocity.x = 0.0
			var rng_ok: bool = absf(to.x) < (230.0 if beh == "snipe" else 170.0) and absf(to.y) < (90.0 if beh == "snipe" else 50.0)
			if beh != "rat" and shot_cd <= 0.0 and rng_ok and player.state != 7:
				_begin_aim()
		"aim", "recover", "stun":
			velocity.x = 0.0
	_ranged_ai()
	velocity.x += knock
	move_and_slide()
	if beh == "rat" and ai == "walk" and is_on_wall() and is_on_floor():
		velocity.y = -170.0


func _begin_aim() -> void:
	ai = "aim"
	ai_t = float(T["tele"]) * v_cd
	dir = 1 if player.global_position.x >= global_position.x else -1
	Sfx.play("windup", 1.6 if beh != "snipe" else 0.8)


func _ranged_ai() -> void:
	if ai_t > 0.0:
		return
	match ai:
		"aim":
			var from := global_position + Vector2(dir * 8, -4)
			var pspeed := float(T["pspeed"])
			var tp: Vector2 = player.global_position + Vector2(0, -5)
			# Aim lead varies per instance: some enemies shoot where you are, some where you'll be.
			var dist := from.distance_to(tp)
			tp += (player.velocity as Vector2) * (dist / pspeed) * v_lead * 0.8
			var base := (tp - from).normalized()
			match beh:
				"lob", "needle":
					var dx := tp.x - from.x
					var tt := clampf(absf(dx) / pspeed, 0.35, 1.2)
					fire.emit(String(T["proj"]), from, Vector2(dx / tt, (tp.y - from.y) / tt - 0.5 * 520.0 * tt))
				"fan":
					for i in v_shots:
						var a := lerpf(-0.35, 0.35, float(i) / maxf(1.0, v_shots - 1.0)) if v_shots > 1 else 0.0
						fire.emit(String(T["proj"]), from, base.rotated(a) * pspeed)
				"burst":
					for i in v_shots:
						get_tree().create_timer(0.12 * i).timeout.connect(_burst_shot.bind(pspeed))
				_:
					fire.emit(String(T["proj"]), from, base * pspeed)
			Sfx.play("swing", 1.4)
			ai = "recover"
			ai_t = 0.4
		"recover", "stun":
			ai = "walk"
			shot_cd = randf_range(float(T.get("cd", [1.5, 2.0])[0]), float(T.get("cd", [1.5, 2.0])[1])) * v_cd


func _burst_shot(pspeed: float) -> void:
	if not alive or player == null or not is_instance_valid(player):
		return
	var from := global_position + Vector2(dir * 8, -4)
	var tp: Vector2 = player.global_position + Vector2(0, -5)
	var dist := from.distance_to(tp)
	tp += (player.velocity as Vector2) * (dist / pspeed) * v_lead * 0.8
	fire.emit(String(T["proj"]), from, (tp - from).normalized() * pspeed)


func _bat(delta: float) -> void:
	var to: Vector2 = player.global_position - global_position
	if not awake:
		velocity = Vector2.ZERO
		if to.length() < 100.0 and to.y > -16.0:
			awake = true
			velocity = Vector2(0, 40)
	else:
		var desired := to.normalized() * speed + Vector2(0, sin(t * 6.0) * 35.0)
		velocity = velocity.move_toward(desired, 260.0 * delta)
		move_and_slide()
		if absf(velocity.x) > 5.0:
			dir = int(signf(velocity.x))


func _process(delta: float) -> void:
	if rig == null:
		return
	var tp: Dictionary
	if not alive:
		var f := sin(t * 22.0)
		tp = Rig.make(Vector2(0, -8), 0.3 * f, 0.5, Vector2(4, 1 + f), Vector2(-4, 1 - f), Vector2(6, -19 + f), Vector2(-6, -18 - f))
	else:
		walk_phase += delta * absf(velocity.x) * 0.33
		var ph := walk_phase
		var cf := cos(ph)
		var sf := sin(ph)
		var hip := Vector2(0.3, -7.5 - absf(cf) * 0.6)
		var sh: Vector2 = rig.shoulder_of(hip, 0.08)
		tp = Rig.make(hip, 0.08, sin(ph * 0.5) * 0.05,
			Vector2(cf * 3.2 + 0.3, -maxf(0.0, -sf) * 2.2),
			Vector2(-cf * 3.2 + 0.3, -maxf(0.0, sf) * 2.2),
			sh + Vector2(-cf * 2.2 + 0.8, 6.4), sh + Vector2(cf * 2.2 + 0.2, 6.4))
		match ai:
			"aim":
				tp["hand_f"] = sh + Vector2(lerpf(-5.0, 8.0, clampf(1.0 - ai_t / 0.55, 0.0, 1.0)), -4.0)
				tp["head"] = -0.1
			"windup":
				tp["torso"] = -0.3
				tp["hand_f"] = sh + Vector2(-6.0, -1.0)
				tp["foot_f"] = Vector2(3.5, 0)
				tp["foot_b"] = Vector2(-3.5, 0)
			"punch":
				tp["torso"] = 0.35
				tp["hand_f"] = sh + Vector2(9.0, 0.5)
				tp["foot_f"] = Vector2(5.0, 0)
				tp["foot_b"] = Vector2(-4.0, 0)
			"stun":
				tp["torso"] = -0.25 + sin(t * 8.0) * 0.1
				tp["head"] = 0.4
				tp["hand_f"] = sh + Vector2(2, 7)
				tp["hand_b"] = sh + Vector2(-2, 7)
	rig.blend(tp, 40.0 if ai == "punch" or ai == "windup" or ai == "aim" else 30.0, delta)


func _draw_special() -> bool:
	var col: Color = T.get("col", Color.WHITE)
	if beh == "rat":
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(float(dir), 1.0))
		draw_ellipse_like(Vector2(0, 1), Vector2(5, 3), col)
		draw_circle(Vector2(5, 0), 2.4, col.lightened(0.1))
		draw_circle(Vector2(6.2, -0.6), 0.6, Color(1, 0.2, 0.2))
		draw_line(Vector2(-5, 1), Vector2(-10, -1.0 + sin(t * 14.0) * 2.0), col.darkened(0.2), 1.0)
		for i in 2:
			draw_line(Vector2(-2 + i * 4, 3), Vector2(-3 + i * 4 + sin(t * 25.0 + i * 3.0) * 2.0, 5), col.darkened(0.3), 1.0)
		draw_set_transform(Vector2.ZERO)
		return true
	if beh == "drone":
		var b := sin(t * 5.0) * 1.0
		draw_rect(Rect2(-6, -3 + b, 12, 6), Color(0.1, 0.12, 0.16))
		draw_rect(Rect2(-5, -2 + b, 10, 4), col)
		draw_circle(Vector2(0, b), 1.8, Color(1, 0.2, 0.2) if int(t * 4.0) % 2 == 0 or ai == "aim" else Color(0.4, 0.1, 0.1))
		for sx in [-1.0, 1.0]:
			draw_line(Vector2(sx * 5, -3 + b), Vector2(sx * 9, -5 + b), Color(0.8, 0.85, 0.9), 1.0)
			draw_rect(Rect2(sx * 9 - 3, -6 + b, 6, 1), Color(0.8, 0.85, 0.9, 0.5 + 0.4 * sin(t * 40.0)))
		if flash > 0.0:
			draw_rect(Rect2(-6, -3, 12, 6), Color(1, 1, 1, 0.7))
		if ai == "aim":
			draw_string(ThemeDB.fallback_font, Vector2(-5, -12), "!", HORIZONTAL_ALIGNMENT_CENTER, 10, 12, Color(1, 0.25, 0.2))
		return true
	return false


func draw_ellipse_like(c: Vector2, r: Vector2, col: Color) -> void:
	var pts := PackedVector2Array()
	for i in 14:
		var a := TAU * i / 14.0
		pts.append(c + Vector2(cos(a) * r.x, sin(a) * r.y))
	draw_colored_polygon(pts, col)


func _draw() -> void:
	if beh != "" and _draw_special():
		return
	if beh == "snipe" and alive and ai == "aim":
		var from := Vector2(dir * 8, -4)
		var toward: Vector2 = (player.global_position + Vector2(0, -5)) - global_position
		draw_line(from, toward, Color(1, 0.15, 0.15, 0.25 + 0.6 * (1.0 - ai_t / maxf(0.01, float(T["tele"]) * v_cd))), 1.0)
	if kind != 1:
		if alive:
			draw_set_transform(Vector2(0, size.y * 0.5), 0.0, Vector2(1.0, 0.28))
			draw_circle(Vector2.ZERO, 8.0 * _scale(), Color(0, 0, 0, 0.4))
		if elite and alive:
			var gp := 0.5 + 0.5 * sin(t * 4.0)
			draw_circle(Vector2(0, 0), size.y * 0.75, Color(1, 0.8, 0.25, 0.08 + 0.06 * gp))
		rig.draw(self, Transform2D(0.0, Vector2(float(dir), 1.0) * _scale(), 0.0, Vector2(0, size.y * 0.5)))
		if beh != "" and alive:
			var tc: Color = T.get("col", Color.GRAY)
			draw_set_transform(Vector2(0, size.y * 0.5) , 0.0, Vector2(float(dir), 1.0))
			draw_rect(Rect2(-3.5, -size.y + 8.0, 7, 7), Color(tc, 0.55))
			draw_set_transform(Vector2.ZERO)
		draw_set_transform(Vector2.ZERO)
		if elite and alive:
			var cy := -size.y * 0.5 - 9.0
			draw_colored_polygon(PackedVector2Array([Vector2(-4, cy), Vector2(-4, cy - 4), Vector2(-2, cy - 2), Vector2(0, cy - 5), Vector2(2, cy - 2), Vector2(4, cy - 4), Vector2(4, cy)]), Color(1, 0.82, 0.25))
		if kind == 3 and alive:
			var sx := dir * 9.0
			var raised := ai == "stun"
			var sr := Rect2(sx - 3.0, -10.0 if not raised else -2.0, 6.0, 20.0)
			draw_rect(sr.grow(1.0), Color(0.05, 0.05, 0.07))
			draw_rect(sr, Color(0.45, 0.5, 0.6))
			draw_rect(Rect2(sr.position + Vector2(1, 3), Vector2(4, 3)), Color(0.6, 0.85, 1.0, 0.7))
			draw_rect(Rect2(sr.position + Vector2(0, 12), Vector2(6, 1)), Color(0.9, 0.7, 0.2))
		draw_set_transform(Vector2.ZERO)
		if flash > 0.0:
			draw_rect(Rect2(-size * 0.5, size), Color(1, 1, 1, 0.6))
		if alive and (ai == "windup" or ai == "aim"):
			var blink := int(t * 20.0) % 2 == 0
			draw_string(ThemeDB.fallback_font, Vector2(-5, -size.y * 0.5 - 6), "!", HORIZONTAL_ALIGNMENT_CENTER, 10, 12, Color(1, 0.25, 0.2) if blink else Color(1, 0.9, 0.3))
		if alive and ai == "stun":
			for i in 3:
				var a := t * 5.0 + i * TAU / 3.0
				draw_circle(Vector2(cos(a) * 6.0, -size.y * 0.5 - 4 + sin(a) * 2.0), 1.3, Color(1, 0.9, 0.3))
		if alive and hp < max_hp:
			draw_rect(Rect2(-7, -size.y * 0.5 - 4, 14, 2), Color(0, 0, 0, 0.7))
			draw_rect(Rect2(-7, -size.y * 0.5 - 4, 14.0 * hp / max_hp, 2), Color(1, 0.3, 0.3))
		return
	if not awake and alive:
		var tex: Texture2D = Sprites.bat()[2]
		draw_set_transform(Vector2(0, -size.y * 0.5 - 1.0), sin(t * 2.0) * 0.12, Vector2.ONE)
		draw_texture(tex, Vector2(-tex.get_width() * 0.5, 0))
		draw_set_transform(Vector2.ZERO)
		return
	var flap := sin(t * 20.0)
	var ol := Color(0.08, 0.02, 0.1)
	var body := Color(0.45, 0.2, 0.6) if flash <= 0.0 else Color.WHITE
	var wing := Color(0.6, 0.3, 0.74)
	var tilt := clampf(velocity.x * 0.004, -0.4, 0.4)
	draw_set_transform(Vector2.ZERO, tilt, Vector2.ONE)
	for side in [-1.0, 1.0]:
		var sh := Vector2(side * 2.0, -0.5)
		var el := sh + Vector2(side * 4.0, -2.0 - flap * 3.5)
		var tip := el + Vector2(side * 5.0, 1.0 - flap * 3.0)
		var m1 := sh + Vector2(side * 2.5, 3.0 - flap * 0.5)
		var m2 := el + Vector2(side * 1.5, 3.5 - flap * 1.5)
		var m3 := tip + Vector2(-side * 0.8, 2.2)
		for tri in [[sh, el, m1], [el, m2, m1], [el, tip, m2], [tip, m3, m2]]:
			draw_colored_polygon(PackedVector2Array(tri), wing)
		draw_polyline(PackedVector2Array([sh, m1, m2, m3, tip]), ol, 0.8)
		draw_polyline(PackedVector2Array([sh, el, tip]), ol, 1.8)
		draw_polyline(PackedVector2Array([sh, el, tip]), body.darkened(0.2), 0.9)
	for side in [-1.0, 1.0]:
		draw_colored_polygon(PackedVector2Array([Vector2(side * 2.6, -1.8), Vector2(side * 1.8, -5.2), Vector2(side * 0.6, -2.4)]), ol)
	draw_circle(Vector2(0, 0.4), 3.9, ol)
	draw_circle(Vector2(0, 0.4), 3.1, body)
	draw_circle(Vector2(-0.8, -0.6), 1.2, body.lightened(0.15))
	draw_rect(Rect2(-2.0, -0.6, 1.3, 1.3), Color(1, 0.25, 0.25))
	draw_rect(Rect2(0.7, -0.6, 1.3, 1.3), Color(1, 0.25, 0.25))
	draw_rect(Rect2(-1.2, 2.0, 0.8, 1.2), Color.WHITE)
	draw_rect(Rect2(0.4, 2.0, 0.8, 1.2), Color.WHITE)
	draw_set_transform(Vector2.ZERO)


func _scale() -> float:
	return 1.3 if kind == 3 else 1.0
