extends SceneTree
## Renders an enemy roster (each type, each city) and a sheet of generated portraits:
##   xvfb-run godot --path . --script res://tests/capture_cast.gd   -> user://cast_enemies.png, cast_portraits.png
var frame := 0
var holder: Node2D
var cam: Camera2D


class Sheet extends Node2D:
	var names: Array = []
	var t := 0.0
	func _process(d: float) -> void:
		t += d
		queue_redraw()
	func _draw() -> void:
		var Art = load("res://scripts/art.gd")
		draw_rect(Rect2(0, 0, 1280, 720), Color(0.1, 0.06, 0.13))
		for i in names.size():
			var c := Vector2(90 + (i % 8) * 150, 80 + (i / 8) * 150)
			draw_rect(Rect2(c - Vector2(66, 66), Vector2(132, 132)), Color(0.12, 0.06, 0.16))
			Art.npc_portrait(self, c, names[i], t, 6.0)
			draw_string(ThemeDB.fallback_font, c + Vector2(-60, 76), names[i], HORIZONTAL_ALIGNMENT_CENTER, 120, 10, Color.WHITE)


class Roster extends Node2D:
	func _draw() -> void:
		var Rig = load("res://scripts/rig.gd")
		var Gear = load("res://scripts/gear.gd")
		draw_rect(Rect2(0, 0, 1280, 720), Color(0.1, 0.06, 0.13))
		var kinds := [0, 4, 6, 7, 8, 9, 10, 11, 3, 2]
		var floors := [1, 3, 8, 13, 18, 23]
		for r in floors.size():
			for c in kinds.size():
				var rig = Rig.new(Rig.enemy_style(kinds[c], floors[r]))
				var xf := Transform2D(0.0, Vector2(3.4, 3.4), 0.0, Vector2(80 + c * 120, 120 + r * 110))
				rig.draw(self, xf)
				Gear.enemy(self, xf, rig, kinds[c], 0.0, Gear.palette(floors[r])[2])
				draw_set_transform_matrix(Transform2D.IDENTITY)


func _initialize() -> void:
	root.add_child(Roster.new())


func _process(_d: float) -> bool:
	frame += 1
	if frame == 6:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/cast_enemies.png")
		for ch in root.get_children():
			ch.queue_free()
		var s := Sheet.new()
		s.names = ["DRAFTQUEENS", "FANDOOL", "POKERSTARZ", "BETMGN", "STEAKE.COM", "BOVADOH", "SEEZER'S CLUB", "WYNNER'S CIRCLE", "SNAKE EYES SAL", "ONE-ARMED BANDIT", "MR. LUCKY", "DICE", "VENDOR", "BARKEEP", "RIVAL", "SINGER"]
		root.add_child(s)
	if frame == 14:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/cast_portraits.png")
		quit()
	return false
