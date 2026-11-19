extends Node2D
## Atmosphere: volumetric light cones under lamps and drifting dust motes.
## Drawn additive + unshaded on top of the world.

var level
var cam: Camera2D
var motes: Array = []
var t := 0.0


func setup(lvl, camera: Camera2D) -> void:
	level = lvl
	cam = camera
	z_index = 6
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	material = mat
	for i in 70:
		motes.append([Vector2(randf_range(-230, 230), randf_range(-130, 130)), randf_range(0.5, 1.5), randf() * TAU])


func _process(delta: float) -> void:
	t += delta
	for m in motes:
		var p: Vector2 = m[0]
		p += Vector2(sin(t * 0.4 + m[2]) * 4.0, -3.0 - m[1] * 2.0) * delta
		if p.y < -135.0:
			p.y = 135.0
		m[0] = p
	queue_redraw()


func _draw() -> void:
	if level == null or cam == null:
		return
	var c := cam.global_position
	for l in level.lamps:
		var lp: Vector2 = l
		if absf(lp.x - c.x) > 300.0 or absf(lp.y - c.y) > 220.0:
			continue
		var fl := 0.85 + 0.15 * sin(t * 13.0 + lp.x) * sin(t * 7.0)
		var top := lp + Vector2(0, 12)
		var pts := PackedVector2Array([top + Vector2(-3, 0), top + Vector2(3, 0), top + Vector2(34, 110), top + Vector2(-34, 110)])
		var cols := PackedColorArray([Color(1, 0.75, 0.4, 0.13 * fl), Color(1, 0.75, 0.4, 0.13 * fl), Color(1, 0.75, 0.4, 0.0), Color(1, 0.75, 0.4, 0.0)])
		draw_polygon(pts, cols)
	for m in motes:
		var p: Vector2 = c + (m[0] as Vector2)
		p.x = c.x + fposmod((m[0] as Vector2).x + 230.0 - c.x * 0.15, 460.0) - 230.0
		var a := 0.25 + 0.25 * sin(t * 2.0 + m[2])
		draw_rect(Rect2(p, Vector2(m[1], m[1])), Color(1, 0.85, 0.6, a))
