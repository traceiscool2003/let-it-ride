extends SceneTree
## Renders every boss (all 3 phases) and Lobby character up close to
## user://gallery_*.png (run windowed):  godot --path . --script res://tests/gallery.gd


var frame := 0
var bosses: Array = []
var holder: Node2D
var cam: Camera2D


func _initialize() -> void:
	var BossScript = load("res://scripts/boss.gd")
	var PropScript = load("res://scripts/prop.gd")
	var LevelScript = load("res://scripts/level.gd")
	RenderingServer.set_default_clear_color(Color(0.1, 0.06, 0.13))
	holder = Node2D.new()
	root.add_child(holder)
	cam = Camera2D.new()
	root.add_child(cam)
	var lv = LevelScript.new()
	holder.add_child(lv)
	var r := RandomNumberGenerator.new()
	lv.generate_boss(r, 1, [])
	lv.visible = false
	for tier in 3:
		for ph in 3:
			var b = BossScript.new()
			b.setup(4 * (tier + 1), lv, holder)
			b.phase = ph + 1
			b.state = "idle"
			b.position = Vector2(-260 + ph * 90, -120 + tier * 110)
			b.set_physics_process(false)
			holder.add_child(b)
			bosses.append(b)
	var kinds := ["vera", "mags", "lucky", "james", "cat", "phone"]
	for i in kinds.size():
		var p = PropScript.new()
		p.kind = kinds[i]
		p.position = Vector2(60 + (i % 3) * 70, -60 + (i / 3) * 110)
		holder.add_child(p)
	cam.zoom = Vector2(2.0, 2.0)
	cam.position = Vector2(-20, 20)


func _process(_d: float) -> bool:
	frame += 1
	if frame == 2:
		cam.make_current()
	for b in bosses:
		b.t += 0.016
		b.queue_redraw()
	if frame == 60:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/gallery_all.png")
		cam.zoom = Vector2(4.0, 4.0)
		cam.position = Vector2(-170, -150)
	if frame == 70:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/gallery_sal.png")
		cam.position = Vector2(-170, -40)
	if frame == 80:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/gallery_roulette.png")
		cam.position = Vector2(-170, 70)
	if frame == 90:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/gallery_house.png")
		cam.position = Vector2(130, -80)
	if frame == 100:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/gallery_npcs1.png")
		cam.position = Vector2(130, 30)
	if frame == 110:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/gallery_npcs2.png")
		print("gallery saved")
		return true
	return false
