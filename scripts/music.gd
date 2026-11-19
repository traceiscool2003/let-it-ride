extends Node
## Autoload. Real-time generative soundtrack, synthesized on the fly (no assets).
## Instruments: FM electric piano (Rhodes), detuned string pads, upright/sub bass,
## brass/sax leads, plucked guitar/harp/vibes, calliope organ, brass stabs.
## Drums are real-sounding kit hits (pitch-dropping kick, noise snare, brushes,
## hats, ride, toms, clap) rendered once into buffers at load, then played back.
## Everything goes through a stereo comb reverb and a ping-pong slap echo.
##
## One theme per zone (Music.zone = level palette index):
##   4 alley: grimy lo-fi jazz noir     0 Atlantic Shitty: smoky lounge/bossa
##   1 Reno: tired carnival march        2 Biloxi: blues-rock shuffle
##   3 Fremont: old-Vegas swing          5 Strip: luxe big-band/strings
##   6 home: warm lo-fi chill
## Set Music.intensity (0 calm .. 1 full battle) and Music.boss_mode from gameplay.
## Zone changes crossfade (fade out, swap, fade in); boss tracks escalate by phase.

const RATE := 22050.0
const TN := 1024
const MAXV := 15

## Style data. prog entries: [semitones from key, chord intervals]. Patterns are
## 16-step strings (x = hit, o = soft hit). key = bass-register midi note.
const STYLES := {
	4: {"name": "alley noir", "bpm": 64.0, "sw": 0.30, "key": 38,
		"prog": [[0, [0, 3, 7, 10, 14]], [-4, [0, 4, 7, 11, 14]], [-2, [0, 3, 7, 10, 14]], [-5, [0, 4, 10, 13, 15]]],
		"scale": [0, 2, 3, 5, 6, 7, 9, 10], "keys": "rhodes", "comp": [0, 6, 10], "bass": "walk",
		"lead": "sax", "dens": 0.34, "pad": 0.5, "vinyl": 1.0, "loct": 1,
		"kk": "x.....x.....o...", "sn": "....o.......o...", "hh": "o.o.o.o.o.o.o.o.", "oh": "................"},
	0: {"name": "lounge", "bpm": 84.0, "sw": 0.16, "key": 41,
		"prog": [[0, [0, 4, 7, 11, 14]], [-3, [0, 3, 7, 10, 14]], [2, [0, 3, 7, 10, 14]], [-5, [0, 4, 10, 14, 21]]],
		"scale": [0, 2, 4, 5, 7, 9, 11], "keys": "vibes", "comp": [0, 3, 8, 11], "bass": "bossa",
		"lead": "vibes", "dens": 0.3, "pad": 0.7, "vinyl": 0.35, "loct": 1,
		"kk": "x..o..x...o.x...", "sn": "..x..x...x..x...", "hh": "x.x.x.x.x.x.x.x.", "oh": "................"},
	1: {"name": "carnival", "bpm": 112.0, "sw": 0.0, "key": 36,
		"prog": [[0, [0, 4, 7]], [5, [0, 4, 7]], [7, [0, 4, 7, 10]], [0, [0, 4, 7]]],
		"scale": [0, 2, 4, 7, 9, 12, 11, 14], "keys": "organ", "comp": [2, 6, 10, 14], "bass": "oompah",
		"lead": "calliope", "dens": 0.55, "pad": 0.2, "vinyl": 0.15, "loct": 2,
		"kk": "x...o...x...o...", "sn": "..x...x...x...x.", "hh": "o.o.o.o.o.o.o.o.", "oh": "......o.......o."},
	2: {"name": "blues rock", "bpm": 92.0, "sw": 0.27, "key": 40,
		"prog": [[0, [0, 7, 12]], [0, [0, 7, 12]], [5, [0, 7, 12]], [7, [0, 7, 12]]],
		"scale": [0, 3, 5, 6, 7, 10], "keys": "none", "comp": [0, 6, 8], "bass": "riff",
		"lead": "guitar", "dens": 0.4, "pad": 0.15, "vinyl": 0.0, "loct": 2,
		"kk": "x.....o.x.o.....", "sn": "....x.......x...", "hh": "x.x.x.x.x.x.x.x.", "oh": "..............o."},
	3: {"name": "old vegas swing", "bpm": 126.0, "sw": 0.30, "key": 43,
		"prog": [[0, [0, 4, 7, 11, 14]], [9, [0, 4, 7, 10, 13]], [2, [0, 3, 7, 10, 14]], [7, [0, 4, 7, 10, 14]]],
		"scale": [0, 2, 4, 5, 7, 9, 10, 11], "keys": "piano", "comp": [2, 7, 10, 14], "bass": "walk",
		"lead": "trumpet", "dens": 0.42, "pad": 0.25, "vinyl": 0.1, "loct": 1,
		"kk": "o.......o.......", "sn": "....o.......o...", "hh": "................", "oh": "x.x.x.x.x.x.x.x."},
	5: {"name": "luxe strip", "bpm": 104.0, "sw": 0.2, "key": 39,
		"prog": [[0, [0, 4, 7, 11, 14]], [-3, [0, 3, 7, 10, 14]], [2, [0, 3, 7, 10, 14]], [-5, [0, 4, 10, 14, 21]]],
		"scale": [0, 2, 4, 5, 7, 9, 11], "keys": "harp", "comp": [0, 4, 8, 12], "bass": "sub",
		"lead": "trumpet", "dens": 0.32, "pad": 1.0, "vinyl": 0.0, "loct": 1,
		"kk": "x...o...x...o...", "sn": "....o.......o...", "hh": "o.o.o.o.o.o.o.o.", "oh": "..o...o...o...o."},
	6: {"name": "home chill", "bpm": 78.0, "sw": 0.22, "key": 40,
		"prog": [[0, [0, 3, 7, 10, 14]], [-4, [0, 4, 7, 11, 14]], [3, [0, 4, 7, 11, 14]], [-2, [0, 4, 10, 14, 17]]],
		"scale": [0, 3, 5, 7, 10, 12], "keys": "rhodes", "comp": [0, 5, 10], "bass": "sub",
		"lead": "vibes", "dens": 0.18, "pad": 0.6, "vinyl": 0.8, "loct": 1,
		"kk": "x.....o.....x...", "sn": "....x.......x...", "hh": "o.o.o.o.o.o.o.o.", "oh": "................"},
}

var intensity := 0.0
var mix := 0.0
var boss_mode := false
## Each boss has its own track (boss_defs music: bpm, root Hz, mode, lead) that
## escalates with the phase (1..3).
var boss_music: Dictionary = {}
var boss_phase := 1
var volume := 1.0
var zone := 6

var player: AudioStreamPlayer
var pb: AudioStreamGeneratorPlayback
var clock := 0.0
var fade := 0.0                 # master fade for zone crossfades
var cur_zone := -99
var boss_amt := 0.0
var _vib := 0.0
var _trem := 0.0

# wavetables
var sin_t := PackedFloat32Array()
var saw_t := PackedFloat32Array()
var sq_t := PackedFloat32Array()
# drum buffers
var drum: Dictionary = {}
var dv: Array = []              # [buf, pos, gain, pan]
var vs: Array = []              # synth voices (see _spawn)

# explore sequencer
var st: Dictionary = {}
var step := 0
var step_t := 0
var step_len := 1000
var motif: Array = []
var last_lead := 4
# boss sequencer
var bstep := 0
var bstep_t := 0
var bstep_len := 1000
var boss_lead_i := 0
# effects
var rb0 := PackedFloat32Array()
var rb1 := PackedFloat32Array()
var rb2 := PackedFloat32Array()
var rb3 := PackedFloat32Array()
var ri0 := 0
var ri1 := 0
var ri2 := 0
var ri3 := 0
var rl0 := 0.0
var rl1 := 0.0
var rl2 := 0.0
var rl3 := 0.0
var eb_l := PackedFloat32Array()
var eb_r := PackedFloat32Array()
var ei := 0
var send_l := 0.0
var send_r := 0.0
var vinyl_amt := 0.0
var vin_lp := 0.0
var dc_l := 0.0
var dc_r := 0.0
var boss_chord := [0, 3, 7, 10]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_tables()
	_build_drums()
	rb0.resize(787)
	rb1.resize(911)
	rb2.resize(853)
	rb3.resize(1013)
	eb_l.resize(int(RATE * 0.36))
	eb_r.resize(int(RATE * 0.27))
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = RATE
	gen.buffer_length = 0.25
	player = AudioStreamPlayer.new()
	player.stream = gen
	player.volume_db = -5.0
	add_child(player)
	player.play()
	pb = player.get_stream_playback()
	_set_style(zone)
	fade = 1.0


func _process(delta: float) -> void:
	if pb == null:
		return
	mix = move_toward(mix, intensity, delta * (1.2 if intensity > mix else 0.4))
	var n := pb.get_frames_available()
	if n <= 0:
		return
	pb.push_buffer(render(n, delta))


# ------------------------------------------------------------------ tables
func _build_tables() -> void:
	sin_t.resize(TN)
	saw_t.resize(TN)
	sq_t.resize(TN)
	for i in TN:
		var p := float(i) / TN
		sin_t[i] = sin(p * TAU)
		var s := 0.0
		var q := 0.0
		for h in range(1, 14):
			s += sin(p * TAU * h) / h
			if h % 2 == 1:
				q += sin(p * TAU * h) / h
		saw_t[i] = s * 0.62
		sq_t[i] = q * 0.78


func _build_drums() -> void:
	var n := 0
	var out := PackedFloat32Array()
	# kick: pitch-dropping sine body + beater click
	out.resize(int(RATE * 0.34))
	var ph := 0.0
	for i in out.size():
		var t := float(i) / RATE
		ph += (46.0 + 120.0 * exp(-t * 38.0)) / RATE
		out[i] = sin(ph * TAU) * exp(-t * 8.5) * 0.9 + (randf() * 2.0 - 1.0) * exp(-t * 300.0) * 0.25
	drum["kick"] = out
	# soft kick (felt)
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.26))
	ph = 0.0
	for i in out.size():
		var t := float(i) / RATE
		ph += (55.0 + 60.0 * exp(-t * 30.0)) / RATE
		out[i] = sin(ph * TAU) * exp(-t * 11.0) * 0.8
	drum["kick_s"] = out
	# snare: tone body + noise rattle
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.25))
	var prev := 0.0
	for i in out.size():
		var t := float(i) / RATE
		var nz := randf() * 2.0 - 1.0
		var hp := nz - prev * 0.5
		prev = nz
		out[i] = (sin(t * TAU * 188.0) * exp(-t * 26.0) * 0.55 + hp * exp(-t * 17.0) * 0.6)
	drum["snare"] = out
	# rim click
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.06))
	for i in out.size():
		var t := float(i) / RATE
		out[i] = (sin(t * TAU * 820.0) * 0.5 + sin(t * TAU * 1730.0) * 0.3) * exp(-t * 90.0)
	drum["rim"] = out
	# brush swish: slow-attack filtered noise
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.22))
	var lp := 0.0
	for i in out.size():
		var t := float(i) / RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.55
		out[i] = lp * minf(t * 40.0, 1.0) * exp(-t * 10.0) * 0.5
	drum["brush"] = out
	# hats
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.07))
	prev = 0.0
	for i in out.size():
		var t := float(i) / RATE
		var nz := randf() * 2.0 - 1.0
		out[i] = (nz - prev) * exp(-t * 70.0) * 0.4
		prev = nz
	drum["hat"] = out
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.34))
	prev = 0.0
	for i in out.size():
		var t := float(i) / RATE
		var nz := randf() * 2.0 - 1.0
		out[i] = (nz - prev) * exp(-t * 11.0) * 0.3
		prev = nz
	drum["open"] = out
	# ride: inharmonic metallic partials + ping
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.5))
	var parts := [2480.0, 3170.0, 4010.0, 5230.0, 6370.0, 7740.0]
	for i in out.size():
		var t := float(i) / RATE
		var s := 0.0
		for f in parts:
			s += sin(t * TAU * f)
		out[i] = (s * 0.05) * exp(-t * 7.0) + sin(t * TAU * 1180.0) * exp(-t * 30.0) * 0.18
	drum["ride"] = out
	# clap
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.2))
	for i in out.size():
		var t := float(i) / RATE
		var burst := 0.0
		for b in 3:
			var tb := t - b * 0.011
			if tb > 0.0:
				burst += exp(-tb * 150.0)
		out[i] = (randf() * 2.0 - 1.0) * (burst * 0.4 + exp(-t * 20.0) * 0.4) * 0.6
	drum["clap"] = out
	# toms
	for pair in [["tom_l", 90.0], ["tom_h", 150.0]]:
		out = PackedFloat32Array()
		out.resize(int(RATE * 0.35))
		ph = 0.0
		for i in out.size():
			var t := float(i) / RATE
			ph += (float(pair[1]) + 50.0 * exp(-t * 20.0)) / RATE
			out[i] = sin(ph * TAU) * exp(-t * 9.0) * 0.8
		drum[pair[0]] = out
	# reverse swell / riser noise for boss phase changes
	out = PackedFloat32Array()
	out.resize(int(RATE * 0.9))
	lp = 0.0
	for i in out.size():
		var t := float(i) / out.size()
		lp += ((randf() * 2.0 - 1.0) - lp) * (0.1 + 0.6 * t)
		out[i] = lp * t * t * 0.5
	drum["riser"] = out
	n = 0


func _hit(name: String, gain: float, pan := 0.5) -> void:
	if dv.size() > 14:
		dv.pop_front()
	dv.append([drum[name], 0, gain, pan])


# ------------------------------------------------------------------ voices
static func mtof(m: float) -> float:
	return 440.0 * pow(2.0, (m - 69.0) / 12.0)


## kind: 0 rhodes 1 pad 2 bass 3 lead 4 pluck 5 organ 6 stab 7 sawbass
func _spawn(kind: int, f: float, amp: float, hold: float, rel: float, pan := 0.5, att := 0.004, aux := 1.0, aux2 := 1.0) -> void:
	if vs.size() >= MAXV:
		vs.pop_front()
	# [ph, inc, amp, dec, kind, age, hold, att_inv, ph2/aux, lp, pan, aux2, bright]
	vs.append([randf() * 0.2, f / RATE, amp, exp(-1.0 / (RATE * maxf(rel, 0.02))), kind, 0,
		int(hold * RATE), 1.0 / (RATE * maxf(att, 0.001)), randf() * 0.5, 0.0, pan, aux2, aux])


func render(n: int, delta := 0.016) -> PackedVector2Array:
	var buf := PackedVector2Array()
	buf.resize(n)
	# zone change -> crossfade
	var want := zone
	if boss_amt > 0.5:
		pass
	if want != cur_zone and fade <= 0.02:
		_set_style(want)
	var fade_goal := 1.0 if want == cur_zone else 0.0
	var fstep := delta * (1.4 if fade_goal > fade else 1.0)
	fade = move_toward(fade, fade_goal, fstep)
	boss_amt = move_toward(boss_amt, 1.0 if (boss_mode and not boss_music.is_empty()) else 0.0, delta * 0.9)
	var exp_g := 1.0 - 0.92 * boss_amt
	var vol := volume * fade * (1.0 - 0.22 * boss_amt)
	var sl := RATE
	for i in n:
		clock += 1.0 / sl
		# ---- sequencers
		if exp_g > 0.03:
			step_t += 1
			if step_t >= step_len:
				_explore_step()
		if boss_amt > 0.03:
			bstep_t += 1
			if bstep_t >= bstep_len:
				_boss_step()
		_vib = sin(clock * TAU * 5.2)
		_trem = 0.85 + 0.15 * sin(clock * TAU * 4.4)
		var l := 0.0
		var r := 0.0
		var sl_ := 0.0
		var sr_ := 0.0
		# ---- synth voices
		var k := vs.size() - 1
		while k >= 0:
			var v: Array = vs[k]
			var kind: int = v[4]
			var age: int = v[5]
			v[5] = age + 1
			var inc: float = v[1]
			var ph: float = v[0] + inc
			if ph >= 1.0:
				ph -= 1.0
			v[0] = ph
			var amp: float = v[2]
			var s := 0.0
			var wet := 0.25
			if kind == 0:
				var b: float = v[12]
				v[12] = b * 0.99965
				var md := sin_t[int(fmod(ph * 14.0, 1.0) * TN) & (TN - 1)] * b * 0.5
				s = sin_t[int((ph + md * 0.1) * TN) & (TN - 1)] + 0.22 * sin_t[int(fmod(ph * 2.0, 1.0) * TN) & (TN - 1)] * b
				s *= _trem
				wet = 0.35
			elif kind == 1:
				var p2: float = v[8] + inc * 1.006
				if p2 >= 1.0:
					p2 -= 1.0
				v[8] = p2
				var x: float = (saw_t[int(ph * TN) & (TN - 1)] + saw_t[int(p2 * TN) & (TN - 1)]) * 0.5
				v[9] += (x - v[9]) * 0.1
				s = v[9] * 1.2
				wet = 0.6
			elif kind == 2:
				var b2: float = v[12]
				v[12] = b2 * 0.9996
				s = sin_t[int(ph * TN) & (TN - 1)] + 0.5 * b2 * sin_t[int(fmod(ph * 2.0, 1.0) * TN) & (TN - 1)] + 0.15 * b2 * sin_t[int(fmod(ph * 3.0, 1.0) * TN) & (TN - 1)]
				wet = 0.08
			elif kind == 3:
				var sw: float = v[12]
				v[12] = minf(sw + 0.00035, 1.0)
				v[0] = fmod(v[0] + inc * 0.008 * _vib * minf(age / 6000.0, 1.0), 1.0)
				var x2: float = saw_t[int(v[0] * TN) & (TN - 1)]
				v[9] += (x2 - v[9]) * (0.05 + 0.3 * sw * float(v[11]))
				s = v[9] * 1.4
				wet = 0.4
			elif kind == 4:
				var b3: float = v[12]
				v[12] = b3 * 0.9993
				var x3: float = sin_t[int(ph * TN) & (TN - 1)] + b3 * (0.5 * sin_t[int(fmod(ph * 2.0, 1.0) * TN) & (TN - 1)] + 0.3 * sin_t[int(fmod(ph * 3.0, 1.0) * TN) & (TN - 1)] + 0.15 * sin_t[int(fmod(ph * 5.0, 1.0) * TN) & (TN - 1)])
				var drv: float = v[11]
				if drv > 1.0:
					x3 = clampf(x3 * drv, -0.7, 0.7) * 1.2
				s = x3 * 0.7
			elif kind == 5:
				v[0] = fmod(v[0] + inc * 0.004 * _vib, 1.0)
				s = sq_t[int(v[0] * TN) & (TN - 1)] * 0.7 + 0.35 * sin_t[int(fmod(v[0] * 2.0, 1.0) * TN) & (TN - 1)]
				wet = 0.2
			elif kind == 6:
				var p3: float = v[8] + inc * 1.01
				if p3 >= 1.0:
					p3 -= 1.0
				v[8] = p3
				var x4: float = (saw_t[int(ph * TN) & (TN - 1)] + saw_t[int(p3 * TN) & (TN - 1)] + saw_t[int(fmod(ph * 2.0, 1.0) * TN) & (TN - 1)] * 0.5) * 0.45
				v[9] += (x4 - v[9]) * (0.1 + 0.4 * v[12])
				v[12] = v[12] * 0.9997
				s = v[9]
				wet = 0.3
			else:
				var b4: float = v[12]
				v[12] = b4 * 0.9998
				var x5: float = saw_t[int(ph * TN) & (TN - 1)]
				v[9] += (x5 - v[9]) * (0.04 + 0.16 * b4)
				s = v[9] * 1.3
				wet = 0.05
			# envelope: attack ramp, hold, then exponential release
			var env := minf(float(age) * v[7], 1.0)
			if age > v[6]:
				amp *= v[3]
				v[2] = amp
			s *= amp * env
			var pan: float = v[10]
			l += s * (1.0 - pan) * 1.4
			r += s * pan * 1.4
			sl_ += s * wet * (1.0 - pan)
			sr_ += s * wet * pan
			if amp < 0.004:
				vs.remove_at(k)
			k -= 1
		# ---- drums
		var d := dv.size() - 1
		while d >= 0:
			var dd: Array = dv[d]
			var buf2: PackedFloat32Array = dd[0]
			var pos: int = dd[1]
			if pos >= buf2.size():
				dv.remove_at(d)
			else:
				var x6: float = buf2[pos] * float(dd[2])
				dd[1] = pos + 1
				var pn: float = dd[3]
				l += x6 * (1.0 - pn) * 1.4
				r += x6 * pn * 1.4
				sl_ += x6 * 0.12
				sr_ += x6 * 0.12
			d -= 1
		# ---- vinyl dust (alley, home, lounge)
		if vinyl_amt > 0.0:
			vin_lp += ((randf() * 2.0 - 1.0) - vin_lp) * 0.3
			var crack := 0.0
			if randf() < 0.0006:
				crack = (randf() * 2.0 - 1.0) * 0.18
			var dust := (vin_lp * 0.006 + crack) * vinyl_amt * exp_g
			l += dust
			r += dust
		# ---- reverb (4 combs, stereo) + ping-pong slap echo
		var rin := (sl_ + sr_) * 0.5
		var y0 := rb0[ri0]
		rl0 += (y0 - rl0) * 0.4
		rb0[ri0] = rin + rl0 * 0.80
		ri0 = (ri0 + 1) % 787
		var y1 := rb1[ri1]
		rl1 += (y1 - rl1) * 0.4
		rb1[ri1] = rin + rl1 * 0.79
		ri1 = (ri1 + 1) % 911
		var y2 := rb2[ri2]
		rl2 += (y2 - rl2) * 0.4
		rb2[ri2] = rin + rl2 * 0.80
		ri2 = (ri2 + 1) % 853
		var y3 := rb3[ri3]
		rl3 += (y3 - rl3) * 0.4
		rb3[ri3] = rin + rl3 * 0.78
		ri3 = (ri3 + 1) % 1013
		var el := eb_l[ei % eb_l.size()]
		var er := eb_r[ei % eb_r.size()]
		eb_l[ei % eb_l.size()] = sl_ * 0.5 + er * 0.38
		eb_r[ei % eb_r.size()] = sr_ * 0.5 + el * 0.38
		ei += 1
		var ol := l + (y0 + y1) * 0.34 + el * 0.45
		var or_ := r + (y2 + y3) * 0.34 + er * 0.45
		# gentle DC block + soft clip
		dc_l += (ol - dc_l) * 0.002
		dc_r += (or_ - dc_r) * 0.002
		ol = (ol - dc_l) * vol
		or_ = (or_ - dc_r) * vol
		buf[i] = Vector2(clampf(ol / (1.0 + absf(ol) * 0.35), -1.0, 1.0), clampf(or_ / (1.0 + absf(or_) * 0.35), -1.0, 1.0))
	return buf


# ------------------------------------------------------------------ explore
func _set_style(z: int) -> void:
	cur_zone = z
	st = STYLES.get(z, STYLES[6])
	vs.clear()
	dv.clear()
	step = 0
	step_t = 0
	motif = []
	vinyl_amt = float(st["vinyl"])
	_update_step_len()
	step_t = step_len


func _update_step_len() -> void:
	var bpm: float = float(st["bpm"]) * (1.0 + 0.16 * mix)
	step_len = int(RATE * 60.0 / bpm / 4.0)


func _swing_len(s: int) -> int:
	var sw: float = float(st["sw"])
	var m := s % 4
	var base := step_len
	if m < 2:
		return int(base * (1.0 + sw))
	return int(base * (1.0 - sw))


func _chord_at(bar: int) -> Array:
	return st["prog"][bar % 4]


func _explore_step() -> void:
	_update_step_len()
	var s16 := step % 16
	var bar := step / 16
	step += 1
	step_t = 0
	step_len = _swing_len(s16 + 0)
	var ch: Array = _chord_at(bar)
	var key: int = int(st["key"])
	var croot: int = key + int(ch[0])
	var ivs: Array = ch[1]
	var style_keys: String = st["keys"]
	var calm := 1.0 - mix * 0.5
	var pad_amt: float = float(st["pad"])

	# pad: sustained chord at the start of each bar
	if s16 == 0 and pad_amt > 0.0:
		var pv := 0.035 * pad_amt
		for j in range(1, mini(ivs.size(), 4)):
			_spawn(1, mtof(croot + 24 + int(ivs[j])), pv, 60.0 / float(st["bpm"]) * 3.0, 1.0, 0.2 + 0.2 * j, 0.7)
		_spawn(1, mtof(croot + 12), pv * 1.2, 60.0 / float(st["bpm"]) * 3.0, 1.0, 0.5, 0.7)

	# comping keys
	var comp: Array = st["comp"]
	if s16 in comp and style_keys != "none":
		var vv := 0.07 * calm
		var voicing := [1, 2, 3, 4]
		if ivs.size() > 4:
			voicing = [1, 2, 3, 4]
		for j in voicing:
			if j >= ivs.size():
				continue
			var m := croot + 24 + int(ivs[j])
			match style_keys:
				"rhodes":
					_spawn(0, mtof(m), vv, 0.1, 0.9, 0.35 + 0.1 * j, 0.004, 1.0)
				"vibes":
					_spawn(4, mtof(m + 12), vv * 0.7, 0.05, 0.9, 0.4 + 0.08 * j, 0.002, 1.0)
				"organ":
					_spawn(5, mtof(m), vv * 0.6, 0.12, 0.18, 0.4 + 0.08 * j, 0.01)
				"piano":
					_spawn(0, mtof(m), vv * 0.9, 0.06, 0.5, 0.3 + 0.12 * j, 0.002, 0.6)
				"harp":
					_spawn(4, mtof(m + 12), vv * 0.6, 0.04, 1.2, 0.2 + 0.2 * j, 0.002, 0.8)

	# bass
	_explore_bass(s16, croot, ivs, bar, calm)

	# lead: motif replayed across 4 bars with mutation
	_explore_lead(s16, bar, croot, ivs, calm)

	# drums
	_explore_drums(s16, calm)

	# battle layer (mix > 0): driving 8ths + stabs + full kit
	if mix > 0.05:
		if s16 % 2 == 0:
			_spawn(7, mtof(croot + (0 if s16 % 4 == 0 else 12 if s16 % 8 == 6 else 7)), 0.1 * mix, 0.06, 0.12, 0.5, 0.002, 1.0)
		if s16 == 0 or s16 == 10:
			for j in range(0, mini(ivs.size(), 4)):
				_spawn(6, mtof(croot + 36 + int(ivs[j])), 0.04 * mix, 0.1, 0.2, 0.5 + 0.1 * (j - 2), 0.004, 1.0)
		if s16 % 8 == 0:
			_hit("kick", 0.7 * mix, 0.5)
		if s16 == 4 or s16 == 12:
			_hit("snare", 0.75 * mix, 0.5)
		if s16 % 2 == 0:
			_hit("hat", 0.4 * mix, 0.62)


func _explore_bass(s16: int, croot: int, ivs: Array, bar: int, calm: float) -> void:
	var nxt: Array = _chord_at(bar + 1)
	var nroot: int = int(st["key"]) + int(nxt[0])
	var bv := 0.2 * calm
	match String(st["bass"]):
		"walk":
			if s16 % 4 == 0:
				var q := s16 / 4
				var m := croot
				if q == 1:
					m = croot + int(ivs[1 if ivs.size() > 1 else 0])
				elif q == 2:
					m = croot + 7
				elif q == 3:
					m = nroot + (1 if nroot < croot else -1) if randf() < 0.6 else nroot - 2
				_spawn(2, mtof(m), bv, 0.18, 0.2, 0.45, 0.004, 1.0)
		"bossa":
			if s16 == 0 or s16 == 6 or s16 == 8 or s16 == 14:
				_spawn(2, mtof(croot if s16 < 8 else croot + 7), bv, 0.2, 0.25, 0.45)
		"oompah":
			if s16 % 8 == 0:
				_spawn(2, mtof(croot), bv, 0.1, 0.12, 0.45)
			elif s16 % 8 == 4:
				_spawn(2, mtof(croot + 7), bv, 0.1, 0.12, 0.45)
		"riff":
			if s16 % 2 == 0:
				var pat := [0, 0, 3, 0, 5, 0, 6, 7]
				var o: int = int(pat[(s16 / 2) % 8])
				_spawn(4, mtof(croot + o), 0.16 * calm, 0.06, 0.16, 0.5, 0.002, 1.0, 1.6)
		"sub":
			if s16 == 0 or s16 == 10:
				_spawn(2, mtof(croot), bv * 1.1, 0.5, 0.5, 0.5, 0.01, 0.6)


func _explore_lead(s16: int, bar: int, croot: int, ivs: Array, calm: float) -> void:
	var dens: float = float(st["dens"])
	if s16 == 0 and bar % 2 == 0:
		# new two-bar phrase: sometimes keep the old one (repeat = hook), sometimes rewrite
		if motif.is_empty() or randf() < 0.45:
			motif = []
			var sc: Array = st["scale"]
			var deg := randi() % sc.size()
			var count := 3 + randi() % 3
			var pos := [0, 2, 3, 6, 8, 10, 11, 14, 16, 18, 22, 24, 27, 30]
			var used := []
			for _c in count * 2:
				var p: int = int(pos[randi() % pos.size()])
				if p not in used and used.size() < count:
					used.append(p)
			used.sort()
			for p in used:
				deg = clampi(deg + [-2, -1, -1, 0, 1, 1, 2][randi() % 7], 0, sc.size() - 1)
				motif.append([p, deg, 0.1 + randf() * 0.5])
	var local := (bar % 2) * 16 + s16
	for e in motif:
		if int(e[0]) == local and randf() < (dens * 2.2 + 0.2):
			var sc2: Array = st["scale"]
			var semis := croot + 12 * int(st["loct"]) + 12 + int(sc2[int(e[1])])
			if int(e[0]) % 8 == 0:
				# snap strong beats toward chord tones
				var tgt: int = int(ivs[(int(e[1])) % ivs.size()])
				semis = croot + 12 * int(st["loct"]) + 12 + tgt
			var f := mtof(semis)
			var lv := 0.09 * calm
			match String(st["lead"]):
				"sax":
					_spawn(3, f, lv * 1.2, 0.35, 0.3, 0.6, 0.05, 1.0, 0.8)
				"trumpet":
					_spawn(3, f, lv * 1.2, 0.25, 0.2, 0.6, 0.035, 1.0, 1.3)
				"vibes":
					_spawn(4, f * 2.0, lv * 0.8, 0.06, 1.1, 0.6, 0.002, 1.0)
				"calliope":
					_spawn(5, f, lv * 0.55, 0.2, 0.12, 0.6, 0.008)
				"guitar":
					_spawn(4, f, lv * 1.2, 0.3, 0.45, 0.58, 0.002, 1.0, 2.6)


func _explore_drums(s16: int, calm: float) -> void:
	var g := calm
	var kk: String = st["kk"]
	var sn: String = st["sn"]
	var hh: String = st["hh"]
	var oh: String = st["oh"]
	var style := String(st["name"])
	if kk[s16] != ".":
		var kg := 0.7 if kk[s16] == "x" else 0.4
		_hit("kick_s" if style in ["alley noir", "home chill", "lounge", "old vegas swing"] else "kick", kg * g, 0.5)
	if sn[s16] != ".":
		var sg := 0.6 if sn[s16] == "x" else 0.35
		if style == "alley noir" or style == "lounge":
			_hit("brush", sg * g * 1.2, 0.55)
			if style == "lounge":
				_hit("rim", 0.3 * g, 0.5)
		elif style == "home chill":
			_hit("snare", sg * g * 0.8, 0.5)
		else:
			_hit("snare", sg * g, 0.5)
	if s16 < hh.length() and hh[s16] != ".":
		var hg := 0.45 if hh[s16] == "x" else 0.28
		if style == "alley noir":
			_hit("brush", hg * g * 0.8, 0.4)
		else:
			_hit("hat", hg * g, 0.62)
	if oh[s16] != ".":
		if style == "old vegas swing" or style == "luxe strip":
			_hit("ride", (0.45 if oh[s16] == "x" else 0.3) * g, 0.6)
		else:
			_hit("open", 0.35 * g, 0.62)
	if style == "carnival" and s16 == 15:
		_hit("tom_h", 0.3 * g, 0.4)


# ------------------------------------------------------------------ boss
func _boss_step() -> void:
	var bpm: float = float(boss_music.get("bpm", 150)) + (boss_phase - 1) * 9.0
	bstep_len = int(RATE * 60.0 / bpm / 4.0)
	bstep_t = 0
	var s16 := bstep % 16
	var bar := bstep / 16
	bstep += 1
	var phr: bool = String(boss_music.get("mode", "minor")) == "phrygian"
	var rootf: float = float(boss_music.get("root", 55.0))
	var prog: Array = [0, -4, 3, -2] if not phr else [0, 1, -2, 1]
	var rm: float = 12.0 * log(rootf / 440.0) / log(2.0) + 69.0 + float(prog[bar % 4]) + 12.0   # bass-register midi
	var chord: Array = [0, 3, 7, 10] if not phr else [0, 1, 7, 8]
	var ph := boss_phase
	# drums: kick pulse, backbeat, hats scale with phase
	var kicks := [0, 4, 8, 12]
	if ph >= 2:
		kicks = [0, 3, 4, 8, 10, 12]
	if ph >= 3:
		kicks = [0, 2, 3, 4, 6, 8, 10, 11, 12, 14]
	if s16 in kicks:
		_hit("kick", 0.85, 0.5)
	if s16 == 4 or s16 == 12:
		_hit("snare", 0.9, 0.5)
		if ph >= 2:
			_hit("clap", 0.5, 0.6)
	if ph == 1 and s16 % 2 == 0 or ph >= 2:
		_hit("hat", 0.4 if s16 % 4 == 2 else 0.26, 0.62)
	if ph >= 2 and s16 % 4 == 3:
		_hit("open", 0.25, 0.65)
	if ph >= 3 and bar % 4 == 3 and s16 >= 12:
		_hit("tom_h" if s16 % 2 == 0 else "tom_l", 0.7, 0.35 + 0.1 * (s16 - 12))
	if s16 == 0 and bar % 4 == 0 and bstep > 16 and ph >= 2:
		_hit("riser", 0.35, 0.5)
	# bass: 8th/16th saw pulse with filter envelope
	var arp := [0, 0, 12, 0, 7, 0, 12, 3] if not phr else [0, 0, 1, 0, 7, 0, 8, 1]
	if s16 % 2 == 0 or (ph >= 3 and s16 % 2 == 1):
		var o: int = int(arp[(s16 / 2) % 8]) if s16 % 2 == 0 else 12
		_spawn(7, mtof(rm + o), 0.14, 0.05, 0.1, 0.5, 0.002, 1.0)
	# sustained dark pad / choir, one chord per bar
	if s16 == 0:
		for j in range(1, 4):
			_spawn(1, mtof(rm + 24 + int(chord[j])), 0.032 + 0.012 * ph, 60.0 / bpm * 3.0, 0.9, 0.15 + 0.23 * j, 0.5)
	# brass/orchestra stabs on the hits
	if (s16 == 0 or s16 == 6 or s16 == 10 or (ph >= 3 and s16 == 14)):
		for j in 4:
			_spawn(6, mtof(rm + 24 + int(chord[j])), 0.045, 0.08, 0.2, 0.3 + 0.13 * j, 0.004, 1.0)
	# lead: stabbing motif, higher and denser with phase
	var lead_every := 8 if ph < 2 else 4
	if s16 % lead_every == (6 if lead_every == 8 else 2) and randf() < 0.85:
		var set: Array = [0, 3, 5, 7, 10, 12] if not phr else [0, 1, 5, 7, 8, 12]
		var off := 24 + (12 if ph >= 3 else 0) + int(set[randi() % set.size()])
		var lw := String(boss_music.get("lead", "saw"))
		var f := mtof(rm + off)
		match lw:
			"square":
				_spawn(5, f, 0.05, 0.12, 0.12, 0.62, 0.004)
			"tri":
				_spawn(4, f, 0.12, 0.1, 0.35, 0.62, 0.002, 1.0)
			_:
				_spawn(3, f, 0.1, 0.14, 0.15, 0.62, 0.01, 1.0, 1.5)
	bstep = bstep


func note_boss_phase_change() -> void:
	## Call when a boss enters a new phase: an impact + riser.
	if drum.is_empty():
		return
	_hit("riser", 0.6, 0.5)
	_hit("tom_l", 0.9, 0.5)
	_hit("kick", 1.0, 0.5)
