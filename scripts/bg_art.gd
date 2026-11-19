extends RefCounted
## CraftPix background art (assets/bg) helpers: parallax skylines per city and
## layered street scenes. Every texture is cached in a static dictionary: a
## texture loaded inside _draw and then dropped is freed before the GPU draws it
## and renders as solid white.

static var _cache: Dictionary = {}

## Per city (0 Atlantic Shitty .. 4 The Strip): which skyline set, its tint, which street.
## tint multiplies the art; glow is the horizon glow colour.
const CITY := [
	{"sky": 1, "street": 1, "tint": Color(0.55, 0.45, 0.62), "glow": Color(0.9, 0.45, 0.25, 0.22)},
	{"sky": 2, "street": 2, "tint": Color(0.75, 0.55, 0.45), "glow": Color(1.0, 0.5, 0.2, 0.25)},
	{"sky": 3, "street": 3, "tint": Color(0.4, 0.7, 0.7), "glow": Color(0.3, 0.9, 0.8, 0.2)},
	{"sky": 6, "street": 3, "tint": Color(0.85, 0.5, 0.95), "glow": Color(1.0, 0.3, 0.8, 0.25)},
	{"sky": 4, "street": 4, "tint": Color(1.0, 0.75, 0.9), "glow": Color(1.0, 0.75, 0.4, 0.3)},
]
## Back-to-front draw order of each street's layers.
const STREET := {
	1: ["Sky", "City1", "buildings", "wall1", "wall2", "boxes_container", "wheels_hydrant", "road_border"],
	2: ["Sky", "City2", "back", "houses3", "houses1", "minishop_callbox", "road_lamps"],
	3: ["sky", "City3", "houses3", "houded2", "houses1", "crosswalk", "road"],
	4: ["Sky", "City4", "houses2", "houses1", "houses", "fountain_bush", "umbrella_policebox", "road"],
}


static func tex(path: String) -> Texture2D:
	if not _cache.has(path):
		_cache[path] = load(path) if ResourceLoader.exists(path) else null
	return _cache[path]


static func city_info(city: int) -> Dictionary:
	return CITY[clampi(city, 0, CITY.size() - 1)]


## Parallax skyline layers (back to front), drawn tiled in `rect` (any space).
## `scroll` is the camera x in the rect's units; layer i moves at speeds[i]*scroll
## (plus drift*t so it also drifts by itself). tint darkens/colours the art.
static func skyline(ci: CanvasItem, rect: Rect2, city: int, scroll: float, t: float, tint_mul := 1.0, drift := 0.0, speeds: Array = [0.0, 0.03, 0.06, 0.1, 0.16, 0.24], from_layer := 1) -> void:
	var info := city_info(city)
	var tint: Color = info["tint"]
	tint = Color(tint.r * tint_mul, tint.g * tint_mul, tint.b * tint_mul, 1.0)
	var sc := rect.size.y / 324.0
	for li in range(from_layer, 7):
		var tx := tex("res://assets/bg/skyline_%d/%d.png" % [info["sky"], li])
		if tx == null:
			continue
		var w := tx.get_width() * sc
		var sp: float = speeds[mini(li - 1, speeds.size() - 1)]
		var off := fposmod(scroll * sp + t * drift * li, w)
		var x := rect.position.x - off
		while x < rect.end.x:
			ci.draw_texture_rect(tx, Rect2(x, rect.position.y, w, tx.get_height() * sc), false, tint)
			x += w


## A layered street scene scaled to fill `rect` (1920x1080 art). Returns false if missing.
static func street(ci: CanvasItem, rect: Rect2, which: int, tint := Color.WHITE, scroll := 0.0, par := 0.0) -> bool:
	if not STREET.has(which):
		return false
	var names: Array = STREET[which]
	var ok := false
	for i in names.size():
		var tx := tex("res://assets/bg/street_%d/%s.png" % [which, names[i]])
		if tx == null:
			continue
		ok = true
		var sc := rect.size.y / float(tx.get_height())
		var w := tx.get_width() * sc
		var f := par * float(i) / float(names.size())
		var x := rect.position.x - fposmod(scroll * f, w) if par > 0.0 else rect.position.x
		while x < rect.end.x:
			ci.draw_texture_rect(tx, Rect2(x, rect.position.y, w, rect.size.y), false, tint)
			x += w
			if par <= 0.0:
				break
	return ok
