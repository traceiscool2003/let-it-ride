extends Node2D
## Boss projectiles: spinning cards, bouncing roulette balls, floor shockwaves.
## Parry or strike them to send them back ("player" owned) at the boss.

var kind := "card"
var vel := Vector2.ZERO
var owner_tag := "boss"
var level
var life := 5.0
var t := 0.0
var alive := true
var size := Vector2(8, 6)
## Weapon projectiles (owner_tag "weapon"): see weapons.gd. Parameters in wp.
var wp := {}
var hit_set := {}
var bounces_left := 0
var origin := Vector2.ZERO
var returning := false


func setup_weapon(w: Dictionary, lvl, v: Vector2) -> void:
	kind = "wp"
	owner_tag = "weapon"
	wp = w
	level = lvl
	vel = v
	life = float(w.get("life", 1.0))
	bounces_left = int(w.get("bounces", 0))
	size = Vector2(6, 6)
	z_index = 4


func setup(k: String, lvl, v: Vector2) -> void:
	kind = k
	level = lvl
	vel = v
	z_index = 3
	match kind:
		"ball":
			size = Vector2(7, 7)
			life = 6.0
		"wave":
			size = Vector2(10, 14)
			life = 4.0


func rect() -> Rect2:
	if kind == "wave":
		return Rect2(global_position.x - size.x * 0.5, global_position.y - size.y, size.x, size.y)
	return Rect2(global_position - size * 0.5, size)


func reflect(toward: Vector2) -> void:
	owner_tag = "player"
	vel = (toward - global_position).normalized() * maxf(vel.length() * 1.4, 300.0)
	life = 3.0


func die() -> void:
	alive = false
	queue_free()


func _physics_process(delta: float) -> void:
	t += delta
	life -= delta
	if kind == "wp":
		_wp_step(delta)
		return
	match kind:
		"card":
			position += vel * delta
			if level.solid_at(position):
				die()
				return
		"ball":
			vel.y += 650.0 * delta
			var np := position + vel * delta
			if level.solid_at(np + Vector2(signf(vel.x) * 3.5, 0)):
				vel.x = -vel.x
				np.x = position.x
			if vel.y > 0.0 and level.solid_at(np + Vector2(0, 3.5)):
				vel.y = -maxf(absf(vel.y) * 0.82, 230.0)
				np.y = position.y
			elif vel.y < 0.0 and level.solid_at(np + Vector2(0, -3.5)):
				vel.y = absf(vel.y)
				np.y = position.y
			position = np
		"wave":
			position += vel * delta
			if level.solid_at(position + Vector2(signf(vel.x) * 6.0, -4.0)) or not level.solid_at(position + Vector2(0, 4.0)):
				die()
				return
	if life <= 0.0:
		die()
		return
	queue_redraw()


func _wp_step(delta: float) -> void:
	var g: float = wp.get("grav", 0.0)
	vel.y += g * delta
	if wp.get("boomerang", false):
		var pl = level.get_meta("player", null)
		if not returning and t > 0.45:
			returning = true
		if returning and pl != null and is_instance_valid(pl):
			var want: Vector2 = ((pl.global_position + Vector2(0, -8)) - global_position).normalized() * 300.0
			vel = vel.lerp(want, minf(1.0, 7.0 * delta))
			if global_position.distance_to(pl.global_position) < 10.0:
				die()
				return
		hit_set.clear() if returning and int(t * 10.0) % 4 == 0 else null
	var np := position + vel * delta
	if level.solid_at(np):
		if bounces_left > 0:
			bounces_left -= 1
			if level.solid_at(Vector2(np.x, position.y)):
				vel.x = -vel.x * 0.9
			else:
				vel.y = -vel.y * 0.85
			np = position
		elif not wp.get("boomerang", false):
			wp["hit_wall"] = true
			life = 0.0
			return
		else:
			returning = true
			np = position
	position = np
	if life <= 0.0:
		wp["expired"] = true
		die()
		return
	queue_redraw()


func _draw_wp() -> void:
	var c: Color = wp.get("col", Color.WHITE)
	var spin := t * 16.0
	draw_circle(Vector2.ZERO, 5.0, Color(c, 0.2))
	match String(wp.get("shape", "chip")):
		"chip":
			draw_circle(Vector2.ZERO, 3.0, Color(0.1, 0.02, 0.04))
			draw_circle(Vector2.ZERO, 2.5, c)
			draw_circle(Vector2.ZERO, 1.0, Color(1, 1, 1))
		"card":
			draw_set_transform(Vector2.ZERO, spin, Vector2.ONE)
			draw_rect(Rect2(-2.5, -3.5, 5, 7), c)
			draw_rect(Rect2(-0.8, -1, 1.6, 2), Color(0.85, 0.1, 0.15))
			draw_set_transform(Vector2.ZERO)
		"die":
			draw_set_transform(Vector2.ZERO, spin * 0.6, Vector2.ONE)
			draw_rect(Rect2(-3.5, -3.5, 7, 7), c)
			draw_circle(Vector2(-1.5, -1.5), 0.9, Color(0.1, 0.1, 0.1))
			draw_circle(Vector2(1.5, 1.5), 0.9, Color(0.1, 0.1, 0.1))
			draw_circle(Vector2.ZERO, 0.9, Color(0.8, 0.1, 0.1))
			draw_set_transform(Vector2.ZERO)
		"bottle":
			draw_set_transform(Vector2.ZERO, spin * 0.5, Vector2.ONE)
			draw_rect(Rect2(-1.8, -3, 3.6, 6), c)
			draw_rect(Rect2(-0.8, -5, 1.6, 2.5), c.lightened(0.2))
			draw_set_transform(Vector2.ZERO)
		"bullet":
			draw_line(-vel.normalized() * 6.0, Vector2.ZERO, Color(c, 0.5), 2.0)
			draw_circle(Vector2.ZERO, 1.8, c)
		"ball":
			draw_circle(Vector2.ZERO, 3.8, Color(0.05, 0.02, 0.05))
			draw_circle(Vector2.ZERO, 3.0, c if int(t * 8.0) % 2 == 0 else Color(0.12, 0.12, 0.14))
			draw_circle(Vector2(-1, -1), 1.0, Color(1, 1, 1, 0.8))
		"cash":
			draw_set_transform(Vector2.ZERO, spin, Vector2.ONE)
			draw_rect(Rect2(-5, -2.5, 10, 5), c)
			draw_rect(Rect2(-1, -2.5, 2, 5), Color(0.9, 0.85, 0.5))
			draw_set_transform(Vector2.ZERO)
		"coin":
			draw_circle(Vector2.ZERO, 2.2, Color(0.2, 0.2, 0.25))
			draw_circle(Vector2.ZERO, 1.8, c)


func _draw() -> void:
	if kind == "wp":
		_draw_wp()
		return
	var mine := owner_tag == "player"
	match kind:
		"card":
			draw_circle(Vector2.ZERO, 7.0, Color(0.4, 0.9, 1.0, 0.25) if mine else Color(1, 0.3, 0.3, 0.18))
			draw_set_transform(Vector2.ZERO, t * 18.0, Vector2.ONE)
			draw_rect(Rect2(-3.5, -5, 7, 10), Color(0.05, 0.02, 0.05))
			draw_rect(Rect2(-3, -4.5, 6, 9), Color(0.97, 0.95, 0.9))
			draw_rect(Rect2(-1, -1.5, 2, 3), Color(0.85, 0.1, 0.15))
			draw_set_transform(Vector2.ZERO)
		"ball":
			var red := int(t * 6.0) % 2 == 0
			draw_circle(Vector2.ZERO, 6.0, Color(0.4, 0.9, 1.0, 0.3) if mine else Color(1, 0.8, 0.4, 0.15))
			draw_circle(Vector2.ZERO, 3.8, Color(0.05, 0.02, 0.05))
			draw_circle(Vector2.ZERO, 3.0, Color(0.85, 0.1, 0.15) if red else Color(0.12, 0.12, 0.14))
			draw_circle(Vector2(-1, -1), 1.0, Color(1, 1, 1, 0.8))
		"wave":
			var a := clampf(life, 0.0, 1.0)
			var s := signf(vel.x)
			for i in 3:
				var hh := 14.0 - i * 4.0
				draw_line(Vector2(-s * i * 4.0, 0), Vector2(-s * i * 4.0 + s * 3.0, -hh), Color(1, 0.75 - i * 0.2, 0.3, a * (1.0 - i * 0.3)), 3.0)
			draw_rect(Rect2(-6, -2, 12, 2), Color(1, 0.9, 0.6, a))
