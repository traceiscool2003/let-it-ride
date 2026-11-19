extends Node
## Autoload. Plays voice acting for every dialogue line.
##
## - If res://voice/<dir>/<line_id>.ogg (or .wav / .mp3) exists, that clip plays.
## - Otherwise it falls back to synthesized Animal-Crossing-style blips, pitched
##   per character (see voice_profiles.gd).
## - Each character has its own AudioServer bus "Voice_<id>" with PitchShift, EQ,
##   Distortion, Chorus and Reverb effects so ONE performer sounds like many.
##   Settings > Audio: Voice Volume and "Voice Filters" (turn off if you baked the
##   effects in with Audacity).

const VP := preload("res://scripts/voice_profiles.gd")
const VL := preload("res://scripts/voice_lines.gd")
const EXTS := ["ogg", "wav", "mp3"]
const RATE := 22050

var volume := 1.0
var filters_on := true
var blips_on := true
var player: AudioStreamPlayer
var blip_players: Array[AudioStreamPlayer] = []
var blip_streams := {}
var clip_len := 0.0
var clip_t := 0.0
var clip_active := false
var last_char := ""
var last_blip_at := -1
var _file_cache := {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_buses()
	player = AudioStreamPlayer.new()
	player.bus = "Voice"
	add_child(player)
	for i in 3:
		var bp := AudioStreamPlayer.new()
		bp.bus = "Voice"
		bp.volume_db = -6.0
		add_child(bp)
		blip_players.append(bp)
	for id in VP.P:
		var bl: Dictionary = VP.P[id]["blip"]
		blip_streams[id] = _make_blip(float(bl["hz"]), String(bl["wave"]))


func _process(delta: float) -> void:
	if clip_active:
		clip_t += delta
		if clip_t >= clip_len or not player.playing:
			clip_active = false


func set_volume(v: float) -> void:
	volume = clampf(v, 0.0, 1.0)
	var idx := AudioServer.get_bus_index("Voice")
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, linear_to_db(maxf(0.0001, volume)))
		AudioServer.set_bus_mute(idx, volume <= 0.0)


func set_filters(on: bool) -> void:
	filters_on = on
	for id in VP.P:
		var idx := AudioServer.get_bus_index("Voice_" + id)
		if idx < 0:
			continue
		for e in AudioServer.get_bus_effect_count(idx):
			AudioServer.set_bus_effect_enabled(idx, e, on)


func _build_buses() -> void:
	if AudioServer.get_bus_index("Voice") < 0:
		AudioServer.add_bus()
		var vi := AudioServer.bus_count - 1
		AudioServer.set_bus_name(vi, "Voice")
		AudioServer.set_bus_send(vi, "Master")
	for id in VP.P:
		var bname := "Voice_" + String(id)
		if AudioServer.get_bus_index(bname) >= 0:
			continue
		AudioServer.add_bus()
		var bi := AudioServer.bus_count - 1
		AudioServer.set_bus_name(bi, bname)
		AudioServer.set_bus_send(bi, "Voice")
		var pr: Dictionary = VP.P[id]["preset"]
		if absf(float(pr["pitch"])) >= 0.25:
			var ps := AudioEffectPitchShift.new()
			ps.pitch_scale = VP.scale_of(float(pr["pitch"]))
			AudioServer.add_bus_effect(bi, ps)
		var eq := AudioEffectEQ6.new()
		# Bands: 32, 100, 320, 1000, 3200, 10000 Hz.
		eq.set_band_gain_db(0, float(pr["eq_low"]))
		eq.set_band_gain_db(1, float(pr["eq_low"]))
		eq.set_band_gain_db(2, float(pr["eq_mid"]) * 0.5)
		eq.set_band_gain_db(3, float(pr["eq_mid"]))
		eq.set_band_gain_db(4, float(pr["eq_high"]))
		eq.set_band_gain_db(5, float(pr["eq_high"]))
		AudioServer.add_bus_effect(bi, eq)
		if float(pr["dist"]) > 0.0:
			var d := AudioEffectDistortion.new()
			d.mode = AudioEffectDistortion.MODE_LOFI
			d.drive = float(pr["dist"])
			d.post_gain = -3.0
			AudioServer.add_bus_effect(bi, d)
		if float(pr["chorus"]) > 0.0:
			var ch := AudioEffectChorus.new()
			ch.wet = float(pr["chorus"]) * 0.5
			AudioServer.add_bus_effect(bi, ch)
		if float(pr["reverb"]) > 0.0:
			var rv := AudioEffectReverb.new()
			rv.wet = float(pr["reverb"]) * 0.6
			rv.room_size = 0.5
			AudioServer.add_bus_effect(bi, rv)


func _make_blip(hz: float, wave: String) -> AudioStreamWAV:
	var n := int(RATE * 0.055)
	var data := PackedByteArray()
	data.resize(n * 2)
	var ph := 0.0
	for i in n:
		var k := float(i) / float(n)
		var env := minf(1.0, k * 12.0) * (1.0 - k)
		ph += (hz * (1.0 + 0.12 * (1.0 - k))) / RATE
		var f := fmod(ph, 1.0)
		var v := 0.0
		match wave:
			"square": v = 1.0 if f < 0.5 else -1.0
			"saw": v = f * 2.0 - 1.0
			_: v = absf(f * 4.0 - 2.0) - 1.0
		data.encode_s16(i * 2, int(clampf(v * env * 0.55, -1.0, 1.0) * 32767.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = RATE
	w.data = data
	return w


## Path of the voice file for a line entry, or "" if the user hasn't recorded it.
func file_for(entry: Dictionary) -> String:
	if entry.is_empty():
		return ""
	var base := "res://voice/%s/%s" % [entry["dir"], entry["id"]]
	if _file_cache.has(base):
		return _file_cache[base]
	var found := ""
	for e in EXTS:
		if ResourceLoader.exists(base + "." + e):
			found = base + "." + e
			break
	_file_cache[base] = found
	return found


func has_file(entry: Dictionary) -> bool:
	return file_for(entry) != ""


func clear_cache() -> void:
	_file_cache.clear()


## Start voicing a dialogue line. Returns the clip length in seconds, or 0.0 when
## only blips will play (the caller then calls blip() as the text types out).
func speak(speaker: String, text: String) -> float:
	var entry: Dictionary = VL.lookup(speaker, text)
	var cid: String = entry.get("char", VP.id_for(speaker))
	last_char = cid
	last_blip_at = -1
	return play_entry(entry, cid)


func play_entry(entry: Dictionary, cid := "") -> float:
	stop()
	if cid == "":
		cid = String(entry.get("char", "rico"))
	var path := file_for(entry)
	if path == "":
		return 0.0
	var st = load(path)
	if st == null or not (st is AudioStream):
		return 0.0
	player.bus = "Voice_" + cid if AudioServer.get_bus_index("Voice_" + cid) >= 0 else "Voice"
	player.stream = st
	player.play()
	clip_len = (st as AudioStream).get_length()
	clip_t = 0.0
	clip_active = true
	return clip_len


func stop() -> void:
	if player and player.playing:
		player.stop()
	clip_active = false


func is_playing() -> bool:
	return clip_active and player != null and player.playing


## Call as text types out: one blip every `rate` visible characters (fallback voice).
func blip(speaker: String, chars_shown: int, text: String) -> void:
	if not blips_on or is_playing() or volume <= 0.0:
		return
	var cid := last_char if last_char != "" else VP.id_for(speaker)
	if not VP.P.has(cid):
		cid = "rico"
	var rate := int(VP.P[cid]["blip"]["rate"])
	if chars_shown <= 0 or chars_shown == last_blip_at or chars_shown % rate != 0:
		return
	if chars_shown - 1 < text.length() and text[chars_shown - 1] in " .,!?-":
		return
	last_blip_at = chars_shown
	for bp in blip_players:
		if not bp.playing:
			bp.bus = "Voice_" + cid if AudioServer.get_bus_index("Voice_" + cid) >= 0 else "Voice"
			bp.stream = blip_streams[cid]
			bp.pitch_scale = randf_range(0.85, 1.25)
			bp.play()
			return
