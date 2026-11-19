extends RefCounted
## Detailed, animated character art drawn with vector shapes: the Lobby
## NPCs (Vera, Mags, Lucky, Jules, Comp the cat, Marlow's payphone) and the
## three bosses (Big Sal, Madame Roulette, The House), including their
## phase changes. Everything is drawn in code, so no image files are needed.
##
## NPC functions draw with the feet at (0, 0) and up as -y, about 40 units tall.
## Head functions draw with the neck at (0, 0) so the same art is used both
## in the world and, scaled up, for dialogue portraits.
## Boss functions draw in the procedural rig's space (see rig.gd).

const K := Color(0.05, 0.02, 0.06)


# ================================================================ helpers

static func ell(c: Vector2, rx: float, ry: float, n := 20, rot := 0.0) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry).rotated(rot))
	return pts


static func fill(ci: CanvasItem, pts: PackedVector2Array, col: Color) -> void:
	if pts.size() >= 3:
		ci.draw_colored_polygon(pts, col)


static func line_loop(ci: CanvasItem, pts: PackedVector2Array, col := K, w := 0.5) -> void:
	if pts.size() < 2:
		return
	var p2 := pts.duplicate()
	p2.append(pts[0])
	ci.draw_polyline(p2, col, w, true)


static func shape(ci: CanvasItem, pts: PackedVector2Array, col: Color, outline := K, w := 0.5) -> void:
	fill(ci, pts, col)
	line_loop(ci, pts, outline, w)


static func blob(ci: CanvasItem, c: Vector2, rx: float, ry: float, col: Color, outline := K, w := 0.5) -> void:
	shape(ci, ell(c, rx, ry), col, outline, w)


static func pts(arr: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in arr:
		out.append(p)
	return out


static func shift(p: PackedVector2Array, d: Vector2) -> PackedVector2Array:
	var out := PackedVector2Array()
	for v in p:
		out.append(v + d)
	return out


## A thick limb segment with a lighter highlight stripe.
static func limb(ci: CanvasItem, a: Vector2, b: Vector2, w: float, col: Color) -> void:
	ci.draw_line(a, b, K, w + 1.0, true)
	ci.draw_circle(a, (w + 1.0) * 0.5, K)
	ci.draw_circle(b, (w + 1.0) * 0.5, K)
	ci.draw_line(a, b, col, w, true)
	ci.draw_circle(a, w * 0.5, col)
	ci.draw_circle(b, w * 0.5, col)
	var n := (b - a).normalized().orthogonal() * w * 0.22
	ci.draw_line(a - n, b - n, col.lightened(0.25), maxf(0.3, w * 0.25), true)


static func eye(ci: CanvasItem, c: Vector2, rx: float, ry: float, iris: Color, blink: bool, glow := 0.0) -> void:
	if blink:
		ci.draw_line(c - Vector2(rx, 0), c + Vector2(rx, 0), K, 0.45, true)
		return
	fill(ci, ell(c, rx, ry, 12), Color(0.97, 0.95, 0.92))
	fill(ci, ell(c + Vector2(rx * 0.2, 0), ry * 0.85, ry * 0.85, 10), iris)
	ci.draw_circle(c + Vector2(rx * 0.25, 0), ry * 0.4, K)
	ci.draw_circle(c + Vector2(rx * 0.05, -ry * 0.35), ry * 0.22, Color(1, 1, 1, 0.9))
	line_loop(ci, ell(c, rx, ry, 12), K, 0.35)
	if glow > 0.0:
		ci.draw_circle(c, rx * 2.2, Color(iris, 0.25 * glow))


static func smoke(ci: CanvasItem, from: Vector2, t: float, n := 5, spread := 1.0) -> void:
	for i in n:
		var k := fmod(t * 0.45 + i / float(n), 1.0)
		var p := from + Vector2(sin(t * 1.3 + i * 1.7) * 2.0 * spread * k + k * 2.0, -k * 12.0 * spread)
		ci.draw_circle(p, 0.6 + k * 2.2 * spread, Color(0.78, 0.76, 0.8, 0.32 * (1.0 - k)))


# ================================================================ NPCs

## Vera Vex behind her dealer's table.
static func vera(ci: CanvasItem, t: float) -> void:
	var br := sin(t * 1.6) * 0.35
	var blink := fmod(t, 4.3) < 0.12
	ci.draw_set_transform(Vector2(0, br * 0.4))
	# Back hair.
	blob(ci, Vector2(0, -34.4), 5.1, 5.4, Color(0.07, 0.04, 0.08))
	# Dress and shoulders.
	var dress := pts([Vector2(-6.5, -12), Vector2(6.5, -12), Vector2(5.6, -21), Vector2(4.6, -26.6), Vector2(-4.6, -26.6), Vector2(-5.6, -21)])
	shape(ci, dress, Color(0.62, 0.05, 0.13))
	fill(ci, pts([Vector2(-6.5, -12), Vector2(-2.5, -12), Vector2(-2.2, -25.4), Vector2(-4.6, -26.6), Vector2(-5.6, -21)]), Color(0.45, 0.03, 0.1))
	fill(ci, pts([Vector2(-4.6, -26.6), Vector2(4.6, -26.6), Vector2(3.8, -28.6), Vector2(-3.8, -28.6)]), Color(0.95, 0.8, 0.72))
	ci.draw_polyline(pts([Vector2(-4.6, -26.6), Vector2(-2.2, -25.4), Vector2(0, -26.4), Vector2(2.2, -25.4), Vector2(4.6, -26.6)]), Color(1, 0.8, 0.3), 0.6, true)
	for i in 4:
		ci.draw_line(Vector2(-0.8, -24 + i * 2.6), Vector2(0.8, -23 + i * 2.6), Color(1, 0.8, 0.3, 0.7), 0.35, true)
	fill(ci, pts([Vector2(-1.2, -28.4), Vector2(1.2, -28.4), Vector2(1, -30.6), Vector2(-1, -30.6)]), Color(0.9, 0.74, 0.66))
	ci.draw_line(Vector2(-1.3, -29.4), Vector2(1.3, -29.4), K, 0.7)
	ci.draw_circle(Vector2(0, -29.1), 0.45, Color(0.9, 0.1, 0.2))
	# Arms in black opera gloves, reaching to the table.
	var deal := sin(t * 2.2)
	limb(ci, Vector2(-4.6, -26), Vector2(-6.6, -19.6), 1.9, Color(0.1, 0.08, 0.12))
	limb(ci, Vector2(-6.6, -19.6), Vector2(-2.6 + deal * 0.6, -16.4), 1.7, Color(0.1, 0.08, 0.12))
	limb(ci, Vector2(4.6, -26), Vector2(6.6, -19.6), 1.9, Color(0.1, 0.08, 0.12))
	limb(ci, Vector2(6.6, -19.6), Vector2(3.6, -17.2), 1.7, Color(0.1, 0.08, 0.12))
	# Head.
	vera_head(ci, Vector2(0, -30.6), t, blink)
	ci.draw_set_transform(Vector2.ZERO)
	# The table.
	fill(ci, ell(Vector2(0, 1), 16, 1.8), Color(0, 0, 0, 0.35))
	shape(ci, pts([Vector2(-12, -10.5), Vector2(-10, -10.5), Vector2(-10.8, 0), Vector2(-12.4, 0)]), Color(0.32, 0.17, 0.08))
	shape(ci, pts([Vector2(10, -10.5), Vector2(12, -10.5), Vector2(12.4, 0), Vector2(10.8, 0)]), Color(0.32, 0.17, 0.08))
	shape(ci, pts([Vector2(-14, -12.6), Vector2(14, -12.6), Vector2(13, -10), Vector2(-13, -10)]), Color(0.36, 0.19, 0.08))
	ci.draw_line(Vector2(-13.4, -11.5), Vector2(13.4, -11.5), Color(1, 0.8, 0.3, 0.8), 0.4)
	shape(ci, ell(Vector2(0, -13.6), 15.5, 2.6, 28), Color(0.07, 0.4, 0.22), Color(0.85, 0.65, 0.25), 0.7)
	line_loop(ci, ell(Vector2(0, -13.6), 12.5, 1.7, 24), Color(1, 0.9, 0.5, 0.35), 0.3)
	# Chip stacks.
	var stacks := [[Vector2(-10.5, -13.8), Color(0.85, 0.12, 0.18), 5], [Vector2(-8.3, -13.4), Color(0.12, 0.12, 0.16), 4], [Vector2(-11.6, -12.9), Color(1, 0.78, 0.2), 3]]
	for sk in stacks:
		var base: Vector2 = sk[0]
		for j in int(sk[2]):
			var c: Color = sk[1]
			shape(ci, ell(base + Vector2(0, -j * 0.75), 1.3, 0.45, 10), c if j % 2 == 0 else c.lightened(0.15), K, 0.25)
	# Card shoe.
	shape(ci, pts([Vector2(8, -13.4), Vector2(12.4, -13.4), Vector2(12.4, -16.2), Vector2(9.4, -16.6)]), Color(0.18, 0.1, 0.08))
	fill(ci, pts([Vector2(9.6, -16.3), Vector2(12, -15.9), Vector2(12, -15.2), Vector2(9.6, -15.4)]), Color(0.95, 0.93, 0.88))
	# Fanned cards, riffled every few seconds.
	var spread := 0.18 + 0.2 * clampf(sin(t * 1.1) * 2.0, 0.0, 1.0)
	for i in 5:
		var a := -0.5 + i * spread + deal * 0.03
		var xf := Transform2D(a, Vector2(-2.4 + deal * 0.6, -16.6))
		var card := pts([xf * Vector2(-1, -0.2), xf * Vector2(1, -0.2), xf * Vector2(1, -3.2), xf * Vector2(-1, -3.2)])
		shape(ci, card, Color(0.98, 0.96, 0.92), K, 0.3)
		ci.draw_circle(xf * Vector2(0, -1.8), 0.35, Color(0.85, 0.1, 0.15) if i % 2 == 0 else K)
	ci.draw_circle(Vector2(-2.6 + deal * 0.6, -16.4), 0.9, Color(0.1, 0.08, 0.12))


static func vera_head(ci: CanvasItem, neck: Vector2, t: float, blink := false) -> void:
	var o := neck
	var skin := Color(0.97, 0.82, 0.73)
	var hair := Color(0.07, 0.04, 0.08)
	# Face.
	var face := pts([o + Vector2(-3.3, -1.6), o + Vector2(3.3, -1.6), o + Vector2(4, -5), o + Vector2(3.7, -8.6), o + Vector2(0, -9.6), o + Vector2(-3.7, -8.6), o + Vector2(-4, -5)])
	shape(ci, face, skin)
	fill(ci, pts([o + Vector2(-3.3, -1.6), o + Vector2(-1.2, -1.4), o + Vector2(-2.6, -4.6), o + Vector2(-4, -5)]), skin.darkened(0.12))
	ci.draw_circle(o + Vector2(-2.4, -4.2), 0.9, Color(1, 0.5, 0.5, 0.25))
	ci.draw_circle(o + Vector2(2.4, -4.2), 0.9, Color(1, 0.5, 0.5, 0.25))
	# Eyes, eyeshadow, brows, lips.
	fill(ci, ell(o + Vector2(-1.55, -6.1), 1.2, 0.6, 10), Color(0.45, 0.15, 0.35, 0.55))
	fill(ci, ell(o + Vector2(1.55, -6.1), 1.2, 0.6, 10), Color(0.45, 0.15, 0.35, 0.55))
	eye(ci, o + Vector2(-1.55, -5.5), 0.95, 0.55, Color(0.25, 0.5, 0.35), blink)
	eye(ci, o + Vector2(1.55, -5.5), 0.95, 0.55, Color(0.25, 0.5, 0.35), blink)
	ci.draw_line(o + Vector2(-2.6, -5.6), o + Vector2(-3.1, -6.1), K, 0.35, true)
	ci.draw_line(o + Vector2(2.6, -5.6), o + Vector2(3.1, -6.1), K, 0.35, true)
	ci.draw_line(o + Vector2(-2.4, -7.1), o + Vector2(-0.8, -7.3), K, 0.35, true)
	ci.draw_line(o + Vector2(0.8, -7.3), o + Vector2(2.4, -7.1), K, 0.35, true)
	ci.draw_line(o + Vector2(0, -5), o + Vector2(0.3, -3.8), skin.darkened(0.25), 0.35, true)
	fill(ci, ell(o + Vector2(0, -2.9), 1.05, 0.42, 10), Color(0.78, 0.06, 0.16))
	ci.draw_line(o + Vector2(-0.9, -2.9), o + Vector2(0.9, -2.9), Color(0.4, 0.02, 0.08), 0.25)
	ci.draw_circle(o + Vector2(-0.3, -3.1), 0.18, Color(1, 1, 1, 0.6))
	ci.draw_circle(o + Vector2(1.9, -3.9), 0.18, K)
	# Bob haircut with blunt bangs and a sheen.
	fill(ci, pts([o + Vector2(-4.9, -1.2), o + Vector2(-3.4, -1.5), o + Vector2(-3.7, -6.6), o + Vector2(-4.6, -7.4)]), hair)
	fill(ci, pts([o + Vector2(4.9, -1.2), o + Vector2(3.4, -1.5), o + Vector2(3.7, -6.6), o + Vector2(4.6, -7.4)]), hair)
	var bangs := pts([o + Vector2(-4.7, -6.9), o + Vector2(4.7, -6.9), o + Vector2(4.4, -9.6), o + Vector2(2.6, -10.8), o + Vector2(-2.6, -10.8), o + Vector2(-4.4, -9.6)])
	shape(ci, bangs, hair)
	ci.draw_arc(o + Vector2(0, -8.2), 3.6, -2.7, -0.6, 10, Color(0.6, 0.45, 0.75, 0.55), 0.45, true)
	# Gold hoop earrings that sway.
	var sw := sin(t * 2.4) * 0.3
	ci.draw_arc(o + Vector2(-4.1 + sw, -3.0), 0.75, 0, TAU, 12, Color(1, 0.8, 0.3), 0.3, true)
	ci.draw_arc(o + Vector2(4.1 + sw, -3.0), 0.75, 0, TAU, 12, Color(1, 0.8, 0.3), 0.3, true)


## Mags Moray at her loan desk.
static func mags_desk(ci: CanvasItem, t: float) -> void:
	var br := sin(t * 1.4) * 0.4
	# Tail swishing behind the desk.
	var sw := sin(t * 2.2) * 2.0
	shape(ci, pts([Vector2(10, -12), Vector2(17, -15 + sw), Vector2(19.5, -20 + sw), Vector2(17.5, -14 + sw * 0.5), Vector2(19.5, -9 + sw), Vector2(15.5, -11)]), Color(0.38, 0.46, 0.58))
	ci.draw_set_transform(Vector2(0, br * 0.3))
	# Dorsal fin out the back of the jacket.
	shape(ci, pts([Vector2(-5.5, -27), Vector2(-11.5, -33.5), Vector2(-9.6, -27.6), Vector2(-5.5, -24)]), Color(0.36, 0.44, 0.56))
	# Suit jacket.
	var navy := Color(0.11, 0.13, 0.22)
	shape(ci, pts([Vector2(-7.5, -12), Vector2(7.5, -12), Vector2(7, -22), Vector2(5.2, -26.6), Vector2(-5.2, -26.6), Vector2(-7, -22)]), navy)
	for i in 8:
		var x := -6.0 + i * 1.7
		ci.draw_line(Vector2(x, -12.4), Vector2(x * 0.92, -25.6), Color(0.35, 0.38, 0.55, 0.55), 0.22)
	fill(ci, pts([Vector2(-2.2, -26.4), Vector2(2.2, -26.4), Vector2(0, -19)]), Color(0.95, 0.94, 0.9))
	shape(ci, pts([Vector2(-0.6, -26), Vector2(0.6, -26), Vector2(1, -20.5), Vector2(0, -19.4), Vector2(-1, -20.5)]), Color(0.8, 0.08, 0.14), K, 0.3)
	ci.draw_line(Vector2(-0.9, -22.6), Vector2(0.9, -22.6), Color(1, 0.8, 0.3), 0.45)
	shape(ci, pts([Vector2(-5.2, -26.6), Vector2(-2.2, -26.4), Vector2(-0.4, -19.6), Vector2(-3.2, -21)]), Color(0.17, 0.2, 0.32), K, 0.35)
	shape(ci, pts([Vector2(5.2, -26.6), Vector2(2.2, -26.4), Vector2(0.4, -19.6), Vector2(3.2, -21)]), Color(0.17, 0.2, 0.32), K, 0.35)
	fill(ci, pts([Vector2(4.2, -23.4), Vector2(5.6, -23.6), Vector2(5.1, -22.4)]), Color(0.9, 0.1, 0.2))
	# Fin-hands: one taps a fountain pen, one rests on the ledger.
	var tap := absf(sin(t * 5.0)) * 0.8 if fmod(t, 5.0) < 2.0 else 0.0
	limb(ci, Vector2(-6.4, -25.4), Vector2(-8.6, -18), 2.4, navy)
	limb(ci, Vector2(-8.6, -18), Vector2(-4.4, -14.2), 2.2, navy)
	limb(ci, Vector2(6.4, -25.4), Vector2(8.6, -18.4), 2.4, navy)
	limb(ci, Vector2(8.6, -18.4), Vector2(5.4, -15.4 - tap), 2.2, navy)
	shape(ci, ell(Vector2(5.2, -15.2 - tap), 1.4, 0.9, 12), Color(0.42, 0.5, 0.62))
	shape(ci, ell(Vector2(-4.2, -14), 1.4, 0.9, 12), Color(0.42, 0.5, 0.62))
	ci.draw_line(Vector2(5.6, -15.6 - tap), Vector2(8.6, -18.6 - tap), K, 0.8, true)
	ci.draw_line(Vector2(5.6, -15.6 - tap), Vector2(8.4, -18.4 - tap), Color(0.15, 0.15, 0.2), 0.55, true)
	ci.draw_line(Vector2(5.6, -15.6 - tap), Vector2(6.2, -16.2 - tap), Color(1, 0.8, 0.3), 0.55)
	mags_head(ci, Vector2(0, -26.4), t)
	ci.draw_set_transform(Vector2.ZERO)
	# Mahogany desk.
	fill(ci, ell(Vector2(0, 1), 18, 1.8), Color(0, 0, 0, 0.35))
	var wood := Color(0.36, 0.15, 0.08)
	shape(ci, pts([Vector2(-16, -12), Vector2(16, -12), Vector2(16, 0), Vector2(-16, 0)]), wood.darkened(0.15))
	for x in [-14.4, -4.6, 5.2]:
		shape(ci, pts([Vector2(x, -10.2), Vector2(x + 9.2, -10.2), Vector2(x + 9.2, -1.6), Vector2(x, -1.6)]), wood.darkened(0.3), Color(0.55, 0.3, 0.12), 0.35)
	shape(ci, pts([Vector2(-17.2, -14), Vector2(17.2, -14), Vector2(17.2, -12), Vector2(-17.2, -12)]), wood)
	ci.draw_line(Vector2(-17, -13.6), Vector2(17, -13.6), Color(0.75, 0.45, 0.25, 0.7), 0.35)
	shape(ci, pts([Vector2(-4, -6.8), Vector2(4, -6.8), Vector2(4, -4.6), Vector2(-4, -4.6)]), Color(0.85, 0.65, 0.25), K, 0.3)
	ci.draw_string(ThemeDB.fallback_font, Vector2(-4, -5.2), "M. MORAY", HORIZONTAL_ALIGNMENT_CENTER, 8, 2, Color(0.25, 0.12, 0.05))
	# Banker's lamp, Markers and a ledger.
	shape(ci, pts([Vector2(-14.6, -14), Vector2(-11.4, -14), Vector2(-12, -14.8), Vector2(-14, -14.8)]), Color(0.75, 0.55, 0.2), K, 0.3)
	ci.draw_line(Vector2(-13, -14.8), Vector2(-13, -19), Color(0.75, 0.55, 0.2), 0.6)
	shape(ci, pts([Vector2(-16.4, -19), Vector2(-9.6, -19), Vector2(-10.4, -21.6), Vector2(-15.6, -21.6)]), Color(0.08, 0.45, 0.25), K, 0.35)
	fill(ci, pts([Vector2(-16, -19), Vector2(-10, -19), Vector2(-9, -14.2), Vector2(-17, -14.2)]), Color(1, 0.9, 0.55, 0.13 + 0.03 * sin(t * 9.0)))
	for i in 4:
		shape(ci, pts([Vector2(-7.5 + i * 0.3, -14 - i * 0.55), Vector2(-1.5 + i * 0.3, -14 - i * 0.55), Vector2(-1.5 + i * 0.3, -14.5 - i * 0.55), Vector2(-7.5 + i * 0.3, -14.5 - i * 0.55)]), Color(0.96, 0.93, 0.82), K, 0.2)
	ci.draw_circle(Vector2(-3.4, -16.3), 0.55, Color(0.8, 0.1, 0.15))
	shape(ci, pts([Vector2(1, -14), Vector2(8.5, -14), Vector2(8, -15), Vector2(1.5, -15)]), Color(0.45, 0.1, 0.12), K, 0.25)
	fill(ci, pts([Vector2(2, -15), Vector2(7.6, -15), Vector2(7.2, -15.5), Vector2(2.4, -15.5)]), Color(0.95, 0.93, 0.85))


static func mags_head(ci: CanvasItem, neck: Vector2, t: float) -> void:
	var o := neck
	var top := Color(0.36, 0.44, 0.56)
	var mid := Color(0.48, 0.56, 0.68)
	var belly := Color(0.9, 0.9, 0.86)
	var grin := 0.5 + 0.5 * clampf(sin(t * 0.7) * 3.0, 0.0, 1.0)
	var head := pts([o + Vector2(-5.6, 0.2), o + Vector2(-6.4, -6), o + Vector2(-3.8, -11.2), o + Vector2(2.4, -12.6), o + Vector2(8.6, -10.4), o + Vector2(13.2, -6.6), o + Vector2(12.4, -4.2), o + Vector2(6.4, -1.6), o + Vector2(0.4, 0.4)])
	shape(ci, head, mid)
	fill(ci, pts([o + Vector2(-6.4, -6), o + Vector2(-3.8, -11.2), o + Vector2(2.4, -12.6), o + Vector2(8.6, -10.4), o + Vector2(13.2, -6.6), o + Vector2(6, -7.6), o + Vector2(-1, -8.4)]), top)
	fill(ci, pts([o + Vector2(0.4, 0.2), o + Vector2(6.4, -1.8), o + Vector2(12.2, -4.4), o + Vector2(11.6, -3.2), o + Vector2(5.6, -0.6)]), belly)
	# Mouth full of teeth.
	var mouth := pts([o + Vector2(3.4, -3.4), o + Vector2(12.4, -5.6), o + Vector2(11.4, -4.2 + grin * 0.4), o + Vector2(4.4, -2.4 + grin * 0.6)])
	shape(ci, mouth, Color(0.35, 0.05, 0.1), K, 0.35)
	for i in 6:
		var x := 4.4 + i * 1.3
		var y := -3.6 - i * 0.33
		fill(ci, pts([o + Vector2(x, y), o + Vector2(x + 1.0, y - 0.25), o + Vector2(x + 0.55, y + 0.9)]), Color.WHITE)
		fill(ci, pts([o + Vector2(x + 0.3, y + 1.1 + grin * 0.4), o + Vector2(x + 1.2, y + 0.85 + grin * 0.4), o + Vector2(x + 0.8, y + 0.1 + grin * 0.4)]), Color(0.95, 0.95, 0.9))
	# Gills, eye, nostril.
	for i in 3:
		ci.draw_arc(o + Vector2(-1.4 + i * 1.1, -4.4), 1.5, 1.2, 2.4, 6, K, 0.35, true)
	var blink := fmod(t, 5.1) < 0.14
	ci.draw_circle(o + Vector2(7.2, -7.6), 1.15, Color(1, 0.82, 0.25))
	if blink:
		fill(ci, ell(o + Vector2(7.2, -7.6), 1.2, 1.2, 10), Color(0.7, 0.75, 0.82))
	else:
		ci.draw_circle(o + Vector2(7.4, -7.6), 0.62, K)
		ci.draw_circle(o + Vector2(7.0, -8.0), 0.22, Color.WHITE)
	ci.draw_line(o + Vector2(11.2, -7.2), o + Vector2(11.8, -7.4), K, 0.4)
	# Fedora with a red band, tilted.
	var hx := Transform2D(-0.12, o + Vector2(1.6, -11.6))
	shape(ci, pts([hx * Vector2(-7.6, 0.4), hx * Vector2(7.6, 0.4), hx * Vector2(6.6, -0.6), hx * Vector2(-6.6, -0.6)]), Color(0.1, 0.1, 0.13))
	shape(ci, pts([hx * Vector2(-4.4, -0.4), hx * Vector2(4.6, -0.4), hx * Vector2(4, -4.8), hx * Vector2(1.6, -5.6), hx * Vector2(-1.8, -5.6), hx * Vector2(-4, -4.6)]), Color(0.13, 0.13, 0.17))
	fill(ci, pts([hx * Vector2(-4.4, -0.4), hx * Vector2(4.6, -0.4), hx * Vector2(4.4, -1.6), hx * Vector2(-4.3, -1.6)]), Color(0.75, 0.08, 0.14))
	ci.draw_line(hx * Vector2(-3.4, -4.4), hx * Vector2(-1.4, -5.2), Color(0.45, 0.45, 0.55, 0.6), 0.35)


## Lucky behind his bar, polishing a glass. `bottles` draws the back shelf.
static func lucky_bar(ci: CanvasItem, t: float, bottles := true) -> void:
	if bottles:
		shape(ci, pts([Vector2(-20, -32), Vector2(20, -32), Vector2(20, -30.8), Vector2(-20, -30.8)]), Color(0.36, 0.2, 0.09))
		var bcols := [Color(0.3, 0.75, 0.4), Color(0.75, 0.3, 0.2), Color(0.95, 0.8, 0.3), Color(0.4, 0.55, 0.95), Color(0.85, 0.4, 0.8), Color(0.95, 0.6, 0.2)]
		for i in 9:
			var bx := -18.0 + i * 4.4
			var c: Color = bcols[i % bcols.size()]
			var h := 5.0 + float((i * 7) % 4)
			var b := pts([Vector2(bx - 1.2, -32), Vector2(bx + 1.2, -32), Vector2(bx + 1.2, -32 - h + 2), Vector2(bx + 0.5, -32 - h + 1), Vector2(bx + 0.5, -32 - h), Vector2(bx - 0.5, -32 - h), Vector2(bx - 0.5, -32 - h + 1), Vector2(bx - 1.2, -32 - h + 2)])
			shape(ci, b, Color(c, 0.85), K, 0.3)
			ci.draw_line(Vector2(bx - 0.7, -32.4), Vector2(bx - 0.7, -32 - h + 2.2), Color(1, 1, 1, 0.45), 0.3)
			ci.draw_circle(Vector2(bx, -33.5), 1.6, Color(c, 0.08 + 0.04 * sin(t * 3.0 + i)))
	# Lucky.
	var bob := sin(t * 2.0) * 0.4
	ci.draw_set_transform(Vector2(0, bob))
	var white := Color(0.95, 0.95, 0.92)
	shape(ci, pts([Vector2(-6, -13), Vector2(6, -13), Vector2(5.4, -24.6), Vector2(-5.4, -24.6)]), white)
	shape(ci, pts([Vector2(-6, -13), Vector2(-1.2, -13), Vector2(-1.4, -24.4), Vector2(-5.4, -24.6)]), Color(0.72, 0.1, 0.15), K, 0.35)
	shape(ci, pts([Vector2(6, -13), Vector2(1.2, -13), Vector2(1.4, -24.4), Vector2(5.4, -24.6)]), Color(0.72, 0.1, 0.15), K, 0.35)
	for i in 3:
		ci.draw_circle(Vector2(1.9, -16 - i * 2.6), 0.32, Color(1, 0.8, 0.3))
	shape(ci, pts([Vector2(-1.8, -25.3), Vector2(0, -24.5), Vector2(1.8, -25.3), Vector2(1.8, -23.7), Vector2(0, -24.5), Vector2(-1.8, -23.7)]), K, K, 0.2)
	# Towel over the shoulder.
	shape(ci, pts([Vector2(3.6, -24.8), Vector2(6, -24.4), Vector2(6.4, -18.6), Vector2(5, -18.8)]), Color(0.9, 0.88, 0.78), K, 0.3)
	# Arms: one polishes a glass in circles.
	var pa := t * 4.0
	var hand := Vector2(-1.5 + cos(pa) * 1.3, -16.5 + sin(pa) * 0.9)
	limb(ci, Vector2(-5, -23.6), Vector2(-7.2, -18), 2.0, white)
	limb(ci, Vector2(-7.2, -18), hand + Vector2(-1.5, 0), 1.8, white)
	ci.draw_line(Vector2(-6.4, -21.6), Vector2(-7.8, -20.6), Color(0.85, 0.1, 0.15), 0.8)
	limb(ci, Vector2(5, -23.6), Vector2(6.8, -18), 2.0, white)
	limb(ci, Vector2(6.8, -18), hand + Vector2(1.4, 0.5), 1.8, white)
	var glass := pts([hand + Vector2(-1.3, -2.4), hand + Vector2(1.3, -2.4), hand + Vector2(1, 1), hand + Vector2(-1, 1)])
	shape(ci, glass, Color(0.75, 0.9, 1.0, 0.45), Color(0.9, 0.95, 1), 0.3)
	ci.draw_line(hand + Vector2(-0.6, -2), hand + Vector2(-0.6, 0.6), Color(1, 1, 1, 0.8), 0.3)
	shape(ci, ell(hand + Vector2(-1.6, 0.4), 1.2, 0.8, 10), Color(0.9, 0.88, 0.78), K, 0.3)
	ci.draw_circle(hand + Vector2(1.6, 0.4), 0.8, Color(0.9, 0.72, 0.58))
	lucky_head(ci, Vector2(0, -24.6), t)
	ci.draw_set_transform(Vector2.ZERO)
	# Bar counter with brass rail.
	fill(ci, ell(Vector2(0, 1), 22, 1.8), Color(0, 0, 0, 0.35))
	var wood := Color(0.38, 0.19, 0.08)
	shape(ci, pts([Vector2(-20, -12.6), Vector2(20, -12.6), Vector2(20, 0), Vector2(-20, 0)]), wood.darkened(0.2))
	for i in 8:
		var x := -18.0 + i * 5.2
		ci.draw_line(Vector2(x, -11.6), Vector2(x, -1), wood.darkened(0.45), 0.5)
		ci.draw_line(Vector2(x + 0.6, -11.6), Vector2(x + 0.6, -1), wood.lightened(0.1), 0.25)
	shape(ci, pts([Vector2(-21, -14.4), Vector2(21, -14.4), Vector2(21, -12.6), Vector2(-21, -12.6)]), wood)
	ci.draw_line(Vector2(-20.6, -14), Vector2(20.6, -14), Color(0.8, 0.5, 0.25, 0.8), 0.4)
	ci.draw_line(Vector2(-20, -3), Vector2(20, -3), Color(0.85, 0.65, 0.25), 0.9, true)
	ci.draw_line(Vector2(-20, -3.4), Vector2(20, -3.4), Color(1, 0.9, 0.55, 0.7), 0.3)
	# A martini on the bar.
	var mg := Vector2(13, -14.4)
	ci.draw_line(mg, mg + Vector2(0, -2.6), Color(0.85, 0.95, 1, 0.8), 0.35)
	shape(ci, pts([mg + Vector2(-2, -4.8), mg + Vector2(2, -4.8), mg + Vector2(0, -2.6)]), Color(0.75, 0.95, 1, 0.45), Color(0.9, 0.95, 1), 0.3)
	ci.draw_circle(mg + Vector2(0.6, -3.9), 0.45, Color(0.4, 0.7, 0.2))


## Lucky's head: slicked grey hair, green visor, big mustache. `o` is the neck.
static func lucky_head(ci: CanvasItem, o: Vector2, t: float) -> void:
	var skin := Color(0.92, 0.74, 0.6)
	shape(ci, pts([o + Vector2(-3.4, -0.6), o + Vector2(3.6, -0.6), o + Vector2(4, -5), o + Vector2(3.4, -8.4), o + Vector2(-3.2, -8.4), o + Vector2(-3.9, -5)]), skin)
	ci.draw_circle(o + Vector2(-3.8, -4.4), 1.0, skin.darkened(0.1))
	fill(ci, pts([o + Vector2(-3.6, -6.2), o + Vector2(-3.2, -9), o + Vector2(3.4, -9), o + Vector2(3.8, -7.4), o + Vector2(-2, -7.6)]), Color(0.7, 0.7, 0.75))
	var blink := fmod(t, 3.7) < 0.12
	eye(ci, o + Vector2(-1.2, -5.2), 0.7, 0.45, Color(0.3, 0.3, 0.45), blink)
	eye(ci, o + Vector2(1.6, -5.2), 0.7, 0.45, Color(0.3, 0.3, 0.45), blink)
	ci.draw_circle(o + Vector2(0.6, -3.6), 0.75, Color(0.92, 0.55, 0.5))
	shape(ci, pts([o + Vector2(-2.4, -2.3), o + Vector2(0.5, -3.1), o + Vector2(3.4, -2.3), o + Vector2(2.6, -1.5), o + Vector2(0.5, -2.2), o + Vector2(-1.6, -1.5)]), Color(0.8, 0.8, 0.82), K, 0.3)
	shape(ci, pts([o + Vector2(-4.4, -7.6), o + Vector2(5.4, -7.6), o + Vector2(4.6, -9), o + Vector2(-3.8, -9)]), Color(0.15, 0.6, 0.3, 0.9), K, 0.3)
	fill(ci, pts([o + Vector2(0.6, -7.6), o + Vector2(6.8, -7.0), o + Vector2(5.4, -7.9)]), Color(0.2, 0.75, 0.4, 0.75))


## Jules in the Lobby: dealer's vest under his hoodie, card tricks.
static func jules(ci: CanvasItem, t: float) -> void:
	var br := sin(t * 1.7) * 0.35
	fill(ci, ell(Vector2(0, 0.6), 7, 1.2), Color(0, 0, 0, 0.35))
	var jeans := Color(0.18, 0.22, 0.36)
	limb(ci, Vector2(-1.8, -12), Vector2(-2.4, -6), 2.4, jeans)
	limb(ci, Vector2(-2.4, -6), Vector2(-2.6, -1), 2.2, jeans)
	limb(ci, Vector2(1.8, -12), Vector2(2.6, -6), 2.4, jeans)
	limb(ci, Vector2(2.6, -6), Vector2(3.2, -1), 2.2, jeans)
	shape(ci, pts([Vector2(-4.4, 0), Vector2(-0.8, 0), Vector2(-0.8, -1.6), Vector2(-3.6, -1.8)]), Color(0.92, 0.92, 0.9))
	shape(ci, pts([Vector2(1.6, 0), Vector2(5.4, 0), Vector2(4.6, -1.8), Vector2(1.8, -1.6)]), Color(0.92, 0.92, 0.9))
	ci.draw_set_transform(Vector2(0, br * 0.4))
	var green := Color(0.16, 0.42, 0.26)
	shape(ci, pts([Vector2(-5.2, -11.4), Vector2(5.2, -11.4), Vector2(5.8, -20), Vector2(4, -23.4), Vector2(-4, -23.4), Vector2(-5.8, -20)]), green)
	shape(ci, pts([Vector2(-2.6, -12), Vector2(2.6, -12), Vector2(2.8, -21.6), Vector2(-2.8, -21.6)]), Color(0.12, 0.1, 0.12), K, 0.35)
	ci.draw_line(Vector2(0, -21.4), Vector2(0, -12.4), Color(0.95, 0.95, 0.9), 0.5)
	for i in 3:
		ci.draw_circle(Vector2(1.2, -19 + i * 2.4), 0.3, Color(1, 0.8, 0.3))
	shape(ci, pts([Vector2(-4.6, -23.4), Vector2(4.6, -23.4), Vector2(3.4, -25.4), Vector2(-3.4, -25.4)]), green.darkened(0.2))
	ci.draw_line(Vector2(-1.4, -23), Vector2(-1.6, -19.6), Color(0.9, 0.9, 0.85), 0.35)
	ci.draw_line(Vector2(1.4, -23), Vector2(1.6, -19.6), Color(0.9, 0.9, 0.85), 0.35)
	# Arms: a card walks across his knuckles.
	limb(ci, Vector2(-4.8, -22), Vector2(-6.2, -16.6), 2.2, green)
	limb(ci, Vector2(-6.2, -16.6), Vector2(-4.6, -12.6), 2.0, green)
	limb(ci, Vector2(4.8, -22), Vector2(6.4, -16.8), 2.2, green)
	limb(ci, Vector2(6.4, -16.8), Vector2(4.6, -14.6), 2.0, green)
	var hand := Vector2(4.4, -14.4)
	ci.draw_circle(hand, 1.0, Color(0.88, 0.7, 0.56))
	var ca := fmod(t * 2.0, TAU)
	var cx := Transform2D(ca, hand + Vector2(0, -2.6))
	shape(ci, pts([cx * Vector2(-0.9, -1.3), cx * Vector2(0.9, -1.3), cx * Vector2(0.9, 1.3), cx * Vector2(-0.9, 1.3)]), Color(0.98, 0.96, 0.92) if cos(ca) > 0.0 else Color(0.65, 0.08, 0.15), K, 0.25)
	ci.draw_circle(Vector2(-4.6, -12.6), 1.0, Color(0.88, 0.7, 0.56))
	jules_head(ci, Vector2(0, -25.2), t)
	ci.draw_set_transform(Vector2.ZERO)


## Jules' head: messy brown hair, stubble, tired eyes. `o` is the neck.
static func jules_head(ci: CanvasItem, o: Vector2, t: float) -> void:
	var skin := Color(0.9, 0.72, 0.58)
	shape(ci, pts([o + Vector2(-3.4, -0.4), o + Vector2(3.4, -0.4), o + Vector2(3.9, -4.8), o + Vector2(3.4, -8.4), o + Vector2(-3.4, -8.4), o + Vector2(-3.9, -4.8)]), skin)
	fill(ci, pts([o + Vector2(-3.4, -0.4), o + Vector2(3.4, -0.4), o + Vector2(3.8, -3), o + Vector2(-3.8, -3)]), Color(0.45, 0.35, 0.3, 0.35))
	var blink := fmod(t, 3.3) < 0.14
	eye(ci, o + Vector2(-1.4, -4.8), 0.75, 0.4, Color(0.35, 0.25, 0.15), blink)
	eye(ci, o + Vector2(1.4, -4.8), 0.75, 0.4, Color(0.35, 0.25, 0.15), blink)
	ci.draw_line(o + Vector2(-2.2, -4.1), o + Vector2(-0.6, -4.1), Color(0.5, 0.3, 0.35, 0.5), 0.3)
	ci.draw_line(o + Vector2(0.6, -4.1), o + Vector2(2.2, -4.1), Color(0.5, 0.3, 0.35, 0.5), 0.3)
	ci.draw_line(o + Vector2(-0.8, -2.2), o + Vector2(0.9, -2.0), Color(0.45, 0.2, 0.2), 0.35, true)
	var hair := Color(0.3, 0.18, 0.1)
	shape(ci, pts([o + Vector2(-4.2, -5.6), o + Vector2(-4.4, -8.6), o + Vector2(-2.6, -10.4), o + Vector2(-0.6, -9.8), o + Vector2(0.6, -11), o + Vector2(2.4, -10), o + Vector2(4.2, -10.4), o + Vector2(4.2, -8.4), o + Vector2(3.6, -6.4), o + Vector2(2.6, -7.4), o + Vector2(0, -7.2), o + Vector2(-2.4, -7.6)]), hair)


## Comp, the Lobby cat.
static func cat(ci: CanvasItem, t: float) -> void:
	var k := Color(0.07, 0.06, 0.09)
	var sheen := Color(0.35, 0.3, 0.5, 0.6)
	fill(ci, ell(Vector2(0, 0.4), 7, 1.0), Color(0, 0, 0, 0.35))
	var sw := sin(t * 1.8)
	var tail := PackedVector2Array()
	for i in 9:
		var k2 := i / 8.0
		tail.append(Vector2(5 + k2 * 4.0 + sin(t * 1.8 + k2 * 2.0) * 1.2 * k2, -1 - k2 * 9.0 + sw * k2 * 1.5))
	ci.draw_polyline(tail, K, 2.4, true)
	ci.draw_polyline(tail, k, 1.6, true)
	shape(ci, pts([Vector2(-5, 0), Vector2(5.8, 0), Vector2(6, -4), Vector2(3.6, -8.4), Vector2(-1, -9.4), Vector2(-4, -6.6)]), k)
	ci.draw_arc(Vector2(1.6, -5), 3.6, -2.4, -1.0, 10, sheen, 0.5, true)
	shape(ci, ell(Vector2(-3.6, -0.6), 1.6, 0.8, 10), k)
	# Head.
	var tw := sin(t * 0.9) > 0.97
	var o := Vector2(-2.6, -10.6)
	shape(ci, ell(o, 3.6, 3.1, 16), k)
	shape(ci, pts([o + Vector2(-3.4, -1.2), o + Vector2(-3.1, -5.6 + (0.6 if tw else 0.0)), o + Vector2(-0.9, -2.8)]), k)
	shape(ci, pts([o + Vector2(0.7, -2.9), o + Vector2(2.6, -5.6), o + Vector2(3.4, -1.4)]), k)
	fill(ci, pts([o + Vector2(-2.9, -1.8), o + Vector2(-2.8, -4.4), o + Vector2(-1.5, -2.6)]), Color(0.7, 0.35, 0.45))
	fill(ci, pts([o + Vector2(1.3, -2.7), o + Vector2(2.4, -4.4), o + Vector2(2.8, -1.8)]), Color(0.7, 0.35, 0.45))
	var slow_blink := fmod(t, 6.0) < 0.5
	for ex in [-1.3, 1.3]:
		var ec := o + Vector2(ex, -0.4)
		if slow_blink:
			ci.draw_arc(ec, 0.7, 0.3, PI - 0.3, 8, Color(0.6, 1, 0.5), 0.35, true)
		else:
			fill(ci, ell(ec, 0.8, 0.65, 10), Color(0.6, 1.0, 0.45))
			fill(ci, ell(ec, 0.22, 0.6, 8), K)
			ci.draw_circle(ec, 1.6, Color(0.6, 1, 0.45, 0.12))
	fill(ci, pts([o + Vector2(-0.35, 0.7), o + Vector2(0.35, 0.7), o + Vector2(0, 1.1)]), Color(0.8, 0.45, 0.55))
	for s2 in [-1, 1]:
		for j in 2:
			ci.draw_line(o + Vector2(s2 * 1.0, 1.0 + j * 0.4), o + Vector2(s2 * 3.6, 0.6 + j * 0.8), Color(0.8, 0.8, 0.85, 0.6), 0.2)
	# Red collar with a gold chip tag.
	ci.draw_arc(o + Vector2(0, 0.4), 2.9, 0.5, PI - 0.5, 10, Color(0.85, 0.1, 0.15), 0.8, true)
	ci.draw_circle(o + Vector2(0, 3.3), 0.75, Color(1, 0.8, 0.25))
	ci.draw_circle(o + Vector2(0, 3.3), 0.38, Color(0.8, 0.55, 0.1))


## Marlow's payphone. `ring` makes the handset rattle.
static func payphone(ci: CanvasItem, t: float, ring: bool) -> void:
	var shakeo := Vector2(sin(t * 60.0) * 0.4, 0) if ring and int(t * 2.0) % 3 == 0 else Vector2.ZERO
	ci.draw_line(Vector2(0, -12), Vector2(0, 0), Color(0.3, 0.3, 0.35), 1.6)
	shape(ci, pts([Vector2(-6.5, -36), Vector2(6.5, -36), Vector2(7, -12), Vector2(-7, -12)]), Color(0.22, 0.24, 0.3))
	fill(ci, pts([Vector2(-6, -35.4), Vector2(-2, -35.4), Vector2(-2.6, -12.6), Vector2(-6.4, -12.6)]), Color(0.32, 0.34, 0.42))
	shape(ci, pts([Vector2(-5.4, -38.6), Vector2(5.4, -38.6), Vector2(6.5, -36), Vector2(-6.5, -36)]), Color(0.18, 0.4, 0.7))
	ci.draw_string(ThemeDB.fallback_font, Vector2(-5.4, -36.6), "PHONE", HORIZONTAL_ALIGNMENT_CENTER, 10.8, 2, Color(1, 1, 1, 0.9))
	shape(ci, pts([Vector2(-4.4, -33.6), Vector2(4.4, -33.6), Vector2(4.4, -30), Vector2(-4.4, -30)]), Color(0.3, 0.8, 0.9, 0.55 + 0.25 * sin(t * 3.0)), K, 0.3)
	for y in 4:
		for x in 3:
			shape(ci, pts([Vector2(-3.2 + x * 2.2, -28.6 + y * 2.2), Vector2(-1.8 + x * 2.2, -28.6 + y * 2.2), Vector2(-1.8 + x * 2.2, -27.4 + y * 2.2), Vector2(-3.2 + x * 2.2, -27.4 + y * 2.2)]), Color(0.85, 0.85, 0.9), K, 0.2)
	shape(ci, pts([Vector2(4.6, -24), Vector2(5.6, -24), Vector2(5.6, -21.6), Vector2(4.6, -21.6)]), Color(0.12, 0.12, 0.14), K, 0.2)
	var cord := PackedVector2Array()
	for i in 12:
		cord.append(Vector2(7.2 + sin(i * 1.6) * 0.6, -18 + i * 0.6) + shakeo * (i / 12.0))
	ci.draw_polyline(cord, K, 0.5, true)
	var hs := pts([Vector2(6.8, -33), Vector2(9.2, -33), Vector2(9.6, -31), Vector2(8.6, -27), Vector2(9.6, -23), Vector2(9.2, -21), Vector2(6.8, -21), Vector2(7.4, -27)])
	shape(ci, shift(hs, shakeo), Color(0.1, 0.1, 0.12))
	if ring and int(t * 2.0) % 3 == 0:
		for i in 3:
			ci.draw_arc(Vector2(10.5, -30), 2.0 + i * 1.6, -0.9, 0.9, 8, Color(1, 0.9, 0.4, 0.8 - i * 0.2), 0.4, true)


# ================================================================ bosses
# Drawn in rig space: feet at the origin, facing +x. boss.gd passes the rig
# transform, the boss tier (1 Sal, 2 Roulette, 3 The House) and the phase.

static func boss_style_overrides(tier: int) -> Dictionary:
	match tier:
		1:
			return {"arm": Color(0.17, 0.17, 0.21), "leg": Color(0.14, 0.14, 0.18), "skin": Color(0.86, 0.66, 0.52), "shoe": Color(0.1, 0.07, 0.06), "arm_w": 3.6, "leg_w": 3.8}
		2:
			return {"arm": Color(0.08, 0.06, 0.09), "skin": Color(0.97, 0.85, 0.78), "shoe": Color(0.7, 0.05, 0.12), "arm_w": 2.4, "leg_w": 2.6}
		3:
			return {"arm": Color(0.92, 0.9, 0.86), "leg": Color(0.88, 0.86, 0.82), "skin": Color(0.97, 0.97, 0.95), "shoe": Color(0.1, 0.08, 0.08), "arm_w": 2.8, "leg_w": 3.0}
	return {}


## Behind the body: Roulette's wheel halo, The House's cape and orbiting dice.
static func boss_back(ci: CanvasItem, xf: Transform2D, rig, tier: int, phase: int, t: float) -> void:
	ci.draw_set_transform_matrix(xf)
	var neck: Vector2 = rig.neck()
	match tier:
		2:
			var c := neck + Vector2(-1.5, -4)
			var spd: float = [1.2, 2.6, 4.5][clampi(phase - 1, 0, 2)]
			var a0 := t * spd
			var r := 13.5
			if phase >= 3:
				for i in 14:
					var fa := TAU * i / 14.0 + t * 0.5
					var fl := 2.0 + absf(sin(t * 9.0 + i * 2.1)) * 2.5
					ci.draw_circle(c + Vector2.from_angle(fa) * (r + 1.5), fl, Color(1, 0.5, 0.15, 0.35))
			ci.draw_circle(c, r + 3.0, Color(1, 0.75, 0.3, 0.1 + 0.08 * phase))
			ci.draw_circle(c, r + 1.4, Color(0.75, 0.55, 0.2))
			for i in 18:
				var p0 := c + Vector2.from_angle(a0 + TAU * i / 18.0) * r
				var p1 := c + Vector2.from_angle(a0 + TAU * (i + 1) / 18.0) * r
				var p2 := c + Vector2.from_angle(a0 + TAU * (i + 1) / 18.0) * r * 0.62
				var p3 := c + Vector2.from_angle(a0 + TAU * i / 18.0) * r * 0.62
				var col := Color(0.1, 0.55, 0.22) if i == 0 else (Color(0.78, 0.06, 0.12) if i % 2 == 0 else Color(0.08, 0.07, 0.09))
				fill(ci, pts([p0, p1, p2, p3]), col)
			line_loop(ci, ell(c, r, r, 36), Color(1, 0.85, 0.4), 0.5)
			ci.draw_circle(c, r * 0.6, Color(0.45, 0.25, 0.1))
			for i in 4:
				ci.draw_line(c, c + Vector2.from_angle(-a0 * 0.7 + i * PI * 0.5) * r * 0.55, Color(0.95, 0.8, 0.35), 0.7, true)
			ci.draw_circle(c, 1.8, Color(1, 0.85, 0.4))
			for b in (1 if phase < 3 else 3):
				var ba := -t * spd * 1.9 + b * TAU / 3.0
				ci.draw_circle(c + Vector2.from_angle(ba) * (r * 0.82), 0.9, Color.WHITE)
		3:
			var sh: Vector2 = rig.shoulder_of(rig.pose["hip"], rig.pose["torso"])
			var wave := sin(t * 2.2)
			var cape := PackedVector2Array([sh + Vector2(-4.5, -1)])
			for i in 7:
				var k := i / 6.0
				cape.append(Vector2(-6.5 - k * 3.0 + sin(t * 2.6 + k * 3.0) * 1.6, sh.y + 2 + k * (-sh.y - 2.5)))
			cape.append(Vector2(4.5 + wave, -0.6))
			cape.append(sh + Vector2(4.6, -1))
			fill(ci, cape, Color(0.55, 0.04, 0.1))
			line_loop(ci, cape, K, 0.5)
			var lining := PackedVector2Array()
			for i in 7:
				var k := i / 6.0
				lining.append(Vector2(-6.5 - k * 3.0 + sin(t * 2.6 + k * 3.0) * 1.6, sh.y + 2 + k * (-sh.y - 2.5)))
			for i in 6:
				var k := 1.0 - i / 5.0
				lining.append(Vector2(-3.4 - k * 1.2 + sin(t * 2.6 + k * 3.0) * 1.2, sh.y + 2 + k * (-sh.y - 2.5)))
			fill(ci, lining, Color(0.06, 0.05, 0.08))
			for i in 4:
				var p := Vector2(-6.0 + sin(t * 2.6 + i) * 1.0, sh.y + 6 + i * 4.0)
				ci.draw_string(ThemeDB.fallback_font, p, ["S", "H", "D", "C"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 3, Color(1, 0.8, 0.35, 0.5))
			_orbit(ci, rig, t, phase, false)


## Torso and head, called from inside the rig so the front arm overlaps.
static func boss_body(ci: CanvasItem, xf: Transform2D, rig, tier: int, phase: int, t: float, alpha: float) -> void:
	var hip: Vector2 = rig.pose["hip"]
	var torso: float = rig.pose["torso"]
	var L: float = rig.s["torso_len"]
	ci.draw_set_transform_matrix(xf)
	if tier == 2:
		_roulette_skirt(ci, rig, t, phase)
	ci.draw_set_transform_matrix(xf * Transform2D(torso, hip))
	match tier:
		1:
			_sal_torso(ci, L, phase, t)
		2:
			_roulette_torso(ci, L, phase)
		3:
			_house_torso(ci, L, phase, t)
	ci.draw_set_transform_matrix(xf * Transform2D(torso + float(rig.pose["head"]), rig.neck()))
	boss_head(ci, tier, phase, t)


## In front of everything: brass knuckles, the rake, the cane, smoke, orbits.
static func boss_front(ci: CanvasItem, xf: Transform2D, rig, tier: int, phase: int, t: float) -> void:
	ci.draw_set_transform_matrix(xf)
	var hf: Vector2 = rig.pose["hand_f"]
	var hb: Vector2 = rig.pose["hand_b"]
	match tier:
		1:
			for h in [hf, hb]:
				var hv: Vector2 = h
				for i in 4:
					ci.draw_arc(hv + Vector2(0.6, -1.0 + i * 0.65), 0.45, 0, TAU, 8, Color(1, 0.8, 0.3), 0.35, true)
				if phase >= 3:
					ci.draw_circle(hv, 3.0, Color(1, 0.6, 0.2, 0.25 + 0.15 * sin(t * 12.0)))
		2:
			var dirv := Vector2(1.0, 0.55).normalized()
			var tip := hf + dirv * 15.0
			ci.draw_line(hf - dirv * 2.0, tip, K, 1.2, true)
			ci.draw_line(hf - dirv * 2.0, tip, Color(0.55, 0.32, 0.12), 0.7, true)
			var n := dirv.orthogonal()
			ci.draw_line(tip - n * 2.2, tip + n * 2.2, K, 1.4, true)
			ci.draw_line(tip - n * 2.0, tip + n * 2.0, Color(0.9, 0.72, 0.3), 0.8, true)
		3:
			var cane_end := Vector2(hf.x + 2.5, -0.2)
			ci.draw_line(hf, cane_end, K, 1.3, true)
			ci.draw_line(hf, cane_end, Color(0.08, 0.07, 0.1), 0.8, true)
			ci.draw_circle(cane_end, 0.6, Color(1, 0.8, 0.3))
			var dt := hf + Vector2(0, -1.6)
			shape(ci, pts([dt + Vector2(-1.3, -1.3), dt + Vector2(1.3, -1.3), dt + Vector2(1.3, 1.3), dt + Vector2(-1.3, 1.3)]), Color(1, 0.82, 0.3), K, 0.3)
			ci.draw_circle(dt, 0.3, K)
			_orbit(ci, rig, t, phase, true)


static func _orbit(ci: CanvasItem, rig, t: float, phase: int, front: bool) -> void:
	var c: Vector2 = (rig.pose["hip"] as Vector2) + Vector2(0, -6)
	var n := 2 + phase
	for i in n:
		var a := t * (1.2 + phase * 0.3) + TAU * i / n
		var z := sin(a)
		if (z > 0.0) != front:
			continue
		var p := c + Vector2(cos(a) * 15.0, z * 3.0 - 2.0 + sin(t * 2.0 + i) * 1.5)
		var s := 1.2 + 0.4 * z
		if i % 2 == 0:
			var rot := t * 3.0 + i
			var box := PackedVector2Array()
			for j in 4:
				box.append(p + Vector2.from_angle(rot + j * PI * 0.5 + PI * 0.25) * s * 1.4)
			shape(ci, box, Color(0.98, 0.97, 0.94), K, 0.3)
			ci.draw_circle(p, 0.3, K)
			ci.draw_circle(p + Vector2.from_angle(rot) * s * 0.6, 0.25, K)
		else:
			shape(ci, ell(p, s * 1.3, s * 0.55, 10), Color(1, 0.78, 0.25) if i % 3 != 0 else Color(0.6, 0.3, 0.9), K, 0.3)


# ---------------------------------------------------------------- Big Sal

static func _sal_torso(ci: CanvasItem, L: float, phase: int, t: float) -> void:
	var body := pts([Vector2(-6, 0.6), Vector2(6, 0.6), Vector2(7.4, -3), Vector2(7.2, -L + 0.8), Vector2(5.2, -L - 0.6), Vector2(-5.2, -L - 0.6), Vector2(-7.2, -L + 0.8), Vector2(-7.4, -3)])
	if phase == 1:
		shape(ci, body, Color(0.17, 0.17, 0.21))
		for i in 9:
			var x := -6.0 + i * 1.5
			ci.draw_line(Vector2(x * 0.98, 0.2), Vector2(x * 0.9, -L), Color(0.4, 0.4, 0.5, 0.5), 0.2)
		fill(ci, pts([Vector2(-2, -L - 0.4), Vector2(2, -L - 0.4), Vector2(0, -3.6)]), Color(0.95, 0.94, 0.9))
		shape(ci, pts([Vector2(-0.7, -L), Vector2(0.7, -L), Vector2(1.1, -3.6), Vector2(0, -2.6), Vector2(-1.1, -3.6)]), Color(0.78, 0.08, 0.12), K, 0.3)
		shape(ci, pts([Vector2(-5.2, -L - 0.6), Vector2(-2, -L - 0.4), Vector2(-0.6, -3.4), Vector2(-4, -4.4)]), Color(0.24, 0.24, 0.3), K, 0.35)
		shape(ci, pts([Vector2(5.2, -L - 0.6), Vector2(2, -L - 0.4), Vector2(0.6, -3.4), Vector2(4, -4.4)]), Color(0.24, 0.24, 0.3), K, 0.35)
		fill(ci, pts([Vector2(4.4, -5.6), Vector2(6.2, -5.8), Vector2(5.6, -4.4)]), Color(0.9, 0.1, 0.18))
	else:
		shape(ci, body, Color(0.93, 0.92, 0.88))
		fill(ci, pts([Vector2(-6, 0.6), Vector2(-2, 0.6), Vector2(-3, -L), Vector2(-7.2, -L + 0.8), Vector2(-7.4, -3)]), Color(0.8, 0.79, 0.76))
		ci.draw_line(Vector2(-3.4, 0.4), Vector2(-3.8, -L), Color(0.8, 0.1, 0.15), 0.9)
		ci.draw_line(Vector2(3.4, 0.4), Vector2(3.8, -L), Color(0.8, 0.1, 0.15), 0.9)
		if phase >= 3:
			ci.draw_line(Vector2(1.5, -5), Vector2(3.5, -2), Color(0.6, 0.1, 0.1, 0.7), 0.4)
			ci.draw_line(Vector2(-1, -3), Vector2(0.5, -1), Color(0.6, 0.1, 0.1, 0.7), 0.4)
	# Gold chain with a $ medallion, belt.
	var chain := PackedVector2Array()
	for i in 9:
		var k := i / 8.0
		chain.append(Vector2(lerpf(-3.6, 3.6, k), -L + 0.6 + sin(k * PI) * 3.4))
	ci.draw_polyline(chain, Color(1, 0.8, 0.3), 0.5, true)
	ci.draw_circle(Vector2(0, -L + 4.2), 1.1, Color(1, 0.8, 0.3))
	ci.draw_string(ThemeDB.fallback_font, Vector2(-1.1, -L + 5.0), "$", HORIZONTAL_ALIGNMENT_CENTER, 2.2, 2, Color(0.5, 0.3, 0.05))
	fill(ci, pts([Vector2(-6.2, 0.6), Vector2(6.2, 0.6), Vector2(6.3, -0.8), Vector2(-6.3, -0.8)]), Color(0.1, 0.07, 0.06))
	shape(ci, pts([Vector2(-1, 0.4), Vector2(1, 0.4), Vector2(1, -1), Vector2(-1, -1)]), Color(1, 0.8, 0.3), K, 0.25)


static func _sal_head(ci: CanvasItem, phase: int, t: float) -> void:
	var skin := Color(0.86, 0.66, 0.52) if phase < 3 else Color(0.92, 0.5, 0.4)
	fill(ci, pts([Vector2(-2.6, 1), Vector2(2.6, 1), Vector2(2.4, -1.4), Vector2(-2.4, -1.4)]), skin.darkened(0.15))
	var head := pts([Vector2(-4.4, -1), Vector2(4.6, -1), Vector2(5.6, -4.6), Vector2(5.2, -8.6), Vector2(3.6, -10.6), Vector2(-3.4, -10.6), Vector2(-5, -8.6), Vector2(-5.2, -4.6)])
	shape(ci, head, skin)
	fill(ci, pts([Vector2(-4.4, -1), Vector2(4.6, -1), Vector2(5.4, -3.8), Vector2(-5.2, -3.8)]), Color(0.35, 0.25, 0.25, 0.35))
	fill(ci, pts([Vector2(-4.4, -1), Vector2(-1.6, -1), Vector2(-2.6, -8.4), Vector2(-5, -8.6), Vector2(-5.2, -4.6)]), skin.darkened(0.12))
	ci.draw_circle(Vector2(-3.4, -5.4), 1.2, skin.darkened(0.2))
	# Brow, eyes, nose, mustache, scar.
	ci.draw_line(Vector2(0.2, -7.4), Vector2(4.8, -6.8), K, 0.9, true)
	eye(ci, Vector2(1.4, -6.1), 0.7, 0.4, Color(0.3, 0.2, 0.15), false, 1.0 if phase >= 3 else 0.0)
	eye(ci, Vector2(3.9, -6.0), 0.6, 0.38, Color(0.3, 0.2, 0.15), false, 1.0 if phase >= 3 else 0.0)
	shape(ci, pts([Vector2(4.4, -5.8), Vector2(6.4, -4), Vector2(4.6, -3.6)]), skin.darkened(0.08), K, 0.35)
	shape(ci, pts([Vector2(1.2, -3.4), Vector2(5.8, -3.6), Vector2(6.2, -2.6), Vector2(4.2, -2.2), Vector2(3.4, -2.8), Vector2(2.2, -2.2), Vector2(1.0, -2.6)]), Color(0.12, 0.08, 0.06), K, 0.3)
	ci.draw_line(Vector2(-0.6, -8.4), Vector2(1.4, -4.6), Color(0.95, 0.55, 0.55, 0.8), 0.35, true)
	# Cigar with a glowing tip and smoke.
	var tip := Vector2(9.4, -1.4)
	ci.draw_line(Vector2(5, -2.4), tip, K, 1.5, true)
	ci.draw_line(Vector2(5, -2.4), tip, Color(0.45, 0.25, 0.12), 1.0, true)
	ci.draw_line(Vector2(6.2, -2.2), Vector2(6.6, -2.1), Color(0.85, 0.1, 0.15), 1.0)
	var ember := 0.6 + 0.4 * sin(t * 4.0)
	ci.draw_circle(tip, 0.65, Color(1, 0.45 + 0.3 * ember, 0.15))
	ci.draw_circle(tip, 1.6, Color(1, 0.5, 0.2, 0.25 * ember))
	smoke(ci, tip + Vector2(0.4, -0.6), t, 5, 0.8)
	if phase >= 2:
		for i in 2:
			var k := fmod(t * 0.8 + i * 0.5, 1.0)
			fill(ci, ell(Vector2(-3 + i * 6.0, -7.6 + k * 4.0), 0.35, 0.6, 8), Color(0.7, 0.85, 1.0, 0.8 * (1.0 - k)))
	if phase < 3:
		# Fedora.
		shape(ci, ell(Vector2(0.4, -10.4), 7.2, 1.3, 20), Color(0.1, 0.1, 0.12))
		shape(ci, pts([Vector2(-3.8, -10.6), Vector2(4.6, -10.6), Vector2(4, -15), Vector2(2, -15.8), Vector2(-1.8, -15.8), Vector2(-3.6, -15)]), Color(0.13, 0.13, 0.16))
		fill(ci, pts([Vector2(-3.8, -10.6), Vector2(4.6, -10.6), Vector2(4.5, -12), Vector2(-3.7, -12)]), Color(0.7, 0.08, 0.12))
		ci.draw_line(Vector2(-2.6, -14.6), Vector2(0.4, -15.4), Color(0.45, 0.45, 0.55, 0.6), 0.35)
	else:
		# Hat's gone: slicked hair, bulging veins, steam from the ears.
		shape(ci, pts([Vector2(-5, -8.4), Vector2(-3.6, -11), Vector2(3.8, -11), Vector2(5.2, -9), Vector2(1, -9.6)]), Color(0.08, 0.06, 0.06))
		ci.draw_polyline(pts([Vector2(1.4, -9.2), Vector2(2.2, -8.4), Vector2(1.8, -7.8)]), Color(0.7, 0.05, 0.05), 0.4, true)
		smoke(ci, Vector2(-4.6, -5.4), t * 2.0, 3, 0.6)


# ---------------------------------------------------------------- Madame Roulette

static func _roulette_skirt(ci: CanvasItem, rig, t: float, phase: int) -> void:
	var hip: Vector2 = rig.pose["hip"]
	var ff: Vector2 = rig.pose["foot_f"]
	var fb: Vector2 = rig.pose["foot_b"]
	var stride := (ff.x - fb.x) * 0.35
	var skirt := PackedVector2Array([hip + Vector2(-3.6, -0.4)])
	var n := 9
	for i in n + 1:
		var k := float(i) / n
		var x := lerpf(-8.0 + stride, 9.0 + stride, k)
		skirt.append(Vector2(x, 0.4 + sin(t * 5.0 + k * 9.0) * 0.45))
	skirt.append(hip + Vector2(3.6, -0.4))
	fill(ci, skirt, Color(0.66, 0.05, 0.13))
	line_loop(ci, skirt, K, 0.5)
	for i in 4:
		var k := (i + 0.5) / 4.0
		var bx := lerpf(-6.0 + stride, 7.0 + stride, k)
		ci.draw_line(hip + Vector2(lerpf(-2.4, 2.4, k), 0), Vector2(bx, 0), Color(0.42, 0.02, 0.08), 0.6, true)
	var hem := PackedVector2Array()
	for i in n + 1:
		var k := float(i) / n
		hem.append(Vector2(lerpf(-8.0 + stride, 9.0 + stride, k), -0.4 + sin(t * 5.0 + k * 9.0) * 0.45))
	ci.draw_polyline(hem, Color(1, 0.8, 0.3), 0.55, true)
	if phase >= 2:
		for i in 3:
			var k := fmod(t * 0.7 + i / 3.0, 1.0)
			ci.draw_circle(Vector2(lerpf(-7.0, 8.0, fmod(i * 0.37 + t * 0.1, 1.0)), -k * 6.0), 0.35, Color(1, 0.85, 0.4, 1.0 - k))


static func _roulette_torso(ci: CanvasItem, L: float, phase: int) -> void:
	var red := Color(0.72, 0.06, 0.14)
	var bod := pts([Vector2(-3.6, 0.4), Vector2(3.6, 0.4), Vector2(4.2, -3.8), Vector2(4.9, -L + 0.8), Vector2(-4.9, -L + 0.8), Vector2(-4.2, -3.8)])
	shape(ci, bod, red)
	fill(ci, pts([Vector2(-3.6, 0.4), Vector2(-1, 0.4), Vector2(-1.6, -L + 1), Vector2(-4.9, -L + 0.8), Vector2(-4.2, -3.8)]), red.darkened(0.3))
	fill(ci, pts([Vector2(-4.9, -L + 0.8), Vector2(4.9, -L + 0.8), Vector2(3.8, -L - 0.8), Vector2(-3.8, -L - 0.8)]), Color(0.97, 0.85, 0.78))
	ci.draw_polyline(pts([Vector2(-4.9, -L + 0.8), Vector2(-2.3, -L + 1.6), Vector2(0, -L + 0.6), Vector2(2.3, -L + 1.6), Vector2(4.9, -L + 0.8)]), Color(1, 0.8, 0.3), 0.6, true)
	for i in 3:
		ci.draw_line(Vector2(-0.9, -1.2 - i * 1.6), Vector2(0.9, -1.8 - i * 1.6), Color(1, 0.8, 0.3, 0.8), 0.3)
	ci.draw_line(Vector2(-1.1, -L - 1.6), Vector2(1.1, -L - 1.6), K, 0.6)
	ci.draw_circle(Vector2(0, -L - 1.3), 0.5, Color(0.9, 0.05, 0.15) if phase < 3 else Color(1, 0.7, 0.2))


static func _roulette_head(ci: CanvasItem, phase: int, t: float) -> void:
	var skin := Color(0.97, 0.85, 0.78)
	var hair := Color(0.07, 0.03, 0.07)
	if phase >= 3:
		# Hair has come loose and whips behind her.
		for i in 6:
			var strand := PackedVector2Array()
			for j in 7:
				var k := j / 6.0
				strand.append(Vector2(-3.0 - k * 9.0, -9.0 + i * 1.2 + sin(t * 6.0 + k * 4.0 + i) * 1.6 * k))
			ci.draw_polyline(strand, hair, 1.3, true)
	fill(ci, pts([Vector2(-1, 0.6), Vector2(1, 0.6), Vector2(0.9, -2.4), Vector2(-0.9, -2.4)]), skin.darkened(0.08))
	var face := pts([Vector2(-3, -2), Vector2(3.4, -2.4), Vector2(4.4, -5.2), Vector2(4.0, -8.8), Vector2(1.2, -10.2), Vector2(-2.8, -9.4), Vector2(-3.6, -6)])
	shape(ci, face, skin)
	fill(ci, pts([Vector2(-3, -2), Vector2(-0.6, -2.2), Vector2(-1.8, -6), Vector2(-3.6, -6)]), skin.darkened(0.1))
	ci.draw_circle(Vector2(2.6, -4.6), 1.0, Color(1, 0.45, 0.45, 0.25))
	# Eyes with long lashes (gold glow in the last phase), lips, beauty mark.
	fill(ci, ell(Vector2(2.2, -6.9), 1.2, 0.55, 10), Color(0.6, 0.05, 0.15, 0.5))
	eye(ci, Vector2(2.3, -6.3), 0.9, 0.5, Color(1, 0.75, 0.2) if phase >= 3 else Color(0.25, 0.12, 0.08), false, 1.0 if phase >= 3 else 0.0)
	for i in 3:
		ci.draw_line(Vector2(1.6 + i * 0.6, -6.7), Vector2(1.3 + i * 0.75, -7.5), K, 0.3, true)
	ci.draw_line(Vector2(1.2, -7.9), Vector2(3.3, -7.7), K, 0.4, true)
	ci.draw_line(Vector2(4.0, -6.0), Vector2(4.6, -4.4), skin.darkened(0.25), 0.4, true)
	fill(ci, ell(Vector2(3.2, -3.4), 0.9, 0.38, 10), Color(0.55, 0.02, 0.1))
	ci.draw_circle(Vector2(1.6, -3.6), 0.18, K)
	# Dangling gold earring.
	var sw := sin(t * 2.2) * 0.5
	ci.draw_line(Vector2(-0.6, -4.4), Vector2(-0.6 + sw, -2.6), Color(1, 0.8, 0.3), 0.3, true)
	ci.draw_circle(Vector2(-0.6 + sw, -2.3), 0.5, Color(1, 0.8, 0.3))
	# Updo with a gold comb and a roulette-ball pin.
	var up := pts([Vector2(-3.8, -5.6), Vector2(-4.4, -9.2), Vector2(-2.2, -11.4), Vector2(1.6, -11.6), Vector2(4.2, -9.6), Vector2(3.4, -8.8), Vector2(0.6, -9.8), Vector2(-2, -8.6), Vector2(-2.6, -6)])
	shape(ci, up, hair)
	if phase < 3:
		shape(ci, ell(Vector2(-1.2, -13.0), 3.3, 2.5, 18), hair)
		ci.draw_arc(Vector2(-1.2, -13.0), 2.4, -2.6, -0.4, 10, Color(0.55, 0.35, 0.6, 0.6), 0.4, true)
		ci.draw_line(Vector2(-4, -11.2), Vector2(1.6, -11.6), Color(1, 0.8, 0.3), 0.8, true)
		ci.draw_circle(Vector2(1.8, -14.2), 0.95, Color(0.98, 0.98, 0.96))
		ci.draw_circle(Vector2(1.5, -14.5), 0.3, Color(1, 1, 1))
	ci.draw_arc(Vector2(0, -8.8), 3.0, -2.6, -1.2, 8, Color(0.55, 0.35, 0.6, 0.6), 0.4, true)


# ---------------------------------------------------------------- The House

static func _house_torso(ci: CanvasItem, L: float, phase: int, t: float) -> void:
	var white := Color(0.93, 0.91, 0.87)
	var bod := pts([Vector2(-4.8, 0.6), Vector2(4.8, 0.6), Vector2(5.6, -3.6), Vector2(6.4, -L + 0.4), Vector2(4.4, -L - 0.8), Vector2(-4.4, -L - 0.8), Vector2(-6.4, -L + 0.4), Vector2(-5.6, -3.6)])
	shape(ci, bod, white)
	fill(ci, pts([Vector2(-4.8, 0.6), Vector2(-1.4, 0.6), Vector2(-2.4, -L), Vector2(-6.4, -L + 0.4), Vector2(-5.6, -3.6)]), white.darkened(0.14))
	# Gold waistcoat, black satin lapels, red bow tie.
	shape(ci, pts([Vector2(-2, -1.2), Vector2(2, -1.2), Vector2(2.2, -L + 1.4), Vector2(0, -L + 2.4), Vector2(-2.2, -L + 1.4)]), Color(0.85, 0.62, 0.2), K, 0.3)
	for i in 3:
		ci.draw_circle(Vector2(0.4, -2.4 - i * 1.5), 0.3, Color(0.3, 0.2, 0.05))
	fill(ci, pts([Vector2(-1.4, -L - 0.6), Vector2(1.4, -L - 0.6), Vector2(0, -L + 2.4)]), Color(0.97, 0.97, 0.95))
	shape(ci, pts([Vector2(-4.4, -L - 0.8), Vector2(-1.4, -L - 0.6), Vector2(-0.2, -3.2), Vector2(-3.4, -4.8)]), Color(0.08, 0.07, 0.1), K, 0.3)
	shape(ci, pts([Vector2(4.4, -L - 0.8), Vector2(1.4, -L - 0.6), Vector2(0.2, -3.2), Vector2(3.4, -4.8)]), Color(0.08, 0.07, 0.1), K, 0.3)
	ci.draw_line(Vector2(-4.3, -L - 0.6), Vector2(-0.4, -3.4), Color(1, 0.8, 0.3, 0.7), 0.25)
	ci.draw_line(Vector2(4.3, -L - 0.6), Vector2(0.4, -3.4), Color(1, 0.8, 0.3, 0.7), 0.25)
	shape(ci, pts([Vector2(-1.8, -L - 1.2), Vector2(0, -L - 0.4), Vector2(1.8, -L - 1.2), Vector2(1.8, -L + 0.2), Vector2(0, -L - 0.4), Vector2(-1.8, -L + 0.2)]), Color(0.8, 0.06, 0.12), K, 0.25)
	# Pocket watch chain and a gold-trimmed hem.
	ci.draw_polyline(pts([Vector2(-1.6, -2.6), Vector2(-3, -1.6), Vector2(-4.2, -2.4)]), Color(1, 0.8, 0.3), 0.3, true)
	ci.draw_line(Vector2(-4.8, 0.4), Vector2(4.8, 0.4), Color(1, 0.8, 0.3), 0.5)
	if phase >= 2:
		ci.draw_circle(Vector2(0, -L * 0.5), 6.0 + 1.5 * sin(t * 4.0), Color(1, 0.8, 0.3, 0.07 * phase))


static func _house_head(ci: CanvasItem, phase: int, t: float) -> void:
	var mask := Color(0.97, 0.96, 0.93)
	fill(ci, pts([Vector2(-1.4, 0.8), Vector2(1.4, 0.8), Vector2(1.2, -1.8), Vector2(-1.2, -1.8)]), Color(0.06, 0.05, 0.08))
	var face := pts([Vector2(-3.4, -1.6), Vector2(3.6, -1.6), Vector2(4.6, -5), Vector2(4.2, -9), Vector2(0.4, -10.6), Vector2(-3.4, -9.4), Vector2(-4.2, -5.6)])
	shape(ci, face, mask)
	fill(ci, pts([Vector2(-3.4, -1.6), Vector2(-1.2, -1.6), Vector2(-2.2, -7.6), Vector2(-4.2, -5.6)]), mask.darkened(0.12))
	# Gold filigree at the temple.
	ci.draw_arc(Vector2(-2.4, -7.4), 1.4, 0.4, 3.6, 10, Color(1, 0.8, 0.3), 0.3, true)
	ci.draw_arc(Vector2(-2.0, -5.2), 0.9, -1.0, 2.4, 8, Color(1, 0.8, 0.3), 0.3, true)
	# Eye holes with glowing $ pupils.
	var glow := 0.6 + 0.4 * sin(t * 3.0)
	for ex in [1.1, 3.3]:
		var ec := Vector2(ex, -6.0)
		fill(ci, ell(ec, 0.95, 0.65, 10), K)
		ci.draw_circle(ec, 1.6, Color(1, 0.8, 0.3, 0.18 * glow * phase))
		ci.draw_string(ThemeDB.fallback_font, ec + Vector2(-0.8, 0.6), "$", HORIZONTAL_ALIGNMENT_CENTER, 1.6, 2, Color(1, 0.85, 0.35, glow))
	ci.draw_arc(Vector2(2.4, -3.8), 1.6, 0.3, PI - 0.4, 10, Color(0.75, 0.06, 0.12), 0.45, true)
	if phase >= 2:
		# Cracks leaking gold light.
		var crack := pts([Vector2(0.4, -10.4), Vector2(0.9, -8.6), Vector2(0.1, -7.4), Vector2(1.0, -5.6), Vector2(0.5, -4.2)])
		ci.draw_polyline(crack, Color(1, 0.85, 0.35, 0.6 + 0.3 * glow), 0.8, true)
		ci.draw_polyline(crack, K, 0.3, true)
	if phase >= 3:
		# The right side of the mask has broken away: slot reels underneath.
		var hole := pts([Vector2(0.9, -9.0), Vector2(4.2, -9.0), Vector2(4.6, -5), Vector2(3.6, -2.2), Vector2(0.6, -3.0), Vector2(1.2, -5.4)])
		shape(ci, hole, Color(0.1, 0.04, 0.08), Color(1, 0.8, 0.3), 0.35)
		var syms := [Color(1, 0.2, 0.2), Color(1, 0.85, 0.3), Color(0.4, 0.9, 1)]
		for r in 3:
			var rx := 1.5 + r * 1.0
			fill(ci, pts([Vector2(rx - 0.4, -7.8), Vector2(rx + 0.4, -7.8), Vector2(rx + 0.4, -4.0), Vector2(rx - 0.4, -4.0)]), Color(0.95, 0.92, 0.85))
			var off := fmod(t * (6.0 + r * 2.0), 3.0)
			for j in 3:
				var sy := -7.4 + fmod(j * 1.3 + off * 1.3, 3.9)
				ci.draw_circle(Vector2(rx, sy), 0.28, syms[(j + r) % 3])
		ci.draw_circle(Vector2(2.4, -6), 4.0, Color(1, 0.75, 0.25, 0.12 + 0.08 * glow))
	# Top hat (floats above his head once the mask breaks).
	var lift := Vector2(0, -2.6 + sin(t * 2.0) * 0.8) if phase >= 3 else Vector2.ZERO
	var hb := Vector2(0.4, -10.0) + lift
	if phase >= 3:
		ci.draw_circle(hb + Vector2(0, -3), 5.0, Color(1, 0.8, 0.3, 0.15))
	shape(ci, ell(hb, 6.2, 1.1, 18), Color(0.07, 0.06, 0.09))
	shape(ci, pts([hb + Vector2(-3.6, -0.2), hb + Vector2(4.0, -0.2), hb + Vector2(3.6, -7.6), hb + Vector2(-3.2, -7.6)]), Color(0.08, 0.07, 0.1))
	var hue := Color.from_hsv(fmod(t * 0.25, 1.0), 0.8, 1.0)
	fill(ci, pts([hb + Vector2(-3.6, -0.4), hb + Vector2(4.0, -0.4), hb + Vector2(3.9, -1.8), hb + Vector2(-3.5, -1.8)]), Color(0.7, 0.05, 0.1))
	ci.draw_line(hb + Vector2(-3.5, -1.1), hb + Vector2(3.9, -1.1), Color(hue, 0.9), 0.35)
	shape(ci, pts([hb + Vector2(2.0, -1.8), hb + Vector2(3.6, -1.8), hb + Vector2(3.4, -4.4), hb + Vector2(1.8, -4.4)]), Color(0.98, 0.97, 0.94), K, 0.2)
	ci.draw_circle(hb + Vector2(2.7, -3.1), 0.35, K)
	ci.draw_line(hb + Vector2(-2.4, -7.2), hb + Vector2(-2.6, -1.6), Color(0.4, 0.4, 0.5, 0.6), 0.3)


## Head in head space (neck at the origin), used for the rig and portraits.
static func boss_head(ci: CanvasItem, tier: int, phase: int, t: float) -> void:
	match tier:
		1:
			_sal_head(ci, phase, t)
		2:
			_roulette_head(ci, phase, t)
		3:
			_house_head(ci, phase, t)


## Portrait for dialogue: the head scaled up, framed in the box.
static func boss_portrait(ci: CanvasItem, center: Vector2, tier: int, t: float, sc := 8.2) -> void:
	ci.draw_set_transform_matrix(Transform2D(0.0, Vector2(sc, sc), 0.0, center + Vector2(-8, 62) * (sc / 8.2)))
	match tier:
		1:
			_sal_torso_bust(ci)
		2:
			fill(ci, pts([Vector2(-6, 6), Vector2(6, 6), Vector2(5, 0.6), Vector2(-5, 0.6)]), Color(0.72, 0.06, 0.14))
		3:
			fill(ci, pts([Vector2(-6.4, 6), Vector2(6.4, 6), Vector2(5, 0.6), Vector2(-5, 0.6)]), Color(0.93, 0.91, 0.87))
			shape(ci, pts([Vector2(-1.8, 0.2), Vector2(0, 1.0), Vector2(1.8, 0.2), Vector2(1.8, 1.6), Vector2(0, 1.0), Vector2(-1.8, 1.6)]), Color(0.8, 0.06, 0.12), K, 0.25)
	boss_head(ci, tier, 1, t)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)


static func _sal_torso_bust(ci: CanvasItem) -> void:
	fill(ci, pts([Vector2(-7, 6), Vector2(7, 6), Vector2(6, 0.6), Vector2(-6, 0.6)]), Color(0.17, 0.17, 0.21))
	fill(ci, pts([Vector2(-2, 0.6), Vector2(2, 0.6), Vector2(0, 5)]), Color(0.95, 0.94, 0.9))
	fill(ci, pts([Vector2(-0.6, 0.8), Vector2(0.6, 0.8), Vector2(0.9, 5), Vector2(-0.9, 5)]), Color(0.78, 0.08, 0.12))


## NPC portraits (neck at the bottom of the box).
static func npc_portrait(ci: CanvasItem, center: Vector2, who: String, t: float, sc := 8.0) -> bool:
	ci.draw_set_transform_matrix(Transform2D(0.0, Vector2(sc, sc), 0.0, center + Vector2(0, 0)))
	match who:
		"VERA":
			fill(ci, pts([Vector2(-6, 8), Vector2(6, 8), Vector2(4.6, 2.4), Vector2(-4.6, 2.4)]), Color(0.62, 0.05, 0.13))
			fill(ci, pts([Vector2(-4.6, 2.4), Vector2(4.6, 2.4), Vector2(3.8, 0.6), Vector2(-3.8, 0.6)]), Color(0.95, 0.8, 0.72))
			vera_head(ci, Vector2(0, 4.6), t, fmod(t, 4.3) < 0.12)
		"MAGS":
			fill(ci, pts([Vector2(-7, 8), Vector2(7, 8), Vector2(5.2, 2.4), Vector2(-5.2, 2.4)]), Color(0.11, 0.13, 0.22))
			fill(ci, pts([Vector2(-2.2, 2.4), Vector2(2.2, 2.4), Vector2(0, 8)]), Color(0.95, 0.94, 0.9))
			fill(ci, pts([Vector2(-0.6, 2.6), Vector2(0.6, 2.6), Vector2(1, 8), Vector2(-1, 8)]), Color(0.8, 0.08, 0.14))
			mags_head(ci, Vector2(-3.0, 5.4), t)
		"LUCKY":
			var white := Color(0.95, 0.95, 0.92)
			fill(ci, pts([Vector2(-6.4, 8), Vector2(6.4, 8), Vector2(5.2, 2.6), Vector2(-5.2, 2.6)]), white)
			fill(ci, pts([Vector2(-6.4, 8), Vector2(-1.4, 8), Vector2(-1.6, 2.8), Vector2(-5.2, 2.6)]), Color(0.72, 0.1, 0.15))
			fill(ci, pts([Vector2(6.4, 8), Vector2(1.4, 8), Vector2(1.6, 2.8), Vector2(5.2, 2.6)]), Color(0.72, 0.1, 0.15))
			shape(ci, pts([Vector2(-1.8, 2.2), Vector2(0, 3.0), Vector2(1.8, 2.2), Vector2(1.8, 3.8), Vector2(0, 3.0), Vector2(-1.8, 3.8)]), K, K, 0.2)
			shape(ci, pts([Vector2(3.6, 2.6), Vector2(6, 3.0), Vector2(6.4, 8), Vector2(5, 8)]), Color(0.9, 0.88, 0.78), K, 0.3)
			lucky_head(ci, Vector2(0, 2.6), t)
		"JULES":
			var green := Color(0.16, 0.42, 0.26)
			fill(ci, pts([Vector2(-6.4, 8), Vector2(6.4, 8), Vector2(5, 2.6), Vector2(-5, 2.6)]), green)
			fill(ci, pts([Vector2(-2.6, 8), Vector2(2.6, 8), Vector2(2.4, 3.0), Vector2(-2.4, 3.0)]), Color(0.12, 0.1, 0.12))
			ci.draw_line(Vector2(0, 3.2), Vector2(0, 8), Color(0.95, 0.95, 0.9), 0.4)
			jules_head(ci, Vector2(0, 3.0), t)
		"ROOK", "DICE":
			var hood := Color(0.30, 0.18, 0.45) if who == "ROOK" else Color(0.15, 0.45, 0.55)
			fill(ci, pts([Vector2(-6.6, 8), Vector2(6.6, 8), Vector2(5.4, 2.4), Vector2(-5.4, 2.4)]), hood)
			ci.draw_line(Vector2(-1.4, 3.4), Vector2(-1.6, 8), Color(0.9, 0.9, 0.85, 0.8), 0.35)
			ci.draw_line(Vector2(1.4, 3.4), Vector2(1.6, 8), Color(0.9, 0.9, 0.85, 0.8), 0.35)
			runner_head(ci, Vector2(0, 3.0), t, hood)
		"MARLOW":
			marlow_bust(ci, t)
		"COMP":
			ci.draw_set_transform_matrix(Transform2D(0.0, Vector2(sc * 0.78, sc * 0.78), 0.0, center + Vector2(16, 72) * (sc / 8.0)))
			cat(ci, t)
		_:
			ci.draw_set_transform_matrix(Transform2D.IDENTITY)
			return false
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true


## The runner's head: hood up, gold eye-band mask, red scarf. `o` is the neck.
static func runner_head(ci: CanvasItem, o: Vector2, t: float, hood: Color) -> void:
	var skin := Color(0.93, 0.76, 0.62)
	shape(ci, ell(o + Vector2(0.2, -4.8), 4.9, 5.4, 22), hood)
	ci.draw_arc(o + Vector2(0.2, -4.8), 5.0, -2.4, -0.6, 12, hood.lightened(0.35), 0.5, true)
	fill(ci, ell(o + Vector2(0.9, -4.3), 3.6, 4.1, 18), hood.darkened(0.65))
	shape(ci, ell(o + Vector2(1.0, -3.9), 2.9, 3.4, 18), skin, K, 0.3)
	fill(ci, ell(o + Vector2(1.0, -2.4), 2.6, 1.6, 14), Color(0.3, 0.15, 0.2, 0.25))
	# Gold eye-band with two slits.
	shape(ci, pts([o + Vector2(-2.2, -5.9), o + Vector2(4.0, -5.9), o + Vector2(4.2, -4.5), o + Vector2(-2.2, -4.5)]), Color(1, 0.78, 0.25), K, 0.25)
	var blink := fmod(t, 3.9) < 0.12
	for ex in [-0.2, 2.2]:
		if blink:
			ci.draw_line(o + Vector2(ex - 0.6, -5.2), o + Vector2(ex + 0.6, -5.2), K, 0.3)
		else:
			fill(ci, ell(o + Vector2(ex, -5.2), 0.75, 0.35, 10), Color(0.98, 0.97, 0.9))
			ci.draw_circle(o + Vector2(ex + 0.2, -5.2), 0.25, K)
	ci.draw_line(o + Vector2(0.2, -2.0), o + Vector2(1.8, -2.1), Color(0.5, 0.25, 0.25), 0.3, true)
	# Scarf with a tail that flutters.
	shape(ci, pts([o + Vector2(-3.8, -1.2), o + Vector2(4.2, -1.2), o + Vector2(4.4, 0.8), o + Vector2(-3.8, 0.8)]), Color(0.78, 0.08, 0.15), K, 0.3)
	var tail := PackedVector2Array()
	for i in 7:
		var u := i / 6.0
		tail.append(o + Vector2(-3.4 - u * 3.2, 0.2 + u * 3.0 + sin(t * 5.0 + u * 4.0) * 0.5 * u))
	ci.draw_polyline(tail, Color(0.78, 0.08, 0.15), 1.4, true)


## Marlow, the fixer: trench coat, fedora brim low, radio mic, cigarette.
static func marlow_bust(ci: CanvasItem, t: float) -> void:
	var coat := Color(0.62, 0.5, 0.32)
	var skin := Color(0.86, 0.68, 0.55)
	fill(ci, pts([Vector2(-7, 8), Vector2(7, 8), Vector2(5.6, 2.2), Vector2(-5.6, 2.2)]), coat)
	fill(ci, pts([Vector2(-5.6, 2.2), Vector2(-1.6, 2.2), Vector2(-0.4, 8), Vector2(-3.2, 8), Vector2(-5.8, 4.6)]), coat.lightened(0.12))
	fill(ci, pts([Vector2(5.6, 2.2), Vector2(1.6, 2.2), Vector2(0.4, 8), Vector2(3.2, 8), Vector2(5.8, 4.6)]), coat.darkened(0.12))
	fill(ci, pts([Vector2(-1.6, 2.2), Vector2(1.6, 2.2), Vector2(0, 6)]), Color(0.2, 0.22, 0.28))
	var o := Vector2(0, 2.6)
	shape(ci, pts([o + Vector2(-3.2, -0.4), o + Vector2(3.2, -0.4), o + Vector2(3.7, -4.6), o + Vector2(3.1, -7.6), o + Vector2(-3.1, -7.6), o + Vector2(-3.7, -4.6)]), skin)
	# Half the face in shadow under the brim.
	fill(ci, pts([o + Vector2(-3.7, -4.6), o + Vector2(-3.1, -7.6), o + Vector2(3.1, -7.6), o + Vector2(3.7, -4.6), o + Vector2(0.4, -4.2)]), Color(0.12, 0.06, 0.08, 0.55))
	fill(ci, pts([o + Vector2(-3.2, -0.4), o + Vector2(3.2, -0.4), o + Vector2(3.5, -2.6), o + Vector2(-3.5, -2.6)]), Color(0.35, 0.28, 0.26, 0.35))
	ci.draw_circle(o + Vector2(-1.3, -4.9), 0.35, Color(1, 0.95, 0.75, 0.9))
	ci.draw_circle(o + Vector2(1.5, -4.9), 0.35, Color(1, 0.95, 0.75, 0.9))
	ci.draw_line(o + Vector2(-0.8, -1.8), o + Vector2(1.0, -1.9), Color(0.4, 0.2, 0.2), 0.3, true)
	# Cigarette with a glowing tip and a thread of smoke.
	ci.draw_line(o + Vector2(1.0, -1.9), o + Vector2(3.8, -1.4), Color(0.95, 0.94, 0.9), 0.5)
	var glow_a := 0.6 + 0.4 * sin(t * 2.3)
	ci.draw_circle(o + Vector2(3.9, -1.4), 0.4, Color(1, 0.45, 0.15, glow_a))
	smoke(ci, o + Vector2(4.0, -1.8), t, 4, 0.6)
	# Fedora.
	fill(ci, ell(o + Vector2(0, -7.6), 6.2, 1.2, 18), Color(0.22, 0.15, 0.1))
	shape(ci, pts([o + Vector2(-3.6, -7.8), o + Vector2(3.6, -7.8), o + Vector2(3.0, -11.0), o + Vector2(0.8, -10.4), o + Vector2(-0.8, -10.4), o + Vector2(-3.0, -11.0)]), Color(0.28, 0.19, 0.12))
	ci.draw_rect(Rect2(o + Vector2(-3.6, -8.8), Vector2(7.2, 1.0)), Color(0.08, 0.05, 0.04))
	# Radio mic in hand.
	limb(ci, Vector2(4.4, 8), Vector2(5.8, 4.6), 2.0, coat)
	shape(ci, pts([Vector2(4.8, 4.8), Vector2(7.2, 4.8), Vector2(7.2, 1.6), Vector2(4.8, 1.6)]), Color(0.15, 0.15, 0.17), K, 0.25)
	ci.draw_line(Vector2(6.6, 1.6), Vector2(7.0, -1.2), Color(0.5, 0.5, 0.55), 0.35)
	if int(t * 3.0) % 2 == 0:
		ci.draw_circle(Vector2(5.4, 2.2), 0.35, Color(1, 0.2, 0.2))


## A croupier standing behind a casino table (draw it before the table).
## `v` picks the look: 0 blackjack, 1 hold'em, 2 baccarat, 3 hi-lo, 4 roulette.
static func dealer(ci: CanvasItem, t: float, v: int) -> void:
	var skins := [Color(0.93, 0.76, 0.62), Color(0.72, 0.52, 0.38), Color(0.55, 0.38, 0.27), Color(0.95, 0.8, 0.7), Color(0.85, 0.66, 0.5)]
	var hairs := [Color(0.1, 0.07, 0.06), Color(0.55, 0.3, 0.12), Color(0.08, 0.06, 0.06), Color(0.85, 0.72, 0.4), Color(0.45, 0.45, 0.48)]
	var vests := [Color(0.08, 0.08, 0.1), Color(0.45, 0.05, 0.1), Color(0.1, 0.2, 0.42), Color(0.1, 0.3, 0.18), Color(0.3, 0.05, 0.25)]
	var skin: Color = skins[v % 5]
	var hair: Color = hairs[(v * 3 + 1) % 5]
	var vest: Color = vests[v % 5]
	var white := Color(0.95, 0.95, 0.92)
	var bob := sin(t * 1.6 + v) * 0.3
	ci.draw_set_transform(Vector2(0, bob))
	shape(ci, pts([Vector2(-5, -13), Vector2(5, -13), Vector2(4.6, -24), Vector2(-4.6, -24)]), white)
	shape(ci, pts([Vector2(-5, -13), Vector2(-1.1, -13), Vector2(-1.4, -23.4), Vector2(-4.6, -24)]), vest, K, 0.3)
	shape(ci, pts([Vector2(5, -13), Vector2(1.1, -13), Vector2(1.4, -23.4), Vector2(4.6, -24)]), vest, K, 0.3)
	for i in 2:
		ci.draw_circle(Vector2(-2.1, -19 + i * 2.6), 0.3, Color(1, 0.8, 0.3))
	shape(ci, pts([Vector2(-1.6, -24.6), Vector2(0, -23.9), Vector2(1.6, -24.6), Vector2(1.6, -23.2), Vector2(0, -23.9), Vector2(-1.6, -23.2)]), Color(0.75, 0.08, 0.14), K, 0.2)
	# Dealing: the left hand holds the deck, the right flicks cards out.
	var ph := fmod(t * 1.3 + v * 0.7, 1.0)
	var hand := Vector2(3.2 + ph * 4.0, -15.8 - sin(ph * PI) * 1.6)
	limb(ci, Vector2(-4.4, -23), Vector2(-6.2, -18.4), 1.8, white)
	limb(ci, Vector2(-6.2, -18.4), Vector2(-3.6, -15.8), 1.6, white)
	shape(ci, pts([Vector2(-5, -17.2), Vector2(-2.4, -17.2), Vector2(-2.4, -15.6), Vector2(-5, -15.6)]), Color(0.6, 0.08, 0.15), K, 0.25)
	ci.draw_circle(Vector2(-3.6, -15.6), 0.9, skin)
	limb(ci, Vector2(4.4, -23), Vector2(6.2, -18.6), 1.8, white)
	limb(ci, Vector2(6.2, -18.6), hand, 1.6, white)
	ci.draw_circle(hand, 0.9, skin)
	if ph < 0.6:
		var cp := hand + Vector2(1.2 + ph * 3.0, -0.6)
		shape(ci, pts([cp + Vector2(-0.9, -1.2), cp + Vector2(0.9, -1.2), cp + Vector2(0.9, 1.2), cp + Vector2(-0.9, 1.2)]), Color(0.98, 0.96, 0.92), K, 0.2)
	# Head.
	var o := Vector2(0, -24.4)
	shape(ci, pts([o + Vector2(-3.2, -0.4), o + Vector2(3.2, -0.4), o + Vector2(3.6, -4.6), o + Vector2(3.1, -8.0), o + Vector2(-3.1, -8.0), o + Vector2(-3.6, -4.6)]), skin)
	var blink := fmod(t + v, 3.6) < 0.12
	eye(ci, o + Vector2(-1.3, -4.6), 0.7, 0.42, Color(0.3, 0.22, 0.15), blink)
	eye(ci, o + Vector2(1.3, -4.6), 0.7, 0.42, Color(0.3, 0.22, 0.15), blink)
	ci.draw_line(o + Vector2(-0.8, -2.0), o + Vector2(0.8, -2.0), Color(0.55, 0.25, 0.25), 0.35, true)
	match v % 4:
		0:
			# Slicked back.
			shape(ci, pts([o + Vector2(-3.6, -5.6), o + Vector2(-3.4, -8.8), o + Vector2(0, -9.6), o + Vector2(3.4, -8.8), o + Vector2(3.6, -5.8), o + Vector2(2.6, -7.6), o + Vector2(-2.6, -7.6)]), hair)
		1:
			# Bun.
			shape(ci, pts([o + Vector2(-3.8, -4.4), o + Vector2(-3.6, -8.8), o + Vector2(0, -9.8), o + Vector2(3.6, -8.8), o + Vector2(3.8, -4.4), o + Vector2(2.8, -7.4), o + Vector2(-2.8, -7.4)]), hair)
			shape(ci, ell(o + Vector2(0, -10.6), 1.8, 1.4, 12), hair)
		2:
			# Short crop with a side part.
			shape(ci, pts([o + Vector2(-3.4, -6.4), o + Vector2(-3.2, -8.8), o + Vector2(1.0, -9.6), o + Vector2(3.4, -8.6), o + Vector2(3.4, -6.4), o + Vector2(-0.6, -7.8)]), hair)
		3:
			# Ponytail.
			shape(ci, pts([o + Vector2(-3.6, -5.0), o + Vector2(-3.4, -8.8), o + Vector2(0, -9.6), o + Vector2(3.4, -8.8), o + Vector2(3.6, -5.0), o + Vector2(2.6, -7.6), o + Vector2(-2.6, -7.6)]), hair)
			var tail := PackedVector2Array()
			for i in 6:
				var u := i / 5.0
				tail.append(o + Vector2(-3.4 - u * 1.6, -7.6 + u * 4.0 + sin(t * 2.0 + u * 3.0) * 0.3))
			ci.draw_polyline(tail, hair, 1.4, true)
	ci.draw_set_transform(Vector2.ZERO)
