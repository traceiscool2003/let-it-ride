extends RefCounted
## Dialogue portraits for everyone without hand-drawn art: bosses, rivals, vendors' staff, crowd NPCs.
## A face is built from a hash of the speaker's name (skin, hair, hat, glasses, facial hair, outfit),
## so every name looks different and always the same. Bosses use their own colour as the outfit accent.
## Drawn in the same bust frame as Art.npc_portrait (neck near y 2.4, shoulders to y 8).

const K := Color(0.06, 0.03, 0.08)
const SKIN := [Color(0.96, 0.8, 0.68), Color(0.88, 0.68, 0.52), Color(0.74, 0.54, 0.38), Color(0.55, 0.38, 0.26), Color(0.4, 0.27, 0.19), Color(0.82, 0.78, 0.7)]
const HAIR := [Color(0.08, 0.06, 0.06), Color(0.3, 0.17, 0.08), Color(0.62, 0.4, 0.15), Color(0.85, 0.75, 0.5), Color(0.55, 0.55, 0.58), Color(0.7, 0.15, 0.1), Color(0.3, 0.2, 0.5)]
const SKIP := ["", "NARRATOR", "???", "TIP", "SYSTEM", "ALL", "CROWD"]


static func hv(s: String, salt: int) -> float:
	var x: int = (s.hash() ^ (salt * 0x9E3779B1)) & 0xffffffff
	x = ((x ^ (x >> 16)) * 0x45d9f3b) & 0xffffffff
	x = ((x ^ (x >> 16)) * 0x45d9f3b) & 0xffffffff
	x = x ^ (x >> 16)
	return float(x & 0xffff) / 65536.0


static func _ell(c: Vector2, rx: float, ry: float, n := 18) -> PackedVector2Array:
	var p := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		p.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return p


static func _shape(ci: CanvasItem, p: PackedVector2Array, col: Color, w := 0.35) -> void:
	ci.draw_colored_polygon(p, col)
	var l := p.duplicate()
	l.append(p[0])
	ci.draw_polyline(l, K, w)


static func accent_for(who: String) -> Color:
	for d in BossDefsRef.POOL:
		if d["name"] == who:
			return d["col"]
	for d in BossDefsRef.SECRET:
		if d["name"] == who:
			return d["col"]
	return Color.from_hsv(hv(who, 1), 0.55, 0.62)


const BossDefsRef := preload("res://scripts/boss_defs.gd")


static func draw(ci: CanvasItem, center: Vector2, who: String, t: float, sc := 8.0) -> bool:
	if who in SKIP or who.length() < 2:
		return false
	var acc := accent_for(who)
	var skin: Color = SKIN[int(hv(who, 2) * SKIN.size()) % SKIN.size()]
	var hair: Color = HAIR[int(hv(who, 3) * HAIR.size()) % HAIR.size()]
	var hair_style := int(hv(who, 4) * 6.0)      # bald, short, slick, long, mohawk, big
	var hat := int(hv(who, 5) * 7.0)             # 0-3 none, 4 fedora, 5 top hat, 6 cap
	var glasses := int(hv(who, 6) * 4.0)         # 0-1 none, 2 round, 3 shades
	var facial := int(hv(who, 7) * 5.0)          # 0-1 none, 2 stache, 3 goatee, 4 scar
	var outfit := int(hv(who, 8) * 4.0)          # suit, vest, tux, hoodie
	var wide := 0.9 + hv(who, 9) * 0.35
	var bob := sin(t * 1.7 + hv(who, 10) * 6.0) * 0.12
	ci.draw_set_transform_matrix(Transform2D(0.0, Vector2(sc, sc), 0.0, center + Vector2(0, bob * sc)))
	# torso
	var base := acc.darkened(0.25)
	_shape(ci, PackedVector2Array([Vector2(-6.6, 8.4), Vector2(6.6, 8.4), Vector2(5.4, 2.6), Vector2(-5.4, 2.6)]), base)
	match outfit:
		0:   # suit with white shirt and tie
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-2, 2.6), Vector2(2, 2.6), Vector2(0, 7)]), Color(0.95, 0.94, 0.9))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-0.5, 3.2), Vector2(0.5, 3.2), Vector2(0.8, 7.5), Vector2(-0.8, 7.5)]), acc.lightened(0.15))
		1:   # vest with gold buttons
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-2.6, 2.6), Vector2(2.6, 2.6), Vector2(2.4, 8.4), Vector2(-2.4, 8.4)]), Color(0.93, 0.9, 0.82))
			for k in 3:
				ci.draw_circle(Vector2(0, 4.2 + k * 1.4), 0.3, Color(0.95, 0.75, 0.25))
		2:   # tux with bow tie
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-2.2, 2.6), Vector2(2.2, 2.6), Vector2(1.6, 8.4), Vector2(-1.6, 8.4)]), Color(0.96, 0.96, 0.94))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-1.5, 3.1), Vector2(0, 3.7), Vector2(1.5, 3.1), Vector2(1.5, 4.5), Vector2(0, 3.7), Vector2(-1.5, 4.5)]), K)
		3:   # hoodie with strings
			ci.draw_arc(Vector2(0, 2.8), 3.2, 0.1, PI - 0.1, 12, base.lightened(0.15), 1.0)
			ci.draw_line(Vector2(-1.2, 3.6), Vector2(-1.4, 7.6), Color(0.9, 0.9, 0.85, 0.8), 0.3)
			ci.draw_line(Vector2(1.2, 3.6), Vector2(1.4, 7.6), Color(0.9, 0.9, 0.85, 0.8), 0.3)
	ci.draw_rect(Rect2(-1.3, 1.2, 2.6, 1.8), skin.darkened(0.15))
	# hair behind the head
	var hc := Vector2(0, -1.3)
	if hair_style == 3:
		_shape(ci, PackedVector2Array([Vector2(-3.8, -2.5), Vector2(3.8, -2.5), Vector2(4.2, 4.0), Vector2(-4.2, 4.0)]), hair)
	if hair_style == 5:
		_shape(ci, _ell(hc + Vector2(0, -0.6), 4.8 * wide, 4.6), hair)
	# head
	_shape(ci, _ell(hc, 3.3 * wide, 3.7), skin)
	ci.draw_circle(Vector2(-3.3 * wide, -0.6), 0.7, skin.darkened(0.08))
	ci.draw_circle(Vector2(3.3 * wide, -0.6), 0.7, skin.darkened(0.08))
	# hair on top
	match hair_style:
		1:
			_shape(ci, PackedVector2Array([Vector2(-3.4 * wide, -1.6), Vector2(-2.4, -4.6), Vector2(2.4, -4.6), Vector2(3.4 * wide, -1.6), Vector2(2.2, -3.0), Vector2(-2.2, -3.0)]), hair)
		2:
			_shape(ci, PackedVector2Array([Vector2(-3.4 * wide, -1.2), Vector2(-2.8, -4.8), Vector2(3.0, -4.4), Vector2(3.4 * wide, -1.0), Vector2(1.0, -3.2), Vector2(-2.0, -2.8)]), hair)
		3:
			_shape(ci, PackedVector2Array([Vector2(-3.5 * wide, -0.4), Vector2(-2.6, -4.9), Vector2(2.6, -4.9), Vector2(3.5 * wide, -0.4), Vector2(2.4, -2.9), Vector2(-2.4, -2.9)]), hair)
		4:
			_shape(ci, PackedVector2Array([Vector2(-0.9, -3.3), Vector2(-1.4, -6.4), Vector2(0, -5.2), Vector2(1.4, -6.6), Vector2(0.9, -3.3)]), hair)
		5:
			_shape(ci, _ell(hc + Vector2(0, -2.2), 3.6 * wide, 1.7), hair)
	# face
	var blink := fmod(t + hv(who, 11) * 5.0, 4.6) < 0.12
	var ey := -1.3
	var ex := 1.25 * wide
	if glasses == 3:
		_shape(ci, PackedVector2Array([Vector2(-2.9 * wide, ey - 0.7), Vector2(2.9 * wide, ey - 0.7), Vector2(2.7 * wide, ey + 0.8), Vector2(0.4, ey + 0.6), Vector2(-0.4, ey + 0.6), Vector2(-2.7 * wide, ey + 0.8)]), Color(0.05, 0.05, 0.08), 0.2)
		ci.draw_line(Vector2(-2.5 * wide, ey - 0.4), Vector2(-1.2 * wide, ey - 0.5), Color(1, 1, 1, 0.45), 0.25)
	else:
		for s in [-1.0, 1.0]:
			if blink:
				ci.draw_line(Vector2(s * ex - 0.6, ey), Vector2(s * ex + 0.6, ey), K, 0.3)
			else:
				ci.draw_circle(Vector2(s * ex, ey), 0.62, Color(0.97, 0.97, 0.95))
				ci.draw_circle(Vector2(s * ex + 0.1, ey + 0.05), 0.36, acc.lightened(0.2) if hv(who, 12) > 0.5 else K)
				ci.draw_circle(Vector2(s * ex + 0.15, ey), 0.17, K)
			ci.draw_line(Vector2(s * ex - 0.9, ey - 1.1 + (0.3 if s < 0 else 0.0) * (hv(who, 13) - 0.5)), Vector2(s * ex + 0.9, ey - 1.0), hair.darkened(0.2), 0.35)
		if glasses == 2:
			for s in [-1.0, 1.0]:
				ci.draw_arc(Vector2(s * ex, ey), 1.0, 0, TAU, 12, Color(0.85, 0.75, 0.3), 0.25)
			ci.draw_line(Vector2(-0.3, ey), Vector2(0.3, ey), Color(0.85, 0.75, 0.3), 0.25)
	ci.draw_line(Vector2(0, -0.6), Vector2(0.35, 0.6), skin.darkened(0.25), 0.3)
	var talk := 0.5 + 0.5 * sin(t * 11.0)
	var my := 1.55
	match facial:
		2:
			_shape(ci, PackedVector2Array([Vector2(-1.8, 0.9), Vector2(0, 0.7), Vector2(1.8, 0.9), Vector2(1.2, 1.4), Vector2(0, 1.1), Vector2(-1.2, 1.4)]), hair.darkened(0.2), 0.2)
		3:
			_shape(ci, PackedVector2Array([Vector2(-1.0, 1.9), Vector2(1.0, 1.9), Vector2(0.6, 3.1), Vector2(-0.6, 3.1)]), hair.darkened(0.2), 0.2)
		4:
			ci.draw_line(Vector2(1.6, -2.2), Vector2(2.2, 0.8), Color(0.75, 0.25, 0.25), 0.35)
	ci.draw_line(Vector2(-0.9, my), Vector2(0.9, my + 0.05 * talk), K, 0.35)
	# hat
	match hat:
		4:
			_shape(ci, _ell(Vector2(0, -3.7), 5.0, 0.9), acc.darkened(0.45))
			_shape(ci, PackedVector2Array([Vector2(-3.0, -3.6), Vector2(-2.4, -6.4), Vector2(2.4, -6.4), Vector2(3.0, -3.6)]), acc.darkened(0.45))
			ci.draw_line(Vector2(-3.0, -4.2), Vector2(3.0, -4.2), acc.lightened(0.3), 0.5)
		5:
			_shape(ci, _ell(Vector2(0, -4.0), 4.4, 0.8), K.lightened(0.1))
			_shape(ci, PackedVector2Array([Vector2(-2.8, -4.0), Vector2(-2.6, -8.4), Vector2(2.6, -8.4), Vector2(2.8, -4.0)]), K.lightened(0.1))
			ci.draw_line(Vector2(-2.8, -4.6), Vector2(2.8, -4.6), acc, 0.7)
		6:
			_shape(ci, PackedVector2Array([Vector2(-3.4 * wide, -2.6), Vector2(-2.6, -5.2), Vector2(2.6, -5.2), Vector2(3.4 * wide, -2.6), Vector2(5.2, -2.3), Vector2(3.0, -2.0)]), acc.darkened(0.15))
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
	return true
