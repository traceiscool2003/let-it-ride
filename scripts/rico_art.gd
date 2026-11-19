extends RefCounted
## Rico's hand-drawn body for the rig. The arc: he starts as a bum who lives on
## his friend's couch, and dresses cooler the higher he climbs.
##   tier 0  COUCH SURFER    stained tank top, grey sweatpants, socks + slides, bedhead, stubble
##   tier 1  HAND-ME-DOWN    faded hoodie, jeans, beat-up sneakers, still unshaven
##   tier 2  THRIFT BOMBER   bomber jacket over a tee, jeans, clean sneakers, tousled hair
##   tier 3  LEATHER & LUCK  black leather jacket, red tee, dark jeans, boots, a styled quiff
##   tier 4  HIGH ROLLER     sharp suit, open collar, gold chain, slicked-back hair, clean shave
## Drawn with smooth curves (Catmull-Rom), thin anti-aliased outlines and soft
## two-tone shading, not chunky blocks. Posture straightens as he gets richer.
## Rig space: facing +x, up is -y, ~1 unit = 1 px at 1x zoom.

const Wardrobe := preload("res://scripts/wardrobe.gd")

const OUTLINE := Color(0.08, 0.05, 0.07)
const SKIN := Color(0.93, 0.74, 0.6)
const SKIN_SH := Color(0.78, 0.55, 0.44)
const SKIN_HI := Color(1.0, 0.86, 0.74)
const STUBBLE := Color(0.42, 0.32, 0.28)
const HAIR := Color(0.18, 0.12, 0.09)
const HAIR_HI := Color(0.36, 0.25, 0.18)
const OW := 0.45   # outline width: thin and clean

## Per tier: top (shirt/jacket), its trim, under-shirt, pants, shoes, shoe accent, shoe style.
const TIERS := [
	{"top": Color(0.88, 0.86, 0.8), "trim": Color(0.75, 0.66, 0.35), "under": Color(0.88, 0.86, 0.8), "pants": Color(0.52, 0.52, 0.55), "shoe": Color(0.38, 0.27, 0.2), "shoe2": Color(0.82, 0.82, 0.8), "style": "slides"},
	{"top": Color(0.42, 0.36, 0.48), "trim": Color(0.62, 0.56, 0.68), "under": Color(0.42, 0.36, 0.48), "pants": Color(0.26, 0.34, 0.5), "shoe": Color(0.72, 0.7, 0.66), "shoe2": Color(0.45, 0.2, 0.2), "style": "sneaker"},
	{"top": Color(0.28, 0.38, 0.26), "trim": Color(0.85, 0.55, 0.2), "under": Color(0.92, 0.9, 0.86), "pants": Color(0.2, 0.26, 0.4), "shoe": Color(0.95, 0.95, 0.93), "shoe2": Color(0.85, 0.15, 0.2), "style": "sneaker"},
	{"top": Color(0.09, 0.08, 0.1), "trim": Color(0.55, 0.55, 0.58), "under": Color(0.78, 0.12, 0.16), "pants": Color(0.11, 0.12, 0.18), "shoe": Color(0.22, 0.14, 0.1), "shoe2": Color(0.12, 0.08, 0.06), "style": "boot"},
	{"top": Color(0.14, 0.13, 0.17), "trim": Color(1.0, 0.82, 0.35), "under": Color(0.96, 0.95, 0.93), "pants": Color(0.12, 0.11, 0.15), "shoe": Color(0.08, 0.06, 0.06), "shoe2": Color(0.5, 0.35, 0.2), "style": "dress"},
]


static func look(worn: Array, floor_num: int) -> Dictionary:
	var tier_i := Wardrobe.tier_for(floor_num)
	var c: Dictionary = TIERS[tier_i]
	var lk := {"tier": tier_i, "jacket": c["top"], "jacket2": c["trim"], "under": c["under"], "legs": c["pants"],
		"shoe": c["shoe"], "shoe2": c["shoe2"], "shoe_style": c["style"], "glove": Color(0, 0, 0, 0), "torso_item": "", "mood": ""}
	var tid := Wardrobe.item_in_slot(worn, "torso")
	if tid != "":
		var it: Dictionary = Wardrobe.info(tid)
		lk["jacket"] = it["col"]
		lk["jacket2"] = it["col2"]
		lk["torso_item"] = tid
	var lid := Wardrobe.item_in_slot(worn, "legs")
	if lid != "":
		lk["legs"] = Wardrobe.info(lid)["col"]
		lk["legs_item"] = lid
	var fid := Wardrobe.item_in_slot(worn, "feet")
	if fid != "" and fid != "thrift_sneakers":
		lk["shoe"] = Wardrobe.info(fid)["col"]
		lk["shoe2"] = Wardrobe.info(fid)["col2"]
		lk["shoe_style"] = {"wingtips": "dress", "steel_toes": "boot", "slick_loafers": "dress"}.get(fid, "sneaker")
	var hid := Wardrobe.item_in_slot(worn, "hands")
	if hid != "":
		lk["glove"] = Wardrobe.info(hid)["col"]
	return lk


## Push proportions and outfit colours into the rig so the limbs match.
static func dress_rig(rig, lk: Dictionary) -> void:
	var tier: int = lk["tier"]
	rig.s["smooth"] = true
	rig.s["thigh"] = 5.8
	rig.s["shin"] = 5.8
	rig.s["torso_len"] = 7.2
	rig.s["shoulder_drop"] = 1.8
	rig.s["upper"] = 4.3
	rig.s["fore"] = 4.1
	rig.s["leg_w"] = 2.5 if tier != 0 else 2.8     # baggy sweatpants
	rig.s["arm_w"] = 1.9 if tier != 0 else 1.6      # bare skinny arms in the tank top
	rig.s["head_r"] = 4.4
	var sl: float = [1.0, 0.7, 0.4, 0.15, 0.0][tier]
	rig.s["acc_off"] = Vector2(sl * 0.9, sl * 0.8)
	rig.s["outline_w"] = OW
	rig.s["arm"] = SKIN if (tier == 0 and lk["torso_item"] == "") else lk["jacket"]
	rig.s["leg"] = lk["legs"]
	rig.s["shoe"] = lk["shoe"]
	rig.s["shoe2"] = lk["shoe2"]
	rig.s["shoe_style"] = lk["shoe_style"]
	rig.s["outline"] = OUTLINE
	var g: Color = lk["glove"]
	rig.s["skin"] = g if g.a > 0.0 else SKIN
	rig.s["cuff"] = lk["jacket2"] if tier >= 1 else SKIN


# ---------------------------------------------------------------- helpers

static func smooth(pts: PackedVector2Array, closed := true, steps := 5) -> PackedVector2Array:
	var out := PackedVector2Array()
	var n := pts.size()
	var segs := n if closed else n - 1
	for i in segs:
		var p0 := pts[(i - 1 + n) % n] if closed else pts[maxi(i - 1, 0)]
		var p1 := pts[i]
		var p2 := pts[(i + 1) % n]
		var p3 := pts[(i + 2) % n] if closed else pts[mini(i + 2, n - 1)]
		for s in steps:
			var u := float(s) / steps
			var u2 := u * u
			var u3 := u2 * u
			out.append(0.5 * ((2.0 * p1) + (-p0 + p2) * u + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * u2 + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * u3))
	if not closed:
		out.append(pts[n - 1])
	return out


## Fill a smooth closed shape and outline it with a thin anti-aliased line.
static func shape(ci: CanvasItem, pts: PackedVector2Array, fill: Color, a: float, ow := OW) -> void:
	var sm := smooth(pts)
	ci.draw_colored_polygon(sm, Color(fill, fill.a * a))
	if ow > 0.0:
		var loop := sm.duplicate()
		loop.append(sm[0])
		ci.draw_polyline(loop, Color(OUTLINE, a), ow, true)


static func soft(ci: CanvasItem, pts: PackedVector2Array, col: Color, a: float) -> void:
	ci.draw_colored_polygon(smooth(pts), Color(col, col.a * a))


static func _v(arr: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in arr:
		out.append(p)
	return out


## body_fn for Rig.draw(): called as (ci, xf, rig, alpha) + bound (lk).
static func body(ci: CanvasItem, xf: Transform2D, rig, alpha: float, lk: Dictionary) -> void:
	var hip: Vector2 = rig.pose["hip"]
	var tor: float = rig.pose["torso"]
	var tl: float = rig.s["torso_len"]
	var tier: int = lk["tier"]
	# Posture: early Rico slouches (head forward and down); the high roller stands tall.
	var slouch: float = [1.0, 0.7, 0.4, 0.15, 0.0][tier]
	ci.draw_set_transform_matrix(xf * Transform2D(tor, hip))
	_torso(ci, tl, alpha, lk, slouch)
	var neck: Vector2 = rig.neck()
	ci.draw_set_transform_matrix(xf * Transform2D(tor + float(rig.pose["head"]) + slouch * 0.12, neck + Vector2(slouch * 0.9, slouch * 0.8)))
	_head(ci, alpha, lk)
	ci.draw_set_transform_matrix(xf)


# ---------------------------------------------------------------- torso

static func _torso(ci: CanvasItem, tl: float, a: float, lk: Dictionary, slouch: float) -> void:
	var tier: int = lk["tier"]
	var j: Color = lk["jacket"]
	var j2: Color = lk["jacket2"]
	var under: Color = lk["under"]
	var item: String = lk["torso_item"]
	var top := -tl
	var gut := slouch * 0.9   # a little beer gut on the couch
	# Base torso silhouette: slumped shoulders, soft belly.
	var tor_shape := _v([Vector2(-2.8, 1.0), Vector2(2.6 + gut * 0.6, 1.0), Vector2(3.1 + gut, -2.4), Vector2(3.0, top + 2.6), Vector2(2.2, top + 0.4),
		Vector2(-0.4, top - 0.2), Vector2(-2.8, top + 0.6), Vector2(-3.4, top + 3.0), Vector2(-3.2, -2.2)])
	if item != "":
		_garment(ci, tor_shape, j, j2, a)
		_item_detail(ci, item, top, j, j2, a)
		return
	match tier:
		0:
			# Stained white tank top, skinny bare shoulders, an old flannel tied round the waist.
			shape(ci, tor_shape, SKIN, a)
			var tank := _v([Vector2(-2.6, 1.0), Vector2(2.6 + gut * 0.6, 1.0), Vector2(3.0 + gut, -2.4), Vector2(2.6, top + 2.4), Vector2(1.6, top + 1.0),
				Vector2(0.6, top + 2.6), Vector2(-1.2, top + 2.2), Vector2(-2.0, top + 0.8), Vector2(-3.0, top + 2.8), Vector2(-3.0, -2.2)])
			shape(ci, tank, j, a)
			soft(ci, _v([Vector2(-2.6, 0.8), Vector2(-0.6, 0.8), Vector2(-1.2, top + 2.6), Vector2(-2.8, top + 2.8)]), Color(0, 0, 0, 0.14), a)
			soft(ci, _v([Vector2(0.6, -3.4), Vector2(2.0, -3.8), Vector2(2.4, -2.4), Vector2(1.2, -1.8)]), Color(0.78, 0.66, 0.3, 0.6), a)   # mystery stain
			ci.draw_circle(Vector2(-0.8, -4.6), 0.45, Color(0.6, 0.45, 0.25, 0.5 * a))                                                     # another one
			# Flannel tied round the waist.
			shape(ci, _v([Vector2(-3.4, 0.2), Vector2(3.4 + gut * 0.6, 0.2), Vector2(3.0 + gut * 0.5, 1.8), Vector2(-3.2, 1.8)]), Color(0.62, 0.18, 0.16), a)
			for k in 4:
				ci.draw_line(Vector2(-2.6 + k * 1.6, 0.3), Vector2(-2.6 + k * 1.6, 1.7), Color(0.1, 0.06, 0.06, 0.5 * a), 0.3)
			shape(ci, _v([Vector2(-3.2, 1.2), Vector2(-2.2, 1.4), Vector2(-3.0, 4.6), Vector2(-4.0, 4.2)]), Color(0.55, 0.15, 0.14), a)   # sleeve hanging
		1:
			# Faded hand-me-down hoodie, hood down, frayed pocket.
			_garment(ci, tor_shape, j, j2, a)
			shape(ci, _v([Vector2(-3.0, top + 0.8), Vector2(0.0, top - 0.6), Vector2(0.8, top + 0.8), Vector2(-2.0, top + 2.4)]), j.darkened(0.15), a)
			ci.draw_polyline(smooth(_v([Vector2(-1.2, -1.0), Vector2(1.0, -1.6), Vector2(2.8 + gut, -1.0)]), false), Color(OUTLINE, 0.6 * a), 0.35, true)
			ci.draw_line(Vector2(1.4, top + 0.8), Vector2(1.7, top + 3.4), Color(j2, a), 0.3)
			ci.draw_line(Vector2(2.1, top + 0.8), Vector2(2.4, top + 3.1), Color(j2, a), 0.3)
		2:
			# Thrift-store bomber jacket over a white tee: ribbed collar and cuffs.
			shape(ci, tor_shape, under, a)
			var jacket := _v([Vector2(-2.8, 1.0), Vector2(0.6, 1.0), Vector2(1.4, top + 1.4), Vector2(2.6, top + 0.4), Vector2(-0.4, top - 0.2),
				Vector2(-2.8, top + 0.6), Vector2(-3.4, top + 3.0), Vector2(-3.2, -2.2)])
			_garment(ci, jacket, j, j2, a)
			shape(ci, _v([Vector2(2.6, 1.0), Vector2(3.2 + gut, -2.4), Vector2(3.0, top + 2.6), Vector2(2.6, top + 0.6), Vector2(1.6, top + 1.4), Vector2(1.2, 1.0)]), j.darkened(0.05), a)
			ci.draw_rect(Rect2(-2.8, 0.2, 6.0, 0.9), Color(j2, a))   # ribbed waistband
			ci.draw_line(Vector2(-0.6, top + 0.2), Vector2(1.4, top + 0.6), Color(j2, a), 0.6)
		3:
			# Black leather jacket over a red tee, with a zipper and shine.
			shape(ci, tor_shape, under, a)
			var lj := _v([Vector2(-2.8, 1.0), Vector2(0.8, 1.0), Vector2(1.6, top + 2.2), Vector2(2.8, top + 0.6), Vector2(-0.4, top - 0.4),
				Vector2(-2.9, top + 0.6), Vector2(-3.5, top + 3.0), Vector2(-3.3, -2.2)])
			_garment(ci, lj, j, j2, a)
			shape(ci, _v([Vector2(2.6, 1.0), Vector2(3.2, -2.4), Vector2(3.1, top + 2.6), Vector2(2.8, top + 0.6), Vector2(1.6, top + 2.2), Vector2(1.4, 1.0)]), j, a)
			ci.draw_polyline(smooth(_v([Vector2(1.6, top + 2.2), Vector2(0.4, top + 0.4), Vector2(-1.4, top + 1.2)]), false), Color(j2, a), 0.4, true)   # lapel
			ci.draw_line(Vector2(0.8, 0.8), Vector2(1.5, top + 2.4), Color(j2, a * 0.9), 0.3)                                                          # zipper
			ci.draw_line(Vector2(-2.0, top + 2.0), Vector2(-1.4, -1.4), Color(1, 1, 1, 0.22 * a), 0.6)                                                 # leather shine
		4:
			# Sharp suit, white shirt with an open collar, a pocket square.
			shape(ci, tor_shape, j, a)
			soft(ci, _v([Vector2(0.4, top + 0.2), Vector2(3.0, top + 0.4), Vector2(2.4, top + 3.6), Vector2(1.6, top + 3.8)]), under, a)
			ci.draw_polyline(smooth(_v([Vector2(0.4, top + 0.2), Vector2(1.4, top + 2.6), Vector2(1.9, -1.0)]), false), Color(OUTLINE, a), 0.4, true)
			ci.draw_polyline(smooth(_v([Vector2(3.0, top + 0.4), Vector2(2.4, top + 2.6), Vector2(2.2, -0.6)]), false), Color(OUTLINE, 0.7 * a), 0.35, true)
			ci.draw_circle(Vector2(2.3, -2.0), 0.3, Color(j2, a))
			soft(ci, _v([Vector2(-1.6, top + 2.0), Vector2(-0.2, top + 1.8), Vector2(-0.4, top + 3.0), Vector2(-1.6, top + 3.0)]), j2, a)   # pocket square
			ci.draw_line(Vector2(-3.0, top + 3.4), Vector2(-2.4, -0.6), Color(1, 1, 1, 0.1 * a), 0.8)
	# Shared soft shading: the back half darker.
	soft(ci, _v([Vector2(-2.8, 0.9), Vector2(-1.4, 0.9), Vector2(-1.8, top + 0.6), Vector2(-2.8, top + 0.6), Vector2(-3.3, top + 3.0)]), Color(0, 0, 0, 0.16), a)


static func _garment(ci: CanvasItem, pts: PackedVector2Array, col: Color, trim: Color, a: float) -> void:
	shape(ci, pts, col, a)
	ci.draw_line(Vector2(2.4, -5.0), Vector2(2.2, -1.2), Color(col.lightened(0.25), 0.7 * a), 0.4)


static func _item_detail(ci: CanvasItem, item: String, top: float, j: Color, j2: Color, a: float) -> void:
	match item:
		"track_jacket":
			for k in 2:
				ci.draw_line(Vector2(-2.6 + k * 0.8, top + 1.0), Vector2(-2.2 + k * 0.8, 0.6), Color(j2, a), 0.35)
			ci.draw_line(Vector2(1.6, top + 0.6), Vector2(1.8, 0.8), Color(j2, a), 0.35)
		"hawaiian":
			for k in 6:
				ci.draw_circle(Vector2(-2.2 + (k % 3) * 2.0, top + 1.8 + (k / 3) * 2.4), 0.55, Color(j2, a))
				ci.draw_circle(Vector2(-1.5 + (k % 3) * 2.0, top + 2.6 + (k / 3) * 2.4), 0.3, Color(1, 0.95, 0.5, a))
			ci.draw_line(Vector2(1.4, top + 0.4), Vector2(1.8, 0.8), Color(OUTLINE, 0.4 * a), 0.3)
		"parkour_vest":
			shape(ci, _v([Vector2(-2.6, -0.2), Vector2(2.8, -0.2), Vector2(3.0, top + 2.2), Vector2(-3.0, top + 2.2)]), j.darkened(0.2), a)
			ci.draw_rect(Rect2(0.6, top + 2.8, 1.8, 1.2), Color(j2, a))


# ---------------------------------------------------------------- head

static func _head(ci: CanvasItem, a: float, lk: Dictionary) -> void:
	var tier: int = lk["tier"]
	var mood: String = lk.get("mood", "")
	# Neck.
	shape(ci, _v([Vector2(-0.6, 0.6), Vector2(1.6, 0.6), Vector2(1.6, -1.8), Vector2(-0.6, -1.8)]), SKIN_SH, a, OW)
	# Head in three-quarter profile: rounded skull, defined jaw, chin forward.
	var head := _v([Vector2(-2.8, -3.0), Vector2(-3.0, -5.6), Vector2(-1.6, -8.0), Vector2(1.0, -8.8), Vector2(3.4, -7.8), Vector2(4.4, -5.8),
		Vector2(4.6, -4.4), Vector2(4.9, -3.6), Vector2(4.5, -3.2), Vector2(4.4, -2.0), Vector2(3.2, -1.0), Vector2(1.2, -0.9), Vector2(-0.8, -1.6)])
	shape(ci, head, SKIN, a)
	soft(ci, _v([Vector2(-2.6, -3.2), Vector2(-2.8, -5.6), Vector2(-1.4, -7.2), Vector2(0.0, -5.0), Vector2(-0.6, -2.0)]), Color(SKIN_SH, 0.55), a)   # shadow side
	soft(ci, _v([Vector2(2.6, -7.0), Vector2(3.8, -6.2), Vector2(3.4, -5.4), Vector2(2.4, -6.0)]), Color(SKIN_HI, 0.6), a)                          # brow highlight
	# Stubble on the jaw for the broke years.
	if tier <= 2:
		var st_a: float = [0.75, 0.6, 0.35][tier]
		soft(ci, _v([Vector2(-0.6, -1.8), Vector2(1.2, -1.0), Vector2(3.2, -1.1), Vector2(4.3, -2.1), Vector2(4.0, -2.9), Vector2(2.6, -2.2), Vector2(0.4, -2.8)]), Color(STUBBLE, st_a), a)
	# Ear.
	soft(ci, _v([Vector2(-0.3, -4.6), Vector2(0.4, -4.7), Vector2(0.5, -3.8), Vector2(-0.1, -3.5)]), SKIN_SH.darkened(0.1), a)
	# Eye: heavy-lidded and tired early, sharp and confident later.
	var e := Vector2(3.0, -5.2)
	if mood == "hurt":
		ci.draw_line(e + Vector2(-0.7, -0.5), e + Vector2(0.7, 0.4), Color(OUTLINE, a), 0.45, true)
		ci.draw_line(e + Vector2(-0.7, 0.4), e + Vector2(0.7, -0.5), Color(OUTLINE, a), 0.45, true)
	else:
		var lid: float = [0.55, 0.45, 0.3, 0.2, 0.15][tier]
		soft(ci, _v([e + Vector2(-0.8, 0.0), e + Vector2(0.0, -0.75), e + Vector2(0.85, -0.2), e + Vector2(0.1, 0.55)]), Color(1, 1, 1), a)
		var iris := Color(1.0, 0.75, 0.25) if mood == "fired" else Color(0.32, 0.22, 0.14)
		ci.draw_circle(e + Vector2(0.3, 0.0), 0.42, Color(iris, a))
		ci.draw_circle(e + Vector2(0.35, 0.0), 0.2, Color(0.05, 0.03, 0.03, a))
		ci.draw_circle(e + Vector2(0.18, -0.15), 0.1, Color(1, 1, 1, a))
		# Upper lid droops lower when he's broke and tired.
		soft(ci, _v([e + Vector2(-0.9, -0.1), e + Vector2(0.0, -0.95), e + Vector2(1.0, -0.3), e + Vector2(0.2, -0.75 + lid)]), SKIN_SH, a)
		ci.draw_polyline(smooth(_v([e + Vector2(-0.9, -0.1), e + Vector2(0.0, -0.95 + lid * 0.6), e + Vector2(1.0, -0.3)]), false), Color(OUTLINE, a), 0.35, true)
		if tier <= 1:
			ci.draw_polyline(smooth(_v([e + Vector2(-0.6, 0.75), e + Vector2(0.2, 0.95), e + Vector2(0.8, 0.6)]), false), Color(SKIN_SH.darkened(0.2), 0.7 * a), 0.25, true)   # eye bags
	# Brow: flat and unbothered, cocky arch at the top.
	var arch: float = [0.0, 0.1, 0.25, 0.4, 0.5][tier]
	ci.draw_polyline(smooth(_v([Vector2(2.0, -6.2), Vector2(3.0, -6.6 - arch), Vector2(4.0, -6.2)]), false), Color(HAIR, a), 0.45, true)
	# Nose and a half-smirk.
	ci.draw_polyline(smooth(_v([Vector2(4.4, -5.4), Vector2(5.1, -4.0), Vector2(4.5, -3.7)]), false), Color(SKIN_SH.darkened(0.15), a), 0.35, true)
	var smirk := 0.3 + tier * 0.12
	ci.draw_polyline(smooth(_v([Vector2(3.0, -2.5), Vector2(3.8, -2.6 - smirk * 0.2), Vector2(4.4, -2.9 - smirk * 0.4)]), false), Color(0.45, 0.16, 0.16, a), 0.35, true)
	_hair(ci, a, tier)


static func _hair(ci: CanvasItem, a: float, tier: int) -> void:
	match tier:
		0, 1:
			# Couch bedhead: messy tufts sticking out in every direction.
			var bed := _v([Vector2(-3.2, -4.2), Vector2(-3.9, -6.0), Vector2(-3.0, -7.4), Vector2(-3.8, -8.6), Vector2(-1.8, -8.8), Vector2(-1.4, -10.2),
				Vector2(0.4, -9.2), Vector2(1.6, -10.4), Vector2(2.4, -9.0), Vector2(4.0, -9.4), Vector2(3.8, -8.0), Vector2(4.8, -7.4), Vector2(3.4, -7.2),
				Vector2(2.2, -7.8), Vector2(0.6, -7.2), Vector2(-0.8, -7.4), Vector2(-1.6, -6.0), Vector2(-2.2, -4.6)])
			shape(ci, bed, HAIR, a)
			ci.draw_polyline(smooth(_v([Vector2(-2.6, -8.0), Vector2(-0.4, -8.8), Vector2(1.8, -9.0)]), false), Color(HAIR_HI, a), 0.35, true)
		2:
			# Tousled, finally washed.
			var tou := _v([Vector2(-3.0, -4.4), Vector2(-3.6, -6.6), Vector2(-2.4, -8.6), Vector2(0.0, -9.6), Vector2(2.6, -9.6), Vector2(4.6, -8.4),
				Vector2(4.4, -7.4), Vector2(3.0, -7.6), Vector2(1.2, -7.2), Vector2(-0.8, -7.4), Vector2(-1.8, -6.0)])
			shape(ci, tou, HAIR, a)
			ci.draw_polyline(smooth(_v([Vector2(-2.0, -8.4), Vector2(0.8, -9.3), Vector2(3.6, -8.8)]), false), Color(HAIR_HI, a), 0.35, true)
		3:
			# A styled quiff.
			var qf := _v([Vector2(-3.0, -4.6), Vector2(-3.4, -7.0), Vector2(-2.0, -8.8), Vector2(0.6, -10.0), Vector2(3.4, -10.6), Vector2(5.2, -9.6),
				Vector2(4.2, -8.6), Vector2(2.4, -8.0), Vector2(0.6, -7.6), Vector2(-1.6, -6.4)])
			shape(ci, qf, HAIR, a)
			ci.draw_polyline(smooth(_v([Vector2(-1.4, -8.6), Vector2(1.6, -9.8), Vector2(4.4, -9.8)]), false), Color(HAIR_HI.lightened(0.15), a), 0.4, true)
		_:
			# Slicked back, glossy.
			var sl := _v([Vector2(-3.0, -4.4), Vector2(-3.4, -6.8), Vector2(-2.0, -8.6), Vector2(0.8, -9.3), Vector2(3.2, -8.9), Vector2(4.2, -7.8),
				Vector2(2.4, -7.9), Vector2(0.2, -7.6), Vector2(-1.8, -6.2)])
			shape(ci, sl, HAIR, a)
			for k in 3:
				ci.draw_polyline(smooth(_v([Vector2(3.4 - k * 0.3, -8.4 + k * 0.4), Vector2(0.6, -8.7 + k * 0.6), Vector2(-2.2, -7.6 + k * 0.6)]), false), Color(HAIR_HI.lightened(0.3), 0.6 * a), 0.25, true)
