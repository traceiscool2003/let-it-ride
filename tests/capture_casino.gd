extends SceneTree
## Screenshots of every casino game and the new progression screens.
##   xvfb-run godot --path . --script res://tests/capture_casino.gd

var main
var frame := 0
var C


func _initialize() -> void:
	C = load("res://scripts/casino.gd")
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_capture_casino.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_capture_casino.cfg"))
	root.add_child(main)


func _shot(n: String) -> void:
	var img := root.get_viewport().get_texture().get_image()
	img.save_png(OS.get_user_data_dir() + "/" + n + ".png")


func _open(g: String) -> void:
	main.state = "casino"
	main.pot = 2400
	main.casino.machine = C.new_machine()
	main.casino.open(g, 0, 6)
	main.casino.bet_i = 1


func _run(n: int) -> void:
	for i in n:
		main.pot += main.casino.update(0.05) + main.casino.take_pending()


func _process(_delta: float) -> bool:
	frame += 1
	var c = main.casino
	match frame:
		5:
			main._start_run()
			main.dialog.clear()
			main._dialog_end()
			main.state = "play"
			paused = false
		20:
			_open("slots")
			main.pot += c.press("confirm", main.pot)
			_run(60)
		25:
			_shot("c01_slots")
			_open("poker")
			main.pot += c.press("confirm", main.pot)
			c.held = [true, false, true, false, false]
			c.sel = 2
		30:
			_shot("c02_video_poker")
			_open("holdem")
			main.pot += c.press("confirm", main.pot)
		35:
			_shot("c03_holdem")
			main.pot += c.press("confirm", main.pot)
			_run(80)
		40:
			_shot("c04_holdem_result")
			_open("baccarat")
			main.pot += c.press("confirm", main.pot)
			c.press("right", main.pot)
		45:
			_shot("c05_baccarat_pick")
			c.press("confirm", main.pot)
			_run(80)
		50:
			_shot("c06_baccarat_result")
			_open("hilo")
			main.pot += c.press("confirm", main.pot)
			c.hl_card = 3
			c.hl_rung = 3
			c.hl_value = 260.0
			c.hl_history = [10, 22, 40, 3]
		55:
			_shot("c07_hilo")
			_open("roulette")
			main.pot += c.press("confirm", main.pot)
			c.pick = 7
		60:
			_shot("c08_roulette_board")
			_open("blackjack")
			main.pot += c.press("confirm", main.pot)
			c.sel = 2
		65:
			_shot("c09_blackjack")
			c.step = "result"
			c.win = 120
			c.msg = "YOU WIN  20 vs 18"
			c.msg_col = Color(0.6, 1, 0.6)
		70:
			_shot("c10_result_gamble_prompt")
			main.pot += c.press("up", main.pot)
		75:
			_shot("c11_double_or_nothing")
			main.state = "play"
			main.casino.done = true
			main.state = "skills"
			main.level_num = 7
			main.xp = 180
			main.skill_points = 4
			main.perks = {"skin1": 1, "blade1": 1, "parry1": 1, "spring": 1, "mag1": 1}
			main.skill_sel = 9
		80:
			_shot("c12_skill_tree")
			main.state = "play"
			main._enter_lobby(false)
			main.skip_cine()
		95:
			_shot("c13_lobby_level")
			main._start_run()
			main.dialog.clear()
			main._dialog_end()
			main.state = "play"
			paused = false
			main.coach_i = 1
		110:
			_shot("c14_coach")
			main.floor_num = 5
			main._build_floor()
			main.state = "play"
		125:
			_shot("c15_zone_back_rooms")
			main.floor_num = 9
			main._build_floor()
			main.state = "play"
		140:
			_shot("c16_zone_vault")
			main.floor_num = 13
			main._build_floor()
			main.state = "play"
		155:
			_shot("c17_zone_high_limit")
			quit()
	return false
