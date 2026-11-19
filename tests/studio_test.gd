extends SceneTree
## Voice Studio + one-folder lookup: godot --headless --path . --script res://tests/studio_test.gd
var fails := 0
var frame := 0


func check(ok: bool, what: String) -> void:
	print(("PASS  " if ok else "FAIL  ") + what)
	if not ok:
		fails += 1


func _process(_d: float) -> bool:
	frame += 1
	if frame < 3:
		return false
	var st = root.get_node("VoiceStudio")
	var vo = root.get_node("Voice")
	st.open()
	check(st.is_open and get_root_paused(), "F6 studio opens and pauses the game")
	check(st.entries.size() > 900, "studio lists every line plus grunts (%d)" % st.entries.size())
	var e: Dictionary = st._current()
	check(not e.is_empty(), "first line is shown")
	var p: String = st.take_path(e)
	check(p.begins_with("res://voice/all/") and p.ends_with(".wav"), "editor takes save into voice/all (" + p + ")")
	# Fake a take: half a second of a tone, saved where the studio would save it.
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = 22050
	var data := PackedByteArray()
	data.resize(22050)
	for i in 11025:
		data.encode_s16(i * 2, int(sin(i * 0.05) * 8000.0))
	wav.data = data
	var abs := ProjectSettings.globalize_path(p)
	DirAccess.make_dir_recursive_absolute(abs.get_base_dir())
	wav.save_to_wav(abs)
	vo.clear_cache()
	check(vo.file_for(e) == p, "Voice finds the one-folder take")
	check(vo.load_stream(p) != null, "fresh un-imported take loads")
	check(st.has_take(e), "studio marks the line as recorded")
	st._delete_current()
	vo.clear_cache()
	check(not st.has_take(e), "delete removes the take")
	st.cur = 0
	st._input(_key(KEY_DOWN))
	check(st.cur == 1, "DOWN moves to the next line")
	st._input(_key(KEY_U))
	check(st.only_missing, "U filters to unrecorded lines")
	st.close()
	check(not st.is_open, "studio closes")
	print("studio test: %d failed" % fails)
	return true


func get_root_paused() -> bool:
	return paused


func _key(k: int) -> InputEventKey:
	var ev := InputEventKey.new()
	ev.physical_keycode = k
	ev.pressed = true
	return ev
