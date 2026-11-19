extends SceneTree
## Every boss: build its arena, run its full attack deck through all 3 phases, kill it.
## godot --headless --path . --script res://tests/boss_test.gd

var main
var frame := 0
var fails := 0
var idx := 0
var ids: Array = []
var BD


func check(ok: bool, msg: String) -> void:
	print(("ok    " if ok else "FAIL  ") + msg)
	if not ok:
		fails += 1


func _initialize() -> void:
	BD = load("res://scripts/boss_defs.gd")
	for d in BD.POOL:
		ids.append(d["id"])
	for d in BD.SECRET:
		ids.append(d["id"])
	ids.append("house")
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_boss.cfg"
	root.add_child(main)


func _process(_d: float) -> bool:
	frame += 1
	if frame == 5:
		main._start_run()
		main.dialog.clear()
		main._dialog_end()
	if frame >= 6 and (frame - 6) % 400 == 0:
		if idx > 0:
			check(main.boss != null and main.boss.phase >= 1, "%s fought through" % ids[idx - 1])
		if idx >= ids.size():
			print("boss test: ", fails, " failed")
			quit(1 if fails > 0 else 0)
			return true
		main.boss_order = [ids[idx], ids[idx], ids[idx], ids[idx]]
		main.floor_num = 5 if ids[idx] != "house" else 25
		main.run_seed = 1
		main._build_floor()
		main.cine.clear()
		main.state = "play"
		paused = false
		main.boss.state = "idle"
		main.pot = 100
		idx += 1
	elif frame > 6:
		var ph := (frame - 6) % 400
		if ph == 100 and main.boss:
			main.boss.hurt(main.boss.max_hp / 2)
			main.state = "play"
			paused = false
		if ph == 200 and main.boss:
			main.boss.hurt(main.boss.max_hp / 4)
			main.state = "play"
			paused = false
		main.player.invuln = 5.0
		if main.state == "menu":
			main.state = "play"
			paused = false
	return false
