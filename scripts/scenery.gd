extends RefCounted
## Painted scenes, drawn in code at full screen (1280x720):
## - the animated title screen: night city, the casino tower, a roulette-wheel
##   moon, searchlights, and The Pit glowing in the street
## - the loading-screen illustrations: the Lobby, the three zones, and a stage
##   for each boss
## - the slot-reel "BUST" wipe used for the death and respawn transition

const Art := preload("res://scripts/art.gd")
const GOLD := Color(1.0, 0.78, 0.25)


# ================================================================ helpers

## Stable pseudo-random number in [0, 1) for index i.
static func rnd(i: int) -> float:
	return fposmod(sin(float(i) * 12.9898 + 78.233) * 43758.5453, 1.0)


## Vertical gradient through color stops: [[0.0, Color], [0.5, Color], ...].
static func vgrad(ci: CanvasItem, r: Rect2, stops: Array) -> void:
	for i in stops.size() - 1:
		var y0: float = r.position.y + r.size.y * float(stops[i][0])
		var y1: float = r.position.y + r.size.y * float(stops[i + 1][0])
		var c0: Color = stops[i][1]
		var c1: Color = stops[i + 1][1]
		ci.draw_polygon(PackedVector2Array([Vector2(r.position.x, y0), Vector2(r.end.x, y0), Vector2(r.end.x, y1), Vector2(r.position.x, y1)]), PackedColorArray([c0, c0, c1, c1]))


static func hgrad(ci: CanvasItem, r: Rect2, c0: Color, c1: Color) -> void:
	ci.draw_polygon(PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)]), PackedColorArray([c0, c1, c1, c0]))


## Soft radial glow: full color at the center fading to clear at the rim.
static func glow(ci: CanvasItem, c: Vector2, rx: float, ry: float, col: Color, n := 28) -> void:
	var edge := Color(col, 0.0)
	var prev := c + Vector2(rx, 0)
	for i in n:
		var a := TAU * float(i + 1) / n
		var p := c + Vector2(cos(a) * rx, sin(a) * ry)
		ci.draw_polygon(PackedVector2Array([c, prev, p]), PackedColorArray([col, edge, edge]))
		prev = p


## A light beam fading out along its length.
static func beam(ci: CanvasItem, from: Vector2, ang: float, length: float, width: float, col: Color) -> void:
	var d := Vector2.from_angle(ang)
	var n := d.orthogonal()
	var far := from + d * length
	ci.draw_polygon(PackedVector2Array([from - n * 4.0, from + n * 4.0, far + n * width, far - n * width]), PackedColorArray([col, col, Color(col, 0.0), Color(col, 0.0)]))


static func quad(ci: CanvasItem, a: Vector2, b: Vector2, c: Vector2, d: Vector2, col: Color) -> void:
	ci.draw_colored_polygon(PackedVector2Array([a, b, c, d]), col)


## Text with a neon glow, centered in `width`.
static func neon_text(ci: CanvasItem, f: Font, pos: Vector2, s: String, sz: int, col: Color, width: float, flick := 1.0) -> void:
	ci.draw_string_outline(f, pos, s, HORIZONTAL_ALIGNMENT_CENTER, width, sz, maxi(8, sz / 3), Color(col, 0.18 * flick))
	ci.draw_string_outline(f, pos, s, HORIZONTAL_ALIGNMENT_CENTER, width, sz, maxi(3, sz / 10), Color(col, 0.55 * flick))
	ci.draw_string(f, pos, s, HORIZONTAL_ALIGNMENT_CENTER, width, sz, Color(col.lightened(0.6), flick))


static func chip(ci: CanvasItem, c: Vector2, r: float, col: Color, rot := 0.0, squash := 1.0) -> void:
	ci.draw_set_transform(c, rot, Vector2(1.0, squash))
	ci.draw_circle(Vector2.ZERO, r, col.darkened(0.35))
	ci.draw_circle(Vector2.ZERO, r * 0.92, col)
	for i in 6:
		var a := TAU * i / 6.0
		var p := Vector2.from_angle(a) * r * 0.78
		ci.draw_rect(Rect2(p - Vector2(r * 0.13, r * 0.13), Vector2(r * 0.26, r * 0.26)), Color(1, 1, 1, 0.85))
	ci.draw_circle(Vector2.ZERO, r * 0.55, col.lightened(0.15))
	ci.draw_arc(Vector2.ZERO, r * 0.55, 0, TAU, 16, Color(1, 1, 1, 0.5), maxf(1.0, r * 0.08))
	ci.draw_set_transform(Vector2.ZERO)


static func card(ci: CanvasItem, f: Font, c: Vector2, w: float, rot: float, flip: float, rank: String, red: bool) -> void:
	var h := w * 1.42
	ci.draw_set_transform(c, rot, Vector2(absf(flip), 1.0))
	var r := Rect2(-w * 0.5, -h * 0.5, w, h)
	ci.draw_rect(r.grow(1.0), Color(0.05, 0.02, 0.05, 0.7))
	if flip >= 0.0:
		ci.draw_rect(r, Color(0.98, 0.96, 0.92))
		var col := Color(0.82, 0.08, 0.14) if red else Color(0.08, 0.06, 0.1)
		ci.draw_string(f, Vector2(-w * 0.42, -h * 0.18), rank, HORIZONTAL_ALIGNMENT_LEFT, -1, int(w * 0.42), col)
		if red:
			ci.draw_colored_polygon(PackedVector2Array([Vector2(0, -w * 0.05), Vector2(w * 0.2, h * 0.12), Vector2(0, h * 0.3), Vector2(-w * 0.2, h * 0.12)]), col)
		else:
			ci.draw_circle(Vector2(-w * 0.09, h * 0.12), w * 0.11, col)
			ci.draw_circle(Vector2(w * 0.09, h * 0.12), w * 0.11, col)
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-w * 0.2, h * 0.1), Vector2(w * 0.2, h * 0.1), Vector2(0, -h * 0.08)]), col)
			ci.draw_rect(Rect2(-w * 0.03, h * 0.12, w * 0.06, h * 0.16), col)
	else:
		ci.draw_rect(r, Color(0.62, 0.07, 0.15))
		ci.draw_rect(r.grow(-w * 0.12), Color(0.9, 0.7, 0.3), false, maxf(1.0, w * 0.05))
		ci.draw_colored_polygon(PackedVector2Array([Vector2(0, -h * 0.22), Vector2(w * 0.2, 0), Vector2(0, h * 0.22), Vector2(-w * 0.2, 0)]), Color(0.9, 0.7, 0.3))
	ci.draw_set_transform(Vector2.ZERO)


## A city skyline: rectangles with lit windows. `seed` picks the layout.
static func skyline(ci: CanvasItem, base_y: float, seed: int, col: Color, win: Color, min_h: float, max_h: float, t: float) -> void:
	var x := -20.0
	var i := 0
	while x < 1300.0:
		var w := 34.0 + rnd(seed + i * 3) * 70.0
		var hh := min_h + rnd(seed + i * 3 + 1) * (max_h - min_h)
		var top := base_y - hh
		ci.draw_rect(Rect2(x, top, w, hh + 400), col)
		# Roof details: antenna, water tower or stepped top.
		var kind := int(rnd(seed + i * 7) * 4.0)
		if kind == 0:
			ci.draw_line(Vector2(x + w * 0.5, top), Vector2(x + w * 0.5, top - 26), col, 2.0)
			if int(t * 1.5 + i) % 3 == 0:
				ci.draw_circle(Vector2(x + w * 0.5, top - 27), 2.2, Color(1, 0.2, 0.2, 0.9))
		elif kind == 1:
			ci.draw_rect(Rect2(x + w * 0.2, top - 16, w * 0.3, 12), col)
			ci.draw_line(Vector2(x + w * 0.24, top - 4), Vector2(x + w * 0.24, top), col, 2.0)
			ci.draw_line(Vector2(x + w * 0.46, top - 4), Vector2(x + w * 0.46, top), col, 2.0)
		elif kind == 2:
			ci.draw_rect(Rect2(x + w * 0.15, top - 12, w * 0.7, 12), col)
		# Windows.
		var cols := int(w / 9.0)
		var rows := int(hh / 12.0)
		for r in rows:
			for c in cols:
				var k := seed * 31 + i * 977 + r * 59 + c * 13
				var lit := rnd(k)
				if lit > 0.62:
					var fl := 1.0
					if lit > 0.97:
						fl = 0.4 + 0.6 * float(int(t * 0.7 + rnd(k + 1) * 9.0) % 2)
					ci.draw_rect(Rect2(x + 4 + c * 9.0, top + 7 + r * 12.0, 4, 5), Color(win, win.a * fl * (0.55 + 0.45 * rnd(k + 2))))
		x += w + 2.0 + rnd(seed + i * 3 + 2) * 10.0
		i += 1


# ================================================================ title

static func title(ci: CanvasItem, f: Font, t: float) -> void:
	# Night sky over the city.
	vgrad(ci, Rect2(0, 0, 1280, 720), [
		[0.0, Color(0.02, 0.01, 0.06)], [0.3, Color(0.09, 0.02, 0.17)],
		[0.55, Color(0.3, 0.05, 0.25)], [0.7, Color(0.7, 0.2, 0.3)], [0.78, Color(0.35, 0.07, 0.16)], [1.0, Color(0.05, 0.01, 0.04)]])
	for i in 110:
		var p := Vector2(rnd(i) * 1280.0, rnd(i + 500) * 380.0)
		if p.distance_to(Vector2(1110, 150)) < 140.0:
			continue
		var tw := 0.5 + 0.5 * sin(t * (0.8 + rnd(i + 900) * 3.0) + i)
		var s := 1.0 + float(rnd(i + 77) > 0.85)
		ci.draw_rect(Rect2(p, Vector2(s, s)), Color(1, 0.95, 1, (0.25 + 0.6 * rnd(i + 33)) * tw))
	_roulette_moon(ci, Vector2(1110, 150), 100.0, t)
	# Clouds drifting across the moon.
	for i in 5:
		var cx := fposmod(rnd(i + 40) * 1600.0 + t * (6.0 + i * 2.0), 1700.0) - 200.0
		var cy := 120.0 + rnd(i + 41) * 170.0
		for j in 5:
			var o := Vector2(cx + j * 38.0 - 80.0, cy + sin(j * 1.7) * 8.0)
			Art.fill(ci, Art.ell(o, 46.0 + rnd(i * 9 + j) * 30.0, 13.0 + rnd(i * 5 + j) * 6.0, 18), Color(0.13, 0.04, 0.18, 0.82))
			Art.fill(ci, Art.ell(o + Vector2(6, -6), 36.0, 5.0, 14), Color(0.6, 0.3, 0.45, 0.22))
	# Searchlights from the tower and the street.
	var tx := 850.0
	for k in 2:
		var a := -PI * 0.5 + sin(t * 0.45 + k * 2.4) * 0.6 + (k - 0.5) * 0.3
		beam(ci, Vector2(tx, 150), a, 760.0, 70.0, Color(1, 0.92, 0.75, 0.13))
	beam(ci, Vector2(150, 560), -PI * 0.5 + sin(t * 0.35) * 0.5, 700.0, 60.0, Color(1, 0.5, 0.8, 0.1))
	beam(ci, Vector2(1220, 560), -PI * 0.5 + sin(t * 0.4 + 1.3) * 0.45, 700.0, 60.0, Color(0.5, 0.85, 1, 0.1))
	# Two skyline layers.
	skyline(ci, 545.0, 11, Color(0.17, 0.05, 0.2), Color(1, 0.78, 0.5, 0.45), 70.0, 210.0, t)
	glow(ci, Vector2(tx, 380), 300.0, 330.0, Color(1, 0.3, 0.55, 0.16))
	_tower(ci, f, tx, t)
	skyline(ci, 600.0, 29, Color(0.07, 0.015, 0.09), Color(1, 0.6, 0.35, 0.6), 40.0, 150.0, t + 3.0)
	# The street, and The Pit glowing in it.
	vgrad(ci, Rect2(0, 600, 1280, 120), [[0.0, Color(0.09, 0.02, 0.09)], [1.0, Color(0.02, 0.0, 0.03)]])
	for i in 9:
		var x := 120.0 + i * 140.0
		ci.draw_line(Vector2(x, 604), Vector2(640 + (x - 640) * 2.4, 720), Color(1, 0.6, 0.4, 0.05), 2.0)
	_pit(ci, f, Vector2(985, 652), t)
	_rook_silhouette(ci, Vector2(740, 636), t, 1.0)
	# Foreground cards tumbling down.
	for i in 14:
		var sp := 30.0 + rnd(i + 200) * 40.0
		var y := fposmod(t * sp + rnd(i + 210) * 820.0, 840.0) - 60.0
		var x := rnd(i + 220) * 1280.0 + sin(t * 0.6 + i) * 50.0
		var rot := t * (0.6 + rnd(i + 230)) + i
		var flip := cos(t * (1.2 + rnd(i + 240) * 1.5) + i)
		var ranks := ["A", "K", "Q", "J", "7", "10"]
		card(ci, f, Vector2(x, y), 18.0 + rnd(i + 250) * 14.0, rot, flip, ranks[i % ranks.size()], i % 2 == 0)
	# Menu side: darken the left so text reads cleanly.
	hgrad(ci, Rect2(0, 0, 640, 720), Color(0.01, 0.0, 0.03, 0.88), Color(0.01, 0.0, 0.03, 0.0))
	vgrad(ci, Rect2(0, 620, 1280, 100), [[0.0, Color(0, 0, 0, 0.0)], [1.0, Color(0, 0, 0, 0.75)]])


static func _roulette_moon(ci: CanvasItem, mc: Vector2, r: float, t: float) -> void:
	glow(ci, mc, r * 2.8, r * 2.8, Color(1, 0.4, 0.55, 0.2))
	glow(ci, mc, r * 1.6, r * 1.6, Color(1, 0.85, 0.7, 0.28))
	ci.draw_circle(mc, r * 1.04, Color(0.45, 0.25, 0.14))
	ci.draw_circle(mc, r * 0.98, Color(0.9, 0.75, 0.5))
	var rot := t * 0.12
	var n := 37
	for i in n:
		var a0 := rot + TAU * i / n
		var a1 := rot + TAU * (i + 1) / n
		var col := Color(0.25, 0.6, 0.38) if i == 0 else (Color(0.82, 0.3, 0.33) if i % 2 == 1 else Color(0.22, 0.17, 0.24))
		quad(ci, mc + Vector2.from_angle(a0) * r * 0.62, mc + Vector2.from_angle(a0) * r * 0.94, mc + Vector2.from_angle(a1) * r * 0.94, mc + Vector2.from_angle(a1) * r * 0.62, col)
		ci.draw_line(mc + Vector2.from_angle(a0) * r * 0.62, mc + Vector2.from_angle(a0) * r * 0.94, Color(0.95, 0.85, 0.6, 0.6), 1.0)
	ci.draw_circle(mc, r * 0.62, Color(0.55, 0.34, 0.18))
	ci.draw_circle(mc, r * 0.46, Color(0.68, 0.45, 0.24))
	for i in 4:
		var a := -rot * 1.7 + i * PI * 0.5
		ci.draw_line(mc, mc + Vector2.from_angle(a) * r * 0.42, Color(1, 0.85, 0.45), 4.0)
		ci.draw_circle(mc + Vector2.from_angle(a) * r * 0.42, 4.0, Color(1, 0.9, 0.55))
	ci.draw_circle(mc, r * 0.12, Color(1, 0.88, 0.5))
	# Moonlight wash and a lit rim.
	ci.draw_circle(mc, r, Color(1, 0.93, 0.85, 0.16))
	ci.draw_arc(mc, r * 1.02, -1.6, 0.4, 28, Color(1, 0.96, 0.85, 0.7), 3.0, true)
	var ba := -t * 0.9
	var bp := mc + Vector2.from_angle(ba) * r * 0.8
	glow(ci, bp, 14.0, 14.0, Color(1, 1, 1, 0.5))
	ci.draw_circle(bp, 5.0, Color(1, 1, 0.97))


static func _tower(ci: CanvasItem, f: Font, tx: float, t: float) -> void:
	var body := Color(0.09, 0.025, 0.11)
	var pier := Color(0.13, 0.04, 0.15)
	ci.draw_rect(Rect2(tx - 92, 262, 184, 400), body)
	ci.draw_rect(Rect2(tx - 72, 214, 144, 50), body)
	ci.draw_rect(Rect2(tx - 50, 176, 100, 40), body)
	ci.draw_rect(Rect2(tx - 30, 146, 60, 32), body)
	ci.draw_colored_polygon(PackedVector2Array([Vector2(tx - 11, 146), Vector2(tx + 11, 146), Vector2(tx, 52)]), body)
	# Sunburst crown.
	for i in 9:
		var a := PI + PI * (i + 0.5) / 9.0
		ci.draw_line(Vector2(tx, 178), Vector2(tx, 178) + Vector2.from_angle(a) * 46.0, Color(1, 0.8, 0.35, 0.55), 2.0)
	# Gold setback trims.
	for s in [[92, 262], [72, 214], [50, 176], [30, 146]]:
		ci.draw_rect(Rect2(tx - s[0], s[1], s[0] * 2, 3), Color(1, 0.78, 0.35, 0.85))
	# Piers and windows.
	for c in 8:
		var x := tx - 86 + c * 22.0
		ci.draw_rect(Rect2(x, 268, 5, 400), pier)
		ci.draw_rect(Rect2(x, 268, 1, 400), Color(0.3, 0.12, 0.3, 0.6))
		for r in 22:
			var k := c * 97 + r * 13
			var lit := rnd(k + 3000)
			if lit > 0.45:
				var fl := 1.0 if lit < 0.95 else 0.4 + 0.6 * float(int(t * 0.8 + rnd(k) * 7.0) % 2)
				ci.draw_rect(Rect2(x + 8, 274 + r * 17.0, 10, 9), Color(1, 0.76, 0.42, (0.35 + 0.5 * rnd(k + 1)) * fl))
	# Neon edges.
	var pulse := 0.75 + 0.25 * sin(t * 2.0)
	for sx in [-92.0, 92.0]:
		ci.draw_line(Vector2(tx + sx, 262), Vector2(tx + sx, 660), Color(1, 0.3, 0.6, 0.25 * pulse), 8.0)
		ci.draw_line(Vector2(tx + sx, 262), Vector2(tx + sx, 660), Color(1, 0.6, 0.8, 0.9 * pulse), 2.0)
	# Beacon.
	if int(t * 1.4) % 2 == 0:
		glow(ci, Vector2(tx, 54), 26.0, 26.0, Color(1, 0.2, 0.25, 0.6))
		ci.draw_circle(Vector2(tx, 54), 4.0, Color(1, 0.5, 0.5))
	# Vertical sign: THE PIT.
	var sr := Rect2(tx + 100, 300, 46, 214)
	ci.draw_line(Vector2(tx + 92, 320), Vector2(tx + 100, 320), Color(0.3, 0.2, 0.25), 3.0)
	ci.draw_line(Vector2(tx + 92, 494), Vector2(tx + 100, 494), Color(0.3, 0.2, 0.25), 3.0)
	ci.draw_rect(sr, Color(0.18, 0.02, 0.06))
	ci.draw_rect(sr, Color(1, 0.25, 0.3, 0.9), false, 2.0)
	var letters := ["T", "H", "E", "", "P", "I", "T"]
	for i in letters.size():
		if letters[i] == "":
			continue
		var fl := 0.25 if int(t * 6.0 + i * 13) % 53 == 0 else 1.0
		neon_text(ci, f, Vector2(sr.position.x, sr.position.y + 30 + i * 29.0), letters[i], 26, Color(1, 0.3, 0.35), sr.size.x, fl)


static func _pit(ci: CanvasItem, f: Font, c: Vector2, t: float) -> void:
	# Light pouring up out of the hole.
	ci.draw_polygon(PackedVector2Array([c + Vector2(-210, 0), c + Vector2(210, 0), c + Vector2(320, -560), c + Vector2(-320, -560)]),
			PackedColorArray([Color(1, 0.55, 0.3, 0.22), Color(1, 0.55, 0.3, 0.22), Color(1, 0.5, 0.3, 0.0), Color(1, 0.5, 0.3, 0.0)]))
	glow(ci, c, 300.0, 90.0, Color(1, 0.45, 0.25, 0.35))
	Art.fill(ci, Art.ell(c, 232.0, 46.0, 40), Color(0.3, 0.09, 0.1))
	Art.fill(ci, Art.ell(c + Vector2(0, 3), 218.0, 40.0, 40), Color(0.06, 0.01, 0.03))
	glow(ci, c + Vector2(0, 8), 200.0, 34.0, Color(1, 0.62, 0.3, 0.85))
	glow(ci, c + Vector2(0, 10), 120.0, 20.0, Color(1, 0.9, 0.6, 0.9))
	var rim := PackedVector2Array()
	for i in 25:
		var a := PI * 1.04 + PI * 0.92 * i / 24.0
		rim.append(c + Vector2(cos(a) * 232.0, sin(a) * 46.0))
	ci.draw_polyline(rim, Color(1, 0.7, 0.4, 0.5), 2.0, true)
	# Chips and cards rising out of it.
	for i in 26:
		var sp := 0.08 + rnd(i + 700) * 0.1
		var p := fposmod(t * sp + rnd(i + 710), 1.0)
		var y := c.y - p * 560.0
		var spread := (rnd(i + 720) - 0.5) * 360.0 * (0.35 + p)
		var x := c.x + spread + sin(t * 1.3 + i) * 16.0
		var a := sin(p * PI)
		if i % 3 == 0:
			card(ci, f, Vector2(x, y), 14.0 + rnd(i) * 8.0, t * 1.5 + i, cos(t * 2.0 + i), ["A", "7", "K"][i % 3], i % 2 == 0)
		else:
			var cc: Color = [Color(0.85, 0.12, 0.18), Color(0.15, 0.4, 0.9), Color(0.15, 0.65, 0.3), Color(0.95, 0.75, 0.2)][i % 4]
			chip(ci, Vector2(x, y), 7.0 + rnd(i + 730) * 5.0, Color(cc, a), t * 2.0 + i, 0.4 + 0.6 * absf(cos(t * 2.0 + i)))


## Rico from behind and to the side, scarf blowing up in the pit's draft.
static func _rook_silhouette(ci: CanvasItem, feet: Vector2, t: float, sc: float) -> void:
	var k := Color(0.04, 0.01, 0.05)
	var rim := Color(1, 0.6, 0.35, 0.9)
	ci.draw_set_transform(feet, 0.0, Vector2(sc, sc))
	Art.fill(ci, Art.ell(Vector2(4, 0), 30, 5), Color(0, 0, 0, 0.45))
	# Legs.
	Art.limb(ci, Vector2(-5, -38), Vector2(-9, -18), 8.0, k)
	Art.limb(ci, Vector2(-9, -18), Vector2(-10, -2), 7.0, k)
	Art.limb(ci, Vector2(5, -38), Vector2(9, -18), 8.0, k)
	Art.limb(ci, Vector2(9, -18), Vector2(12, -2), 7.0, k)
	# Coat and hood.
	var coat := Art.pts([Vector2(-16, -34), Vector2(16, -36), Vector2(14, -72), Vector2(6, -82), Vector2(-8, -82), Vector2(-15, -70)])
	Art.fill(ci, coat, k)
	ci.draw_polyline(Art.pts([Vector2(16, -36), Vector2(14, -72), Vector2(6, -82)]), rim, 2.0, true)
	var hood := Art.ell(Vector2(0, -92), 13, 14, 18)
	Art.fill(ci, hood, k)
	ci.draw_arc(Vector2(0, -92), 13.5, -1.3, 0.9, 12, rim, 2.0, true)
	# Arm hanging, fist clenched.
	Art.limb(ci, Vector2(11, -76), Vector2(16, -56), 7.0, k)
	Art.limb(ci, Vector2(16, -56), Vector2(17, -40), 6.0, k)
	ci.draw_line(Vector2(19, -74), Vector2(20, -56), rim, 1.5, true)
	# Scarf: two tails streaming up and back.
	for tail in 2:
		var pts := PackedVector2Array()
		for i in 12:
			var u := i / 11.0
			pts.append(Vector2(-6 - u * 46.0 - tail * 6.0, -82 - u * 24.0 + sin(t * 6.0 + u * 5.0 + tail) * 6.0 * u))
		ci.draw_polyline(pts, Color(0.75, 0.08, 0.15), 6.0 - tail * 1.5, true)
	ci.draw_rect(Rect2(-10, -86, 20, 7), Color(0.75, 0.08, 0.15))
	ci.draw_set_transform(Vector2.ZERO)


# ================================================================ loading paintings

## Draws the loading illustration for `kind`:
## "lobby", "slots", "back", "vault", "deep", "boss1", "boss2", "boss3".
static func painting(ci: CanvasItem, f: Font, kind: String, t: float) -> void:
	match kind:
		"lobby":
			_paint_lobby(ci, f, t)
		"back":
			_paint_back_rooms(ci, f, t)
		"vault":
			_paint_vault(ci, f, t, false)
		"deep":
			_paint_vault(ci, f, t, true)
		"boss1", "boss2", "boss3":
			_paint_boss(ci, f, int(kind.right(1)), t)
		_:
			_paint_slot_hall(ci, f, t)
	# Film grain and a vignette over every painting.
	for i in 140:
		var p := Vector2(rnd(i + int(t * 24.0) * 7) * 1280.0, rnd(i * 3 + int(t * 24.0)) * 720.0)
		ci.draw_rect(Rect2(p, Vector2(2, 2)), Color(1, 1, 1, 0.035))
	hgrad(ci, Rect2(0, 0, 220, 720), Color(0, 0, 0, 0.55), Color(0, 0, 0, 0))
	hgrad(ci, Rect2(1060, 0, 220, 720), Color(0, 0, 0, 0), Color(0, 0, 0, 0.55))
	vgrad(ci, Rect2(0, 0, 1280, 140), [[0.0, Color(0, 0, 0, 0.55)], [1.0, Color(0, 0, 0, 0)]])


## Perspective helper for the hall paintings. z = depth (1 near), X = sideways
## offset in "units"; returns the floor point on screen.
static func _persp(vp: Vector2, z: float, x: float, floor_h := 420.0, unit := 300.0) -> Vector2:
	return Vector2(vp.x + x * unit / z, vp.y + floor_h / z)


static func _paint_slot_hall(ci: CanvasItem, f: Font, t: float) -> void:
	var vp := Vector2(640, 300)
	vgrad(ci, Rect2(0, 0, 1280, 720), [[0.0, Color(0.06, 0.01, 0.04)], [0.4, Color(0.25, 0.04, 0.1)], [0.42, Color(0.2, 0.03, 0.08)], [1.0, Color(0.3, 0.04, 0.08)]])
	# Coffered ceiling lines.
	for i in 13:
		var x := -300.0 + i * 156.0
		ci.draw_line(Vector2(x, 0), vp + Vector2((x - vp.x) * 0.05, -6), Color(1, 0.7, 0.35, 0.12), 2.0)
	for z in [1.2, 1.7, 2.4, 3.4, 5.0, 7.5]:
		var y: float = vp.y - 300.0 / z
		ci.draw_line(Vector2(0, y), Vector2(1280, y), Color(1, 0.7, 0.35, 0.08), 2.0)
	# Carpet with a perspective diamond pattern.
	for zi in 18:
		var z0 := 1.0 + zi * 0.6
		var z1 := z0 + 0.6
		for xi in range(-8, 8):
			var a := _persp(vp, z0, xi)
			var b := _persp(vp, z0, xi + 1)
			var c := _persp(vp, z1, xi + 1)
			var d := _persp(vp, z1, xi)
			var col := Color(0.42, 0.06, 0.12) if (zi + xi) % 2 == 0 else Color(0.32, 0.04, 0.09)
			quad(ci, a, b, c, d, col.darkened(clampf((z0 - 1.0) / 14.0, 0.0, 0.7)))
			var m := (a + b + c + d) * 0.25
			ci.draw_circle(m, 2.6 / z0 * 2.0, Color(1, 0.75, 0.3, 0.5 / z0 * 2.0))
	glow(ci, vp, 420.0, 160.0, Color(1, 0.5, 0.4, 0.25))
	# Far wall with a giant JACKPOT sign.
	neon_text(ci, f, Vector2(440, vp.y - 34), "JACKPOT", 46, Color(1, 0.85, 0.3), 400, 0.25 if int(t * 7.0) % 37 == 0 else 1.0)
	# Rows of slot cabinets, far to near.
	var zs := [11.0, 8.5, 6.6, 5.2, 4.1, 3.2, 2.5, 1.95, 1.5]
	for side in [-1.0, 1.0]:
		for zi in zs.size():
			var z: float = zs[zi]
			_cabinet(ci, vp, z, side * 2.25, t + zi * 0.7 + side, zi)
	# Chandeliers.
	for z in [5.5, 2.6]:
		var top := Vector2(vp.x, vp.y - 330.0 / float(z))
		var s: float = 1.0 / float(z) * 3.0
		ci.draw_line(Vector2(top.x, 0), top, Color(0.6, 0.45, 0.2), 2.0)
		glow(ci, top + Vector2(0, 20 * s), 160.0 * s, 90.0 * s, Color(1, 0.85, 0.55, 0.45))
		for i in 9:
			var a := PI * i / 8.0
			var p := top + Vector2(cos(a) * 40.0 * s, 14.0 * s + sin(a) * 16.0 * s)
			ci.draw_line(top + Vector2(0, 8 * s), p, Color(1, 0.8, 0.4, 0.7), 1.5)
			ci.draw_circle(p + Vector2(0, 4 * s), 3.0 * s, Color(1, 0.97, 0.85))
			ci.draw_line(p + Vector2(0, 6 * s), p + Vector2(0, 14 * s), Color(0.8, 0.95, 1, 0.6), 1.0)


static func _cabinet(ci: CanvasItem, vp: Vector2, z: float, x: float, t: float, idx: int) -> void:
	var s := 300.0 / z
	var base := _persp(vp, z, x)
	var w := 0.85 * s
	var h := 1.85 * s
	var r := Rect2(base.x - w * 0.5, base.y - h, w, h)
	var fade := clampf((z - 1.4) / 10.0, 0.0, 0.75)
	var body := Color(0.45, 0.06, 0.14).darkened(fade)
	ci.draw_rect(r.grow(1.0), Color(0, 0, 0, 0.6))
	ci.draw_rect(r, body)
	ci.draw_rect(Rect2(r.position, Vector2(w, h * 0.16)), Color(1, 0.75, 0.3).darkened(fade))
	var scr := Rect2(r.position + Vector2(w * 0.12, h * 0.24), Vector2(w * 0.76, h * 0.26))
	var syms := [Color(1, 0.25, 0.3), Color(1, 0.85, 0.3), Color(0.4, 0.9, 1), Color(0.5, 1, 0.5)]
	glow(ci, scr.get_center(), w * 1.1, h * 0.55, Color(syms[idx % 4], 0.22 * (1.0 - fade)))
	ci.draw_rect(scr, Color(0.98, 0.95, 0.88).darkened(fade))
	for j in 3:
		var c: Color = syms[(idx + j + int(t * 2.0) * (1 if j == 1 else 0)) % 4]
		ci.draw_rect(Rect2(scr.position + Vector2(scr.size.x * (0.08 + j * 0.31), scr.size.y * 0.2), Vector2(scr.size.x * 0.24, scr.size.y * 0.6)), c.darkened(fade))
	ci.draw_rect(Rect2(r.position + Vector2(w * 0.1, h * 0.6), Vector2(w * 0.8, h * 0.08)), Color(0.15, 0.02, 0.05))
	var blink := int(t * 3.0) % 2 == 0
	ci.draw_rect(Rect2(r.position + Vector2(0, h * 0.16), Vector2(w, h * 0.03)), (Color(1, 0.3, 0.5) if blink else Color(1, 0.85, 0.3)).darkened(fade))
	var lx := r.end.x + w * 0.06
	ci.draw_line(Vector2(lx, r.position.y + h * 0.5), Vector2(lx + w * 0.1, r.position.y + h * 0.2), Color(0.7, 0.7, 0.75).darkened(fade), maxf(1.0, w * 0.04))
	ci.draw_circle(Vector2(lx + w * 0.1, r.position.y + h * 0.2), maxf(1.5, w * 0.07), Color(0.9, 0.15, 0.2).darkened(fade))
	ci.draw_rect(Rect2(base.x - w * 0.55, base.y - 2, w * 1.1, 2), Color(0, 0, 0, 0.5))


static func _paint_back_rooms(ci: CanvasItem, f: Font, t: float) -> void:
	vgrad(ci, Rect2(0, 0, 1280, 720), [[0.0, Color(0.02, 0.04, 0.03)], [0.5, Color(0.04, 0.08, 0.06)], [1.0, Color(0.01, 0.02, 0.02)]])
	# Wood paneling and striped wallpaper.
	for i in 22:
		var x := i * 60.0
		ci.draw_rect(Rect2(x, 0, 30, 330), Color(0.07, 0.12, 0.09))
		ci.draw_rect(Rect2(x + 30, 0, 2, 330), Color(0.12, 0.2, 0.14, 0.6))
	for i in 11:
		var x := i * 120.0
		ci.draw_rect(Rect2(x + 6, 340, 108, 160), Color(0.16, 0.08, 0.04))
		ci.draw_rect(Rect2(x + 14, 350, 92, 140), Color(0.22, 0.11, 0.05))
		ci.draw_rect(Rect2(x + 14, 350, 92, 2), Color(0.45, 0.25, 0.1, 0.6))
	ci.draw_rect(Rect2(0, 330, 1280, 10), Color(0.35, 0.2, 0.08))
	ci.draw_rect(Rect2(0, 330, 1280, 2), Color(0.8, 0.55, 0.25, 0.6))
	# The lamp and its cone.
	var lc := Vector2(640, 150)
	ci.draw_line(Vector2(640, 0), lc, Color(0.2, 0.2, 0.18), 3.0)
	ci.draw_polygon(PackedVector2Array([lc + Vector2(-110, 70), lc + Vector2(110, 70), Vector2(1100, 600), Vector2(180, 600)]),
			PackedColorArray([Color(1, 0.88, 0.55, 0.22), Color(1, 0.88, 0.55, 0.22), Color(1, 0.88, 0.55, 0.0), Color(1, 0.88, 0.55, 0.0)]))
	ci.draw_colored_polygon(PackedVector2Array([lc + Vector2(-70, 0), lc + Vector2(70, 0), lc + Vector2(118, 70), lc + Vector2(-118, 70)]), Color(0.1, 0.32, 0.18))
	ci.draw_line(lc + Vector2(-118, 70), lc + Vector2(118, 70), Color(0.8, 0.65, 0.3), 3.0)
	glow(ci, lc + Vector2(0, 74), 80.0, 18.0, Color(1, 0.95, 0.7, 0.95))
	# Table.
	var tc := Vector2(640, 540)
	Art.fill(ci, Art.ell(tc + Vector2(0, 30), 470, 120, 48), Color(0, 0, 0, 0.6))
	Art.fill(ci, Art.ell(tc, 450, 125, 48), Color(0.3, 0.14, 0.05))
	Art.fill(ci, Art.ell(tc + Vector2(0, -6), 414, 104, 48), Color(0.05, 0.3, 0.16))
	glow(ci, tc + Vector2(0, -16), 330.0, 82.0, Color(0.35, 0.85, 0.45, 0.45))
	var rail := PackedVector2Array()
	for i in 31:
		var a := PI * 1.06 + PI * 0.88 * i / 30.0
		rail.append(tc + Vector2(cos(a) * 300.0, -6.0 + sin(a) * 76.0))
	ci.draw_polyline(rail, Color(1, 0.85, 0.5, 0.25), 2.0, true)
	# Community cards and chip stacks.
	var ranks := ["A", "K", "Q", "J", "10"]
	for i in 5:
		card(ci, f, tc + Vector2(-152 + i * 76, -34), 52.0, (i - 2) * 0.03, 1.0, ranks[i], i % 2 == 1)
	for s in [[Vector2(-300, 10), 7, Color(0.85, 0.12, 0.18)], [Vector2(-250, 30), 5, Color(0.15, 0.4, 0.9)], [Vector2(270, 16), 9, Color(0.95, 0.75, 0.2)], [Vector2(320, 34), 4, Color(0.15, 0.6, 0.3)], [Vector2(0, 52), 12, Color(0.1, 0.1, 0.12)]]:
		var p: Vector2 = tc + (s[0] as Vector2)
		for k in int(s[1]):
			chip(ci, p + Vector2(0, -k * 5.0), 18.0, s[2], 0.0, 0.38)
	# Ashtray and cigar smoke.
	var at := tc + Vector2(190, 40)
	Art.fill(ci, Art.ell(at, 26, 8, 16), Color(0.35, 0.35, 0.4))
	Art.fill(ci, Art.ell(at, 18, 5, 16), Color(0.12, 0.12, 0.14))
	ci.draw_line(at + Vector2(-4, -2), at + Vector2(34, -10), Color(0.35, 0.2, 0.1), 5.0)
	glow(ci, at + Vector2(36, -10), 8.0, 8.0, Color(1, 0.45, 0.2, 0.9))
	for k in 3:
		var sm := PackedVector2Array()
		for i in 18:
			var u := i / 17.0
			sm.append(at + Vector2(36 + sin(t * 1.2 + u * 6.0 + k) * 22.0 * u + k * 8.0, -12 - u * 300.0))
		ci.draw_polyline(sm, Color(0.8, 0.85, 0.8, 0.08), 10.0 + k * 6.0, true)
	# Silhouettes of players around the table.
	_player_sil(ci, Vector2(130, 720), 1.25, false)
	_player_sil(ci, Vector2(1150, 720), 1.25, true)
	_player_sil(ci, Vector2(640, 440), 0.62, false)
	for i in 6:
		var y := 120.0 + i * 90.0
		hgrad(ci, Rect2(0, y, 1280, 40), Color(0.7, 0.8, 0.7, 0.0), Color(0.7, 0.8, 0.7, 0.03 + 0.02 * sin(t + i)))


## A gambler in a fedora, seen from behind.
static func _player_sil(ci: CanvasItem, base: Vector2, sc: float, flip: bool) -> void:
	var k := Color(0.01, 0.02, 0.02)
	ci.draw_set_transform(base, 0.0, Vector2(-sc if flip else sc, sc))
	Art.fill(ci, Art.pts([Vector2(-120, 0), Vector2(120, 0), Vector2(110, -110), Vector2(60, -150), Vector2(-60, -150), Vector2(-110, -110)]), k)
	Art.fill(ci, Art.ell(Vector2(0, -190), 44, 50, 20), k)
	Art.fill(ci, Art.ell(Vector2(0, -222), 80, 14, 20), k)
	Art.fill(ci, Art.pts([Vector2(-44, -222), Vector2(44, -222), Vector2(36, -268), Vector2(-36, -268)]), k)
	ci.draw_rect(Rect2(-44, -236, 88, 10), Color(0.25, 0.05, 0.08))
	ci.draw_arc(Vector2(0, -190), 46, -0.5, 0.6, 10, Color(1, 0.85, 0.5, 0.35), 3.0, true)
	ci.draw_set_transform(Vector2.ZERO)


static func _paint_vault(ci: CanvasItem, f: Font, t: float, deep: bool) -> void:
	var steel := Color(0.12, 0.16, 0.22) if not deep else Color(0.1, 0.08, 0.04)
	var steel_l := Color(0.3, 0.38, 0.48) if not deep else Color(0.45, 0.36, 0.15)
	vgrad(ci, Rect2(0, 0, 1280, 720), [[0.0, steel.darkened(0.6)], [0.6, steel], [0.62, steel.darkened(0.4)], [1.0, steel.darkened(0.75)]])
	# Riveted wall plates.
	for y in 6:
		for x in 11:
			var r := Rect2(x * 120 + 4, y * 74 + 4, 112, 66)
			ci.draw_rect(r, Color(1, 1, 1, 0.025))
			ci.draw_rect(r, Color(0, 0, 0, 0.3), false, 2.0)
			for c in [r.position + Vector2(6, 6), Vector2(r.end.x - 6, r.position.y + 6), r.end - Vector2(6, 6), Vector2(r.position.x + 6, r.end.y - 6)]:
				ci.draw_circle(c, 2.2, steel_l)
	# Floor plates in perspective.
	var vp := Vector2(640, 446)
	for i in 15:
		var x := -400.0 + i * 150.0
		ci.draw_line(vp + Vector2((x - 640) * 0.1, 0), Vector2(x, 720), Color(steel_l, 0.25), 2.0)
	for z in [1.0, 1.4, 2.0, 3.0, 4.6]:
		ci.draw_line(Vector2(0, vp.y + 274.0 / z), Vector2(1280, vp.y + 274.0 / z), Color(steel_l, 0.2), 2.0)
	# Gold spilling out of the open door.
	var dc := Vector2(770, 300)
	glow(ci, dc + Vector2(-160, 40), 380.0, 300.0, Color(1, 0.75, 0.3, 0.35))
	# The vault door, swung slightly open.
	var R := 236.0
	ci.draw_set_transform(dc, 0.0, Vector2(0.9, 1.0))
	ci.draw_circle(Vector2.ZERO, R + 18.0, Color(0, 0, 0, 0.5))
	ci.draw_circle(Vector2.ZERO, R, steel.lightened(0.1))
	ci.draw_circle(Vector2.ZERO, R * 0.9, steel_l.darkened(0.25))
	ci.draw_arc(Vector2.ZERO, R * 0.9, 0, TAU, 64, Color(1, 1, 1, 0.12), 3.0)
	for i in 28:
		var a := TAU * i / 28.0
		var p := Vector2.from_angle(a) * R * 0.95
		ci.draw_circle(p, 8.0, steel_l)
		ci.draw_circle(p + Vector2(-2, -2), 3.0, Color(1, 1, 1, 0.35))
	ci.draw_circle(Vector2.ZERO, R * 0.62, steel.lightened(0.2))
	ci.draw_arc(Vector2.ZERO, R * 0.62, 0, TAU, 48, Color(0, 0, 0, 0.4), 4.0)
	# Spoked handle wheel, slowly turning.
	var wa := t * 0.35
	for i in 3:
		var a := wa + i * TAU / 3.0
		var p := Vector2.from_angle(a) * R * 0.5
		ci.draw_line(-p, p, Color(0.85, 0.85, 0.9) if not deep else Color(1, 0.85, 0.4), 12.0)
		ci.draw_circle(p, 13.0, Color(0.9, 0.9, 0.95) if not deep else GOLD)
		ci.draw_circle(-p, 13.0, Color(0.9, 0.9, 0.95) if not deep else GOLD)
	ci.draw_circle(Vector2.ZERO, 34.0, steel_l)
	ci.draw_circle(Vector2.ZERO, 22.0, Color(0.85, 0.7, 0.3))
	# Combination dial.
	var dd := Vector2(-R * 0.3, -R * 0.33)
	ci.draw_circle(dd, 28.0, Color(0.08, 0.08, 0.1))
	for i in 20:
		var a := -t * 0.6 + TAU * i / 20.0
		ci.draw_line(dd + Vector2.from_angle(a) * 20.0, dd + Vector2.from_angle(a) * 26.0, Color(1, 1, 1, 0.7), 1.5)
	ci.draw_set_transform(Vector2.ZERO)
	# Gold bars stacked on the left.
	for row in 4:
		for i in 5 - row:
			var bx := 120.0 + i * 70.0 + row * 35.0
			var by := 640.0 - row * 34.0
			quad(ci, Vector2(bx, by), Vector2(bx + 64, by), Vector2(bx + 56, by - 30), Vector2(bx + 8, by - 30), Color(0.85, 0.62, 0.18))
			quad(ci, Vector2(bx + 8, by - 30), Vector2(bx + 56, by - 30), Vector2(bx + 50, by - 36), Vector2(bx + 14, by - 36), Color(1, 0.85, 0.4))
			var shine := fposmod(t * 0.4 + i * 0.13 + row * 0.2, 1.0)
			ci.draw_line(Vector2(bx + 8 + shine * 48, by - 30), Vector2(bx + 2 + shine * 48, by), Color(1, 1, 0.85, 0.5), 3.0)
	# Security lasers.
	for i in 4:
		var y0 := 200.0 + i * 120.0
		var a := Vector2(0, y0 + sin(t * 0.8 + i) * 30.0)
		var b := Vector2(1280, y0 + 140.0 - i * 60.0)
		var on := 0.75 + 0.25 * sin(t * 9.0 + i)
		ci.draw_line(a, b, Color(1, 0.1, 0.15, 0.18 * on), 12.0)
		ci.draw_line(a, b, Color(1, 0.4, 0.4, 0.85 * on), 2.0)
		glow(ci, a, 20.0, 20.0, Color(1, 0.2, 0.2, 0.6))
		glow(ci, b, 20.0, 20.0, Color(1, 0.2, 0.2, 0.6))
	for i in 40:
		var p := Vector2(rnd(i + 90) * 1280.0, fposmod(rnd(i + 91) * 720.0 - t * (8.0 + rnd(i) * 12.0), 720.0))
		ci.draw_circle(p, 1.4, Color(1, 0.9, 0.6, 0.35))


static func _paint_lobby(ci: CanvasItem, f: Font, t: float) -> void:
	vgrad(ci, Rect2(0, 0, 1280, 720), [[0.0, Color(0.05, 0.01, 0.03)], [0.55, Color(0.22, 0.04, 0.08)], [0.62, Color(0.08, 0.02, 0.03)], [1.0, Color(0.02, 0.0, 0.01)]])
	# Art deco sunburst behind the elevator.
	var ec := Vector2(640, 420)
	for i in 23:
		var a := PI + PI * (i + 0.5) / 23.0
		ci.draw_line(ec + Vector2(0, -120), ec + Vector2(0, -120) + Vector2.from_angle(a) * 420.0, Color(1, 0.75, 0.35, 0.12 if i % 2 == 0 else 0.05), 6.0)
	# Checkerboard floor in perspective.
	var vp := Vector2(640, 410)
	for zi in 14:
		var z0 := 1.0 + zi * 0.45
		var z1 := z0 + 0.45
		for xi in range(-9, 9):
			var col := Color(0.85, 0.8, 0.72) if (zi + xi) % 2 == 0 else Color(0.06, 0.03, 0.04)
			quad(ci, _persp(vp, z0, xi, 310.0, 140.0), _persp(vp, z0, xi + 1, 310.0, 140.0), _persp(vp, z1, xi + 1, 310.0, 140.0), _persp(vp, z1, xi, 310.0, 140.0), col.darkened(clampf((z0 - 1.0) / 7.0, 0.0, 0.85)))
	vgrad(ci, Rect2(0, 410, 1280, 310), [[0.0, Color(0.1, 0.0, 0.02, 0.7)], [0.5, Color(0.1, 0.0, 0.02, 0.25)], [1.0, Color(0, 0, 0, 0.6)]])
	# Elevator doors with the floor dial.
	var er := Rect2(ec.x - 110, ec.y - 250, 220, 250)
	ci.draw_rect(er.grow(14), Color(0.65, 0.48, 0.18))
	ci.draw_rect(er.grow(8), Color(0.25, 0.15, 0.06))
	ci.draw_rect(er, Color(0.75, 0.58, 0.25))
	ci.draw_rect(Rect2(er.position + Vector2(108, 0), Vector2(4, er.size.y)), Color(0.3, 0.2, 0.08))
	for side in [0, 1]:
		var x: float = er.position.x + 20.0 + float(side) * 110.0
		ci.draw_rect(Rect2(x, er.position.y + 30, 70, 190), Color(0.85, 0.68, 0.32), false, 2.0)
		ci.draw_colored_polygon(PackedVector2Array([Vector2(x + 35, er.position.y + 70), Vector2(x + 55, er.position.y + 125), Vector2(x + 35, er.position.y + 180), Vector2(x + 15, er.position.y + 125)]), Color(0.6, 0.42, 0.15))
	var dial := Vector2(ec.x, er.position.y - 46)
	ci.draw_arc(dial, 40, PI, TAU, 24, Color(0.85, 0.68, 0.32), 6.0)
	for i in 7:
		var a := PI + PI * i / 6.0
		ci.draw_line(dial + Vector2.from_angle(a) * 30.0, dial + Vector2.from_angle(a) * 37.0, Color(0.95, 0.85, 0.6), 2.0)
	var needle := PI + PI * (0.5 + 0.45 * sin(t * 0.7))
	ci.draw_line(dial, dial + Vector2.from_angle(needle) * 34.0, Color(0.9, 0.15, 0.2), 3.0)
	neon_text(ci, f, Vector2(ec.x - 150, er.position.y - 64), "DESCEND", 26, Color(1, 0.3, 0.4), 300, 0.3 if int(t * 5.0) % 29 == 0 else 1.0)
	# Payphone under a spotlight (left) and Comp on a stool (right).
	ci.draw_polygon(PackedVector2Array([Vector2(250, 0), Vector2(290, 0), Vector2(380, 640), Vector2(160, 640)]),
			PackedColorArray([Color(0.5, 0.85, 1, 0.2), Color(0.5, 0.85, 1, 0.2), Color(0.5, 0.85, 1, 0.0), Color(0.5, 0.85, 1, 0.0)]))
	glow(ci, Vector2(270, 640), 140.0, 26.0, Color(0.5, 0.85, 1, 0.3))
	ci.draw_set_transform(Vector2(270, 640), 0.0, Vector2(7.0, 7.0))
	Art.payphone(ci, t, int(t) % 4 == 0)
	ci.draw_set_transform(Vector2.ZERO)
	ci.draw_polygon(PackedVector2Array([Vector2(990, 0), Vector2(1030, 0), Vector2(1110, 640), Vector2(910, 640)]),
			PackedColorArray([Color(1, 0.75, 0.9, 0.18), Color(1, 0.75, 0.9, 0.18), Color(1, 0.75, 0.9, 0.0), Color(1, 0.75, 0.9, 0.0)]))
	glow(ci, Vector2(1010, 640), 130.0, 24.0, Color(1, 0.75, 0.9, 0.28))
	ci.draw_rect(Rect2(970, 560, 80, 14), Color(0.6, 0.06, 0.15))
	ci.draw_rect(Rect2(976, 574, 6, 66), Color(0.75, 0.58, 0.25))
	ci.draw_rect(Rect2(1038, 574, 6, 66), Color(0.75, 0.58, 0.25))
	ci.draw_set_transform(Vector2(1010, 562), 0.0, Vector2(6.0, 6.0))
	Art.cat(ci, t)
	ci.draw_set_transform(Vector2.ZERO)
	neon_text(ci, f, Vector2(340, 52), "NO ONE DIES OWING THE HOUSE", 30, Color(1, 0.35, 0.65), 600, 0.3 if int(t * 6.0) % 41 == 0 else 1.0)


static func _paint_boss(ci: CanvasItem, f: Font, tier: int, t: float) -> void:
	var accent: Color = [Color(1, 0.5, 0.25), Color(1, 0.3, 0.45), Color(1, 0.8, 0.3)][clampi(tier - 1, 0, 2)]
	vgrad(ci, Rect2(0, 0, 1280, 720), [[0.0, Color(0.02, 0.0, 0.02)], [0.7, Color(0.12, 0.02, 0.05)], [1.0, Color(0.03, 0.0, 0.01)]])
	var c := Vector2(640, 330)
	# A backdrop that tells you who you're about to fight.
	match tier:
		1:
			# Sal's office: window blinds over the city.
			var wr := Rect2(340, 60, 600, 360)
			ci.draw_rect(wr, Color(0.1, 0.05, 0.12))
			skyline(ci, 420.0, 51, Color(0.05, 0.02, 0.07), Color(1, 0.75, 0.45, 0.7), 60.0, 260.0, t)
			for i in 24:
				ci.draw_rect(Rect2(wr.position.x, wr.position.y + i * 15.0, wr.size.x, 7), Color(0.04, 0.02, 0.03, 0.85))
			ci.draw_rect(wr, Color(0.35, 0.22, 0.1), false, 10.0)
		2:
			# A giant roulette wheel turning behind Madame Roulette.
			var rot := t * 0.4
			for i in 37:
				var a0 := rot + TAU * i / 37.0
				var a1 := rot + TAU * (i + 1) / 37.0
				var col := Color(0.1, 0.4, 0.2) if i == 0 else (Color(0.5, 0.05, 0.1) if i % 2 == 1 else Color(0.08, 0.05, 0.08))
				quad(ci, c + Vector2.from_angle(a0) * 200.0, c + Vector2.from_angle(a0) * 330.0, c + Vector2.from_angle(a1) * 330.0, c + Vector2.from_angle(a1) * 200.0, col)
			ci.draw_arc(c, 330.0, 0, TAU, 64, Color(1, 0.8, 0.4, 0.6), 4.0)
			ci.draw_arc(c, 200.0, 0, TAU, 64, Color(1, 0.8, 0.4, 0.6), 3.0)
		3:
			# A wall of slot screens all showing the same thing: $.
			for y in 5:
				for x in 9:
					var r := Rect2(70 + x * 128, 30 + y * 82, 116, 70)
					ci.draw_rect(r, Color(0.12, 0.08, 0.02))
					ci.draw_rect(r.grow(-6), Color(0.2, 0.14, 0.03))
					var on := int(t * 3.0 + x + y * 2) % 4 != 0
					ci.draw_string(f, Vector2(r.position.x, r.position.y + 54), "$", HORIZONTAL_ALIGNMENT_CENTER, r.size.x, 46, Color(1, 0.8, 0.3, 0.85 if on else 0.25))
	# Curtains.
	for side in [-1.0, 1.0]:
		for i in 9:
			var x: float = 640.0 + float(side) * (420.0 + i * 26.0)
			var sway := sin(t * 0.8 + i) * 4.0
			ci.draw_colored_polygon(PackedVector2Array([Vector2(x - 14, 0), Vector2(x + 14, 0), Vector2(x + 16 + sway, 720), Vector2(x - 16 + sway, 720)]), Color(0.45, 0.03, 0.08).darkened(0.25 * float(i % 2)))
		ci.draw_rect(Rect2(0 if side < 0 else 1280 - 420, 0, 420, 40), Color(0.35, 0.02, 0.06))
	# Spotlight and stage.
	ci.draw_polygon(PackedVector2Array([Vector2(600, 0), Vector2(680, 0), Vector2(900, 600), Vector2(380, 600)]),
			PackedColorArray([Color(1, 0.95, 0.8, 0.3), Color(1, 0.95, 0.8, 0.3), Color(1, 0.95, 0.8, 0.02), Color(1, 0.95, 0.8, 0.02)]))
	glow(ci, Vector2(640, 600), 300.0, 50.0, Color(accent, 0.45))
	glow(ci, c, 260.0, 260.0, Color(accent, 0.18))
	Art.boss_portrait(ci, c + Vector2(10, 10), tier, t, 15.0)


# ================================================================ BUST wipe

## The slot-reel wipe. `k` runs from 0 to about 2.3 seconds:
## reels drop in, stop one at a time on B-U-S-T, hold, then fall away.
static func bust_wipe(ci: CanvasItem, f: Font, k: float) -> void:
	var letters := ["B", "U", "S", "T"]
	var syms := ["7", "BAR", "$", "777", "A", "21"]
	var cw := 320.0
	for i in 4:
		var t_in := 0.08 * i
		var yoff := 0.0
		if k < t_in + 0.35:
			yoff = -760.0 * (1.0 - ease(clampf((k - t_in) / 0.35, 0.0, 1.0), 0.3))
		var t_out := 1.75 + 0.07 * i
		if k > t_out:
			yoff = 780.0 * pow(clampf((k - t_out) / 0.45, 0.0, 1.0), 2.0)
		if yoff >= 760.0:
			continue
		var x := i * cw
		var r := Rect2(x, yoff, cw, 720)
		ci.draw_rect(r, Color(0.95, 0.92, 0.84))
		var stop := 0.62 + 0.2 * i
		if k < stop:
			# Spinning: blurred symbols streaming past.
			for j in 5:
				var sy := fposmod(k * 2600.0 + i * 137.0 + j * 190.0, 950.0) - 150.0 + yoff
				var s: String = syms[(i + j) % syms.size()]
				ci.draw_string(f, Vector2(x, sy), s, HORIZONTAL_ALIGNMENT_CENTER, cw, 120, Color(0.5, 0.1, 0.15, 0.35))
				ci.draw_string(f, Vector2(x, sy - 40.0), s, HORIZONTAL_ALIGNMENT_CENTER, cw, 120, Color(0.5, 0.1, 0.15, 0.15))
		else:
			var bounce := sin(clampf((k - stop) / 0.18, 0.0, 1.0) * PI) * 22.0
			var cy := 405.0 + yoff + bounce
			ci.draw_string(f, Vector2(x, cy - 250.0), syms[i % syms.size()], HORIZONTAL_ALIGNMENT_CENTER, cw, 90, Color(0.4, 0.3, 0.3, 0.35))
			ci.draw_string(f, Vector2(x, cy + 230.0), syms[(i + 3) % syms.size()], HORIZONTAL_ALIGNMENT_CENTER, cw, 90, Color(0.4, 0.3, 0.3, 0.35))
			ci.draw_string_outline(f, Vector2(x, cy + 70.0), letters[i], HORIZONTAL_ALIGNMENT_CENTER, cw, 260, 14, Color(0.25, 0.0, 0.03))
			ci.draw_string(f, Vector2(x, cy + 70.0), letters[i], HORIZONTAL_ALIGNMENT_CENTER, cw, 260, Color(0.82, 0.07, 0.14))
		# Reel curvature: shade toward the top and bottom.
		vgrad(ci, Rect2(x, yoff, cw, 720), [[0.0, Color(0, 0, 0, 0.7)], [0.25, Color(0, 0, 0, 0.0)], [0.75, Color(0, 0, 0, 0.0)], [1.0, Color(0, 0, 0, 0.7)]])
		ci.draw_rect(Rect2(x, yoff, 8, 720), Color(0.65, 0.48, 0.18))
		ci.draw_rect(Rect2(x + cw - 8, yoff, 8, 720), Color(0.4, 0.28, 0.1))
	if k > 1.42 and k < 1.8:
		var a := clampf((k - 1.42) / 0.1, 0.0, 1.0) * clampf((1.8 - k) / 0.1, 0.0, 1.0)
		ci.draw_rect(Rect2(0, 352, 1280, 6), Color(1, 0.2, 0.25, a))
		ci.draw_string_outline(f, Vector2(0, 660), "THE HOUSE COLLECTS", HORIZONTAL_ALIGNMENT_CENTER, 1280, 34, 8, Color(0, 0, 0, a))
		ci.draw_string(f, Vector2(0, 660), "THE HOUSE COLLECTS", HORIZONTAL_ALIGNMENT_CENTER, 1280, 34, Color(1, 0.85, 0.4, a))
