extends Node
## Autoload. Real-time generative soundtrack, synthesized on the fly.
## - Explore: sparse, gentle piano notes over a soft drone with a long echo
##   (calm, wandering, never the same twice).
## - Battle: 150+ BPM kick / snare / hats, a driving minor bass arpeggio and
##   stabbing lead. Crossfades with `intensity` (0 calm .. 1 full battle).
## Set Music.intensity from gameplay; Music.boss_mode for the boss tempo.

const RATE := 22050.0
const PENTA := [261.63, 293.66, 329.63, 392.0, 440.0, 523.25, 587.33, 659.25, 783.99]
const BASS_ROOTS := [130.81, 110.0, 87.31, 98.0]          # C  A  F  G
const BATTLE_ROOTS := [55.0, 43.65, 65.41, 49.0]          # A  F  C  G
const BATTLE_ARP := [0, 12, 7, 12, 3, 12, 7, 15]          # minor arpeggio (semitones)
const LEAD := [0, 3, 5, 7, 10, 12]

var intensity := 0.0
var mix := 0.0
var boss_mode := false
var volume := 1.0

var player: AudioStreamPlayer
var pb: AudioStreamGeneratorPlayback
var voices: Array = []      # [freq, phase, amp, decay]
var next_note := 0.5
var drone_phase := 0.0
var drone_freq := 130.81
var drone_target := 130.81
var bar_i := 0
var clock := 0.0
var delay_buf := PackedFloat32Array()
var delay_i := 0

var step := 0
var step_samples := 0
var step_count := 0
var kick_env := 0.0
var kick_phase := 0.0
var snare_env := 0.0
var hat_env := 0.0
var bass_phase := 0.0
var bass_freq := 55.0
var bass_lp := 0.0
var bass_env := 0.0
var lead_phase := 0.0
var lead_freq := 440.0
var lead_env := 0.0
var noise_prev := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = RATE
	gen.buffer_length = 0.2
	player = AudioStreamPlayer.new()
	player.stream = gen
	player.volume_db = -7.0
	add_child(player)
	player.play()
	pb = player.get_stream_playback()
	delay_buf.resize(int(RATE * 0.42))


func _process(delta: float) -> void:
	if pb == null:
		return
	mix = move_toward(mix, intensity, delta * (1.2 if intensity > mix else 0.35))
	var n := pb.get_frames_available()
	if n <= 0:
		return
	var buf := PackedVector2Array()
	buf.resize(n)
	for i in n:
		var s := _sample()
		buf[i] = Vector2(s, s)
	pb.push_buffer(buf)


func _sample() -> float:
	clock += 1.0 / RATE
	var calm_amt := 1.0 - mix * 0.85
	var out := 0.0

	# ---- explore layer
	if clock >= next_note:
		var chord := randf() < 0.25
		var f: float = PENTA[randi() % PENTA.size()]
		voices.append([f, 0.0, 0.16, exp(-1.0 / (RATE * 1.6))])
		if chord:
			voices.append([f * 1.5 if f < 500.0 else f * 0.75, 0.0, 0.1, exp(-1.0 / (RATE * 1.4))])
		next_note = clock + randf_range(0.45, 1.9) * (0.6 if mix > 0.5 else 1.0)
		if randf() < 0.18:
			bar_i = (bar_i + 1) % BASS_ROOTS.size()
			drone_target = BASS_ROOTS[bar_i]
			voices.append([drone_target, 0.0, 0.14, exp(-1.0 / (RATE * 3.0))])
	var piano := 0.0
	var i := voices.size() - 1
	while i >= 0:
		var v: Array = voices[i]
		v[1] = v[1] + v[0] / RATE
		var ph: float = v[1] * TAU
		piano += (sin(ph) + 0.35 * sin(ph * 2.0) + 0.12 * sin(ph * 3.0)) * v[2]
		v[2] = v[2] * v[3]
		if v[2] < 0.002:
			voices.remove_at(i)
		i -= 1
	drone_freq = lerpf(drone_freq, drone_target, 0.00005)
	drone_phase += drone_freq * 0.5 / RATE
	var drone := sin(drone_phase * TAU) * 0.05 * (0.7 + 0.3 * sin(clock * 0.4))
	var calm := piano + drone
	var echo := delay_buf[delay_i]
	delay_buf[delay_i] = calm + echo * 0.42
	delay_i = (delay_i + 1) % delay_buf.size()
	out += (calm + echo * 0.5) * calm_amt

	# ---- battle layer
	if mix > 0.01:
		var bpm := 168.0 if boss_mode else 152.0
		step_samples = int(RATE * 60.0 / bpm / 4.0)
		step_count += 1
		if step_count >= step_samples:
			step_count = 0
			step = (step + 1) % 64
			var s16 := step % 16
			if s16 % 4 == 0 or (boss_mode and s16 == 10):
				kick_env = 1.0
				kick_phase = 0.0
			if s16 == 4 or s16 == 12:
				snare_env = 1.0
			if s16 % 2 == 0:
				hat_env = 0.6 if s16 % 4 == 2 else 0.35
			var root: float = BATTLE_ROOTS[(step / 16) % 4]
			bass_freq = root * pow(2.0, BATTLE_ARP[s16 % 8] / 12.0)
			bass_env = 1.0
			if s16 % 8 == 6 and randf() < 0.8:
				lead_freq = root * 8.0 * pow(2.0, LEAD[randi() % LEAD.size()] / 12.0)
				lead_env = 1.0
		var b := 0.0
		kick_phase += lerpf(48.0, 150.0, kick_env * kick_env) / RATE
		b += sin(kick_phase * TAU) * kick_env * 0.55
		kick_env *= 0.9993
		var nz := randf() * 2.0 - 1.0
		b += nz * snare_env * 0.22
		snare_env *= 0.9988
		b += (nz - noise_prev) * hat_env * 0.07
		noise_prev = nz
		hat_env *= 0.996
		bass_phase += bass_freq / RATE
		var sq := 1.0 if fmod(bass_phase, 1.0) < 0.5 else -1.0
		bass_lp += (sq - bass_lp) * 0.08
		b += bass_lp * 0.16 * (0.4 + 0.6 * bass_env)
		bass_env *= 0.9997
		lead_phase += lead_freq / RATE
		var saw := fmod(lead_phase, 1.0) * 2.0 - 1.0
		b += saw * lead_env * 0.06
		lead_env *= 0.99985
		out += b * mix
	return clampf(out * volume, -1.0, 1.0)
