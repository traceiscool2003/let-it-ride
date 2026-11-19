extends Node2D
## Reactive foliage: grass that parts around the runner, verlet vines that
## swing when you pass through them, and glowing mushrooms.

var level
var player
var base := PackedVector2Array()
var lens := PackedFloat32Array()
var ang := PackedFloat32Array()
var angv := PackedFloat32Array()
var shade := PackedFloat32Array()
var vines: Array = []   # {pts, old}
var shrooms: Array = []
var t := 0.0


func setup(lvl, pl) -> void:
	level = lvl
	player = pl
	z_index = -3
	for g in level.grass:
		base.append(g[0])
		lens.append(g[1])
		shade.append(g[2])
		ang.append(0.0)
		angv.append(0.0)
	for v in level.vine_spots:
		var a: Vector2 = v[0]
		var n: int = v[1]
		var pts: Array[Vector2] = []
		for i in n + 1:
			pts.append(a + Vector2(0, i * 4.0))
		vines.append({"pts": pts, "old": pts.duplicate()})
	shrooms = level.shrooms


func _process(delta: float) -> void:
	t += delta
	if player == null:
		return
	var pp: Vector2 = player.global_position
	var feet := pp + Vector2(0, 11)
	var pv: Vector2 = player.velocity
	var k := minf(1.0, 10.0 * delta)
	for i in base.size():
		var b := base[i]
		if absf(b.x - pp.x) > 240.0 or absf(b.y - pp.y) > 150.0:
			continue
		var target := sin(t * 1.6 + b.x * 0.05) * 0.14
		var dx := b.x - feet.x
		var dy := b.y - feet.y
		if absf(dx) < 12.0 and absf(dy) < 16.0:
			target += signf(dx) * (1.0 - absf(dx) / 12.0) * 1.2 + clampf(pv.x * 0.002, -0.5, 0.5)
		angv[i] += (target - ang[i]) * 140.0 * delta
		angv[i] *= 1.0 - k
		ang[i] += angv[i] * delta
	var dt := minf(delta, 0.033)
	for v in vines:
		var pts: Array[Vector2] = v["pts"]
		var old: Array[Vector2] = v["old"]
		if absf(pts[0].x - pp.x) > 260.0 or absf(pts[0].y - pp.y) > 170.0:
			continue
		for i in range(1, pts.size()):
			var p := pts[i]
			var vel := (p - old[i]) * 0.96
			old[i] = p
			p += vel + Vector2(sin(t * 1.3 + i) * 0.6, 300.0) * dt * dt
			var d := p - pp
			if d.length() < 9.0:
				p = pp + d.normalized() * 9.0 + pv * dt * 0.4
			pts[i] = p
		for _it in 3:
			for i in pts.size() - 1:
				var d := pts[i + 1] - pts[i]
				var l := d.length()
				if l < 0.001:
					continue
				var diff := d * ((l - 4.0) / l)
				if i == 0:
					pts[i + 1] -= diff
				else:
					pts[i] += diff * 0.5
					pts[i + 1] -= diff * 0.5
	queue_redraw()


func _draw() -> void:
	if player == null:
		return
	var pp: Vector2 = player.global_position
	for i in base.size():
		var b := base[i]
		if absf(b.x - pp.x) > 250.0 or absf(b.y - pp.y) > 160.0:
			continue
		var s := shade[i]
		var col := Color(0.16, 0.5, 0.26).lerp(Color(0.35, 0.7, 0.3), s)
		var a := ang[i]
		var tip := b + Vector2(sin(a), -cos(a)) * lens[i]
		var mid := b + Vector2(sin(a * 0.5), -cos(a * 0.5)) * lens[i] * 0.5
		draw_line(b, mid, col.darkened(0.2), 1.2)
		draw_line(mid, tip, col, 1.0)
	for v in vines:
		var pts: Array[Vector2] = v["pts"]
		if absf(pts[0].x - pp.x) > 260.0 or absf(pts[0].y - pp.y) > 170.0:
			continue
		draw_polyline(PackedVector2Array(pts), Color(0.06, 0.2, 0.1), 2.2)
		draw_polyline(PackedVector2Array(pts), Color(0.15, 0.42, 0.2), 1.2)
		for i in range(1, pts.size(), 2):
			var p := pts[i]
			var side := 1.0 if i % 4 == 1 else -1.0
			draw_colored_polygon(PackedVector2Array([p, p + Vector2(side * 3.0, -1.0), p + Vector2(side * 1.5, 1.5)]), Color(0.25, 0.6, 0.28))
	for s in shrooms:
		var p: Vector2 = s[0]
		var sz: float = s[1]
		var c: Color = s[2]
		var pulse := 0.6 + 0.4 * sin(t * 2.0 + p.x)
		draw_circle(p + Vector2(0, -sz - 1), sz * 2.6, Color(c, 0.08 * pulse))
		draw_rect(Rect2(p + Vector2(-0.6, -sz - 1), Vector2(1.2, sz + 1)), Color(0.85, 0.82, 0.75))
		draw_colored_polygon(PackedVector2Array([p + Vector2(-sz, -sz), p + Vector2(0, -sz * 2.0), p + Vector2(sz, -sz)]), c.lerp(Color.WHITE, 0.15 * pulse))
