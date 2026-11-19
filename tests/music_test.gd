extends SceneTree
## Renders every zone's theme and each boss phase offline; checks non-silence, no NaN, and CPU cost.
func _init() -> void:
	var M = load("res://scripts/music.gd").new()
	M._ready()
	M.pb = null
	var fails := 0
	for z in [4, 0, 1, 2, 3, 5, 6]:
		M.zone = z
		M.fade = 0.0
		var t0 := Time.get_ticks_usec()
		var peak := 0.0
		var rms := 0.0
		var bad := false
		var total := 0
		for c in 40:
			var b: PackedVector2Array = M.render(1100, 0.05)
			for v in b:
				if is_nan(v.x) or is_nan(v.y):
					bad = true
				peak = maxf(peak, absf(v.x))
				rms += v.x * v.x
			total += b.size()
		var us := float(Time.get_ticks_usec() - t0) / total
		var ok: bool = not bad and peak > 0.05 and peak <= 1.0
		print("zone %d %s: peak %.2f rms %.3f  %.1f us/sample (budget 45)" % [z, M.st["name"], peak, sqrt(rms / total), us], "" if ok else "  FAIL")
		if not ok:
			fails += 1
	# boss phases + battle intensity
	M.zone = 3
	M.mix = 1.0
	M.intensity = 1.0
	M.boss_mode = true
	M.boss_music = {"bpm": 156, "root": 49.0, "mode": "phrygian", "lead": "square"}
	for ph in [1, 2, 3]:
		M.boss_phase = ph
		var t0 := Time.get_ticks_usec()
		var peak := 0.0
		var total := 0
		var bad := false
		for c in 40:
			var b: PackedVector2Array = M.render(1100, 0.05)
			for v in b:
				if is_nan(v.x):
					bad = true
				peak = maxf(peak, absf(v.x))
			total += b.size()
		var us := float(Time.get_ticks_usec() - t0) / total
		var ok: bool = not bad and peak > 0.1
		print("boss phase %d: peak %.2f  %.1f us/sample" % [ph, peak, us], "" if ok else "  FAIL")
		if not ok:
			fails += 1
	print("music test: %d failed" % fails)
	quit(fails)
