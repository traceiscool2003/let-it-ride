extends Node2D
## Mags Moray, collecting on a late loan. A shark in a pinstripe suit who
## swims straight through walls toward the player. She can't be hurt, and she
## eats any enemy she passes, so a clever runner can lead her into a crowd.
## main.gd spawns her when a loan is past due and handles contact damage.

var target: Node2D
var speed := 62.0
var t := 0.0
var facing := 1.0
var bite := 0.0


func _ready() -> void:
	z_index = 4


func rect() -> Rect2:
	return Rect2(position.x - 13, position.y - 8, 26, 16)


func _process(delta: float) -> void:
	t += delta
	bite = maxf(0.0, bite - delta)
	if target and is_instance_valid(target):
		var to: Vector2 = target.global_position + Vector2(0, -4) - global_position
		var d := to.length()
		if d > 1.0:
			# Lazy at range, relentless up close.
			var s := speed * (1.0 + clampf((260.0 - d) / 260.0, 0.0, 1.0) * 0.6)
			global_position += to / d * s * delta
			if absf(to.x) > 4.0:
				facing = signf(to.x)
	queue_redraw()


func _draw() -> void:
	var sw := sin(t * 7.0) * 2.0
	var k := Color(0.05, 0.03, 0.06)
	var body := Color(0.45, 0.5, 0.6)
	var belly := Color(0.85, 0.85, 0.82)
	var suit := Color(0.12, 0.12, 0.16)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(facing, 1.0))
	# Glow so she reads through walls.
	draw_circle(Vector2.ZERO, 22.0, Color(1.0, 0.2, 0.3, 0.12 + 0.06 * sin(t * 5.0)))
	# Tail.
	draw_colored_polygon(PackedVector2Array([Vector2(-12, 0), Vector2(-20, -7 + sw), Vector2(-18, 0), Vector2(-20, 7 + sw)]), body)
	# Body in a pinstripe suit.
	draw_colored_polygon(PackedVector2Array([Vector2(-13, -6), Vector2(8, -8), Vector2(15, -2), Vector2(13, 4), Vector2(-13, 6)]), k)
	draw_colored_polygon(PackedVector2Array([Vector2(-12, -5), Vector2(8, -7), Vector2(14, -2), Vector2(12, 3), Vector2(-12, 5)]), suit)
	for i in 5:
		draw_line(Vector2(-10 + i * 4, -6), Vector2(-10 + i * 4, 4), Color(0.4, 0.4, 0.5), 0.5)
	# Head and belly.
	draw_colored_polygon(PackedVector2Array([Vector2(6, -8), Vector2(16, -4), Vector2(18, 0), Vector2(14, 4), Vector2(6, 3)]), body)
	draw_colored_polygon(PackedVector2Array([Vector2(8, 1), Vector2(17, 0), Vector2(14, 4), Vector2(8, 4)]), belly)
	# Dorsal fin.
	draw_colored_polygon(PackedVector2Array([Vector2(-2, -7), Vector2(3, -16), Vector2(6, -7)]), body)
	# Teeth and eye.
	var open := 1.5 + bite * 3.0
	for i in 3:
		draw_colored_polygon(PackedVector2Array([Vector2(10 + i * 2.5, 1), Vector2(11 + i * 2.5, 1 + open), Vector2(12 + i * 2.5, 1)]), Color.WHITE)
	draw_circle(Vector2(13, -3), 1.3, Color(1, 0.85, 0.3))
	# Red tie.
	draw_colored_polygon(PackedVector2Array([Vector2(5, 3), Vector2(7, 3), Vector2(6.5, 7), Vector2(5.5, 7)]), Color(0.85, 0.1, 0.15))
	draw_set_transform(Vector2.ZERO)
	draw_string(ThemeDB.fallback_font, Vector2(-24, -20), "PAY UP", HORIZONTAL_ALIGNMENT_CENTER, 48, 7, Color(1, 0.4, 0.45, 0.8 + 0.2 * sin(t * 8.0)))
