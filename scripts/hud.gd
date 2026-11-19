extends Control
## All screen-space UI: the in-run HUD (pot, lives, flow, minimap, floor
## track, boss bars), dialogue, title menu, runner select, skill tree,
## trophies, pause menu, exit choice and the bust screen.

const Sprites := preload("res://scripts/sprites.gd")
const Charms := preload("res://scripts/charms.gd")
const Art := preload("res://scripts/art.gd")
const Scenery := preload("res://scripts/scenery.gd")
const BOSS_TIERS := {"BIG SAL": 1, "MADAME ROULETTE": 2, "THE HOUSE": 3}

const GOLD := Color(1.0, 0.78, 0.25)
const GREEN := Color(0.55, 0.95, 0.6)
const RED := Color(1.0, 0.32, 0.35)
const CYAN := Color(0.45, 0.9, 1.0)
const DIM := Color(0.7, 0.66, 0.78)
const PANEL := Color(0.03, 0.01, 0.06, 0.7)

var g
var f: Font
var disp_pot := 0.0
var disp_bank := 0.0
var chain_pop := 0.0
var last_chain := 0
var heart_pop := 0.0
var last_hp := 3
var boss_ghost := 1.0
var portraits := {}
var mini_img: Image
var mini_tex: ImageTexture
var mini_t := 0.0
var mini_level = null
var t := 0.0
var dt := 0.016


func _ready() -> void:
	f = ThemeDB.fallback_font
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = Vector2(1280, 720)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portraits["RICO"] = Sprites.bake(Sprites.R_HEAD, Sprites.RUNNER_PAL)
	var jp: Dictionary = Sprites.RUNNER_PAL.duplicate()
	jp["P"] = Color(0.2, 0.45, 0.3)
	jp["p"] = Color(0.3, 0.6, 0.4)
	portraits["JULES"] = Sprites.bake(Sprites.R_HEAD, jp)
	var dp: Dictionary = Sprites.RUNNER_PAL.duplicate()
	dp["P"] = Color(0.15, 0.45, 0.55)
	dp["p"] = Color(0.25, 0.65, 0.75)
	portraits["DICE"] = Sprites.bake(Sprites.R_HEAD, dp)
	var names := ["BIG SAL", "MADAME ROULETTE", "THE HOUSE"]
	for i in 3:
		portraits[names[i]] = Sprites.bake(Sprites.BOSS_HEADS[i], Sprites.BOSS_PALS[i])
	var lp: Dictionary = Sprites.GUARD_PAL.duplicate()
	portraits["LUCKY"] = Sprites.bake(Sprites.G_HEAD, lp)


func _process(delta: float) -> void:
	t += delta
	dt = delta
	if g == null:
		return
	disp_pot = lerpf(disp_pot, float(g.pot), 1.0 - exp(-10.0 * delta))
	if absf(disp_pot - g.pot) < 0.5:
		disp_pot = g.pot
	disp_bank = lerpf(disp_bank, float(g.banked), 1.0 - exp(-6.0 * delta))
	if g.chain > last_chain:
		chain_pop = 1.0
	last_chain = g.chain
	chain_pop = maxf(0.0, chain_pop - delta * 4.0)
	if g.hp < last_hp:
		heart_pop = 1.0
	last_hp = g.hp
	heart_pop = maxf(0.0, heart_pop - delta * 2.0)
	if g.boss and is_instance_valid(g.boss):
		var r: float = float(g.boss.hp) / float(g.boss.max_hp)
		boss_ghost = r if r > boss_ghost else lerpf(boss_ghost, r, 1.0 - exp(-2.5 * delta))
	else:
		boss_ghost = 1.0
	mini_t -= delta
	if mini_t <= 0.0:
		mini_t = 0.2
		_update_minimap()


# ---------------------------------------------------------------- helpers

func _txt(pos: Vector2, s: String, sz: int, col: Color, align := HORIZONTAL_ALIGNMENT_LEFT, width := -1.0) -> void:
	draw_string_outline(f, pos, s, align, width, sz, maxi(4, sz / 5), Color(0, 0, 0, col.a * 0.9))
	draw_string(f, pos, s, align, width, sz, col)


func _ctxt(y: float, s: String, sz: int, col: Color) -> void:
	_txt(Vector2(0, y), s, sz, col, HORIZONTAL_ALIGNMENT_CENTER, 1280.0)


func _blink(period_ms := 500) -> bool:
	return (Time.get_ticks_msec() / period_ms) % 2 == 0


func _tier_col(tier: int) -> Color:
	match tier:
		1: return Color(0.85, 0.85, 0.9)
		2: return Color(0.35, 0.85, 1.0)
		3: return Color(0.45, 1.0, 0.5)
		4: return GOLD
	return Color(1.0, 0.35, 0.9)


func _diamond(c: Vector2, r: float, col: Color) -> void:
	draw_colored_polygon(PackedVector2Array([c + Vector2(0, -r), c + Vector2(r, 0), c + Vector2(0, r), c + Vector2(-r, 0)]), col)


func _panel(r: Rect2, accent := Color(0, 0, 0, 0)) -> void:
	draw_rect(r, PANEL)
	draw_rect(r, Color(1, 1, 1, 0.08), false, 1.0)
	if accent.a > 0.0:
		draw_rect(Rect2(r.position, Vector2(4, r.size.y)), accent)


func _money(v: float) -> String:
	var n := int(round(v))
	var s := str(absi(n))
	var out := ""
	while s.length() > 3:
		out = "," + s.substr(s.length() - 3) + out
		s = s.substr(0, s.length() - 3)
	return ("-" if n < 0 else "") + "$" + s + out


func _update_minimap() -> void:
	if g.level == null or not is_instance_valid(g.level):
		return
	var lv = g.level
	if mini_level != lv or mini_img == null:
		mini_level = lv
		mini_img = Image.create_empty(lv.w, lv.h, false, Image.FORMAT_RGBA8)
		mini_tex = ImageTexture.create_from_image(mini_img)
	for y in lv.h:
		for x in lv.w:
			var i: int = y * lv.w + x
			if lv.seen[i] == 0:
				mini_img.set_pixel(x, y, Color(0, 0, 0, 0))
				continue
			var v: int = lv.grid[i]
			var c := Color(0.25, 0.12, 0.2, 0.9)
			if v == 0:
				c = Color(0.08, 0.04, 0.1, 0.75)
			elif v == 2:
				c = Color(0.8, 0.8, 0.85, 0.9)
			elif v == 3:
				c = Color(0.5, 0.85, 1.0, 0.9)
			elif v >= 4:
				c = Color(0.55, 0.35, 0.25, 0.9)
			mini_img.set_pixel(x, y, c)
	mini_tex.update(mini_img)


## Silksong-style map (M): only places you have seen, you, markers, vendors, exit.
func _draw_map() -> void:
	var lv = g.level
	if lv == null or not is_instance_valid(lv) or mini_tex == null:
		return
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.03, 0.02, 0.05, 0.94))
	var city: Dictionary = g.Cities.info(g.floor_num)
	_ctxt(54, "%s  -  FLOOR %d" % [String(city["full"]).to_upper(), g.floor_num], 28, GOLD)
	var sc := minf(1100.0 / lv.w, 520.0 / lv.h)
	var mr := Rect2(640 - lv.w * sc * 0.5, 100, lv.w * sc, lv.h * sc)
	draw_rect(mr.grow(6), Color(0.1, 0.07, 0.14))
	draw_rect(mr.grow(6), Color(GOLD, 0.5), false, 2.0)
	draw_texture_rect(mini_tex, mr, false)
	# Room grid lines.
	for rx in range(1, lv.RX):
		draw_line(mr.position + Vector2(rx * lv.RW * sc, 0), mr.position + Vector2(rx * lv.RW * sc, mr.size.y), Color(1, 1, 1, 0.05), 1.0)
	for ry in range(1, lv.RY):
		draw_line(mr.position + Vector2(0, ry * lv.RH * sc), mr.position + Vector2(mr.size.x, ry * lv.RH * sc), Color(1, 1, 1, 0.05), 1.0)
	var ex: Vector2 = lv.exit_pos / 16.0
	if lv.seen[clampi(int(ex.y) - 1, 0, lv.h - 1) * lv.w + clampi(int(ex.x), 0, lv.w - 1)] == 1:
		_diamond(ex * sc + mr.position + Vector2(0, -sc), 8.0, GOLD)
		_txt(ex * sc + mr.position + Vector2(10, -4), "EXIT", 13, GOLD)
	for gm in lv.games:
		var gp: Vector2 = (gm[0] as Vector2) / 16.0
		if lv.seen[clampi(int(gp.y) - 1, 0, lv.h - 1) * lv.w + clampi(int(gp.x), 0, lv.w - 1)] == 1:
			var lab: String = {"vera": "CHARMS", "bar": "BAR", "tailor": "CLOTHES", "fizz": "DOC FIZZ", "gunny": "WEAPONS", "shady": "SHADY", "secretdoor": "SECRET?"}.get(gm[1], "TABLE")
			draw_circle(gp * sc + mr.position + Vector2(0, -sc), 5.0, CYAN)
			_txt(gp * sc + mr.position + Vector2(8, -2), lab, 12, CYAN)
	for mk in g.map_markers:
		var mp: Vector2 = (mk as Vector2) / 16.0 * sc + mr.position
		_diamond(mp, 6.0, Color(1, 0.4, 0.8))
	if g.boss and is_instance_valid(g.boss) and g.boss.alive():
		draw_circle(g.boss.global_position / 16.0 * sc + mr.position, 6.0, RED)
	var pp: Vector2 = g.player.global_position / 16.0 * sc + mr.position
	if _blink(300):
		draw_circle(pp, 6.0, Color.WHITE)
	draw_circle(pp, 4.0, GREEN)
	_ctxt(660, "SPACE: drop / remove a marker      M or ESC: close      The map fills in as you explore.", 16, DIM)


# ---------------------------------------------------------------- dispatch

func _draw() -> void:
	if g == null:
		return
	match g.state:
		"title":
			_draw_title()
		"skills":
			_draw_skills()
		"trophies":
			_draw_trophies()
		"play":
			_draw_play()
		"map":
			_draw_play()
			_draw_map()
		"cine":
			_draw_cine()
		"settings":
			if g.settings_return == "title":
				_draw_title()
			else:
				_draw_play()
			g.settings.draw(self, f, dt)
		"menu":
			_draw_play()
			g.menu.draw(self, f, dt)
		"pause":
			_draw_play()
			_draw_pause()
		"dialog":
			_draw_play()
			if g.dialog_after == "choice":
				_draw_choice()
			_draw_dialog()
		"casino":
			_draw_play()
			g.casino.draw(self, f, g.pot)
		"choice":
			_draw_play()
			_draw_choice()
		"dead":
			_draw_play()
			_draw_dead()
		"loading":
			_draw_loading()
		"wipe":
			_draw_play()
			if not g.wipe_built:
				_draw_dead()
			Scenery.bust_wipe(self, f, g.wipe_t)
	if g.fade_in > 0.0 and g.state != "loading":
		draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, clampf(g.fade_in / 0.45, 0.0, 1.0)))
	_draw_toasts()
	if g.settings and g.settings.val("show_fps"):
		_txt(Vector2(0, 712), "%d FPS" % Engine.get_frames_per_second(), 14, Color(0.6, 1, 0.6, 0.85), HORIZONTAL_ALIGNMENT_RIGHT, 1272)


# ---------------------------------------------------------------- in-run HUD

func _draw_play() -> void:
	if g.in_hub:
		_draw_hub()
		_draw_common()
		return
	_draw_run_hud()
	_draw_run_extras()
	_draw_common()
	if g.zone_card_t > 0.0 and g.state == "play":
		_draw_zone_card()


func _draw_run_hud() -> void:
	# --- Pot panel.
	var pr := Rect2(16, 14, 420, 122)
	_panel(pr, GOLD)
	_txt(Vector2(32, 38), "THE POT", 17, GOLD)
	var pot_col := Color.WHITE
	if g.last_call_left == 0.0 and g.pot > 0 and _blink(150):
		pot_col = RED
	var ps := _money(disp_pot)
	var bump := 1.0 + 0.08 * clampf((g.pot - disp_pot) / 50.0, 0.0, 1.0)
	_txt(Vector2(32, 86), ps, int(48 * bump), pot_col)
	# Multiplier badge.
	var bc := Vector2(392, 62)
	var m: int = g.pot_mult
	var pulse := 1.0 + (0.08 * sin(t * 6.0) if m > 1 else 0.0)
	var mc := _tier_col(clampi(1 + int(log(m) / log(2.0)), 1, 5))
	draw_circle(bc, 30.0 * pulse, Color(mc, 0.25))
	draw_arc(bc, 30.0 * pulse, 0, TAU, 32, mc, 3.0)
	_txt(Vector2(bc.x - 40, bc.y + 11), "x%d" % m, 30, mc, HORIZONTAL_ALIGNMENT_CENTER, 80)
	_txt(Vector2(32, 110), "AT RISK  " + _money(g.pot * g.pot_mult), 16, Color(1, 0.75, 0.55))
	_txt(Vector2(230, 110), "BANKED  " + _money(disp_bank), 16, GREEN)

	# --- Lives, dash pips, parry ready.
	var hp_x := 1262.0
	for i in g.start_hp:
		var c := Vector2(hp_x - (g.start_hp - 1 - i) * 34, 34)
		var alive: bool = i < g.hp
		var s := 12.0
		if alive and g.hp == 1:
			s += 2.0 * sin(t * 10.0)
		if i == g.hp and heart_pop > 0.0:
			s += heart_pop * 8.0
		_diamond(c, s + 2.0, Color(0, 0, 0, 0.6))
		_diamond(c, s, RED if alive else Color(0.25, 0.12, 0.15))
		if alive:
			_diamond(c + Vector2(-3, -3), s * 0.3, Color(1, 0.7, 0.7))
	# Nerve meter (fills when you land hits; hold FOCUS to heal).
	var nr := Rect2(1000, 14, 150, 10)
	draw_rect(nr.grow(2), Color(0, 0, 0, 0.6))
	draw_rect(nr, Color(0.1, 0.16, 0.22))
	var nf: float = g.nerve / g.NERVE_MAX
	draw_rect(Rect2(nr.position, Vector2(nr.size.x * nf, nr.size.y)), Color(0.4, 0.95, 1.0) if g.nerve >= g.NERVE_COST else Color(0.25, 0.5, 0.65))
	draw_rect(Rect2(nr.position.x + nr.size.x * (g.NERVE_COST / g.NERVE_MAX) - 1, nr.position.y, 2, nr.size.y), Color(1, 1, 1, 0.6))
	_txt(Vector2(1000, 42), "NERVE", 12, DIM)
	var wd: Dictionary = g.Weapons.info(g.weapon_id)
	var wtxt := String(wd["name"])
	match String(wd["cost"]):
		"ammo":
			wtxt += "  x%d" % g.weapon_ammo_of(g.weapon_id)
		"pot":
			wtxt += "  $%d" % int(wd["amt"])
		"nerve":
			wtxt += "  %d NERVE" % int(wd["amt"])
	_txt(Vector2(1040, 42), wtxt, 12, Color(wd["col"]))
	if g.focus_t > 0.0:
		draw_rect(Rect2(nr.position + Vector2(0, 12), Vector2(nr.size.x * clampf(g.focus_t / 0.9, 0, 1), 4)), Color(1, 1, 1, 0.9))
	if g.player and is_instance_valid(g.player):
		var pl = g.player
		for i in pl.dash_max:
			var r := Rect2(1180 - i * 26, 56, 20, 8)
			draw_rect(r, Color(0, 0, 0, 0.6))
			draw_rect(r.grow(-1), CYAN if i < pl.dashes else Color(0.15, 0.2, 0.25))
		_txt(Vector2(1210, 66), "DASH", 12, DIM)
		var ready: bool = pl.parry_cd <= 0.0
		var pc := Vector2(1150, 86)
		draw_circle(pc, 11.0, Color(0, 0, 0, 0.6))
		if ready:
			draw_arc(pc, 9.0, 0, TAU, 20, CYAN, 2.5)
		else:
			draw_arc(pc, 9.0, -PI * 0.5, -PI * 0.5 + TAU * (1.0 - pl.parry_cd / pl.cfg.parry_cooldown), 20, Color(0.4, 0.5, 0.6), 2.5)
		_txt(Vector2(1166, 92), "PARRY", 14, CYAN if ready else DIM)

	# --- Floor track + run timer.
	var base_floor: int = ((g.floor_num - 1) / 12) * 12
	var tx0 := 640.0 - 11 * 15.0
	draw_rect(Rect2(tx0 - 14, 22, 22 * 15.0 + 28, 34), Color(0, 0, 0, 0.45))
	draw_line(Vector2(tx0, 39), Vector2(tx0 + 11 * 30.0, 39), Color(1, 1, 1, 0.15), 2.0)
	for i in 12:
		var fl := base_floor + i + 1
		var c := Vector2(tx0 + i * 30.0, 39)
		var boss_f: bool = fl % g.boss_every == 0
		var col := Color(0.35, 0.3, 0.4)
		if fl < g.floor_num:
			col = GOLD.darkened(0.3)
		elif fl == g.floor_num:
			col = Color.WHITE
		if boss_f:
			_diamond(c, 9.0 if fl != g.floor_num else 11.0 + sin(t * 6.0), RED if fl >= g.floor_num else RED.darkened(0.5))
			_diamond(c, 4.0, col)
		else:
			draw_circle(c, 5.0 if fl != g.floor_num else 7.0, col)
	var secs := int(g.run_time)
	if g.settings.val("timer"):
		_ctxt(76, "FLOOR %d    %02d:%02d" % [g.floor_num, secs / 60, secs % 60], 18, Color(1, 1, 1, 0.85))
	else:
		_ctxt(76, "FLOOR %d" % g.floor_num, 18, Color(1, 1, 1, 0.85))

	_ctxt(98, "%s STATUS" % g.Cities.status_name(g.run_status()), 13, g.Cities.CITIES[clampi(g.run_status() - 1, 0, 4)]["col"] if g.run_status() >= 1 else DIM)
	# --- Minimap.
	if mini_tex and g.level and is_instance_valid(g.level):
		var lv = g.level
		var sc := minf(176.0 / lv.w, 120.0 / lv.h)
		var mr := Rect2(1264 - lv.w * sc, 112, lv.w * sc, lv.h * sc)
		draw_rect(mr.grow(4), Color(0, 0, 0, 0.55))
		draw_rect(mr.grow(4), Color(1, 1, 1, 0.1), false, 1.0)
		draw_texture_rect(mini_tex, mr, false)
		var pp: Vector2 = g.player.global_position / 16.0 * sc + mr.position
		if _blink(250):
			draw_circle(pp, 3.0, Color.WHITE)
		var ex: Vector2 = lv.exit_pos / 16.0
		if lv.seen[clampi(int(ex.y) - 1, 0, lv.h - 1) * lv.w + clampi(int(ex.x), 0, lv.w - 1)] == 1:
			_diamond(ex * sc + mr.position + Vector2(0, -sc), 4.0, GOLD)
		if g.boss and is_instance_valid(g.boss) and g.boss.alive():
			draw_circle(g.boss.global_position / 16.0 * sc + mr.position, 4.0, RED)
		# House rules under the map.
		var y := mr.end.y + 30.0
		if g.rules.size() > 0:
			_txt(Vector2(0, y), "HOUSE RULES", 16, RED, HORIZONTAL_ALIGNMENT_RIGHT, 1262.0)
			for r in g.rules:
				var info: Dictionary = g.rule_info(r)
				y += 22.0
				draw_rect(Rect2(1262 - 190, y - 15, 190, 19), Color(0.3, 0.02, 0.06, 0.6))
				_txt(Vector2(0, y), info["name"], 15, Color(1, 0.65, 0.55), HORIZONTAL_ALIGNMENT_RIGHT, 1258.0)

	# --- Last call.
	if g.last_call_left > 0.0:
		_ctxt(108, "LAST CALL  %d" % ceili(g.last_call_left), 28, Color(1, 0.6, 0.25) if g.last_call_left > 10.0 else RED)
	elif g.last_call_left == 0.0 and _blink(250):
		_ctxt(108, "THE POT IS BLEEDING", 28, RED)

	# --- Flow meter.
	var tier: int = g.flow_mult()
	var tc := _tier_col(tier)
	var bx := 20.0
	var by := 680.0
	var bw := 440.0
	var bh := 20.0
	var ratio: float = g.flow / g.flow_max
	draw_rect(Rect2(bx - 4, by - 4, bw + 8, bh + 8), Color(0, 0, 0, 0.7))
	draw_rect(Rect2(bx, by, bw * ratio, bh), tc)
	draw_rect(Rect2(bx, by, bw * ratio, 5), Color(1, 1, 1, 0.3))
	for i in range(1, 4):
		draw_rect(Rect2(bx + bw * i / 4.0 - 1, by, 2, bh), Color(0, 0, 0, 0.55))
	if tier >= 4:
		for i in 14:
			var fx0 := bx + (i + 0.5) * bw * ratio / 14.0
			var fh := 10.0 + 8.0 * absf(sin(t * 9.0 + i * 1.7))
			draw_colored_polygon(PackedVector2Array([Vector2(fx0 - 6, by), Vector2(fx0, by - fh), Vector2(fx0 + 6, by)]), Color(tc, 0.55))
	_txt(Vector2(bx, by - 12), "FLOW", 18, DIM)
	_txt(Vector2(bx + 64, by - 10), "x%d" % tier, 34 + (int(4.0 * maxf(0.0, sin(t * 12.0))) if tier >= 4 else 0), tc)
	if g.chain > 1:
		var cs := int(26 + chain_pop * 14)
		_txt(Vector2(bx + 140, by - 10), "%d CHAIN" % g.chain, cs, Color.WHITE.lerp(GOLD, minf(1.0, g.chain / 25.0)))
	for i in g.popups.size():
		var p: Dictionary = g.popups[i]
		var life: float = p["life"]
		var a: float = clampf(life / 0.35, 0.0, 1.0) * (1.0 - i * 0.15)
		_txt(Vector2(bx, by - 52 - i * 26), p["t"], 22 if i == 0 else 18, Color(tc, a))

	# --- Boss bar.
	if g.boss and is_instance_valid(g.boss) and g.boss.state != "intro":
		_draw_boss_bar(g.boss)

	# --- Floor banner.
	if g.banner_t > 0.0 and g.zone_card_t <= 0.0:
		var a: float = clampf(g.banner_t, 0.0, 1.0)
		var head := "FLOOR %d" % g.floor_num
		if g.is_boss_floor() and g.boss and is_instance_valid(g.boss):
			head = "BOSS FLOOR"
			_ctxt(300, g.boss.bname, 30, Color(RED, a))
		else:
			_ctxt(300, g.banner_sub, 24, Color(GOLD, a))
		_ctxt(250, head, 72, Color(1, 1, 1, a))

	# --- Callout.
	if g.callout_t > 0.0:
		var k: float = g.callout_t
		var sc := 1.0 + maxf(0.0, (k - 0.85) * 4.0)
		_ctxt(200, g.callout, int(56 * sc), Color(g.callout_col, minf(1.0, k * 2.0)))

	# --- Interact prompt.
	if g.interact_text != "" and g.state == "play":
		var sp: Vector2 = g.to_screen(g.interact_pos)
		var tw := f.get_string_size(g.interact_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 20).x
		draw_rect(Rect2(sp.x - tw * 0.5 - 10, sp.y - 26, tw + 20, 34), Color(0, 0, 0, 0.7))
		draw_rect(Rect2(sp.x - tw * 0.5 - 10, sp.y - 26, tw + 20, 34), GOLD, false, 2.0)
		_txt(Vector2(sp.x - 150, sp.y - 2), g.interact_text, 20, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 300)

	if g.floor_num == 1 and g.state == "play" and g.banner_t <= 0.0 and g.run_time < 40.0 and g.settings.val("hints"):
		_ctxt(712, "F / J strike     Q / K parry     Shift dash     Down slide     Up at doors and machines", 15, Color(DIM, 0.8))


func _draw_boss_bar(b) -> void:
	var w := 720.0
	var x := 640.0 - w * 0.5
	var y := 628.0
	var ratio: float = float(b.hp) / float(b.max_hp)
	var col: Color = [Color(0.85, 0.3, 0.25), Color(0.9, 0.15, 0.35), Color(0.95, 0.75, 0.25)][b.tier - 1]
	_txt(Vector2(x, y - 14), b.bname, 30, Color.WHITE)
	var nw := f.get_string_size(b.bname, HORIZONTAL_ALIGNMENT_LEFT, -1, 30).x
	_txt(Vector2(x + nw + 14, y - 16), b.title, 17, DIM)
	for i in 3:
		var pc := Vector2(x + w - 10 - i * 22, y - 22)
		_diamond(pc, 8.0, RED if b.phase > i else Color(0.3, 0.15, 0.2))
	draw_rect(Rect2(x - 4, y - 4, w + 8, 30), Color(0, 0, 0, 0.8))
	draw_rect(Rect2(x, y, w, 22), Color(0.15, 0.05, 0.08))
	draw_rect(Rect2(x, y, w * boss_ghost, 22), Color(1, 0.95, 0.85, 0.85))
	draw_rect(Rect2(x, y, w * ratio, 22), col)
	draw_rect(Rect2(x, y, w * ratio, 6), col.lightened(0.35))
	for i in range(1, 10):
		draw_rect(Rect2(x + w * i / 10.0, y, 1, 22), Color(0, 0, 0, 0.35))
	_diamond(Vector2(x + w * 0.5, y + 11), 7.0, Color(0, 0, 0, 0.8))
	_diamond(Vector2(x + w * 0.5, y + 11), 4.0, GOLD)
	if b.flash > 0.0:
		draw_rect(Rect2(x, y, w * ratio, 22), Color(1, 1, 1, 0.7))
	if b.is_stunned():
		if _blink(200):
			_ctxt(y + 50, "STUNNED  -  DOUBLE DAMAGE", 20, GOLD)
	elif b.state == "dead":
		_ctxt(y + 50, "DEFEATED", 22, GOLD)
	if g.boss_shout_t > 0.0:
		_ctxt(y - 50, "\"%s\"" % g.boss_shout, 24, Color(1, 0.85, 0.8, minf(1.0, g.boss_shout_t)))


# ---------------------------------------------------------------- dialogue

func _draw_dialog() -> void:
	if g.dialog.is_empty():
		return
	var line: Array = g.dialog[0]
	var who: String = line[0]
	var text: String = line[1]
	var shown := text.substr(0, int(g.dialog_chars))
	var box := Rect2(150, 500, 980, 170)
	draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.35))
	draw_rect(box.grow(4), GOLD.darkened(0.3))
	draw_rect(box, Color(0.05, 0.02, 0.08, 0.96))
	var port := Rect2(box.position + Vector2(18, 18), Vector2(134, 134))
	draw_rect(port, Color(0.12, 0.06, 0.16))
	draw_rect(port, Color(1, 1, 1, 0.15), false, 2.0)
	if BOSS_TIERS.has(who):
		Art.boss_portrait(self, port.get_center(), BOSS_TIERS[who], t)
	elif Art.npc_portrait(self, port.get_center(), who, t):
		pass
	elif portraits.has(who):
		var tex: Texture2D = portraits[who]
		var s := 11.0 if tex.get_height() <= 8 else 10.0
		var ts := tex.get_size() * s
		draw_texture_rect(tex, Rect2(port.get_center() - ts * 0.5 + Vector2(0, 10), ts), false)
	elif who == "MARLOW":
		var c := port.get_center()
		draw_rect(Rect2(c + Vector2(-40, -20), Vector2(80, 56)), Color(0.25, 0.25, 0.3))
		draw_rect(Rect2(c + Vector2(-34, -14), Vector2(36, 44)), Color(0.1, 0.1, 0.12))
		for i in 5:
			draw_rect(Rect2(c + Vector2(-32, -10 + i * 8), Vector2(32, 3)), Color(0.35, 0.35, 0.4))
		draw_circle(c + Vector2(20, 0), 9.0, GOLD.darkened(0.2))
		draw_line(c + Vector2(28, -20), c + Vector2(38, -52), Color(0.6, 0.6, 0.65), 3.0)
		if _blink(300):
			draw_circle(c + Vector2(20, 22), 3.0, RED)
	var name_col := GOLD
	match who:
		"RICO", "JULES", "DICE":
			name_col = Color(0.75, 0.6, 1.0)
		"MARLOW":
			name_col = CYAN
		"LUCKY":
			name_col = GREEN
		"VERA":
			name_col = Color(1, 0.6, 0.75)
		"MAGS":
			name_col = Color(1, 0.5, 0.5)
		"THE HOUSE":
			name_col = GOLD
		_:
			name_col = RED
	_txt(box.position + Vector2(176, 42), who, 24, name_col)
	draw_multiline_string(f, box.position + Vector2(176, 80), shown, HORIZONTAL_ALIGNMENT_LEFT, 780, 22, 4, Color(0.95, 0.92, 1.0))
	if int(g.dialog_chars) >= text.length() and _blink(400):
		_txt(box.position + Vector2(box.size.x - 140, box.size.y - 16), "JUMP  >", 18, GOLD)


# ---------------------------------------------------------------- menus

func _draw_logo(y: float) -> void:
	var wob := sin(t * 1.5) * 3.0
	var flick := 0.35 if int(t * 7.0) % 41 == 0 else 1.0
	draw_string_outline(f, Vector2(0, y + wob), "LET IT RIDE", HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 116, 34, Color(1, 0.45, 0.2, 0.16 * flick))
	draw_string_outline(f, Vector2(0, y + wob), "LET IT RIDE", HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 116, 14, Color(0.25, 0.02, 0.08, 0.95))
	draw_string(f, Vector2(0, y + wob), "LET IT RIDE", HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 116, Color(GOLD.lightened(0.1), flick))
	draw_string(f, Vector2(0, y + wob - 3), "LET IT RIDE", HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 116, Color(1, 0.95, 0.75, 0.25 * flick))
	draw_rect(Rect2(380, y + 18, 520, 3), Color(1, 0.3, 0.6, 0.8 * flick))
	_diamond(Vector2(370, y + 19), 7.0, Color(1, 0.3, 0.6, flick))
	_diamond(Vector2(910, y + 19), 7.0, Color(1, 0.3, 0.6, flick))


func _draw_title() -> void:
	Scenery.title(self, f, t)
	_draw_logo(150)
	_ctxt(204, "Break into The Pit.  Rescue Jules.  Know when to walk away.", 21, Color(0.95, 0.88, 0.95))
	if g.intro_seen:
		_txt(Vector2(112, 300), "Your Marker is still open. The Lobby is waiting.", 15, Color(1, 0.6, 0.6, 0.85))
	var items: Array = g.title_items()
	for i in items.size():
		var sel: bool = i == g.title_sel
		var y := 350.0 + i * 46.0
		if sel:
			Scenery.hgrad(self, Rect2(92, y - 32, 420, 42), Color(1, 0.75, 0.25, 0.28), Color(1, 0.75, 0.25, 0.0))
			draw_rect(Rect2(92, y - 32, 4, 42), GOLD)
			Scenery.chip(self, Vector2(124, y - 11), 12.0, Color(0.85, 0.12, 0.18), 0.0, absf(cos(t * 3.0)))
		_txt(Vector2(150 if sel else 140, y), items[i], 30 if sel else 25, GOLD if sel else Color(1, 1, 1, 0.85))
	# Runner select card.
	var ch: Dictionary = g.CHARACTERS[g.char_i]
	var unlocked: bool = g.char_unlocked(g.char_i)
	var pr := Rect2(92, 586, 440, 92)
	draw_rect(pr, Color(0.02, 0.0, 0.05, 0.75))
	draw_rect(pr, Color(0.75, 0.6, 1.0, 0.55), false, 1.5)
	var pc := Rect2(pr.position + Vector2(8, 8), Vector2(76, 76))
	draw_rect(pc, Color(0.12, 0.06, 0.16))
	if unlocked:
		Art.npc_portrait(self, pc.get_center() + Vector2(0, 2), ch["name"], t, 4.6)
	else:
		_txt(Vector2(pc.position.x, pc.position.y + 54), "?", 48, DIM, HORIZONTAL_ALIGNMENT_CENTER, pc.size.x)
	_txt(Vector2(pr.position.x + 100, pr.position.y + 32), "RUNNER", 13, DIM)
	_txt(Vector2(pr.position.x + 160, pr.position.y + 33), "<  " + (ch["name"] if unlocked else "???") + "  >", 22, Color(0.85, 0.75, 1.0))
	draw_multiline_string(f, Vector2(pr.position.x + 100, pr.position.y + 58), ch["desc"] if unlocked else ch["lock"], HORIZONTAL_ALIGNMENT_LEFT, 330, 14, 2, DIM)
	# Stats ribbon.
	var stats := "WALLET %s     LEVEL %d     BEST %s     RUNS %d     BOSSES %d/3     TROPHIES %d/%d" % [
		_money(g.wallet), g.level_num, _money(g.best), g.runs, mini(5, g.bosses_beaten / g.boss_every), g.trophies.size(), g.TROPHIES.size()]
	_txt(Vector2(600, 672), "UP / DOWN choose     LEFT / RIGHT runner     JUMP select", 15, Color(DIM, 0.85), HORIZONTAL_ALIGNMENT_RIGHT, 640)
	_txt(Vector2(600, 700), stats, 15, Color(1, 0.9, 0.7, 0.9), HORIZONTAL_ALIGNMENT_RIGHT, 640)


func _draw_loading() -> void:
	Scenery.painting(self, f, g.load_kind, g.load_t if String(g.load_kind).begins_with("drive") else t)
	var shade_y := 540.0 if String(g.load_kind).begins_with("drive") else 440.0
	Scenery.vgrad(self, Rect2(0, shade_y, 1280, 720 - shade_y), [[0.0, Color(0, 0, 0, 0.0)], [0.42, Color(0.01, 0.0, 0.03, 0.86)], [1.0, Color(0.01, 0.0, 0.03, 0.97)]])
	var slide := (1.0 - ease(clampf(g.load_t / 0.5, 0.0, 1.0), 0.3)) * 40.0
	_txt(Vector2(70 - slide, 596), g.load_title, 60, GOLD)
	draw_rect(Rect2(72 - slide, 612, 380, 3), Color(1, 0.3, 0.6, 0.85))
	_txt(Vector2(72 - slide, 644), g.load_sub, 19, Color.WHITE)
	_txt(Vector2(72, 688), "TIP", 15, CYAN)
	draw_multiline_string(f, Vector2(112, 688), g.load_tip, HORIZONTAL_ALIGNMENT_LEFT, 900, 17, 2, DIM)
	# Spinning chip "loading" indicator.
	var c := Vector2(1196, 626)
	Scenery.glow(self, c, 46.0, 46.0, Color(1, 0.4, 0.3, 0.25))
	Scenery.chip(self, c, 26.0, Color(0.85, 0.12, 0.18), 0.0, maxf(0.08, absf(cos(t * 3.2))))
	var ready: bool = g.load_done and g.load_t > (2.5 if String(g.load_kind).begins_with("drive") else 0.8)
	var dots := ".".repeat(int(t * 3.0) % 4)
	_txt(Vector2(980, 690), ("JUMP  continue" if ready else "LOADING" + dots), 16, Color(1, 1, 1, 0.75), HORIZONTAL_ALIGNMENT_RIGHT, 260)
	var k := clampf(g.load_t / maxf(0.01, g.load_dur), 0.0, 1.0)
	draw_rect(Rect2(0, 714, 1280, 6), Color(0, 0, 0, 0.7))
	draw_rect(Rect2(0, 714, 1280 * k, 6), GOLD)
	draw_rect(Rect2(1280 * k - 30, 714, 30, 6), Color(1, 1, 0.85, 0.8))
	var a_in := clampf(g.load_t / 0.3, 0.0, 1.0)
	if a_in < 1.0:
		draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 1.0 - a_in))
	var a_out := clampf((g.load_t - (g.load_dur - 0.25)) / 0.25, 0.0, 1.0) if g.load_done else 0.0
	if a_out > 0.0:
		draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, a_out))


func _draw_skills() -> void:
	Scenery.vgrad(self, Rect2(0, 0, 1280, 720), [[0.0, Color(0.03, 0.01, 0.06)], [1.0, Color(0.08, 0.02, 0.08)]])
	_ctxt(62, "THE FENCE", 48, GOLD)
	_ctxt(92, "Marlow's contact sells talent. Every level earns SKILL POINTS.", 17, DIM)
	# Level, XP and points.
	var lr := Rect2(40, 26, 300, 74)
	_panel(lr, GREEN)
	_txt(Vector2(58, 54), "LEVEL %d" % g.level_num, 24, Color.WHITE)
	_xp_bar(Rect2(58, 66, 260, 10))
	_txt(Vector2(58, 94), "%d / %d XP" % [g.xp, g.xp_need(g.level_num)], 14, DIM)
	var sr := Rect2(940, 26, 300, 74)
	_panel(sr, GOLD)
	_txt(Vector2(958, 56), "SKILL POINTS", 16, DIM)
	_txt(Vector2(940, 60), str(g.skill_points), 36, GOLD, HORIZONTAL_ALIGNMENT_RIGHT, 284)
	_txt(Vector2(958, 90), "WALLET  " + _money(g.wallet), 15, GREEN)
	var bw := 228.0
	for b in g.BRANCHES.size():
		var cx: float = 152.0 + b * 244.0
		_txt(Vector2(cx - bw * 0.5, 146), g.BRANCHES[b][0], 24, g.BRANCHES[b][1], HORIZONTAL_ALIGNMENT_CENTER, bw)
	var sel_node: Dictionary = g.SKILLS[g.skill_sel]
	for i in g.SKILLS.size():
		var sk: Dictionary = g.SKILLS[i]
		var bc: Color = g.BRANCHES[sk["branch"]][1]
		var cx: float = 152.0 + sk["branch"] * 244.0
		var cy: float = 200.0 + sk["tier"] * 96.0
		var owned: bool = g.has_skill(sk["id"])
		var avail: bool = g.skill_available(sk)
		if sk["tier"] > 0:
			draw_line(Vector2(cx, cy - 96 + 30), Vector2(cx, cy - 30), Color(bc, 0.85 if owned else 0.2), 4.0)
		var r := Rect2(cx - bw * 0.5, cy - 30, bw, 60)
		draw_rect(r, Color(bc, 0.22) if owned else Color(0.08, 0.05, 0.1))
		var border: Color = bc if owned else (Color(1, 1, 1, 0.5) if avail else Color(1, 1, 1, 0.12))
		draw_rect(r, border, false, 2.0)
		if i == g.skill_sel:
			draw_rect(r.grow(5), Color(1, 1, 1, 0.8 + 0.2 * sin(t * 8.0)), false, 3.0)
		_txt(Vector2(r.position.x + 12, cy - 5), sk["name"], 17, Color.WHITE if (owned or avail) else Color(1, 1, 1, 0.35))
		var cost: int = sk["cost"]
		var cost_txt := "LEARNED" if owned else "%d SKILL POINT%s" % [cost, "S" if cost > 1 else ""]
		_txt(Vector2(r.position.x + 12, cy + 20), cost_txt, 14, GREEN if owned else (GOLD if g.skill_points >= cost and avail else Color(1, 0.45, 0.45, 0.8)))
	var dr := Rect2(140, 596, 1000, 108)
	_panel(dr, g.BRANCHES[sel_node["branch"]][1])
	_txt(Vector2(140, 630), sel_node["name"] + "   -   " + sel_node["desc"], 21, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 1000)
	_txt(Vector2(140, 660), "Buy an extra SKILL POINT for %s banked:  press STRIKE" % _money(g.sp_price()), 16, Color(1, 0.9, 0.6), HORIZONTAL_ALIGNMENT_CENTER, 1000)
	_txt(Vector2(140, 690), g.skill_msg if g.skill_msg != "" else "ARROWS move     JUMP learn     STRIKE buy a point     ESC back", 15, DIM, HORIZONTAL_ALIGNMENT_CENTER, 1000)


func _xp_bar(r: Rect2) -> void:
	var k: float = clampf(float(g.xp) / float(g.xp_need(g.level_num)), 0.0, 1.0)
	draw_rect(r, Color(0, 0, 0, 0.6))
	draw_rect(Rect2(r.position, Vector2(r.size.x * k, r.size.y)), GREEN)
	if g.xp_flash > 0.0:
		draw_rect(Rect2(r.position, Vector2(r.size.x * k, r.size.y)), Color(1, 1, 1, 0.5 * g.xp_flash))
	draw_rect(r, Color(1, 1, 1, 0.25), false, 1.0)


func _draw_trophies() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.03, 0.01, 0.05, 0.92))
	_ctxt(70, "TROPHY CASE", 52, CYAN)
	_ctxt(104, "%d of %d earned" % [g.trophies.size(), g.TROPHIES.size()], 18, DIM)
	for i in g.TROPHIES.size():
		var tr: Dictionary = g.TROPHIES[i]
		var col: int = i % 2
		var row: int = i / 2
		var r := Rect2(90 + col * 560, 130 + row * 46, 540, 40)
		var got: bool = g.trophies.has(tr["id"])
		draw_rect(r, Color(0.3, 0.6, 0.8, 0.2) if got else Color(0.08, 0.05, 0.1))
		draw_rect(r, CYAN if got else Color(1, 1, 1, 0.1), false, 2.0)
		_diamond(r.position + Vector2(22, 20), 11.0, GOLD if got else Color(0.2, 0.15, 0.25))
		_txt(r.position + Vector2(44, 26), tr["name"] if got or not tr.get("secret", false) else "???", 18, Color.WHITE if got else DIM)
		_txt(r.position + Vector2(230, 26), tr["desc"] if got or not tr.get("secret", false) else "A secret.", 14, DIM)
	_ctxt(700, "ESC back", 16, DIM)


func _draw_pause() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.65))
	_ctxt(200, "PAUSED", 72, Color.WHITE)
	var items: Array = g.pause_items()
	for i in items.size():
		var sel: bool = i == g.pause_sel
		var y := 290.0 + i * 52.0
		if sel:
			draw_rect(Rect2(460, y - 34, 360, 46), Color(1, 0.8, 0.3, 0.12))
			draw_rect(Rect2(460, y - 34, 360, 46), GOLD, false, 2.0)
		_ctxt(y, items[i], 28 if sel else 24, GOLD if sel else Color.WHITE)
	var s: Dictionary = g.stats
	_ctxt(660, "Kills %d    Parries %d    Smashed %d    Best chain %d" % [s.get("kills", 0), s.get("parries", 0), s.get("smashed", 0), g.best_chain], 18, DIM)
	if not g.in_hub:
		var cr := Rect2(40, 250, 360, 60 + maxi(1, g.charms.equipped.size()) * 62)
		_panel(cr, GOLD)
		_txt(Vector2(60, 282), "CHARMS  %d / %d" % [g.charms.equipped.size(), g.charms.max_slots], 20, GOLD)
		if g.charms.equipped.is_empty():
			_txt(Vector2(60, 318), "None yet. Win them on slots, buy them", 15, DIM)
			_txt(Vector2(60, 338), "from Vera, crack Vault Doors, beat bosses.", 15, DIM)
		for i in g.charms.equipped.size():
			var id: String = g.charms.equipped[i]
			var inf: Dictionary = Charms.info(id)
			var cy: float = 316.0 + float(i) * 62.0
			draw_circle(Vector2(70, cy + 4), 12.0, Charms.color(id))
			draw_circle(Vector2(70, cy + 4), 7.0, Charms.color(id).darkened(0.5))
			_txt(Vector2(92, cy), inf["name"], 18, Color.WHITE)
			draw_multiline_string(f, Vector2(92, cy + 20), inf["desc"], HORIZONTAL_ALIGNMENT_LEFT, 290, 14, 2, DIM)


func _draw_choice() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.0, 0.04, 0.84))
	_ctxt(110, "FLOOR %d CLEARED" % g.floor_num, 40, GOLD)
	_ctxt(212, "Bank it and it's safe forever.  Ride it and it doubles, but a bust loses everything at risk.", 17, DIM)
	_ctxt(176, "POT  %s   x%d" % [_money(g.pot), g.pot_mult], 52, Color.WHITE)
	var boxes := [Rect2(170, 230, 440, 330), Rect2(670, 230, 440, 330)]
	for i in 2:
		var r: Rect2 = boxes[i]
		var sel: bool = g.choice_idx == i
		draw_rect(r, Color(1, 1, 1, 0.07) if sel else Color(0, 0, 0, 0.4))
		draw_rect(r, GOLD if sel else Color(0.4, 0.35, 0.45), false, 4.0 if sel else 2.0)
	var l: Rect2 = boxes[0]
	_txt(Vector2(l.position.x, 300), "CASH OUT", 46, GREEN, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 360), "Bank " + _money(g.charms.cash_out(g.pot * g.pot_mult)), 30, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	if g._debt() > 0:
		_txt(Vector2(l.position.x, 388), "Mags takes up to " + _money(g._debt()), 17, Color(1, 0.55, 0.55), HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 410), "+1 life", 22, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 440), "Multiplier resets to x1", 22, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 470), "All House Rules cleared", 22, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 535), "[1]", 20, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	var r2: Rect2 = boxes[1]
	_txt(Vector2(r2.position.x, 300), "LET IT RIDE", 46, RED, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
	_txt(Vector2(r2.position.x, 360), "Pot multiplier x%d" % (g.pot_mult * g.charms.ride_factor()), 30, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
	_txt(Vector2(r2.position.x, 410), _money(g.pot) + " stays on the table", 22, DIM, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
	if g.pending_rule != "":
		var info: Dictionary = g.rule_info(g.pending_rule)
		_txt(Vector2(r2.position.x, 450), "NEW HOUSE RULE", 20, RED, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
		_txt(Vector2(r2.position.x, 482), info["name"], 28, Color(1, 0.62, 0.5), HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
		_txt(Vector2(r2.position.x, 510), info["desc"], 18, DIM, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
	_txt(Vector2(r2.position.x, 545), "[2]", 20, DIM, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
	var next: int = g.floor_num + 1
	if next % g.boss_every == 0:
		_ctxt(600, "NEXT FLOOR: BOSS FIGHT", 26, RED if _blink(300) else GOLD)
	_ctxt(650, "LEFT / RIGHT to choose      JUMP to confirm", 22, Color.WHITE)


func _draw_dead() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.16, 0.0, 0.03, minf(0.88, g.dead_t * 1.4)))
	if g.dead_t < 0.4:
		return
	var k := clampf((g.dead_t - 0.4) * 3.0, 0.0, 1.0)
	var bump := 1.0 + (1.0 - k) * 0.4
	_ctxt(118, "BUSTED", int(96 * bump), Color(RED, k))
	_ctxt(156, g.death_reason, 22, Color(DIM, k))
	# The House's collection notice, slid in like a receipt.
	var slide := (1.0 - k) * 60.0
	var r := Rect2(360, 182 + slide, 560, 420)
	draw_rect(r.grow(4), Color(0, 0, 0, 0.5 * k))
	draw_rect(r, Color(0.95, 0.92, 0.84, k))
	for i in 28:
		var zx := r.position.x + i * 20.0
		draw_colored_polygon(PackedVector2Array([Vector2(zx, r.end.y), Vector2(zx + 10, r.end.y + 8), Vector2(zx + 20, r.end.y)]), Color(0.95, 0.92, 0.84, k))
	var ink := Color(0.16, 0.07, 0.1, k)
	var red_ink := Color(0.7, 0.08, 0.14, k)
	var green_ink := Color(0.1, 0.45, 0.2, k)
	_txt(Vector2(r.position.x, r.position.y + 38), "THE HOUSE", 30, red_ink, HORIZONTAL_ALIGNMENT_CENTER, r.size.x)
	_txt(Vector2(r.position.x, r.position.y + 62), "COLLECTION NOTICE  #%06d" % (int(g.pstats.get("deaths", 0)) * 7919 % 1000000), 15, ink, HORIZONTAL_ALIGNMENT_CENTER, r.size.x)
	draw_line(r.position + Vector2(24, 76), r.position + Vector2(r.size.x - 24, 76), Color(ink, 0.4 * k), 1.0)
	var rows: Array = [["Lost at the table", "-" + _money(g.lost_pot), red_ink]]
	if g.kept_pot > 0:
		rows.append(["Insurance paid out", "+" + _money(g.kept_pot), green_ink])
	if g.heat_bonus > 0:
		rows.append(["Heat bonus (Heat %d)" % g.heat_run, "+" + _money(g.heat_bonus), green_ink])
	rows.append(["Banked this run", _money(g.banked), green_ink])
	rows.append(["Interest added to your Marker", "12%", red_ink])
	var y := r.position.y + 106
	for row in rows:
		_txt(Vector2(r.position.x + 30, y), row[0], 18, ink)
		_txt(Vector2(r.position.x, y), row[1], 20, row[2], HORIZONTAL_ALIGNMENT_RIGHT, r.size.x - 30)
		y += 28
	draw_line(Vector2(r.position.x + 24, y - 12), Vector2(r.end.x - 24, y - 12), Color(ink, 0.25 * k), 1.0)
	var s2: Dictionary = g.stats
	var secs := int(g.run_time)
	var st := [
		["Floor reached", str(g.floor_num)], ["Time", "%02d:%02d" % [secs / 60, secs % 60]],
		["Knockouts", str(s2.get("kills", 0))], ["Parries", str(s2.get("parries", 0))],
		["Best chain", str(g.best_chain)], ["Rode / banked", "%d / %d" % [g.run_rides, g.run_cashouts]],
	]
	for i in st.size():
		var cx := r.position.x + 30 + (i % 2) * 260.0
		var cy := y + 14 + (i / 2) * 26.0
		_txt(Vector2(cx, cy), st[i][0], 15, Color(ink, 0.75 * k))
		_txt(Vector2(cx - 20, cy), st[i][1], 16, ink, HORIZONTAL_ALIGNMENT_RIGHT, 240)
	var foot := y + 104
	var daily_txt := ""
	if g.is_daily:
		daily_txt = "DAILY DEAL  " + ("score " + _money(g.banked) + "   best today " + _money(g.daily_best) if g.daily_scored and not g.assisted else "practice run (not scored)")
	_txt(Vector2(r.position.x, foot), daily_txt if daily_txt != "" else "Seed %d" % g.run_seed, 14, Color(ink, 0.7 * k), HORIZONTAL_ALIGNMENT_CENTER, r.size.x)
	_txt(Vector2(r.position.x, foot + 26), g.death_quip, 15, Color(red_ink, 0.85 * k), HORIZONTAL_ALIGNMENT_CENTER, r.size.x)
	if g.new_best:
		_txt(Vector2(r.end.x - 150, r.position.y + 40), "NEW BEST!", 18, red_ink)
	if g.dead_t > 1.0 and _blink(600):
		_ctxt(660, "JUMP  wake up in the Lobby        R  run it back now        ESC  title", 22, Color.WHITE)


func _draw_toasts() -> void:
	if g.state == "menu" or g.state == "cine":
		return
	for i in g.toasts.size():
		var tst: Dictionary = g.toasts[i]
		var life: float = tst["t"]
		var slide := clampf((4.0 - life) * 4.0, 0.0, 1.0) * clampf(life * 3.0, 0.0, 1.0)
		var r := Rect2(1280 - 440 * slide, 260 + i * 80, 420, 68)
		draw_rect(r, Color(0.05, 0.03, 0.08, 0.95))
		draw_rect(r, CYAN, false, 2.0)
		_diamond(r.position + Vector2(34, 34), 18.0, GOLD)
		_txt(r.position + Vector2(64, 28), tst["text"], 15, CYAN)
		var sub: String = tst["sub"]
		var sz := 20
		while sz > 13 and f.get_string_size(sub, HORIZONTAL_ALIGNMENT_LEFT, -1, sz).x > 340.0:
			sz -= 1
		_txt(r.position + Vector2(64, 52), sub, sz, Color.WHITE)


# ================================================================ new HUD pieces

func _draw_common() -> void:
	# --- The House over the PA.
	if g.bark_t > 0.0 and g.bark_text != "" and (g.state == "play" or g.state == "dialog"):
		var a := clampf(g.bark_t * 2.0, 0.0, 1.0) * clampf((5.0 - g.bark_t) * 4.0, 0.0, 1.0)
		var y := 118.0 if not g.in_hub else 96.0
		var label := "THE HOUSE"
		var tw := f.get_string_size(g.bark_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 19).x
		var lw := f.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x
		var w := tw + lw + 56.0
		var r := Rect2(640 - w * 0.5, y - 22, w, 34)
		draw_rect(r, Color(0.08, 0.0, 0.03, 0.82 * a))
		draw_rect(r, Color(RED, 0.7 * a), false, 2.0)
		var pulse := 0.6 + 0.4 * sin(t * 10.0)
		draw_circle(r.position + Vector2(14, 17), 4.0, Color(RED, a * pulse))
		_txt(r.position + Vector2(26, 23), label, 15, Color(RED.lightened(0.2), a))
		_txt(r.position + Vector2(36 + lw, 24), g.bark_text, 19, Color(1, 0.93, 0.88, a))
	# --- One-time tips (top center, so they never cover the floor you're on).
	if g.tip_t > 0.0 and g.tip_title != "" and (g.state == "play" or g.state == "dialog") and (g.in_hub or (g.banner_t <= 0.0 and g.zone_card_t <= 0.0)):
		var a := clampf(g.tip_t * 2.0, 0.0, 1.0) * clampf((8.0 - g.tip_t) * 4.0, 0.0, 1.0)
		var r := Rect2(700, 96, 540, 96) if g.in_hub else Rect2(370, 146, 540, 96)
		var rise := (1.0 - clampf((8.0 - g.tip_t) * 4.0, 0.0, 1.0)) * -16.0
		r.position.y += rise
		draw_rect(r.grow(3), Color(0, 0, 0, 0.45 * a))
		draw_rect(r, Color(0.05, 0.03, 0.1, 0.92 * a))
		draw_rect(r, Color(CYAN, 0.9 * a), false, 2.0)
		draw_rect(Rect2(r.position, Vector2(6, r.size.y)), Color(CYAN, a))
		_txt(r.position + Vector2(22, 26), "TIP", 14, Color(CYAN, a))
		_txt(r.position + Vector2(58, 27), g.tip_title, 19, Color(1, 1, 1, a))
		draw_multiline_string(f, r.position + Vector2(22, 52), g.tip_text, HORIZONTAL_ALIGNMENT_LEFT, r.size.x - 40, 16, 3, Color(DIM, a))
	if g.debug_overlay:
		_draw_debug()
	if g.voice_test_on:
		_draw_voice_test()
	if g.journal_on:
		_draw_journal()


## F4 hunter's journal: every enemy and boss you've met, kills per entry.
func _draw_journal() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.04, 0.03, 0.07, 0.94))
	_ctxt(62, "THE DEGENERATE'S JOURNAL", 32, GOLD)
	_ctxt(90, "Everybody you've met on the climb, and how many times you've beaten them. (any key closes)", 15, DIM)
	var ET = g.EnemyTypes
	var names: Array = []
	for k in ET.T:
		names.append(ET.name_of(k))
	var bosses: Array = []
	for d in g.BossDefs.POOL:
		bosses.append(d["name"])
	for d in g.BossDefs.SECRET:
		bosses.append(d["name"])
	bosses.append(g.BossDefs.FINAL["name"])
	var y := 140.0
	_txt(Vector2(80, y), "ENEMIES", 18, CYAN)
	y += 30.0
	for i in names.size():
		var n: String = names[i]
		var kills := int(g.bestiary.get(n, 0))
		_txt(Vector2(80 + (i % 2) * 280, y + (i / 2) * 26), "%s  %s" % [n if kills > 0 else "? ? ?", "x%d" % kills if kills > 0 else ""], 16, Color.WHITE if kills > 0 else DIM)
	_txt(Vector2(660, 140), "BOSSES", 18, RED)
	for i in bosses.size():
		var bn: String = bosses[i]
		var bk := int(g.bestiary.get(bn, 0))
		_txt(Vector2(660, 170 + i * 26), "%s  %s" % [bn if bk > 0 else "? ? ?", "x%d" % bk if bk > 0 else ""], 16, Color.WHITE if bk > 0 else DIM)


## F3 voice test overlay.
func _draw_voice_test() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.86))
	var cid: String = g.VoiceProfiles.ORDER[g.vt_char % g.VoiceProfiles.ORDER.size()]
	var prof: Dictionary = g.VoiceProfiles.P[cid]
	_txt(Vector2(40, 52), "VOICE TEST", 30, GOLD)
	_txt(Vector2(40, 82), "LEFT/RIGHT: character    UP/DOWN: line    ENTER: play    F3/ESC: close", 15, DIM)
	_txt(Vector2(40, 130), "%s   (%s)" % [prof["name"], cid], 26, Color.WHITE)
	_txt(Vector2(40, 156), String(prof["role"]), 16, DIM)
	_txt(Vector2(40, 178), "Filter: " + g.VoiceProfiles.recipe(cid), 14, CYAN)
	var lines: Array = g.voice_test_lines()
	var first := clampi(g.vt_line - 8, 0, maxi(0, lines.size() - 17))
	for i in range(first, mini(lines.size(), first + 17)):
		var e: Dictionary = lines[i]
		var rec: bool = Voice.has_file(e)
		var y := 222.0 + (i - first) * 26.0
		if i == g.vt_line:
			draw_rect(Rect2(30, y - 18, 1220, 24), Color(1, 1, 1, 0.12))
		_txt(Vector2(40, y), "[x]" if rec else "[ ]", 15, GREEN if rec else DIM)
		_txt(Vector2(80, y), String(e["id"]), 15, GOLD if i == g.vt_line else Color(0.8, 0.8, 0.9))
		_txt(Vector2(380, y), String(e["text"]).left(100), 15, Color.WHITE if i == g.vt_line else DIM)
	_txt(Vector2(40, 690), "%d lines for this character. [x] = a recorded file was found in res://voice/%s/" % [lines.size(), cid], 14, DIM)


func _draw_objectives(x: float, y: float) -> void:
	var lines: Array = g.objective_lines()
	for i in lines.size():
		var main_line := i == 0
		var s: String = lines[i]
		var sz := 19 if main_line else 15
		var tw := f.get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, sz).x
		var r := Rect2(x - 6, y - sz - 3, tw + 34, sz + 10)
		draw_rect(r, Color(0, 0, 0, 0.5))
		if main_line:
			_diamond(Vector2(x + 7, y - sz * 0.35), 6.0 + sin(t * 4.0), GOLD)
			_txt(Vector2(x + 22, y), s, sz, Color.WHITE)
		else:
			var col := Color(1, 0.55, 0.55) if s.begins_with("MAGS") or s.begins_with("Owe") else CYAN
			draw_rect(Rect2(x + 4, y - sz * 0.5 - 2, 6, 6), col)
			_txt(Vector2(x + 22, y), s, sz, Color(col.lightened(0.3), 0.95))
		y += sz + 14


func _draw_run_extras() -> void:
	# Slim XP bar along the bottom edge with a level tag.
	var xk: float = clampf(float(g.xp) / float(g.xp_need(g.level_num)), 0.0, 1.0)
	draw_rect(Rect2(0, 716, 1280, 4), Color(0, 0, 0, 0.55))
	draw_rect(Rect2(0, 716, 1280 * xk, 4), Color(GREEN, 0.75 + 0.25 * g.xp_flash))
	if g.xp_flash > 0.0:
		_txt(Vector2(0, 708), "LV %d   +%d XP" % [g.level_num, g.last_xp_gain], 14, Color(GREEN, minf(1.0, g.xp_flash * 1.5)), HORIZONTAL_ALIGNMENT_RIGHT, 1268)
	_draw_coach()
	# --- Charm badges under the Pot panel.
	var eq: Array = g.charms.equipped
	var x := 16.0
	for i in g.charms.max_slots:
		var r := Rect2(x + i * 84.0, 144, 78, 26)
		if i < eq.size():
			var id: String = eq[i]
			var c := Charms.color(id)
			draw_rect(r, Color(c, 0.16))
			draw_rect(r, Color(c, 0.85), false, 1.5)
			draw_circle(r.position + Vector2(12, 13), 7.0, c)
			draw_circle(r.position + Vector2(12, 13), 3.5, c.darkened(0.5))
			var nm: String = String(Charms.info(id)["name"]).split(" ")[0]
			if nm.length() > 8:
				nm = nm.left(8)
			_txt(r.position + Vector2(23, 18), nm, 12, Color.WHITE)
		else:
			draw_rect(r, Color(0, 0, 0, 0.35))
			draw_rect(r, Color(1, 1, 1, 0.08), false, 1.0)
	_draw_objectives(22.0, 206.0)
	# --- Dice buff.
	if g.dice_chip_t > 0.0:
		_txt(Vector2(0, 640), "SNAKE EYES  CHIPS x2  %ds" % ceili(g.dice_chip_t), 18, GREEN, HORIZONTAL_ALIGNMENT_CENTER, 1280)


func _draw_hub() -> void:
	# --- Lobby panel.
	var pr := Rect2(16, 14, 380, 110)
	_panel(pr, Color(1, 0.6, 0.75))
	_txt(Vector2(34, 44), "HOME SWEET HOVEL", 26, Color(1, 0.75, 0.85))
	_txt(Vector2(34, 74), "WALLET  " + _money(g.wallet), 19, GREEN)
	_txt(Vector2(214, 74), "BEST  " + _money(g.best), 19, GOLD)
	_txt(Vector2(34, 104), "RUNS %d     TICKETS %d/%d     HEAT %d" % [g.runs, g.tickets.size(), g.Dialogue.TICKETS.size(), g.heat()], 15, DIM)
	# Level badge and XP.
	var lv := Rect2(410, 14, 250, 64)
	_panel(lv, GREEN)
	_txt(Vector2(426, 42), "LEVEL %d" % g.level_num, 21, Color.WHITE)
	if g.skill_points > 0:
		_txt(Vector2(410, 42), "%d SP TO SPEND" % g.skill_points, 14, GOLD if _blink(500) else Color(GOLD, 0.6), HORIZONTAL_ALIGNMENT_RIGHT, 236)
	_xp_bar(Rect2(426, 54, 218, 9))
	_draw_objectives(22.0, 160.0)
	# --- "!" over characters with something new to say.
	if g.level and is_instance_valid(g.level):
		for gm in g.level.games:
			var info: Array = g.HUB_KINDS.get(gm[1], ["", ""])
			if info[1] != "" and g.hub_new.get(info[1], false):
				var sp: Vector2 = g.to_screen((gm[0] as Vector2) + Vector2(0, -66))
				sp.y += sin(t * 5.0 + sp.x) * 5.0
				_diamond(sp, 17.0, Color(0, 0, 0, 0.6))
				_diamond(sp, 14.0, GOLD)
				_txt(sp + Vector2(-20, 9), "!", 26, Color(0.15, 0.05, 0.1), HORIZONTAL_ALIGNMENT_CENTER, 40)
		# Bouncing arrow over the DESCEND door when that's the goal.
		var lines: Array = g.objective_lines()
		if lines.size() > 0 and String(lines[0]).contains("your car"):
			var ep: Vector2 = g.to_screen(g.level.exit_pos + Vector2(0, -78))
			ep.y += sin(t * 6.0) * 7.0
			draw_colored_polygon(PackedVector2Array([ep + Vector2(-14, -10), ep + Vector2(14, -10), ep + Vector2(0, 8)]), GOLD)
			draw_polyline(PackedVector2Array([ep + Vector2(-14, -10), ep + Vector2(14, -10), ep + Vector2(0, 8), ep + Vector2(-14, -10)]), Color(0, 0, 0, 0.7), 2.0)
	# --- Callout + interact prompt.
	if g.callout_t > 0.0:
		var k: float = g.callout_t
		var sc := 1.0 + maxf(0.0, (k - 0.85) * 4.0)
		_ctxt(200, g.callout, int(48 * sc), Color(g.callout_col, minf(1.0, k * 2.0)))
	if g.interact_text != "" and g.state == "play":
		var sp: Vector2 = g.to_screen(g.interact_pos)
		var tw := f.get_string_size(g.interact_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 20).x
		draw_rect(Rect2(sp.x - tw * 0.5 - 12, sp.y - 26, tw + 24, 36), Color(0, 0, 0, 0.75))
		draw_rect(Rect2(sp.x - tw * 0.5 - 12, sp.y - 26, tw + 24, 36), GOLD, false, 2.0)
		_txt(Vector2(sp.x - 200, sp.y - 1), g.interact_text, 20, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 400)
	if g.settings.val("hints"):
		_ctxt(708, "UP  talk / interact      R  start a run right away      ESC  pause / settings", 15, Color(DIM, 0.8))


func _draw_cine() -> void:
	# World only: no HUD. Letterbox bars, title cards and dialogue.
	var b: float = ease(g.bars, -2.0)
	var bh := 92.0 * b
	draw_rect(Rect2(0, 0, 1280, bh), Color(0, 0, 0))
	draw_rect(Rect2(0, 720 - bh, 1280, bh), Color(0, 0, 0))
	if g.card_text != "":
		var k: float = g.card_t
		var dur: float = g.card_dur
		var a := clampf(k / 0.45, 0.0, 1.0) * clampf((dur - k) / 0.5, 0.0, 1.0)
		draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.45 * a))
		var grow := 1.0 + 0.06 * clampf(k / dur, 0.0, 1.0)
		var sz := int(78 * grow)
		var spread := 60.0 + 180.0 * clampf(k / 0.6, 0.0, 1.0)
		draw_rect(Rect2(640 - spread, 362, spread * 2.0, 2), Color(GOLD, a))
		_ctxt(342, g.card_text, sz, Color(GOLD.lightened(0.15), a))
		if g.card_sub != "":
			draw_multiline_string(f, Vector2(240, 402), g.card_sub, HORIZONTAL_ALIGNMENT_CENTER, 800, 22, 3, Color(DIM, a))
	if g.cast_name != "":
		_draw_cast_card()
	if not g.dialog.is_empty():
		_draw_dialog()
	if b > 0.5:
		_txt(Vector2(0, 708), "ESC  skip", 15, Color(1, 1, 1, 0.45 * b), HORIZONTAL_ALIGNMENT_RIGHT, 1260)


## Character introduction card: slides in from the left with a portrait,
## name, role and a one-line description.
func _draw_cast_card() -> void:
	var k: float = g.card_t
	var dur: float = g.card_dur
	var a := clampf(k / 0.3, 0.0, 1.0) * clampf((dur - k) / 0.35, 0.0, 1.0)
	var slide := (1.0 - ease(clampf(k / 0.45, 0.0, 1.0), 0.25)) * -520.0
	var who: String = g.cast_name
	var accent := GOLD
	match who:
		"RICO": accent = Color(0.75, 0.6, 1.0)
		"MAGS": accent = Color(1, 0.5, 0.5)
		"VERA": accent = Color(1, 0.6, 0.75)
		"LUCKY": accent = GREEN
		"MARLOW": accent = CYAN
		"COMP": accent = Color(1, 0.75, 0.9)
	var r := Rect2(70 + slide, 426, 660, 168)
	Scenery.hgrad(self, Rect2(r.position.x - 70, r.position.y, r.size.x + 200, r.size.y), Color(0.02, 0.0, 0.04, 0.92 * a), Color(0.02, 0.0, 0.04, 0.0))
	draw_rect(Rect2(r.position.x - 70, r.position.y, r.size.x + 120, 3), Color(accent, a))
	draw_rect(Rect2(r.position.x - 70, r.end.y - 3, r.size.x + 40, 3), Color(accent, 0.6 * a))
	var pb := Rect2(r.position + Vector2(10, 18), Vector2(132, 132))
	draw_rect(pb, Color(0.1, 0.05, 0.14, a))
	draw_rect(pb, Color(accent, 0.6 * a), false, 2.0)
	if a > 0.05:
		if BOSS_TIERS.has(who):
			Art.boss_portrait(self, pb.get_center(), BOSS_TIERS[who], t, 7.8)
		else:
			Art.npc_portrait(self, pb.get_center(), who, t, 7.6)
	_txt(r.position + Vector2(162, 40), g.cast_role, 17, Color(accent, a))
	_txt(r.position + Vector2(160, 94), who, 52, Color(1, 1, 1, a))
	draw_multiline_string(f, r.position + Vector2(162, 126), g.cast_line, HORIZONTAL_ALIGNMENT_LEFT, 480, 17, 2, Color(DIM, a))


func _draw_zone_card() -> void:
	var k: float = 3.2 - g.zone_card_t
	var a := clampf(k / 0.4, 0.0, 1.0) * clampf(g.zone_card_t / 0.6, 0.0, 1.0)
	var spread := 80.0 + 220.0 * clampf(k / 0.7, 0.0, 1.0)
	var z: int = g.zone_of(g.floor_num)
	_ctxt(300, "FLOOR %d   -   ZONE %d" % [g.floor_num, z + 1], 18, Color(DIM, a))
	draw_rect(Rect2(640 - spread, 318, spread * 2.0, 2), Color(GOLD, a))
	_ctxt(370, g.zone_card, 60, Color(GOLD.lightened(0.15), a))
	_ctxt(404, String(g.ZONES[z]["sub"]), 19, Color(1, 1, 1, 0.85 * a))


func _portrait_vera(c: Vector2) -> void:
	var skin := Color(0.92, 0.76, 0.66)
	var hair := Color(0.08, 0.05, 0.09)
	draw_rect(Rect2(c + Vector2(-44, 18), Vector2(88, 48)), Color(0.75, 0.08, 0.16))
	draw_rect(Rect2(c + Vector2(-10, 10), Vector2(20, 14)), skin)
	draw_rect(Rect2(c + Vector2(-30, -42), Vector2(60, 58)), skin)
	draw_rect(Rect2(c + Vector2(-38, -54), Vector2(76, 22)), hair)
	draw_rect(Rect2(c + Vector2(-40, -40), Vector2(14, 52)), hair)
	draw_rect(Rect2(c + Vector2(26, -40), Vector2(14, 52)), hair)
	draw_rect(Rect2(c + Vector2(-18, -16), Vector2(10, 5)), Color(0.15, 0.08, 0.12))
	draw_rect(Rect2(c + Vector2(8, -16), Vector2(10, 5)), Color(0.15, 0.08, 0.12))
	draw_rect(Rect2(c + Vector2(-8, 2), Vector2(16, 4)), Color(0.8, 0.1, 0.2))
	# A card held up at the edge.
	draw_rect(Rect2(c + Vector2(30, 6), Vector2(24, 34)), Color(0.97, 0.95, 0.9))
	draw_rect(Rect2(c + Vector2(30, 6), Vector2(24, 34)), Color(0.1, 0.05, 0.08), false, 1.5)
	_txt(c + Vector2(30, 32), "Q", 20, Color(0.1, 0.1, 0.12), HORIZONTAL_ALIGNMENT_CENTER, 24)


func _portrait_mags(c: Vector2) -> void:
	var body := Color(0.45, 0.5, 0.6)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-50, 66), c + Vector2(-34, -30), c + Vector2(10, -48), c + Vector2(46, -20), c + Vector2(50, 66)]), body)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-6, -44), c + Vector2(6, -66), c + Vector2(18, -42)]), body)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-50, 66), c + Vector2(-46, 20), c + Vector2(50, 20), c + Vector2(50, 66)]), Color(0.12, 0.12, 0.16))
	for i in 9:
		draw_line(c + Vector2(-44 + i * 11, 24), c + Vector2(-44 + i * 11, 66), Color(0.4, 0.4, 0.5), 1.0)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-4, 20), c + Vector2(4, 20), c + Vector2(6, 60), c + Vector2(-6, 60)]), Color(0.85, 0.1, 0.15))
	draw_colored_polygon(PackedVector2Array([c + Vector2(-30, 0), c + Vector2(44, -4), c + Vector2(40, 12), c + Vector2(-26, 14)]), Color(0.85, 0.85, 0.82))
	for i in 7:
		draw_colored_polygon(PackedVector2Array([c + Vector2(-24 + i * 9, 0), c + Vector2(-20 + i * 9, 9), c + Vector2(-16 + i * 9, 0)]), Color.WHITE)
	draw_circle(c + Vector2(22, -18), 5.0, Color(1, 0.85, 0.3))
	draw_circle(c + Vector2(23, -18), 2.0, Color(0.1, 0.05, 0.05))


func _draw_debug() -> void:
	var lines := [
		"FPS %d   state %s   seed %d" % [Engine.get_frames_per_second(), g.state, g.run_seed],
		"floor %d  floor_t %.1f  run %.1f" % [g.floor_num, g.floor_t, g.run_time],
		"pot %d  x%d  flow %.0f (x%d)  chain %d" % [g.pot, g.pot_mult, g.flow, g.flow_mult(), g.chain],
		"charms %s" % str(g.charms.equipped),
		"debt %d  rules %s  heat %d" % [g._debt(), str(g.rules), g.heat_run],
		"F2: +$500 and a random charm",
	]
	draw_rect(Rect2(440, 420, 420, 22 * lines.size() + 14), Color(0, 0, 0, 0.75))
	for i in lines.size():
		_txt(Vector2(452, 440 + i * 22), lines[i], 14, Color(0.6, 1, 0.6))


## First-run controls coach: one move at a time, with the actual key.
func _draw_coach() -> void:
	if g.coach_i < 0 or g.coach_i >= g.COACH.size() or g.state != "play":
		return
	var c: Array = g.COACH[g.coach_i]
	var keys := ""
	for a in String(c[1]).split(","):
		if a != "":
			keys += ("  +  " if keys != "" else "") + g.settings.key_names(a).split(" / ")[0]
	var r := Rect2(440, 560, 400, 86)
	var pulse := 0.6 + 0.4 * sin(t * 4.0)
	draw_rect(r, Color(0.02, 0.0, 0.05, 0.85))
	draw_rect(r, Color(CYAN, pulse), false, 2.0)
	_txt(r.position + Vector2(16, 24), "TRY IT  %d / %d" % [g.coach_i + 1, g.COACH.size()], 13, CYAN)
	_txt(r.position + Vector2(16, 54), c[0], 26, Color.WHITE)
	if keys != "":
		var kw := f.get_string_size(keys, HORIZONTAL_ALIGNMENT_LEFT, -1, 18).x + 20.0
		var kr := Rect2(r.end.x - kw - 16, r.position.y + 30, kw, 30)
		draw_rect(kr, Color(1, 1, 1, 0.12))
		draw_rect(kr, Color(1, 1, 1, 0.6), false, 1.5)
		_txt(Vector2(kr.position.x, kr.position.y + 22), keys, 18, GOLD, HORIZONTAL_ALIGNMENT_CENTER, kw)
	_txt(r.position + Vector2(16, 76), c[2], 14, DIM)
	if g.coach_ok_t > 0.0:
		_ctxt(r.position.y - 12, "NICE!", 26, Color(GREEN, minf(1.0, g.coach_ok_t * 2.0)))
