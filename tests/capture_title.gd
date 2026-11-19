extends SceneTree
## Screenshots of the title screen (run windowed): intro frames + settled menu.
var frame := 0
var m
func _initialize() -> void:
	m = load("res://scenes/main.tscn").instantiate()
	m.save_path = "user://test_title.cfg"
	root.add_child(m)
func _shot(n: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/" + n + ".png")
func _process(_d: float) -> bool:
	frame += 1
	if frame == 25:
		_shot("title_a")
	if frame == 70:
		_shot("title_b")
	if frame == 240:
		_shot("title_c")
		m.title_sel = 2
	if frame == 260:
		_shot("title_d")
		return true
	return false
