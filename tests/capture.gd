extends SceneTree
## Saves screenshots of key screens to user:// (run windowed, not headless):
##   godot --path . --script res://tests/capture.gd
## Uses its own save file, so your real save is never touched.

var main
var frame := 0
var shots := 0
var wait := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_capture.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_capture.cfg"))
	root.add_child(main)


func _shot(n: String) -> void:
	var img := root.get_viewport().get_texture().get_image()
	img.save_png(OS.get_user_data_dir() + "/" + n + ".png")
	shots += 1


func _clear() -> void:
	if main.state == "dialog":
		main.dialog.clear()
		main._dialog_end()


func _process(_delta: float) -> bool:
	frame += 1
	match frame:
		30:
			_shot("01_title")
			main._enter_lobby(false)
		70:
			_shot("02_intro_card")
			for i in 30:
				main._cine_tick(0.1)
		110:
			_shot("03_intro_pan")
			main.skip_cine()
			main.player.global_position = main.level.games.filter(func(gm): return gm[1] == "vera")[0][0] + Vector2(-30, -12)
			main.camera.global_position = main.player.global_position
		160:
			_shot("04_lobby")
			main._hub_interact("vera")
		170:
			_shot("05_vera_dialog")
			while main.state == "dialog":
				_clear()
		180:
			main.wallet = 3000
			main._build_menu("licenses", "", 2)
		185:
			_shot("06_licenses")
			main._close_menu()
			main.player.global_position = main.level.games.filter(func(gm): return gm[1] == "mags")[0][0] + Vector2(-26, -12)
			main.camera.global_position = main.player.global_position
		220:
			_shot("07_lobby_mags")
			main._start_run()
			_clear()
			main.state = "play"
			paused = false
			Input.action_press("right")
		270:
			Input.action_release("right")
			for id in ["chalk", "magnet", "seven"]:
				main._give_charm(id)
			main.pot = 640
			main.pot_mult = 2
			main._on_move("WALL RUN")
			main._on_move("VAULT")
		285:
			_shot("08_run_hud")
			main._open_menu("shop")
		290:
			_shot("09_vera_shop")
			main._close_menu()
			main._open_menu("bets")
		295:
			_shot("10_side_bets")
			main._close_menu()
			main.floor_num = 2
			var tries := 0
			while main.vault.is_empty() and tries < 30:
				main.run_seed += 1
				main._build_floor()
				tries += 1
			main.state = "play"
			paused = false
			var vp: Vector2 = main.vault["pos"]
			main.player.global_position = vp + Vector2(-40, -12)
			main.camera.global_position = main.player.global_position
		340:
			_shot("11_vault_door")
			main.floor_num = 3
			main._reach_exit()
			_clear()
			main.state = "choice"
			paused = true
		345:
			_shot("12_exit_choice")
			main._choose(1)
			main._loading_tick(10.0)
		346:
			if main.state != "cine" and wait < 2000:
				wait += 1
				frame -= 1
				return false
			wait = 0
			for i in 15:
				main._cine_tick(0.1)
		360:
			_shot("13_boss_intro")
			for i in 4:
				main._cine_tick(0.1)
		395:
			_shot("14_boss_card")
			main.skip_cine()
			main.boss.state = "idle"
		420:
			main.boss.hurt(14)
		430:
			main.boss.iframes = 0.0
			main.boss.hurt(6)
			main.camera.zoom = Vector2(3.2, 3.2)
		440:
			_shot("15_boss_fight")
			main.state = "pause"
			paused = true
		445:
			_shot("16_pause_charms")
			main.state = "play"
			paused = false
			main.player.invuln = 0.0
			main.hp = 1
			main.pot = 900
			main.pot_mult = 2
			main._hurt(0.0, "Flattened by BIG SAL")
		530:
			_shot("17_collection_notice")
			main._enter_lobby(true)
			main.player.global_position = main.level.games.filter(func(gm): return gm[1] == "phone")[0][0] + Vector2(-24, -12)
			main.camera.global_position = main.player.global_position
		570:
			_shot("18_lobby_wake")
			for i in 12:
				main.tickets[i] = true
			main._open_menu("tickets")
		575:
			_shot("19_tickets")
			main._close_menu()
			main.pause_sel = 0
			main.state = "pause"
			main._open_settings()
		580:
			_shot("20_settings_graphics")
			main.settings.tab = 4
			main.settings.row = 4
		585:
			_shot("21_settings_controls")
			main.settings.tab = 3
			main.settings.row = 0
		590:
			_shot("22_settings_access")
			print("saved %d screenshots to %s" % [shots, OS.get_user_data_dir()])
			return true
	return false
