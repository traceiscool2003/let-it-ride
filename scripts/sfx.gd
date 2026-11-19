extends Node
## Autoload. Synthesizes every sound effect at startup — no audio files needed.

var streams := {}
var players: Array[AudioStreamPlayer] = []
var volume := 1.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in 14:
		var p := AudioStreamPlayer.new()
		p.volume_db = -8.0
		add_child(p)
		players.append(p)
	streams["jump"] = _tone(260.0, 540.0, 0.09, "square", 0.22)
	streams["wall"] = _tone(240.0, 720.0, 0.1, "square", 0.24)
	streams["wallrun"] = _tone(180.0, 520.0, 0.16, "tri", 0.4)
	streams["dash"] = _tone(2400.0, 500.0, 0.14, "noise", 0.35)
	streams["slide"] = _tone(1600.0, 700.0, 0.16, "noise", 0.2)
	streams["vault"] = _tone(380.0, 820.0, 0.07, "tri", 0.45)
	streams["grab"] = _tone(500.0, 300.0, 0.05, "square", 0.18)
	streams["land"] = _tone(900.0, 200.0, 0.06, "noise", 0.25)
	streams["chip"] = _tone(1300.0, 1900.0, 0.06, "square", 0.14)
	streams["chip_big"] = _seq([1047.0, 1319.0, 1568.0, 2093.0], 0.045, "square", 0.15)
	streams["stomp"] = _tone(260.0, 50.0, 0.13, "square", 0.35)
	streams["kick"] = _tone(1800.0, 120.0, 0.12, "noise", 0.4)
	streams["hurt"] = _tone(420.0, 70.0, 0.25, "saw", 0.35)
	streams["die"] = _tone(620.0, 35.0, 0.7, "saw", 0.35)
	streams["tier"] = _seq([659.0, 988.0], 0.06, "square", 0.18)
	streams["door"] = _seq([392.0, 523.0, 659.0], 0.07, "tri", 0.4)
	streams["tick"] = _tone(900.0, 900.0, 0.025, "square", 0.12)
	streams["bank"] = _seq([523.0, 659.0, 784.0, 1047.0, 1319.0], 0.06, "square", 0.18)
	streams["ride"] = _seq([196.0, 247.0, 294.0, 392.0, 587.0], 0.07, "saw", 0.22)
	streams["start"] = _seq([262.0, 392.0, 523.0], 0.08, "tri", 0.4)
	streams["swing"] = _tone(3200.0, 900.0, 0.08, "noise", 0.22)
	streams["hit"] = _tone(320.0, 90.0, 0.08, "square", 0.4)
	streams["clash"] = _seq([1760.0, 2637.0], 0.04, "square", 0.2)
	streams["parry"] = _seq([2093.0, 3136.0, 2637.0], 0.05, "square", 0.25)
	streams["guard"] = _tone(1200.0, 1500.0, 0.04, "tri", 0.25)
	streams["windup"] = _tone(200.0, 420.0, 0.2, "saw", 0.15)
	streams["punch"] = _tone(1400.0, 200.0, 0.1, "noise", 0.35)
	streams["slam"] = _tone(140.0, 30.0, 0.35, "square", 0.45)
	streams["boss_die"] = _seq([523.0, 392.0, 330.0, 262.0, 196.0, 131.0], 0.12, "saw", 0.3)
	streams["glass"] = _tone(6000.0, 2800.0, 0.22, "noise", 0.32)
	streams["crack"] = _tone(700.0, 80.0, 0.22, "noise", 0.45)
	streams["crumble"] = _tone(420.0, 110.0, 0.3, "noise", 0.3)
	streams["creak"] = _tone(150.0, 110.0, 0.18, "saw", 0.12)
	streams["smash"] = _tone(1100.0, 150.0, 0.16, "noise", 0.42)
	streams["coins"] = _seq([1568.0, 1319.0, 1760.0, 2093.0], 0.04, "square", 0.13)
	streams["buy"] = _seq([784.0, 1047.0, 1568.0], 0.06, "square", 0.18)
	streams["deny"] = _seq([220.0, 196.0], 0.08, "square", 0.18)
	streams["blip"] = _tone(700.0, 760.0, 0.02, "square", 0.08)
	streams["charge"] = _tone(300.0, 900.0, 0.35, "tri", 0.18)


func play(sname: String, pitch := 1.0) -> void:
	if not streams.has(sname):
		return
	var pick: AudioStreamPlayer = players[0]
	for p in players:
		if not p.playing:
			pick = p
			break
	pick.stream = streams[sname]
	pick.pitch_scale = pitch * randf_range(0.95, 1.05)
	pick.volume_db = -8.0 + linear_to_db(maxf(volume, 0.0001))
	pick.play()


func _tone(f0: float, f1: float, dur: float, wave: String, vol: float) -> AudioStreamWAV:
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = 22050
	wav.stereo = false
	wav.data = _samples(f0, f1, dur, wave, vol)
	return wav


func _seq(notes: Array, dur: float, wave: String, vol: float) -> AudioStreamWAV:
	var data := PackedByteArray()
	for f in notes:
		data.append_array(_samples(f, f, dur, wave, vol))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = 22050
	wav.stereo = false
	wav.data = data
	return wav


func _samples(f0: float, f1: float, dur: float, wave: String, vol: float) -> PackedByteArray:
	var rate := 22050.0
	var n := int(dur * rate)
	var data := PackedByteArray()
	data.resize(n * 2)
	var phase := 0.0
	var nval := 0.0
	var last_cycle := -1
	for i in n:
		var k := float(i) / float(n)
		phase += lerpf(f0, f1, k) / rate
		var frac := phase - floorf(phase)
		var s := 0.0
		match wave:
			"square":
				s = 1.0 if frac < 0.5 else -1.0
			"saw":
				s = frac * 2.0 - 1.0
			"tri":
				s = absf(frac * 4.0 - 2.0) - 1.0
			"noise":
				var cyc := int(phase)
				if cyc != last_cycle:
					last_cycle = cyc
					nval = randf() * 2.0 - 1.0
				s = nval
		var env := (1.0 - k) * minf(1.0, float(i) / 60.0)
		data.encode_s16(i * 2, int(clampf(s * env * vol, -1.0, 1.0) * 32767.0))
	return data
