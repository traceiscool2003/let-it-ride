extends SceneTree
## Headless smoke test: godot --headless --path . --script res://tests/smoke.gd
## Exercises generation, combat, bosses, casino, bar, skills, pause, death.

var main
var frame := 0


func _initialize() -> void:
	var L = load("res://scripts/level.gd")
	var rng := RandomNumberGenerator.new()
	var bad := 0
	for s in 200:
		rng.seed = s
		var lv = L.new()
		root.add_child(lv)
		if s % 10 == 0:
			lv.generate_boss(rng, 1 + s % 3, [])
		else:
			lv.generate(rng, 1 + s % 12, ["edge", "security"] if s % 3 == 0 else [])
		var sp: Vector2 = lv.start_pos
		if lv.solid_at(sp) or lv.solid_at(sp + Vector2(0, -8)) or not lv.solid_at(sp + Vector2(0, 14)):
			bad += 1
		if lv.solid_at(lv.exit_pos + Vector2(0, -8)) or not lv.solid_at(lv.exit_pos + Vector2(0, 4)):
			bad += 1
		lv.free()
	print("generator: 200 floors, bad spawn/exit = ", bad)
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_save.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_save.cfg"))
	root.add_child(main)


func _press(a: String) -> void:
	Input.action_press(a)


func _release(a: String) -> void:
	Input.action_release(a)


func _process(_delta: float) -> bool:
	frame += 1
	match frame:
		5:
			main._start_run()
			main.dialog.clear()
			main._dialog_end()
			main.state = "play"
			paused = false
		10:
			_press("right")
		30:
			_press("attack")
		32:
			_release("attack")
		36:
			_press("attack")
		38:
			_release("attack")
		42:
			_press("parry")
		44:
			_release("parry")
		50:
			_press("jump")
		58:
			_release("jump")
		60:
			_press("dash")
		62:
			_release("dash")
		90:
			_press("down")
		110:
			_release("down")
			_release("right")
		120:
			main.casino.open("slots", 0, 1)
			main.pot = 500
			main.state = "casino"
			print("casino open ok")
		121:
			main.pot += main.casino.press("confirm", main.pot)
		200:
			main.pot += main.casino.update(0.1)
			main.casino.open("blackjack", 0, 1)
			main.pot += main.casino.press("confirm", main.pot)
			main.casino.press("right", main.pot)
			main.casino.press("confirm", main.pot)
		240:
			for i in 10:
				main.pot += main.casino.update(0.7)
			main.casino.open("roulette", 0, 1)
			main.pot += main.casino.press("confirm", main.pot)
			main.casino.press("confirm", main.pot)
			for i in 60:
				main.pot += main.casino.update(0.1)
			main.casino.open("bar", 0, 3)
			main.pot += main.casino.press("confirm", main.pot)
			print("casino games ok, bought=", main.casino.bought, " pot=", main.pot)
			main.state = "play"
			paused = false
		260:
			main.floor_num = 3
			main._reach_exit()
			main.dialog.clear()
			main.state = "choice"
		270:
			main._choose(1)
			main._loading_tick(10.0)
			main.dialog.clear()
			main._dialog_end()
			print("boss floor: ", main.level.is_boss, " boss=", main.boss.bname if main.boss else "none")
		280:
			main.state = "play"
			paused = false
			main.boss.state = "idle"
		400:
			print("boss hp ", main.boss.hp, "/", main.boss.max_hp, " projectiles=", main.projectiles.size(), " state=", main.boss.state)
			main.boss.hurt(999)
		500:
			main.dialog.clear()
			main.state = "play"
			paused = false
			print("boss defeated, exit locked=", main.level.exit_locked, " chips=", main.chips.size())
		520:
			main.state = "pause"
			main._pause_tick()
			main.state = "skills"
			main.wallet = 99999
			main._skills_tick()
			main.perks["skin1"] = 1
			print("perk skin=", main.perk("skin"), " trophies=", main.trophies.size())
			main.state = "play"
		530:
			main.player.invuln = 0.0
			main.hp = 1
			main._hurt(0.0, "test")
		600:
			print("final state=", main.state, " floor=", main.floor_num, " wallet=", main.wallet)
			return true
	return false
