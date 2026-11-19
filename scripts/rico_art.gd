extends RefCounted
## Rico's hand-drawn body for the rig (replaces the old pixel head and torso).
## Everything is vector: outlined, two-tone shaded, and dressed by the outfit
## tier (alley rags -> hoodie -> polo -> sharp suit -> black-card tux) plus any
## worn torso/leg/feet/hands item. The limbs are drawn by rig.gd's smooth path
## using the colours from look().
## Rig space: neck/hip from the rig, facing +x, up is -y, ~1 unit = 1 px at 1x.

const Wardrobe := preload("res://scripts/wardrobe.gd")

const OUTLINE := Color(0.05, 0.03, 0.07)
const SKIN := Color(0.93, 0.72, 0.56)
const SKIN_SH := Color(0.76, 0.52, 0.4)
const HAIR := Color(0.13, 0.08, 0.07)
const HAIR_HI := Color(0.32, 0.2, 0.15)


## The colours for the current outfit. Used for the torso here and the limbs in rig.gd.
static func look(worn: Array, floor_num: int) -> Dictionary:
	var tier_i := Wardrobe.tier_for(floor_num)
	var tier: Dictionary = Wardrobe.TIERS[tier_i]
	var lk := {"tier": tier_i, "jacket": tier["torso"], "jacket2": tier["accent"], "legs": tier["legs"],
		"shoe": Color(0.82, 0.82, 0.8), "shoe2": Color(0.65, 0.18, 0.2), "glove": Color(0, 0, 0, 0), "torso_item": ""}
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
	if fid != "":
		lk["shoe"] = Wardrobe.info(fid)["col"]
		lk["shoe2"] = Wardrobe.info(fid)["col2"]
	var hid := Wardrobe.item_in_slot(worn, "hands")
	if hid != "":
		lk["glove"] = Wardrobe.info(hid)["col"]
	return lk


## Push the outfit colours into the rig style so the smooth limbs match.
static func dress_rig(rig, lk: Dictionary) -> void:
	var j: Color = lk["jacket"]
	rig.s["smooth"] = true
	rig.s["arm"] = j
	rig.s["leg"] = lk["legs"]
	rig.s["shoe"] = lk["shoe"]
	rig.s["shoe2"] = lk["shoe2"]
	rig.s["outline"] = OUTLINE
	var g: Color = lk["glove"]
	rig.s["skin"] = g if g.a > 0.0 else SKIN
	rig.s["cuff"] = lk["jacket2"]


static func _poly(ci: CanvasItem, pts: PackedVector2Array, fill: Color, alpha: float, ow := 0.9) -> void:
	ci.draw_colored_polygon(pts, Color(fill, fill.a * alpha))
	var loop := pts.duplicate()
	loop.append(pts[0])
	ci.draw_polyline(loop, Color(OUTLINE, alpha), ow)


## body_fn for Rig.draw(): called as (ci, xf, rig, alpha) + bound (lk).
static func body(ci: CanvasItem, xf: Transform2D, rig, alpha: float, lk: Dictionary) -> void:
	var hip: Vector2 = rig.pose["hip"]
	var tor: float = rig.pose["torso"]
	var tl: float = rig.s["torso_len"]
	ci.draw_set_transform_matrix(xf * Transform2D(tor, hip))
	_torso(ci, tl, alpha, lk)
	var neck: Vector2 = rig.neck()
	ci.draw_set_transform_matrix(xf * Transform2D(tor + float(rig.pose["head"]), neck) * Transform2D(0.0, Vector2(0, 2.6)))
	_head(ci, alpha, lk)
	ci.draw_set_transform_matrix(xf)


# ---------------------------------------------------------------- torso

static func _torso(ci: CanvasItem, tl: float, a: float, lk: Dictionary) -> void:
	var tier: int = lk["tier"]
	var j: Color = lk["jacket"]
	var j2: Color = lk["jacket2"]
	var item: String = lk["torso_item"]
	# Base silhouette: hips to rounded shoulders, slightly wider at the chest.
	var top := -tl
	var shape := PackedVector2Array([Vector2(-3.0, 1.2), Vector2(3.2, 1.2), Vector2(3.8, top + 3.0), Vector2(3.0, top + 0.6),
		Vector2(1.0, top - 0.2), Vector2(-1.6, top - 0.2), Vector2(-3.6, top + 0.8), Vector2(-4.0, top + 3.2)])
	_poly(ci, shape, j, a)
	# Shading: a darker back half and a light rim on the chest.
	ci.draw_colored_polygon(PackedVector2Array([Vector2(-3.0, 1.2), Vector2(-0.6, 1.2), Vector2(-1.4, top), Vector2(-3.6, top + 0.8), Vector2(-4.0, top + 3.2)]), Color(j.darkened(0.3), a * 0.9))
	ci.draw_line(Vector2(3.3, top + 2.6), Vector2(2.8, 0.6), Color(j.lightened(0.35), a * 0.8), 0.6)
	match item:
		"track_jacket":
			for k in 3:
				ci.draw_line(Vector2(-2.6 + k * 0.9, top + 1.0), Vector2(-2.2 + k * 0.9, 0.8), Color(j2, a), 0.4)
			ci.draw_line(Vector2(1.6, top + 0.6), Vector2(1.6, 1.0), Color(j2, a), 0.5)   # zipper
		"parkour_vest":
			_poly(ci, PackedVector2Array([Vector2(-2.8, 0.6), Vector2(3.0, 0.6), Vector2(3.4, top + 2.4), Vector2(-3.4, top + 2.4)]), j.darkened(0.15), a, 0.6)
			ci.draw_rect(Rect2(0.6, top + 3.4, 2.0, 1.4), Color(j2, a))
			ci.draw_rect(Rect2(-2.4, top + 3.4, 2.0, 1.4), Color(j2, a))
		"hawaiian":
			for k in 5:
				ci.draw_circle(Vector2(-2.4 + (k % 3) * 2.2, top + 2.0 + (k / 3) * 2.6), 0.7, Color(j2, a))
				ci.draw_circle(Vector2(-1.4 + (k % 3) * 2.2, top + 3.2 + (k / 3) * 2.6), 0.4, Color(1, 0.95, 0.5, a))
		_:
			match tier:
				0:
					# Alley rags: a torn, patched hoodie.
					ci.draw_rect(Rect2(-2.6, top + 3.6, 1.8, 1.6), Color(0.45, 0.38, 0.28, a))
					ci.draw_line(Vector2(-2.6, top + 3.6), Vector2(-0.8, top + 5.2), Color(OUTLINE, a * 0.6), 0.3)
					ci.draw_colored_polygon(PackedVector2Array([Vector2(1.6, 1.2), Vector2(2.4, 0.0), Vector2(3.0, 1.2)]), Color(0.06, 0.04, 0.06, a))
				1:
					# Hoodie: front pocket and drawstrings.
					ci.draw_line(Vector2(-1.4, -1.2), Vector2(2.8, -1.2), Color(j.darkened(0.35), a), 0.5)
					ci.draw_line(Vector2(1.4, top + 0.6), Vector2(1.8, top + 3.2), Color(j2, a), 0.35)
					ci.draw_line(Vector2(2.2, top + 0.6), Vector2(2.5, top + 3.0), Color(j2, a), 0.35)
				2:
					# Polo: collar and buttons.
					_poly(ci, PackedVector2Array([Vector2(-1.2, top + 0.2), Vector2(2.8, top + 0.2), Vector2(2.2, top + 1.6), Vector2(0.8, top + 1.0)]), j.lightened(0.15), a, 0.4)
					for k in 2:
						ci.draw_circle(Vector2(1.9, top + 2.0 + k * 1.2), 0.3, Color(j2, a))
				3, 4:
					# Suit / tux: white shirt V, lapels, tie or gold trim.
					ci.draw_colored_polygon(PackedVector2Array([Vector2(0.4, top + 0.2), Vector2(3.2, top + 0.4), Vector2(2.0, top + 4.0)]), Color(0.95, 0.94, 0.92, a))
					ci.draw_line(Vector2(0.4, top + 0.2), Vector2(2.0, top + 4.2), Color(j2 if tier == 4 else j.lightened(0.25), a), 0.6)
					ci.draw_line(Vector2(3.2, top + 0.4), Vector2(2.0, top + 4.2), Color(j2 if tier == 4 else j.lightened(0.25), a), 0.6)
					if tier == 3:
						ci.draw_colored_polygon(PackedVector2Array([Vector2(1.6, top + 0.8), Vector2(2.4, top + 0.8), Vector2(2.2, top + 3.6), Vector2(1.9, top + 4.0), Vector2(1.6, top + 3.6)]), Color(j2, a))
					ci.draw_circle(Vector2(2.1, -1.4), 0.35, Color(j2 if tier == 4 else Color(0.2, 0.2, 0.2), a))
	# Hood (bunched behind the neck) for the hoodie tiers.
	if item == "" and tier <= 1:
		_poly(ci, PackedVector2Array([Vector2(-3.6, top + 0.8), Vector2(-0.6, top - 0.6), Vector2(0.4, top + 0.6), Vector2(-2.2, top + 2.2)]), j.darkened(0.12), a, 0.6)


# ---------------------------------------------------------------- head

static func _head(ci: CanvasItem, a: float, lk: Dictionary) -> void:
	# Neck.
	ci.draw_rect(Rect2(-0.8, -1.4, 2.0, 1.8), Color(SKIN_SH, a))
	# Skull + jaw in profile, facing +x.
	var head := PackedVector2Array([Vector2(-2.6, -2.4), Vector2(-3.0, -5.0), Vector2(-1.6, -7.6), Vector2(1.2, -8.4), Vector2(3.6, -7.2),
		Vector2(4.4, -5.2), Vector2(5.0, -3.8), Vector2(4.4, -3.4), Vector2(4.6, -2.2), Vector2(3.6, -1.2), Vector2(1.6, -0.8), Vector2(-0.6, -1.2)])
	_poly(ci, head, SKIN, a, 0.8)
	# Jaw shadow and stubble.
	ci.draw_colored_polygon(PackedVector2Array([Vector2(-0.6, -1.2), Vector2(1.6, -0.8), Vector2(3.6, -1.2), Vector2(3.2, -2.0), Vector2(0.6, -2.0)]), Color(SKIN_SH, a * 0.8))
	for k in 5:
		ci.draw_circle(Vector2(1.0 + k * 0.6, -1.4 - (k % 2) * 0.3), 0.18, Color(0.35, 0.25, 0.22, a * 0.6))
	# Ear.
	ci.draw_circle(Vector2(-0.4, -4.0), 0.65, Color(SKIN_SH, a))
	ci.draw_arc(Vector2(-0.4, -4.0), 0.65, -1.2, 1.6, 6, Color(OUTLINE, a * 0.7), 0.3)
	# Eye: white, pupil looking ahead, heavy-lidded brow (he hasn't slept).
	ci.draw_circle(Vector2(2.9, -5.0), 0.75, Color(1, 1, 1, a))
	ci.draw_circle(Vector2(3.25, -5.0), 0.42, Color(0.1, 0.08, 0.1, a))
	ci.draw_line(Vector2(2.0, -5.9), Vector2(3.9, -5.6), Color(HAIR, a), 0.55)
	ci.draw_line(Vector2(2.3, -4.3), Vector2(3.5, -4.3), Color(SKIN_SH, a * 0.8), 0.3)   # eye bag
	# A cocky smirk.
	ci.draw_line(Vector2(3.0, -2.3), Vector2(4.2, -2.6), Color(0.4, 0.15, 0.15, a), 0.4)
	# Messy hair swept forward, with a highlight streak.
	var hair := PackedVector2Array([Vector2(-3.2, -4.4), Vector2(-3.4, -6.6), Vector2(-2.2, -8.6), Vector2(0.2, -9.8), Vector2(2.4, -9.6),
		Vector2(4.6, -8.8), Vector2(5.4, -7.2), Vector2(3.8, -7.6), Vector2(3.0, -6.8), Vector2(1.2, -7.6), Vector2(-0.8, -7.0), Vector2(-1.6, -5.4)])
	_poly(ci, hair, HAIR, a, 0.7)
	ci.draw_line(Vector2(-1.6, -8.4), Vector2(2.6, -9.0), Color(HAIR_HI, a), 0.5)
	if int(lk["tier"]) >= 3:
		# Slicked back for the money tiers.
		ci.draw_line(Vector2(-2.4, -6.8), Vector2(3.4, -8.4), Color(HAIR_HI.lightened(0.2), a * 0.7), 0.35)
