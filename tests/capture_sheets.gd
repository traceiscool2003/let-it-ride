extends SceneTree
## Enemy + NPC sprite sheets per city, no level needed: xvfb-run godot --path . --script res://tests/capture_sheets.gd
var n := 0
func _initialize() -> void:
	var bg := ColorRect.new(); bg.color = Color(0.15, 0.12, 0.2); bg.size = Vector2(1280, 720); root.add_child(bg)
	var world := Node2D.new(); world.scale = Vector2(3, 3); root.add_child(world)
	var E = load("res://scripts/enemy.gd")
	var stub := Node2D.new(); world.add_child(stub)
	var kinds := [0, 2, 3, 4, 6, 7, 8, 9, 10, 11]
	for city in 5:
		for i in kinds.size():
			var e = E.new()
			e.position = Vector2(14 + i * 40, 40 + city * 46)
			world.add_child(e)
			e.setup(kinds[i], null, stub, city * 5 + 1)
			e.set_physics_process(false)
			e.dir = 1
func _process(_d: float) -> bool:
	n += 1
	if n == 8:
		root.get_viewport().get_texture().get_image().save_png(OS.get_user_data_dir() + "/sheets.png")
		quit()
	return false
