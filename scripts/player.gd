extends CharacterBody2D
## The runner. State machine driven; all tunables come from MovementConfig.

signal move_done(move_name: String)
signal landed(impact: float)
signal pounded(pos: Vector2)

enum S { NORMAL, WALL_RUN, LEDGE, CLIMB, SLIDE, DASH, VAULT, DEAD }

const T := 16.0
const Rig := preload("res://scripts/rig.gd")
const RicoArt := preload("res://scripts/rico_art.gd")
const SCARF_N := 8
const Wardrobe := preload("res://scripts/wardrobe.gd")

var cfg: MovementConfig
var level
var fx

var state: int = S.NORMAL
var state_t := 0.0
var facing := 1
var coyote := 0.0
var buffer := 0.0
var wall_coyote := 0.0
var last_wall_dir := 0
var wall_lock := 0.0
var dashes := 1
var dash_max := 1
var atk_t := 0.0
var atk_kind := "fwd"
var atk_id := 0
var atk_cd := 0.0
var combo := 0
var combo_t := 0.0
var parry_t := 0.0
var parry_cd := 0.0
var parry_flash := 0.0
var parry_bonus := 0.0
var dash_enabled := true
## Abilities come from worn clothing (see main.OUTFIT_ITEMS). Keys: dash, double_jump,
## wall (cling + wall jump), wall_run, slide, vault, ledge, glide, super_dash, pound.
var abil := {"dash": true}
## Worn clothing ids and the floor number (outfit tier); main sets these.
var worn: Array = []
var outfit_floor := 1
var pounding := false
var hit_flash := 0.0
var charm_ids: Array = []
var air_jumps := 0
var dash_cd := 0.0
var dash_dir := Vector2.RIGHT
var wall_run_ready := true
var wr_dir := 1
var ledge_dir := 1
var ledge_cd := 0.0
var slide_cd := 0.0
var climb_from := Vector2.ZERO
var climb_to := Vector2.ZERO
var vault_vx := 0.0
var jump_cut_ok := false
var was_on_floor := false
var wall_sliding := false
var invuln := 0.0
var spawn_lock := 0.25
var gravity_mult := 1.0
var flow_ratio := 0.0
var squash := Vector2.ONE
var trail: Array[Vector2] = []
var t := 0.0
var run_phase := 0.0
var hood := Color(0.30, 0.18, 0.45)
var hood_l := Color(0.47, 0.31, 0.64)
var rig
var rig_rot := 0.0
var land_comp := 0.0
var last_facing := 1
var last_step := 0
var force_ground := false
var scarf: Array[Vector2] = []
var scarf_old: Array[Vector2] = []
var shape: RectangleShape2D
var col: CollisionShape2D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	floor_snap_length = 4.0
	z_index = 2
	shape = RectangleShape2D.new()
	col = CollisionShape2D.new()
	col.shape = shape
	add_child(col)
	_set_body(false)
	rig = Rig.new(Rig.runner_style(hood, hood_l))


# ---------------------------------------------------------------- helpers

func _ix() -> int:
	var a := Input.get_axis("left", "right")
	return 0 if absf(a) < 0.3 else int(signf(a))


func _iy() -> int:
	var a := Input.get_axis("up", "down")
	return 0 if absf(a) < 0.5 else int(signf(a))


func _set_body(slide: bool) -> void:
	var s: Vector2 = cfg.slide_size if slide else cfg.stand_size
	shape.size = s
	col.position = Vector2(0, (cfg.stand_size.y - s.y) * 0.5)


func get_rect() -> Rect2:
	return Rect2(global_position + col.position - shape.size * 0.5, shape.size)


func _bottom() -> float:
	return global_position.y + cfg.stand_size.y * 0.5


func _can_stand() -> bool:
	var b := _bottom()
	var hw := cfg.stand_size.x * 0.5 - 0.5
	for py in [b - cfg.stand_size.y + 0.5, b - cfg.stand_size.y * 0.5]:
		for px in [global_position.x - hw, global_position.x + hw]:
			if level.solid_at(Vector2(px, py)):
				return false
	return true


## Which side has a wall flush against us (1 right, -1 left, 0 none).
func _wall_dir() -> int:
	var hw := shape.size.x * 0.5 + 1.5
	var cy := global_position.y + col.position.y
	var top := cy - shape.size.y * 0.3
	var r: bool = level.solid_at(Vector2(global_position.x + hw, cy)) and level.solid_at(Vector2(global_position.x + hw, top))
	var l: bool = level.solid_at(Vector2(global_position.x - hw, cy)) and level.solid_at(Vector2(global_position.x - hw, top))
	if r and l:
		return facing
	if r:
		return 1
	if l:
		return -1
	return 0


func _emit(n: String) -> void:
	move_done.emit(n)


func _dust(pos: Vector2, n: int, dir := Vector2.UP, spread := 1.3) -> void:
	if fx:
		fx.burst(pos, n, Color(0.85, 0.78, 0.7, 0.8), 55.0, 0.35, 2.0, 120.0, dir, spread)


# ---------------------------------------------------------------- main loop

func _physics_process(delta: float) -> void:
	t += delta
	run_phase += absf(velocity.x) * delta * 0.075
	squash = squash.lerp(Vector2.ONE, minf(1.0, 14.0 * delta))
	_update_trail()
	queue_redraw()
	if state == S.DEAD:
		velocity.y += cfg.gravity * delta
		position += velocity * delta
		return

	invuln = maxf(0.0, invuln - delta)
	hit_flash = maxf(0.0, hit_flash - delta)
	spawn_lock = maxf(0.0, spawn_lock - delta)
	ledge_cd = maxf(0.0, ledge_cd - delta)
	slide_cd = maxf(0.0, slide_cd - delta)
	wall_lock = maxf(0.0, wall_lock - delta)
	state_t += delta

	var ix := _ix()
	var iy := _iy()
	if Input.is_action_just_pressed("jump") and spawn_lock <= 0.0:
		buffer = cfg.jump_buffer
	else:
		buffer = maxf(0.0, buffer - delta)
	var jump_held := Input.is_action_pressed("jump")
	var dash_pressed := Input.is_action_just_pressed("dash") and spawn_lock <= 0.0

	# Combat input (works on the ground, in the air, mid-dash, mid-wall-run).
	atk_t = maxf(0.0, atk_t - delta)
	atk_cd = maxf(0.0, atk_cd - delta)
	combo_t = maxf(0.0, combo_t - delta)
	parry_t = maxf(0.0, parry_t - delta)
	parry_cd = maxf(0.0, parry_cd - delta)
	parry_flash = maxf(0.0, parry_flash - delta)
	var can_fight := state == S.NORMAL or state == S.DASH or state == S.WALL_RUN or state == S.VAULT
	if spawn_lock <= 0.0 and can_fight:
		if Input.is_action_just_pressed("attack") and atk_cd <= 0.0:
			_start_attack(iy)
		if Input.is_action_just_pressed("parry") and parry_cd <= 0.0:
			parry_t = cfg.parry_window + parry_bonus
			parry_cd = cfg.parry_cooldown
			squash = Vector2(1.15, 0.9)
			Sfx.play("guard")

	wall_sliding = false
	match state:
		S.NORMAL:
			_st_normal(delta, ix, iy, jump_held, dash_pressed)
		S.WALL_RUN:
			_st_wall_run(delta, ix)
		S.LEDGE:
			_st_ledge(ix, iy)
		S.CLIMB:
			_st_climb()
		S.SLIDE:
			_st_slide(delta, ix, iy)
		S.DASH:
			_st_dash(iy)
		S.VAULT:
			_st_vault(delta)


func _st_normal(delta: float, ix: int, iy: int, jump_held: bool, dash_pressed: bool) -> void:
	var on_floor := is_on_floor()
	dash_cd = maxf(0.0, dash_cd - delta)
	if on_floor:
		coyote = cfg.coyote_time
		dashes = dash_max
		air_jumps = 1 if abil.get("double_jump", false) else 0
		wall_run_ready = true
	else:
		coyote = maxf(0.0, coyote - delta)

	if pounding:
		if on_floor:
			pounding = false
			pounded.emit(Vector2(global_position.x, _bottom()))
		else:
			velocity = Vector2(0, 560.0)
			move_and_slide()
			if is_on_floor():
				pounding = false
				_on_land(560.0)
				pounded.emit(Vector2(global_position.x, _bottom()))
			return
	elif abil.get("pound", false) and not on_floor and iy > 0 and not jump_held and velocity.y > -80.0 and (_ground_below() < 0.0 or _ground_below() - _bottom() > 24.0):
		pounding = true
		squash = Vector2(0.8, 1.3)
		Sfx.play("slam", 1.2)
		return

	var wd := _wall_dir() if abil.get("wall", false) else 0
	if not on_floor and wd != 0:
		dashes = dash_max
		air_jumps = 1 if abil.get("double_jump", false) else 0
		last_wall_dir = wd
		wall_coyote = cfg.wall_coyote_time
	else:
		wall_coyote = maxf(0.0, wall_coyote - delta)

	# Slide: down while running (Slick Loafers).
	if abil.get("slide", false) and on_floor and iy > 0 and absf(velocity.x) >= cfg.slide_min_speed and slide_cd <= 0.0:
		_start_slide()
		return

	# Jumps (buffered + coyote), then wall jump, then double jump.
	if buffer > 0.0:
		if on_floor or coyote > 0.0:
			_jump()
		elif wd != 0 or wall_coyote > 0.0:
			_wall_jump(wd if wd != 0 else last_wall_dir)
		elif air_jumps > 0 and Input.is_action_just_pressed("jump"):
			_double_jump()

	# Dash works on the ground and in the air (one per airtime), like a cloak dash.
	if dash_pressed and dash_enabled and abil.get("dash", false) and dash_cd <= 0.0 and (on_floor or dashes > 0):
		_start_dash(ix, iy)
		return

	# Variable jump height.
	if jump_cut_ok and not jump_held and velocity.y < 0.0:
		velocity.y *= cfg.jump_cut_mult
		jump_cut_ok = false
	if velocity.y >= 0.0:
		jump_cut_ok = false

	_apply_run(ix, delta, on_floor)

	if abil.get("vault", false) and (on_floor or coyote > 0.0) and ix != 0 and _try_vault(ix):
		return

	_apply_gravity(delta, jump_held)
	# Silk Scarf: hold jump while falling to glide.
	if abil.get("glide", false) and not on_floor and jump_held and velocity.y > 40.0 and not jump_cut_ok:
		velocity.y = minf(velocity.y, 55.0)

	if not on_floor and wd != 0 and ix == wd and velocity.y > 0.0:
		velocity.y = minf(velocity.y, cfg.wall_slide_speed)
		wall_sliding = true
		facing = -wd
		if fx and randf() < 0.25:
			_dust(global_position + Vector2(wd * 6.0, -6.0), 1, Vector2(-wd, -0.5), 0.6)

	var pre_vx := velocity.x
	var pre_vy := velocity.y
	_corner_correct(delta)
	move_and_slide()
	if _smash_check(Vector2(pre_vx, pre_vy)):
		return
	var now_floor := is_on_floor()
	if now_floor and not was_on_floor:
		_on_land(pre_vy)
	was_on_floor = now_floor

	# Wall run: hit a tall wall at speed while holding into it.
	if abil.get("wall_run", false) and is_on_wall() and wall_run_ready and ix != 0 and absf(pre_vx) >= cfg.wall_run_min_speed \
			and int(signf(pre_vx)) == ix and _tall_wall(ix):
		_start_wall_run(ix)
		return

	# Ledge grab.
	if abil.get("ledge", false) and not now_floor and ledge_cd <= 0.0 and velocity.y >= -40.0:
		var wd2 := _wall_dir()
		if wd2 != 0 and ix == wd2:
			_try_ledge(wd2, false)


## Jump corner correction (from Celeste): if rising into a ceiling corner,
## slide sideways a few pixels instead of bonking.
func _corner_correct(delta: float) -> void:
	if velocity.y >= 0.0 or cfg.corner_correction <= 0.0:
		return
	var up := Vector2(0, velocity.y * delta)
	if not test_move(global_transform, up):
		return
	for d in range(1, int(cfg.corner_correction) + 1):
		for sgn in [1, -1]:
			var off := Vector2(d * sgn, 0)
			if not test_move(global_transform, off) and not test_move(global_transform.translated(off), up):
				global_position += off
				return


func _apply_run(ix: int, delta: float, on_floor: bool) -> void:
	if wall_lock > 0.0:
		return
	var vx := velocity.x
	var mx := cfg.max_run_speed
	if ix != 0:
		if absf(vx) > 1.0 and int(signf(vx)) != ix:
			vx = move_toward(vx, ix * mx, (cfg.turn_accel if on_floor else cfg.air_accel * 1.4) * delta)
		elif absf(vx) <= mx:
			vx = move_toward(vx, ix * mx, (cfg.ground_accel if on_floor else cfg.air_accel) * delta)
		else:
			vx = move_toward(vx, ix * mx, (cfg.overspeed_decay_ground if on_floor else cfg.overspeed_decay_air) * delta)
		facing = ix
	else:
		var dec := cfg.ground_decel if on_floor else cfg.air_decel
		if absf(vx) > mx and not on_floor:
			dec = cfg.overspeed_decay_air
		vx = move_toward(vx, 0.0, dec * delta)
	velocity.x = clampf(vx, -cfg.absolute_max_speed, cfg.absolute_max_speed)


func _apply_gravity(delta: float, jump_held: bool) -> void:
	var g := cfg.gravity * gravity_mult
	if velocity.y > 0.0:
		g *= cfg.fall_gravity_mult
	elif absf(velocity.y) < cfg.apex_threshold and jump_held:
		g *= cfg.apex_gravity_mult
	velocity.y = minf(velocity.y + g * delta, cfg.max_fall_speed)


func _on_land(vy: float) -> void:
	var k := clampf(vy / cfg.max_fall_speed, 0.0, 1.0)
	squash = Vector2(1.0 + 0.3 * k, 1.0 - 0.25 * k)
	land_comp = 1.0 + 4.0 * k
	if vy > 120.0:
		_dust(Vector2(global_position.x, _bottom()), 3 + int(k * 6), Vector2.UP, 1.4)
		Sfx.play("land_hard" if k > 0.75 else "land", 1.0 - k * 0.15)
	landed.emit(vy)


# ---------------------------------------------------------------- moves

func _jump() -> void:
	velocity.y = -cfg.jump_velocity
	coyote = 0.0
	buffer = 0.0
	jump_cut_ok = true
	squash = Vector2(0.72, 1.3)
	_dust(Vector2(global_position.x, _bottom()), 4)
	Sfx.play("jump")


## Wingtip Shoes: one extra jump in the air, with a feathery puff.
func _double_jump() -> void:
	air_jumps -= 1
	velocity.y = -cfg.jump_velocity * 0.92
	buffer = 0.0
	jump_cut_ok = true
	squash = Vector2(0.7, 1.32)
	if fx:
		fx.burst(Vector2(global_position.x, _bottom()), 10, Color(1, 1, 1, 0.9), 70.0, 0.35, 2.0, 40.0, Vector2.DOWN, 1.2)
	Sfx.play("double_jump")
	_emit("DOUBLE JUMP")


func _wall_jump(wd: int) -> void:
	state = S.NORMAL
	velocity.x = -wd * maxf(cfg.wall_jump_velocity.x, absf(velocity.x) * 0.5)
	velocity.y = -cfg.wall_jump_velocity.y
	wall_lock = cfg.wall_jump_lock
	facing = -wd
	buffer = 0.0
	wall_coyote = 0.0
	coyote = 0.0
	jump_cut_ok = true
	wall_run_ready = true
	squash = Vector2(0.75, 1.25)
	_dust(global_position + Vector2(wd * 6.0, 4.0), 5, Vector2(-wd, -0.3), 0.8)
	Sfx.play("wall")
	_emit("WALL JUMP")


func _start_wall_run(dir: int) -> void:
	state = S.WALL_RUN
	state_t = 0.0
	wr_dir = dir
	facing = dir
	wall_run_ready = false
	dashes = dash_max
	velocity.y = -cfg.wall_run_speed
	Sfx.play("wallrun")
	_emit("WALL RUN")


func _st_wall_run(_delta: float, ix: int) -> void:
	var k := state_t / cfg.wall_run_time
	velocity.x = wr_dir * 30.0
	velocity.y = -cfg.wall_run_speed * (1.0 - 0.55 * k)
	if buffer > 0.0:
		_wall_jump(wr_dir)
		return
	if _try_ledge(wr_dir, true):
		return
	move_and_slide()
	if fx and randf() < 0.4:
		_dust(Vector2(global_position.x + wr_dir * 5.0, _bottom()), 1, Vector2(-wr_dir, 0.5), 0.5)
	if _wall_dir() != wr_dir:
		# Ran off the top: pop over.
		state = S.NORMAL
		velocity = Vector2(wr_dir * 95.0, velocity.y * 0.7)
	elif is_on_ceiling() or state_t >= cfg.wall_run_time or ix == -wr_dir:
		state = S.NORMAL
		velocity.y *= 0.35


func _try_ledge(wd: int, auto_climb: bool) -> bool:
	var top := global_position.y - cfg.stand_size.y * 0.5
	var fxp := global_position.x + wd * (cfg.stand_size.x * 0.5 + 2.0)
	var cx := floori(fxp / T)
	var mycx := floori(global_position.x / T)
	var r0 := floori(top / T)
	for rr in [r0, r0 + 1]:
		var r: int = rr
		var ly := float(r) * T
		if absf(ly - (top + 4.0)) > cfg.ledge_grab_window:
			continue
		if level.solid(cx, r) and not level.solid(cx, r - 1) and not level.solid(cx, r - 2) and not level.solid(mycx, r - 1):
			var hang_x := (cx * T - cfg.stand_size.x * 0.5 - 0.1) if wd > 0 else (cx * T + T + cfg.stand_size.x * 0.5 + 0.1)
			ledge_dir = wd
			facing = wd
			if wd > 0:
				climb_to = Vector2(cx * T + cfg.stand_size.x * 0.5 + 1.0, ly - cfg.stand_size.y * 0.5 - 0.2)
			else:
				climb_to = Vector2(cx * T + T - cfg.stand_size.x * 0.5 - 1.0, ly - cfg.stand_size.y * 0.5 - 0.2)
			dashes = dash_max
			wall_run_ready = true
			velocity = Vector2.ZERO
			if auto_climb:
				_begin_climb()
			else:
				global_position = Vector2(hang_x, ly - 4.0 + cfg.stand_size.y * 0.5)
				state = S.LEDGE
				state_t = 0.0
				squash = Vector2(0.9, 1.1)
				Sfx.play("grab")
			return true
	return false


func _st_ledge(ix: int, iy: int) -> void:
	velocity = Vector2.ZERO
	if state_t < 0.07:
		return
	if buffer > 0.0:
		buffer = 0.0
		if ix == -ledge_dir:
			_wall_jump(ledge_dir)
		else:
			state = S.NORMAL
			ledge_cd = 0.2
			_jump()
			_emit("LEDGE HOP")
	elif iy < 0 or ix == ledge_dir:
		_begin_climb()
	elif iy > 0 or ix == -ledge_dir:
		state = S.NORMAL
		ledge_cd = 0.3


func _begin_climb() -> void:
	climb_from = global_position
	state = S.CLIMB
	state_t = 0.0
	velocity = Vector2.ZERO
	squash = Vector2(0.85, 1.15)
	Sfx.play("grab")
	_emit("MANTLE")


func _st_climb() -> void:
	var k := clampf(state_t / cfg.ledge_climb_time, 0.0, 1.0)
	var ky := 1.0 - pow(1.0 - k, 2.0)
	global_position = Vector2(lerpf(climb_from.x, climb_to.x, k * k), lerpf(climb_from.y, climb_to.y, ky))
	if k >= 1.0:
		state = S.NORMAL
		velocity = Vector2(ledge_dir * cfg.max_run_speed * 0.6, 0.0)
		was_on_floor = true
		coyote = cfg.coyote_time
		squash = Vector2(1.15, 0.85)


func _start_slide() -> void:
	state = S.SLIDE
	state_t = 0.0
	_set_body(true)
	var s := signf(velocity.x)
	var sp := absf(velocity.x)
	velocity.x = s * minf(sp + cfg.slide_boost, maxf(sp, cfg.max_run_speed + cfg.slide_boost))
	squash = Vector2(1.25, 0.8)
	_dust(Vector2(global_position.x, _bottom()), 5, Vector2(-s, -0.4), 0.6)
	Sfx.play("slide")
	_emit("SLIDE")


func _st_slide(delta: float, ix: int, iy: int) -> void:
	var on_floor := is_on_floor()
	if on_floor:
		coyote = cfg.coyote_time
		dashes = dash_max
		wall_run_ready = true
	else:
		coyote = maxf(0.0, coyote - delta)
	velocity.x = move_toward(velocity.x, 0.0, cfg.slide_friction * delta)
	var can_stand := _can_stand()
	if buffer > 0.0 and (on_floor or coyote > 0.0) and can_stand:
		_set_body(false)
		state = S.NORMAL
		_jump()
		_emit("SLIDE JUMP")
		return
	if can_stand and (iy <= 0 or absf(velocity.x) < cfg.slide_stop_speed or (not on_floor and state_t > 0.08)):
		_set_body(false)
		state = S.NORMAL
		slide_cd = cfg.slide_cooldown
		return
	if not can_stand and absf(velocity.x) < 45.0:
		velocity.x = ix * 45.0  # crawl out from under low ceilings
		if ix != 0:
			facing = ix
	velocity.y = minf(velocity.y + cfg.gravity * gravity_mult * delta, cfg.max_fall_speed)
	var pre_v := velocity
	move_and_slide()
	if _smash_check(pre_v):
		return
	was_on_floor = is_on_floor()
	if fx and on_floor and absf(velocity.x) > 60.0 and randf() < 0.5:
		_dust(Vector2(global_position.x - signf(velocity.x) * 4.0, _bottom()), 1, Vector2(-signf(velocity.x), -0.6), 0.5)


func _start_dash(ix: int, iy: int) -> void:
	# Default dash is a crisp horizontal burst; the Track Jacket unlocks 8-way.
	var d := Vector2(ix, iy) if abil.get("super_dash", false) else Vector2(ix if ix != 0 else facing, 0)
	if d == Vector2.ZERO:
		d = Vector2(facing, 0)
	dash_cd = cfg.dash_cooldown
	dash_dir = d.normalized()
	if ix != 0:
		facing = ix
	state = S.DASH
	state_t = 0.0
	dashes -= 1
	jump_cut_ok = false
	squash = Vector2(1.3, 0.75) if absf(dash_dir.x) > absf(dash_dir.y) else Vector2(0.75, 1.3)
	if fx:
		fx.burst(global_position, 8, Color(1.0, 0.85, 0.4, 0.9), 90.0, 0.3, 2.0, 0.0, -dash_dir, 0.7)
	Sfx.play("dash")
	_emit("AIR DASH")


func _st_dash(iy: int) -> void:
	velocity = dash_dir * cfg.dash_speed
	if buffer > 0.0 and abil.get("wall", false):
		var wd := _wall_dir()
		if wd != 0:
			_wall_jump(wd)
			return
	move_and_slide()
	if _smash_check(dash_dir * cfg.dash_speed):
		return
	# Dash into a wall at speed -> wall run.
	if abil.get("wall_run", false) and is_on_wall() and dash_dir.x != 0.0 and wall_run_ready and _tall_wall(int(signf(dash_dir.x))):
		_start_wall_run(int(signf(dash_dir.x)))
		return
	# Diagonal dash into the floor -> slide with all that speed.
	if abil.get("slide", false) and is_on_floor() and dash_dir.y > 0.0 and absf(dash_dir.x) > 0.1:
		velocity.y = 0.0
		was_on_floor = true
		_start_slide()
		return
	if state_t >= cfg.dash_time or is_on_wall() or is_on_ceiling() or (is_on_floor() and iy > 0):
		state = S.NORMAL
		velocity.x *= cfg.dash_end_mult
		velocity.y *= 0.4


func _tall_wall(dir: int) -> bool:
	var x := global_position.x + dir * (cfg.stand_size.x * 0.5 + 2.0)
	var b := _bottom()
	return level.solid_at(Vector2(x, b - 20.0)) and level.solid_at(Vector2(x, b - 6.0))


func _try_vault(dir: int) -> bool:
	if absf(velocity.x) < cfg.vault_min_speed or int(signf(velocity.x)) != dir:
		return false
	var b := _bottom()
	var front := global_position.x + dir * (shape.size.x * 0.5)
	var look := front + dir * (2.0 + absf(velocity.x) * 0.06)
	var foot := b - 8.0
	if not level.solid_at(Vector2(look, foot)):
		return false
	if level.solid_at(Vector2(look, foot - 16.0)) or level.solid_at(Vector2(look, foot - 32.0)):
		return false
	if level.solid_at(Vector2(global_position.x, foot - 32.0)):
		return false
	vault_vx = velocity.x + dir * cfg.vault_speed_bonus
	velocity.y = -cfg.vault_hop_velocity
	state = S.VAULT
	state_t = 0.0
	squash = Vector2(1.2, 0.8)
	_dust(Vector2(look - dir * 4.0, foot - 8.0), 4, Vector2(-dir, -1.0), 0.6)
	Sfx.play("vault")
	_emit("VAULT")
	return true


func _st_vault(delta: float) -> void:
	velocity.x = vault_vx
	velocity.y += cfg.gravity * gravity_mult * 0.5 * delta
	move_and_slide()
	if state_t >= cfg.vault_time:
		state = S.NORMAL
		was_on_floor = is_on_floor()


# ---------------------------------------------------------------- combat

func _start_attack(iy: int) -> void:
	var kind := "fwd"
	if iy < 0:
		kind = "up"
	elif iy > 0 and not is_on_floor():
		kind = "down"
	combo = (combo + 1) % 3 if combo_t > 0.0 else 0
	atk_kind = kind
	atk_t = cfg.attack_time
	atk_cd = cfg.attack_time * 0.75 + cfg.attack_cooldown
	combo_t = cfg.attack_time + cfg.combo_window
	atk_id += 1
	if kind == "fwd" and is_on_floor() and state == S.NORMAL:
		velocity.x += facing * (cfg.finisher_lunge if combo == 2 else 35.0)
	squash = Vector2(1.22, 0.86) if kind == "fwd" else Vector2(0.88, 1.2)
	if kind == "fwd":
		_dust(Vector2(global_position.x - facing * 4.0, _bottom()), 2, Vector2(-facing, -0.4), 0.7)
	Sfx.play("swing", 1.0 + combo * 0.15)


func attack_active() -> bool:
	return atk_t > cfg.attack_time - cfg.attack_active


## Live strike hitbox in world space (empty Rect2 when not swinging).
func attack_hitbox() -> Rect2:
	if not attack_active():
		return Rect2()
	var c := global_position
	match atk_kind:
		"up":
			return Rect2(c.x - 13, c.y - 36, 26, 26)
		"down":
			return Rect2(c.x - 12, c.y + 2, 24, 24)
	var reach := 22.0 if combo < 2 else 30.0
	var hy := 26.0 if combo < 2 else 32.0
	return Rect2(c.x + (2.0 if facing > 0 else -2.0 - reach), c.y - hy * 0.6, reach, hy)


func pogo() -> void:
	velocity.y = -cfg.pogo_bounce
	dashes = dash_max
	wall_run_ready = true
	jump_cut_ok = false
	if state == S.DASH:
		state = S.NORMAL
	squash = Vector2(0.8, 1.25)


## Called by the game when a parry lands.
func parried() -> void:
	parry_t = 0.0
	parry_cd = 0.0
	parry_flash = 0.25
	invuln = maxf(invuln, 0.4)
	dashes = dash_max
	squash = Vector2(1.3, 0.8)


## Smash glass / cracked blocks we just collided with, keeping momentum.
func _smash_check(pre_v: Vector2) -> bool:
	var power := 0
	if state == S.DASH or state == S.SLIDE:
		power = 2
	elif absf(pre_v.x) >= 90.0:
		power = 1
	var hit := false
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		var n := c.get_normal()
		var p := c.get_position() - n * 2.0
		var cell := Vector2i(floori(p.x / T), floori(p.y / T))
		var v: int = level.get_cell(cell.x, cell.y)
		var pw := power
		if n.y < -0.5:
			pw = 2 if pre_v.y > 330.0 else (1 if pre_v.y > 220.0 else 0)
		elif n.y > 0.5:
			pw = 1 if pre_v.y < -200.0 else 0
		if (v == 3 and pw >= 1) or (v == 4 and pw >= 2):
			level.smash(cell)
			hit = true
	if hit:
		velocity = pre_v
		_emit("SMASH")
	return hit


# ---------------------------------------------------------------- external

func bounce() -> void:
	velocity.y = -(cfg.stomp_bounce_held if Input.is_action_pressed("jump") else cfg.stomp_bounce)
	dashes = dash_max
	wall_run_ready = true
	jump_cut_ok = false
	if state == S.DASH or state == S.WALL_RUN or state == S.VAULT:
		state = S.NORMAL
	squash = Vector2(0.75, 1.3)


func take_hit(from_x: float) -> void:
	invuln = 1.2
	hit_flash = 0.12
	squash = Vector2(0.7, 1.25)
	if state == S.SLIDE and _can_stand():
		_set_body(false)
	if state != S.SLIDE:
		state = S.NORMAL
	var d := signf(global_position.x - from_x)
	if d == 0.0:
		d = -facing
	velocity = Vector2(d * 170.0, -230.0)
	wall_lock = 0.2


func die() -> void:
	state = S.DEAD
	collision_mask = 0
	velocity = Vector2(-facing * 70.0, -280.0)


# ---------------------------------------------------------------- animation
# Every frame we build a target pose for the current move and blend the rig
# toward it, so transitions are always smooth. Poses are in rig space:
# feet at origin, facing +x, up is -y (see rig.gd).

func _update_trail() -> void:
	var fast := absf(velocity.x) > cfg.max_run_speed * 1.15 or state == S.DASH or flow_ratio >= 0.5
	if fast and state != S.DEAD:
		trail.append(global_position)
		if trail.size() > 7:
			trail.pop_front()
	elif trail.size() > 0:
		trail.pop_front()


func _process(delta: float) -> void:
	if rig == null:
		return
	if facing != last_facing:
		last_facing = facing
		squash = Vector2(0.65, 1.12)
	land_comp = lerpf(land_comp, 0.0, 1.0 - exp(-9.0 * delta))
	var res := _target_pose()
	var tp: Dictionary = res[0]
	var rate: float = res[1]
	tp["hip"] = (tp["hip"] as Vector2) + Vector2(0, land_comp)
	rig.blend(tp, rate, delta)
	if state == S.DEAD:
		rig_rot += -facing * 9.0 * delta
	else:
		rig_rot = lerp_angle(rig_rot, res[2], 1.0 - exp(-rate * delta))
	var step := int(run_phase / 2.0)
	if step != last_step:
		last_step = step
		if state == S.NORMAL and is_on_floor() and absf(velocity.x) > 60.0:
			_dust(Vector2(global_position.x - facing * 2.0, _bottom()), 2, Vector2(-facing, -0.8), 0.5)
	_update_scarf(delta)
	queue_redraw()


func _rig_xform() -> Transform2D:
	var center := Vector2(0, _bottom() - global_position.y - 11.0)
	return Transform2D(rig_rot, center) * Transform2D(0.0, Vector2(0, 11.0)) \
		* Transform2D(0.0, Vector2(facing * squash.x, squash.y), 0.0, Vector2.ZERO)


func _run_pose(ph: float, k: float) -> Dictionary:
	var cf := cos(ph)
	var sf := sin(ph)
	var stride := 3.0 + 2.2 * k
	var lift := 2.0 + 2.6 * k
	var ff := Vector2(cf * stride + 0.8, -maxf(0.0, -sf) * lift)
	var fb := Vector2(-cf * stride + 0.8, -maxf(0.0, sf) * lift)
	var hip := Vector2(0.6 * k, -10.7 + 0.8 * k * (1.0 - absf(cf)))
	var tor := 0.1 + 0.14 * k
	var sh: Vector2 = rig.shoulder_of(hip, tor)
	var sw := -cf * (1.6 + 2.2 * k)
	var hf := sh + Vector2(sw + 0.8, 5.0 - maxf(0.0, sw) * 0.8)
	var hb := sh + Vector2(-sw + 0.8, 5.0 - maxf(0.0, -sw) * 0.8)
	return Rig.make(hip, tor, -tor * 0.6, ff, fb, hf, hb)


func _target_pose() -> Array:
	var grounded := is_on_floor() or force_ground
	var rate := 18.0
	var rot := 0.0
	var tp: Dictionary
	var hurt := invuln > 0.9 and state == S.NORMAL
	match state:
		S.DEAD:
			var f := sin(t * 20.0)
			tp = Rig.make(Vector2(0, -11), 0.3 * f, 0.4, Vector2(4, 1 + f), Vector2(-4, 1 - f), Vector2(6, -20 + f * 2.0), Vector2(-6, -19 - f * 2.0))
			rate = 25.0
		S.SLIDE:
			var sl := sin(t * 30.0) * 0.3
			tp = Rig.make(Vector2(-1.0, -3.6), -1.05, 0.85, Vector2(8.0, 0.0), Vector2(2.2, -0.2), Vector2(1.5, -9.0), Vector2(-6.5 + sl, -0.4))
			rate = 26.0
		S.LEDGE:
			var sw := sin(t * 3.0) * 0.8
			tp = Rig.make(Vector2(sw * 0.3, -10.4), -0.08, -0.3, Vector2(1.0 + sw, 0.6), Vector2(-1.5 + sw, 0.2), Vector2(4.4, -19.4), Vector2(3.0, -19.6))
			rate = 22.0
		S.CLIMB:
			var k := clampf(state_t / cfg.ledge_climb_time, 0.0, 1.0)
			tp = Rig.make(Vector2(0.5, -11.0), 0.4, -0.15, Vector2(4.5, -6.0 + k * 5.0), Vector2(-3.0, 0.0), Vector2(4.0, -11.5 + k * 3.0), Vector2(2.5, -11.0 + k * 3.0))
			rate = 34.0
		S.VAULT:
			tp = Rig.make(Vector2(1.0, -14.5), 0.55, -0.35, Vector2(3.5, -9.5), Vector2(0.0, -8.0), Vector2(5.5, -11.5), Vector2(4.5, -11.0))
			rate = 40.0
		S.DASH:
			var dl := Vector2(dash_dir.x * facing, dash_dir.y)
			rot = atan2(dl.x, -dl.y) * 0.85 * facing
			tp = Rig.make(Vector2(0, -11), 0.15, -0.3, Vector2(-1.5, 1.5), Vector2(-3.8, -0.5), Vector2(4.5, -23.0), Vector2(-1.0, -12.5))
			rate = 36.0
		S.WALL_RUN:
			tp = _run_pose(t * TAU * 3.4, 1.3)
			rot = -0.7 * facing
			rate = 32.0
		_:
			if hurt:
				var sh0: Vector2 = rig.shoulder_of(Vector2(-1, -11), -0.45)
				tp = Rig.make(Vector2(-1, -11), -0.45, 0.3, Vector2(3.5, -1.5), Vector2(-2.0, 0.0), sh0 + Vector2(-2, -5), sh0 + Vector2(-4, -3))
				rate = 30.0
			elif wall_sliding:
				var sh1: Vector2 = rig.shoulder_of(Vector2(-0.5, -11), -0.12)
				tp = Rig.make(Vector2(-0.5, -11), -0.12, 0.15, Vector2(2.6, -1.2), Vector2(-4.6, -4.0), sh1 + Vector2(3.0, 3.0), Vector2(-5.8, -18.0))
				rate = 16.0
			elif not grounded:
				var tr := clampf(velocity.y / 260.0 * 0.5 + 0.5, 0.0, 1.0)
				var shr: Vector2 = rig.shoulder_of(Vector2(0, -12.0), 0.12)
				var shf: Vector2 = rig.shoulder_of(Vector2(0, -11.6), -0.04)
				var rise := Rig.make(Vector2(0, -12.0), 0.12, -0.05, Vector2(3.8, -5.0), Vector2(-2.2, -1.8), shr + Vector2(2.5, -4.0), shr + Vector2(-3.5, 2.5))
				var fall := Rig.make(Vector2(0, -11.6), -0.04, -0.15, Vector2(2.6, -0.6), Vector2(-3.0, -2.2),
					shf + Vector2(4.0, -3.5 + sin(t * 14.0)), shf + Vector2(-3.8, -4.5 + cos(t * 13.0)))
				tp = Rig.mix(rise, fall, tr)
				rate = 14.0
			else:
				var ix := _ix()
				if ix != 0 and absf(velocity.x) > 70.0 and int(signf(velocity.x)) != ix:
					var sh2: Vector2 = rig.shoulder_of(Vector2(0.5, -10.0), 0.35)
					tp = Rig.make(Vector2(0.5, -10.0), 0.35, -0.2, Vector2(2.0, 0.0), Vector2(-5.0, 0.0), sh2 + Vector2(4.0, 2.0), sh2 + Vector2(-2.0, 5.0))
					rate = 26.0
					if fx and randf() < 0.4:
						_dust(Vector2(global_position.x - facing * 5.0, _bottom()), 1, Vector2(facing, -0.6), 0.6)
				elif absf(velocity.x) > 20.0:
					tp = _run_pose(run_phase * TAU / 4.0, clampf(absf(velocity.x) / cfg.max_run_speed, 0.35, 1.8))
					rate = 40.0
				else:
					var b := sin(t * 2.4)
					var hip := Vector2(0, -10.7 + b * 0.25)
					var sh3: Vector2 = rig.shoulder_of(hip, 0.05)
					tp = Rig.make(hip, 0.05, sin(t * 1.3) * 0.05, Vector2(2.3, 0), Vector2(-2.0, 0), sh3 + Vector2(1.4, 8.0 + b * 0.2), sh3 + Vector2(-1.4, 8.0))
					rate = 12.0
	# Combat overlays on top of whatever the legs are doing.
	if atk_t > 0.0 and state != S.DEAD:
		var p := 1.0 - atk_t / cfg.attack_time
		var e := 1.0 - pow(1.0 - minf(1.0, p * 1.8), 3.0)
		var hip: Vector2 = tp["hip"]
		var tor: float = tp["torso"]
		var sh: Vector2 = rig.shoulder_of(hip, tor)
		match atk_kind:
			"up":
				tp["hand_f"] = sh + Vector2(lerpf(-3.0, 3.0, e), lerpf(2.0, -9.5, e))
				tp["head"] = -0.35
			"down":
				tp["hand_f"] = sh + Vector2(lerpf(4.0, 1.0, e), lerpf(-6.0, 10.0, e))
				tp["torso"] = tor + 0.35
			_:
				var reach := 9.5 if combo < 2 else 11.0
				tp["hand_f"] = sh + Vector2(lerpf(-4.0, reach, e), lerpf(-6.0, 1.0, e))
				tp["torso"] = tor + lerpf(-0.25, 0.35, e)
				if combo == 2:
					tp["hand_b"] = sh + Vector2(lerpf(-5.0, reach - 2.0, e), lerpf(-3.0, 2.0, e))
		rate = 60.0
	elif parry_t > 0.0 or parry_flash > 0.0:
		var hip2: Vector2 = tp["hip"]
		var sh2: Vector2 = rig.shoulder_of(hip2, -0.1)
		tp["torso"] = -0.1
		tp["hand_f"] = sh2 + Vector2(6.0, 0.0)
		tp["hand_b"] = sh2 + Vector2(5.5, -2.5)
		rate = 60.0
	# Hollow Knight-style lean: tilt into the run, flare back when skidding,
	# and rock back during the attack windup.
	if state == S.NORMAL and grounded and rot == 0.0:
		rot = clampf(velocity.x / maxf(1.0, cfg.max_run_speed), -1.2, 1.2) * 0.12
	if atk_t > 0.0 and atk_kind == "fwd" and atk_t > cfg.attack_time * 0.85:
		rot -= facing * 0.1
	return [tp, rate, rot]


func _update_scarf(delta: float) -> void:
	var anchor: Vector2 = global_position + _rig_xform() * rig.head_point(Vector2(-2.5, 1.0))
	if scarf.size() != SCARF_N:
		scarf.clear()
		scarf_old.clear()
		for i in SCARF_N:
			scarf.append(anchor)
			scarf_old.append(anchor)
	var dt := minf(delta, 0.033)
	for i in range(1, SCARF_N):
		var p := scarf[i]
		var v := (p - scarf_old[i]) * 0.9
		scarf_old[i] = p
		var flutter := Vector2(sin(t * 11.0 + i * 0.9), cos(t * 7.0 + i * 1.3)) * 0.04 * i
		scarf[i] = p + v + Vector2(0, 240.0) * dt * dt + flutter
	scarf[0] = anchor
	scarf_old[0] = anchor
	for _it in 4:
		for i in SCARF_N - 1:
			var d := scarf[i + 1] - scarf[i]
			var l := d.length()
			if l < 0.001:
				continue
			var diff := d * ((l - 2.1) / l)
			if i == 0:
				scarf[i + 1] -= diff
			else:
				scarf[i] += diff * 0.5
				scarf[i + 1] -= diff * 0.5


func _draw() -> void:
	if rig == null:
		return
	var a := 1.0
	if invuln > 0.0 and int(invuln * 20.0) % 2 == 0:
		a = 0.35
	var xf := _rig_xform()

	# Contact shadow on the ground below.
	if state != S.DEAD:
		var gy := _ground_below()
		if gy >= 0.0:
			var d := gy - _bottom()
			if d < 80.0:
				var k0 := 1.0 - d / 80.0
				draw_set_transform(Vector2(0, gy - global_position.y), 0.0, Vector2(1.0, 0.28))
				draw_circle(Vector2.ZERO, 4.0 + 4.0 * k0, Color(0, 0, 0, 0.45 * k0))
				draw_set_transform(Vector2.ZERO)

	var ghost :=Color(0.85, 0.9, 1.0).lerp(Color(1.0, 0.72, 0.2), flow_ratio)
	for i in trail.size():
		var k := float(i + 1) / float(trail.size() + 1)
		rig.draw_silhouette(self, Transform2D(0.0, trail[i] - global_position) * xf, Color(ghost, 0.2 * k * a))

	draw_set_transform(Vector2.ZERO)
	if false and scarf.size() == SCARF_N:  # scarf removed from the design
		var oc := Color(0.06, 0.03, 0.09, a)
		var sc := Color(0.92, 0.15, 0.25, a)
		for pass_i in 2:
			for i in SCARF_N - 1:
				var w := lerpf(2.6, 1.1, float(i) / float(SCARF_N - 1))
				var p0 := scarf[i] - global_position
				var p1 := scarf[i + 1] - global_position
				if pass_i == 0:
					draw_line(p0, p1, oc, w + 1.4)
				else:
					draw_line(p0, p1, sc if i % 3 != 2 else sc.darkened(0.2), w)

	var lk := RicoArt.look(worn, outfit_floor)
	if hit_flash > 0.0 or state == S.DEAD or invuln > 0.9:
		lk["mood"] = "hurt"
	elif flow_ratio > 0.7:
		lk["mood"] = "fired"
	RicoArt.dress_rig(rig, lk)
	rig.draw(self, xf, a, RicoArt.body.bind(lk))
	RicoArt.accessories(self, xf, rig, a, worn, lk)
	if not charm_ids.is_empty():
		Wardrobe.draw_charm_gear(self, rig, xf, charm_ids, a)
	if hit_flash > 0.0:
		rig.draw_silhouette(self, xf, Color(1, 1, 1, 0.9))

	if flow_ratio > 0.25:
		draw_set_transform_matrix(xf)
		draw_circle(rig.head_point(Vector2(1.5, -1.5)), 2.5 + flow_ratio * 3.0, Color(1.0, 0.8, 0.3, 0.2 * flow_ratio * a))
	draw_set_transform(Vector2.ZERO)

	# Slash arc.
	if atk_t > 0.0:
		var p := 1.0 - atk_t / cfg.attack_time
		var fade := 1.0 - p
		var col := Color(1.0, 0.95, 0.8).lerp(Color(1.0, 0.75, 0.25), flow_ratio)
		var center := Vector2(0, -2)
		var r := 16.0 if combo < 2 else 21.0
		var a0 := 0.0
		var a1 := 0.0
		match atk_kind:
			"up":
				a0 = -PI * 0.95
				a1 = -PI * 0.05
				center = Vector2(0, -8)
			"down":
				a0 = PI * 0.05
				a1 = PI * 0.95
				center = Vector2(0, 6)
			_:
				if facing > 0:
					a0 = -PI * 0.55
					a1 = PI * 0.4
				else:
					a0 = PI * 0.6
					a1 = PI * 1.55
		var sweep := minf(1.0, p * 2.2)
		var end_a := lerpf(a0, a1, sweep)
		draw_arc(center, r, a0, end_a, 16, Color(col, 0.85 * fade), 3.5 if combo < 2 else 5.0)
		draw_arc(center, r - 3.0, a0, end_a, 16, Color(1, 1, 1, 0.5 * fade), 1.5)
	# Parry guard flash.
	if parry_t > 0.0 or parry_flash > 0.0:
		var good := parry_flash > 0.0
		var pc := Color(0.4, 0.9, 1.0) if not good else Color(1.0, 1.0, 1.0)
		var ang0 := -PI * 0.5 if facing > 0 else PI * 0.5
		draw_arc(Vector2(facing * 4.0, -2.0), 14.0 + (6.0 * parry_flash * 4.0 if good else 0.0), ang0, ang0 + PI, 14, Color(pc, 0.8), 2.5)


func _ground_below() -> float:
	var cx := floori(global_position.x / T)
	var cy := floori(_bottom() / T)
	for i in 6:
		if level.solid(cx, cy + i):
			return float((cy + i) * T)
	return -1.0
