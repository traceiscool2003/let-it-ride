extends Node2D
## Per-zone environment art, all drawn in code. One instance per layer, children of the level:
##   "back"  : 4 parallax depth layers + fog + light shafts + wall decals (z 0, over the wall paint)
##   "mid"   : set dressing standing on floors / hanging from ceilings (z 6, over the tiles)
##   "front" : 2 foreground parallax silhouettes + zone particles (rain, steam, embers, confetti...)
## Static helpers also draw tile materials, ambient occlusion and contact shadows for the TileLayer.
## Zones (level palette index): 0 Atlantic Shitty/Resortz, 1 Reno/Cirrcus, 2 Biloxi/Hard Rok,
## 3 Fremont/Goldun Nugget, 4 Alley, 5 Strip/Bellagiro.

const T := 16
const COL_RAT := Color(0.16, 0.14, 0.15)

var lvl
var layer := "back"
var t := 0.0
var items: Array = []          # [kind, Vector2 pos, seed(float 0..1), extra]
var wall_items: Array = []     # decals on the back wall
var parts: Array = []          # particles [pos, vel, life, size, seed]
var rats: Array = []
var boss_id := ""
var zone := 0
var W := 0.0
var H := 0.0


static func h1(a: int, b: int = 0) -> float:
	var v := ((a * 73856093) ^ (b * 19349663) ^ 0x5bd1e995) & 0xffff
	return float(v) / 65536.0


func setup(level, which: String) -> void:
	lvl = level
	layer = which
	zone = level.zone
	boss_id = level.boss_id
	W = float(level.w * T)
	H = float(level.h * T)
	match which:
		"back":
			z_index = 0
			_gen_wall_items()
		"mid":
			z_index = 6
			_gen_items()
		"ao":
			z_index = 1
		"front":
			z_index = 20
			var mat := CanvasItemMaterial.new()
			mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
			material = mat


func _process(delta: float) -> void:
	t += delta
	if layer == "front":
		_update_particles(delta)
	if layer == "mid":
		for r in rats:
			r[0] += r[1] * delta * 30.0
			if r[0] > r[3] or r[0] < r[2]:
				r[1] = -r[1]
	if layer != "ao":
		queue_redraw()


func _cam() -> Vector2:
	var c := get_viewport().get_camera_2d()
	if c:
		return c.get_screen_center_position()
	return Vector2(W * 0.5, H * 0.5)


func _view() -> Rect2:
	var c := get_viewport().get_camera_2d()
	var z := 3.0
	var ctr := Vector2(W * 0.5, H * 0.5)
	if c:
		z = c.zoom.x
		ctr = c.get_screen_center_position()
	var sz := get_viewport_rect().size / z
	return Rect2(ctr - sz * 0.5, sz).grow(24.0)


func _draw() -> void:
	if lvl == null or lvl.is_lobby:
		return
	match layer:
		"ao":
			ambient_occlusion(lvl, self)
		"back":
			_draw_back()
		"mid":
			_draw_mid()
		"front":
			_draw_front()


# ======================================================================= helpers

## Rect clipped to the level so silhouettes never spill into the void.
func _r(x: float, y: float, w: float, h: float, col: Color) -> void:
	var x0 := maxf(x, 0.0)
	var x1 := minf(x + w, W)
	var y0 := maxf(y, 0.0)
	var y1 := minf(y + h, H)
	if x1 > x0 and y1 > y0:
		draw_rect(Rect2(x0, y0, x1 - x0, y1 - y0), col)


func _vfade(rect: Rect2, c_top: Color, c_bot: Color) -> void:
	var rr := rect.intersection(Rect2(0, 0, W, H))
	if rr.size.x <= 0 or rr.size.y <= 0:
		return
	draw_polygon(PackedVector2Array([rr.position, Vector2(rr.end.x, rr.position.y), rr.end, Vector2(rr.position.x, rr.end.y)]),
		PackedColorArray([c_top, c_top, c_bot, c_bot]))


func _px(lx: float, f: float, cam: Vector2) -> float:
	return cam.x + (lx - cam.x) * f


func _poly(pts: Array, col: Color) -> void:
	draw_colored_polygon(PackedVector2Array(pts), col)


func _glow(c: Vector2, r: float, col: Color, n := 7) -> void:
	for i in n:
		var k := 1.0 - float(i) / n
		draw_circle(c, r * (0.25 + 0.75 * (1.0 - k) + 0.0), Color(col.r, col.g, col.b, col.a * 0.16 * k))


func _fog_col() -> Color:
	var P: Dictionary = lvl.pal()
	return (P["wall"] as Color).lerp(Color(0.5, 0.5, 0.6), 0.12)


# ======================================================================= BACK
func _draw_back() -> void:
	var cam := _cam()
	var vr := _view()
	var P: Dictionary = lvl.pal()
	var wall: Color = P["wall"]
	if lvl.is_boss:
		_boss_backdrop(cam, vr)
	else:
		# 4 parallax layers, far -> near, each fogged into the wall colour (atmospheric perspective).
		for li in 4:
			var f: float = [0.18, 0.34, 0.52, 0.72][li]
			var fogk: float = [0.78, 0.6, 0.42, 0.24][li]
			_layer(li, f, cam, vr)
			_vfade(Rect2(vr.position.x, vr.position.y, vr.size.x, vr.size.y), Color(wall.r, wall.g, wall.b, fogk * 0.34), Color(wall.r, wall.g, wall.b, fogk * 0.1))
		_wall_decals(vr)
	_shafts(cam, vr)


func _layer(li: int, f: float, cam: Vector2, vr: Rect2) -> void:
	# Layer art is laid out along x in "layer space" and projected with factor f.
	var span := vr.size.x / f
	var lx0 := cam.x - span * 0.5 - 40.0
	var lx1 := cam.x + span * 0.5 + 40.0
	var base := lerpf(cam.y + 62.0, H * 0.5 + 70.0, f * 0.4)
	var step: float = [52.0, 44.0, 36.0, 60.0][li]
	var i0 := int(floorf(lx0 / step))
	var i1 := int(ceilf(lx1 / step))
	var col := _layer_col(li)
	for i in range(i0, i1 + 1):
		var lx := float(i) * step
		var px := _px(lx, f, cam)
		if px < vr.position.x - 80.0 or px > vr.end.x + 80.0:
			continue
		var rn := h1(i, zone * 7 + li)
		var rn2 := h1(i + 91, zone * 3 + li)
		_layer_item(li, px, base, step * (f * 0.5 + 0.55), rn, rn2, col, i)


func _layer_col(li: int) -> Color:
	var P: Dictionary = lvl.pal()
	var m: Color = P["motif"]
	var w: Color = P["wall"]
	return w.lerp(m, 0.55 + 0.1 * li).lightened(0.02 + 0.015 * li)


func _layer_item(li: int, x: float, base: float, sw: float, rn: float, rn2: float, col: Color, i: int) -> void:
	var tw := (0.0 if t == 0.0 else t)
	match zone:
		4:   # alley: skyline, water tanks, fire-escape brick, hanging cables
			match li:
				0:
					var bh := 60.0 + rn * 120.0
					_r(x, base - bh, sw * 0.9, bh + 400.0, col)
					for wy in range(int(base - bh + 8), int(base), 11):
						for wx in range(int(x + 5), int(x + sw * 0.9 - 5), 9):
							if h1(wx, wy) < 0.3:
								_r(wx, wy, 3, 4, Color(1.0, 0.8, 0.45, 0.2 + 0.15 * h1(wx + 1, wy)))
				1:
					var bh2 := 40.0 + rn * 80.0
					_r(x, base - bh2, sw, bh2 + 400.0, col)
					if rn2 < 0.35:   # water tank on stilts
						_r(x + sw * 0.3, base - bh2 - 20.0, 16, 14, col.lightened(0.04))
						_r(x + sw * 0.3 + 2, base - bh2 - 6.0, 2, 6, col)
						_r(x + sw * 0.3 + 12, base - bh2 - 6.0, 2, 6, col)
					for wy in range(int(base - bh2 + 6), int(base), 13):
						if h1(i, wy) < 0.4:
							_r(x + 5, wy, 5, 6, Color(0.9, 0.7, 0.4, 0.25))
				2:
					var bh3 := 90.0 + rn * 60.0
					_r(x, base - bh3, sw, bh3 + 400.0, col)
					if rn2 < 0.5:   # fire escape zig-zag
						for k in 4:
							var yy := base - bh3 + 14.0 + k * 22.0
							_r(x + 3, yy, sw - 6, 2, col.lightened(0.12))
							draw_line(Vector2(x + 4 + (k % 2) * (sw - 10), yy), Vector2(x + 4 + ((k + 1) % 2) * (sw - 10), yy + 22.0), col.lightened(0.1), 1.0)
				3:
					if rn < 0.5:   # cables sagging
						var y0 := base - 170.0 + rn2 * 60.0
						draw_polyline(PackedVector2Array([Vector2(x, y0), Vector2(x + sw * 0.5, y0 + 10.0), Vector2(x + sw, y0)]), col.darkened(0.2), 1.0)
		0:   # Atlantic Shitty: boardwalk windows, arches, slot rows, columns
			match li:
				0:
					_r(x, base - 150.0, sw * 0.9, 120.0, Color(0.2, 0.32, 0.45, 0.35))
					_r(x, base - 150.0, sw * 0.9, 1.5, col.lightened(0.15))
					_r(x, base - 40.0, sw * 0.9, 12.0, Color(0.15, 0.2, 0.3, 0.5))
					if rn < 0.3:
						draw_arc(Vector2(x + sw * 0.4, base - 90.0), 22.0, 0, TAU, 20, Color(0.6, 0.55, 0.4, 0.2), 1.0)   # ferris wheel
				1:
					_poly([Vector2(x, base), Vector2(x, base - 70.0), Vector2(x + sw * 0.5, base - 96.0), Vector2(x + sw, base - 70.0), Vector2(x + sw, base)], col)
				2:
					_r(x + 3, base - 36.0, sw - 6, 36, col.lightened(0.03))
					_r(x + 6, base - 32.0, sw - 12, 3, Color(1.0, 0.3, 0.5, 0.14 + 0.1 * sin(tw * 3.0 + i)))
					_r(x + 6, base - 26.0, sw - 12, 20, col.darkened(0.2))
				3:
					_r(x, base - 190.0, 9, 220.0, col.lightened(0.06))
					_r(x - 2, base - 190.0, 13, 4, col.lightened(0.12))
		1:   # Reno carnival
			match li:
				0:
					var stripe := int(i) % 2 == 0
					_poly([Vector2(x, base - 120.0), Vector2(x + sw, base - 120.0), Vector2(x + sw, base + 120.0), Vector2(x, base + 120.0)], Color(0.55, 0.12, 0.14, 0.4) if stripe else Color(0.8, 0.7, 0.5, 0.22))
				1:
					if rn < 0.3:   # ferris wheel
						var c := Vector2(x + sw * 0.5, base - 70.0)
						draw_arc(c, 48.0, 0, TAU, 28, col.lightened(0.18), 1.5)
						for k in 8:
							var a := tw * 0.15 + k * TAU / 8.0
							draw_line(c, c + Vector2.from_angle(a) * 48.0, col.lightened(0.12), 1.0)
							draw_circle(c + Vector2.from_angle(a) * 48.0, 3.0, Color(1.0, 0.8, 0.4, 0.5))
				2:
					var by := base - 140.0 + sin(x * 0.05) * 6.0
					draw_line(Vector2(x, by), Vector2(x + sw, by + 8.0), col.lightened(0.1), 1.0)   # bunting
					_poly([Vector2(x + 4, by + 1), Vector2(x + sw * 0.5, by + 3), Vector2(x + sw * 0.25, by + 16.0)], [Color(0.9, 0.25, 0.3, 0.5), Color(0.95, 0.8, 0.3, 0.5), Color(0.3, 0.6, 0.9, 0.5)][i % 3])
				3:
					if rn < 0.4:   # balloons
						var by2 := base - 100.0 - rn * 60.0 + sin(tw + i) * 4.0
						draw_circle(Vector2(x, by2), 7.0, [Color(0.9, 0.2, 0.3, 0.55), Color(0.3, 0.7, 0.95, 0.55), Color(0.95, 0.8, 0.2, 0.55)][i % 3])
						draw_line(Vector2(x, by2 + 7.0), Vector2(x + 2, by2 + 38.0), Color(0.8, 0.8, 0.8, 0.3), 1.0)
		2:   # Biloxi Hard Rok: stage rigs, gulf windows, amps/guitars, wood posts
			match li:
				0:
					_r(x, base - 150.0, sw * 0.9, 110.0, Color(0.9, 0.5, 0.2, 0.18))   # sunset gulf
					_r(x, base - 60.0, sw * 0.9, 26.0, Color(0.1, 0.25, 0.4, 0.4))
				1:
					_r(x, base - 130.0, 3, 130.0, col.lightened(0.1))
					_r(x - 6, base - 134.0, 16, 6, col.lightened(0.14))
				2:
					if rn < 0.5:   # amp stack
						_r(x, base - 44.0, 18, 44, col.lightened(0.04))
						draw_circle(Vector2(x + 9, base - 32.0), 4.0, col.darkened(0.3))
						draw_circle(Vector2(x + 9, base - 14.0), 5.0, col.darkened(0.3))
					else:   # guitar
						draw_circle(Vector2(x + 6, base - 14.0), 7.0, col.lightened(0.12))
						_r(x + 5, base - 50.0, 2, 38, col.lightened(0.12))
				3:
					_r(x, base - 170.0, 8, 200.0, Color(0.12, 0.07, 0.05, 0.85))
		3:   # Fremont: neon canopy, gold arches, shark tank, pillars
			match li:
				0:
					_r(x, base - 160.0, sw, 18.0, Color(1.0, 0.7, 0.2, 0.1 + 0.05 * sin(tw * 2.0 + i)))
					_r(x, base - 140.0, sw, 1.5, Color(1.0, 0.85, 0.4, 0.3))
				1:
					draw_arc(Vector2(x + sw * 0.5, base - 30.0), sw * 0.5, PI, TAU, 14, Color(0.95, 0.75, 0.3, 0.3), 2.0)
				2:
					if i % 4 == 0:   # shark tank panel
						_r(x, base - 90.0, sw * 3.0, 70.0, Color(0.1, 0.3, 0.45, 0.45))
						_r(x, base - 90.0, sw * 3.0, 2.0, Color(0.9, 0.75, 0.3, 0.5))
						var sx := x + fposmod(tw * 14.0 + i * 31.0, sw * 3.0 - 20.0)
						_poly([Vector2(sx, base - 55.0), Vector2(sx + 12, base - 59.0), Vector2(sx + 22, base - 55.0), Vector2(sx + 12, base - 51.0)], Color(0.05, 0.12, 0.2, 0.8))
						_poly([Vector2(sx + 8, base - 59.0), Vector2(sx + 12, base - 66.0), Vector2(sx + 15, base - 58.0)], Color(0.05, 0.12, 0.2, 0.8))
				3:
					_r(x, base - 190.0, 8, 220.0, Color(0.2, 0.15, 0.06, 0.8))
					_r(x + 1, base - 190.0, 2, 220.0, Color(1.0, 0.85, 0.4, 0.25))
		5:   # The Strip: chandelier clusters, marble columns, fountain arcs, hedges
			match li:
				0:
					if rn < 0.5:
						var c0 := Vector2(x, base - 160.0 + rn * 20.0)
						_glow(c0, 22.0, Color(1.0, 0.85, 0.5, 0.5), 5)
						for k in 7:
							draw_circle(c0 + Vector2(-12 + k * 4, 6 + absf(k - 3) * -1.5), 1.2, Color(1, 0.95, 0.8, 0.7))
				1:
					_r(x, base - 160.0, 9, 190.0, Color(0.75, 0.72, 0.8, 0.14))
					_r(x - 2, base - 160.0, 13, 5, Color(0.9, 0.8, 0.5, 0.2))
				2:
					if i % 3 == 0:   # fountain jets
						for k in 5:
							var a0 := -PI * 0.5 + (k - 2) * 0.25
							var pts := PackedVector2Array()
							for s in 8:
								var tt := s / 7.0
								pts.append(Vector2(x + 12 + cos(a0) * 46.0 * tt, base - 4.0 - sin(-a0) * 60.0 * tt + 60.0 * tt * tt))
							draw_polyline(pts, Color(0.7, 0.9, 1.0, 0.22 + 0.08 * sin(tw * 4.0 + k)), 1.0)
				3:
					var hh := 30.0 + rn * 14.0
					draw_circle(Vector2(x + 14, base - hh * 0.5), hh * 0.5, Color(0.08, 0.2, 0.12, 0.55))
					_r(x + 12, base - 4.0, 4, 8, Color(0.1, 0.07, 0.05, 0.6))


func _wall_decals(vr: Rect2) -> void:
	for it in wall_items:
		var p: Vector2 = it[1]
		if not vr.has_point(p):
			continue
		var rn: float = it[2]
		match String(it[0]):
			"stain":
				draw_circle(p, 5.0 + rn * 7.0, Color(0, 0, 0, 0.12))
				draw_circle(p + Vector2(2, 3), 3.0 + rn * 4.0, Color(0, 0, 0, 0.1))
			"leak":   # water-stained ceiling streak
				_vfade(Rect2(p.x - 4, p.y, 8, 34.0 + rn * 30.0), Color(0.3, 0.25, 0.1, 0.22), Color(0.3, 0.25, 0.1, 0.0))
			"poster":
				var pc := Color.from_hsv(rn, 0.5, 0.55)
				draw_rect(Rect2(p + Vector2(-7, -10), Vector2(14, 20)), Color(0.9, 0.85, 0.7, 0.55))
				draw_rect(Rect2(p + Vector2(-5, -8), Vector2(10, 9)), Color(pc, 0.7))
				draw_rect(Rect2(p + Vector2(-5, 3), Vector2(10, 1)), Color(0.2, 0.2, 0.2, 0.5))
				draw_rect(Rect2(p + Vector2(-5, 6), Vector2(7, 1)), Color(0.2, 0.2, 0.2, 0.4))
				draw_rect(Rect2(p + Vector2(7, -10), Vector2(2, 20)), Color(0, 0, 0, 0.12))
			"graffiti":
				var gc := Color.from_hsv(rn, 0.7, 0.85, 0.5)
				draw_polyline(PackedVector2Array([p, p + Vector2(5, -8), p + Vector2(9, 0), p + Vector2(13, -8), p + Vector2(18, 0)]), gc, 1.6)
				draw_arc(p + Vector2(8, -14), 4.0, 0.0, TAU, 10, gc, 1.2)
			"pipe":
				draw_rect(Rect2(p.x - 1.5, p.y, 3, 48.0 + rn * 40.0), Color(0.12, 0.1, 0.1, 0.8))
				draw_rect(Rect2(p.x - 1.5, p.y, 1, 48.0 + rn * 40.0), Color(0.4, 0.38, 0.35, 0.4))
			"escape":
				for k in 3:
					var yy := p.y + k * 20.0
					draw_rect(Rect2(p.x, yy, 28, 2), Color(0.1, 0.09, 0.09, 0.9))
					draw_line(Vector2(p.x + (k % 2) * 28.0, yy), Vector2(p.x + ((k + 1) % 2) * 28.0, yy + 20.0), Color(0.12, 0.11, 0.11, 0.9), 1.4)
					draw_line(Vector2(p.x, yy - 6), Vector2(p.x + 28, yy - 6), Color(0.14, 0.13, 0.12, 0.8), 1.0)
			"window":   # boardwalk / gulf window
				draw_rect(Rect2(p + Vector2(-12, -14), Vector2(24, 28)), Color(0.05, 0.04, 0.05))
				var sky := Color(0.15, 0.3, 0.5) if zone != 2 else Color(0.8, 0.4, 0.2)
				_vfade(Rect2(p + Vector2(-10, -12), Vector2(20, 24)), sky.lightened(0.15), sky.darkened(0.3))
				draw_rect(Rect2(p + Vector2(-10, 4), Vector2(20, 8)), Color(0.08, 0.16, 0.28, 0.8))
				draw_line(p + Vector2(0, -12), p + Vector2(0, 12), Color(0.05, 0.04, 0.05), 1.5)
			"stripe":
				draw_rect(Rect2(p.x - 6, p.y, 12, 150.0), Color(0.55, 0.12, 0.15, 0.28))
			"clown":
				draw_circle(p, 9.0, Color(0.9, 0.85, 0.8, 0.5))
				draw_circle(p + Vector2(0, 1), 2.5, Color(0.9, 0.15, 0.2, 0.8))
				draw_circle(p + Vector2(-3, -2), 1.1, Color(0.1, 0.1, 0.1, 0.8))
				draw_circle(p + Vector2(3, -2), 1.1, Color(0.1, 0.1, 0.1, 0.8))
				draw_arc(p + Vector2(0, 3), 4.0, 0.2, PI - 0.2, 8, Color(0.9, 0.15, 0.2, 0.7), 1.2)
				draw_colored_polygon(PackedVector2Array([p + Vector2(-8, -4), p + Vector2(-4, -11), p + Vector2(-1, -7)]), Color(0.3, 0.7, 0.9, 0.6))
				draw_colored_polygon(PackedVector2Array([p + Vector2(8, -4), p + Vector2(4, -11), p + Vector2(1, -7)]), Color(0.9, 0.3, 0.5, 0.6))
			"marble":
				draw_polyline(PackedVector2Array([p, p + Vector2(6, 10), p + Vector2(3, 22), p + Vector2(10, 34)]), Color(0.8, 0.8, 0.9, 0.1), 1.0)


func _gen_wall_items() -> void:
	# decals scattered over the back wall, deterministic from the level seed
	var n := int(lvl.w * lvl.h / 18)
	for k in n:
		var gx := int(h1(k, 3) * (lvl.w - 4)) + 2
		var gy := int(h1(k, 5) * (lvl.h - 4)) + 2
		if lvl.get_cell(gx, gy) != lvl.EMPTY:
			continue
		var p := Vector2(gx * T + 8, gy * T + 8)
		var rn := h1(k, 9)
		var kinds: Array = []
		match zone:
			4:
				kinds = ["stain", "poster", "graffiti", "pipe", "escape", "stain", "graffiti"]
			0:
				kinds = ["leak", "stain", "window", "poster", "leak"]
			1:
				kinds = ["stripe", "clown", "poster", "stripe"]
			2:
				kinds = ["window", "poster", "stain"]
			3:
				kinds = ["marble", "poster", "stain"]
			5:
				kinds = ["marble", "marble", "poster"]
		if kinds.is_empty():
			continue
		var kind: String = kinds[int(rn * kinds.size()) % kinds.size()]
		if kind in ["leak", "pipe", "stripe"]:
			# hang from the ceiling of the room
			var cy := gy
			while cy > 0 and lvl.get_cell(gx, cy - 1) == lvl.EMPTY:
				cy -= 1
			p.y = cy * T
		wall_items.append([kind, p, h1(k, 17)])


# ======================================================================= MID
func _gen_items() -> void:
	items.clear()
	rats.clear()
	var W2: int = lvl.w
	var H2: int = lvl.h
	var avoid: Array = []
	for g in lvl.games:
		avoid.append(g[0])
	for s in lvl.slots:
		avoid.append(s)
	for ps in lvl.prop_spots:
		avoid.append(ps[0])
	for gm in lvl.lamps:
		avoid.append(gm)
	avoid.append(lvl.start_pos)
	avoid.append(lvl.exit_pos)
	if lvl.is_boss:
		_gen_boss_items()
		return
	for y in range(2, H2 - 1):
		for x in range(1, W2 - 1):
			if lvl.get_cell(x, y) != lvl.EMPTY:
				continue
			var below: int = lvl.get_cell(x, y + 1)
			var above: int = lvl.get_cell(x, y - 1)
			var rn := h1(x, y * 3 + 1)
			var pos := Vector2(x * T + 8, (y + 1) * T)
			var ok := true
			for a in avoid:
				if pos.distance_to(a) < 22.0:
					ok = false
					break
			if not ok:
				continue
			if below == lvl.SOLID and rn < 0.2:
				var k := _floor_kind(rn * 5.0, x, y)
				if k != "":
					items.append([k, pos, h1(x, y + 77), 0])
					if k == "rat":
						rats.append([pos.x, 1.0, pos.x - 22.0, pos.x + 22.0, pos.y, items.size() - 1])
			elif above == lvl.SOLID and rn > 0.93:
				var ck := _ceil_kind()
				if ck != "":
					items.append([ck, Vector2(x * T + 8, y * T), h1(x, y + 33), 0])


func _floor_kind(r: float, x: int, y: int) -> String:
	var opts: Array = []
	match zone:
		4:
			opts = ["dumpster", "trash", "crate", "puddle", "vent", "rat", "barrel", "puddle", "trash"]
		0:
			opts = ["palm", "stool", "bucket", "rope", "carpet", "palm", "stool"]
		1:
			opts = ["popcorn", "balloons", "pole", "horse", "stool", "balloons"]
		2:
			opts = ["amp", "guitar", "speaker", "chair", "amp", "drum"]
		3:
			opts = ["planter", "rope", "stool", "arrow", "planter"]
		5:
			opts = ["urn", "topiary", "statue", "fountain", "urn", "topiary"]
	if opts.is_empty():
		return ""
	return opts[int(r * 7.3 + h1(x, y) * 9.0) % opts.size()]


func _ceil_kind() -> String:
	return ["pipe_h", "chandelier", "lantern", "cable", "chandelier", "chandelier"][clampi(zone, 0, 5)]


func _gen_boss_items() -> void:
	# stage dressing: speaker/stage props along the floor, a table silhouette in the centre
	var fy := float((lvl.h - 1) * T)
	items.append(["table", Vector2(W * 0.5, fy), 0.5, 0])
	for k in 4:
		items.append(["chair_b", Vector2(W * (0.38 + k * 0.08), fy), h1(k, 4), 0])
	items.append(["stage_lights", Vector2(W * 0.5, T * 2), 0.0, 0])
	for k in 3:
		items.append(["curtain", Vector2(2 * T + k * 5, T), float(k), 0])
		items.append(["curtain", Vector2(W - 2 * T - k * 5, T), float(k) + 10.0, 0])


func _draw_mid() -> void:
	var vr := _view()
	for it in items:
		var p: Vector2 = it[1]
		if not vr.has_point(p):
			continue
		_draw_item(String(it[0]), p, float(it[2]), it)
	for r in rats:
		var p2 := Vector2(r[0], r[4])
		if vr.has_point(p2):
			var d: float = r[1]
			var skit := sin(t * 18.0) * 0.8
			draw_rect(Rect2(p2.x - 4 * d if d > 0 else p2.x - 4, p2.y - 4 + skit * 0.3, 8, 3.4), COL_RAT)
			draw_circle(p2 + Vector2(4 * d, -2.5), 1.6, COL_RAT)
			draw_line(p2 + Vector2(-4 * d, -2), p2 + Vector2(-9 * d, -3 + skit), COL_RAT, 0.8)
			draw_rect(Rect2(p2.x + 4 * d - 0.5, p2.y - 3.3, 1, 1), Color(1, 0.2, 0.2, 0.8))


func _draw_item(kind: String, p: Vector2, rn: float, it: Array) -> void:
	match kind:
		"dumpster":
			_r(p.x - 14, p.y - 15, 28, 15, Color(0.1, 0.22, 0.14))
			_r(p.x - 15, p.y - 17, 30, 3, Color(0.07, 0.15, 0.1))
			_r(p.x - 14, p.y - 15, 28, 1, Color(0.3, 0.5, 0.36, 0.5))
			_r(p.x - 12, p.y - 11, 24, 1, Color(0, 0, 0, 0.3))
			_r(p.x - 13, p.y - 2, 3, 2, Color(0.04, 0.04, 0.04))
			_r(p.x + 10, p.y - 2, 3, 2, Color(0.04, 0.04, 0.04))
			if rn > 0.5:   # spilling trash
				draw_circle(p + Vector2(8, -17), 3.5, Color(0.2, 0.2, 0.22))
		"trash":
			for k in 2:
				var q := p + Vector2(-5 + k * 8, 0)
				draw_circle(q + Vector2(0, -5), 5.0, Color(0.05, 0.05, 0.06))
				draw_circle(q + Vector2(-1.5, -6.5), 1.6, Color(0.3, 0.3, 0.34, 0.55))
				draw_rect(Rect2(q.x - 1, q.y - 11, 2, 3), Color(0.05, 0.05, 0.06))
		"crate":
			_r(p.x - 7, p.y - 13, 14, 13, Color(0.3, 0.2, 0.1))
			_r(p.x - 7, p.y - 13, 14, 2, Color(0.4, 0.28, 0.14))
			draw_line(p + Vector2(-7, -13), p + Vector2(7, 0), Color(0.2, 0.12, 0.06), 1.0)
		"puddle":
			var wob := 0.5 + 0.5 * sin(t * 2.0 + rn * 6.0)
			draw_rect(Rect2(p.x - 10, p.y - 1.5, 20, 1.5), Color(0.25, 0.3, 0.45, 0.55))
			draw_rect(Rect2(p.x - 6, p.y - 1.5, 12, 1), Color(1.0, 0.75, 0.4, 0.25 * wob))   # neon reflection
			draw_rect(Rect2(p.x - 3 + sin(t * 3.0 + rn * 5.0) * 3.0, p.y - 1.5, 3, 1), Color(0.9, 0.95, 1.0, 0.3))
		"vent":
			_r(p.x - 6, p.y - 3, 12, 3, Color(0.12, 0.12, 0.13))
			for k in 4:
				var ph := fposmod(t * 0.7 + rn * 3.0 + k * 0.25, 1.0)
				draw_circle(p + Vector2(sin(ph * 9.0 + k) * 4.0, -4.0 - ph * 30.0), 3.0 + ph * 7.0, Color(0.8, 0.82, 0.85, 0.22 * (1.0 - ph)))
		"barrel":
			_r(p.x - 6, p.y - 15, 12, 15, Color(0.25, 0.1, 0.07))
			_r(p.x - 6, p.y - 11, 12, 1, Color(0.1, 0.05, 0.04))
			_r(p.x - 6, p.y - 5, 12, 1, Color(0.1, 0.05, 0.04))
			var fl := 0.7 + 0.3 * sin(t * 17.0 + rn * 7.0) * sin(t * 9.0)
			_poly([p + Vector2(-4, -15), p + Vector2(0, -24.0 * fl), p + Vector2(4, -15)], Color(1.0, 0.55, 0.12, 0.9))
			_poly([p + Vector2(-2, -15), p + Vector2(0, -19.0 * fl), p + Vector2(2, -15)], Color(1.0, 0.9, 0.5, 0.9))
			_glow(p + Vector2(0, -16), 22.0, Color(1.0, 0.55, 0.2, 0.5), 6)
		"rat":
			pass
		"palm":
			_r(p.x - 4, p.y - 6, 8, 6, Color(0.5, 0.25, 0.15))
			for k in 5:
				var a := -PI * 0.5 + (k - 2) * 0.55
				draw_line(p + Vector2(0, -6), p + Vector2(0, -6) + Vector2.from_angle(a) * 12.0 + Vector2(0, 3), Color(0.1, 0.32, 0.16), 2.0)
		"stool":
			draw_rect(Rect2(p.x - 4, p.y - 9, 8, 2), Color(0.5, 0.1, 0.14))
			draw_line(p + Vector2(0, -7), p + Vector2(0, 0), Color(0.6, 0.6, 0.66), 1.0)
			draw_line(p + Vector2(-4, 0), p + Vector2(4, 0), Color(0.6, 0.6, 0.66), 1.0)
		"bucket":
			_r(p.x - 4, p.y - 7, 8, 7, Color(0.45, 0.5, 0.55))
			var ph2 := fposmod(t * 1.1 + rn * 3.0, 1.0)
			draw_circle(Vector2(p.x, p.y - 60.0 + ph2 * 52.0), 1.0, Color(0.5, 0.7, 0.95, 0.8))
		"rope":
			for k in 2:
				draw_line(p + Vector2(-9 + k * 18, 0), p + Vector2(-9 + k * 18, -11), Color(0.8, 0.65, 0.25), 1.6)
				draw_circle(p + Vector2(-9 + k * 18, -12), 1.6, Color(0.95, 0.8, 0.35))
			draw_polyline(PackedVector2Array([p + Vector2(-9, -10), p + Vector2(0, -6), p + Vector2(9, -10)]), Color(0.6, 0.1, 0.15), 1.4)
		"carpet":
			_r(p.x - 12, p.y - 1.5, 24, 1.5, Color(0.35, 0.05, 0.08, 0.7))
		"popcorn":
			_r(p.x - 8, p.y - 14, 16, 10, Color(0.85, 0.2, 0.22))
			for k in 4:
				_r(p.x - 8 + k * 4, p.y - 14, 2, 10, Color(0.95, 0.9, 0.8))
			_poly([p + Vector2(-9, -14), p + Vector2(0, -22), p + Vector2(9, -14)], Color(0.9, 0.2, 0.25))
			draw_circle(p + Vector2(-5, -4), 2.5, Color(0.2, 0.1, 0.08))
			draw_circle(p + Vector2(5, -4), 2.5, Color(0.2, 0.1, 0.08))
		"balloons":
			for k in 3:
				var bp := p + Vector2(-5 + k * 5, -22.0 - k * 3 + sin(t * 1.2 + k) * 1.5)
				draw_line(p + Vector2(0, -2), bp + Vector2(0, 4), Color(0.8, 0.8, 0.8, 0.5), 0.8)
				draw_circle(bp, 4.5, [Color(0.95, 0.25, 0.3), Color(0.3, 0.7, 0.95), Color(0.95, 0.85, 0.25)][k])
				draw_circle(bp + Vector2(-1.5, -1.5), 1.2, Color(1, 1, 1, 0.5))
		"pole":
			for k in 5:
				_r(p.x - 3, p.y - 40 + k * 8, 6, 8, Color(0.85, 0.2, 0.25) if k % 2 == 0 else Color(0.95, 0.92, 0.85))
		"horse":   # a tired carousel horse, drooping
			var bob := sin(t * 0.8 + rn * 5.0) * 1.0
			draw_line(p + Vector2(0, 0), p + Vector2(0, -22), Color(0.85, 0.7, 0.3), 1.5)
			_r(p.x - 8, p.y - 18 + bob, 16, 7, Color(0.8, 0.78, 0.74))
			_r(p.x + 5, p.y - 24 + bob, 5, 8, Color(0.8, 0.78, 0.74))
			draw_line(p + Vector2(-6, -11 + bob), p + Vector2(-7, -3), Color(0.8, 0.78, 0.74), 1.5)
			draw_line(p + Vector2(5, -11 + bob), p + Vector2(7, -3), Color(0.8, 0.78, 0.74), 1.5)
			_r(p.x - 1, p.y - 20 + bob, 4, 3, Color(0.85, 0.2, 0.3))
		"amp":
			_r(p.x - 8, p.y - 18, 16, 18, Color(0.08, 0.07, 0.07))
			_r(p.x - 8, p.y - 18, 16, 2, Color(0.5, 0.42, 0.3))
			draw_circle(p + Vector2(0, -8), 4.5, Color(0.2, 0.2, 0.22))
			draw_circle(p + Vector2(0, -8), 1.5, Color(0.05, 0.05, 0.06))
			draw_circle(p + Vector2(5, -16), 0.8, Color(0.9, 0.2, 0.15))
		"guitar":
			draw_line(p + Vector2(0, 0), p + Vector2(0, -6), Color(0.15, 0.15, 0.17), 1.0)
			draw_circle(p + Vector2(0, -9), 4.5, Color(0.65, 0.2, 0.1))
			draw_circle(p + Vector2(0, -15), 3.2, Color(0.65, 0.2, 0.1))
			draw_line(p + Vector2(0, -17), p + Vector2(0, -30), Color(0.35, 0.2, 0.1), 1.8)
			draw_rect(Rect2(p.x - 2, p.y - 33, 4, 4), Color(0.2, 0.12, 0.07))
		"speaker":
			_r(p.x - 6, p.y - 24, 12, 24, Color(0.05, 0.05, 0.06))
			draw_circle(p + Vector2(0, -8), 3.5 + sin(t * 14.0) * 0.4, Color(0.18, 0.18, 0.2))
			draw_circle(p + Vector2(0, -18), 2.2, Color(0.18, 0.18, 0.2))
		"chair":
			_r(p.x - 6, p.y - 8, 12, 5, Color(0.28, 0.1, 0.06))
			_r(p.x - 6, p.y - 16, 3, 8, Color(0.25, 0.08, 0.05))
			_r(p.x - 6, p.y - 3, 2, 3, Color(0.1, 0.05, 0.03))
			_r(p.x + 4, p.y - 3, 2, 3, Color(0.1, 0.05, 0.03))
		"drum":
			_r(p.x - 7, p.y - 10, 14, 10, Color(0.6, 0.1, 0.12))
			_r(p.x - 7, p.y - 10, 14, 2, Color(0.8, 0.8, 0.85))
			draw_line(p + Vector2(7, -16), p + Vector2(12, -22), Color(0.8, 0.8, 0.5), 1.0)
		"planter":
			_r(p.x - 6, p.y - 8, 12, 8, Color(0.75, 0.55, 0.15))
			_r(p.x - 6, p.y - 8, 12, 1, Color(1.0, 0.9, 0.5))
			draw_circle(p + Vector2(0, -12), 6.0, Color(0.12, 0.35, 0.18))
			draw_circle(p + Vector2(-3, -14), 3.0, Color(0.18, 0.45, 0.25))
		"arrow":
			var on := int(t * 3.0 + rn * 4.0) % 3
			for k in 3:
				_poly([p + Vector2(-8 + k * 6, -13), p + Vector2(-3 + k * 6, -9), p + Vector2(-8 + k * 6, -5)], Color(1.0, 0.8, 0.25, 0.9 if k == on else 0.3))
		"urn":
			_poly([p + Vector2(-5, 0), p + Vector2(5, 0), p + Vector2(7, -9), p + Vector2(3, -17), p + Vector2(-3, -17), p + Vector2(-7, -9)], Color(0.82, 0.82, 0.88))
			draw_line(p + Vector2(-6, -9), p + Vector2(6, -9), Color(0.9, 0.78, 0.4), 1.0)
			draw_line(p + Vector2(-5, -3), p + Vector2(-4, -14), Color(1, 1, 1, 0.5), 1.0)
		"topiary":
			_r(p.x - 3, p.y - 8, 6, 8, Color(0.5, 0.35, 0.2))
			draw_circle(p + Vector2(0, -12), 7.0, Color(0.08, 0.3, 0.14))
			draw_circle(p + Vector2(0, -21), 4.5, Color(0.1, 0.36, 0.17))
			draw_circle(p + Vector2(-2, -13), 2.5, Color(0.2, 0.5, 0.26))
		"statue":
			_r(p.x - 6, p.y - 7, 12, 7, Color(0.78, 0.78, 0.82))
			_r(p.x - 3, p.y - 21, 6, 14, Color(0.9, 0.9, 0.94))
			draw_circle(p + Vector2(0, -24), 3.2, Color(0.92, 0.92, 0.96))
			draw_line(p + Vector2(3, -19), p + Vector2(9, -26), Color(0.9, 0.9, 0.94), 1.8)
			_r(p.x + 1, p.y - 21, 2, 14, Color(1, 1, 1, 0.3))
		"fountain":
			_r(p.x - 12, p.y - 6, 24, 6, Color(0.78, 0.78, 0.84))
			_r(p.x - 10, p.y - 8, 20, 2, Color(0.35, 0.6, 0.8, 0.8))
			for k in 3:
				var ph3 := fposmod(t * 1.3 + k * 0.33, 1.0)
				draw_line(p + Vector2(0, -8), p + Vector2((k - 1) * 9.0 * ph3, -8 - 20.0 * (1.0 - (1.0 - ph3) * (1.0 - ph3))), Color(0.75, 0.92, 1.0, 0.7 * (1.0 - ph3 * 0.5)), 1.0)
			draw_rect(Rect2(p.x - 1, p.y - 18, 2, 11), Color(0.85, 0.85, 0.9))
		# ---- ceiling items (p is the ceiling surface)
		"cable":
			draw_polyline(PackedVector2Array([p, p + Vector2(3 * sin(t * 0.8 + rn * 6.0), 9), p + Vector2(0, 18)]), Color(0.05, 0.05, 0.05), 1.0)
			if rn > 0.55:
				var fl := 1.0 if int(t * 12.0 + rn * 9.0) % 13 > 1 else 0.2
				draw_circle(p + Vector2(0, 20), 1.6, Color(1.0, 0.35, 0.3, 0.9 * fl))
		"pipe_h":
			_r(p.x - 18, p.y + 1, 36, 4, Color(0.13, 0.12, 0.12))
			_r(p.x - 18, p.y + 1, 36, 1, Color(0.45, 0.4, 0.35, 0.4))
			if rn > 0.5:
				draw_circle(p + Vector2(rn * 10.0 - 4.0, 8.0 + fposmod(t * 40.0 + rn * 90.0, 20.0)), 0.9, Color(0.5, 0.7, 0.9, 0.7))
		"chandelier":
			var sway := sin(t * 0.7 + rn * 6.0) * 1.4
			draw_line(p, p + Vector2(sway, 10), Color(0.7, 0.6, 0.3), 1.0)
			for k in 7:
				var q := p + Vector2(sway + (k - 3) * 3.6, 14 + absf(k - 3) * -1.0 * 0.0 + (3 - absf(k - 3)) * -1.5 + 6.0)
				draw_line(p + Vector2(sway, 10), q, Color(0.85, 0.7, 0.35, 0.9), 1.0)
				draw_circle(q + Vector2(0, 2.5), 1.4, Color(1.0, 0.95, 0.8, 0.8 + 0.2 * sin(t * 3.0 + k + rn * 9.0)))
			_glow(p + Vector2(sway, 20), 16.0, Color(1.0, 0.85, 0.5, 0.35), 5)
		"lantern":
			draw_line(p, p + Vector2(0, 8), Color(0.2, 0.15, 0.1), 1.0)
			draw_circle(p + Vector2(0, 12), 4.0, Color(0.95, 0.55, 0.2, 0.85))
			_glow(p + Vector2(0, 12), 16.0, Color(1.0, 0.6, 0.25, 0.4), 5)
		"banner":
			var sw := sin(t * 1.1 + rn * 6.0) * 1.2
			_poly([p + Vector2(-5, 0), p + Vector2(5, 0), p + Vector2(5 + sw, 22), p + Vector2(0, 17), p + Vector2(-5 + sw, 22)], Color(0.85, 0.2, 0.25) if rn > 0.5 else Color(0.95, 0.8, 0.3))
		# ---- boss stage
		"table":
			_r(p.x - 46, p.y - 22, 92, 5, Color(0.07, 0.3, 0.17))
			_r(p.x - 48, p.y - 18, 96, 4, Color(0.25, 0.12, 0.06))
			_r(p.x - 40, p.y - 14, 6, 14, Color(0.15, 0.07, 0.04))
			_r(p.x + 34, p.y - 14, 6, 14, Color(0.15, 0.07, 0.04))
			for k in 5:
				draw_rect(Rect2(p.x - 24 + k * 11, p.y - 29, 8, 7), Color(0.95, 0.94, 0.9))
				draw_rect(Rect2(p.x - 24 + k * 11, p.y - 29, 8, 7), Color(0.2, 0.2, 0.25), false, 0.8)
			for k in 3:
				draw_circle(p + Vector2(-34 + k * 4, -24), 2.2, [Color(0.9, 0.2, 0.2), Color(0.2, 0.5, 0.9), Color(0.2, 0.8, 0.4)][k])
		"chair_b":
			_r(p.x - 5, p.y - 12, 10, 4, Color(0.4, 0.08, 0.1))
			_r(p.x - 5, p.y - 22, 3, 10, Color(0.35, 0.07, 0.09))
			_r(p.x - 5, p.y - 8, 2, 8, Color(0.12, 0.06, 0.04))
			_r(p.x + 3, p.y - 8, 2, 8, Color(0.12, 0.06, 0.04))
		"curtain":
			var wv := sin(t * 0.6 + rn) * 1.5
			_poly([p + Vector2(-8, 0), p + Vector2(8, 0), p + Vector2(10 + wv, (lvl.h - 3) * T), p + Vector2(-6 + wv, (lvl.h - 3) * T)], Color(0.45 - 0.02 * rn, 0.06, 0.1, 0.8))
			draw_line(p + Vector2(0, 0), p + Vector2(2 + wv, (lvl.h - 3) * T), Color(0.7, 0.15, 0.2, 0.5), 1.0)
		"stage_lights":
			for k in 5:
				var cx := W * (0.12 + k * 0.19)
				draw_rect(Rect2(cx - 5, p.y - 4, 10, 6), Color(0.1, 0.1, 0.12))
				var a := sin(t * (0.6 + k * 0.13) + k * 1.7) * 0.5
				var col: Color = [Color(1.0, 0.85, 0.5), Color(0.5, 0.8, 1.0), Color(1.0, 0.45, 0.7), Color(0.6, 1.0, 0.6), Color(1.0, 0.8, 0.4)][k]
				draw_polygon(PackedVector2Array([Vector2(cx - 2, p.y + 2), Vector2(cx + 2, p.y + 2), Vector2(cx + 2 + sin(a) * 120.0 + 30.0, p.y + 190.0), Vector2(cx - 2 + sin(a) * 120.0 - 30.0, p.y + 190.0)]),
					PackedColorArray([Color(col, 0.2), Color(col, 0.2), Color(col, 0.0), Color(col, 0.0)]))


# ======================================================================= BOSS BACKDROP
func _boss_backdrop(cam: Vector2, vr: Rect2) -> void:
	var P: Dictionary = lvl.pal()
	var wall: Color = P["wall"]
	# a grand stage: back curtain gradient, a huge emblem per game, floating motes
	_vfade(Rect2(0, 0, W, H), Color(wall.lightened(0.05), 1.0), Color(wall.darkened(0.2), 1.0))
	var fx := cam.x * 0.15
	for k in 9:
		var x := W * (k + 0.5) / 9.0 + fx * 0.3 - 8.0
		_r(x, 0, 10, H, Color(0.35, 0.05, 0.08, 0.5) if k % 2 == 0 else Color(0.25, 0.03, 0.06, 0.5))
	var c := Vector2(W * 0.5 + (cam.x - W * 0.5) * 0.12, H * 0.34)
	var id := boss_id
	var col := Color(1.0, 0.8, 0.3, 0.14)
	match id:
		"seezers":   # blackjack: giant 21
			draw_string(ThemeDB.fallback_font, c + Vector2(-70, 40), "21", HORIZONTAL_ALIGNMENT_CENTER, 140, 120, col)
		"wynners":
			for k in 3:
				draw_circle(c + Vector2((k - 1) * 70.0, 0), 44.0, Color(0.95, 0.95, 0.9, 0.08))
		"snake_eyes":
			for k in 2:
				draw_rect(Rect2(c + Vector2(-80 + k * 90.0, -34), Vector2(70, 70)), Color(0.9, 0.9, 0.85, 0.1))
				draw_circle(c + Vector2(-45 + k * 90.0, 1), 8.0, Color(0.9, 0.1, 0.1, 0.25))
		"rusty_slots":
			for k in 3:
				draw_rect(Rect2(c + Vector2(-110 + k * 76.0, -50), Vector2(68, 100)), Color(0.9, 0.2, 0.7, 0.08))
				draw_string(ThemeDB.fallback_font, c + Vector2(-90 + k * 76.0, 14), "7", HORIZONTAL_ALIGNMENT_LEFT, -1, 60, Color(1, 0.3, 0.3, 0.18))
		"mr_lucky":
			for k in 9:
				var a := TAU * k / 9.0 + t * 0.1
				draw_circle(c + Vector2.from_angle(a) * 72.0, 14.0, Color(0.5, 1.0, 0.4, 0.1))
		"house":
			draw_circle(c, 80.0, Color(1, 0.8, 0.3, 0.07))
			draw_arc(c, 80.0, 0, TAU, 40, Color(1, 0.85, 0.4, 0.25), 2.0)
			for k in 12:
				var a := TAU * k / 12.0 + t * 0.15
				draw_line(c + Vector2.from_angle(a) * 80.0, c + Vector2.from_angle(a) * 96.0, Color(1, 0.85, 0.4, 0.3), 2.0)
		_:
			for k in 4:   # suits
				var sx := c.x + (k - 1.5) * 64.0
				var sc: Color = [Color(0.9, 0.2, 0.25, 0.12), Color(0.1, 0.1, 0.12, 0.2), Color(0.9, 0.2, 0.25, 0.12), Color(0.1, 0.1, 0.12, 0.2)][k]
				if k % 2 == 0:
					draw_circle(Vector2(sx - 6, c.y - 6), 12.0, sc)
					draw_circle(Vector2(sx + 6, c.y - 6), 12.0, sc)
					_poly([Vector2(sx - 17, c.y - 2), Vector2(sx + 17, c.y - 2), Vector2(sx, c.y + 28)], sc)
				else:
					draw_circle(Vector2(sx, c.y - 8), 13.0, sc)
					_poly([Vector2(sx - 14, c.y + 6), Vector2(sx + 14, c.y + 6), Vector2(sx, c.y - 20)], sc)
					_r(sx - 2, c.y + 4, 4, 20, sc)
	# far arches along the back
	for k in 7:
		var ax := W * (k + 0.5) / 7.0 + (cam.x - W * 0.5) * 0.25
		draw_arc(Vector2(ax, H * 0.78), 24.0, PI, TAU, 14, Color(0.9, 0.75, 0.3, 0.12), 2.0)
	_vfade(Rect2(0, 0, W, H), Color(wall.r, wall.g, wall.b, 0.0), Color(wall.r, wall.g, wall.b, 0.4))


func _shafts(cam: Vector2, vr: Rect2) -> void:
	# soft light shafts slanting down through the room (colour per zone)
	var col: Color = [Color(1.0, 0.8, 0.5), Color(1.0, 0.7, 0.5), Color(1.0, 0.65, 0.35), Color(1.0, 0.85, 0.45), Color(1.0, 0.6, 0.3), Color(0.8, 0.7, 1.0)][clampi(zone, 0, 5)]
	var n := 5
	for k in n:
		var f := 0.62 + 0.05 * k
		var lx := cam.x + (float(k) - 2.0) * 90.0 + sin(t * 0.15 + k * 2.1) * 20.0
		var x0 := _px(lx, f, cam)
		var top := vr.position.y
		var bot := top + 150.0 + (k % 2) * 40.0
		var wd := 14.0 + 8.0 * (k % 3)
		var a := (0.05 + 0.02 * sin(t * 0.5 + k * 1.3)) * (0.6 if lvl.is_boss else 1.0)
		draw_polygon(PackedVector2Array([Vector2(x0 - wd * 0.4, top), Vector2(x0 + wd * 0.4, top), Vector2(x0 + wd + 40.0, bot), Vector2(x0 - wd + 40.0, bot)]),
			PackedColorArray([Color(col, a), Color(col, a), Color(col, 0.0), Color(col, 0.0)]))


# ======================================================================= FRONT
func _spawn_particle(vr: Rect2, anywhere := false) -> void:
	var y := vr.position.y + (randf() * vr.size.y if anywhere else -8.0)
	var x := vr.position.x + randf() * vr.size.x
	var v := Vector2.ZERO
	var life := 3.0 + randf() * 3.0
	var sz := 1.0 + randf()
	match zone:
		4:   # rain + wind
			v = Vector2(-26, 210 + randf() * 80)
			life = 1.6
			sz = 1.0
		0:   # dust + salt spray
			v = Vector2(randf_range(-6, 6), randf_range(2, 9))
		1:   # confetti
			v = Vector2(randf_range(-12, 12), randf_range(14, 30))
			sz = 1.5 + randf() * 1.5
		2:   # smoke haze drifting
			v = Vector2(randf_range(4, 12), randf_range(-8, -2))
			y = vr.position.y + randf() * vr.size.y
			sz = 5.0 + randf() * 8.0
		3:   # gold glitter
			v = Vector2(randf_range(-4, 4), randf_range(-4, 8))
			y = vr.position.y + randf() * vr.size.y
		5:   # sparkles / petals
			v = Vector2(randf_range(-8, 8), randf_range(5, 14))
	if lvl.is_boss:
		v = Vector2(randf_range(-10, 10), randf_range(-26, -8))   # embers rising
		y = vr.end.y + 4.0 if not anywhere else vr.position.y + randf() * vr.size.y
		sz = 1.0 + randf() * 1.5
	parts.append([Vector2(x, y), v, life, sz, randf()])


func _update_particles(delta: float) -> void:
	var vr := _view()
	var want := 130 if zone == 4 and not lvl.is_boss else 56
	if parts.is_empty():
		for i in want:
			_spawn_particle(vr, true)
	var i := parts.size() - 1
	while i >= 0:
		var p: Array = parts[i]
		p[2] -= delta
		var v: Vector2 = p[1]
		var swirl := 0.0
		if zone != 4 or lvl.is_boss:
			swirl = sin(t * 1.3 + float(p[4]) * 9.0) * 8.0
		p[0] = (p[0] as Vector2) + (v + Vector2(swirl, 0)) * delta
		if p[2] <= 0.0 or not vr.grow(40).has_point(p[0]):
			parts.remove_at(i)
		i -= 1
	while parts.size() < want:
		_spawn_particle(vr, false)


func _draw_front() -> void:
	if lvl == null or lvl.is_lobby:
		return
	var cam := _cam()
	var vr := _view()
	# foreground parallax silhouettes (blurry dark shapes sliding past faster than the world)
	for li in 2:
		var f := 1.18 + 0.22 * li
		var step := 210.0 + 70.0 * li
		var span := vr.size.x / f
		var i0 := int(floorf((cam.x - span * 0.5 - 60.0) / step))
		var i1 := int(ceilf((cam.x + span * 0.5 + 60.0) / step))
		for i in range(i0, i1 + 1):
			var rn := h1(i + li * 50, zone + 11)
			if rn > 0.45:
				continue
			var px := _px(float(i) * step, f, cam)
			var col := Color(0.0, 0.0, 0.02, 0.26 - 0.06 * li)
			match zone:
				4:
					# hanging cables / pipes
					draw_polyline(PackedVector2Array([Vector2(px, vr.position.y), Vector2(px + sin(t * 0.5 + i) * 3.0, vr.position.y + 40.0), Vector2(px - 4, vr.position.y + 70.0 + rn * 60.0)]), col, 2.5)
				1:
					draw_rect(Rect2(px, vr.position.y, 8, 24 + rn * 30), Color(0.4, 0.04, 0.07, 0.3))   # tent drape
				3, 5:
					draw_rect(Rect2(px, vr.position.y, 10, vr.size.y), col)   # column edge
				_:
					draw_rect(Rect2(px, vr.position.y, 6, vr.size.y), col)
	# vignette
	var vc := Color(0, 0, 0, 0.0)
	var vd := Color(0, 0, 0, 0.35)
	var sz := vr.size
	draw_polygon(PackedVector2Array([vr.position, vr.position + Vector2(sz.x, 0), vr.position + Vector2(sz.x, 26), vr.position + Vector2(0, 26)]), PackedColorArray([vd, vd, vc, vc]))
	draw_polygon(PackedVector2Array([vr.position + Vector2(0, sz.y - 26), vr.position + Vector2(sz.x, sz.y - 26), vr.position + sz, vr.position + Vector2(0, sz.y)]), PackedColorArray([vc, vc, vd, vd]))
	# particles
	for p in parts:
		var pos: Vector2 = p[0]
		var rn: float = p[4]
		var s: float = p[3]
		match zone:
			4:
				if lvl.is_boss:
					draw_rect(Rect2(pos, Vector2(s, s)), Color(1.0, 0.5, 0.2, 0.6))
				else:
					draw_line(pos, pos + Vector2(-2.2, 9.0), Color(0.7, 0.8, 1.0, 0.28), 1.0)
			0:
				draw_rect(Rect2(pos, Vector2(s, s)), Color(1.0, 0.9, 0.7, 0.22 + 0.15 * sin(t * 2.0 + rn * 9.0)))
			1:
				var c := Color.from_hsv(rn, 0.7, 1.0, 0.8)
				var fl := absf(sin(t * 5.0 + rn * 20.0))
				draw_rect(Rect2(pos, Vector2(s * (0.4 + fl), s)), c)
			2:
				draw_circle(pos, s, Color(0.75, 0.72, 0.7, 0.035))
			3:
				var tw := 0.5 + 0.5 * sin(t * 4.0 + rn * 30.0)
				draw_rect(Rect2(pos, Vector2(s * 0.8, s * 0.8)), Color(1.0, 0.85, 0.4, 0.55 * tw))
			5:
				var tw2 := 0.5 + 0.5 * sin(t * 3.0 + rn * 30.0)
				draw_line(pos - Vector2(s, 0), pos + Vector2(s, 0), Color(1.0, 0.95, 0.85, 0.7 * tw2), 1.0)
				draw_line(pos - Vector2(0, s), pos + Vector2(0, s), Color(1.0, 0.95, 0.85, 0.7 * tw2), 1.0)
		if lvl.is_boss and zone != 4:
			draw_rect(Rect2(pos, Vector2(s, s)), Color(1.0, 0.6, 0.25, 0.5))


# ======================================================================= TILE HELPERS (static)
## Material, edge highlight, decals and variation for one solid tile. `r` is the tile rect.
static func tile_detail(lv, ci: CanvasItem, x: int, y: int, r: Rect2, base: Color, up: bool, dn: bool, lf: bool, rt: bool, hsh: int) -> void:
	var z: int = lv.zone
	var p := r.position
	# low-frequency lightness drift so large walls never look like a repeating grid
	var drift := (h1(x / 3, y / 2 + z) - 0.5) * 0.16
	if drift > 0.0:
		ci.draw_rect(r, Color(1, 1, 1, drift * 0.5))
	else:
		ci.draw_rect(r, Color(0, 0, 0, -drift * 0.7))
	match z:
		4:   # wet brick: mortar offset, sheen on tops, grime, stains
			if hsh % 4 == 0:
				ci.draw_rect(Rect2(p + Vector2(3, 3), Vector2(4, 2)), base.lightened(0.12))
			if up:
				ci.draw_rect(Rect2(p + Vector2(0, 0), Vector2(T, 1)), Color(0.7, 0.8, 1.0, 0.35))
				if hsh % 3 == 0:
					ci.draw_rect(Rect2(p + Vector2(2, 1), Vector2(6, 1)), Color(1.0, 0.8, 0.5, 0.35))
			if dn and hsh % 4 == 1:
				ci.draw_rect(Rect2(p + Vector2(5 + hsh % 6, T - 1), Vector2(1, 4)), Color(0.45, 0.5, 0.6, 0.35))   # drip streak
			if hsh % 7 == 0:
				ci.draw_circle(p + Vector2(8, 8), 5.0, Color(0, 0, 0, 0.14))   # soot stain
		0:   # peeling carpet / stained plaster
			if up:
				ci.draw_rect(Rect2(p, Vector2(T, 3)), Color(0.55, 0.08, 0.12))
				for k in 4:
					ci.draw_rect(Rect2(p + Vector2(1 + k * 4, 1), Vector2(2, 1)), Color(0.9, 0.7, 0.3, 0.6))   # gold carpet pattern
				if hsh % 5 == 0:
					ci.draw_rect(Rect2(p + Vector2(4, 1), Vector2(8, 2)), Color(0.3, 0.05, 0.08))   # worn patch
			elif hsh % 6 == 0:
				ci.draw_rect(Rect2(p + Vector2(2, 2), Vector2(10, 6)), Color(0.35, 0.3, 0.12, 0.18))   # water stain
		1:   # circus stripes and tent canvas
			if (x + y) % 4 < 2:
				ci.draw_rect(Rect2(p, Vector2(T, T)), Color(0.6, 0.12, 0.14, 0.12))
			if up:
				ci.draw_rect(Rect2(p, Vector2(T, 2)), Color(0.95, 0.88, 0.6, 0.55) if x % 2 == 0 else Color(0.85, 0.2, 0.25, 0.7))
		2:   # wood and leather: grain
			ci.draw_rect(Rect2(p + Vector2(0, 4 + hsh % 8), Vector2(T, 1)), Color(0.0, 0.0, 0.0, 0.16))
			ci.draw_rect(Rect2(p + Vector2(0, 10 - hsh % 5), Vector2(T, 1)), Color(1.0, 0.8, 0.5, 0.06))
			if hsh % 9 == 0:
				ci.draw_circle(p + Vector2(8, 8), 2.0, Color(0, 0, 0, 0.3))   # knot
		3:   # gold inlay
			if (x + y) % 3 == 0:
				ci.draw_rect(Rect2(p + Vector2(0, T - 1), Vector2(T, 1)), Color(1.0, 0.8, 0.3, 0.35))
			if up:
				ci.draw_rect(Rect2(p + Vector2(0, 1), Vector2(T, 1)), Color(1.0, 0.9, 0.5, 0.5))
		5:   # marble veins and gold trim
			if hsh % 3 == 0:
				ci.draw_polyline(PackedVector2Array([p + Vector2(0, 3 + hsh % 6), p + Vector2(7, 7), p + Vector2(10, 5), p + Vector2(T, 11)]), Color(0.9, 0.88, 1.0, 0.12), 1.0)
			if up:
				ci.draw_rect(Rect2(p + Vector2(0, 0), Vector2(T, 1)), Color(1.0, 0.85, 0.4, 0.6))
	# rim light: tops near warm light sources glow
	if up:
		var best := 999.0
		for l in lv.lamps:
			best = minf(best, (l as Vector2).distance_to(p + Vector2(8, 0)))
		for n in lv.neons:
			best = minf(best, (n[0] as Vector2).distance_to(p + Vector2(8, 0)) * 0.8)
		if best < 120.0:
			var k := 1.0 - best / 120.0
			var lc: Color = lv.pal()["edge"]
			ci.draw_rect(Rect2(p, Vector2(T, 1)), Color(lc.lightened(0.4), 0.6 * k))
			ci.draw_rect(Rect2(p + Vector2(0, 1), Vector2(T, 2)), Color(lc, 0.2 * k))
	# decals on exposed faces
	if hsh % 23 == 0:
		ci.draw_polyline(PackedVector2Array([p + Vector2(3, 2), p + Vector2(6, 6), p + Vector2(5, 10), p + Vector2(9, 13)]), Color(0, 0, 0, 0.35), 1.0)   # crack
	if hsh % 29 == 1 and not up:
		ci.draw_rect(Rect2(p + Vector2(4, 5), Vector2(5, 3)), Color(1, 1, 1, 0.07))   # chip


## Ambient occlusion and contact shadows, drawn on the empty cells beside solid tiles.
static func ambient_occlusion(lv, ci: CanvasItem) -> void:
	var dark := Color(0, 0, 0, 0.34)
	var none := Color(0, 0, 0, 0.0)
	for y in range(1, lv.h - 1):
		for x in range(1, lv.w - 1):
			if lv.grid[lv.idx(x, y)] != lv.EMPTY:
				continue
			var s_dn: bool = lv.get_cell(x, y + 1) == lv.SOLID
			var s_up: bool = lv.get_cell(x, y - 1) == lv.SOLID
			var s_lf: bool = lv.get_cell(x - 1, y) == lv.SOLID
			var s_rt: bool = lv.get_cell(x + 1, y) == lv.SOLID
			if not (s_dn or s_up or s_lf or s_rt):
				continue
			var o := Vector2(x * T, y * T)
			if s_dn:
				ci.draw_polygon(PackedVector2Array([o + Vector2(0, T - 6), o + Vector2(T, T - 6), o + Vector2(T, T), o + Vector2(0, T)]), PackedColorArray([none, none, Color(0, 0, 0, 0.22), Color(0, 0, 0, 0.22)]))
			if s_up:
				ci.draw_polygon(PackedVector2Array([o, o + Vector2(T, 0), o + Vector2(T, 6), o + Vector2(0, 6)]), PackedColorArray([Color(0, 0, 0, 0.3), Color(0, 0, 0, 0.3), none, none]))
			if s_lf:
				ci.draw_polygon(PackedVector2Array([o, o + Vector2(5, 0), o + Vector2(5, T), o + Vector2(0, T)]), PackedColorArray([Color(0, 0, 0, 0.22), none, none, Color(0, 0, 0, 0.22)]))
			if s_rt:
				ci.draw_polygon(PackedVector2Array([o + Vector2(T - 5, 0), o + Vector2(T, 0), o + Vector2(T, T), o + Vector2(T - 5, T)]), PackedColorArray([none, Color(0, 0, 0, 0.22), Color(0, 0, 0, 0.22), none]))
			# concave corners get the darkest pooled shadow
			if s_dn and s_lf:
				ci.draw_polygon(PackedVector2Array([o + Vector2(0, T - 8), o + Vector2(8, T), o + Vector2(0, T)]), PackedColorArray([none, none, dark]))
			if s_dn and s_rt:
				ci.draw_polygon(PackedVector2Array([o + Vector2(T, T - 8), o + Vector2(T, T), o + Vector2(T - 8, T)]), PackedColorArray([none, dark, none]))
			if s_up and s_lf:
				ci.draw_polygon(PackedVector2Array([o, o + Vector2(8, 0), o + Vector2(0, 8)]), PackedColorArray([dark, none, none]))
			if s_up and s_rt:
				ci.draw_polygon(PackedVector2Array([o + Vector2(T, 0), o + Vector2(T, 8), o + Vector2(T - 8, 0)]), PackedColorArray([dark, none, none]))
