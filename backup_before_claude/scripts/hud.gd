extends Control
## All screen-space UI: the in-run HUD (pot, lives, flow, minimap, floor
## track, boss bars), dialogue, title menu, runner select, skill tree,
## trophies, pause menu, exit choice and the bust screen.

const Sprites := preload("res://scripts/sprites.gd")

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


func _ready() -> void:
	f = ThemeDB.fallback_font
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = Vector2(1280, 720)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	portraits["ROOK"] = Sprites.bake(Sprites.R_HEAD, Sprites.RUNNER_PAL)
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
	_draw_toasts()


# ---------------------------------------------------------------- in-run HUD

func _draw_play() -> void:
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
	_ctxt(76, "FLOOR %d    %02d:%02d" % [g.floor_num, secs / 60, secs % 60], 18, Color(1, 1, 1, 0.85))

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
	if g.banner_t > 0.0:
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

	if g.floor_num == 1 and g.state == "play" and g.banner_t <= 0.0 and g.run_time < 40.0:
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
	for i in 2:
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
	if portraits.has(who):
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
		"ROOK", "JULES", "DICE":
			name_col = Color(0.75, 0.6, 1.0)
		"MARLOW":
			name_col = CYAN
		"LUCKY":
			name_col = GREEN
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
	_txt(Vector2(0, y + wob), "LET IT RIDE", 112, Color(GOLD, flick), HORIZONTAL_ALIGNMENT_CENTER, 1280.0)
	draw_rect(Rect2(380, y + 16, 520, 3), Color(1, 0.3, 0.6, 0.8 * flick))


func _draw_title() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.03, 0.01, 0.05, 0.78))
	_draw_logo(170)
	_ctxt(222, "Break into The Pit. Rescue Jules. Know when to walk away.", 22, DIM)
	var items: Array = g.title_items()
	for i in items.size():
		var sel: bool = i == g.title_sel
		var y := 310.0 + i * 58.0
		if sel:
			draw_rect(Rect2(440, y - 38, 400, 50), Color(1, 0.8, 0.3, 0.12))
			draw_rect(Rect2(440, y - 38, 400, 50), GOLD, false, 2.0)
		_ctxt(y, items[i], 32 if sel else 26, GOLD if sel else Color.WHITE)
	# Runner preview.
	var ch: Dictionary = g.CHARACTERS[g.char_i]
	var unlocked: bool = g.char_unlocked(g.char_i)
	var pr := Rect2(110, 290, 230, 260)
	_panel(pr, Color(0.75, 0.6, 1.0))
	if portraits.has(ch["name"]):
		var tex: Texture2D = portraits[ch["name"]]
		var ts := tex.get_size() * 12.0
		draw_texture_rect(tex, Rect2(pr.get_center() - ts * 0.5 + Vector2(0, -40), ts), false, Color(1, 1, 1) if unlocked else Color(0, 0, 0, 0.9))
	_txt(Vector2(pr.position.x, pr.position.y + 170), ch["name"] if unlocked else "???", 28, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, pr.size.x)
	draw_multiline_string(f, Vector2(pr.position.x + 14, pr.position.y + 198), ch["desc"] if unlocked else ch["lock"], HORIZONTAL_ALIGNMENT_CENTER, pr.size.x - 28, 15, 4, DIM)
	# Stats.
	var sr := Rect2(940, 290, 230, 260)
	_panel(sr, GREEN)
	var lines := [
		["WALLET", _money(g.wallet), GREEN],
		["BEST RUN", _money(g.best), GOLD],
		["LIFETIME", _money(g.lifetime), Color.WHITE],
		["RUNS", str(g.runs), Color.WHITE],
		["BOSSES", "%d / 3" % mini(3, g.bosses_beaten / g.boss_every), RED],
		["TROPHIES", "%d / %d" % [g.trophies.size(), g.TROPHIES.size()], CYAN],
	]
	for i in lines.size():
		_txt(Vector2(960, 330 + i * 38), lines[i][0], 16, DIM)
		_txt(Vector2(940, 330 + i * 38), lines[i][1], 20, lines[i][2], HORIZONTAL_ALIGNMENT_RIGHT, 214)
	_ctxt(620, "UP / DOWN choose     LEFT / RIGHT change runner     JUMP select", 18, DIM)
	_ctxt(660, "MOVE A/D   JUMP Space   DASH Shift   STRIKE F/J   PARRY Q/K   SLIDE Down", 17, Color(DIM, 0.8))


func _draw_skills() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.03, 0.01, 0.05, 0.92))
	_ctxt(70, "THE FENCE", 52, GOLD)
	_ctxt(104, "Marlow's contact sells talent. Paid in banked cash.", 18, DIM)
	_txt(Vector2(0, 70), "WALLET  " + _money(g.wallet), 26, GREEN, HORIZONTAL_ALIGNMENT_RIGHT, 1250)
	var branch_names := ["BODY", "FISTS", "FORTUNE"]
	var branch_cols := [Color(1, 0.45, 0.45), Color(0.5, 0.85, 1), GOLD]
	for b in 3:
		var cx := 260.0 + b * 380.0
		_txt(Vector2(cx - 150, 160), branch_names[b], 28, branch_cols[b], HORIZONTAL_ALIGNMENT_CENTER, 300)
	var sel_node: Dictionary = g.SKILLS[g.skill_sel]
	for i in g.SKILLS.size():
		var sk: Dictionary = g.SKILLS[i]
		var cx: float = 260.0 + sk["branch"] * 380.0
		var cy: float = 230.0 + sk["tier"] * 100.0
		var owned: bool = g.has_skill(sk["id"])
		var avail: bool = g.skill_available(sk)
		if sk["tier"] > 0:
			draw_line(Vector2(cx, cy - 100 + 32), Vector2(cx, cy - 32), Color(branch_cols[sk["branch"]], 0.8 if owned else 0.2), 4.0)
		var r := Rect2(cx - 150, cy - 32, 300, 64)
		var bg := Color(0.08, 0.05, 0.1)
		if owned:
			bg = Color(branch_cols[sk["branch"]], 0.25)
		draw_rect(r, bg)
		var border: Color = branch_cols[sk["branch"]] if owned else (Color(1, 1, 1, 0.5) if avail else Color(1, 1, 1, 0.12))
		draw_rect(r, border, false, 2.0)
		if i == g.skill_sel:
			draw_rect(r.grow(5), Color(1, 1, 1, 0.8 + 0.2 * sin(t * 8.0)), false, 3.0)
		_txt(Vector2(r.position.x + 14, cy - 6), sk["name"], 20, Color.WHITE if (owned or avail) else Color(1, 1, 1, 0.35))
		_txt(Vector2(r.position.x + 14, cy + 20), "OWNED" if owned else _money(sk["cost"]), 16, GREEN if owned else (GOLD if g.wallet >= sk["cost"] else RED))
	var dr := Rect2(240, 640, 800, 60)
	_panel(dr)
	_txt(Vector2(240, 668), sel_node["name"] + "  -  " + sel_node["desc"], 20, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, 800)
	_txt(Vector2(240, 692), g.skill_msg if g.skill_msg != "" else "ARROWS move     JUMP buy     ESC back", 16, DIM, HORIZONTAL_ALIGNMENT_CENTER, 800)


func _draw_trophies() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.03, 0.01, 0.05, 0.92))
	_ctxt(70, "TROPHY CASE", 52, CYAN)
	_ctxt(104, "%d of %d earned" % [g.trophies.size(), g.TROPHIES.size()], 18, DIM)
	for i in g.TROPHIES.size():
		var tr: Dictionary = g.TROPHIES[i]
		var col: int = i % 2
		var row: int = i / 2
		var r := Rect2(120 + col * 530, 140 + row * 72, 510, 62)
		var got: bool = g.trophies.has(tr["id"])
		draw_rect(r, Color(0.3, 0.6, 0.8, 0.2) if got else Color(0.08, 0.05, 0.1))
		draw_rect(r, CYAN if got else Color(1, 1, 1, 0.1), false, 2.0)
		_diamond(r.position + Vector2(32, 31), 16.0, GOLD if got else Color(0.2, 0.15, 0.25))
		_txt(r.position + Vector2(62, 27), tr["name"] if got or not tr.get("secret", false) else "???", 20, Color.WHITE if got else DIM)
		_txt(r.position + Vector2(62, 50), tr["desc"] if got or not tr.get("secret", false) else "A secret.", 15, DIM)
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
	_ctxt(620, "Kills %d    Parries %d    Smashed %d    Best chain %d" % [s.get("kills", 0), s.get("parries", 0), s.get("smashed", 0), g.best_chain], 18, DIM)


func _draw_choice() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.0, 0.04, 0.84))
	_ctxt(110, "FLOOR %d CLEARED" % g.floor_num, 40, GOLD)
	_ctxt(176, "POT  %s   x%d" % [_money(g.pot), g.pot_mult], 52, Color.WHITE)
	var boxes := [Rect2(170, 230, 440, 330), Rect2(670, 230, 440, 330)]
	for i in 2:
		var r: Rect2 = boxes[i]
		var sel: bool = g.choice_idx == i
		draw_rect(r, Color(1, 1, 1, 0.07) if sel else Color(0, 0, 0, 0.4))
		draw_rect(r, GOLD if sel else Color(0.4, 0.35, 0.45), false, 4.0 if sel else 2.0)
	var l: Rect2 = boxes[0]
	_txt(Vector2(l.position.x, 300), "CASH OUT", 46, GREEN, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 360), "Bank " + _money(g.pot * g.pot_mult), 30, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 410), "+1 life", 22, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 440), "Multiplier resets to x1", 22, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 470), "All House Rules cleared", 22, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	_txt(Vector2(l.position.x, 535), "[1]", 20, DIM, HORIZONTAL_ALIGNMENT_CENTER, l.size.x)
	var r2: Rect2 = boxes[1]
	_txt(Vector2(r2.position.x, 300), "LET IT RIDE", 46, RED, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
	_txt(Vector2(r2.position.x, 360), "Pot multiplier x%d" % (g.pot_mult * 2), 30, Color.WHITE, HORIZONTAL_ALIGNMENT_CENTER, r2.size.x)
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
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.16, 0.0, 0.03, minf(0.85, g.dead_t * 1.4)))
	if g.dead_t < 0.4:
		return
	_ctxt(150, "BUSTED", 110, RED)
	_ctxt(195, g.death_reason, 24, DIM)
	_ctxt(232, g.death_quip, 20, Color(CYAN, 0.85))
	var r := Rect2(340, 260, 600, 300)
	_panel(r, RED)
	_txt(Vector2(370, 300), "Lost at the table", 20, DIM)
	_txt(Vector2(340, 300), _money(g.lost_pot), 22, Color(1, 0.55, 0.55), HORIZONTAL_ALIGNMENT_RIGHT, 570)
	if g.kept_pot > 0:
		_txt(Vector2(370, 330), "Insurance paid out", 20, DIM)
		_txt(Vector2(340, 330), "+" + _money(g.kept_pot), 22, GREEN, HORIZONTAL_ALIGNMENT_RIGHT, 570)
	_txt(Vector2(370, 370), "Bankroll this run", 26, Color.WHITE)
	_txt(Vector2(340, 370), _money(g.banked), 32, GREEN, HORIZONTAL_ALIGNMENT_RIGHT, 570)
	var s: Dictionary = g.stats
	var secs := int(g.run_time)
	var rows := [
		["Floor reached", str(g.floor_num)], ["Time", "%02d:%02d" % [secs / 60, secs % 60]],
		["Kills", str(s.get("kills", 0))], ["Parries", str(s.get("parries", 0))],
		["Smashed", str(s.get("smashed", 0))], ["Best chain", str(g.best_chain)],
	]
	for i in rows.size():
		var cx := 370.0 + (i % 2) * 290.0
		var cy := 420.0 + (i / 2) * 32.0
		_txt(Vector2(cx, cy), rows[i][0], 17, DIM)
		_txt(Vector2(cx - 30, cy), rows[i][1], 19, Color.WHITE, HORIZONTAL_ALIGNMENT_RIGHT, 280)
	_ctxt(530, ("NEW BEST RUN!" if g.new_best else "Best  " + _money(g.best)) + "     Wallet  " + _money(g.wallet), 22, GOLD)
	if g.dead_t > 1.2 and _blink():
		_ctxt(620, "JUMP  run it back        ESC  title / The Fence", 26, Color.WHITE)


func _draw_toasts() -> void:
	for i in g.toasts.size():
		var tst: Dictionary = g.toasts[i]
		var life: float = tst["t"]
		var slide := clampf((4.0 - life) * 4.0, 0.0, 1.0) * clampf(life * 3.0, 0.0, 1.0)
		var r := Rect2(1280 - 380 * slide, 150 + i * 80, 360, 68)
		draw_rect(r, Color(0.05, 0.03, 0.08, 0.95))
		draw_rect(r, CYAN, false, 2.0)
		_diamond(r.position + Vector2(34, 34), 18.0, GOLD)
		_txt(r.position + Vector2(64, 28), tst["text"], 15, CYAN)
		_txt(r.position + Vector2(64, 52), tst["sub"], 20, Color.WHITE)
