extends SceneTree
## Quick compile check of every script: godot --headless --path . --script res://tests/parse.gd


func _initialize() -> void:
	var bad := 0
	for f in DirAccess.get_files_at("res://scripts"):
		if f.ends_with(".gd"):
			var sc = load("res://scripts/" + f)
			if sc == null or not sc.can_instantiate():
				print("FAILED: ", f)
				bad += 1
	print("parse check: %d failed" % bad)
	quit()
