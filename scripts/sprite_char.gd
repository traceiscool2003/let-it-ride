extends RefCounted
## Sprite-sheet characters (CraftPix packs in res://assets/chars, see LICENSE.txt).
## Every sheet is a row of 128x128 frames. frames(sheet) builds a SpriteFrames
## with whatever animations that character has; recolor() returns the shader that
## tweaks a sheet so it's ours (Rico's couch-bum rags, his dark hair at the top).

const FRAME := 128
const ROOT := "res://assets/chars/"

## Rico's look per outfit tier (5 cities): couch bum -> high roller.
const RICO_TIERS := [
	{"sheet": "city_men_1", "recolor": 1},   # couch bum: dirty washed-out shirt, grey overalls
	{"sheet": "city_men_1", "recolor": 0},   # working stiff: the orange shirt, clean-ish
	{"sheet": "gangsters_2", "recolor": 0},  # hustler: shirt, suspenders, slacks
	{"sheet": "city_men_3", "recolor": 0},   # leather & luck: leather jacket, shades
	{"sheet": "gangsters_3", "recolor": 2},  # high roller: the suit, hair dyed back to Rico's brown
]

## Animation name -> [file, fps, loops]. Missing files are skipped.
const ANIMS := {
	"idle": ["Idle", 8.0, true], "idle2": ["Idle_2", 9.0, true], "walk": ["Walk", 11.0, true], "run": ["Run", 15.0, true],
	"jump": ["Jump", 12.0, false], "hurt": ["Hurt", 14.0, false], "dead": ["Dead", 10.0, false],
	"attack": ["Attack", 20.0, false], "attack_1": ["Attack_1", 20.0, false], "attack_2": ["Attack_2", 20.0, false],
	"attack_3": ["Attack_3", 20.0, false], "shot": ["Shot", 16.0, false], "recharge": ["Recharge", 14.0, false],
}

static var _cache := {}
static var _shader: Shader


static func frames(sheet: String) -> SpriteFrames:
	if _cache.has(sheet):
		return _cache[sheet]
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	for anim in ANIMS:
		var def: Array = ANIMS[anim]
		var path := ROOT + sheet + "/" + String(def[0]) + ".png"
		if not ResourceLoader.exists(path):
			continue
		var tex: Texture2D = load(path)
		var n := int(tex.get_width() / FRAME)
		sf.add_animation(anim)
		sf.set_animation_speed(anim, float(def[1]))
		sf.set_animation_loop(anim, bool(def[2]))
		for i in n:
			var at := AtlasTexture.new()
			at.atlas = tex
			at.region = Rect2(i * FRAME, 0, FRAME, FRAME)
			sf.add_frame(anim, at)
	if not sf.has_animation("attack") and sf.has_animation("attack_1"):
		sf.add_animation("attack")
		sf.set_animation_speed("attack", 20.0)
		sf.set_animation_loop("attack", false)
		for i in sf.get_frame_count("attack_1"):
			sf.add_frame("attack", sf.get_frame_texture("attack_1", i))
	_cache[sheet] = sf
	return sf


## 0 = as drawn, 1 = couch-bum rags, 2 = Rico's brown hair. `flash` whites out on hit.
static func material(mode: int) -> ShaderMaterial:
	if _shader == null:
		_shader = Shader.new()
		_shader.code = SHADER
	var m := ShaderMaterial.new()
	m.shader = _shader
	m.set_shader_parameter("mode", mode)
	return m


## A sheet recoloured for an enemy: hue-shift the clothes, scale saturation/brightness.
static func material_hue(hue: float, sat := 1.0, val := 1.0) -> ShaderMaterial:
	var m := material(0)
	m.set_shader_parameter("hue_shift", hue)
	m.set_shader_parameter("sat_mul", sat)
	m.set_shader_parameter("val_mul", val)
	return m


const SHADER := """
shader_type canvas_item;
uniform int mode = 0;
uniform float flash = 0.0;
uniform float hue_shift = 0.0;   // 0..1 turn applied to clothes (skin tones are skipped)
uniform float val_mul = 1.0;
uniform float sat_mul = 1.0;

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec3 hsv = rgb2hsv(col.rgb);
	if (mode == 1) {
		// Couch bum: the bright orange shirt becomes a dingy, stained off-white,
		// and the navy overalls fade to a tired grey.
		if (hsv.x > 0.02 && hsv.x < 0.13 && hsv.y > 0.62 && hsv.z > 0.35) {
			float v = hsv.z;
			col.rgb = mix(vec3(0.78, 0.74, 0.62), vec3(0.62, 0.56, 0.42), 1.0 - v) * (0.75 + 0.35 * v);
		} else if (hsv.x > 0.5 && hsv.x < 0.75 && hsv.y > 0.15) {
			col.rgb = hsv2rgb(vec3(hsv.x, hsv.y * 0.15, hsv.z * 1.15));
		}
	} else if (mode == 2) {
		// High roller: blond hair dyed to Rico's dark brown.
		if (hsv.x > 0.095 && hsv.x < 0.18 && hsv.y > 0.3 && hsv.z > 0.45) {
			col.rgb = hsv2rgb(vec3(0.07, 0.55, hsv.z * 0.32));
		}
	}
	if (hue_shift != 0.0 || val_mul != 1.0 || sat_mul != 1.0) {
		vec3 h2 = rgb2hsv(col.rgb);
		bool skin = h2.x < 0.12 && h2.y < 0.82 && h2.y > 0.12;
		if (!skin && h2.y > 0.12) {
			h2.x = fract(h2.x + hue_shift);
		}
		h2.y = clamp(h2.y * sat_mul, 0.0, 1.0);
		h2.z = clamp(h2.z * val_mul, 0.0, 1.0);
		col.rgb = hsv2rgb(h2);
	}
	col.rgb = mix(col.rgb, vec3(1.0), flash);
	COLOR = col;
}
"""
