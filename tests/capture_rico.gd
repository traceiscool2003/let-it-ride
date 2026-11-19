extends SceneTree
## Close-up screenshots of Rico in every outfit tier + an accessory set (windowed).
var frame := 0
var m
var shots := [[1, []], [6, []], [11, []], [16, []], [21, []], [21, ["top_hat", "shades", "cape", "gold_chain", "tux_pants", "wingtips"]], [3, ["bucket_hat", "hawaiian", "cargo_shorts", "fanny_pack"]], [8, ["track_jacket", "grip_gloves", "eyepatch"]]]
var idx := 0
var zoom := float(OS.get_environment("RICO_ZOOM")) if OS.get_environment("RICO_ZOOM") != "" else 7.0
func _initialize() -> void:
	m = load("res://scenes/main.tscn").instantiate()
	m.save_path = "user://test_rico.cfg"
	root.add_child(m)
func _process(_d: float) -> bool:
	frame += 1
	if frame == 10:
		m._start_run()
		m.dialog.clear()
		m._dialog_end()
		m.state = "play"
		paused = false
		m.tip_t = 0.0
	if frame >= 60 and (frame - 60) % 12 == 0:
		if idx > 0:
			root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/rico_%d.png" % (idx - 1))
		if idx >= shots.size():
			return true
		m.player.outfit_floor = shots[idx][0]
		m.player.worn = ["thrift_sneakers"] + shots[idx][1]
		m.camera.zoom = Vector2(zoom, zoom)
		idx += 1
	return false
