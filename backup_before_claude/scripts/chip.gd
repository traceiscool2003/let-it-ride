extends Node2D
## A casino chip. 1 = silver, 5 = red, 25 = gold, 100 = purple jackpot.
## "Loose" chips burst out of smashed things and bounce on the level.

var value := 1
var t := 0.0
var age := 10.0
var loose := false
var vel := Vector2.ZERO
var level


func _ready() -> void:
	t = randf() * TAU
	z_index = 1


func launch(lvl, v: Vector2) -> void:
	level = lvl
	vel = v
	loose = true
	age = 0.0


func collectible() -> bool:
	return age > 0.25


func _process(delta: float) -> void:
	t += delta
	age += delta
	if loose and level:
		vel.y = minf(vel.y + 700.0 * delta, 420.0)
		var np := position + vel * delta
		if level.solid_at(np + Vector2(signf(vel.x) * 4.0, 0)):
			vel.x *= -0.5
			np.x = position.x
		if vel.y > 0.0 and level.solid_at(np + Vector2(0, 4)):
			np.y = floorf((np.y + 4.0) / 16.0) * 16.0 - 4.0
			vel.y *= -0.45
			vel.x *= 0.7
			if absf(vel.y) < 40.0:
				loose = false
		elif vel.y < 0.0 and level.solid_at(np + Vector2(0, -4)):
			vel.y = 0.0
			np.y = position.y
		position = np
	queue_redraw()


func color() -> Color:
	if value >= 100:
		return Color(0.8, 0.4, 1.0)
	if value >= 25:
		return Color(1.0, 0.78, 0.2)
	if value >= 5:
		return Color(0.92, 0.2, 0.26)
	return Color(0.82, 0.86, 0.95)


func _draw() -> void:
	var y := 0.0 if loose else sin(t * 3.0) * 1.5
	var r := 3.5 if value == 1 else (4.5 if value == 5 else (5.5 if value == 25 else 6.5))
	var c := color()
	draw_circle(Vector2(0, y), r + 3.0, Color(c, 0.14))
	var spin := absf(cos(t * (9.0 if loose else 2.2)))
	draw_set_transform(Vector2(0, y), 0.0, Vector2(maxf(0.2, spin), 1.0))
	draw_circle(Vector2.ZERO, r, c)
	draw_circle(Vector2.ZERO, r * 0.65, c.darkened(0.35))
	draw_circle(Vector2.ZERO, r * 0.35, c.lightened(0.2))
	draw_set_transform(Vector2.ZERO)
