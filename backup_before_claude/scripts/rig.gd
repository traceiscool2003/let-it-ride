extends RefCounted
## Procedural 2D character rig: pixel-art head + torso, two-bone IK arms and
## legs, and smooth pose blending. Poses live in "rig space": feet at the
## origin, facing +x, up is -y. The owner computes a target pose each frame
## and calls blend(); draw() renders through any Transform2D (flip, squash,
## rotation), so one rig handles every state.

const Sprites := preload("res://scripts/sprites.gd")

var s: Dictionary
var pose: Dictionary


func _init(style: Dictionary) -> void:
	s = style
	var hip := Vector2(0, -(float(s["thigh"]) + float(s["shin"])) * 0.92)
	pose = make(hip, 0.0, 0.0, Vector2(2, 0), Vector2(-2, 0), Vector2(1.5, hip.y + 1), Vector2(-1.5, hip.y + 1))


static func make(hip: Vector2, torso: float, head: float, ff: Vector2, fb: Vector2, hf: Vector2, hb: Vector2) -> Dictionary:
	return {"hip": hip, "torso": torso, "head": head, "foot_f": ff, "foot_b": fb, "hand_f": hf, "hand_b": hb}


static func mix(a: Dictionary, b: Dictionary, k: float) -> Dictionary:
	var out := {}
	for key in a:
		out[key] = lerp(a[key], b[key], k)
	return out


func blend(target: Dictionary, rate: float, delta: float) -> void:
	var k := 1.0 - exp(-rate * delta)
	for key in target:
		pose[key] = lerp(pose[key], target[key], k)


func shoulder_of(hip: Vector2, torso: float) -> Vector2:
	return hip + Vector2(0, -(float(s["torso_len"]) - float(s["shoulder_drop"]))).rotated(torso)


func neck() -> Vector2:
	return (pose["hip"] as Vector2) + Vector2(0, -float(s["torso_len"])).rotated(pose["torso"])


## A point in head space (origin at the neck) mapped to rig space.
func head_point(local: Vector2) -> Vector2:
	return neck() + local.rotated(float(pose["torso"]) + float(pose["head"]))


## Two-bone IK. Returns [joint, end]. bend +1 = joint toward +x when the
## limb points down (knees), -1 = backward (elbows).
static func ik(a: Vector2, t: Vector2, l1: float, l2: float, bend: float) -> Array:
	var d := t - a
	var dn := d.normalized() if d.length() > 0.001 else Vector2.DOWN
	var dist := clampf(d.length(), 0.01, l1 + l2 - 0.01)
	var x := (l1 * l1 - l2 * l2 + dist * dist) / (2.0 * dist)
	var hh := sqrt(maxf(0.0, l1 * l1 - x * x))
	return [a + dn * x + dn.orthogonal() * hh * bend, a + dn * dist]


func draw(ci: CanvasItem, xf: Transform2D, alpha := 1.0) -> void:
	var hip: Vector2 = pose["hip"]
	var sh := shoulder_of(hip, pose["torso"])
	ci.draw_set_transform_matrix(xf)
	_limb(ci, sh, pose["hand_b"], s["upper"], s["fore"], -1.0, false, alpha, 0.62)
	_limb(ci, hip, pose["foot_b"], s["thigh"], s["shin"], 1.0, true, alpha, 0.62)
	_limb(ci, hip, pose["foot_f"], s["thigh"], s["shin"], 1.0, true, alpha, 1.0)

	var mod := Color(1, 1, 1, alpha)
	var tt: Texture2D = s["torso_tex"]
	ci.draw_set_transform_matrix(xf * Transform2D(float(pose["torso"]), hip))
	ci.draw_texture(tt, Vector2(-tt.get_width() * 0.5, -tt.get_height() + float(s["torso_sink"])), mod)
	var ht: Texture2D = s["head_tex"]
	ci.draw_set_transform_matrix(xf * Transform2D(float(pose["torso"]) + float(pose["head"]), neck()))
	ci.draw_texture(ht, s["head_off"], mod)

	ci.draw_set_transform_matrix(xf)
	_limb(ci, sh, pose["hand_f"], s["upper"], s["fore"], -1.0, false, alpha, 1.0)


func _limb(ci: CanvasItem, a: Vector2, t: Vector2, l1: float, l2: float, bend: float, is_leg: bool, alpha: float, shade: float) -> void:
	var r := ik(a, t, l1, l2, bend)
	var j: Vector2 = r[0]
	var e: Vector2 = r[1]
	var w: float = s["leg_w"] if is_leg else s["arm_w"]
	var col: Color = s["leg"] if is_leg else s["arm"]
	col = Color(col.darkened(1.0 - shade), alpha)
	var oc := Color(s["outline"], alpha)
	var ow := w + 1.6
	ci.draw_line(a, j, oc, ow)
	ci.draw_line(j, e, oc, ow)
	ci.draw_circle(j, ow * 0.5, oc)
	ci.draw_circle(a, ow * 0.5, oc)
	if is_leg:
		ci.draw_rect(Rect2(e + Vector2(-2.1, -2.4), Vector2(6.4, 3.6)), oc)
	else:
		ci.draw_circle(e, 2.0, oc)
	ci.draw_line(a, j, col, w)
	ci.draw_line(j, e, col, w)
	ci.draw_circle(j, w * 0.5, col)
	ci.draw_circle(a, w * 0.5, col)
	if is_leg:
		var sc: Color = s["shoe"]
		ci.draw_rect(Rect2(e + Vector2(-1.3, -1.6), Vector2(4.8, 2.0)), Color(sc.darkened(1.0 - shade), alpha))
	else:
		var sk: Color = s["skin"]
		ci.draw_circle(e, 1.3, Color(sk.darkened(1.0 - shade), alpha))


## Flat-color version used for after-images.
func draw_silhouette(ci: CanvasItem, xf: Transform2D, col: Color) -> void:
	ci.draw_set_transform_matrix(xf)
	var hip: Vector2 = pose["hip"]
	var sh := shoulder_of(hip, pose["torso"])
	for limb in [[sh, pose["hand_b"], false], [hip, pose["foot_b"], true], [hip, pose["foot_f"], true], [sh, pose["hand_f"], false]]:
		var is_leg: bool = limb[2]
		var r := ik(limb[0], limb[1], s["thigh"] if is_leg else s["upper"], s["shin"] if is_leg else s["fore"], 1.0 if is_leg else -1.0)
		var w: float = (s["leg_w"] if is_leg else s["arm_w"]) + 0.6
		ci.draw_line(limb[0], r[0], col, w)
		ci.draw_line(r[0], r[1], col, w)
	ci.draw_line(hip, neck(), col, float(s["torso_w"]))
	ci.draw_circle(head_point(Vector2(0.5, -3.5)), float(s["head_r"]), col)


static func runner_style(hood := Color(0.30, 0.18, 0.45), hood_l := Color(0.47, 0.31, 0.64)) -> Dictionary:
	var pal: Dictionary = Sprites.RUNNER_PAL.duplicate()
	pal["P"] = hood
	pal["p"] = hood_l
	return {
		"thigh": 5.8, "shin": 5.8, "torso_len": 7.0, "shoulder_drop": 1.6,
		"upper": 4.2, "fore": 4.2, "leg_w": 2.6, "arm_w": 2.1,
		"torso_w": 7.0, "head_r": 4.5,
		"outline": pal["K"], "leg": Color(0.16, 0.14, 0.25), "arm": Color(0.22, 0.18, 0.36),
		"skin": pal["S"], "shoe": pal["W"],
		"torso_tex": Sprites.bake(Sprites.R_TORSO, pal), "torso_sink": 1.0,
		"head_tex": Sprites.bake(Sprites.R_HEAD, pal), "head_off": Vector2(-6, -7),
	}


static func guard_style() -> Dictionary:
	var pal: Dictionary = Sprites.GUARD_PAL
	return {
		"thigh": 4.0, "shin": 4.0, "torso_len": 7.6, "shoulder_drop": 1.2,
		"upper": 4.0, "fore": 3.8, "leg_w": 3.4, "arm_w": 3.0,
		"torso_w": 11.0, "head_r": 4.2,
		"outline": pal["K"], "leg": Color(0.09, 0.09, 0.11), "arm": Color(0.16, 0.16, 0.2),
		"skin": pal["S"], "shoe": Color(0.25, 0.22, 0.2),
		"torso_tex": Sprites.bake(Sprites.G_TORSO, pal), "torso_sink": 1.0,
		"head_tex": Sprites.bake(Sprites.G_HEAD, pal), "head_off": Vector2(-6, -5),
	}


static func boss_style(tier: int) -> Dictionary:
	var i := clampi(tier - 1, 0, 2)
	var pal: Dictionary = Sprites.BOSS_PALS[i]
	var head: Array = Sprites.BOSS_HEADS[i]
	var st := guard_style()
	st["torso_tex"] = Sprites.bake(Sprites.BOSS_TORSOS[i], pal)
	st["head_tex"] = Sprites.bake(head, pal)
	st["head_off"] = Vector2(-6, -head.size() + 1)
	st["arm"] = (pal["J"] as Color).lightened(0.08)
	st["leg"] = pal["L"]
	st["skin"] = pal.get("S", Color(0.95, 0.75, 0.3))
	st["shoe"] = Color(0.12, 0.1, 0.1) if i != 1 else Color(0.85, 0.1, 0.15)
	return st


static func enemy_style(kind: int) -> Dictionary:
	var st := guard_style()
	var pal: Dictionary = Sprites.GUARD_PAL.duplicate()
	if kind == 2:
		pal["J"] = Color(0.62, 0.08, 0.14)
		pal["j"] = Color(0.8, 0.2, 0.25)
		pal["D"] = Color(0.15, 0.6, 0.3)
		pal["d"] = Color(0.5, 1.0, 0.6)
		st["arm"] = Color(0.92, 0.92, 0.9)
		st["leg"] = Color(0.08, 0.08, 0.1)
	else:
		pal["J"] = Color(0.18, 0.2, 0.26)
		pal["j"] = Color(0.3, 0.33, 0.4)
		pal["W"] = Color(0.3, 0.33, 0.4)
		pal["R"] = Color(0.9, 0.7, 0.2)
		pal["S"] = Color(0.6, 0.45, 0.35)
		st["arm"] = Color(0.22, 0.24, 0.3)
		st["leg"] = Color(0.12, 0.13, 0.17)
		st["arm_w"] = 3.6
		st["leg_w"] = 3.8
	st["torso_tex"] = Sprites.bake(Sprites.G_TORSO, pal)
	st["head_tex"] = Sprites.bake(Sprites.G_HEAD, pal)
	return st
