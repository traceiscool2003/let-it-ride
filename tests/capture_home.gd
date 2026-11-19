extends SceneTree
## Screenshots of the apartment and the street: xvfb-run godot --path . --script res://tests/capture_home.gd
var main
var frame := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_home.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_home.cfg"))
	root.add_child(main)


func _shot(n: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/" + n + ".png")


func _put(px: float) -> void:
	main.player.global_position = Vector2(px * 16.0, main.player.global_position.y)
	main.camera.global_position = main.player.global_position


func _process(_d: float) -> bool:
	frame += 1
	match frame:
		10:
			main.intro_seen = true
			main._enter_lobby(false)
		50:
			main.dialog.clear()
			main._dialog_end()
			main.state = "play"
			main.banner_t = 0.0
			main.tip_t = 0.0
			_put(8)
		70:
			_shot("home_a_apartment")
			_put(19)
		90:
			_shot("home_b_door")
			_put(31)
		110:
			_shot("home_c_street")
			_put(55)
		130:
			_shot("home_d_busstop")
			quit()
	return false
