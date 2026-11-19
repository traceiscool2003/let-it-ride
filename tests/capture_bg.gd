extends SceneTree
## Contact sheet of the CraftPix backgrounds: xvfb-run godot --path . --script res://tests/capture_bg.gd
const BgArt := preload("res://scripts/bg_art.gd")
var n := 0
class Sheet extends Node2D:
	var mode := 0
	func _draw() -> void:
		var BA = load("res://scripts/bg_art.gd")
		if mode == 0:
			for s in 4:
				BA.street(self, Rect2((s % 2) * 640, (s / 2) * 360, 640, 360), s + 1)
		else:
			for c in 5:
				var r := Rect2((c % 2) * 640, (c / 2) * 240, 640, 240)
				draw_rect(r, Color.BLACK)
				BA.skyline(self, r, c, 0.0, 0.0)
func _initialize() -> void:
	root.size = Vector2i(1280, 720)
	for m in 2:
		var s := Sheet.new(); s.mode = m; s.name = "S%d" % m; s.visible = (m == 0); root.add_child(s)
func _process(_d: float) -> bool:
	n += 1
	if n == 5:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/bg_streets.png")
		root.get_node("S0").visible = false; root.get_node("S1").visible = true
	if n == 10:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/bg_sky.png")
		quit()
	return false
