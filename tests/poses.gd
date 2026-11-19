extends SceneTree
## Renders a gallery of every animation pose to user://poses.png.
## Run (windowed): godot --path . --script res://tests/poses.gd

var PlayerScript
var EnemyScript

var main
var frame := 0
var cam: Camera2D


class Bg extends Node2D:
	func _draw() -> void:
		draw_rect(Rect2(-400, -300, 800, 700), Color(0.09, 0.05, 0.12))
		for y in [-4.0, 70.0, 144.0]:
			draw_rect(Rect2(-200, y, 400, 3), Color(0.09, 0.4, 0.25))


func _initialize() -> void:
	PlayerScript = load("res://scripts/player.gd")
	EnemyScript = load("res://scripts/enemy.gd")
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)


func _add_player(pos: Vector2, setup: Callable) -> void:
	var p = PlayerScript.new()
	p.cfg = main.movement
	p.level = main.level
	p.position = pos
	main.world.add_child(p)
	p.set_physics_process(false)
	p.process_mode = Node.PROCESS_MODE_ALWAYS
	p.z_index = 20
	setup.call(p)


func _process(_d: float) -> bool:
	frame += 1
	if frame == 3:
		main._start_run()
		main.state = "gallery"
		main.player.visible = false
		var bg := Bg.new()
		bg.z_index = 15
		bg.position = Vector2(2000, 2000)
		main.world.add_child(bg)
		cam = Camera2D.new()
		cam.zoom = Vector2(3.4, 3.4)
		cam.position = Vector2(2000, 2066)
		main.world.add_child(cam)
		cam.make_current()
		var base := Vector2(2000 - 140, 2000 - 4 - 11)
		var S = PlayerScript.S
		var setups := [
			func(p): p.force_ground = true,
			func(p): p.force_ground = true; p.velocity = Vector2(150, 0); p.run_phase = 0.0,
			func(p): p.force_ground = true; p.velocity = Vector2(150, 0); p.run_phase = 1.0,
			func(p): p.force_ground = true; p.velocity = Vector2(240, 0); p.run_phase = 3.0,
			func(p): p.velocity = Vector2(80, -300),
			func(p): p.velocity = Vector2(80, 300),
			func(p): p.wall_sliding = true; p.velocity = Vector2(0, 70),
			func(p): p.state = S.SLIDE; p.velocity = Vector2(180, 0),
		]
		for i in setups.size():
			_add_player(base + Vector2(i * 40, 0), setups[i])
		var setups2 := [
			func(p): p.state = S.WALL_RUN,
			func(p): p.state = S.LEDGE,
			func(p): p.state = S.VAULT,
			func(p): p.state = S.DASH; p.dash_dir = Vector2(1, 0),
			func(p): p.state = S.DASH; p.dash_dir = Vector2(1, -1).normalized(),
			func(p): p.state = S.CLIMB; p.state_t = 0.05,
			func(p): p.invuln = 1.1; p.force_ground = true,
		]
		for i in setups2.size():
			_add_player(base + Vector2(i * 40, 74), func(p): p.outfit_floor = 16; setups2[i].call(p))
		var setups3 := [
			func(p): p.force_ground = true; p.atk_t = p.cfg.attack_time * 0.6; p.atk_kind = "fwd",
			func(p): p.force_ground = true; p.atk_t = p.cfg.attack_time * 0.6; p.atk_kind = "fwd"; p.combo = 2,
			func(p): p.force_ground = true; p.atk_t = p.cfg.attack_time * 0.6; p.atk_kind = "up",
			func(p): p.velocity = Vector2(40, 120); p.atk_t = p.cfg.attack_time * 0.6; p.atk_kind = "down",
			func(p): p.force_ground = true; p.parry_t = 0.15,
			func(p): p.force_ground = true; p.worn = ["thrift_sneakers", "top_hat", "shades", "cape", "gold_chain"]; p.outfit_floor = 21,
			func(p): p.force_ground = true; p.worn = ["thrift_sneakers", "bucket_hat", "hawaiian", "cargo_shorts", "fanny_pack"]; p.outfit_floor = 3,
			func(p): p.force_ground = true; p.worn = ["thrift_sneakers", "bowtie", "eyepatch", "tux_pants", "wingtips", "grip_gloves"]; p.outfit_floor = 16,
		]
		for i in setups3.size():
			_add_player(base + Vector2(i * 40, 148), setups3[i])
		var g = EnemyScript.new()
		g.position = base + Vector2(7 * 40, 74 + 0.5)
		g.setup(0, main.level, main.player, 1)
		main.world.add_child(g)
		g.set_physics_process(false)
		g.process_mode = Node.PROCESS_MODE_ALWAYS
		g.z_index = 20
		var b = EnemyScript.new()
		b.position = base + Vector2(6 * 40 + 20, 40)
		b.setup(1, main.level, main.player, 1)
		b.awake = true
		main.world.add_child(b)
		b.set_physics_process(false)
		b.process_mode = Node.PROCESS_MODE_ALWAYS
		b.z_index = 20
	if frame > 3 and frame < 90:
		for n in main.world.get_children():
			if n is CharacterBody2D and n != main.player:
				n.t += 0.0  # poses settle via _process
	if frame == 90:
		var img := root.get_viewport().get_texture().get_image()
		img.save_png(OS.get_user_data_dir() + "/poses.png")
		print("saved")
		return true
	return false
