extends SceneTree
## Headless test for the Lobby, dialogue, charms, menus, loans, side bets,
## Vault Doors, tickets, cutscenes, Table Limits, Daily Deal and endings.
##   godot --headless --path . --script res://tests/systems.gd
## Uses its own save file, so your real save is never touched.

var main
var frame := 0
var fails := 0
var wait := 0


func _initialize() -> void:
	main = load("res://scenes/main.tscn").instantiate()
	main.save_path = "user://test_systems.cfg"
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_systems.cfg"))
	root.add_child(main)


func check(ok: bool, what: String) -> void:
	if not ok:
		fails += 1
	print(("PASS  " if ok else "FAIL  ") + what)


func _skip_cine() -> void:
	if main.state == "cine":
		main.skip_cine()


func _clear_dialog() -> void:
	if main.state == "dialog":
		main.dialog.clear()
		main._dialog_end()


func _process(_delta: float) -> bool:
	frame += 1
	match frame:
		3:
			# Charms: pipeline and rolls.
			var C = load("res://scripts/charms.gd")
			var ch = C.new()
			var r := RandomNumberGenerator.new()
			r.seed = 1
			check(ch.roll(r, 3).size() == 3, "charm roll gives 3")
			check(ch.pool("rare").is_empty(), "rare charms locked until licensed")
			ch.licensed["feather"] = true
			check(ch.pool("rare") == ["feather"], "licensed rare charm joins the pool")
			ch.equipped = ["spender", "housemoney"]
			check(ch.chip_value(10, {"flow_mult": 2, "pot_mult": 4}) == 60, "chip pipeline multiplies (10 x2 x1.5 x2 = 60)")
			ch.equipped = ["seven"]
			var got7 := 0
			for i in 7:
				got7 = ch.chip_value(1, {"flow_mult": 1})
			check(got7 == 7 and ch.seven_proc, "Lucky Seven pays 7x on the 7th chip")
			# Dialogue picker.
			var D = load("res://scripts/dialogue.gd")
			var e: Dictionary = D.pick("MARLOW", {"runs": 1}, {}, {}, r)
			check(e.get("id", "") == "marlow_intro", "first Marlow call is the intro")
			e = D.pick("MARLOW", {"runs": 2, "deaths": 1, "last_cause": "spikes"}, {"marlow_intro": true}, {}, r)
			check(e.get("id", "") == "marlow_spikes", "Marlow reacts to dying on spikes")
			e = D.pick("JULES", {"runs": 5}, {}, {}, r)
			check(e.is_empty(), "Jules has nothing to say before the ending")
		5:
			main._enter_lobby(false)
			check(main.in_hub and main.state == "cine", "first Lobby visit plays the intro cutscene")
			check(main.level.is_lobby and main.level.games.size() >= 8, "Lobby built with characters")
			check(not main.level.games.any(func(gm): return gm[1] == "jules" or gm[1] == "board"), "Jules and Table Limits hidden before the ending")
		8:
			# Let the cutscene run a bit to exercise pans/cards, then skip.
			for i in 40:
				main._cine_tick(0.05)
			_skip_cine()
			check(main.state == "play" and main.bars_target == 0.0, "intro cutscene skips cleanly")
			check(main.tip_title == "THE LOBBY", "Lobby tip shows after the intro")
			check(main.hub_new.get("VERA", false) and main.hub_new.get("MAGS", false), "new-dialogue markers over Vera and Mags")
			check(String(main.objective_lines()[0]).contains("DESCEND") and String(main.objective_lines()[1]).contains("!"), "objective: DESCEND first, talking is optional")
		10:
			main._hub_interact("phone")
			check(main.state == "dialog" and main.dialog[0][0] == "MARLOW", "payphone starts Marlow's intro")
			_clear_dialog()
			main._hub_interact("vera")
			check(main.state == "dialog", "Vera talks first")
			_clear_dialog()
			check(main.state == "menu" and main.menu.kind == "licenses", "then Vera's license menu opens")
			main.wallet = 5000
			main.menu.sel = 0
			main._menu_result(main.menu.press("confirm"))
			check(main.charms.licensed.size() == 1 and main.wallet < 5000, "bought a charm license")
			main._close_menu()
			main._hub_interact("mags")
			_clear_dialog()
			check(main.menu.kind == "loan", "Mags opens the loan desk")
			main.menu.sel = 0
			main._menu_result(main.menu.press("confirm"))
			check(main.pending_loan, "loan signed")
			main._close_menu()
			main._hub_interact("cat")
			check(main.cat_bonus > 0.0 and main.trophies.has("pet"), "petting Comp gives a Flow bonus")
			main._hub_interact("tickets")
			check(main.state == "menu" and main.menu.kind == "tickets", "tickets board opens")
			main._close_menu()
			main._hub_interact("trophies")
			check(main.state == "trophies", "trophy case opens from the Lobby")
			main._back_from_menu_screen()
			check(main.state == "play" and main.in_hub, "back to the Lobby")
		12:
			main._start_run()
			_clear_dialog()
			main.state = "play"
			paused = false
			check(not main.in_hub and main.pot == 200 and main._debt() == 300, "loan lands in the Pot, $300 owed")
			check(main.flow >= 25.0, "cat Flow bonus applied")
		14:
			# Charms + swap menu.
			for id in ["chalk", "cool", "magnet", "spender", "hang"]:
				main._give_charm(id)
			check(main.charms.full(), "5 charm slots filled")
			check(main.start_hp == main.base_hp - 1, "Big Spender costs a max life")
			check(main.player.cfg.wall_run_time > main.movement.wall_run_time, "Chalk Bag lengthens wall runs")
			main._offer_charm("pickpocket")
			check(main.state == "menu" and main.menu.kind == "swap", "full slots open the swap menu")
			main.menu.sel = 3
			main._menu_result(main.menu.press("confirm"))
			check(main.charms.has("pickpocket") and not main.charms.has("spender"), "swapped Big Spender out")
			check(main.start_hp == main.base_hp, "max life restored after swapping it out")
			main.state = "play"
			paused = false
		16:
			# Vera's shop on the floor.
			main.pot = 2000
			main.charms.equipped = ["chalk"]
			main._open_menu("shop")
			check(main.menu.items.size() == 7, "Vera's table: 3 charms + 2 clothes + weapon + reroll")
			main.menu.sel = 6
			main._menu_result(main.menu.press("confirm"))
			check(main.pot < 2000 and main.state == "menu", "reroll charged the Pot")
			main.menu.sel = 0
			main._menu_result(main.menu.press("confirm"))
			check(main.charms.equipped.size() == 2, "bought a charm from Vera")
			main.state = "play"
			paused = false
		18:
			# Side bets.
			main.pot = 500
			main._open_menu("bets")
			check(main.menu.items.size() == 4, "3 side bets + no bet")
			var pick := 0
			for i in 3:
				if main.menu.items[i]["id"] == "nodmg":
					pick = i
			main.menu.sel = pick
			var id: String = main.menu.items[pick]["id"]
			main._menu_result(main.menu.press("confirm"))
			check(main.menu.kind == "bet_stake" and main.menu.items.size() == 4, "stake picker: small / big / all in / never mind")
			main.menu.sel = 0
			var small_stake: int = main._bet_stake(0)
			main._menu_result(main.menu.press("confirm"))
			check(main.bet_used and main.active_bet.get("id", "") == id and main.pot == 500 - small_stake, "bet placed, stake taken")
			main.state = "play"
			paused = false
			if id == "nodmg":
				var before: int = main.pot
				main._resolve_bet_at_exit()
				check(main.pot > before, "clean-hands bet paid at the exit")
			else:
				main.active_bet["done"] = true
		20:
			# Chip spill + Rabbit's Foot.
			main.pot = 500
			main.hp = 3
			main.player.invuln = 0.0
			var chips_before: int = main.chips.size()
			main._hurt(main.player.global_position.x + 5, "Knocked out by a bouncer")
			check(main.pot == 400 and main.chips.size() > chips_before, "getting hit spills 20% of the Pot")
			main.charms.equipped.append("rabbit")
			main.hp = 1
			main.player.invuln = 0.0
			main._hurt(main.player.global_position.x + 5, "Knocked out by a bouncer")
			check(main.state == "play" and main.hp == 1 and main.pot == 0, "Rabbit's Foot dumps the Pot instead of busting")
		22:
			# Vault Door.
			main.vault = {}
			main.floor_num = 2
			var tries := 0
			while main.vault.is_empty() and tries < 20:
				main.run_seed += 1
				main._build_floor()
				tries += 1
			_skip_cine()
			check(not main.vault.is_empty(), "a Vault Door spawned on floor 2")
			main._try_vault()
			check(main.vault["state"] == "open" and main.charm_queue.size() > 0, "vault cracked, charm pick queued")
			main.charm_queue.clear()
		24:
			# Mags hunts past the deadline; cashing out pays her.
			main.pot = 0
			main.debt_principal = 200
			main.debt_interest = 100
			main.debt_deadline = 3
			main.floor_num = 5
			main.run_seed += 7
			main._build_floor()
			_skip_cine()
			main.state = "play"
			paused = false
			check(main.mags_node != null and int(main.pstats.get("defaulted", 0)) == 1, "Mags hunts after the deadline")
			main.pot = 400
			main.pot_mult = 1
			main._reach_exit()
			main.dialog.clear()
			main.state = "choice"
			var banked_before: int = main.banked
			main._choose(0)
			main._loading_tick(10.0)
			_skip_cine()
			check(main._debt() == 0 and main.banked - banked_before >= 100, "cash out paid Mags, kept the rest")
			check(main.trophies.has("loan"), "loan trophy")
		26:
			# Ticket pickup (the Queen is ticket 12).
			for i in 11:
				main.tickets[i] = true
			main.ticket_node = main.TicketNode.new()
			main.world.add_child(main.ticket_node)
			main._collect_ticket()
			check(main.flags.has("queen_found"), "ticket #12 is Vera's Queen of Spades")
		28:
			# Bust -> collection notice -> wake in the Lobby.
			main.state = "play"
			paused = false
			main.pot = 300
			main.pot_mult = 4
			main.charms.equipped.clear()
			main.hp = 1
			main.player.invuln = 0.0
			main._hurt(0.0, "Impaled on house spikes")
			check(main.state == "dead" and main.last_cause == "spikes" and main.lost_pot == 1200, "bust recorded: spikes, $1200 lost")
			check(FileAccess.file_exists("user://run_log.csv"), "run log written")
		30:
			main._enter_lobby(true)
			check(main.in_hub and main.bark_text != "", "woke in the Lobby, the House comments")
			main._hub_interact("phone")
			var said: String = main.dialog[0][1] if main.dialog.size() > 0 else ""
			check(said.contains("Spikes") or said.contains("times eight"), "Marlow reacts to the last bust")
			_clear_dialog()
			main._hub_interact("vera")
			while main.state == "dialog":
				_clear_dialog()
			check(main.seen.has("vera_queen_found") or main.seen.has("vera_bust"), "Vera has new reactive lines")
			main._close_menu()
		32:
			# Daily Deal: same floor for the same day.
			main._start_run(true)
			_clear_dialog()
			var seed_a: int = main.run_seed
			var exit_a: Vector2 = main.level.exit_pos
			main._start_run(true)
			_clear_dialog()
			check(main.run_seed == seed_a and main.level.exit_pos == exit_a, "Daily Deal floors are identical")
			check(not main.daily_scored, "second daily attempt is practice")
		34:
			# Ending unlocks: Table Limits and Jules in the Lobby.
			main.ending_seen = true
			main.flags["ending"] = true
			main.stakes_on = {"short": true, "edge": true}
			main._enter_lobby(false)
			check(main.level.games.any(func(gm): return gm[1] == "board") and main.level.games.any(func(gm): return gm[1] == "jules"), "board and Jules appear after the ending")
			check(main.heat() == 3, "Heat adds up from Table Limits")
			main._start_run()
			_clear_dialog()
			check(main.rules.has("edge") and main.start_hp == main.base_hp - 1, "Table Limits apply to the run")
			main.state = "play"
			paused = false
		36:
			# True ending: beat The House with every ticket, Vera freed, Marlow's confession.
			for i in 20:
				main.tickets[i] = true
			main.flags["vera_free"] = true
			main.flags["marlow_confessed"] = true
			main.floor_num = 12
			main._build_floor()
		37:
			if main.state != "cine" and wait < 600:
				wait += 1
				frame -= 1
				return false
			wait = 0
			check(main.state == "cine" and main.boss != null and main.boss.tier == 3, "boss intro cutscene for The House")
			_skip_cine()
			main.state = "play"
			paused = false
			main.boss.state = "idle"
			main.boss.hurt(9999)
		60:
			if main.state != "cine" and wait < 900:
				wait += 1
				frame -= 1
				return false
			check(main.flags.has("true_end") and main.trophies.has("true_end"), "true ending reached")
			check(main.state == "cine", "ending cutscene plays")
			var has_card := false
			for st in main.cine:
				if st.get("text", "") == "THE FREE HOUSE":
					has_card = true
			check(has_card, "true ending has its title card")
			_skip_cine()
			check(main.charm_queue.size() > 0, "boss spoils queued")
		62:
			main._tick_play(0.016)
			check(main.state == "menu" and main.menu.kind == "pick", "spoils open a charm pick")
			main.menu.sel = 0
			main._menu_result(main.menu.press("confirm"))
			# Settings: open from pause, change values, rebind a key, back out.
			main.state = "pause"
			main.pause_sel = 1
			Input.action_press("jump")
		63:
			main._pause_tick()
			Input.action_release("jump")
			check(main.state == "settings" and main.settings_return == "pause", "Settings opens from the pause menu")
			var st = main.settings
			st.tab = 3
			st.row = 1
			main._settings_result(st.press("right"))
			check(main.assist_invincible and main.assisted, "Accessibility: assist invincibility toggles and flags the run")
			st.tab = 2
			st.row = 0
			main._settings_result(st.press("left"))
			check(float(st.val("shake")) == 0.75, "Gameplay: screen shake steps down to 75%")
			st.tab = 0
			st.row = 7
			main._settings_result(st.press("left"))
			check(is_equal_approx(main.FXScript.particle_mult, 0.35), "Graphics: particles set to Low")
			st.row = 6
			main._settings_result(st.press("left"))
			check(main.LevelScript.shadow_quality == 1, "Graphics: shadows set to Hard")
			st.tab = 4
			st.row = 4
			main._settings_result(st.press("confirm"))
			check(st.rebinding == "jump", "Controls: waiting for a new jump key")
			var ev := InputEventKey.new()
			ev.physical_keycode = KEY_V
			ev.pressed = true
			main._input(ev)
			var has_v := false
			for e in InputMap.action_get_events("jump"):
				if e is InputEventKey and e.physical_keycode == KEY_V:
					has_v = true
			check(has_v and st.rebinding == "", "Controls: jump rebound to V")
			main._settings_result("reset_controls")
			has_v = false
			var has_space := false
			for e in InputMap.action_get_events("jump"):
				if e is InputEventKey and e.physical_keycode == KEY_V:
					has_v = true
				if e is InputEventKey and e.physical_keycode == KEY_SPACE:
					has_space = true
			check(not has_v and has_space, "Controls: reset restores Space")
			main._settings_result(st.press("back"))
			check(main.state == "pause", "Back returns to the pause menu")
			var cf := ConfigFile.new()
			cf.load("user://test_systems.cfg")
			var saved: Dictionary = cf.get_value("settings", "options", {})
			check(float(saved.get("shake", 1.0)) == 0.75, "Settings saved to disk")
			main.settings.reset_all()
			main._apply_settings()
			check(not main.assist_invincible and float(main.settings.val("shake")) == 1.0, "Reset all settings")
			# Cutscenes off: story still plays as dialogue.
			main.settings.set_val("cutscenes", "off")
			main.state = "play"
			paused = false
			main._cinematic([{"do": "bars", "v": 1.0}, {"do": "say", "lines": [["ROOK", "test"]]}])
			check(main.state == "dialog" and main.dialog.size() == 1, "Cutscenes off: dialogue still plays")
			main.dialog.clear()
			main._dialog_end()
			print("\n%d checks failed" % fails)
			return true
	return false
