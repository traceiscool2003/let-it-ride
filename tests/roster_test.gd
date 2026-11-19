extends SceneTree
## Spawns every enemy kind and fires every weapon, then runs frames to catch runtime errors.
## godot --headless --path . --script res://tests/roster_test.gd

var main
var frame := 0
var fails := 0


func check(ok: bool, msg: String) -> void:
	print(("ok    " if ok else "FAIL  ") + msg)
	if not ok:
		fails += 1


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_roster.cfg"
	root.add_child(main)


func _process(_d: float) -> bool:
	frame += 1
	match frame:
		5:
			main._start_run()
			main.dialog.clear()
			main._dialog_end()
			main.state = "play"
			paused = false
		10:
			var ET = load("res://scripts/enemy_types.gd")
			for k in ET.T:
				if k == 13:
					continue
				main._spawn_enemy(main.player.global_position + Vector2(60 + (k % 5) * 10, -8), k)
			check(main.enemies.size() >= 10, "spawned %d enemies of every type" % main.enemies.size())
			var rng := RandomNumberGenerator.new()
			var kinds := {}
			for f in [1, 6, 11, 16, 21]:
				for i in 80:
					kinds[ET.pick(f, false, rng)] = true
					kinds[ET.pick(f, true, rng)] = true
			check(kinds.size() >= 10, "%d distinct enemy kinds appear across the cities" % kinds.size())
		12:
			main.pot = 500
			main.nerve = 99
			var W = load("res://scripts/weapons.gd")
			for id in W.ids():
				main.give_weapon(id)
				main.weapon_id = id
				main.shoot_cd = 0.0
				main._fire_weapon()
			check(main.projectiles.size() >= 8, "all weapons fired (%d projectiles)" % main.projectiles.size())
		20:
			main.pot = 3000
			main.charms.equipped = ["chalk", "cool"]
			for k in ["tailor", "fizz", "gunny", "shady", "shop"]:
				main._open_menu(k)
				check(main.menu.items.size() > 0, "menu %s opens with items" % k)
				main._menu_result(main.menu.press("confirm"))
				main.state = "play"
				paused = false
			for i in 12:
				main._drink_fizz()
			main.hp = main.start_hp
			check(main.run_swag() is int, "swag computed")
			for i in 5:
				main._offer_charm("chalk")
			check(main.charms.count("chalk") >= 2, "charms stack")
		25:
			for c in ["velma", "dumpster_dan", "slick_nick", "lorraine", "dunn", "comp"]:
				main._talk_npc(c)
			main.crowd_cd = 0.0
			main._crowd_bark(0.1)
			main.dialog.clear()
			main.state = "play"
			paused = false
			check(main.bark_text != "", "crowd bark: " + main.bark_text.left(40))
		30:
			main.floor_num = 3
			main._enter_secret()
			main._loading_tick(10.0)
			main._loading_tick(10.0)
			check(main.boss != null and main.in_secret and main.boss.def["id"] in ["snake_eyes", "rusty_slots"], "secret boss arena built")
		70:
			check(main.state in ["play", "dead", "menu", "dialog", "cine", "loading"], "still running after 60 frames: " + main.state)
			print("roster test: ", fails, " failed")
			quit(1 if fails > 0 else 0)
	return false
