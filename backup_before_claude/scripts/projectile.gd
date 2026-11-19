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


func _draw() -> void:
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
