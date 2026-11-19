extends SceneTree
## Three concept designs for Rico, drawn large, so the user can pick a direction.
##   godot --path . --script res://tests/rico_concepts.gd   (windowed)
## Saves user://rico_concepts.png

var frame := 0
var canvas: Node2D


class Sheet extends Node2D:
	var t := 1.3
	var font: Font

	func _ready() -> void:
		font = ThemeDB.fallback_font

	func _draw() -> void:
		draw_rect(Rect2(0, 0, 1280, 720), Color(0.06, 0.05, 0.09))
		for i in 3:
			var cx := 213.0 + i * 427.0
			# Backdrop glow and floor for each concept.
			for r in 8:
				draw_circle(Vector2(cx, 360), 260.0 - r * 28.0, Color([Color(1, 0.7, 0.35), Color(1, 0.35, 0.5), Color(0.3, 0.8, 1.0)][i], 0.018 + r * 0.004))
			draw_rect(Rect2(cx - 180, 600, 360, 3), Color(1, 1, 1, 0.15))
		_high_roller(Vector2(213, 600))
		_hustler(Vector2(640, 600))
		_runner(Vector2(1067, 600))
		var names := [["A.  THE HIGH ROLLER", "Hollow Knight / Silksong style: a strong dark silhouette,\nlong flowing coat, glowing eyes, minimal detail."],
			["B.  THE HUSTLER", "Bold cartoon style: big hair, gold-tooth grin,\nleather jacket, loud and expressive."],
			["C.  THE RUNNER", "Sleek modern style: hood, LED visor with $ eyes,\ntracksuit with glowing neon piping."]]
		for i in 3:
			var cx := 213.0 + i * 427.0
			draw_string(font, Vector2(cx - 200, 650), names[i][0], HORIZONTAL_ALIGNMENT_CENTER, 400, 24, Color(1, 0.85, 0.5))
			draw_multiline_string(font, Vector2(cx - 200, 676), names[i][1], HORIZONTAL_ALIGNMENT_CENTER, 400, 14, 2, Color(0.8, 0.78, 0.88))

	func _p(pts: Array, fill: Color, ol := Color(0.03, 0.02, 0.05), w := 3.0) -> void:
		var pa := PackedVector2Array(pts)
		draw_colored_polygon(pa, fill)
		var loop := pa.duplicate()
		loop.append(pa[0])
		if w > 0.0:
			draw_polyline(loop, ol, w, true)

	func _o(c: Vector2, r: float, fill: Color, ol := Color(0.03, 0.02, 0.05), w := 3.0) -> void:
		if w > 0.0:
			draw_circle(c, r + w * 0.5, ol)
		draw_circle(c, r, fill)

	# ------------------------------------------------------------ A: The High Roller
	func _high_roller(f: Vector2) -> void:
		var coat := Color(0.07, 0.07, 0.12)
		var coat_hi := Color(0.16, 0.15, 0.24)
		var rim := Color(1.0, 0.74, 0.38)
		var o := func(x: float, y: float) -> Vector2: return f + Vector2(x, y)
		# Scarf streaming behind (drawn first).
		var sc: Array = []
		for k in 12:
			var kk := float(k) / 11.0
			sc.append(o.call(-10 - kk * 150.0, -300 + kk * 40.0 + sin(t * 5.0 - kk * 6.0) * 14.0 * kk))
		for k in 11:
			draw_line(sc[k], sc[k + 1], Color(0.75, 0.06, 0.12), lerpf(22.0, 6.0, float(k) / 10.0))
		# Legs: slim, dark trousers, pointed shoes.
		_p([o.call(-22, -150), o.call(-6, -150), o.call(-10, -6), o.call(-24, -6)], coat)
		_p([o.call(6, -150), o.call(22, -150), o.call(20, -6), o.call(8, -6)], coat)
		_p([o.call(-26, -10), o.call(-8, -10), o.call(4, -2), o.call(-26, 0)], Color(0.03, 0.03, 0.04))
		_p([o.call(6, -10), o.call(22, -10), o.call(40, -2), o.call(6, 0)], Color(0.03, 0.03, 0.04))
		# The long coat: narrow waist, flared tails that sway.
		var sway := sin(t * 2.0) * 10.0
		_p([o.call(-40, -300), o.call(40, -300), o.call(46, -220), o.call(30, -200), o.call(60 + sway, -70), o.call(34 + sway, -60),
			o.call(10, -110), o.call(-10, -110), o.call(-34 + sway, -56), o.call(-66 + sway, -72), o.call(-30, -200), o.call(-46, -220)], coat)
		# Coat folds and the rim light from the right.
		draw_line(o.call(0, -290), o.call(0, -112), Color(0.02, 0.02, 0.04), 3.0)
		draw_line(o.call(18, -200), o.call(40 + sway, -80), coat_hi, 3.0)
		draw_line(o.call(40, -300), o.call(46, -220), rim, 3.0)
		draw_line(o.call(46, -220), o.call(30, -200), rim, 2.0)
		draw_line(o.call(30, -200), o.call(60 + sway, -70), rim, 2.0)
		# Popped collar and a gold lapel pin (a poker chip).
		_p([o.call(-38, -300), o.call(-14, -330), o.call(-4, -296)], coat_hi)
		_p([o.call(38, -300), o.call(14, -330), o.call(4, -296)], coat_hi)
		_o(o.call(22, -270), 7.0, Color(0.85, 0.12, 0.18))
		_o(o.call(22, -270), 3.0, Color(1, 0.9, 0.6), Color(0, 0, 0, 0), 0.0)
		# Arm: gloved hand flicking a playing card.
		_p([o.call(30, -290), o.call(48, -284), o.call(58, -210), o.call(44, -206)], coat)
		_o(o.call(54, -200), 10.0, Color(0.1, 0.08, 0.1))
		var card := [o.call(60, -230), o.call(84, -226), o.call(80, -192), o.call(56, -196)]
		_p(card, Color(0.97, 0.95, 0.9), Color(0.03, 0.02, 0.05), 2.0)
		draw_string(font, o.call(63, -204), "A", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.8, 0.1, 0.15))
		# Head in shadow under a wide-brim fedora; two glowing gold eyes.
		_o(o.call(0, -350), 30.0, Color(0.05, 0.05, 0.08))
		_p([o.call(-62, -366), o.call(64, -372), o.call(54, -360), o.call(-56, -354)], Color(0.05, 0.05, 0.08))
		_p([o.call(-34, -370), o.call(36, -372), o.call(30, -412), o.call(4, -404), o.call(-28, -412)], Color(0.06, 0.06, 0.1))
		draw_line(o.call(-34, -378), o.call(36, -380), Color(0.75, 0.06, 0.12), 6.0)   # hat band
		draw_line(o.call(30, -412), o.call(36, -372), rim, 2.0)
		var blink := 1.0 if fmod(t, 4.0) > 0.12 else 0.1
		for ex in [-10.0, 12.0]:
			for g in 5:
				draw_circle(o.call(ex, -344), 14.0 - g * 2.5, Color(1.0, 0.75, 0.3, 0.06 * blink))
			draw_circle(o.call(ex, -344), 4.0, Color(1.0, 0.9, 0.55, blink))

	# ------------------------------------------------------------ B: The Hustler
	func _hustler(f: Vector2) -> void:
		var skin := Color(0.95, 0.74, 0.58)
		var skin_sh := Color(0.8, 0.55, 0.42)
		var jacket := Color(0.32, 0.12, 0.1)
		var o := func(x: float, y: float) -> Vector2: return f + Vector2(x, y)
		# Legs: dark jeans, white high-tops with red stripes.
		_p([o.call(-30, -170), o.call(-6, -170), o.call(-10, -20), o.call(-34, -20)], Color(0.14, 0.16, 0.26))
		_p([o.call(6, -170), o.call(30, -170), o.call(34, -20), o.call(10, -20)], Color(0.12, 0.14, 0.23))
		for s in [-1.0, 1.0]:
			var x0 := -40.0 if s < 0 else 4.0
			_p([o.call(x0, -26), o.call(x0 + 34, -26), o.call(x0 + 48, -8), o.call(x0 + 46, 0), o.call(x0, 0)], Color(0.97, 0.97, 0.95))
			draw_line(o.call(x0 + 4, -8), o.call(x0 + 44, -8), Color(0.85, 0.15, 0.2), 5.0)
		# Loud shirt under an open leather jacket.
		_p([o.call(-46, -310), o.call(46, -310), o.call(40, -160), o.call(-40, -160)], Color(0.95, 0.4, 0.3))
		for k in 9:
			_o(o.call(-28 + (k % 3) * 28, -290 + (k / 3) * 44), 7.0, Color(0.25, 0.8, 0.85), Color(0, 0, 0, 0), 0.0)
			_o(o.call(-18 + (k % 3) * 28, -276 + (k / 3) * 44), 4.0, Color(1, 0.9, 0.4), Color(0, 0, 0, 0), 0.0)
		_p([o.call(-50, -312), o.call(-14, -312), o.call(-22, -150), o.call(-46, -150)], jacket)
		_p([o.call(14, -312), o.call(50, -312), o.call(46, -150), o.call(22, -150)], jacket)
		draw_line(o.call(-14, -312), o.call(-22, -150), Color(0.5, 0.22, 0.18), 3.0)
		draw_line(o.call(14, -312), o.call(22, -150), Color(0.5, 0.22, 0.18), 3.0)
		# Gold chain.
		for k in 9:
			var ang := PI * (0.12 + 0.76 * float(k) / 8.0)
			_o(o.call(cos(ang) * 22.0, -312 + sin(ang) * 30.0), 4.0, Color(1, 0.82, 0.3), Color(0.4, 0.25, 0.05), 1.5)
		# Arms: one thumb-in-pocket, one finger-gun.
		_p([o.call(-50, -306), o.call(-30, -300), o.call(-34, -200), o.call(-56, -204)], jacket)
		_o(o.call(-46, -196), 12.0, skin)
		_p([o.call(50, -306), o.call(32, -298), o.call(70, -250), o.call(84, -264)], jacket)
		_p([o.call(78, -270), o.call(112, -278), o.call(112, -268), o.call(84, -256)], skin)
		_o(o.call(82, -262), 11.0, skin)
		# Big head: jaw, grin with a gold tooth, eyebrows, sunglasses up on the hair.
		_p([o.call(-36, -330), o.call(36, -330), o.call(42, -380), o.call(32, -420), o.call(-32, -420), o.call(-42, -380)], skin)
		_p([o.call(-30, -332), o.call(30, -332), o.call(36, -350), o.call(-36, -350)], skin_sh, Color(0, 0, 0, 0), 0.0)
		draw_arc(o.call(4, -360), 20.0, 0.25, PI - 0.25, 16, Color(0.4, 0.08, 0.1), 4.0)
		draw_rect(Rect2(o.call(-4, -344), Vector2(9, 8)), Color(1.0, 0.82, 0.3))
		for ex in [-14.0, 16.0]:
			_o(o.call(ex, -384), 6.0, Color(1, 1, 1), Color(0.03, 0.02, 0.05), 2.0)
			_o(o.call(ex + 2.0, -384), 3.0, Color(0.15, 0.1, 0.1), Color(0, 0, 0, 0), 0.0)
			draw_line(o.call(ex - 9, -398), o.call(ex + 9, -400 + (ex * 0.2)), Color(0.15, 0.08, 0.05), 4.0)
		# Pompadour.
		_p([o.call(-42, -404), o.call(-36, -444), o.call(-6, -470), o.call(40, -466), o.call(56, -446), o.call(38, -440), o.call(42, -418), o.call(30, -420), o.call(-28, -424)], Color(0.12, 0.07, 0.05))
		draw_line(o.call(-20, -450), o.call(40, -456), Color(0.35, 0.22, 0.15), 4.0)
		_p([o.call(-30, -430), o.call(30, -432), o.call(28, -420), o.call(-28, -418)], Color(0.1, 0.1, 0.12))
		_p([o.call(-26, -428), o.call(-4, -428), o.call(-6, -420), o.call(-24, -420)], Color(0.95, 0.75, 0.2), Color(0, 0, 0, 0), 0.0)
		_p([o.call(4, -428), o.call(26, -428), o.call(24, -420), o.call(6, -420)], Color(0.95, 0.75, 0.2), Color(0, 0, 0, 0), 0.0)

	# ------------------------------------------------------------ C: The Runner
	func _runner(f: Vector2) -> void:
		var suit := Color(0.1, 0.11, 0.16)
		var neon := Color(0.25, 0.95, 1.0)
		var neon2 := Color(1.0, 0.3, 0.65)
		var glow := 0.75 + 0.25 * sin(t * 3.0)
		var o := func(x: float, y: float) -> Vector2: return f + Vector2(x, y)
		# Legs in a running stance, glowing piping down the sides.
		_p([o.call(-34, -170), o.call(-10, -170), o.call(-40, -22), o.call(-60, -26)], suit)
		_p([o.call(4, -170), o.call(28, -170), o.call(44, -30), o.call(22, -24)], suit)
		draw_line(o.call(-12, -168), o.call(-42, -26), Color(neon, glow), 3.0)
		draw_line(o.call(26, -168), o.call(42, -32), Color(neon, glow), 3.0)
		_p([o.call(-74, -30), o.call(-36, -30), o.call(-30, -8), o.call(-78, -10)], Color(0.95, 0.95, 0.98))
		_p([o.call(18, -32), o.call(52, -32), o.call(66, -12), o.call(20, -10)], Color(0.95, 0.95, 0.98))
		draw_line(o.call(-74, -12), o.call(-32, -12), Color(neon2, glow), 4.0)
		draw_line(o.call(20, -14), o.call(64, -14), Color(neon2, glow), 4.0)
		# Chip belt.
		draw_rect(Rect2(o.call(-44, -182), Vector2(88, 14)), Color(0.05, 0.05, 0.07))
		for k in 5:
			_o(o.call(-32 + k * 16, -175), 6.0, [Color(0.85, 0.12, 0.18), Color(0.1, 0.55, 0.3), Color(0.15, 0.15, 0.18)][k % 3], Color(0, 0, 0, 0.8), 1.5)
		# Tracksuit top.
		_p([o.call(-46, -320), o.call(46, -320), o.call(44, -180), o.call(-44, -180)], suit)
		draw_line(o.call(0, -318), o.call(0, -184), Color(0.3, 0.3, 0.38), 3.0)
		draw_line(o.call(-44, -316), o.call(-42, -186), Color(neon, glow), 3.0)
		draw_line(o.call(44, -316), o.call(42, -186), Color(neon, glow), 3.0)
		# Arms pumping.
		_p([o.call(-46, -314), o.call(-28, -306), o.call(-60, -238), o.call(-76, -250)], suit)
		_o(o.call(-72, -238), 11.0, Color(0.12, 0.12, 0.16))
		_p([o.call(46, -314), o.call(28, -306), o.call(70, -270), o.call(82, -286)], suit)
		_o(o.call(80, -276), 11.0, Color(0.12, 0.12, 0.16))
		# Hood and LED visor with $ $ eyes.
		_p([o.call(-46, -318), o.call(46, -318), o.call(50, -380), o.call(30, -430), o.call(-30, -430), o.call(-50, -380)], suit)
		_p([o.call(-30, -394), o.call(36, -394), o.call(32, -360), o.call(-26, -360)], Color(0.02, 0.02, 0.04))
		for g in 4:
			draw_rect(Rect2(o.call(-30 - g * 2, -394 - g * 2), Vector2(66 + g * 4, 34 + g * 4)), Color(neon, 0.04 * glow), false, 2.0)
		draw_string(font, o.call(-22, -368), "$  $", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color(neon, glow))
		draw_line(o.call(-44, -380), o.call(-28, -428), Color(neon2, glow), 3.0)


func _initialize() -> void:
	canvas = Sheet.new()
	root.add_child(canvas)


func _process(_d: float) -> bool:
	frame += 1
	if frame == 8:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/rico_concepts.png")
		print("saved rico_concepts.png")
		return true
	return false
