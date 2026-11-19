extends SceneTree
## In-game close-ups of the enemy roster on three floors: xvfb-run godot --path . --script res://tests/capture_enemies.gd
var main
var frame := 0
var floors := [2, 8, 23]
var i := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_enemies.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_enemies.cfg"))
	root.add_child(main)


func _process(_d: float) -> bool:
	frame += 1
	if frame == 10:
		main.intro_seen = true
		main._enter_lobby(false)
	if frame == 40:
		main.dialog.clear()
		main._dialog_end()
		main._start_run()
	if frame > 40 and (frame - 40) % 50 == 0:
		if i > 0:
			root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/enemies_%d.png" % floors[i - 1])
		if i >= floors.size():
			quit()
			return false
		main.floor_num = floors[i]
		main._build_floor()
		main.state = "play"
		main.banner_t = 0.0
		main.zone_card_t = 0.0
		paused = false
		var base: Vector2 = main.level.start_pos
		var kinds := [0, 4, 6, 7, 8, 9, 10, 11, 3, 2]
		for k in kinds.size():
			main._spawn_enemy(base + Vector2(40 + k * 22, -4), 0)
			var e = main.enemies[main.enemies.size() - 1]
			e.setup(kinds[k], main.level, main.player, floors[i], 1.0, false)
			e.position = base + Vector2(40 + k * 22, -4)
			e.process_mode = Node.PROCESS_MODE_DISABLED
		main.player.global_position = base + Vector2(-30, -10)
		main.camera.zoom = Vector2(4.4, 4.4)
		main.camera.global_position = base + Vector2(130, -14)
		main.camera.position_smoothing_enabled = false
		i += 1
	return false
