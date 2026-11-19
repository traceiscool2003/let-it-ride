extends Node2D
## Breakable props (crate, urn, glass case) and casino tables (blackjack,
## roulette). Origin is bottom-center on the floor.

var kind := "crate"
var t := 0.0
var broken := false
## Vault Doors only: "closed", "open" or "sealed".
var vault_state := "closed"

const Art := preload("res://scripts/art.gd")
const ANIMATED := ["safe", "poker", "holdem", "baccarat", "hilo", "blackjack", "case", "roulette", "bar", "lucky", "vera", "mags", "phone", "cat", "vault", "bets", "jules", "daily", "board", "fence"]


func _ready() -> void:
	z_index = -4
	t = randf() * 10.0


func breakable() -> bool:
	return kind == "crate" or kind == "urn" or kind == "case" or kind == "safe"


func rect() -> Rect2:
	match kind:
		"crate": return Rect2(position.x - 6, position.y - 12, 12, 12)
		"urn": return Rect2(position.x - 5, position.y - 13, 10, 13)
		"case": return Rect2(position.x - 6, position.y - 16, 12, 16)
		"safe": return Rect2(position.x - 7, position.y - 14, 14, 14)
	return Rect2(position.x - 16, position.y - 16, 32, 16)


func debris_color() -> Color:
	match kind:
		"crate": return Color(0.6, 0.4, 0.2)
		"urn": return Color(0.3, 0.45, 0.85)
		"safe": return Color(1, 0.8, 0.3)
	return Color(0.7, 0.9, 1.0)


func _process(delta: float) -> void:
	t += delta
	if ANIMATED.has(kind):
		queue_redraw()


func _draw() -> void:
	var k := Color(0.06, 0.03, 0.06)
	match kind:
		"bar", "lucky":
			Art.lucky_bar(self, t, true)
			_txt_small("LUCKY'S BAR", -46, Color(0.55, 1, 0.6), 60)
		"vera":
			Art.vera(self, t)
			_txt_small("VERA'S TABLE", -47, Color(1, 0.6, 0.75), 60)
		"mags":
			Art.mags_desk(self, t)
			_txt_small("LOANS", -52, Color(1, 0.5, 0.55))
		"phone":
			Art.payphone(self, t, true)
			_txt_small("MARLOW", -44, Color(0.45, 0.9, 1.0))
		"fence":
			_draw_sign_door("THE FENCE", Color(0.45, 1.0, 0.55))
		"daily":
			_draw_sign_door("DAILY DEAL", Color(0.4, 0.9, 1.0))
		"trophies":
			_draw_trophy_case()
		"board":
			_draw_board()
		"tickets":
			_draw_corkboard()
		"cat":
			Art.cat(self, t)
			_txt_small("COMP", -20, Color(0.9, 0.85, 1.0, 0.8))
		"bets":
			_draw_kiosk()
		"vault":
			_draw_vault()
		"jules":
			Art.jules(self, t)
			_txt_small("JULES", -40, Color(0.6, 1.0, 0.7))
		"crate":
			draw_rect(Rect2(-6, -12, 12, 12), k)
			draw_rect(Rect2(-5, -11, 10, 10), Color(0.5, 0.31, 0.16))
			draw_rect(Rect2(-5, -11, 10, 2), Color(0.64, 0.42, 0.22))
			draw_line(Vector2(-5, -1), Vector2(5, -11), Color(0.38, 0.22, 0.1), 1.5)
			draw_rect(Rect2(-1.5, -7.5, 3, 3), Color(1, 0.8, 0.3))
		"urn":
			var pts := PackedVector2Array([Vector2(-2, -13), Vector2(2, -13), Vector2(2, -11), Vector2(5, -7), Vector2(4, -2), Vector2(2, 0), Vector2(-2, 0), Vector2(-4, -2), Vector2(-5, -7), Vector2(-2, -11)])
			draw_colored_polygon(pts, Color(0.2, 0.32, 0.7))
			draw_polyline(pts + PackedVector2Array([pts[0]]), k, 1.0)
			draw_rect(Rect2(-4.5, -7, 9, 2), Color(0.95, 0.75, 0.3))
			draw_rect(Rect2(-3, -10, 1, 6), Color(0.5, 0.65, 1, 0.6))
		"case":
			draw_rect(Rect2(-6, -5, 12, 5), Color(0.18, 0.08, 0.12))
			draw_rect(Rect2(-6, -5, 12, 1), Color(0.85, 0.65, 0.25))
			var shine := 0.5 + 0.5 * sin(t * 3.0)
			draw_circle(Vector2(0, -10), 3.0, Color(1, 0.8, 0.25))
			draw_circle(Vector2(0, -10), 1.6, Color(0.75, 0.55, 0.15))
			draw_rect(Rect2(-5, -16, 10, 11), Color(0.6, 0.9, 1, 0.22))
			draw_rect(Rect2(-5, -16, 10, 11), Color(0.8, 0.95, 1, 0.6), false, 1.0)
			draw_line(Vector2(-3, -7), Vector2(1, -15), Color(1, 1, 1, 0.3 + 0.4 * shine), 1.0)
		"safe":
			var glint := 0.5 + 0.5 * sin(t * 3.0)
			draw_circle(Vector2(0, -7), 10.0, Color(1, 0.8, 0.3, 0.08 + 0.06 * glint))
			draw_rect(Rect2(-7, -14, 14, 14), k)
			draw_rect(Rect2(-6, -13, 12, 12), Color(0.32, 0.36, 0.42))
			draw_rect(Rect2(-6, -13, 12, 2), Color(0.5, 0.55, 0.62))
			draw_rect(Rect2(-5, -11, 10, 9), Color(0.25, 0.28, 0.33), false, 1.0)
			draw_circle(Vector2(0, -6.5), 2.6, Color(0.85, 0.68, 0.25))
			draw_line(Vector2(0, -6.5), Vector2(0, -6.5) + Vector2.from_angle(t * 2.0) * 2.0, k, 0.8)
			draw_rect(Rect2(4, -8, 1, 3), Color(0.8, 0.8, 0.85))
			_txt_small("STASH", -18, Color(1, 0.85, 0.35, 0.6 + 0.4 * glint))
		"blackjack":
			Art.dealer(self, t, 0)
			_felt_table(Color(0.08, 0.42, 0.25), "21")
			for i in 3:
				draw_rect(Rect2(-9 + i * 6, -17, 4, 5), Color(0.95, 0.95, 0.9))
				draw_rect(Rect2(-8 + i * 6, -16, 1, 1), Color(0.8, 0.1, 0.15))
		"holdem":
			Art.dealer(self, t, 1)
			_felt_table(Color(0.06, 0.36, 0.22), "HOLD'EM")
			for i in 5:
				var up := i < 3 or int(t * 0.5) % 2 == 0
				draw_rect(Rect2(-11 + i * 4.6, -17, 3.6, 4.6), Color(0.95, 0.95, 0.9) if up else Color(0.6, 0.08, 0.15))
			for i in 3:
				draw_rect(Rect2(8, -16 - i * 1.4, 4, 1.2), [Color(0.85, 0.12, 0.18), Color(0.15, 0.4, 0.9), Color(0.95, 0.75, 0.2)][i])
		"baccarat":
			Art.dealer(self, t, 2)
			_felt_table(Color(0.35, 0.06, 0.1), "BACCARAT")
			draw_rect(Rect2(-12, -17, 8, 4), Color(0.2, 0.35, 0.8, 0.8))
			draw_rect(Rect2(4, -17, 8, 4), Color(0.8, 0.2, 0.25, 0.8))
		"hilo":
			Art.dealer(self, t, 3)
			_felt_table(Color(0.1, 0.25, 0.4), "HI-LO")
			var cardy := -21.0 - absf(sin(t * 2.0)) * 2.0
			draw_rect(Rect2(-3, cardy, 6, 8), Color(0.97, 0.95, 0.9))
			draw_string(ThemeDB.fallback_font, Vector2(-3, cardy + 6.5), "?", HORIZONTAL_ALIGNMENT_CENTER, 6, 6, Color(0.8, 0.1, 0.15))
			draw_colored_polygon(PackedVector2Array([Vector2(-9, -19), Vector2(-6, -23), Vector2(-3, -19)]), Color(0.5, 1, 0.5))
			draw_colored_polygon(PackedVector2Array([Vector2(3, -23), Vector2(9, -23), Vector2(6, -19)]), Color(1, 0.45, 0.4))
		"poker":
			_video_poker()
		"roulette":
			Art.dealer(self, t, 4)
			_felt_table(Color(0.08, 0.36, 0.22), "ROULETTE")
			var c := Vector2(0, -17)
			draw_circle(c, 6.0, Color(0.35, 0.2, 0.1))
			for i in 12:
				var a := t * 2.0 + i * TAU / 12.0
				draw_line(c, c + Vector2.from_angle(a) * 5.0, Color(0.85, 0.1, 0.15) if i % 2 == 0 else Color(0.05, 0.05, 0.05), 2.0)
			draw_circle(c, 1.5, Color(0.9, 0.75, 0.3))


## A casino table with a felt top, brass rail, carved legs and a lit sign.
func _felt_table(felt: Color, sign: String) -> void:
	var k := Color(0.06, 0.03, 0.06)
	draw_set_transform(Vector2(0, 0.5), 0.0, Vector2(1.0, 0.25))
	draw_circle(Vector2.ZERO, 20.0, Color(0, 0, 0, 0.35))
	draw_set_transform(Vector2.ZERO)
	for lx in [-13.0, 11.0]:
		draw_rect(Rect2(lx - 0.5, -12, 3, 12), k)
		draw_rect(Rect2(lx, -12, 2, 12), Color(0.3, 0.16, 0.08))
		draw_rect(Rect2(lx - 1, -2, 4, 2), Color(0.75, 0.55, 0.2))
	draw_rect(Rect2(-18, -15.5, 36, 5), k)
	draw_rect(Rect2(-17, -15, 34, 3), felt)
	draw_rect(Rect2(-17, -15, 34, 1), felt.lightened(0.25))
	draw_rect(Rect2(-18, -12, 36, 2), Color(0.45, 0.26, 0.1))
	draw_rect(Rect2(-18, -12, 36, 0.8), Color(0.9, 0.7, 0.3))
	var font := ThemeDB.fallback_font
	var w := font.get_string_size(sign, HORIZONTAL_ALIGNMENT_LEFT, -1, 6).x + 6.0
	var blink := 0.8 + 0.2 * sin(t * 3.0)
	draw_rect(Rect2(-w * 0.5, -45, w, 8), Color(0.08, 0.02, 0.05, 0.9))
	draw_rect(Rect2(-w * 0.5, -45, w, 8), Color(1, 0.8, 0.3, 0.8 * blink), false, 0.6)
	draw_string(font, Vector2(-w * 0.5, -38.8), sign, HORIZONTAL_ALIGNMENT_CENTER, w, 6, Color(1, 0.9, 0.6, blink))


## A Jacks-or-Better video poker cabinet.
func _video_poker() -> void:
	var k := Color(0.06, 0.03, 0.06)
	draw_rect(Rect2(-9, -30, 18, 30), k)
	draw_rect(Rect2(-8, -29, 16, 28), Color(0.12, 0.14, 0.4))
	draw_rect(Rect2(-8, -29, 16, 4), Color(1, 0.8, 0.3))
	draw_string(ThemeDB.fallback_font, Vector2(-8, -25.6), "POKER", HORIZONTAL_ALIGNMENT_CENTER, 16, 4, Color(0.2, 0.05, 0.1))
	draw_rect(Rect2(-7, -23, 14, 9), Color(0.03, 0.05, 0.2))
	for i in 5:
		var up := int(t * 1.5 + i) % 7 != 0
		draw_rect(Rect2(-6.5 + i * 2.7, -21, 2.2, 3.2), Color(0.97, 0.95, 0.9) if up else Color(0.6, 0.08, 0.15))
	draw_string(ThemeDB.fallback_font, Vector2(-7, -15.2), "JACKS+", HORIZONTAL_ALIGNMENT_CENTER, 14, 3, Color(1, 0.9, 0.4))
	draw_rect(Rect2(-7, -12, 14, 3), Color(0.25, 0.25, 0.3))
	for i in 5:
		draw_rect(Rect2(-6.5 + i * 2.7, -11.5, 2.0, 2.0), Color(1, 0.85, 0.3) if int(t * 4.0) % 5 == i else Color(0.6, 0.55, 0.4))
	draw_rect(Rect2(-8, -8, 16, 8), Color(0.08, 0.08, 0.2))
	var glow := 0.5 + 0.5 * sin(t * 2.0)
	draw_rect(Rect2(-9, -31, 18, 1), Color(0.5, 0.8, 1.0, glow))


func _table(felt: Color) -> void:
	var k := Color(0.06, 0.03, 0.06)
	draw_rect(Rect2(-14, -12, 4, 12), Color(0.25, 0.14, 0.08))
	draw_rect(Rect2(10, -12, 4, 12), Color(0.25, 0.14, 0.08))
	draw_rect(Rect2(-17, -15, 34, 4), k)
	draw_rect(Rect2(-16, -15, 32, 3), felt)
	draw_rect(Rect2(-17, -12, 34, 2), Color(0.45, 0.28, 0.12))


func _draw_bar_npc() -> void:
	# Lucky's counter.
	draw_rect(Rect2(-18, -13, 36, 13), Color(0.3, 0.16, 0.08))
	draw_rect(Rect2(-19, -15, 38, 3), Color(0.55, 0.35, 0.15))
	draw_rect(Rect2(-18, -10, 36, 1), Color(0.85, 0.65, 0.25))
	for i in 4:
		var bx := -14.0 + i * 9.0
		draw_rect(Rect2(bx, -26, 3, 8), [Color(0.3, 0.7, 0.4), Color(0.7, 0.3, 0.2), Color(0.9, 0.8, 0.3), Color(0.4, 0.5, 0.9)][i])
		draw_rect(Rect2(bx + 1, -29, 1, 3), Color(0.2, 0.2, 0.2))
	# Lucky: green visor, white shirt, red vest.
	var bob := sin(t * 2.0) * 0.5
	draw_rect(Rect2(4, -27 + bob, 10, 12), Color(0.06, 0.03, 0.06))
	draw_rect(Rect2(5, -26 + bob, 8, 11), Color(0.95, 0.95, 0.92))
	draw_rect(Rect2(5, -22 + bob, 3, 7), Color(0.75, 0.1, 0.15))
	draw_rect(Rect2(10, -22 + bob, 3, 7), Color(0.75, 0.1, 0.15))
	draw_rect(Rect2(5, -35 + bob, 8, 8), Color(0.88, 0.7, 0.55))
	draw_rect(Rect2(4, -36 + bob, 10, 3), Color(0.2, 0.7, 0.35))
	draw_rect(Rect2(11, -32 + bob, 2, 1), Color(0.1, 0.05, 0.05))
	draw_rect(Rect2(7, -29 + bob, 4, 1), Color(0.5, 0.25, 0.2))


# ---------------------------------------------------------------- new NPCs and objects

func _txt_small(s: String, y: float, col: Color, w := 48.0, sz := 6) -> void:
	draw_string(ThemeDB.fallback_font, Vector2(-w * 0.5, y), s, HORIZONTAL_ALIGNMENT_CENTER, w, sz, col)


func _draw_vera() -> void:
	# Vera Vex behind a dealer's table: black bob, red dress, fanned cards.
	var bob := sin(t * 1.6) * 0.5
	var skin := Color(0.92, 0.76, 0.66)
	draw_rect(Rect2(-6, -26 + bob, 12, 13), Color(0.06, 0.03, 0.06))
	draw_rect(Rect2(-5, -25 + bob, 10, 12), Color(0.75, 0.08, 0.16))
	draw_rect(Rect2(-4, -34 + bob, 8, 8), skin)
	draw_rect(Rect2(-5, -36 + bob, 10, 4), Color(0.08, 0.05, 0.08))
	draw_rect(Rect2(-6, -34 + bob, 2, 7), Color(0.08, 0.05, 0.08))
	draw_rect(Rect2(4, -34 + bob, 2, 7), Color(0.08, 0.05, 0.08))
	draw_rect(Rect2(-2, -30 + bob, 1, 1), Color(0.1, 0.05, 0.05))
	draw_rect(Rect2(1, -30 + bob, 1, 1), Color(0.1, 0.05, 0.05))
	draw_rect(Rect2(-1, -28 + bob, 3, 1), Color(0.8, 0.1, 0.2))
	_table(Color(0.08, 0.42, 0.25))
	for i in 4:
		var a := -0.6 + i * 0.4 + sin(t * 2.0) * 0.05
		draw_set_transform(Vector2(0, -16), a, Vector2.ONE)
		draw_rect(Rect2(-2, -9, 4, 6), Color(0.97, 0.95, 0.9))
		draw_rect(Rect2(-1, -8, 1, 1), Color(0.8, 0.1, 0.15) if i % 2 == 0 else Color(0.1, 0.1, 0.12))
		draw_set_transform(Vector2.ZERO)
	_txt_small("VERA'S TABLE", -40, Color(1, 0.6, 0.75), 60)


func _draw_mags_desk() -> void:
	# Mags behind a loan desk with a stack of Markers.
	var bob := sin(t * 2.2) * 0.7
	var body := Color(0.45, 0.5, 0.6)
	draw_colored_polygon(PackedVector2Array([Vector2(-7, -16 + bob), Vector2(-3, -36 + bob), Vector2(5, -34 + bob), Vector2(8, -16 + bob)]), body)
	draw_colored_polygon(PackedVector2Array([Vector2(-1, -35 + bob), Vector2(2, -43 + bob), Vector2(4, -34 + bob)]), body)
	draw_rect(Rect2(-7, -24 + bob, 15, 9), Color(0.12, 0.12, 0.16))
	draw_rect(Rect2(0, -24 + bob, 2, 6), Color(0.85, 0.1, 0.15))
	draw_circle(Vector2(3, -30 + bob), 1.2, Color(1, 0.85, 0.3))
	for i in 3:
		draw_colored_polygon(PackedVector2Array([Vector2(1 + i * 2, -27 + bob), Vector2(2 + i * 2, -25 + bob), Vector2(3 + i * 2, -27 + bob)]), Color.WHITE)
	draw_rect(Rect2(-18, -14, 36, 14), Color(0.28, 0.16, 0.1))
	draw_rect(Rect2(-19, -16, 38, 3), Color(0.5, 0.32, 0.14))
	for i in 3:
		draw_rect(Rect2(-14 + i * 2, -19 - i, 9, 3), Color(0.95, 0.92, 0.8))
	_txt_small("LOANS", -48, Color(1, 0.45, 0.5))


func _draw_phone() -> void:
	draw_rect(Rect2(-6, -34, 12, 22), Color(0.06, 0.03, 0.06))
	draw_rect(Rect2(-5, -33, 10, 20), Color(0.3, 0.32, 0.38))
	draw_rect(Rect2(-4, -31, 8, 4), Color(0.6, 0.9, 1.0, 0.5 + 0.3 * sin(t * 4.0)))
	for y in 3:
		for x in 3:
			draw_rect(Rect2(-3.5 + x * 2.5, -25 + y * 2.5, 1.5, 1.5), Color(0.8, 0.8, 0.85))
	var ring := sin(t * 30.0) * (1.0 if int(t * 2.0) % 3 == 0 else 0.0)
	draw_rect(Rect2(6 + ring, -32, 3, 12), Color(0.15, 0.15, 0.18))
	draw_line(Vector2(7, -20), Vector2(7, -10), Color(0.1, 0.1, 0.1), 1.0)
	_txt_small("MARLOW", -38, Color(0.45, 0.9, 1.0))


func _draw_sign_door(label: String, col: Color) -> void:
	draw_rect(Rect2(-11, -32, 22, 32), Color(0.45, 0.42, 0.5))
	draw_rect(Rect2(-8, -29, 16, 29), Color(0.05, 0.02, 0.06))
	draw_rect(Rect2(-8, -29, 16, 29), Color(col, 0.12 + 0.05 * sin(t * 3.0)))
	draw_circle(Vector2(5, -14), 1.2, Color(0.9, 0.75, 0.3))
	var flick := 0.4 if int(t * 7.0) % 23 == 0 else 1.0
	draw_rect(Rect2(-24, -42, 48, 9), Color(col, 0.12 * flick))
	draw_rect(Rect2(-24, -42, 48, 9), Color(col, 0.8 * flick), false, 1.0)
	_txt_small(label, -35, Color(col.lightened(0.5), flick))


func _draw_trophy_case() -> void:
	draw_rect(Rect2(-9, -6, 18, 6), Color(0.18, 0.08, 0.12))
	draw_rect(Rect2(-8, -26, 16, 20), Color(0.6, 0.9, 1, 0.18))
	draw_rect(Rect2(-8, -26, 16, 20), Color(0.8, 0.95, 1, 0.6), false, 1.0)
	draw_colored_polygon(PackedVector2Array([Vector2(-4, -22), Vector2(4, -22), Vector2(2, -15), Vector2(-2, -15)]), Color(1, 0.8, 0.25))
	draw_rect(Rect2(-1, -15, 2, 4), Color(0.85, 0.65, 0.2))
	draw_rect(Rect2(-3, -11, 6, 2), Color(0.85, 0.65, 0.2))
	_txt_small("TROPHIES", -30, Color(0.45, 0.9, 1.0))


func _draw_board() -> void:
	draw_rect(Rect2(-2, -10, 4, 10), Color(0.3, 0.18, 0.1))
	draw_rect(Rect2(-17, -36, 34, 26), Color(0.4, 0.25, 0.12))
	draw_rect(Rect2(-15, -34, 30, 22), Color(0.1, 0.16, 0.12))
	for i in 4:
		draw_rect(Rect2(-12, -30 + i * 5, 14 + (i * 7) % 10, 1), Color(0.85, 0.9, 0.85, 0.7))
		draw_rect(Rect2(8, -30 + i * 5, 3, 1), Color(1, 0.35, 0.35, 0.8))
	_txt_small("TABLE LIMITS", -40, Color(1, 0.4, 0.4), 60)


func _draw_corkboard() -> void:
	draw_rect(Rect2(-17, -38, 34, 26), Color(0.35, 0.2, 0.1))
	draw_rect(Rect2(-15, -36, 30, 22), Color(0.62, 0.45, 0.28))
	for i in 5:
		var p := Vector2(-12 + (i * 7) % 24, -33 + (i * 5) % 14)
		draw_rect(Rect2(p, Vector2(6, 4)), Color(0.95, 0.93, 0.85))
		draw_circle(p + Vector2(3, 0), 0.9, Color(0.85, 0.15, 0.2))
	_txt_small("LOSING TICKETS", -42, Color(0.95, 0.9, 0.75), 64)


func _draw_cat() -> void:
	# Comp, the Lobby cat.
	var k := Color(0.08, 0.06, 0.1)
	var tail := sin(t * 2.5) * 3.0
	draw_line(Vector2(5, -2), Vector2(10, -6 + tail), k, 2.0)
	draw_line(Vector2(10, -6 + tail), Vector2(11, -11 + tail), k, 2.0)
	draw_colored_polygon(PackedVector2Array([Vector2(-5, 0), Vector2(6, 0), Vector2(5, -7), Vector2(-3, -8)]), k)
	draw_circle(Vector2(-3, -10), 4.0, k)
	draw_colored_polygon(PackedVector2Array([Vector2(-7, -12), Vector2(-6, -16), Vector2(-4, -13)]), k)
	draw_colored_polygon(PackedVector2Array([Vector2(-2, -13), Vector2(0, -16), Vector2(0, -12)]), k)
	var blink := int(t * 1.3) % 6 == 0
	if not blink:
		draw_rect(Rect2(-5, -11, 1, 1), Color(1, 0.85, 0.3))
		draw_rect(Rect2(-2, -11, 1, 1), Color(1, 0.85, 0.3))
	draw_rect(Rect2(-5, -6, 4, 1), Color(0.85, 0.1, 0.15))
	_txt_small("COMP", -20, Color(0.9, 0.85, 1.0, 0.8))


func _draw_kiosk() -> void:
	draw_rect(Rect2(-7, -24, 14, 24), Color(0.06, 0.03, 0.06))
	draw_rect(Rect2(-6, -23, 12, 22), Color(0.2, 0.25, 0.45))
	draw_rect(Rect2(-5, -21, 10, 7), Color(0.4, 0.9, 1.0, 0.55 + 0.25 * sin(t * 5.0)))
	draw_rect(Rect2(-4, -11, 8, 2), Color(0.95, 0.93, 0.85))
	draw_rect(Rect2(-4, -7, 8, 1), Color(0.95, 0.93, 0.85))
	_txt_small("SIDE BETS", -28, Color(0.45, 0.9, 1.0))


func _draw_vault() -> void:
	var c := Vector2(0, -16)
	var ring := Color(0.6, 0.6, 0.66)
	match vault_state:
		"open":
			draw_circle(c, 15.0, Color(0.05, 0.02, 0.05))
			draw_circle(c, 13.0, Color(1, 0.8, 0.3, 0.25 + 0.15 * sin(t * 6.0)))
			draw_set_transform(c + Vector2(13, 0), 0.0, Vector2(0.35, 1.0))
			draw_circle(Vector2.ZERO, 14.0, ring)
			draw_set_transform(Vector2.ZERO)
			_txt_small("CRACKED", -36, Color(1, 0.85, 0.3))
		"sealed":
			draw_circle(c, 15.0, Color(0.06, 0.03, 0.06))
			draw_circle(c, 14.0, Color(0.3, 0.3, 0.34))
			draw_line(c + Vector2(-9, -9), c + Vector2(9, 9), Color(0.75, 0.15, 0.2), 2.0)
			draw_line(c + Vector2(9, -9), c + Vector2(-9, 9), Color(0.75, 0.15, 0.2), 2.0)
			_txt_small("SEALED", -36, Color(1, 0.4, 0.4))
		_:
			draw_circle(c, 15.0, Color(0.06, 0.03, 0.06))
			draw_circle(c, 14.0, ring)
			draw_circle(c, 10.0, Color(0.42, 0.42, 0.48))
			for i in 6:
				var a := t * 1.5 + i * TAU / 6.0
				draw_line(c, c + Vector2.from_angle(a) * 9.0, Color(0.85, 0.7, 0.3), 1.5)
			draw_circle(c, 3.0, Color(0.85, 0.7, 0.3))
			var glow := 0.5 + 0.5 * sin(t * 8.0)
			draw_arc(c, 17.0, 0, TAU, 24, Color(1, 0.85, 0.3, 0.5 * glow), 1.5)
			_txt_small("VAULT", -36, Color(1, 0.85, 0.3))


func _draw_jules() -> void:
	var bob := sin(t * 1.8) * 0.6
	var hood := Color(0.2, 0.45, 0.3)
	draw_rect(Rect2(-4, -9, 3, 9), Color(0.15, 0.12, 0.18))
	draw_rect(Rect2(1, -9, 3, 9), Color(0.15, 0.12, 0.18))
	draw_rect(Rect2(-5, -20 + bob, 10, 12), hood)
	draw_rect(Rect2(-4, -27 + bob, 8, 8), Color(0.88, 0.7, 0.55))
	draw_rect(Rect2(-5, -29 + bob, 10, 4), hood.lightened(0.15))
	draw_rect(Rect2(-5, -28 + bob, 2, 6), hood.lightened(0.15))
	draw_rect(Rect2(1, -24 + bob, 1, 1), Color(0.1, 0.05, 0.05))
	_txt_small("JULES", -33, Color(0.6, 1.0, 0.7))
