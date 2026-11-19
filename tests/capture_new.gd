extends SceneTree
## Screenshots of the presentation layer: title, loading screens, cast cards,
## zone card and the BUST respawn wipe.
##   xvfb-run godot --path . --script res://tests/capture_new.gd

var main
var frame := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_capture_new.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_capture_new.cfg"))
	root.add_child(main)


func _shot(n: String) -> void:
	var img := root.get_viewport().get_texture().get_image()
	img.save_png(OS.get_user_data_dir() + "/" + n + ".png")


func _load_kind(kind: String, title: String, sub: String) -> void:
	main._loading(kind, title, sub, func(): pass)
	main.load_t = 1.0
	main.load_done = true
	main.load_dur = 999.0


func _process(_delta: float) -> bool:
	frame += 1
	match frame:
		40:
			_shot("n01_title")
			main.title_sel = 0
			_load_kind("lobby", "THE LOBBY", "Where every debtor wakes up.")
		50:
			_shot("n02_load_lobby")
			_load_kind("slots", "THE SLOT HALL", "FLOOR 1  -  Velvet, brass, and a thousand hungry machines.")
		60:
			_shot("n03_load_slots")
			_load_kind("back", "THE BACK ROOMS", "FLOOR 5  -  Card tables, cigar smoke, and nobody's friends.")
		70:
			_shot("n04_load_back")
			_load_kind("vault", "THE VAULT", "FLOOR 9  -  Steel, lasers, and everything the House ever took.")
		80:
			_shot("n05_load_vault")
			_load_kind("boss1", "SAL'S OFFICE", "BOSS FLOOR  -  FLOOR 4")
		90:
			_shot("n06_load_boss1")
			_load_kind("boss2", "THE ROULETTE BALLROOM", "BOSS FLOOR  -  FLOOR 8")
		100:
			_shot("n07_load_boss2")
			_load_kind("boss3", "THE PENTHOUSE", "BOSS FLOOR  -  FLOOR 12")
		110:
			_shot("n08_load_boss3")
			_load_kind("deep", "HIGH LIMIT", "FLOOR 13  -  Below The Pit there's always more Pit.")
		120:
			_shot("n09_load_deep")
			main.state = "title"
			main._loading("lobby", "THE LOBBY", "", func(): main._enter_lobby(false))
			main._loading_tick(10.0)
			# Fast-forward the intro to the first cast card (Rico).
			for i in 200:
				if main.cine_step.get("do", "") == "who":
					break
				main._cine_tick(0.1)
				if main.state == "cine" and main.cine_step.get("do", "") == "say":
					main.dialog.clear()
					main._next_cine_step()
			main.card_t = 1.0
		135:
			_shot("n10_cast_rook")
			# Advance to the Vera card.
			for i in 400:
				if main.cast_name == "VERA":
					break
				if main.cine_step.get("do", "") == "say":
					main.dialog.clear()
					main._next_cine_step()
				else:
					main._cine_tick(0.1)
			main.card_t = 1.0
		150:
			_shot("n11_cast_vera")
			for i in 400:
				if main.cast_name == "MARLOW":
					break
				if main.cine_step.get("do", "") == "say":
					main.dialog.clear()
					main._next_cine_step()
				else:
					main._cine_tick(0.1)
			main.card_t = 1.0
		165:
			_shot("n12_cast_marlow")
			main.skip_cine()
			main._start_run()
			main.dialog.clear()
			main._dialog_end()
			main.state = "play"
			paused = false
			main.zone_card = "THE SLOT HALL"
			main.zone_card_t = 2.0
		185:
			_shot("n13_zone_card")
			main._die("Dealt out by a GUARD")
		230:
			main._respawn_sequence()
			main.wipe_t = 0.45
		232:
			_shot("n14_wipe_drop")
			main.wipe_t = 1.5
		236:
			_shot("n15_wipe_bust")
			main.wipe_t = 1.95
		238:
			_shot("n16_wipe_reveal")
		262:
			_shot("n17_lobby_drop")
		330:
			_shot("n18_lobby_landed")
			quit()
	return false
