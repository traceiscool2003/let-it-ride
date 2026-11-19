extends Node2D
## Lightweight particles and floating text, all drawn in one node.

var parts: Array = []
var texts: Array = []
var font: Font


func _ready() -> void:
	font = ThemeDB.fallback_font
	z_index = 5


func burst(pos: Vector2, n: int, col: Color, spd := 60.0, life := 0.4, size := 2.0, grav := 200.0, dir := Vector2.ZERO, spread := PI) -> void:
	for i in n:
		var a := randf() * TAU
		if dir != Vector2.ZERO:
			a = dir.angle() + randf_range(-spread, spread)
		var v := Vector2.from_angle(a) * spd * randf_range(0.4, 1.0)
		var l := life * randf_range(0.6, 1.0)
		parts.append({"p": pos, "v": v, "l": l, "m": l, "c": col, "s": size, "g": grav})


func text(pos: Vector2, s: String, col: Color, size := 9) -> void:
	texts.append({"p": pos, "s": s, "c": col, "l": 0.9, "z": size})


func _process(delta: float) -> void:
	for p in parts:
		var v: Vector2 = p["v"]
		v.y += p["g"] * delta
		p["v"] = v
		p["p"] = (p["p"] as Vector2) + v * delta
		p["l"] = p["l"] - delta
	parts = parts.filter(func(p): return p["l"] > 0.0)
	for tx in texts:
		tx["p"] = (tx["p"] as Vector2) + Vector2(0, -24.0 * delta)
		tx["l"] = tx["l"] - delta
	texts = texts.filter(func(tx): return tx["l"] > 0.0)
	queue_redraw()


func _draw() -> void:
	for p in parts:
		var k: float = p["l"] / p["m"]
		var s: float = p["s"] * (0.4 + 0.6 * k)
		var c: Color = p["c"]
		draw_rect(Rect2((p["p"] as Vector2) - Vector2(s, s) * 0.5, Vector2(s, s)), Color(c, c.a * k))
	for tx in texts:
		var c: Color = tx["c"]
		var life: float = tx["l"]
		var a: float = clampf(life / 0.3, 0.0, 1.0)
		var pos: Vector2 = tx["p"]
		draw_string_outline(font, pos - Vector2(50, 0), tx["s"], HORIZONTAL_ALIGNMENT_CENTER, 100, tx["z"], 3, Color(0, 0, 0, a))
		draw_string(font, pos - Vector2(50, 0), tx["s"], HORIZONTAL_ALIGNMENT_CENTER, 100, tx["z"], Color(c, a))
