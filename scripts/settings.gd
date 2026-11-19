extends RefCounted
## The SETTINGS screen: Graphics, Audio, Gameplay, Accessibility, Controls.
## Opened from the title screen and the pause menu. Values live in `values`
## and are saved with the game; main.gd's _apply_settings() pushes them into
## the engine, shaders, audio buses and gameplay code.
##
## To add an option: add an entry to the right tab in _build(), give it a
## default, then read it in main.gd with settings.val("your_id").

const TABS := ["GRAPHICS", "AUDIO", "GAMEPLAY", "ACCESSIBILITY", "CONTROLS"]
const GOLD := Color(1.0, 0.78, 0.25)
const DIM := Color(0.72, 0.68, 0.8)
const CYAN := Color(0.45, 0.9, 1.0)

## Keyboard actions the player can rebind, with display names.
const BINDABLE := [
	["left", "Move Left"], ["right", "Move Right"], ["up", "Up / Interact"], ["down", "Down / Slide"],
	["jump", "Jump / Confirm"], ["dash", "Air Dash"], ["attack", "Strike"], ["parry", "Parry"], ["focus", "Focus (Heal)"],
	["pause", "Pause / Back"], ["restart", "Quick Restart"],
]

var values := {}
var options := {}
var tab := 0
var row := -1
var rebinding := ""
var msg := ""
var t := 0.0


func _init() -> void:
	_build()
	for tb in options:
		for o in options[tb]:
			if o.has("def"):
				values[o["id"]] = o["def"]
	values["binds"] = {}


static func _pct(step := 0.1) -> Array:
	var out: Array = []
	var v := 0.0
	while v <= 1.0001:
		out.append([snappedf(v, 0.01), "%d%%" % int(round(v * 100))])
		v += step
	return out


func _build() -> void:
	var onoff := [[true, "On"], [false, "Off"]]
	options = {
		"GRAPHICS": [
			{"id": "window", "label": "Window Mode", "vals": [["windowed", "Windowed"], ["fullscreen", "Fullscreen"], ["exclusive", "Exclusive Fullscreen"]], "def": "windowed", "desc": "Fullscreen is borderless. Exclusive can give slightly lower input lag."},
			{"id": "res", "label": "Window Size", "vals": [[Vector2i(1280, 720), "1280 x 720"], [Vector2i(1600, 900), "1600 x 900"], [Vector2i(1920, 1080), "1920 x 1080"], [Vector2i(2560, 1440), "2560 x 1440"]], "def": Vector2i(1280, 720), "desc": "Size of the window in Windowed mode. The game always scales to fit."},
			{"id": "vsync", "label": "V-Sync", "vals": onoff, "def": true, "desc": "Locks the frame rate to your monitor to stop screen tearing."},
			{"id": "fps", "label": "Frame Rate Limit", "vals": [[30, "30"], [60, "60"], [120, "120"], [144, "144"], [240, "240"], [0, "Unlimited"]], "def": 0, "desc": "Cap the frame rate (useful with V-Sync off or on laptops)."},
			{"id": "bloom", "label": "Bloom / Glow", "vals": [[0.0, "Off"], [0.5, "Low"], [1.0, "High"], [1.5, "Ultra"]], "def": 1.0, "desc": "How much neon, chips and lights glow."},
			{"id": "vignette", "label": "Vignette", "vals": onoff, "def": true, "desc": "Darkens the screen edges for a cinematic look."},
			{"id": "shadows", "label": "Dynamic Shadows", "vals": [[0, "Off"], [1, "Hard"], [2, "Soft"]], "def": 2, "desc": "Real-time shadows from lamps. Turn off for more speed on older PCs."},
			{"id": "particles", "label": "Particles", "vals": [[0.35, "Low"], [1.0, "Normal"], [1.6, "Extra"]], "def": 1.0, "desc": "Sparks, dust, debris and chip bursts."},
			{"id": "ambient", "label": "Light Rays & Dust", "vals": onoff, "def": true, "desc": "Volumetric light cones under lamps and drifting dust."},
			{"id": "foliage", "label": "Grass & Vines", "vals": onoff, "def": true, "desc": "Reactive grass, swinging vines and glowing mushrooms."},
			{"id": "show_fps", "label": "Show FPS", "vals": [[false, "Off"], [true, "On"]], "def": false, "desc": "Frame counter in the corner."},
		],
		"AUDIO": [
			{"id": "master", "label": "Master Volume", "vals": _pct(), "def": 1.0, "desc": "Everything."},
			{"id": "music", "label": "Music Volume", "vals": _pct(), "def": 0.8, "desc": "The piano and the drum-and-bass."},
			{"id": "sfx", "label": "Sound Effects Volume", "vals": _pct(), "def": 0.8, "desc": "Chips, hits, slots, doors."},
			{"id": "blips", "label": "Dialogue Blips", "vals": onoff, "def": true, "desc": "The little sound when dialogue advances."},
			{"id": "mute_unfocused", "label": "Mute When Unfocused", "vals": onoff, "def": true, "desc": "Silence the game when you tab out."},
		],
		"GAMEPLAY": [
			{"id": "shake", "label": "Screen Shake", "vals": _pct(0.25), "def": 1.0, "desc": "Camera shake on hits, slams and jackpots."},
			{"id": "hitstop", "label": "Hit Freeze", "vals": onoff, "def": true, "desc": "The tiny freeze-frame that makes hits feel heavy."},
			{"id": "lookahead", "label": "Camera Lookahead", "vals": [[0.0, "Off"], [0.5, "Low"], [1.0, "Normal"], [1.4, "Far"]], "def": 1.0, "desc": "How far the camera leads in the direction you're running."},
			{"id": "text_speed", "label": "Text Speed", "vals": [[30.0, "Slow"], [55.0, "Normal"], [110.0, "Fast"], [9999.0, "Instant"]], "def": 55.0, "desc": "How fast dialogue types out."},
			{"id": "cutscenes", "label": "Cutscenes", "vals": [["always", "Always Play"], ["first", "First Time Only"], ["off", "Off (dialogue only)"]], "def": "always", "desc": "Boss entrances and story scenes. Dialogue still plays when they're off."},
			{"id": "load_screens", "label": "Loading Screens", "vals": [["full", "Full Art"], ["quick", "Quick"]], "def": "full", "desc": "Full shows each floor's painting a little longer. Quick gets you in faster."},
			{"id": "tips", "label": "Tips", "vals": onoff, "def": true, "desc": "One-time tips the first time you meet each system."},
			{"id": "barks", "label": "House Announcements", "vals": onoff, "def": true, "desc": "The House's comments over the PA."},
			{"id": "timer", "label": "Run Timer", "vals": onoff, "def": true, "desc": "Show the run clock under the floor track."},
			{"id": "hints", "label": "Control Hints", "vals": onoff, "def": true, "desc": "Button reminders at the bottom of the screen."},
		],
		"ACCESSIBILITY": [
			{"id": "assist_speed", "label": "Game Speed (Assist)", "vals": [[1.0, "100%"], [0.85, "85%"], [0.7, "70%"], [0.55, "55%"]], "def": 1.0, "desc": "Slow the whole game down. Daily Deal scores aren't recorded with Assist on."},
			{"id": "assist_invincible", "label": "Invincible (Assist)", "vals": [[false, "Off"], [true, "On"]], "def": false, "desc": "Nothing can hurt you. The story still works normally."},
			{"id": "flash", "label": "Reduce Flashing", "vals": [[false, "Off"], [true, "On"]], "def": false, "desc": "Softens red hit flashes and other bright flashes."},
			{"id": "hurt_vignette", "label": "Low-Life Red Glow", "vals": onoff, "def": true, "desc": "The pulsing red edge when you're on your last life."},
			{"id": "slowmo_fx", "label": "Slow-Motion Color Fade", "vals": onoff, "def": true, "desc": "The desaturated look during parries and big moments."},
		],
		"CONTROLS": [],
	}


func val(id: String):
	return values.get(id)


func set_val(id: String, v) -> void:
	values[id] = v


func _rows() -> Array:
	var name: String = TABS[tab]
	if name == "CONTROLS":
		var out: Array = []
		for b in BINDABLE:
			out.append({"id": "bind_" + b[0], "label": b[1], "action": b[0]})
		out.append({"id": "reset_controls", "label": "Reset Controls to Default"})
		out.append({"id": "reset_all", "label": "Reset ALL Settings"})
		return out
	return options[name]


func _cycle(o: Dictionary, dir: int) -> void:
	var vals: Array = o["vals"]
	var cur = values.get(o["id"])
	var i := 0
	for k in vals.size():
		if typeof(vals[k][0]) == typeof(cur) and vals[k][0] == cur:
			i = k
		elif typeof(cur) == TYPE_FLOAT and typeof(vals[k][0]) == TYPE_FLOAT and absf(float(vals[k][0]) - float(cur)) < 0.001:
			i = k
	i = clampi(i + dir, 0, vals.size() - 1) if vals.size() > 2 else (i + 1) % vals.size()
	values[o["id"]] = vals[i][0]


func value_label(o: Dictionary) -> String:
	var cur = values.get(o["id"])
	for v in o["vals"]:
		if typeof(v[0]) == typeof(cur) and v[0] == cur:
			return v[1]
		if typeof(cur) == TYPE_FLOAT and typeof(v[0]) == TYPE_FLOAT and absf(float(v[0]) - float(cur)) < 0.001:
			return v[1]
	return str(cur)


## Returns "changed", "back", "rebind", "reset_controls", "reset_all" or "".
func press(action: String) -> String:
	var rows := _rows()
	match action:
		"up":
			row = maxi(-1, row - 1)
			Sfx.play("tick")
		"down":
			row = mini(rows.size() - 1, row + 1)
			Sfx.play("tick")
		"left", "right":
			var d := -1 if action == "left" else 1
			if row < 0:
				tab = (tab + TABS.size() + d) % TABS.size()
				Sfx.play("tick")
			else:
				var o: Dictionary = rows[row]
				if o.has("vals"):
					_cycle(o, d)
					Sfx.play("tick")
					return "changed"
		"confirm":
			if row < 0:
				tab = (tab + 1) % TABS.size()
				Sfx.play("tick")
				return ""
			var o: Dictionary = rows[row]
			if o.has("vals"):
				_cycle(o, 1)
				Sfx.play("tick")
				return "changed"
			if o.has("action"):
				rebinding = o["action"]
				msg = "Press a key for %s   (ESC cancels)" % o["label"]
				Sfx.play("door")
				return "rebind"
			if o["id"] == "reset_controls" or o["id"] == "reset_all":
				Sfx.play("buy")
				return o["id"]
		"back":
			Sfx.play("tick")
			return "back"
	return ""


func reset_all() -> void:
	var binds: Dictionary = {}
	_init()
	values["binds"] = binds


# ---------------------------------------------------------------- drawing

func _txt(ci: CanvasItem, f: Font, pos: Vector2, s: String, sz: int, col: Color, width := -1.0, align := HORIZONTAL_ALIGNMENT_LEFT) -> void:
	ci.draw_string_outline(f, pos, s, align, width, sz, maxi(4, sz / 5), Color(0, 0, 0, 0.85 * col.a))
	ci.draw_string(f, pos, s, align, width, sz, col)


static func key_names(action: String) -> String:
	var names: Array = []
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			var k: int = (ev as InputEventKey).physical_keycode
			names.append(OS.get_keycode_string(k))
	return " / ".join(names) if names.size() > 0 else "(none)"


func draw(ci: CanvasItem, f: Font, delta: float) -> void:
	t += delta
	ci.draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.0, 0.04, 0.9))
	var panel := Rect2(110, 40, 1060, 640)
	ci.draw_rect(panel.grow(5), Color(0.5, 0.36, 0.14))
	ci.draw_rect(panel, Color(0.05, 0.02, 0.08, 0.98))
	_txt(ci, f, Vector2(panel.position.x, 96), "SETTINGS", 44, GOLD, panel.size.x, HORIZONTAL_ALIGNMENT_CENTER)
	# Tabs.
	var tw := panel.size.x / TABS.size()
	for i in TABS.size():
		var r := Rect2(panel.position.x + i * tw + 8, 116, tw - 16, 40)
		var on := i == tab
		ci.draw_rect(r, Color(GOLD, 0.18) if on else Color(0, 0, 0, 0.4))
		ci.draw_rect(r, GOLD if on else Color(1, 1, 1, 0.12), false, 2.0 if on else 1.0)
		if on and row < 0:
			ci.draw_rect(r.grow(4.0 + sin(t * 6.0) * 1.5), Color(GOLD, 0.4), false, 2.0)
		_txt(ci, f, Vector2(r.position.x, r.position.y + 27), TABS[i], 18, Color.WHITE if on else DIM, r.size.x, HORIZONTAL_ALIGNMENT_CENTER)
	# Rows.
	var rows := _rows()
	var top := 0
	var max_rows := 10
	if row >= max_rows:
		top = row - max_rows + 1
	for k in mini(max_rows, rows.size() - top):
		var i := top + k
		var o: Dictionary = rows[i]
		var r := Rect2(150, 176 + k * 42, 980, 36)
		var sel := i == row
		ci.draw_rect(r, Color(1, 1, 1, 0.07) if sel else Color(0, 0, 0, 0.25))
		if sel:
			ci.draw_rect(r, CYAN, false, 2.0)
			ci.draw_rect(Rect2(r.position, Vector2(5, r.size.y)), CYAN)
		_txt(ci, f, Vector2(r.position.x + 20, r.position.y + 25), o["label"], 19, Color.WHITE)
		var vtxt := ""
		var vcol := GOLD
		if o.has("vals"):
			vtxt = value_label(o)
			if sel:
				vtxt = "<  " + vtxt + "  >"
		elif o.has("action"):
			vtxt = "PRESS A KEY..." if rebinding == o["action"] else key_names(o["action"])
			vcol = Color(1, 0.6, 0.6) if rebinding == o["action"] else CYAN
		else:
			vtxt = "PRESS JUMP" if sel else ""
			vcol = Color(1, 0.55, 0.55)
		_txt(ci, f, Vector2(r.position.x, r.position.y + 25), vtxt, 19, vcol, r.size.x - 22, HORIZONTAL_ALIGNMENT_RIGHT)
	# Description and hints.
	var desc := "LEFT / RIGHT to switch tabs, DOWN to pick a setting."
	if row >= 0 and row < rows.size():
		desc = String(rows[row].get("desc", ""))
		if rows[row].has("action"):
			desc = "Press JUMP, then the new key. Controllers always work with the default buttons."
	if msg != "" and rebinding != "":
		desc = msg
	_txt(ci, f, Vector2(150, 622), desc, 17, DIM, 980, HORIZONTAL_ALIGNMENT_CENTER)
	_txt(ci, f, Vector2(150, 656), "UP / DOWN choose     LEFT / RIGHT change     JUMP select     ESC back (saves)", 16, Color(DIM, 0.8), 980, HORIZONTAL_ALIGNMENT_CENTER)
