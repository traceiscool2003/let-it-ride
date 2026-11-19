extends SceneTree
## Voice kit checks: line ids are unique and complete, every character has a profile,
## buses exist, fallback blips work. godot --headless --path . --script res://tests/voice_test.gd

var fails := 0


func check(ok: bool, msg: String) -> void:
	print(("ok    " if ok else "FAIL  ") + msg)
	if not ok:
		fails += 1


func _initialize() -> void:
	var VL = load("res://scripts/voice_lines.gd")
	var VP = load("res://scripts/voice_profiles.gd")
	var reg: Array = VL.registry()
	check(reg.size() > 800, "registry has %d lines" % reg.size())
	var seen := {}
	var dups := 0
	var counts := {}
	for e in reg:
		var k := String(e["dir"]) + "/" + String(e["id"])
		if seen.has(k):
			dups += 1
			print("  dup: ", k)
		seen[k] = true
		counts[e["char"]] = int(counts.get(e["char"], 0)) + 1
		if not VP.P.has(e["char"]):
			print("  no profile: ", e["char"])
			fails += 1
	check(dups == 0, "all line ids unique (%d duplicates)" % dups)
	for cid in ["vera", "fizz", "tailor", "gunny", "lucky", "mags", "marlow", "jules", "rico"]:
		check(int(counts.get(cid, 0)) >= 40, "%s has %d lines (>= 40)" % [cid, counts.get(cid, 0)])
	for cid in ["velma", "dumpster_dan", "slick_nick", "lorraine", "dunn", "comp"]:
		check(int(counts.get(cid, 0)) >= 15, "%s has %d lines (>= 15)" % [cid, counts.get(cid, 0)])
	var named := 0
	for cid in VP.ORDER:
		if int(counts.get(cid, 0)) > 0:
			named += 1
	check(named >= 12, "%d voiced characters" % named)
	var crowd := 0
	for t in ["tourist", "junkie", "pitboss", "drunk", "bouncer", "hustler"]:
		crowd += int(counts.get(t, 0))
	check(crowd >= 60 + 12, "crowd barks per city >= 60 (shared+city = %d)" % crowd)
	_late = true
	_vl = VL


var _late := false
var _vl
var _n := 0


func _process(_d: float) -> bool:
	_n += 1
	if _n < 3:
		return false
	var VL = _vl
	var v = root.get_node_or_null("Voice")
	check(v != null, "Voice autoload present")
	if v:
		check(AudioServer.get_bus_index("Voice_rico") >= 0 and AudioServer.get_bus_index("Voice_the_house") >= 0, "per-character buses exist")
		v.set_filters(false)
		v.set_filters(true)
		check(v.speak("RICO", "Let it ride, baby!") == 0.0, "no file -> fallback blips")
	var e0: Dictionary = VL.lookup("MARLOW", "Rico! You picked up. So the rumors are true: The House doesn't let debtors die. It just sends them home with a bigger bill.")
	check(not e0.is_empty() and e0["id"] == "marlow_intro_1", "dialogue line resolves to marlow_intro_1")
	print("voice test: ", fails, " failed")
	quit(1 if fails > 0 else 0)
	return true
