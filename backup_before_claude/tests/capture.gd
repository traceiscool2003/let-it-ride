extends SceneTree
## Saves screenshots of key screens to user:// (run windowed).

var main
var frame := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)


func _shot(n: String) -> void:
	var img := root.get_viewport().get_texture().get_image()
	img.save_png(OS.get_user_data_dir() + "/" + n + ".png")


func _process(_delta: float) -> bool:
	frame += 1
	match frame:
		30:
			_shot("title")
		32:
			main._start_run()
		34:
			_shot("dialog")
			main.dialog.clear()
			main._dialog_end()
			Input.action_press("right")
		80:
			Input.action_press("attack")
		82:
			Input.action_release("attack")
			main._on_move("WALL RUN")
			main._on_move("VAULT")
			main._on_move("PARRY")
			main.pot = 420
		90:
			_shot("play")
			Input.action_release("right")
		95:
			main.casino.open("slots", 0, 1)
			main.state = "casino"
			paused = true
			main.casino.press("confirm", main.pot)
		200:
			_shot("slots")
			main.casino.done = true
		205:
			main.floor_num = 3
			main.dialog.clear()
			main._choose(1)
		210:
			main.dialog.clear()
			main._dialog_end()
			main.state = "play"
			paused = false
			main.boss.state = "idle"
			main.boss.hurt(9)
		330:
			_shot("boss")
		335:
			main.state = "skills"
			main.perks["skin1"] = 1
			main.perks["blade1"] = 1
		340:
			_shot("skills")
			main.floor_num = 6
			main.rules = ["security"]
			main.state = "play"
			paused = false
			main._build_floor()
			for e in main.enemies:
				if e.kind >= 2:
					main.player.global_position = e.global_position + Vector2(-50, -4)
					main.camera.global_position = main.player.global_position
					break
		400:
			_shot("enemies")
			print("saved to ", OS.get_user_data_dir())
			return true
	return false
