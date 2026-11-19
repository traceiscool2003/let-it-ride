extends SceneTree
## Screenshot of the Voice Studio (run windowed).
var frame := 0
func _initialize() -> void:
	var m = load("res://scenes/main.tscn").instantiate()
	m.save_path = "user://test_studio.cfg"
	root.add_child(m)
func _process(_d: float) -> bool:
	frame += 1
	if frame == 20:
		root.get_node("VoiceStudio").open()
	if frame == 30:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/studio.png")
		root.get_node("VoiceStudio").close()
		return true
	return false
