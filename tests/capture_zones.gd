extends SceneTree
## Screenshots of each zone and boss arena: xvfb-run godot --path . --script res://tests/capture_zones.gd
## Pass floor numbers after `--` to capture only those (e.g. -- 1 6).
var main
var frame := 0
var floors := [1, 3, 6, 11, 16, 21, 5, 10, 15]
var i := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_zones.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_zones.cfg"))
	root.add_child(main)
	var a := OS.get_cmdline_user_args()
	if a.size() > 0:
		floors = []
		for s in a:
			floors.append(int(s))


func _shot(n: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/" + n + ".png")


func _process(_d: float) -> bool:
	frame += 1
	if frame == 10:
		main.intro_seen = true
		main._enter_lobby(false)
	if frame == 40:
		main.dialog.clear()
		main._dialog_end()
		main._start_run()
	if frame > 40 and (frame - 40) % 60 == 0:
		if i > 0:
			_shot("z%02d_floor%d" % [i, floors[i - 1]])
		if i >= floors.size():
			quit()
			return false
		main.floor_num = floors[i]
		main._build_floor()
		main.state = "play"
		main.banner_t = 0.0
		main.zone_card_t = 0.0
		main.tip_t = 0.0
		paused = false
		var pl = main.player
		var lv = main.level
		pl.global_position = lv.start_pos + Vector2(60, -20) if not lv.is_boss else lv.start_pos + Vector2(120, -20)
		main.camera.global_position = pl.global_position
		i += 1
	return false
