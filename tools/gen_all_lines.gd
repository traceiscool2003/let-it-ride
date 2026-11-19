extends SceneTree
## Writes voice/ALL_LINES.md: every voice line in the game, numbered, in one list,
## so you can record straight down the page. Also creates voice/all/ (the one-folder
## drop zone). Run: godot --headless --path . --script res://tools/gen_all_lines.gd

func _initialize() -> void:
	var VL = load("res://scripts/voice_lines.gd")
	var VP = load("res://scripts/voice_profiles.gd")
	var reg: Array = VL.registry()
	var order: Array = VP.ORDER.duplicate()
	var by_char := {}
	for e in reg:
		var c := String(e["char"])
		if not by_char.has(c):
			by_char[c] = []
			if not order.has(c):
				order.append(c)
		by_char[c].append(e)
	var s := "# Every voice line: record straight down this list\n\n"
	s += "There are **%d lines**. Work through them in order, one character at a time.\n\n" % reg.size()
	s += "## Two ways to record\n\n"
	s += "### Easiest: the in-game Voice Studio\n"
	s += "1. Open the project in Godot and press **F5**.\n"
	s += "2. Press **F6** anywhere in the game.\n"
	s += "3. Read the line on screen and press **R**. Say it, then press **R** again.\n"
	s += "4. It saves automatically, plays your take back, and **ENTER** moves to the next line.\n\n"
	s += "The studio tracks what you've recorded, so you can't lose your place. **N** jumps to the next line you haven't done.\n\n"
	s += "### One folder, with your own app (Audacity and so on)\n"
	s += "Save every file into the single folder **`voice/all/`**, using the file name in the table. Example: `voice/all/rico__greet_1.ogg`. `.ogg`, `.wav` or `.mp3` all work. The game finds them automatically.\n\n"
	s += "Tick the box for each line as you go.\n\n"
	var n := 0
	for c in order:
		if not by_char.has(c):
			continue
		var prof: Dictionary = VP.P.get(c, {})
		s += "---\n\n## %s" % String(prof.get("name", c.to_upper()))
		if prof.has("quote"):
			s += "  \"%s\"" % prof["quote"]
		s += "\n"
		if prof.has("pitch"):
			s += "*%s pitch, %s, %s energy. %s accent. %s.* Tip: %s\n\n" % [prof["pitch"], prof["speed"], prof["energy"], prof["accent"], prof["attitude"], prof.get("tip", "")]
		s += "| # | Done | File name (in voice/all/) | Line | How to say it |\n|---|---|---|---|---|\n"
		for e in by_char[c]:
			n += 1
			var flat := String(e["dir"]).replace("/", "-")
			s += "| %d | [ ] | `%s__%s.ogg` | %s | %s |\n" % [n, flat, e["id"], String(e["text"]).replace("|", "/"), String(e.get("note", "")).replace("|", "/")]
		s += "\n"
	var abs := ProjectSettings.globalize_path("res://voice/ALL_LINES.md")
	var f := FileAccess.open(abs, FileAccess.WRITE)
	f.store_string(s)
	f.close()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://voice/all"))
	var g := FileAccess.open(ProjectSettings.globalize_path("res://voice/all/README.txt"), FileAccess.WRITE)
	g.store_string("ONE-FOLDER DROP ZONE\n\nPut ALL your recorded voice lines here, named exactly as in voice/ALL_LINES.md,\ne.g. rico__greet_1.ogg  or  _cutscenes-intro__intro_3.wav\n\nThe in-game Voice Studio (F6) also saves its takes here.\n")
	g.close()
	print("wrote voice/ALL_LINES.md with ", n, " lines")
	quit()
