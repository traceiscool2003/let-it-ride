extends RefCounted
## The title screen: "The Climb". Rico on a rain-soaked rooftop in Atlantic Shitty,
## staring across a grimy city at the Vegas Strip glowing on the horizon. That's
## the whole game in one picture: from a dumpster to the Strip.
## draw_scene() paints the world, draw_logo() the 3D neon logo with its slam-in.
## `tt` is seconds since the title screen appeared (drives the intro).

const Scenery := preload("res://scripts/scenery.gd")

const HORIZON := 430.0
const ROOF_Y := 560.0
const RICO_AT := Vector2(960, ROOF_Y - 6)


static func draw_scene(ci: CanvasItem, f: Font, t: float, tt: float) -> void:
	var flash := _lightning(t)
	_sky(ci, t, flash)
	_strip(ci, f, t)
	_city(ci, t, flash)
	_neon_signs(ci, f, t)
	_rooftop(ci, t, flash)
	_rico(ci, RICO_AT, t)
	_rain(ci, t)
	_finish(ci, t, tt, flash)


# ---------------------------------------------------------------- sky

static func _lightning(t: float) -> float:
	# A double flash every ~9 seconds.
	var k := fmod(t, 9.0)
	if k > 6.0 and k < 6.08:
		return 1.0
	if k > 6.16 and k < 6.22:
		return 0.6
	return 0.0


static func _sky(ci: CanvasItem, t: float, flash: float) -> void:
	Scenery.vgrad(ci, Rect2(0, 0, 1280, HORIZON + 20), [
		[0.0, Color(0.02, 0.02, 0.05)], [0.45, Color(0.07, 0.04, 0.12)], [0.8, Color(0.28, 0.12, 0.2)], [1.0, Color(0.6, 0.32, 0.22)]])
	# Heavy storm clouds, slowly rolling.
	for i in 9:
		var cx := fposmod(Scenery.rnd(i * 7) * 1700.0 + t * (4.0 + i * 0.8), 1800.0) - 250.0
		var cy := 40.0 + Scenery.rnd(i * 7 + 1) * 230.0
		for j in 6:
			var o := Vector2(cx + j * 55.0 - 140.0, cy + sin(j * 1.3 + i) * 12.0)
			Scenery.glow(ci, o, 90.0 + Scenery.rnd(i * 13 + j) * 50.0, 30.0 + Scenery.rnd(i * 5 + j) * 14.0, Color(0.04, 0.03, 0.07, 0.55))
	if flash > 0.0:
		ci.draw_rect(Rect2(0, 0, 1280, HORIZON), Color(0.75, 0.75, 1.0, 0.25 * flash))
		# The bolt itself, far off to the left.
		var p := Vector2(220, 0)
		var pts := PackedVector2Array([p])
		for s in 9:
			p += Vector2(Scenery.rnd(s * 3 + int(t / 9.0)) * 40.0 - 20.0, 42.0)
			pts.append(p)
		ci.draw_polyline(pts, Color(0.9, 0.9, 1.0, flash), 2.5)
		ci.draw_polyline(pts, Color(0.6, 0.6, 1.0, 0.3 * flash), 9.0)


# ---------------------------------------------------------------- the Strip (the goal)

static func _strip(ci: CanvasItem, f: Font, t: float) -> void:
	var base := HORIZON
	# Warm gold glow of Vegas on the horizon.
	Scenery.glow(ci, Vector2(1060, base), 420.0, 120.0, Color(1.0, 0.7, 0.3, 0.35))
	Scenery.glow(ci, Vector2(1060, base - 40), 220.0, 160.0, Color(1.0, 0.55, 0.3, 0.18))
	# Searchlights sweeping up into the storm.
	for s in 4:
		var ang := -PI * 0.5 + sin(t * 0.5 + s * 1.7) * 0.42
		Scenery.beam(ci, Vector2(900 + s * 95, base - 10), ang, 560, 38, Color(1.0, 0.92, 0.7, 0.08))
	# Far skyline of luxury towers.
	var towers := [[860, 90, 34], [900, 140, 30], [945, 110, 40], [992, 210, 46], [1046, 150, 36], [1090, 260, 42], [1140, 175, 38], [1186, 120, 44], [1236, 95, 40]]
	for tw in towers:
		var x: float = tw[0]
		var h: float = tw[1]
		var w: float = tw[2]
		ci.draw_rect(Rect2(x, base - h, w, h), Color(0.16, 0.1, 0.16))
		for r in int(h / 9.0):
			if (r + int(x)) % 3 != 0:
				ci.draw_rect(Rect2(x + 4, base - h + 5 + r * 9, w - 8, 2), Color(1.0, 0.8, 0.45, 0.35))
	# The Bellagiro: the tallest tower, with a crown light that pulses.
	var bx := 1090.0
	ci.draw_rect(Rect2(bx + 14, base - 300, 14, 40), Color(0.2, 0.13, 0.18))
	var pulse := 0.6 + 0.4 * sin(t * 2.2)
	Scenery.glow(ci, Vector2(bx + 21, base - 300), 40.0, 40.0, Color(1.0, 0.85, 0.4, 0.5 * pulse))
	ci.draw_circle(Vector2(bx + 21, base - 300), 4.0, Color(1, 0.95, 0.8))
	# Fountain spray catching the light at its feet.
	for k in 7:
		var h := 30.0 + 22.0 * absf(sin(t * 1.4 + k * 0.7))
		ci.draw_line(Vector2(bx - 30 + k * 16, base), Vector2(bx - 30 + k * 16, base - h), Color(0.8, 0.9, 1.0, 0.35), 2.0)


# ---------------------------------------------------------------- the grimy city between

static func _city(ci: CanvasItem, t: float, flash: float) -> void:
	# Mid layer: Atlantic Shitty's rundown blocks, lit by a few failing windows.
	Scenery.skyline(ci, 505.0, 41, Color(0.08, 0.06, 0.09), Color(1.0, 0.75, 0.4, 0.5), 40.0, 120.0, t)
	Scenery.vgrad(ci, Rect2(0, HORIZON - 10, 1280, 90), [[0.0, Color(0.45, 0.25, 0.25, 0.25)], [1.0, Color(0.0, 0.0, 0.0, 0.0)]])
	# A water tower and smokestack silhouettes.
	ci.draw_rect(Rect2(740, 350, 6, 90), Color(0.06, 0.05, 0.07))
	ci.draw_rect(Rect2(702, 320, 80, 36), Color(0.07, 0.06, 0.08))
	ci.draw_colored_polygon(PackedVector2Array([Vector2(698, 320), Vector2(742, 298), Vector2(786, 320)]), Color(0.07, 0.06, 0.08))
	for s in 2:
		var sx := 820.0 + s * 60.0
		ci.draw_rect(Rect2(sx, 300, 16, 140), Color(0.07, 0.06, 0.08))
		for p in 5:
			var k := fmod(t * 0.25 + p * 0.2 + s * 0.1, 1.0)
			Scenery.glow(ci, Vector2(sx + 8 + k * 50.0, 296 - k * 110.0), 14 + k * 30.0, 10 + k * 22.0, Color(0.3, 0.27, 0.3, 0.28 * (1.0 - k)))
	if flash > 0.0:
		ci.draw_rect(Rect2(0, HORIZON - 120, 1280, 200), Color(0.6, 0.6, 0.8, 0.08 * flash))


static func _neon_signs(ci: CanvasItem, f: Font, t: float) -> void:
	# Flickering neon on the near buildings.
	var signs := [["PAWN", Vector2(760, 500), Color(1.0, 0.3, 0.5), 3.1], ["LIQUOR", Vector2(640, 478), Color(0.3, 0.9, 1.0), 5.3], ["BAIL BONDZ", Vector2(1040, 452), Color(1.0, 0.75, 0.2), 7.7]]
	for sg in signs:
		var p: Vector2 = sg[1]
		var col: Color = sg[2]
		var on := 1.0
		var ph: float = sg[3]
		if sin(t * ph) > 0.93 or (fmod(t + ph, 6.0) < 0.15):
			on = 0.15
		var w := f.get_string_size(String(sg[0]), HORIZONTAL_ALIGNMENT_LEFT, -1, 22).x
		Scenery.glow(ci, p + Vector2(w * 0.5, -8), w * 0.9, 26.0, Color(col, 0.25 * on))
		ci.draw_string_outline(f, p, String(sg[0]), HORIZONTAL_ALIGNMENT_LEFT, -1, 22, 5, Color(col, 0.35 * on))
		ci.draw_string(f, p, String(sg[0]), HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(col.lightened(0.5), on))


# ---------------------------------------------------------------- the rooftop

static func _rooftop(ci: CanvasItem, t: float, flash: float) -> void:
	# Building face below the ledge, then the wet roof.
	ci.draw_rect(Rect2(560, ROOF_Y, 720, 160), Color(0.05, 0.04, 0.06))
	ci.draw_rect(Rect2(0, ROOF_Y + 24, 1280, 136), Color(0.04, 0.035, 0.05))
	ci.draw_rect(Rect2(560, ROOF_Y - 6, 720, 8), Color(0.13, 0.11, 0.13))     # parapet ledge
	ci.draw_rect(Rect2(560, ROOF_Y - 6, 720, 2), Color(0.35, 0.3, 0.35, 0.6)) # wet highlight on the ledge
	# AC unit with a steam plume, an antenna and a satellite dish.
	ci.draw_rect(Rect2(1150, ROOF_Y - 48, 74, 42), Color(0.1, 0.09, 0.11))
	for v in 6:
		ci.draw_line(Vector2(1156, ROOF_Y - 42 + v * 6), Vector2(1218, ROOF_Y - 42 + v * 6), Color(0.05, 0.05, 0.06), 1.0)
	for p in 6:
		var k := fmod(t * 0.45 + p * 0.17, 1.0)
		Scenery.glow(ci, Vector2(1186 - k * 60.0, ROOF_Y - 52 - k * 120.0), 12 + k * 34.0, 10 + k * 26.0, Color(0.6, 0.58, 0.66, 0.22 * (1.0 - k)))
	ci.draw_line(Vector2(640, ROOF_Y - 6), Vector2(640, ROOF_Y - 120), Color(0.08, 0.07, 0.09), 3.0)
	ci.draw_line(Vector2(628, ROOF_Y - 100), Vector2(652, ROOF_Y - 100), Color(0.08, 0.07, 0.09), 2.0)
	ci.draw_circle(Vector2(640, ROOF_Y - 122), 3.0, Color(1.0, 0.2, 0.2, 0.6 + 0.4 * sin(t * 3.0)))
	# Puddles reflecting the Strip's gold and the neon.
	for pd in [[700.0, 96.0], [980.0, 140.0], [1210.0, 60.0]]:
		var px: float = pd[0]
		var pw: float = pd[1]
		ci.draw_rect(Rect2(px, ROOF_Y + 40, pw, 6), Color(0.15, 0.12, 0.18, 0.8))
		ci.draw_rect(Rect2(px + pw * 0.3, ROOF_Y + 41, pw * 0.25, 3), Color(1.0, 0.75, 0.4, 0.25 + 0.1 * sin(t * 2.0 + px)))
		var rr := fmod(t * 1.3 + px * 0.01, 1.0)
		ci.draw_arc(Vector2(px + pw * 0.5, ROOF_Y + 43), 4.0 + rr * 16.0, PI, TAU, 12, Color(1, 1, 1, 0.25 * (1.0 - rr)), 1.0)
	# A few lost chips and a card on the roof.
	Scenery.chip(ci, Vector2(1040, ROOF_Y + 18), 7.0, Color(0.85, 0.12, 0.18), 0.0, 0.35)
	Scenery.chip(ci, Vector2(1056, ROOF_Y + 22), 7.0, Color(0.1, 0.55, 0.3), 0.0, 0.35)
	Scenery.chip(ci, Vector2(760, ROOF_Y + 26), 7.0, Color(0.12, 0.12, 0.14), 0.0, 0.35)
	if flash > 0.0:
		ci.draw_rect(Rect2(0, ROOF_Y - 10, 1280, 170), Color(0.7, 0.7, 0.9, 0.06 * flash))


## Rico from behind, hood up, hands in his pockets, scarf whipping in the wind,
## staring at the Strip. Rim-lit gold from the horizon on his right side.
static func _rico(ci: CanvasItem, feet: Vector2, t: float) -> void:
	var breath := sin(t * 1.6) * 0.8
	var dark := Color(0.035, 0.03, 0.05)
	var cloth := Color(0.09, 0.07, 0.12)
	var rim := Color(1.0, 0.72, 0.38, 0.95)
	var M := Transform2D(0.0, Vector2(2.4, 2.4), 0.0, feet)
	ci.draw_set_transform_matrix(M)
	# Ground shadow and the reflection in the wet roof.
	Scenery.glow(ci, Vector2(0, 1), 22.0, 3.0, Color(0, 0, 0, 0.6))
	# Legs: jeans, slightly apart, weight on one hip.
	ci.draw_colored_polygon(PackedVector2Array([Vector2(-8, 0), Vector2(-3, 0), Vector2(-1, -30), Vector2(-9, -30)]), dark)
	ci.draw_colored_polygon(PackedVector2Array([Vector2(3, 0), Vector2(8, 0), Vector2(9, -30), Vector2(1, -30)]), dark)
	ci.draw_rect(Rect2(-9, -2, 7, 2), Color(0.18, 0.14, 0.16))   # sneaker soles
	ci.draw_rect(Rect2(2, -2, 7, 2), Color(0.18, 0.14, 0.16))
	# Hoodie: hem, torso widening to the shoulders.
	var by := -breath
	var torso := PackedVector2Array([Vector2(-11, -27), Vector2(11, -27), Vector2(13, -46 + by), Vector2(15, -56 + by), Vector2(11, -62 + by),
		Vector2(-11, -62 + by), Vector2(-15, -56 + by), Vector2(-13, -46 + by)])
	ci.draw_colored_polygon(torso, cloth)
	# Arms down, hands in the hoodie pocket.
	ci.draw_colored_polygon(PackedVector2Array([Vector2(-15, -56 + by), Vector2(-11, -58 + by), Vector2(-9, -36), Vector2(-14, -34)]), dark)
	ci.draw_colored_polygon(PackedVector2Array([Vector2(15, -56 + by), Vector2(11, -58 + by), Vector2(9, -36), Vector2(14, -34)]), dark)
	ci.draw_rect(Rect2(-10, -34, 20, 5), Color(0.06, 0.05, 0.08))   # waistband
	# Hood up, with the drawstring tips just visible.
	var hood := PackedVector2Array([Vector2(-9, -61 + by), Vector2(9, -61 + by), Vector2(10, -70 + by), Vector2(8, -78 + by), Vector2(3, -82 + by),
		Vector2(-3, -82 + by), Vector2(-8, -78 + by), Vector2(-10, -70 + by)])
	ci.draw_colored_polygon(hood, cloth)
	ci.draw_polyline(PackedVector2Array([Vector2(-4, -80 + by), Vector2(-1, -66 + by)]), Color(0.02, 0.02, 0.03), 1.0)
	# Gold rim light down his right side: hood, shoulder, arm, leg.
	ci.draw_polyline(PackedVector2Array([Vector2(3, -82 + by), Vector2(8, -78 + by), Vector2(10, -70 + by), Vector2(11, -62 + by), Vector2(15, -56 + by),
		Vector2(14, -34), Vector2(11, -27), Vector2(9, -30), Vector2(8, 0)]), rim, 0.9)
	Scenery.glow(ci, Vector2(12, -50), 6.0, 22.0, Color(1.0, 0.7, 0.4, 0.12))
	# Scarf: two red tails streaming back in the wind, tapering to the tips.
	for tail in 2:
		var root := Vector2(-6, -62 + by)
		var tl := 34.0 if tail == 0 else 26.0
		var top := PackedVector2Array()
		var bot := PackedVector2Array()
		for k in 10:
			var kk := float(k) / 9.0
			var wave := sin(t * 7.0 - kk * 5.0 + tail * 1.3) * 4.0 * kk
			var c := root + Vector2(-kk * tl, kk * (4.0 + tail * 5.0) + wave)
			var w := lerpf(2.6, 0.6, kk)
			top.append(c + Vector2(0, -w))
			bot.append(c + Vector2(0, w))
		bot.reverse()
		var poly := top + bot
		ci.draw_colored_polygon(poly, Color(0.7, 0.07, 0.12) if tail == 0 else Color(0.55, 0.05, 0.1))
		ci.draw_polyline(top, Color(1.0, 0.35, 0.35, 0.6), 0.6)
	ci.draw_rect(Rect2(-9, -63 + by, 18, 4), Color(0.75, 0.08, 0.13))   # scarf wrapped at the neck
	ci.draw_set_transform(Vector2.ZERO)


# ---------------------------------------------------------------- weather + finish

static func _rain(ci: CanvasItem, t: float) -> void:
	for layer in 2:
		var n := 120 if layer == 0 else 60
		var spd := 900.0 if layer == 0 else 1400.0
		var ln := 14.0 if layer == 0 else 26.0
		var a := 0.18 if layer == 0 else 0.3
		for i in n:
			var x := fposmod(Scenery.rnd(i * 5 + layer * 999) * 1400.0 - t * spd * 0.22, 1400.0) - 60.0
			var y := fposmod(Scenery.rnd(i * 9 + 3 + layer * 777) * 760.0 + t * spd, 760.0) - 20.0
			ci.draw_line(Vector2(x, y), Vector2(x - ln * 0.25, y + ln), Color(0.75, 0.8, 0.95, a), 1.0 + layer)


static func _finish(ci: CanvasItem, t: float, tt: float, flash: float) -> void:
	# Left-side shade so the menu reads, vignette, letterbox, grain.
	Scenery.hgrad(ci, Rect2(0, 0, 700, 720), Color(0.01, 0.005, 0.02, 0.9), Color(0.01, 0.005, 0.02, 0.0))
	Scenery.hgrad(ci, Rect2(1080, 0, 200, 720), Color(0, 0, 0, 0.0), Color(0, 0, 0, 0.45))
	Scenery.vgrad(ci, Rect2(0, 600, 1280, 120), [[0.0, Color(0, 0, 0, 0.0)], [1.0, Color(0, 0, 0, 0.8)]])
	ci.draw_rect(Rect2(0, 0, 1280, 18), Color(0, 0, 0))
	ci.draw_rect(Rect2(0, 702, 1280, 18), Color(0, 0, 0))
	var seed := int(t * 24.0)
	for i in 260:
		ci.draw_rect(Rect2(Scenery.rnd(seed * 977 + i * 3) * 1280.0, Scenery.rnd(seed * 571 + i * 7) * 720.0, 1, 1), Color(1, 1, 1, 0.05))
	# Fade in from black on boot.
	var fade := 1.0 - clampf(tt / 1.2, 0.0, 1.0)
	if fade > 0.0:
		ci.draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, fade))


# ---------------------------------------------------------------- the logo

## Big extruded gold logo with a neon outline. Slams in at ~0.9s with a flash,
## then idles with a slow glow pulse and a light sweep every few seconds.
static func draw_logo(ci: CanvasItem, f: Font, at: Vector2, t: float, tt: float) -> void:
	var k := clampf((tt - 0.7) / 0.35, 0.0, 1.0)
	if k <= 0.0:
		return
	var sc := lerpf(1.5, 1.0, ease(k, 0.25))
	var alpha := clampf(k * 2.0, 0.0, 1.0)
	ci.draw_set_transform(at, 0.0, Vector2(sc, sc))
	# Back glow.
	var pulse := 0.85 + 0.15 * sin(t * 1.8)
	Scenery.glow(ci, Vector2(250, -30), 360.0, 110.0, Color(1.0, 0.45, 0.35, 0.22 * alpha * pulse))
	# "LET IT" sits above "RIDE".
	_logo_word(ci, f, Vector2(8, -70), "LET IT", 54, 5, alpha, t)
	_logo_word(ci, f, Vector2(0, 40), "RIDE", 128, 10, alpha, t)
	# A thin rule with diamond caps and a spinning chip.
	ci.draw_rect(Rect2(10, 64, 470, 3), Color(1.0, 0.35, 0.55, 0.9 * alpha))
	for dx in [6.0, 484.0]:
		ci.draw_colored_polygon(PackedVector2Array([Vector2(dx, 58), Vector2(dx + 7, 65.5), Vector2(dx, 73), Vector2(dx - 7, 65.5)]), Color(1.0, 0.8, 0.3, alpha))
	Scenery.chip(ci, Vector2(445, -88), 16.0, Color(0.85, 0.12, 0.18), 0.0, maxf(0.15, absf(cos(t * 2.4))))
	ci.draw_set_transform(Vector2.ZERO)
	# Impact flash when it lands.
	var fl := 1.0 - clampf((tt - 1.05) / 0.35, 0.0, 1.0)
	if tt > 1.0 and fl > 0.0:
		ci.draw_rect(Rect2(0, 0, 1280, 720), Color(1.0, 0.9, 0.75, 0.35 * fl))


static func _logo_word(ci: CanvasItem, f: Font, p: Vector2, s: String, size: int, depth: int, alpha: float, t: float) -> void:
	# Extruded side, darkening as it goes back.
	for d in range(depth, 0, -1):
		var kd := float(d) / depth
		ci.draw_string(f, p + Vector2(d * 0.6, d), s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, Color(0.35 - 0.25 * kd, 0.08, 0.06, alpha))
	# Neon outline glow, then a dark crisp outline.
	ci.draw_string_outline(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, 18, Color(1.0, 0.3, 0.5, 0.12 * alpha))
	ci.draw_string_outline(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, 9, Color(1.0, 0.35, 0.55, 0.35 * alpha))
	ci.draw_string_outline(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, 4, Color(0.25, 0.04, 0.05, alpha))
	# Gold face with a bevel: dark lower edge, bright upper edge.
	ci.draw_string(f, p + Vector2(0, 2), s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, Color(0.75, 0.42, 0.1, alpha))
	ci.draw_string(f, p, s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, Color(1.0, 0.78, 0.28, alpha))
	ci.draw_string(f, p + Vector2(0, -2), s, HORIZONTAL_ALIGNMENT_LEFT, -1, size, Color(1.0, 0.95, 0.7, 0.35 * alpha))
	# A light sweep glints across every 5 seconds.
	var sweep := fmod(t, 5.0) / 0.8
	if sweep < 1.0:
		var w := f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
		var sx := p.x + sweep * (w + 80.0) - 40.0
		Scenery.glow(ci, Vector2(sx, p.y - size * 0.35), 26.0, size * 0.5, Color(1, 1, 0.9, 0.35 * alpha * sin(sweep * PI)))
