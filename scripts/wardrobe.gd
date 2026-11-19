extends RefCounted
## Everything you own is clothing. Each item sits in a slot, may grant an ability
## (player.abil key) or a buff (see main/charms), and has a SWAG score: positive
## = sharp, negative = ugly. Good buffs look nice, bad buffs look awful.
## Outfit tiers: every floor you climb dresses the base outfit nicer.

const SLOTS := ["head", "face", "neck", "torso", "legs", "feet", "hands", "back"]

## id -> {name, slot, desc, abil, swag, col, col2, price, rarity}
const ITEMS := {
	"thrift_sneakers": {"name": "THRIFT SNEAKERS", "slot": "feet", "desc": "Scuffed, but they dash. DASH.", "abil": "dash", "swag": 0, "col": Color(0.75, 0.75, 0.72), "col2": Color(0.5, 0.2, 0.2), "price": 0, "rarity": "common"},
	"wingtips": {"name": "WINGTIP SHOES", "slot": "feet", "desc": "Fancy footwork. DOUBLE JUMP.", "abil": "double_jump", "swag": 3, "col": Color(0.15, 0.1, 0.08), "col2": Color(0.9, 0.9, 0.95), "price": 220, "rarity": "uncommon"},
	"grip_gloves": {"name": "GRIP GLOVES", "slot": "hands", "desc": "Tacky leather. WALL CLING & WALL JUMP.", "abil": "wall", "swag": 2, "col": Color(0.55, 0.3, 0.15), "col2": Color(0.3, 0.15, 0.08), "price": 200, "rarity": "uncommon"},
	"track_jacket": {"name": "TRACK JACKET", "slot": "torso", "desc": "Three stripes of pure velocity. SUPER DASH (8 directions).", "abil": "super_dash", "swag": 1, "col": Color(0.1, 0.35, 0.8), "col2": Color(1, 1, 1), "price": 340, "rarity": "rare"},
	"steel_toes": {"name": "STEEL-TOE BOOTS", "slot": "feet", "desc": "Heavy. Hold DOWN in the air to GROUND POUND.", "abil": "pound", "swag": -1, "col": Color(0.3, 0.3, 0.33), "col2": Color(0.7, 0.7, 0.75), "price": 260, "rarity": "uncommon"},
	"silk_scarf": {"name": "SILK SCARF", "slot": "neck", "desc": "Hold JUMP while falling to GLIDE.", "abil": "glide", "swag": 4, "col": Color(0.85, 0.12, 0.3), "col2": Color(1.0, 0.8, 0.3), "price": 300, "rarity": "rare"},
	"chalk_mitts": {"name": "CHALK MITTS", "slot": "hands", "desc": "Chalky. WALL RUN on tall walls.", "abil": "wall_run", "swag": 0, "col": Color(0.95, 0.95, 0.95), "col2": Color(0.7, 0.7, 0.7), "price": 380, "rarity": "rare"},
	"slick_loafers": {"name": "SLICK LOAFERS", "slot": "feet", "desc": "Zero grip. SLIDE under things.", "abil": "slide", "swag": 3, "col": Color(0.4, 0.2, 0.1), "col2": Color(0.9, 0.75, 0.2), "price": 240, "rarity": "uncommon"},
	"parkour_vest": {"name": "PARKOUR VEST", "slot": "torso", "desc": "Pockets and attitude. VAULT low obstacles & LEDGE GRAB.", "abil": "vault", "abil2": "ledge", "swag": -1, "col": Color(0.2, 0.4, 0.2), "col2": Color(0.8, 0.6, 0.1), "price": 280, "rarity": "uncommon"},
	# Pure style pieces (no ability): found, bought, or from buff clothes.
	"bucket_hat": {"name": "BUCKET HAT", "slot": "head", "desc": "Ugly. Lucky-ish.", "swag": -3, "col": Color(0.55, 0.6, 0.3), "col2": Color(0.3, 0.3, 0.1), "price": 30, "rarity": "common"},
	"top_hat": {"name": "TOP HAT", "slot": "head", "desc": "Distinguished degenerate.", "swag": 5, "col": Color(0.06, 0.06, 0.08), "col2": Color(0.8, 0.1, 0.2), "price": 250, "rarity": "rare"},
	"shades": {"name": "GOLD SHADES", "slot": "face", "desc": "Cool, in a bad way.", "swag": 4, "col": Color(0.95, 0.75, 0.2), "col2": Color(0.1, 0.1, 0.1), "price": 180, "rarity": "uncommon"},
	"eyepatch": {"name": "LUCKY EYEPATCH", "slot": "face", "desc": "Lost an eye on a bad beat.", "swag": 2, "col": Color(0.08, 0.08, 0.1), "col2": Color(0.3, 0.3, 0.3), "price": 90, "rarity": "common"},
	"fanny_pack": {"name": "FANNY PACK", "slot": "back", "desc": "It holds your chips. It hurts your pride.", "swag": -4, "col": Color(0.9, 0.3, 0.7), "col2": Color(0.2, 0.9, 0.9), "price": 40, "rarity": "common"},
	"cape": {"name": "HIGH-ROLLER CAPE", "slot": "back", "desc": "Because why not.", "swag": 6, "col": Color(0.5, 0.05, 0.15), "col2": Color(1, 0.8, 0.3), "price": 420, "rarity": "rare"},
	"gold_chain": {"name": "GOLD CHAIN", "slot": "neck", "desc": "Heavy. Shiny.", "swag": 4, "col": Color(1.0, 0.82, 0.25), "col2": Color(0.8, 0.6, 0.1), "price": 160, "rarity": "uncommon"},
	"bowtie": {"name": "BOW TIE", "slot": "neck", "desc": "Black tie, red eyes.", "swag": 3, "col": Color(0.1, 0.1, 0.12), "col2": Color(0.8, 0.1, 0.2), "price": 80, "rarity": "common"},
	"cargo_shorts": {"name": "CARGO SHORTS", "slot": "legs", "desc": "In winter.", "swag": -5, "col": Color(0.6, 0.55, 0.35), "col2": Color(0.4, 0.35, 0.2), "price": 20, "rarity": "common"},
	"tux_pants": {"name": "TUX TROUSERS", "slot": "legs", "desc": "Satin stripe, no regrets.", "swag": 5, "col": Color(0.07, 0.07, 0.09), "col2": Color(0.9, 0.9, 0.9), "price": 200, "rarity": "uncommon"},
	"hawaiian": {"name": "HAWAIIAN SHIRT", "slot": "torso", "desc": "Loud. A tourist's best friend.", "swag": -2, "col": Color(0.9, 0.4, 0.3), "col2": Color(0.3, 0.8, 0.8), "price": 60, "rarity": "common"},
}

## Base outfit per city tier (0..4) plus floor polish. Torso color, legs color, accent.
const TIERS := [
	{"name": "ALLEY RAGS", "torso": Color(0.30, 0.27, 0.25), "legs": Color(0.22, 0.20, 0.20), "accent": Color(0.45, 0.4, 0.35), "swag": -3},
	{"name": "HUSTLER'S HOODIE", "torso": Color(0.35, 0.22, 0.45), "legs": Color(0.18, 0.18, 0.28), "accent": Color(0.7, 0.5, 0.8), "swag": 0},
	{"name": "PIT-CREW POLO", "torso": Color(0.2, 0.35, 0.45), "legs": Color(0.2, 0.22, 0.3), "accent": Color(0.8, 0.8, 0.6), "swag": 2},
	{"name": "SHARP SUIT", "torso": Color(0.14, 0.14, 0.2), "legs": Color(0.12, 0.12, 0.16), "accent": Color(0.9, 0.2, 0.3), "swag": 5},
	{"name": "BLACK-CARD TUX", "torso": Color(0.05, 0.05, 0.07), "legs": Color(0.05, 0.05, 0.07), "accent": Color(1.0, 0.82, 0.3), "swag": 8},
]

const START_OUTFIT := ["thrift_sneakers"]


static func info(id: String) -> Dictionary:
	return ITEMS.get(id, {"name": "?", "slot": "torso", "desc": "", "swag": 0, "col": Color.GRAY, "col2": Color.DARK_GRAY, "price": 0, "rarity": "common"})


## Tier for a 1-based floor number: floors 1-5 city 1 etc. Within a city the
## outfit polish improves, so `tier_float` gives 0..4.99.
static func tier_float(floor_num: int) -> float:
	return clampf((floor_num - 1) / 5.0, 0.0, 4.99)


static func tier_for(floor_num: int) -> int:
	return int(tier_float(floor_num))


## Abilities granted by a worn list of item ids.
static func abilities(worn: Array) -> Dictionary:
	var out := {}
	for id in worn:
		var it: Dictionary = info(id)
		if it.has("abil"):
			out[it["abil"]] = true
		if it.has("abil2"):
			out[it["abil2"]] = true
	return out


## Total swag: tier base + worn items. Higher is sharper.
static func swag(worn: Array, floor_num: int) -> int:
	var s: int = TIERS[tier_for(floor_num)]["swag"]
	for id in worn:
		s += int(info(id)["swag"])
	return s


static func swag_label(v: int) -> String:
	if v <= -6: return "DUMPSTER FIRE"
	if v <= -2: return "UGLY"
	if v <= 3: return "MEH"
	if v <= 8: return "SHARP"
	if v <= 14: return "DAPPER"
	return "HIGH ROLLER"


static func item_in_slot(worn: Array, slot: String) -> String:
	for id in worn:
		if String(info(id)["slot"]) == slot:
			return id
	return ""


## Add an item, replacing whatever sits in the same slot (except it keeps the old one's ability only if it is re-worn).
static func wear(worn: Array, id: String) -> Array:
	var out: Array = []
	var slot: String = info(id)["slot"]
	for w in worn:
		if String(info(w)["slot"]) != slot:
			out.append(w)
	out.append(id)
	return out


## Draw worn clothes on the rig. ci = CanvasItem, xf = rig transform.
static func draw(ci: CanvasItem, rig, xf: Transform2D, worn: Array, floor_num: int, alpha: float) -> void:
	var tier: Dictionary = TIERS[tier_for(floor_num)]
	var hip: Vector2 = rig.pose["hip"]
	var tor: float = rig.pose["torso"]
	var torso_len: float = rig.s["torso_len"]
	# Base outfit torso overlay (a coloured jacket band) and legs tint.
	ci.draw_set_transform_matrix(xf * Transform2D(tor, hip))
	var tc: Color = tier["torso"]
	tc.a = 0.78 * alpha
	ci.draw_rect(Rect2(-3.2, -torso_len + 1.4, 6.4, torso_len - 2.0), tc)
	var ac: Color = tier["accent"]
	ac.a = alpha
	ci.draw_rect(Rect2(-0.4, -torso_len + 2.0, 0.8, torso_len - 3.0), ac)
	if tier_for(floor_num) >= 3:
		ci.draw_rect(Rect2(-1.2, -torso_len + 1.2, 2.4, 1.4), Color(1, 1, 1, alpha))
	ci.draw_set_transform_matrix(xf)
	for slot in ["legs", "feet"]:
		var id := item_in_slot(worn, slot)
		var feet: Array = [rig.pose["foot_f"], rig.pose["foot_b"]]
		var lc: Color = tier["legs"]
		if id != "":
			lc = info(id)["col"] if slot == "legs" else lc
		if slot == "legs":
			for f in feet:
				ci.draw_line(hip, (hip + (f as Vector2)) * 0.5, Color(lc, 0.6 * alpha), 2.7)
		else:
			var sc: Color = info(id)["col"] if id != "" else Color(0.25, 0.22, 0.2)
			var sc2: Color = info(id)["col2"] if id != "" else Color(0.4, 0.4, 0.4)
			for f in feet:
				var fp := f as Vector2
				ci.draw_rect(Rect2(fp.x - 2.0, fp.y - 2.4, 5.0, 2.6), Color(sc, alpha))
				ci.draw_rect(Rect2(fp.x - 2.0, fp.y - 0.4, 5.0, 0.8), Color(sc2, alpha))
	# Torso clothing, neck, back, hands, head, face.
	var tid := item_in_slot(worn, "torso")
	if tid != "":
		var it: Dictionary = info(tid)
		ci.draw_set_transform_matrix(xf * Transform2D(tor, hip))
		ci.draw_rect(Rect2(-3.4, -torso_len + 1.2, 6.8, torso_len - 1.8), Color(it["col"], 0.9 * alpha))
		ci.draw_rect(Rect2(-0.5, -torso_len + 1.2, 1.0, torso_len - 1.8), Color(it["col2"], alpha))
		if tid == "hawaiian":
			for i in 4:
				ci.draw_circle(Vector2(-2.0 + i * 1.4, -torso_len + 2.5 + (i % 2) * 2.0), 0.8, Color(it["col2"], alpha))
		ci.draw_set_transform_matrix(xf)
	var bid := item_in_slot(worn, "back")
	if bid != "":
		var itb: Dictionary = info(bid)
		ci.draw_set_transform_matrix(xf * Transform2D(tor, hip))
		if bid == "cape":
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-2, -torso_len + 1), Vector2(-7, 0), Vector2(-6, 3), Vector2(-1, -1)]), Color(itb["col"], alpha))
		else:
			ci.draw_rect(Rect2(-5.2, -4.2, 3.6, 2.4), Color(itb["col"], alpha))
			ci.draw_rect(Rect2(-5.2, -3.4, 3.6, 0.6), Color(itb["col2"], alpha))
		ci.draw_set_transform_matrix(xf)
	var nid := item_in_slot(worn, "neck")
	var neck: Vector2 = rig.neck()
	if nid != "":
		var itn: Dictionary = info(nid)
		ci.draw_set_transform_matrix(xf * Transform2D(tor, neck))
		if nid == "bowtie":
			ci.draw_colored_polygon(PackedVector2Array([Vector2(0, 0.6), Vector2(-2.4, -0.6), Vector2(-2.4, 1.8)]), Color(itn["col2"], alpha))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(0, 0.6), Vector2(2.4, -0.6), Vector2(2.4, 1.8)]), Color(itn["col2"], alpha))
		else:
			ci.draw_rect(Rect2(-2.8, 0.0, 5.6, 1.6), Color(itn["col"], alpha))
			if nid == "gold_chain":
				ci.draw_circle(Vector2(0.5, 2.4), 1.0, Color(itn["col2"], alpha))
		ci.draw_set_transform_matrix(xf)
	var hid := item_in_slot(worn, "hands")
	if hid != "":
		var ith: Dictionary = info(hid)
		for h in [rig.pose["hand_f"], rig.pose["hand_b"]]:
			ci.draw_circle(h as Vector2, 1.7, Color(ith["col"], alpha))
	var hdid := item_in_slot(worn, "head")
	if hdid != "":
		var ith2: Dictionary = info(hdid)
		var top: Vector2 = rig.head_point(Vector2(0, -3.5))
		ci.draw_set_transform_matrix(xf * Transform2D(float(rig.pose["torso"]) + float(rig.pose["head"]), top))
		if hdid == "top_hat":
			ci.draw_rect(Rect2(-3.0, -5.0, 6.0, 5.4), Color(ith2["col"], alpha))
			ci.draw_rect(Rect2(-4.6, 0.0, 9.2, 1.0), Color(ith2["col"], alpha))
			ci.draw_rect(Rect2(-3.0, -1.4, 6.0, 1.0), Color(ith2["col2"], alpha))
		else:
			ci.draw_rect(Rect2(-4.2, -2.0, 8.4, 2.8), Color(ith2["col"], alpha))
			ci.draw_rect(Rect2(-5.4, 0.2, 10.8, 0.9), Color(ith2["col2"], alpha))
		ci.draw_set_transform_matrix(xf)
	var fid := item_in_slot(worn, "face")
	if fid != "":
		var itf: Dictionary = info(fid)
		var eye: Vector2 = rig.head_point(Vector2(1.8, -0.2))
		ci.draw_set_transform_matrix(xf * Transform2D(float(rig.pose["torso"]) + float(rig.pose["head"]), eye))
		if fid == "eyepatch":
			ci.draw_rect(Rect2(-1.2, -1.2, 2.4, 2.4), Color(itf["col"], alpha))
		else:
			ci.draw_rect(Rect2(-1.6, -1.0, 4.4, 2.0), Color(itf["col"], alpha))
			ci.draw_rect(Rect2(-1.2, -0.6, 3.6, 1.2), Color(itf["col2"], alpha))
		ci.draw_set_transform_matrix(xf)
