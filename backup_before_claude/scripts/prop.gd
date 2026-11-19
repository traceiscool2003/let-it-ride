extends Node2D
## Breakable props (crate, urn, glass case) and casino tables (blackjack,
## roulette). Origin is bottom-center on the floor.

var kind := "crate"
var t := 0.0
var broken := false


func _ready() -> void:
	z_index = -4
	t = randf() * 10.0


func breakable() -> bool:
	return kind == "crate" or kind == "urn" or kind == "case"


func rect() -> Rect2:
	match kind:
		"crate": return Rect2(position.x - 6, position.y - 12, 12, 12)
		"urn": return Rect2(position.x - 5, position.y - 13, 10, 13)
		"case": return Rect2(position.x - 6, position.y - 16, 12, 16)
	return Rect2(position.x - 16, position.y - 16, 32, 16)


func debris_color() -> Color:
	match kind:
		"crate": return Color(0.6, 0.4, 0.2)
		"urn": return Color(0.3, 0.45, 0.85)
	return Color(0.7, 0.9, 1.0)


func _process(delta: float) -> void:
	t += delta
	if kind == "case" or kind == "roulette" or kind == "bar":
		queue_redraw()


func _draw() -> void:
	var k := Color(0.06, 0.03, 0.06)
	match kind:
		"bar":
			_draw_bar_npc()
		"crate":
			draw_rect(Rect2(-6, -12, 12, 12), k)
			draw_rect(Rect2(-5, -11, 10, 10), Color(0.5, 0.31, 0.16))
			draw_rect(Rect2(-5, -11, 10, 2), Color(0.64, 0.42, 0.22))
			draw_line(Vector2(-5, -1), Vector2(5, -11), Color(0.38, 0.22, 0.1), 1.5)
			draw_rect(Rect2(-1.5, -7.5, 3, 3), Color(1, 0.8, 0.3))
		"urn":
			var pts := PackedVector2Array([Vector2(-2, -13), Vector2(2, -13), Vector2(2, -11), Vector2(5, -7), Vector2(4, -2), Vector2(2, 0), Vector2(-2, 0), Vector2(-4, -2), Vector2(-5, -7), Vector2(-2, -11)])
			draw_colored_polygon(pts, Color(0.2, 0.32, 0.7))
			draw_polyline(pts + PackedVector2Array([pts[0]]), k, 1.0)
			draw_rect(Rect2(-4.5, -7, 9, 2), Color(0.95, 0.75, 0.3))
			draw_rect(Rect2(-3, -10, 1, 6), Color(0.5, 0.65, 1, 0.6))
		"case":
			draw_rect(Rect2(-6, -5, 12, 5), Color(0.18, 0.08, 0.12))
			draw_rect(Rect2(-6, -5, 12, 1), Color(0.85, 0.65, 0.25))
			var shine := 0.5 + 0.5 * sin(t * 3.0)
			draw_circle(Vector2(0, -10), 3.0, Color(1, 0.8, 0.25))
			draw_circle(Vector2(0, -10), 1.6, Color(0.75, 0.55, 0.15))
			draw_rect(Rect2(-5, -16, 10, 11), Color(0.6, 0.9, 1, 0.22))
			draw_rect(Rect2(-5, -16, 10, 11), Color(0.8, 0.95, 1, 0.6), false, 1.0)
			draw_line(Vector2(-3, -7), Vector2(1, -15), Color(1, 1, 1, 0.3 + 0.4 * shine), 1.0)
		"blackjack":
			_table(Color(0.08, 0.42, 0.25))
			for i in 3:
				draw_rect(Rect2(-9 + i * 6, -17, 4, 5), Color(0.95, 0.95, 0.9))
				draw_rect(Rect2(-8 + i * 6, -16, 1, 1), Color(0.8, 0.1, 0.15))
			draw_string(ThemeDB.fallback_font, Vector2(-16, -24), "21", HORIZONTAL_ALIGNMENT_CENTER, 32, 7, Color(1, 0.85, 0.35))
		"roulette":
			_table(Color(0.08, 0.36, 0.22))
			var c := Vector2(0, -17)
			draw_circle(c, 6.0, Color(0.35, 0.2, 0.1))
			for i in 12:
				var a := t * 2.0 + i * TAU / 12.0
				draw_line(c, c + Vector2.from_angle(a) * 5.0, Color(0.85, 0.1, 0.15) if i % 2 == 0 else Color(0.05, 0.05, 0.05), 2.0)
			draw_circle(c, 1.5, Color(0.9, 0.75, 0.3))


func _table(felt: Color) -> void:
	var k := Color(0.06, 0.03, 0.06)
	draw_rect(Rect2(-14, -12, 4, 12), Color(0.25, 0.14, 0.08))
	draw_rect(Rect2(10, -12, 4, 12), Color(0.25, 0.14, 0.08))
	draw_rect(Rect2(-17, -15, 34, 4), k)
	draw_rect(Rect2(-16, -15, 32, 3), felt)
	draw_rect(Rect2(-17, -12, 34, 2), Color(0.45, 0.28, 0.12))


func _draw_bar_npc() -> void:
	# Lucky's counter.
	draw_rect(Rect2(-18, -13, 36, 13), Color(0.3, 0.16, 0.08))
	draw_rect(Rect2(-19, -15, 38, 3), Color(0.55, 0.35, 0.15))
	draw_rect(Rect2(-18, -10, 36, 1), Color(0.85, 0.65, 0.25))
	for i in 4:
		var bx := -14.0 + i * 9.0
		draw_rect(Rect2(bx, -26, 3, 8), [Color(0.3, 0.7, 0.4), Color(0.7, 0.3, 0.2), Color(0.9, 0.8, 0.3), Color(0.4, 0.5, 0.9)][i])
		draw_rect(Rect2(bx + 1, -29, 1, 3), Color(0.2, 0.2, 0.2))
	# Lucky: green visor, white shirt, red vest.
	var bob := sin(t * 2.0) * 0.5
	draw_rect(Rect2(4, -27 + bob, 10, 12), Color(0.06, 0.03, 0.06))
	draw_rect(Rect2(5, -26 + bob, 8, 11), Color(0.95, 0.95, 0.92))
	draw_rect(Rect2(5, -22 + bob, 3, 7), Color(0.75, 0.1, 0.15))
	draw_rect(Rect2(10, -22 + bob, 3, 7), Color(0.75, 0.1, 0.15))
	draw_rect(Rect2(5, -35 + bob, 8, 8), Color(0.88, 0.7, 0.55))
	draw_rect(Rect2(4, -36 + bob, 10, 3), Color(0.2, 0.7, 0.35))
	draw_rect(Rect2(11, -32 + bob, 2, 1), Color(0.1, 0.05, 0.05))
	draw_rect(Rect2(7, -29 + bob, 4, 1), Color(0.5, 0.25, 0.2))
