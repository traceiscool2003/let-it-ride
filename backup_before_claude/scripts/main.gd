extends Node
## Game director: run state, Pot / Bankroll economy, Flow, House Rules,
## combat resolution, bosses, breakables, casino games, story, perks (The
## Fence), lighting, post-processing, adaptive music.

const LevelScript := preload("res://scripts/level.gd")
const PlayerScript := preload("res://scripts/player.gd")
const EnemyScript := preload("res://scripts/enemy.gd")
const BossScript := preload("res://scripts/boss.gd")
const ProjScript := preload("res://scripts/projectile.gd")
const ChipScript := preload("res://scripts/chip.gd")
const PropScript := preload("res://scripts/prop.gd")
const FXScript := preload("res://scripts/fx.gd")
const FoliageScript := preload("res://scripts/foliage.gd")
const AmbientScript := preload("res://scripts/ambient.gd")
const HUDScript := preload("res://scripts/hud.gd")
const CasinoScript := preload("res://scripts/casino.gd")
const Story := preload("res://scripts/story.gd")

const RULES := {
	"heavy": {"name": "HEAVY POCKETS", "desc": "Gravity +25%"},
	"loiter": {"name": "NO LOITERING", "desc": "Flow drains 3x faster"},
	"edge": {"name": "HOUSE EDGE", "desc": "Twice the spikes"},
	"security": {"name": "SECURITY DETAIL", "desc": "Twice the guards and bats"},
	"lights": {"name": "LIGHTS OUT", "desc": "The power's been cut"},
	"lastcall": {"name": "LAST CALL", "desc": "40s on the clock, then the Pot bleeds"},
	"glass": {"name": "GLASS JAW", "desc": "Any hit busts you"},
	"grounded": {"name": "GROUNDED", "desc": "No air dash"},
}

## Skill tree: three branches, each node requires the one above it.
const SKILLS := [
	{"id": "skin1", "name": "THICK SKIN", "desc": "+1 max life", "branch": 0, "tier": 0, "cost": 300, "grants": {"skin": 1}},
	{"id": "warm1", "name": "HOT STREAK", "desc": "Start every floor with 25 Flow", "branch": 0, "tier": 1, "cost": 700, "grants": {"warm": 1}},
	{"id": "dash2", "name": "SECOND WIND", "desc": "A second air dash", "branch": 0, "tier": 2, "cost": 1500, "grants": {"dash": 1}},
	{"id": "skin2", "name": "IRON HIDE", "desc": "+1 more max life", "branch": 0, "tier": 3, "cost": 3200, "grants": {"skin": 1}},
	{"id": "blade1", "name": "BRASS KNUCKLES", "desc": "+1 strike damage", "branch": 1, "tier": 0, "cost": 400, "grants": {"blade": 1}},
	{"id": "parry1", "name": "IRON NERVE", "desc": "Much wider parry window", "branch": 1, "tier": 1, "cost": 800, "grants": {"parry": 2}},
	{"id": "hay", "name": "HAYMAKER", "desc": "Combo finishers deal +2 damage", "branch": 1, "tier": 2, "cost": 1600, "grants": {"haymaker": 2}},
	{"id": "blade2", "name": "LOADED GLOVES", "desc": "+1 more strike damage", "branch": 1, "tier": 3, "cost": 3200, "grants": {"blade": 1}},
	{"id": "mag1", "name": "STICKY FINGERS", "desc": "Much bigger chip magnet", "branch": 2, "tier": 0, "cost": 250, "grants": {"magnet": 2}},
	{"id": "luck1", "name": "LOADED DICE", "desc": "Luckier slots, more gold chips", "branch": 2, "tier": 1, "cost": 700, "grants": {"luck": 2}},
	{"id": "ins1", "name": "INSURANCE", "desc": "Keep 30% of the Pot when you bust", "branch": 2, "tier": 2, "cost": 1500, "grants": {"insure": 2}},
	{"id": "stake", "name": "HIGH ROLLER", "desc": "Start every run with $150 in the Pot", "branch": 2, "tier": 3, "cost": 3000, "grants": {"stake": 1}},
]

## Playable runners.
const CHARACTERS := [
	{"name": "ROOK", "desc": "Balanced. Fast hands, faster feet.", "lock": "", "hood": Color(0.30, 0.18, 0.45), "hood_l": Color(0.47, 0.31, 0.64), "speed": 1.0, "hp": 0, "dmg": 0, "flow": 0.0},
	{"name": "DICE", "desc": "Glass cannon speedster. +12% speed, starts hot, -1 life.", "lock": "Beat Big Sal to unlock.", "hood": Color(0.15, 0.45, 0.55), "hood_l": Color(0.25, 0.65, 0.75), "speed": 1.12, "hp": -1, "dmg": 0, "flow": 40.0},
	{"name": "JULES", "desc": "The brother. Heavy hitter: +1 life, +1 damage, a bit slower.", "lock": "Finish the story to unlock.", "hood": Color(0.2, 0.45, 0.3), "hood_l": Color(0.3, 0.6, 0.4), "speed": 0.93, "hp": 1, "dmg": 1, "flow": 0.0},
]

const TROPHIES := [
	{"id": "first_bank", "name": "Walk Away", "desc": "Cash out for the first time"},
	{"id": "ride8", "name": "Let It Ride", "desc": "Reach a x8 Pot multiplier"},
	{"id": "flow5", "name": "In The Zone", "desc": "Hit the x5 Flow tier"},
	{"id": "chain30", "name": "Unbroken", "desc": "Chain 30 moves"},
	{"id": "parry10", "name": "Iron Wall", "desc": "Parry 10 times in one run"},
	{"id": "smash25", "name": "Bull In A Casino", "desc": "Smash 25 things in one run"},
	{"id": "boss1", "name": "Sal's Out", "desc": "Defeat Big Sal"},
	{"id": "boss2", "name": "Wheel Stops", "desc": "Defeat Madame Roulette"},
	{"id": "boss3", "name": "House Falls", "desc": "Defeat The House"},
	{"id": "jackpot", "name": "Triple Seven", "desc": "Hit the slot machine jackpot", "secret": true},
	{"id": "blackjack", "name": "Natural", "desc": "Win with a blackjack"},
	{"id": "rich", "name": "High Roller", "desc": "Bank $2,000 in one run"},
	{"id": "greedy", "name": "Should've Banked", "desc": "Bust with $1,000+ at risk", "secret": true},
	{"id": "drinks", "name": "Regular", "desc": "Buy a drink from Lucky"},
]

const RED_C := Color(1.0, 0.35, 0.35)

const POST_SHADER := """
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float iris = 2.0;
uniform vec2 iris_center = vec2(0.5);
uniform float hurt = 0.0;
uniform float flow = 0.0;
uniform float slowmo = 0.0;
void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 col = texture(screen_tex, uv).rgb;
	vec3 blur = textureLod(screen_tex, uv, 2.5).rgb * 0.5 + textureLod(screen_tex, uv, 4.5).rgb * 0.5;
	col += max(blur - vec3(0.32), vec3(0.0)) * 0.9;
	float l = dot(col, vec3(0.299, 0.587, 0.114));
	col = mix(vec3(l), col, 1.1 + flow * 0.25);
	col *= vec3(1.03, 0.98, 1.06);
	vec2 d = uv - 0.5;
	d.x *= 1.6;
	float v = smoothstep(0.42, 1.05, length(d));
	col *= 1.0 - v * 0.6;
	col = mix(col, vec3(0.65, 0.0, 0.06), v * hurt);
	col = mix(col, vec3(l) * vec3(0.85, 0.95, 1.15), slowmo * 0.55);
	vec2 q = uv - iris_center;
	q.x *= 1.7778;
	col *= 1.0 - smoothstep(iris - 0.03, iris, length(q));
	COLOR = vec4(col, 1.0);
}
"""

@export var movement: MovementConfig

@export_group("Flow")
@export var flow_gains := {
	"WALL JUMP": 14.0, "WALL RUN": 16.0, "MANTLE": 9.0, "LEDGE HOP": 8.0,
	"SLIDE": 8.0, "SLIDE JUMP": 11.0, "SLIDE KICK": 18.0, "VAULT": 14.0,
	"AIR DASH": 7.0, "STOMP": 18.0, "STRIKE": 6.0, "FINISHER": 14.0, "POGO": 16.0,
	"PARRY": 22.0, "SMASH": 7.0, "BOSS HIT": 8.0, "BOSS STOMP": 20.0, "KO": 12.0,
}
@export var flow_max := 100.0
@export var flow_tier_size := 25.0
@export var flow_idle_drain := 5.0
@export var flow_stopped_drain := 55.0
@export var flow_stop_speed := 45.0
@export var flow_stop_grace := 0.6
@export var flow_repeat_penalty := 0.3

@export_group("Run")
@export var base_hp := 3
@export var last_call_time := 40.0
@export var last_call_bleed := 0.08
@export var boss_every := 4

var state := "title"
var rng := RandomNumberGenerator.new()
var world: Node2D
var level
var player
var boss
var fx
var camera: Camera2D
var player_light: PointLight2D
var enemies: Array = []
var chips: Array = []
var props: Array = []
var projectiles: Array = []
var hud
var post: ColorRect
var dark_rect: ColorRect
var unshaded: CanvasItemMaterial
var casino

var hp := 3
var start_hp := 3
var pot := 0
var pot_mult := 1
var banked := 0
var floor_num := 1
var rules: Array = []
var pending_rule := ""
var choice_idx := 0
var choice_t := 0.0
var flow := 0.0
var chain := 0
var best_chain := 0
var last_move := ""
var stop_t := 0.0
var popups: Array = []
var banner_t := 0.0
var banner_sub := ""
var trauma := 0.0
var last_call_left := -1.0
var bleed_acc := 0.0
var dead_t := 0.0
var death_reason := ""
var death_quip := ""
var lost_pot := 0
var kept_pot := 0
var new_best := false
var run_time := 0.0
var iris_t := 0.0
var hurt_flash := 0.0
var slowmo := 0.0
var callout := ""
var callout_t := 0.0
var callout_col := Color.WHITE
var boss_shout := ""
var boss_shout_t := 0.0
var interact_text := ""
var interact_pos := Vector2.ZERO
var stats := {}

# Dialogue.
var dialog: Array = []
var dialog_chars := 0.0
var dialog_after := ""
# Menus.
var title_sel := 0
var skill_sel := 0
var skill_msg := ""
var pause_sel := 0
var char_i := 0
var toasts: Array = []
var trophies := {}
var music_vol := 0.8
var sfx_vol := 0.8
var run_dmg_bonus := 0
var run_cfg: MovementConfig
var chip_mult := 1

# Persistent.
var best := 0
var wallet := 0
var lifetime := 0
var runs := 0
var perks := {}
var intro_seen := false
var exit_tip_seen := false
var bosses_beaten := 0
var ending_seen := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if movement == null:
		movement = load("res://config/movement.tres")
	rng.randomize()
	_setup_input()
	_load()
	call_deferred("_apply_volume")
	unshaded = CanvasItemMaterial.new()
	unshaded.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	casino = CasinoScript.new()

	var post_layer := CanvasLayer.new()
	post_layer.layer = 4
	add_child(post_layer)
	post = ColorRect.new()
	post.size = Vector2(1280, 720)
	post.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = POST_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	post.material = mat
	post_layer.add_child(post)
	dark_rect = ColorRect.new()
	dark_rect.visible = false

	var hud_layer := CanvasLayer.new()
	hud_layer.layer = 10
	add_child(hud_layer)
	hud = HUDScript.new()
	hud.g = self
	hud_layer.add_child(hud)

	_build_floor()
	get_tree().paused = true
	state = "title"


## Sum of an effect granted by every owned skill node.
func perk(id: String) -> int:
	var n := 0
	for sk in SKILLS:
		if perks.has(sk["id"]):
			n += int((sk["grants"] as Dictionary).get(id, 0))
	return n


func has_skill(id: String) -> bool:
	return perks.has(id)


func skill_available(sk: Dictionary) -> bool:
	if has_skill(sk["id"]):
		return false
	if int(sk["tier"]) == 0:
		return true
	for o in SKILLS:
		if o["branch"] == sk["branch"] and int(o["tier"]) == int(sk["tier"]) - 1:
			return has_skill(o["id"])
	return false


func char_unlocked(i: int) -> bool:
	match i:
		1: return bosses_beaten >= boss_every
		2: return ending_seen
	return true


func title_items() -> Array:
	return ["DESCEND", "THE FENCE  (skill tree)", "TROPHY CASE"]


func pause_items() -> Array:
	return ["RESUME", "MUSIC  < %d%% >" % int(music_vol * 100), "SOUND  < %d%% >" % int(sfx_vol * 100), "RESTART RUN", "QUIT TO TITLE"]


func unlock(id: String) -> void:
	if trophies.has(id):
		return
	for tr in TROPHIES:
		if tr["id"] == id:
			trophies[id] = true
			toasts.append({"text": "TROPHY UNLOCKED", "sub": tr["name"], "t": 4.0})
			Sfx.play("buy")
			_save()
			return


# ---------------------------------------------------------------- input map

func _setup_input() -> void:
	var keys := {
		"left": [KEY_A, KEY_LEFT], "right": [KEY_D, KEY_RIGHT],
		"up": [KEY_W, KEY_UP], "down": [KEY_S, KEY_DOWN],
		"jump": [KEY_SPACE, KEY_Z, KEY_C],
		"dash": [KEY_SHIFT, KEY_X],
		"attack": [KEY_F, KEY_J],
		"parry": [KEY_Q, KEY_K],
		"confirm": [KEY_ENTER, KEY_KP_ENTER],
		"restart": [KEY_R], "pause": [KEY_ESCAPE, KEY_P],
		"choose1": [KEY_1], "choose2": [KEY_2],
	}
	var pads := {
		"left": [JOY_BUTTON_DPAD_LEFT], "right": [JOY_BUTTON_DPAD_RIGHT],
		"up": [JOY_BUTTON_DPAD_UP], "down": [JOY_BUTTON_DPAD_DOWN],
		"jump": [JOY_BUTTON_A], "dash": [JOY_BUTTON_B, JOY_BUTTON_RIGHT_SHOULDER],
		"attack": [JOY_BUTTON_X], "parry": [JOY_BUTTON_LEFT_SHOULDER, JOY_BUTTON_Y],
		"pause": [JOY_BUTTON_START], "restart": [JOY_BUTTON_BACK],
	}
	var axes := {
		"left": [JOY_AXIS_LEFT_X, -1.0], "right": [JOY_AXIS_LEFT_X, 1.0],
		"up": [JOY_AXIS_LEFT_Y, -1.0], "down": [JOY_AXIS_LEFT_Y, 1.0],
	}
	for a in keys:
		if not InputMap.has_action(a):
			InputMap.add_action(a, 0.35)
		for k in keys[a]:
			var ev := InputEventKey.new()
			ev.physical_keycode = k
			InputMap.action_add_event(a, ev)
	for a in pads:
		for b in pads[a]:
			var ev := InputEventJoypadButton.new()
			ev.button_index = b
			InputMap.action_add_event(a, ev)
	for a in axes:
		var ev := InputEventJoypadMotion.new()
		ev.axis = axes[a][0]
		ev.axis_value = axes[a][1]
		InputMap.action_add_event(a, ev)


func _jp(a: String) -> bool:
	return Input.is_action_just_pressed(a)


# ---------------------------------------------------------------- run flow

func _start_run() -> void:
	Engine.time_scale = 1.0
	if not char_unlocked(char_i):
		char_i = 0
	var ch: Dictionary = CHARACTERS[char_i]
	run_cfg = movement.duplicate()
	run_cfg.max_run_speed *= ch["speed"]
	run_cfg.dash_speed *= ch["speed"]
	run_cfg.wall_run_min_speed *= ch["speed"]
	run_dmg_bonus = ch["dmg"]
	start_hp = maxi(1, base_hp + perk("skin") + int(ch["hp"]))
	hp = start_hp
	pot = 150 if perk("stake") > 0 else 0
	pot_mult = 1
	banked = 0
	floor_num = 1
	rules = []
	best_chain = 0
	new_best = false
	run_time = 0.0
	runs += 1
	stats = {"kills": 0, "parries": 0, "smashed": 0, "chips": 0, "bosses": 0, "casino": 0}
	banner_sub = Story.WHISPERS[rng.randi_range(0, Story.WHISPERS.size() - 1)]
	_build_floor()
	state = "play"
	get_tree().paused = false
	Sfx.play("start")
	if not intro_seen:
		intro_seen = true
		_save()
		_say(Story.INTRO, "")
	elif rng.randf() < 0.7:
		_say([Story.RADIO[rng.randi_range(0, Story.RADIO.size() - 1)]], "")


func is_boss_floor() -> bool:
	return floor_num % boss_every == 0


func _build_floor() -> void:
	if world:
		world.queue_free()
	enemies.clear()
	chips.clear()
	props.clear()
	projectiles.clear()
	boss = null
	world = Node2D.new()
	world.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(world)
	move_child(world, 0)

	var cm := CanvasModulate.new()
	cm.color = Color(0.07, 0.06, 0.1) if rules.has("lights") else Color(0.52, 0.44, 0.6)
	world.add_child(cm)

	level = LevelScript.new()
	world.add_child(level)
	if is_boss_floor():
		level.generate_boss(rng, ((floor_num / boss_every) - 1) % 3 + 1, rules)
	else:
		level.generate(rng, floor_num, rules)
	level.broke.connect(_on_broke)
	level.crumble_started.connect(_on_crumble)

	for s in level.chip_spots:
		var v: int = s[1]
		if v == 5 and rng.randf() < perk("luck") * 0.08:
			v = 25
		_add_chip(s[0], v)

	for s in level.prop_spots:
		var p = PropScript.new()
		p.kind = ["crate", "urn", "case"][s[1]]
		p.position = s[0]
		world.add_child(p)
		props.append(p)
	for gm in level.games:
		if gm[1] != "slots":
			var p = PropScript.new()
			p.kind = gm[1]
			p.position = gm[0]
			world.add_child(p)

	player = PlayerScript.new()
	player.cfg = run_cfg if run_cfg else movement
	var ch: Dictionary = CHARACTERS[char_i]
	player.hood = ch["hood"]
	player.hood_l = ch["hood_l"]
	player.level = level
	player.position = level.start_pos
	player.gravity_mult = 1.25 if rules.has("heavy") else 1.0
	player.dash_enabled = not rules.has("grounded")
	player.dash_max = 1 + perk("dash")
	player.dashes = player.dash_max
	player.parry_bonus = perk("parry") * 0.05
	world.add_child(player)
	player.move_done.connect(_on_move)
	player.landed.connect(_on_land)
	player_light = PointLight2D.new()
	player_light.texture = LevelScript.light_tex()
	player_light.color = Color(0.85, 0.85, 1.0)
	player_light.energy = 1.1 if rules.has("lights") else 0.55
	player_light.texture_scale = 1.0 if rules.has("lights") else 0.75
	player_light.shadow_enabled = rules.has("lights")
	player.add_child(player_light)

	for s in level.enemy_spots:
		_spawn_enemy(s[0], s[1])

	if level.is_boss:
		boss = BossScript.new()
		boss.position = level.boss_spawn + Vector2(0, -18)
		boss.setup(floor_num, level, player)
		world.add_child(boss)
		boss.fire.connect(_on_boss_fire)
		boss.summon.connect(_on_boss_summon)
		boss.slammed.connect(_on_boss_slam)
		boss.phase_changed.connect(_on_boss_phase)
		boss.defeated.connect(_on_boss_defeated)

	fx = FXScript.new()
	fx.material = unshaded
	world.add_child(fx)
	player.fx = fx

	var fol = FoliageScript.new()
	fol.setup(level, player)
	world.add_child(fol)

	camera = Camera2D.new()
	camera.zoom = Vector2(2, 2) if level.is_boss else Vector2(3, 3)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = level.w * level.T
	camera.limit_bottom = level.h * level.T
	world.add_child(camera)
	camera.global_position = player.global_position
	camera.make_current()

	var amb = AmbientScript.new()
	amb.setup(level, camera)
	world.add_child(amb)

	last_call_left = last_call_time if rules.has("lastcall") else -1.0
	bleed_acc = 0.0
	flow = minf(flow_max, perk("warm") * 25.0 + float(ch["flow"]))
	chain = 0
	last_move = ""
	stop_t = 0.0
	popups.clear()
	banner_t = 2.8
	chip_mult = 1
	iris_t = 0.0
	if is_boss_floor() and state == "play":
		var tier: int = boss.tier
		_say(Story.BOSS_INTRO[tier], "")


func _add_chip(pos: Vector2, v: int):
	var c = ChipScript.new()
	c.value = v
	c.position = pos
	c.material = unshaded
	world.add_child(c)
	chips.append(c)
	return c


func _spawn_loose(pos: Vector2, values: Array) -> void:
	for v in values:
		var c = _add_chip(pos, v)
		c.launch(level, Vector2(rng.randf_range(-120, 120), rng.randf_range(-280, -140)))


func _spawn_enemy(pos: Vector2, kind: int) -> void:
	var e = EnemyScript.new()
	if kind == 0 and not level.is_boss:
		var r := rng.randf()
		if floor_num >= 2 and r < 0.25:
			kind = 2
		elif floor_num >= 3 and r < 0.42:
			kind = 3
	e.position = pos
	e.setup(kind, level, player, floor_num)
	world.add_child(e)
	e.fire.connect(_on_boss_fire)
	enemies.append(e)


func _reach_exit() -> void:
	state = "choice"
	choice_idx = 0
	choice_t = 0.0
	var avail: Array = RULES.keys().filter(func(k): return not rules.has(k))
	pending_rule = avail[rng.randi_range(0, avail.size() - 1)] if avail.size() > 0 else ""
	get_tree().paused = true
	Sfx.play("door")
	if not exit_tip_seen:
		exit_tip_seen = true
		_save()
		_say(Story.FIRST_EXIT, "choice")


func _choose(i: int) -> void:
	if i == 0:
		var gain := pot * pot_mult
		if gain > 0:
			unlock("first_bank")
		banked += gain
		banner_sub = "CASHED OUT  +$%d   (rules cleared, +1 life)" % gain
		pot = 0
		pot_mult = 1
		rules.clear()
		hp = mini(hp + 1, start_hp)
		Sfx.play("bank")
	else:
		pot_mult *= 2
		if pending_rule != "":
			rules.append(pending_rule)
			banner_sub = "LET IT RIDE  x%d   NEW RULE: %s" % [pot_mult, RULES[pending_rule]["name"]]
		else:
			banner_sub = "LET IT RIDE  x%d" % pot_mult
		Sfx.play("ride")
	if banked > best:
		best = banked
		new_best = true
	floor_num += 1
	state = "play"
	get_tree().paused = false
	_build_floor()
	_save()


func _die(reason: String) -> void:
	state = "dead"
	dead_t = 0.0
	death_reason = reason
	lost_pot = pot * pot_mult
	kept_pot = int(lost_pot * perk("insure") * 0.15)
	if lost_pot >= 1000:
		unlock("greedy")
	banked += kept_pot
	pot = 0
	player.die()
	Sfx.play("die")
	shake(1.0)
	slowmo = 1.0
	death_quip = Story.DEATH_QUIPS[rng.randi_range(0, Story.DEATH_QUIPS.size() - 1)]
	_end_run()


func _end_run() -> void:
	if banked > best:
		best = banked
		new_best = true
	wallet += banked
	lifetime += banked
	_save()


# ---------------------------------------------------------------- dialogue

func _say(lines: Array, after: String) -> void:
	for l in lines:
		dialog.append(l)
	if state != "dialog":
		dialog_after = after if after != "" else state
		state = "dialog"
		get_tree().paused = true
	dialog_chars = 0.0


func _dialog_tick(delta: float) -> void:
	if dialog.is_empty():
		_dialog_end()
		return
	var line: String = dialog[0][1]
	dialog_chars += delta * 55.0
	if _jp("jump") or _jp("confirm") or _jp("attack"):
		if dialog_chars < line.length():
			dialog_chars = line.length()
		else:
			dialog.pop_front()
			dialog_chars = 0.0
			Sfx.play("blip", 1.4)
			if dialog.is_empty():
				_dialog_end()
	elif int(dialog_chars) % 3 == 0 and dialog_chars < line.length():
		pass


func _dialog_end() -> void:
	state = dialog_after
	get_tree().paused = state != "play"


# ---------------------------------------------------------------- loop

func _process(delta: float) -> void:
	match state:
		"title":
			Music.intensity = 0.0
			var n := title_items().size()
			if _jp("up"):
				title_sel = (title_sel + n - 1) % n
				Sfx.play("tick")
			if _jp("down"):
				title_sel = (title_sel + 1) % n
				Sfx.play("tick")
			if _jp("left"):
				char_i = (char_i + CHARACTERS.size() - 1) % CHARACTERS.size()
				Sfx.play("tick")
			if _jp("right"):
				char_i = (char_i + 1) % CHARACTERS.size()
				Sfx.play("tick")
			if _jp("jump") or _jp("confirm"):
				match title_sel:
					0:
						if char_unlocked(char_i):
							_start_run()
						else:
							Sfx.play("deny")
					1:
						state = "skills"
						skill_msg = ""
						Sfx.play("door")
					2:
						state = "trophies"
						Sfx.play("door")
		"skills":
			_skills_tick()
		"trophies":
			if _jp("pause") or _jp("dash") or _jp("jump") or _jp("confirm"):
				state = "title"
				Sfx.play("tick")
		"pause":
			_pause_tick()
		"dialog":
			_dialog_tick(delta)
		"casino":
			Music.intensity = 0.0
			for a in ["left", "right", "confirm", "back"]:
				var pressed := false
				match a:
					"confirm":
						pressed = _jp("jump") or _jp("confirm")
					"back":
						pressed = _jp("down") or _jp("pause")
					_:
						pressed = _jp(a)
				if pressed:
					var before := pot
					pot = maxi(0, pot + casino.press(a, pot))
					if pot < before:
						stats["casino"] = stats.get("casino", 0) + 1
			var gain: int = casino.update(delta)
			if casino.achievement != "":
				unlock(casino.achievement)
				casino.achievement = ""
			if casino.bought != "":
				_apply_drink(casino.bought)
				casino.bought = ""
			if gain > 0:
				pot += gain
				if casino.big_win:
					shake(0.6)
			if casino.done:
				state = "play"
				get_tree().paused = false
		"play":
			if _jp("pause"):
				state = "pause"
				pause_sel = 0
				get_tree().paused = true
				Sfx.play("tick")
			elif _jp("restart"):
				_end_run()
				_start_run()
				return
			else:
				_tick_play(delta)
		"choice":
			choice_t += delta
			if _jp("left") and choice_idx != 0:
				choice_idx = 0
				Sfx.play("tick")
			if _jp("right") and choice_idx != 1:
				choice_idx = 1
				Sfx.play("tick")
			if choice_t > 0.4:
				if _jp("choose1"):
					_choose(0)
				elif _jp("choose2"):
					_choose(1)
				elif _jp("jump") or _jp("confirm"):
					_choose(choice_idx)
		"dead":
			dead_t += delta
			Music.intensity = 0.0
			_update_camera(delta)
			if dead_t > 1.2 and (_jp("jump") or _jp("confirm") or _jp("restart")):
				_start_run()
			elif dead_t > 1.2 and _jp("pause"):
				state = "title"
				get_tree().paused = true
	_update_fx(delta)
	if hud:
		hud.queue_redraw()


func _skills_tick() -> void:
	var cur: Dictionary = SKILLS[skill_sel]
	var b: int = cur["branch"]
	var tr: int = cur["tier"]
	if _jp("up"):
		tr = maxi(0, tr - 1)
	if _jp("down"):
		tr = mini(3, tr + 1)
	if _jp("left"):
		b = (b + 2) % 3
	if _jp("right"):
		b = (b + 1) % 3
	for i in SKILLS.size():
		if SKILLS[i]["branch"] == b and SKILLS[i]["tier"] == tr and i != skill_sel:
			skill_sel = i
			Sfx.play("tick")
	if _jp("pause") or _jp("dash"):
		state = "title"
		Sfx.play("tick")
		return
	if _jp("jump") or _jp("confirm"):
		var sk: Dictionary = SKILLS[skill_sel]
		if has_skill(sk["id"]):
			skill_msg = "Already yours."
			Sfx.play("deny")
		elif not skill_available(sk):
			skill_msg = "Unlock the skill above it first."
			Sfx.play("deny")
		elif wallet < int(sk["cost"]):
			skill_msg = "Not enough banked cash. Cash out more often."
			Sfx.play("deny")
		else:
			wallet -= int(sk["cost"])
			perks[sk["id"]] = 1
			skill_msg = "%s acquired." % sk["name"]
			Sfx.play("buy")
			_save()


func _pause_tick() -> void:
	var n := pause_items().size()
	if _jp("up"):
		pause_sel = (pause_sel + n - 1) % n
		Sfx.play("tick")
	if _jp("down"):
		pause_sel = (pause_sel + 1) % n
		Sfx.play("tick")
	var dx := (1 if _jp("right") else 0) - (1 if _jp("left") else 0)
	if dx != 0:
		if pause_sel == 1:
			music_vol = clampf(music_vol + dx * 0.1, 0.0, 1.0)
		elif pause_sel == 2:
			sfx_vol = clampf(sfx_vol + dx * 0.1, 0.0, 1.0)
		_apply_volume()
		Sfx.play("tick")
	if _jp("pause"):
		state = "play"
		get_tree().paused = false
		return
	if _jp("jump") or _jp("confirm"):
		match pause_sel:
			0:
				state = "play"
				get_tree().paused = false
			3:
				_end_run()
				_start_run()
			4:
				_end_run()
				state = "title"
				get_tree().paused = true
				_build_floor()


func _apply_volume() -> void:
	Music.volume = music_vol
	Sfx.volume = sfx_vol
	_save()


func _check_trophies() -> void:
	if pot_mult >= 8:
		unlock("ride8")
	if flow_mult() >= 5:
		unlock("flow5")
	if chain >= 30:
		unlock("chain30")
	if int(stats.get("parries", 0)) >= 10:
		unlock("parry10")
	if int(stats.get("smashed", 0)) >= 25:
		unlock("smash25")
	if banked >= 2000:
		unlock("rich")


func _update_fx(delta: float) -> void:
	trauma = maxf(0.0, trauma - delta * 2.0)
	if camera and is_instance_valid(camera):
		camera.offset = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * trauma * trauma * 7.0
	iris_t += delta
	hurt_flash = maxf(0.0, hurt_flash - delta * 1.6)
	slowmo = maxf(0.0, slowmo - delta * 0.8)
	callout_t = maxf(0.0, callout_t - delta)
	for tst in toasts:
		tst["t"] -= delta
	toasts = toasts.filter(func(x): return x["t"] > 0.0)
	boss_shout_t = maxf(0.0, boss_shout_t - delta)
	var m := post.material as ShaderMaterial
	m.set_shader_parameter("iris", lerpf(0.0, 2.2, clampf(iris_t / 0.7, 0.0, 1.0)))
	if player and is_instance_valid(player):
		m.set_shader_parameter("iris_center", to_screen(player.global_position) / Vector2(1280, 720))
	m.set_shader_parameter("hurt", hurt_flash + (0.35 if hp == 1 and state == "play" else 0.0))
	m.set_shader_parameter("flow", flow / flow_max)
	m.set_shader_parameter("slowmo", slowmo)


func _tick_play(delta: float) -> void:
	run_time += delta
	_check_trophies()
	_update_flow(delta)
	_update_camera(delta)
	for p in popups:
		p["life"] -= delta
	popups = popups.filter(func(p): return p["life"] > 0.0)
	banner_t = maxf(0.0, banner_t - delta)
	if last_call_left >= 0.0:
		last_call_left = maxf(0.0, last_call_left - delta)
		if last_call_left <= 0.0 and pot > 0:
			bleed_acc += maxf(1.0, pot * last_call_bleed) * delta
			var b := int(bleed_acc)
			if b > 0:
				pot = maxi(0, pot - b)
				bleed_acc -= b
	# Music intensity follows the danger.
	var target := 0.0
	if boss and is_instance_valid(boss) and boss.alive() and boss.state != "intro":
		target = 1.0
	else:
		for e in enemies:
			if is_instance_valid(e) and e.is_aggro():
				target = 0.6
				break
	Music.intensity = target
	Music.boss_mode = target >= 1.0 and boss != null and boss.phase == 2


func _physics_process(delta: float) -> void:
	if state != "play" or get_tree().paused or player == null:
		return
	_check_world(delta)


# ---------------------------------------------------------------- combat & world

func _try_parry(src: Vector2) -> bool:
	if player.parry_t <= 0.0:
		return false
	player.parried()
	stats["parries"] = stats.get("parries", 0) + 1
	hitstop(0.12)
	shake(0.35)
	slowmo = 0.6
	Sfx.play("parry")
	var mid: Vector2 = (player.global_position + src) * 0.5
	fx.burst(mid, 18, Color(0.8, 0.95, 1.0), 170.0, 0.4, 2.5, 0.0)
	fx.burst(mid, 8, Color(1, 0.9, 0.5), 90.0, 0.3, 2.0, 0.0)
	_callout("PARRY!", Color(0.6, 0.95, 1.0))
	_on_move("PARRY")
	return true


func _check_world(delta: float) -> void:
	var pr: Rect2 = player.get_rect()
	var pc := pr.get_center()
	var ps: int = player.state
	level.reveal(player.global_position)

	# Chips (magnet).
	var mag := 26.0 + perk("magnet") * 14.0
	for i in range(chips.size() - 1, -1, -1):
		var c = chips[i]
		if not is_instance_valid(c):
			chips.remove_at(i)
			continue
		if not c.collectible():
			continue
		var d: float = (c.position as Vector2).distance_to(pc)
		if d < mag:
			c.loose = false
			c.position = (c.position as Vector2).move_toward(pc, (110.0 + (mag - d) * 14.0) * delta)
		if d < 9.0:
			_collect(c)
			chips.remove_at(i)

	# Crumbling floors.
	if player.is_on_floor():
		for fxp in [pr.position.x + 1.0, pr.end.x - 1.0]:
			level.touch_crumble(Vector2i(floori(fxp / 16.0), floori((pr.end.y + 2.0) / 16.0)))

	# Spikes.
	if player.velocity.y >= 0.0 and (level.spike_at(Vector2(pr.position.x + 1.0, pr.end.y - 1.0)) or level.spike_at(Vector2(pr.end.x - 1.0, pr.end.y - 1.0))):
		_hurt(player.global_position.x - player.facing, "Impaled on house spikes")
		if state != "play":
			return

	_resolve_strike()

	# Enemies.
	for e in enemies:
		if not is_instance_valid(e) or not e.alive:
			continue
		var pk: Rect2 = e.punch_rect()
		if pk.has_area() and pr.intersects(pk):
			if _try_parry(e.global_position):
				e.stun(1.5, player.global_position.x)
				continue
			_hurt(e.global_position.x, "Knocked out by a bouncer")
			if state != "play":
				return
			continue
		var er: Rect2 = e.get_rect()
		if not pr.intersects(er):
			continue
		if ps == PlayerScript.S.SLIDE and e.kind != 3:
			e.hurt(99, player.global_position.x)
			_enemy_killed(e)
			_on_move("SLIDE KICK")
			Sfx.play("kick")
		elif player.velocity.y > 0.0 and pr.end.y - er.position.y <= 6.0 + player.velocity.y * delta * 2.0:
			if e.kind == 3 and not e.hurt(2, player.global_position.x):
				player.bounce()
				_on_move("STOMP")
				Sfx.play("stomp")
				continue
			e.hurt(99, player.global_position.x)
			_enemy_killed(e)
			player.bounce()
			_on_move("STOMP")
			Sfx.play("stomp")
			hitstop(0.045)
		elif e.is_dangerous():
			if _try_parry(e.global_position):
				if e.kind == 1:
					e.hurt(99, player.global_position.x)
					_enemy_killed(e)
				else:
					e.stun(1.2, player.global_position.x)
				continue
			_hurt(e.global_position.x, "Escorted out by security" if e.kind == 0 else "Bitten by a pit bat")
			if state != "play":
				return
	enemies = enemies.filter(func(e): return is_instance_valid(e))

	# Boss body.
	if boss and is_instance_valid(boss) and boss.alive():
		var br: Rect2 = boss.get_rect()
		if pr.intersects(br):
			if player.velocity.y > 0.0 and pr.end.y - br.position.y <= 10.0 + player.velocity.y * delta * 2.0:
				var dealt: int = boss.hurt(2 + perk("blade"))
				player.bounce()
				if dealt > 0:
					_boss_hit_fx(dealt, Vector2(boss.global_position.x, br.position.y))
					_on_move("BOSS STOMP")
			elif boss.dangerous():
				if _try_parry(boss.global_position):
					if boss.charging():
						boss.stun(2.2)
						boss.hurt(1)
						_callout("PERFECT PARRY!", Color(1, 0.9, 0.4))
					player.velocity = Vector2(signf(player.global_position.x - boss.global_position.x) * 200.0, -180.0)
				else:
					_hurt(boss.global_position.x, "Flattened by " + boss.bname)
					if state != "play":
						return

	# Projectiles.
	for p in projectiles:
		if not is_instance_valid(p) or not p.alive:
			continue
		var prc: Rect2 = p.rect()
		if p.owner_tag == "boss" and pr.intersects(prc):
			if _try_parry(p.global_position):
				if p.kind != "wave" and boss and is_instance_valid(boss) and boss.alive():
					p.reflect(boss.global_position)
				elif p.kind == "card" and _nearest_enemy(p.global_position) != null:
					p.reflect(_nearest_enemy(p.global_position).global_position)
				else:
					p.die()
				continue
			_hurt(p.global_position.x, "Dealt out by " + (boss.bname if boss and is_instance_valid(boss) else "the House"))
			p.die()
			if state != "play":
				return
		elif p.owner_tag == "player" and _proj_hits_enemy(p):
			p.die()
		elif p.owner_tag == "player" and boss and is_instance_valid(boss) and boss.alive() and prc.intersects(boss.get_rect()):
			var dealt: int = boss.hurt(2)
			if dealt > 0:
				_boss_hit_fx(dealt, p.global_position)
				_callout("RETURN TO SENDER", Color(0.6, 0.95, 1.0))
			p.die()
	projectiles = projectiles.filter(func(p): return is_instance_valid(p) and p.alive)

	# Props: smash on fast contact.
	var fast: bool = ps == PlayerScript.S.DASH or ps == PlayerScript.S.SLIDE or absf(player.velocity.x) > 125.0 or player.velocity.y > 220.0
	if fast:
		for p in props:
			if is_instance_valid(p) and not p.broken and pr.intersects(p.rect()):
				_break_prop(p)

	# Exit & casino games.
	interact_text = ""
	if pr.intersects(level.exit_rect()):
		interact_pos = level.exit_pos + Vector2(0, -44)
		interact_text = "LOCKED: beat the boss" if level.exit_locked else "UP: EXIT"
		if not level.exit_locked and Input.is_action_pressed("up") and player.is_on_floor():
			_reach_exit()
			return
	else:
		for gm in level.games:
			var gp: Vector2 = gm[0]
			if absf(gp.x - pc.x) < (16.0 if gm[1] == "slots" else 20.0) and absf(gp.y - pr.end.y) < 6.0:
				interact_pos = gp + Vector2(0, -34)
				interact_text = "UP: TALK TO LUCKY" if gm[1] == "bar" else "UP: PLAY " + ("SLOTS" if gm[1] == "slots" else String(gm[1]).to_upper())
				if _jp("up") and player.is_on_floor():
					casino.open(gm[1], perk("luck"), floor_num)
					state = "casino"
					get_tree().paused = true
					Sfx.play("door")
				break


func _resolve_strike() -> void:
	var hb: Rect2 = player.attack_hitbox()
	if not hb.has_area():
		return
	var id: int = player.atk_id
	var down: bool = player.atk_kind == "down"
	var fin: bool = player.combo == 2
	var dmg := 1 + perk("blade") + run_dmg_bonus + ((1 + perk("haymaker")) if fin else 0)
	var landed := false
	for e in enemies:
		if not is_instance_valid(e) or not e.alive or int(e.get_meta("hit", -1)) == id:
			continue
		if hb.intersects(e.get_rect()):
			e.set_meta("hit", id)
			landed = true
			if e.blocking(player.global_position.x) and not fin:
				Sfx.play("clash", 0.8)
				fx.burst(e.global_position + Vector2(e.dir * 9, -2), 8, Color(0.8, 0.9, 1.0), 110.0, 0.25, 2.0, 0.0)
				fx.text(e.global_position + Vector2(0, -24), "BLOCKED", Color(0.7, 0.85, 1.0), 9)
				player.velocity.x = -player.facing * 140.0
				continue
			if e.kind == 3 and fin and e.blocking(player.global_position.x):
				e.stun(1.6, player.global_position.x)
				_callout("GUARD BREAK!", Color(1, 0.8, 0.4))
			var killed: bool = e.hurt(dmg, player.global_position.x)
			fx.burst(e.global_position, 8, Color(1, 0.95, 0.7), 120.0, 0.25, 2.0, 0.0)
			if killed:
				_enemy_killed(e)
				_on_move("KO")
	if boss and is_instance_valid(boss) and boss.alive() and int(boss.get_meta("hit", -1)) != id and hb.intersects(boss.get_rect()):
		boss.set_meta("hit", id)
		var dealt: int = boss.hurt(dmg)
		if dealt > 0:
			landed = true
			_boss_hit_fx(dealt, hb.get_center())
	for p in projectiles:
		if is_instance_valid(p) and p.alive and p.owner_tag == "boss" and hb.intersects(p.rect()):
			if p.kind == "ball" and boss and is_instance_valid(boss):
				p.reflect(boss.global_position)
			elif p.kind == "card":
				p.die()
			else:
				continue
			Sfx.play("clash")
			fx.burst(p.global_position, 6, Color(1, 1, 1), 100.0, 0.2, 2.0, 0.0)
			landed = true
	for p in props:
		if is_instance_valid(p) and not p.broken and hb.intersects(p.rect()):
			_break_prop(p)
			landed = true
	var c0 := Vector2i(floori(hb.position.x / 16.0), floori(hb.position.y / 16.0))
	var c1 := Vector2i(floori(hb.end.x / 16.0), floori(hb.end.y / 16.0))
	for cy in range(c0.y, c1.y + 1):
		for cx in range(c0.x, c1.x + 1):
			var v: int = level.get_cell(cx, cy)
			if v == 3 or v == 4:
				level.smash(Vector2i(cx, cy))
				landed = true
	if landed:
		Sfx.play("hit", 1.0 + player.combo * 0.12)
		hitstop(0.035 if not fin else 0.06)
		shake(0.12 if not fin else 0.3)
		if down:
			player.pogo()
			_on_move("POGO")
		else:
			_on_move("FINISHER" if fin else "STRIKE")
		# Each swing only connects once per target set.
		player.atk_t = minf(player.atk_t, movement.attack_time - movement.attack_active)


func _boss_hit_fx(dealt: int, at: Vector2) -> void:
	fx.burst(at, 12 + dealt * 4, Color(1, 0.85, 0.4), 160.0, 0.35, 2.5, 120.0)
	fx.text(at + Vector2(0, -12), "-%d" % dealt, Color(1, 0.4, 0.3) if dealt < 3 else Color(1, 0.9, 0.3), 12)
	Sfx.play("hit", 0.8)
	shake(0.2)
	hitstop(0.05)
	_on_move("BOSS HIT")


func _enemy_killed(e) -> void:
	var bonus: int = (5 if e.kind == 0 else 3) * flow_mult()
	pot += bonus
	stats["kills"] = stats.get("kills", 0) + 1
	fx.text(e.global_position + Vector2(0, -14), "+%d" % bonus, Color(1, 0.85, 0.4), 10)
	fx.burst(e.global_position, 12, Color(1, 0.9, 0.6), 120.0, 0.4, 2.0, 200.0)
	shake(0.25)


func _break_prop(p) -> void:
	p.broken = true
	props.erase(p)
	var at: Vector2 = (p.rect() as Rect2).get_center()
	fx.burst(at, 16, p.debris_color(), 140.0, 0.5, 2.5, 420.0, Vector2.UP, 1.4)
	Sfx.play("glass" if p.kind == "case" else "smash")
	shake(0.15)
	stats["smashed"] = stats.get("smashed", 0) + 1
	var vals: Array = []
	match p.kind:
		"crate":
			for i in rng.randi_range(3, 5):
				vals.append(5 if rng.randf() < 0.25 else 1)
		"urn":
			for i in rng.randi_range(2, 4):
				vals.append(25 if rng.randf() < 0.15 + perk("luck") * 0.05 else 5)
		"case":
			vals = [25, 5, 5]
			if rng.randf() < 0.2 + perk("luck") * 0.08:
				vals.append(100)
	_spawn_loose(at, vals)
	Sfx.play("coins")
	_on_move("SMASH")
	p.queue_free()


func _on_broke(cell: Vector2i, kind: int) -> void:
	var at := Vector2(cell.x * 16 + 8, cell.y * 16 + 8)
	match kind:
		3:
			fx.burst(at, 9, Color(0.75, 0.95, 1.0, 0.9), 150.0, 0.55, 2.5, 500.0)
			Sfx.play("glass", randf_range(0.9, 1.15))
		4:
			fx.burst(at, 10, Color(0.45, 0.14, 0.2), 130.0, 0.6, 3.0, 500.0)
			fx.burst(at, 6, Color(0.8, 0.7, 0.6, 0.6), 50.0, 0.6, 2.0, -20.0)
			Sfx.play("crack")
			if rng.randf() < 0.3:
				_spawn_loose(at, [5 if rng.randf() < 0.3 else 1])
		5:
			fx.burst(at, 8, Color(0.6, 0.45, 0.3), 80.0, 0.6, 2.5, 500.0)
			Sfx.play("crumble")
	stats["smashed"] = stats.get("smashed", 0) + 1
	shake(0.12)


func _on_crumble(cell: Vector2i) -> void:
	fx.burst(Vector2(cell.x * 16 + 8, cell.y * 16 + 16), 5, Color(0.7, 0.55, 0.4, 0.8), 30.0, 0.6, 1.5, 200.0, Vector2.DOWN, 0.6)
	Sfx.play("creak")


func _on_boss_fire(kind: String, pos: Vector2, vel: Vector2) -> void:
	var p = ProjScript.new()
	p.position = pos
	p.setup(kind, level, vel)
	p.material = unshaded
	world.add_child(p)
	projectiles.append(p)


func _on_boss_summon(pos: Vector2) -> void:
	_spawn_enemy(pos + Vector2(0, -12), 0)
	fx.burst(pos, 16, Color(0.8, 0.4, 1.0), 120.0, 0.5, 2.5, 0.0)
	Sfx.play("door")


func _on_boss_slam(pos: Vector2) -> void:
	shake(0.6)
	Sfx.play("slam")
	fx.burst(pos, 18, Color(0.8, 0.7, 0.6, 0.8), 140.0, 0.5, 2.5, 300.0, Vector2.UP, 1.3)


func _on_boss_phase(_p: int) -> void:
	boss_shout = Story.BOSS_PHASE.get(boss.tier, "")
	boss_shout_t = 3.0
	_callout("PHASE 2", Color(1, 0.35, 0.35))
	shake(0.5)
	Sfx.play("windup", 0.6)


func _on_boss_defeated() -> void:
	var tier: int = boss.tier
	stats["bosses"] = stats.get("bosses", 0) + 1
	unlock("boss%d" % tier)
	Sfx.play("boss_die")
	shake(1.0)
	slowmo = 1.5
	_callout("JACKPOT!", Color(1, 0.85, 0.3))
	var vals: Array = []
	for i in 14 + tier * 4:
		var r := rng.randf()
		vals.append(100 if r < 0.08 else (25 if r < 0.4 else 5))
	_spawn_loose(boss.global_position + Vector2(0, -10), vals)
	for e in enemies:
		if is_instance_valid(e) and e.alive:
			e.kill(0.0)
	level.exit_locked = false
	level.tile_layer.queue_redraw()
	for p in projectiles:
		if is_instance_valid(p):
			p.die()
	var first := floor_num > bosses_beaten
	bosses_beaten = maxi(bosses_beaten, floor_num)
	_save()
	var lines: Array = Story.BOSS_DEFEAT[tier].duplicate()
	if tier == 3 and not ending_seen:
		ending_seen = true
		lines.append_array(Story.ENDING)
	var tm := get_tree().create_timer(2.2, true, false, true)
	tm.timeout.connect(_boss_outro.bind(lines, first or tier == 3))


func _boss_outro(lines: Array, show: bool) -> void:
	if state == "play" and show:
		_say(lines, "")


func _hurt(from_x: float, reason: String) -> void:
	if player.invuln > 0.0:
		return
	hp = 0 if rules.has("glass") else hp - 1
	flow = 0.0
	chain = 0
	last_move = ""
	shake(0.55)
	hitstop(0.08)
	hurt_flash = 1.0
	fx.burst(player.global_position, 14, Color(1, 0.3, 0.35), 120.0, 0.45, 2.5, 250.0)
	if hp <= 0:
		_die(reason)
	else:
		Sfx.play("hurt")
		player.take_hit(from_x)


func _callout(text: String, col: Color) -> void:
	callout = text
	callout_t = 1.0
	callout_col = col


func _collect(c) -> void:
	var v: int = c.value * flow_mult() * chip_mult
	pot += v
	stats["chips"] = stats.get("chips", 0) + v
	var col: Color = c.color()
	fx.text(c.position + Vector2(0, -6), "+%d" % v, col, 9 if v < 25 else 11)
	fx.burst(c.position, 6, col, 70.0, 0.35, 2.0, 60.0)
	Sfx.play("chip_big" if c.value >= 25 else "chip", 1.0 + minf(0.5, chain * 0.03))
	if c.value >= 100:
		_callout("+$%d" % v, Color(0.85, 0.5, 1.0))
	c.queue_free()


func _on_move(move_name: String) -> void:
	var g: float = flow_gains.get(move_name, 5.0)
	if move_name == last_move:
		g *= flow_repeat_penalty
	last_move = move_name
	var old_tier := flow_mult()
	flow = minf(flow_max, flow + g)
	chain += 1
	best_chain = maxi(best_chain, chain)
	stop_t = 0.0
	popups.push_front({"t": move_name, "life": 1.1})
	if popups.size() > 5:
		popups.pop_back()
	if flow_mult() > old_tier:
		Sfx.play("tier", 1.0 + flow_mult() * 0.08)
		fx.text(player.global_position + Vector2(0, -24), "FLOW x%d" % flow_mult(), Color(1, 0.85, 0.3), 11)


func _on_land(impact: float) -> void:
	if impact > 380.0:
		shake(0.15)


func _update_flow(delta: float) -> void:
	var drain_mult := 3.0 if rules.has("loiter") else 1.0
	var pstate: int = player.state
	var busy: bool = player.velocity.length() >= flow_stop_speed or pstate == PlayerScript.S.CLIMB or player.atk_t > 0.0
	if boss and is_instance_valid(boss) and boss.alive():
		busy = true
	if busy:
		stop_t = 0.0
	else:
		stop_t += delta
	if stop_t > flow_stop_grace:
		flow -= flow_stopped_drain * drain_mult * delta
		chain = 0
	else:
		flow -= flow_idle_drain * drain_mult * delta
	if flow <= 0.0:
		flow = 0.0
		chain = 0
	player.flow_ratio = flow / flow_max


func flow_mult() -> int:
	return mini(5, 1 + int(flow / flow_tier_size))


func rule_info(id: String) -> Dictionary:
	return RULES.get(id, {"name": "?", "desc": ""})


func _update_camera(delta: float) -> void:
	if camera == null or player == null or not is_instance_valid(camera):
		return
	var v: Vector2 = player.velocity
	var look := Vector2(clampf(v.x * 0.3, -70.0, 70.0), clampf(v.y * 0.12, -20.0, 40.0))
	var target: Vector2 = player.global_position + look
	if boss and is_instance_valid(boss) and boss.alive():
		target = target.lerp(boss.global_position, 0.3)
	camera.global_position = camera.global_position.lerp(target, 1.0 - exp(-6.0 * delta))


func shake(amount: float) -> void:
	trauma = minf(1.0, trauma + amount)


func hitstop(dur: float) -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(dur, true, false, true).timeout
	Engine.time_scale = 1.0


func to_screen(p: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform() * p


# ---------------------------------------------------------------- save

func _load() -> void:
	var cf := ConfigFile.new()
	if cf.load("user://save.cfg") != OK:
		return
	best = int(cf.get_value("stats", "best", 0))
	wallet = int(cf.get_value("stats", "wallet", 0))
	lifetime = int(cf.get_value("stats", "lifetime", 0))
	runs = int(cf.get_value("stats", "runs", 0))
	perks = cf.get_value("stats", "perks", {})
	intro_seen = bool(cf.get_value("story", "intro", false))
	exit_tip_seen = bool(cf.get_value("story", "exit_tip", false))
	bosses_beaten = int(cf.get_value("story", "bosses", 0))
	ending_seen = bool(cf.get_value("story", "ending", false))
	trophies = cf.get_value("stats", "trophies", {})
	music_vol = float(cf.get_value("settings", "music", 0.8))
	sfx_vol = float(cf.get_value("settings", "sfx", 0.8))
	char_i = int(cf.get_value("settings", "runner", 0))


func _save() -> void:
	var cf := ConfigFile.new()
	cf.set_value("stats", "best", best)
	cf.set_value("stats", "wallet", wallet)
	cf.set_value("stats", "lifetime", lifetime)
	cf.set_value("stats", "runs", runs)
	cf.set_value("stats", "perks", perks)
	cf.set_value("story", "intro", intro_seen)
	cf.set_value("story", "exit_tip", exit_tip_seen)
	cf.set_value("story", "bosses", bosses_beaten)
	cf.set_value("story", "ending", ending_seen)
	cf.set_value("stats", "trophies", trophies)
	cf.set_value("settings", "music", music_vol)
	cf.set_value("settings", "sfx", sfx_vol)
	cf.set_value("settings", "runner", char_i)
	cf.save("user://save.cfg")


func _apply_drink(id: String) -> void:
	unlock("drinks")
	match id:
		"shot":
			hp = mini(hp + 1, start_hp)
			_callout("+1 LIFE", RED_C)
		"flow":
			flow = flow_max
			_callout("FLOW MAXED", Color(1, 0.85, 0.3))
		"lucky":
			chip_mult = 2
			_callout("CHIPS x2 THIS FLOOR", Color(0.6, 1, 0.6))


func _proj_hits_enemy(p) -> bool:
	for e in enemies:
		if is_instance_valid(e) and e.alive and (p.rect() as Rect2).intersects(e.get_rect()):
			if e.hurt(3, p.global_position.x):
				_enemy_killed(e)
				_callout("RETURN TO SENDER", Color(0.6, 0.95, 1.0))
			return true
	return false


func _nearest_enemy(from: Vector2):
	var best_e = null
	var best_d := 260.0
	for e in enemies:
		if is_instance_valid(e) and e.alive:
			var d: float = (e.global_position as Vector2).distance_to(from)
			if d < best_d:
				best_d = d
				best_e = e
	return best_e
