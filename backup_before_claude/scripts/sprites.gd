extends RefCounted
## Pixel-art character models, authored as text maps and baked to textures at
## runtime. Edit a map, hit play. Every sprite faces RIGHT; code flips it.
## One character = one pixel; '.' is transparent; rows auto-pad to the widest.

const RUNNER_PAL := {
	"K": Color(0.06, 0.03, 0.09),   # outline
	"P": Color(0.30, 0.18, 0.45),   # hood
	"p": Color(0.47, 0.31, 0.64),   # hood highlight
	"S": Color(0.93, 0.74, 0.58),   # skin
	"G": Color(1.00, 0.80, 0.30),   # gold goggles
	"R": Color(0.90, 0.16, 0.26),   # scarf
	"J": Color(0.17, 0.14, 0.28),   # jacket
	"j": Color(0.31, 0.26, 0.47),   # jacket highlight
	"B": Color(0.50, 0.32, 0.15),   # belt
	"g": Color(1.00, 0.86, 0.36),   # chip buckle
	"L": Color(0.11, 0.10, 0.17),   # pants
	"W": Color(0.92, 0.92, 0.96),   # sneakers
}

const GUARD_PAL := {
	"K": Color(0.03, 0.03, 0.04),
	"S": Color(0.80, 0.62, 0.48),
	"s": Color(0.66, 0.48, 0.36),
	"D": Color(0.02, 0.02, 0.03),   # shades
	"d": Color(0.35, 0.55, 0.75),   # shade glint
	"J": Color(0.10, 0.10, 0.13),   # suit
	"j": Color(0.20, 0.20, 0.25),
	"W": Color(0.95, 0.95, 0.95),   # shirt
	"R": Color(0.90, 0.10, 0.20),   # bow tie
	"L": Color(0.07, 0.07, 0.09),
}

const BAT_PAL := {
	"K": Color(0.08, 0.02, 0.10),
	"P": Color(0.45, 0.20, 0.60),
	"p": Color(0.62, 0.34, 0.78),
	"R": Color(1.00, 0.25, 0.25),
	"w": Color(1.00, 1.00, 1.00),
}

# --- Runner ---------------------------------------------------------------

const R_TOP := [
	"...KKKKK....",
	"..KPPPPPK...",
	".KPppPPPPK..",
	".KPpPPPPPPK.",
	".KPPPKSSSSK.",
	".KPPKGGGGGGK",
	".KPPKSSSSSK.",
	"..KPPKSSSK..",
	"...KRRRRRK..",
	"..KJjRRJJJK.",
	".KJjjJJJJJK.",
	".KJjJJJJJSK.",
	".KSjJJJJJSK.",
	".KBBBBgBBBK.",
]

const R_ARMS_UP := [
	".......KSSK.",
	"......KjSK..",
	"......KjK...",
]

const R_LEGS_STAND := [
	"..KLLLLLLK..",
	"..KLLKKLLK..",
	"..KLLK.KLLK.",
	"..KLLK.KLLK.",
	"..KLLK.KLLK.",
	"..KLLK.KLLK.",
	".KWWWK.KWWWK",
	".KKKKK.KKKKK",
]

const R_LEGS_CROUCH := [
	"..KLLLLLLK..",
	"..KLLKKLLK..",
	"..KLLK.KLLK.",
	"..KLLK.KLLK.",
	"..KLLK.KLLK.",
	".KWWWK.KWWWK",
	".KKKKK.KKKKK",
]

const R_LEGS_RUN_A := [
	"..KLLLLLLK..",
	"..KLLLKLLLK.",
	".KLLK..KLLK.",
	".KLK....KLLK",
	"KLLK.....KLK",
	"KWK......KWW",
	"KK.......KKK",
]

const R_LEGS_RUN_B := [
	"..KLLLLLLK..",
	"...KLLLLK...",
	"...KLLLLK...",
	"...KLLKLLK..",
	"...KLKKLLK..",
	"..KWWKKWWWK.",
	"..KKK.KKKKK.",
]

const R_LEGS_RUN_C := [
	"..KLLLLLLK..",
	"..KLLKLLLK..",
	"..KLLK.KLLK.",
	".KLLK..KLLK.",
	".KLK...KLK..",
	"KWWK...KWWK.",
	"KKK....KKK..",
]

const R_LEGS_JUMP := [
	"..KLLLLLLK..",
	"..KLLKLLLLK.",
	".KLLK.KLLK..",
	".KWWK.KLLK..",
	".KKK..KWWWK.",
	"......KKKK..",
]

const R_LEGS_FALL := [
	"..KLLLLLLK..",
	".KLLKKKKLLK.",
	".KLLK..KLLK.",
	"KLLK....KLLK",
	"KWWK....KWWK",
	"KKKK....KKKK",
]

const R_SLIDE := [
	".......KKKKK....",
	"......KPPPPPK...",
	".....KPpPPKSSK..",
	".....KPPPKGGGGK.",
	"....KRRRRKSSSK..",
	"..KKJJjjJJKKK...",
	".KJJJJJJJBgLLLK.",
	"KSKJJJJJBBLLLLWK",
	"KKKKKKKKKKKKKKKK",
]

# --- Guard ----------------------------------------------------------------

const G_TOP := [
	"...KKKKKK...",
	"..KSSSSSSK..",
	".KSSSSSSSSK.",
	".KSsKDDDDdK.",
	".KSSSSSSSSK.",
	"..KSssssSK..",
	".KKKWRRWKKK.",
	"KJjJJWWJJJJK",
	"KJjJJWWJJJJK",
	"KSJJJJJJJJSK",
	".KJJJJJJJJK.",
]

const G_LEGS_A := [
	".KLLLKKLLLK.",
	".KLLK..KLLK.",
	".KLLK..KLLK.",
	"KKKKK..KKKKK",
]

const G_LEGS_B := [
	"..KLLLLLLK..",
	"..KLLKKLLK..",
	"...KLLLLK...",
	"..KKKKKKKK..",
]

# --- Bat ------------------------------------------------------------------

const B_UP := [
	"KK............KK",
	"KpK..........KpK",
	"KppK..KKKK..KppK",
	".KppKKPPPPKKppK.",
	".KpppKPRPRKpppK.",
	"..KppKPPPPKppK..",
	"...KKKPwwPKKK...",
	"......KKKK......",
]

const B_DOWN := [
	"......KKKK......",
	".....KPPPPK.....",
	"....KKPRPRKK....",
	"..KKppPPPPppKK..",
	".KpppKPwwPKpppK.",
	"KppKK.KKKK.KKppK",
	"KpK..........KpK",
	"KK............KK",
]

const B_HANG := [
	"..KK..",
	".KPPK.",
	"KpPPpK",
	"KpPPpK",
	"KpPPpK",
	"KpwwpK",
	".KRRK.",
	"..KK..",
]

# --- Rig parts (used by rig.gd) -------------------------------------------

const R_HEAD := [
	"...KKKKK....",
	"..KPPPPPK...",
	".KPppPPPPK..",
	".KPpPPPPPPK.",
	".KPPPKSSSSK.",
	".KPPKGGGGGGK",
	".KPPKSSSSSK.",
	"..KPPKSSSK..",
]

const R_TORSO := [
	"..KRRRK.",
	".KJjRRJK",
	"KJjjJJJK",
	"KJjJJJJK",
	"KJjJJJJK",
	"KJjJJJJK",
	"KBBBgBBK",
	".KLLLLK.",
]

const G_HEAD := [
	"...KKKKKK...",
	"..KSSSSSSK..",
	".KSSSSSSSSK.",
	".KSsKDDDDdK.",
	".KSSSSSSSSK.",
	"..KSssssSK..",
]

const G_TORSO := [
	"...KWRRWK...",
	"..KJjWWJJK..",
	".KJjJWWJJJK.",
	"KJjJJWWJJJJK",
	"KJjJJWWJJJJK",
	"KJjJJJJJJJJK",
	"KJjJJJJJJJJK",
	"KJJJJJJJJJJK",
	".KLLLLLLLLK.",
]

# --- Bosses -----------------------------------------------------------------

const BOSS_PALS := [
	{   # Big Sal: grey pinstripe, red tie, cigar
		"K": Color(0.04, 0.03, 0.04), "S": Color(0.86, 0.66, 0.52), "s": Color(0.7, 0.5, 0.4),
		"D": Color(0.05, 0.05, 0.06), "H": Color(0.25, 0.18, 0.15), "G": Color(1, 0.55, 0.2),
		"W": Color(0.95, 0.95, 0.95), "R": Color(0.85, 0.1, 0.15), "J": Color(0.32, 0.32, 0.38),
		"j": Color(0.46, 0.46, 0.53), "L": Color(0.2, 0.2, 0.24),
	},
	{   # Madame Roulette: red dress, red hair, gold
		"K": Color(0.06, 0.02, 0.04), "S": Color(0.95, 0.78, 0.68), "H": Color(0.75, 0.08, 0.15),
		"G": Color(1, 0.82, 0.3), "R": Color(0.82, 0.08, 0.16), "r": Color(0.55, 0.04, 0.1),
		"W": Color(1, 1, 1), "J": Color(0.82, 0.08, 0.16), "j": Color(0.55, 0.04, 0.1), "L": Color(0.1, 0.02, 0.04),
	},
	{   # The House: gold mask, black suit, the eye
		"K": Color(0.02, 0.01, 0.03), "M": Color(0.95, 0.75, 0.3), "E": Color(0.4, 1, 0.95),
		"G": Color(1, 0.8, 0.3), "W": Color(0.9, 0.9, 0.95), "D": Color(0.5, 0.05, 0.1),
		"J": Color(0.07, 0.06, 0.09), "j": Color(0.16, 0.14, 0.2), "L": Color(0.05, 0.04, 0.06),
	},
]

const BOSS_HEADS := [
	[
		"...KKKKKK...",
		"..KSSSSSSK..",
		".KSSSSSSSSK.",
		".KSSKDSSKDK.",
		".KSSSSSSSSK.",
		".KSHHHHHHSKGG",
		"..KSSSSSSK..",
	],
	[
		"..KKKKKKKK..",
		".KHHHHHHHHK.",
		"KHHHSSSSSHHK",
		"KHHSKSSKSHHK",
		"KHHSSSSSSHHK",
		"KHHSSRRSSHGK",
		".KHHSSSSHHK.",
		"..KK.KK.KK..",
	],
	[
		"..KKKKKKKK..",
		".KMMMMMMMMK.",
		"KMMMMMMMMMMK",
		"KMMKEEKKEEMK",
		"KMMMMMMMMMMK",
		"KMMMMKKMMMMK",
		".KMMMMMMMMK.",
		"..KKKKKKKK..",
	],
]

const BOSS_TORSOS := [
	[
		"...KWRRWK...",
		"..KjJWRWJjK.",
		".KJjJWRWJjJK",
		"KJjJjWRWjJjK",
		"KJjJjJRJjJjK",
		"KJjJjJJJjJjK",
		"KJjJjJJJjJjK",
		"KJJJJJJJJJJK",
		".KLLLLLLLLK.",
	],
	[
		"...KGGGGK...",
		"..KSRGGRSK..",
		".KRRRRRRRRK.",
		"KRrRRRRRRrRK",
		"KRrRRRRRRrRK",
		".KRrRRRRrRK.",
		".KRrRRRRrRK.",
		"KRRrRRRRrRRK",
		"KKKKKKKKKKKK",
	],
	[
		"...KWDDWK...",
		"..KJJWDWJJK.",
		".KJJJWDWJJJK",
		"KJjJJGGGJJjK",
		"KJjJGEEEGJjK",
		"KJjJJGGGJJjK",
		"KJjJJJJJJJjK",
		"KJJJJJJJJJJK",
		".KLLLLLLLLK.",
	],
]

static var _cache := {}


static func bake(rows: Array, pal: Dictionary) -> ImageTexture:
	var w := 0
	for r in rows:
		w = maxi(w, (r as String).length())
	var img := Image.create_empty(w, rows.size(), false, Image.FORMAT_RGBA8)
	for y in rows.size():
		var r: String = rows[y]
		for x in r.length():
			var ch := r[x]
			if pal.has(ch):
				img.set_pixel(x, y, pal[ch])
	return ImageTexture.create_from_image(img)


static func runner() -> Dictionary:
	if _cache.has("runner"):
		return _cache["runner"]
	var f := {
		"idle0": bake(R_TOP + R_LEGS_STAND, RUNNER_PAL),
		"idle1": bake(R_TOP + R_LEGS_CROUCH, RUNNER_PAL),
		"run0": bake(R_TOP + R_LEGS_RUN_A, RUNNER_PAL),
		"run1": bake(R_TOP + R_LEGS_RUN_B, RUNNER_PAL),
		"run2": bake(R_TOP + R_LEGS_RUN_C, RUNNER_PAL),
		"run3": bake(R_TOP + R_LEGS_RUN_B, RUNNER_PAL),
		"jump": bake(R_TOP + R_LEGS_JUMP, RUNNER_PAL),
		"fall": bake(R_TOP + R_LEGS_FALL, RUNNER_PAL),
		"hang": bake(R_ARMS_UP + R_TOP + R_LEGS_STAND, RUNNER_PAL),
		"slide": bake(R_SLIDE, RUNNER_PAL),
	}
	_cache["runner"] = f
	return f


## Row (from the top of each frame) where the scarf knot sits.
static func runner_neck(frame: String) -> float:
	if frame == "slide":
		return 4.5
	if frame == "hang":
		return 11.5
	return 8.5


static func guard() -> Array:
	if not _cache.has("guard"):
		_cache["guard"] = [bake(G_TOP + G_LEGS_A, GUARD_PAL), bake(G_TOP + G_LEGS_B, GUARD_PAL)]
	return _cache["guard"]


static func bat() -> Array:
	if not _cache.has("bat"):
		_cache["bat"] = [bake(B_UP, BAT_PAL), bake(B_DOWN, BAT_PAL), bake(B_HANG, BAT_PAL)]
	return _cache["bat"]
