extends Node
## Autoload. Every sound effect is synthesized at startup (no audio files), but
## built like real foley instead of beeps: layered pitch-drop "thumps" for
## impacts, filtered noise for cloth, air and debris, inharmonic partials for
## metal and bells, clay-chip clacks for money, and a touch of room echo.
##
## GRUNTS: if you record your own effort sounds they play on top, for example
## res://voice/rico/grunt_jump_1.ogg (see HOW_TO_RECORD.md, "Grunts"). Any number
## of variants _1.._5; one is picked at random. Files can be .ogg, .wav or .mp3.

const RATE := 44100
const EXTS := ["ogg", "wav", "mp3"]

## Which grunt slot (if any) each sound triggers on Rico, and how often (0..1),
## so attacks and jumps don't grunt every single time.
const RICO_GRUNTS := {
	"jump": ["jump", 0.35], "wall": ["jump", 0.5], "vault": ["effort", 0.4], "grab": ["effort", 0.5],
	"dash": ["dash", 0.5], "slide": ["slide", 0.5], "swing": ["attack", 0.45], "kick": ["attack", 0.6],
	"stomp": ["effort", 0.5], "hurt": ["hurt", 1.0], "die": ["death", 1.0], "parry": ["parry", 0.8],
	"double_jump": ["jump", 0.5], "heal": ["heal", 1.0], "land_hard": ["land", 0.8],
}

var streams := {}
var players: Array[AudioStreamPlayer] = []
var grunt_player: AudioStreamPlayer
var volume := 1.0
var _grunt_cache := {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in 16:
		var p := AudioStreamPlayer.new()
		p.volume_db = -6.0
		add_child(p)
		players.append(p)
	grunt_player = AudioStreamPlayer.new()
	add_child(grunt_player)
	_build()


func play(sname: String, pitch := 1.0) -> void:
	if RICO_GRUNTS.has(sname):
		var g: Array = RICO_GRUNTS[sname]
		if randf() < float(g[1]):
			grunt("rico", String(g[0]))
	if not streams.has(sname):
		return
	var pick: AudioStreamPlayer = players[0]
	for p in players:
		if not p.playing:
			pick = p
			break
	pick.stream = streams[sname]
	pick.pitch_scale = pitch * randf_range(0.94, 1.06)
	pick.volume_db = -6.0 + linear_to_db(maxf(volume, 0.0001))
	pick.play()


## Play one of the user's recorded grunts for `who` (rico, enemy, or a boss id),
## e.g. grunt("rico", "hurt") -> res://voice/rico/grunt_hurt_<1..5>.ogg.
## Silent when nothing is recorded. Returns true if a clip played.
func grunt(who: String, slot: String) -> bool:
	if who == "house":
		who = "the_house"
	var files := grunt_files(who, slot)
	if files.is_empty():
		return false
	if grunt_player.playing and slot != "hurt" and slot != "death":
		return false
	var st = load(files[randi() % files.size()])
	if st == null or not (st is AudioStream):
		return false
	var bus := "Voice_" + who
	grunt_player.bus = bus if AudioServer.get_bus_index(bus) >= 0 else ("Voice" if AudioServer.get_bus_index("Voice") >= 0 else "Master")
	grunt_player.stream = st
	grunt_player.pitch_scale = randf_range(0.96, 1.04)
	grunt_player.volume_db = linear_to_db(maxf(volume, 0.0001))
	grunt_player.play()
	return true


func grunt_files(who: String, slot: String) -> Array:
	var key := who + "/" + slot
	if _grunt_cache.has(key):
		return _grunt_cache[key]
	var out: Array = []
	for n in range(1, 6):
		for e in EXTS:
			var path := "res://voice/%s/grunt_%s_%d.%s" % [who, slot, n, e]
			if ResourceLoader.exists(path):
				out.append(path)
				break
	_grunt_cache[key] = out
	return out


func clear_grunt_cache() -> void:
	_grunt_cache.clear()


# ---------------------------------------------------------------- the foley

func _build() -> void:
	var b: PackedFloat32Array
	# --- Movement: cloth, shoes and air.
	b = _buf(0.2); _noise(b, 0.0, 0.16, 0.35, 0.015, 0.07, 700.0, 2800.0, 300.0); _thump(b, 0.0, 120.0, 70.0, 0.3, 0.03)
	streams["jump"] = _wav(b, 0.8)
	b = _buf(0.24); _noise(b, 0.0, 0.2, 0.3, 0.02, 0.09, 900.0, 3600.0, 400.0); _noise(b, 0.0, 0.08, 0.15, 0.002, 0.03, 5000.0, 5000.0, 1500.0)
	streams["double_jump"] = _wav(b, 0.7)
	b = _buf(0.16); _thump(b, 0.0, 150.0, 90.0, 0.45, 0.04); _noise(b, 0.0, 0.1, 0.35, 0.002, 0.05, 2500.0, 2000.0, 300.0)
	streams["wall"] = _wav(b, 0.85)
	b = _buf(0.3)
	for k in 4:
		_noise(b, k * 0.06, 0.06, 0.28, 0.002, 0.03, 2200.0, 1800.0, 400.0)
		_thump(b, k * 0.06, 170.0, 110.0, 0.15, 0.02)
	streams["wallrun"] = _wav(b, 0.8)
	b = _buf(0.3); _noise(b, 0.0, 0.28, 0.6, 0.04, 0.12, 900.0, 6000.0, 250.0); _noise(b, 0.02, 0.2, 0.2, 0.06, 0.1, 300.0, 1200.0, 60.0)
	streams["dash"] = _wav(b, 0.85)
	b = _buf(0.34); _noise(b, 0.0, 0.32, 0.35, 0.03, 0.2, 1800.0, 1100.0, 250.0)
	streams["slide"] = _wav(b, 0.75)
	b = _buf(0.18); _noise(b, 0.0, 0.12, 0.3, 0.01, 0.05, 1200.0, 3500.0, 300.0); _thump(b, 0.04, 140.0, 80.0, 0.35, 0.04)
	streams["vault"] = _wav(b, 0.8)
	b = _buf(0.12); _thump(b, 0.0, 200.0, 120.0, 0.3, 0.03); _noise(b, 0.0, 0.06, 0.25, 0.002, 0.03, 3000.0, 2500.0, 500.0)
	streams["grab"] = _wav(b, 0.7)
	b = _buf(0.22); _thump(b, 0.0, 95.0, 45.0, 0.65, 0.06); _noise(b, 0.0, 0.12, 0.3, 0.002, 0.05, 1300.0, 900.0, 80.0)
	streams["land"] = _wav(b, 0.85)
	b = _buf(0.4); _thump(b, 0.0, 80.0, 35.0, 0.9, 0.12); _noise(b, 0.0, 0.25, 0.45, 0.002, 0.1, 1100.0, 500.0, 50.0); _grains(b, 0.02, 0.3, 10, 0.12, 900.0)
	streams["land_hard"] = _wav(b, 0.9)
	# --- Money: clay poker chips clacking together.
	b = _buf(0.12); _clack(b, 0.0, 1.0); _clack(b, 0.035, 0.6)
	streams["chip"] = _wav(b, 0.7)
	b = _buf(0.45)
	for k in 7:
		_clack(b, k * 0.04 + randf() * 0.012, 0.9 - k * 0.07)
	_bell(b, 0.18, 2349.0, 0.18, 0.35)
	streams["chip_big"] = _wav(b, 0.75)
	b = _buf(0.6)
	for k in 12:
		_clack(b, k * 0.035 + randf() * 0.015, 0.8 - k * 0.04)
	streams["coins"] = _wav(b, 0.7)
	b = _buf(1.0)
	for k in 5:
		_clack(b, k * 0.035, 0.8)
	_bell(b, 0.14, 2093.0, 0.35, 0.6); _bell(b, 0.2, 2637.0, 0.22, 0.5); _thump(b, 0.12, 300.0, 200.0, 0.15, 0.05)
	streams["bank"] = _wav(_echo(b, 0.18), 0.8)
	b = _buf(0.7); _clack(b, 0.0, 0.8); _clack(b, 0.04, 0.6); _bell(b, 0.07, 1760.0, 0.3, 0.45)
	streams["buy"] = _wav(b, 0.75)
	# --- Combat: air, flesh, wood and metal.
	b = _buf(0.16); _noise(b, 0.0, 0.14, 0.55, 0.012, 0.055, 6500.0, 1400.0, 700.0)
	streams["swing"] = _wav(b, 0.8)
	b = _buf(0.22); _thump(b, 0.0, 140.0, 48.0, 0.95, 0.065); _noise(b, 0.0, 0.05, 0.6, 0.001, 0.016, 3500.0, 1500.0, 150.0); _thump(b, 0.0, 320.0, 170.0, 0.35, 0.03)
	streams["hit"] = _wav(_drive(b, 1.6), 0.95)
	b = _buf(0.2); _noise(b, 0.0, 0.08, 0.35, 0.01, 0.04, 4000.0, 1500.0, 500.0); _thump(b, 0.03, 150.0, 60.0, 0.7, 0.05)
	streams["kick"] = _wav(_drive(b, 1.4), 0.9)
	b = _buf(0.28); _thump(b, 0.0, 115.0, 38.0, 1.0, 0.09); _noise(b, 0.0, 0.14, 0.4, 0.002, 0.06, 900.0, 500.0, 40.0)
	streams["stomp"] = _wav(_drive(b, 1.5), 0.95)
	b = _buf(0.18); _noise(b, 0.0, 0.1, 0.4, 0.01, 0.05, 3000.0, 1200.0, 300.0); _thump(b, 0.05, 130.0, 55.0, 0.6, 0.05)
	streams["punch"] = _wav(_drive(b, 1.3), 0.85)
	b = _buf(0.4); _thump(b, 0.0, 105.0, 40.0, 0.9, 0.11); _noise(b, 0.0, 0.2, 0.5, 0.001, 0.08, 1600.0, 700.0, 60.0); _thump(b, 0.0, 230.0, 110.0, 0.35, 0.06)
	streams["hurt"] = _wav(_drive(b, 1.5), 0.95)
	b = _buf(1.4); _thump(b, 0.0, 110.0, 35.0, 1.0, 0.12); _thump(b, 0.05, 70.0, 28.0, 0.8, 0.5); _noise(b, 0.0, 0.6, 0.4, 0.002, 0.3, 700.0, 200.0, 30.0)
	streams["die"] = _wav(_echo(b, 0.3), 0.95)
	b = _buf(0.45); _metal(b, 0.0, 1900.0, 0.3, 0.22); _noise(b, 0.0, 0.03, 0.4, 0.001, 0.01, 8000.0, 8000.0, 2000.0)
	streams["clash"] = _wav(b, 0.8)
	b = _buf(0.9); _metal(b, 0.0, 2600.0, 0.4, 0.5); _metal(b, 0.0, 1300.0, 0.25, 0.4); _noise(b, 0.0, 0.03, 0.5, 0.001, 0.01, 9000.0, 9000.0, 2500.0); _thump(b, 0.0, 90.0, 50.0, 0.5, 0.08)
	streams["parry"] = _wav(_echo(b, 0.25), 0.9)
	b = _buf(0.14); _noise(b, 0.0, 0.1, 0.3, 0.03, 0.05, 1500.0, 4000.0, 600.0)
	streams["guard"] = _wav(b, 0.65)
	b = _buf(0.26); _noise(b, 0.0, 0.24, 0.32, 0.18, 0.04, 400.0, 2600.0, 150.0)
	streams["windup"] = _wav(b, 0.7)
	b = _buf(0.45); _noise(b, 0.0, 0.4, 0.3, 0.32, 0.06, 500.0, 4500.0, 200.0); _tone(b, 0.0, 0.4, 200.0, 520.0, 0.12, 0.3, 0.05)
	streams["charge"] = _wav(b, 0.7)
	b = _buf(0.9); _thump(b, 0.0, 75.0, 26.0, 1.0, 0.35); _noise(b, 0.0, 0.5, 0.6, 0.002, 0.25, 450.0, 180.0, 25.0); _grains(b, 0.04, 0.5, 18, 0.15, 1400.0)
	streams["slam"] = _wav(_drive(_echo(b, 0.25), 1.4), 1.0)
	b = _buf(2.2); _thump(b, 0.0, 90.0, 24.0, 1.0, 0.6); _noise(b, 0.0, 1.6, 0.5, 0.002, 0.7, 600.0, 120.0, 20.0); _shatter(b, 0.1, 30, 0.6)
	for k in 4:
		_thump(b, 0.3 + k * 0.28, 70.0, 30.0, 0.5 - k * 0.1, 0.2)
	streams["boss_die"] = _wav(_echo(b, 0.4), 1.0)
	# --- The world: glass, wood, stone and doors.
	b = _buf(0.5); _noise(b, 0.0, 0.08, 0.55, 0.001, 0.04, 9000.0, 6000.0, 2500.0); _shatter(b, 0.0, 26, 0.3); _thump(b, 0.0, 300.0, 150.0, 0.2, 0.03)
	streams["glass"] = _wav(b, 0.85)
	b = _buf(0.22); _noise(b, 0.0, 0.1, 0.6, 0.001, 0.04, 2600.0, 1500.0, 150.0); _thump(b, 0.0, 210.0, 100.0, 0.4, 0.04)
	streams["crack"] = _wav(_drive(b, 1.3), 0.9)
	b = _buf(0.5); _grains(b, 0.0, 0.4, 22, 0.35, 1300.0); _noise(b, 0.0, 0.4, 0.25, 0.02, 0.2, 400.0, 250.0, 30.0)
	streams["crumble"] = _wav(b, 0.85)
	b = _buf(0.34); _creak(b, 0.0, 0.3, 135.0, 108.0, 0.35)
	streams["creak"] = _wav(b, 0.6)
	b = _buf(0.4); _thump(b, 0.0, 160.0, 70.0, 0.7, 0.06); _noise(b, 0.0, 0.12, 0.55, 0.001, 0.07, 2200.0, 1000.0, 120.0); _grains(b, 0.02, 0.28, 12, 0.25, 2000.0)
	streams["smash"] = _wav(_drive(b, 1.3), 0.9)
	b = _buf(0.6); _creak(b, 0.0, 0.18, 160.0, 120.0, 0.2); _thump(b, 0.18, 120.0, 75.0, 0.7, 0.08); _noise(b, 0.18, 0.1, 0.4, 0.001, 0.05, 800.0, 500.0, 60.0)
	streams["door"] = _wav(_echo(b, 0.2), 0.85)
	# --- Interface: soft clicks and chimes, nothing beepy.
	b = _buf(0.035); _noise(b, 0.0, 0.01, 0.4, 0.0005, 0.004, 6000.0, 6000.0, 2500.0); _tone(b, 0.0, 0.02, 1500.0, 1500.0, 0.08, 0.001, 0.008)
	streams["blip"] = _wav(b, 0.5)
	b = _buf(0.03); _noise(b, 0.0, 0.01, 0.4, 0.0005, 0.003, 7000.0, 7000.0, 3000.0)
	streams["tick"] = _wav(b, 0.45)
	b = _buf(0.8); _bell(b, 0.0, 1318.5, 0.3, 0.5); _bell(b, 0.08, 1975.5, 0.25, 0.45)
	streams["tier"] = _wav(_echo(b, 0.2), 0.7)
	b = _buf(0.3); _thump(b, 0.0, 170.0, 130.0, 0.45, 0.06); _thump(b, 0.11, 150.0, 110.0, 0.45, 0.07)
	streams["deny"] = _wav(b, 0.7)
	b = _buf(1.2); _noise(b, 0.0, 0.5, 0.4, 0.3, 0.15, 600.0, 5000.0, 200.0); _bell(b, 0.42, 1046.5, 0.3, 0.6); _bell(b, 0.42, 1568.0, 0.25, 0.6); _thump(b, 0.42, 110.0, 50.0, 0.5, 0.15)
	streams["start"] = _wav(_echo(b, 0.3), 0.85)
	# Let it ride: a snare roll that swells into a crash and a big hit.
	b = _buf(1.6)
	var tt := 0.0
	while tt < 0.75:
		_noise(b, tt, 0.03, 0.12 + tt * 0.5, 0.001, 0.015, 5000.0, 4000.0, 900.0)
		tt += 0.028
	_noise(b, 0.78, 0.8, 0.5, 0.001, 0.4, 12000.0, 8000.0, 4000.0); _thump(b, 0.78, 90.0, 40.0, 1.0, 0.18)
	streams["ride"] = _wav(_echo(b, 0.25), 0.95)
	b = _buf(0.7); _tone(b, 0.0, 0.6, 520.0, 780.0, 0.15, 0.2, 0.2); _noise(b, 0.0, 0.5, 0.15, 0.2, 0.2, 2000.0, 6000.0, 500.0)
	streams["heal"] = _wav(_echo(b, 0.2), 0.7)


# ---------------------------------------------------------------- synthesis kit

func _buf(dur: float) -> PackedFloat32Array:
	var b := PackedFloat32Array()
	b.resize(int(dur * RATE))
	return b


## Pitch-dropping sine with a click of attack: the body of every impact.
func _thump(b: PackedFloat32Array, at: float, f0: float, f1: float, amp: float, decay: float) -> void:
	var i0 := int(at * RATE)
	var n := mini(b.size() - i0, int(decay * 7.0 * RATE))
	var ph := 0.0
	for i in n:
		var tsec := float(i) / RATE
		var f := f1 + (f0 - f1) * exp(-tsec / (decay * 0.6))
		ph += f / RATE
		var env := exp(-tsec / decay) * minf(1.0, tsec / 0.0015)
		b[i0 + i] += sin(ph * TAU) * env * amp


## Plain sine glide with attack and decay (used sparingly, for tonal colour).
func _tone(b: PackedFloat32Array, at: float, dur: float, f0: float, f1: float, amp: float, attack: float, decay: float) -> void:
	var i0 := int(at * RATE)
	var n := mini(b.size() - i0, int(dur * RATE))
	var ph := 0.0
	for i in n:
		var k := float(i) / maxf(1.0, float(n))
		var tsec := float(i) / RATE
		ph += lerpf(f0, f1, k) / RATE
		var env := minf(1.0, tsec / maxf(attack, 0.0005)) * exp(-maxf(0.0, tsec - attack) / decay)
		b[i0 + i] += (sin(ph * TAU) + 0.25 * sin(ph * TAU * 2.0)) * env * amp


## Filtered noise: low-pass sweeps lp0 -> lp1 with a high-pass at hp, an attack
## swell and an exponential decay. Air, cloth, debris, crashes.
func _noise(b: PackedFloat32Array, at: float, dur: float, amp: float, attack: float, decay: float, lp0: float, lp1: float, hp: float) -> void:
	var i0 := int(at * RATE)
	var n := mini(b.size() - i0, int(maxf(dur, decay * 5.0) * RATE))
	var lp := 0.0
	var hpst := 0.0
	var a_hp := exp(-TAU * hp / RATE)
	var a_lp := 0.0
	for i in n:
		var tsec := float(i) / RATE
		var k := clampf(tsec / maxf(dur, 0.001), 0.0, 1.0)
		if i % 16 == 0:
			a_lp = 1.0 - exp(-TAU * lerpf(lp0, lp1, k) / RATE)
		var w := randf() * 2.0 - 1.0
		lp += (w - lp) * a_lp
		hpst = a_hp * hpst + (1.0 - a_hp) * lp
		var s := lp - hpst
		var env := minf(1.0, tsec / maxf(attack, 0.0005)) * exp(-maxf(0.0, tsec - attack) / decay)
		b[i0 + i] += s * env * amp * 2.2


## Inharmonic partials: metal, blades, parry rings.
func _metal(b: PackedFloat32Array, at: float, f: float, amp: float, decay: float) -> void:
	var ratios := [1.0, 2.76, 5.4, 8.93]
	var amps := [1.0, 0.6, 0.35, 0.2]
	for j in ratios.size():
		_partial(b, at, f * float(ratios[j]), amp * float(amps[j]), decay / (1.0 + j * 0.6))


## Bell: a warm fundamental with a couple of shimmering overtones.
func _bell(b: PackedFloat32Array, at: float, f: float, amp: float, decay: float) -> void:
	_partial(b, at, f, amp, decay)
	_partial(b, at, f * 2.0, amp * 0.4, decay * 0.6)
	_partial(b, at, f * 3.01, amp * 0.25, decay * 0.4)
	_partial(b, at, f * 0.5, amp * 0.2, decay * 1.2)


func _partial(b: PackedFloat32Array, at: float, f: float, amp: float, decay: float) -> void:
	var i0 := int(at * RATE)
	var n := mini(b.size() - i0, int(decay * 6.0 * RATE))
	for i in n:
		var tsec := float(i) / RATE
		b[i0 + i] += sin(TAU * f * tsec) * exp(-tsec / decay) * minf(1.0, tsec / 0.001) * amp


## One clay poker chip striking another: a bright click plus a short ring.
func _clack(b: PackedFloat32Array, at: float, amp: float) -> void:
	_noise(b, at, 0.01, 0.55 * amp, 0.0003, 0.005, 9000.0, 7000.0, 2200.0)
	_partial(b, at, randf_range(2900.0, 3500.0), 0.22 * amp, 0.018)
	_partial(b, at, randf_range(4800.0, 5600.0), 0.1 * amp, 0.01)


## Shattering glass: a cloud of tiny high pings scattered in time.
func _shatter(b: PackedFloat32Array, at: float, count: int, spread: float) -> void:
	for k in count:
		var st := at + randf() * spread * randf()
		_partial(b, st, randf_range(2500.0, 9500.0), randf_range(0.05, 0.13), randf_range(0.015, 0.07))


## Debris grains: short low-passed crunches (gravel, splinters, plaster).
func _grains(b: PackedFloat32Array, at: float, spread: float, count: int, amp: float, lp: float) -> void:
	for k in count:
		var st := at + randf() * spread
		_noise(b, st, 0.02, amp * randf_range(0.4, 1.0), 0.0005, randf_range(0.006, 0.02), lp, lp * 0.7, 120.0)


## A wooden creak: a slowly gliding buzz with a wobbling amplitude.
func _creak(b: PackedFloat32Array, at: float, dur: float, f0: float, f1: float, amp: float) -> void:
	var i0 := int(at * RATE)
	var n := mini(b.size() - i0, int(dur * RATE))
	var ph := 0.0
	for i in n:
		var k := float(i) / maxf(1.0, float(n))
		ph += lerpf(f0, f1, k) / RATE
		var x := ph * TAU
		var s := sin(x) + 0.5 * sin(2.0 * x) + 0.33 * sin(3.0 * x) + 0.2 * sin(5.0 * x)
		var wob := 0.6 + 0.4 * sin(k * 37.0)
		var env := sin(k * PI)
		b[i0 + i] += s * wob * env * amp * 0.45


## A short room: two quiet echoes so things sit in a space instead of a void.
func _echo(b: PackedFloat32Array, amount: float) -> PackedFloat32Array:
	var taps := [[0.043, 0.55], [0.089, 0.35], [0.137, 0.2]]
	var out := b.duplicate()
	for tp in taps:
		var d := int(float(tp[0]) * RATE)
		var g := float(tp[1]) * amount
		for i in range(d, b.size()):
			out[i] += b[i - d] * g
	return out


## Warm saturation so impacts feel heavy rather than clinical.
func _drive(b: PackedFloat32Array, k: float) -> PackedFloat32Array:
	var out := b.duplicate()
	for i in out.size():
		out[i] = tanh(out[i] * k) / tanh(k)
	return out


## Normalize, soft-clip and encode as a 16-bit mono WAV stream.
func _wav(b: PackedFloat32Array, peak: float) -> AudioStreamWAV:
	var mx := 0.0001
	for v in b:
		mx = maxf(mx, absf(v))
	var g := peak / mx
	var data := PackedByteArray()
	data.resize(b.size() * 2)
	var fade := mini(200, b.size())
	for i in b.size():
		var v := tanh(b[i] * g * 1.1) / tanh(1.1)
		if i > b.size() - fade:
			v *= float(b.size() - i) / fade
		data.encode_s16(i * 2, int(clampf(v, -1.0, 1.0) * 32767.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = RATE
	wav.stereo = false
	wav.data = data
	return wav
