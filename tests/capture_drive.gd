extends SceneTree
## Screenshots the 5 highway road-trip loading screens (run windowed):
##   godot --path . --script res://tests/capture_drive.gd

var main
var frame := 0
var city := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_drive.cfg"
	root.add_child(main)


func _process(_delta: float) -> bool:
	frame += 1
	if frame == 20 + city * 40:
		main._loading_drive(city, func(): pass)
		main.load_t = 3.0
		main.load_done = true
		main.load_dur = 99.0
	if frame == 50 + city * 40:
		var img := root.get_viewport().get_texture().get_image()
		img.save_png(OS.get_user_data_dir() + "/drive_%d.png" % city)
		city += 1
		if city >= 5:
			print("saved drive_0..4.png to ", OS.get_user_data_dir())
			return true
	return false
