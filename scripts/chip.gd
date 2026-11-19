extends Node2D
## A casino chip. 1 = silver, 5 = red, 25 = gold, 100 = purple jackpot.
## "Loose" chips burst out of smashed things and bounce on the level.

var value := 1
var t := 0.0
var age := 10.0
var loose := false
var vel := Vector2.ZERO
var level
## Spilled chips skip the multipliers (they were already counted) and vanish
## after `ttl` seconds if nobody grabs them.
var raw := false
var ttl := -1.0


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
	if ttl > 0.0 and age > ttl:
		queue_free()
		return
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


## Real casino colors: $1 white, $5 red, $25 green, $100 black, $500 purple, $1000 orange.
static func color_of(v: int) -> Color:
	if v >= 1000:
		return Color(1.0, 0.6, 0.12)
	if v >= 500:
		return Color(0.62, 0.3, 0.9)
	if v >= 100:
		return Color(0.1, 0.1, 0.12)
	if v >= 25:
		return Color(0.15, 0.7, 0.3)
	if v >= 5:
		return Color(0.9, 0.15, 0.2)
	return Color(0.95, 0.95, 0.97)


func color() -> Color:
	return color_of(value)


func _draw() -> void:
	var y := 0.0 if loose else sin(t * 3.0) * 1.5
	var r := 3.5 if value == 1 else (4.5 if value == 5 else (5.0 if value == 25 else (5.5 if value == 100 else (6.0 if value == 500 else 6.8))))
	var c := color()
	if ttl > 0.0 and age > ttl - 1.2 and int(age * 12.0) % 2 == 0:
		c.a = 0.35
	draw_circle(Vector2(0, y), r + 3.0, Color(c, 0.14))
	var spin := absf(cos(t * (9.0 if loose else 2.2)))
	draw_set_transform(Vector2(0, y), 0.0, Vector2(maxf(0.2, spin), 1.0))
	draw_circle(Vector2.ZERO, r, c)
	var inner := Color(1, 1, 1) if c.v < 0.5 or value in [5, 25, 500] else Color(0.15, 0.15, 0.2)
	for i in 6:
		var a := i * TAU / 6.0
		draw_circle(Vector2(cos(a), sin(a)) * r * 0.82, r * 0.14, inner)
	draw_circle(Vector2.ZERO, r * 0.55, c.darkened(0.25))
	draw_circle(Vector2.ZERO, r * 0.3, c.lightened(0.15))
	draw_set_transform(Vector2.ZERO)
