extends SceneTree
## Regenerates the whole voice kit from the line registry:
##   voice/<char>/README.txt, voice/_cutscenes/<scene>/README.txt, VOICE_CAST.md,
##   VOICE_SCRIPT.md, HOW_TO_RECORD.md
## Run: godot --headless --path . --script res://tools/gen_voice_kit.gd
## (Edit lines in scripts/voice_lines*.gd, profiles in scripts/voice_profiles.gd, then re-run.)

var VL
var VP


func _w(path: String, text: String) -> void:
	var abs := ProjectSettings.globalize_path("res://" + path)
	DirAccess.make_dir_recursive_absolute(abs.get_base_dir())
	var f := FileAccess.open(abs, FileAccess.WRITE)
	f.store_string(text)
	f.close()


func _initialize() -> void:
	VL = load("res://scripts/voice_lines.gd")
	VP = load("res://scripts/voice_profiles.gd")
	var reg: Array = VL.registry()
	var by_char := {}
	var by_dir := {}
	for e in reg:
		if not by_char.has(e["char"]):
			by_char[e["char"]] = []
		by_char[e["char"]].append(e)
		if not by_dir.has(e["dir"]):
			by_dir[e["dir"]] = []
		by_dir[e["dir"]].append(e)
	# --- voice/ folders
	for dir in by_dir:
		var lines: Array = by_dir[dir]
		var t := ""
		var is_scene := String(dir).begins_with("_cutscenes")
		if is_scene:
			t += "CUTSCENE FOLDER: %s\n" % dir
			t += "Drop one file per line below, named exactly like the ID (e.g. %s.ogg).\nThe game plays the clip during the cutscene and waits for it to finish. Players can skip.\n\n" % lines[0]["id"]
		else:
			var pr: Dictionary = VP.P[dir]
			t += "VOICE FOLDER: %s  (%s)\n%s\n\n" % [pr["name"], dir, pr["role"]]
			t += "HOW TO PERFORM: %s\nACTING TIP: %s\n" % [pr["quote"], pr["tip"]]
			t += "AUDACITY RECIPE: %s\n\n" % VP.recipe(dir)
			t += "SUPER SIMPLE VOICE-CHANGING GUIDE (beginner):\n"
			t += " 1. Install Audacity (free): audacityteam.org.\n 2. Click the red Record button and say a line. Click Stop.\n"
			t += " 3. Trim the silence at both ends (drag, press Delete).\n"
			t += " 4. EASY WAY: skip effects. Just act the voice using the tip above, export, done.\n"
			t += " 5. BAKED WAY: press Ctrl+A, then use Effect > Pitch and Tempo > Change Pitch, Effect > EQ and Filters > Bass and Treble,\n    Effect > Distortion and Modulation > Distortion, Effect > Delay and Reverb > Reverb with the recipe below.\n"
			t += " 6. File > Export > Export as OGG. Name the file exactly like the ID. Save it in this folder.\n"
			t += " 7. Test: open Godot, press F5, press F3 (Voice Test), pick this character, press Enter.\n"
			t += " Live voice changer (optional, free): Clownfish Voice Changer. Free version has basic presets only.\n\n"
			t += "SIMPLE VERSION: record each line CLEAN (no effects), name it like the ID, drop it here. The game adds this character's voice filter for you.\n"
			t += "Or bake the recipe in with Audacity, then turn OFF Settings > Audio > Voice Filters.\n\n"
		t += "FILES EXPECTED (.ogg, 44.1 kHz, mono). %d lines:\n\n" % lines.size()
		for e in lines:
			t += "%s.ogg\n    SAY: \"%s\"\n    HOW: %s  (%s)\n" % [e["id"], e["text"], e["note"], e["where"]]
			if is_scene:
				t += "    SPEAKER: %s\n" % e["speaker"]
			t += "\n"
		_w("voice/%s/README.txt" % dir, t)
		_w("voice/%s/.gitkeep" % dir, "")
	# --- VOICE_CAST.md
	var cast := "# VOICE CAST\n\nOne card per character. You perform ALL of them, so each card tells you how to sound different, plus the in-game filter preset that helps (see `scripts/voice_profiles.gd`).\n\nPitch numbers are semitones; EQ numbers are dB.\n\n"
	for cid in VP.ORDER:
		var p: Dictionary = VP.P[cid]
		var pr: Dictionary = p["preset"]
		cast += "## %s\n> \"%s\"\n\n" % [p["name"], p["quote"]]
		cast += "**Role:** %s\n\n" % p["role"]
		cast += "| | |\n|---|---|\n| Age | %s |\n| Accent | %s |\n| Pitch | %s |\n| Speed | %s |\n| Energy | %s |\n| Attitude | %s |\n| Sounds like | %s |\n| Mouth tricks | %s |\n" % [p["age"], p["accent"], p["pitch"], p["speed"], p["energy"], p["attitude"], p["ref"], p["mouth"]]
		cast += "| Acting tip | %s |\n" % p["tip"]
		cast += "| In-engine filter | pitch %+.0f st, EQ low %+.0f / mid %+.0f / high %+.0f dB, distortion %d%%, reverb %d%%, chorus %d%% |\n" % [pr["pitch"], pr["eq_low"], pr["eq_mid"], pr["eq_high"], int(float(pr["dist"]) * 100), int(float(pr["reverb"]) * 100), int(float(pr["chorus"]) * 100)]
		cast += "| Lines to record | %d (folder `voice/%s/`) |\n\n" % [by_char.get(cid, []).size(), cid]
	_w("VOICE_CAST.md", cast)
	# --- VOICE_SCRIPT.md
	var sc := "# VOICE SCRIPT\n\nEvery voiced line, grouped by character, then by scene/context. Name the file exactly like the Line ID (`<id>.ogg`) and put it in the folder shown. The game finds it by itself, no code changes.\n\nTotal lines: %d.\n\nCutscene lines live under `voice/_cutscenes/<scene>/`.\n\n" % reg.size()
	for cid in VP.ORDER:
		var lines2: Array = by_char.get(cid, [])
		if lines2.is_empty():
			continue
		sc += "## %s (`%s`) - %d lines\n\n" % [VP.P[cid]["name"], cid, lines2.size()]
		var wheres := []
		for e in lines2:
			if not wheres.has(e["where"]):
				wheres.append(e["where"])
		for w in wheres:
			sc += "### %s\n\n| Line ID | Text | Direction | Folder |\n|---|---|---|---|\n" % w
			for e in lines2:
				if e["where"] == w:
					sc += "| `%s` | %s | %s | `voice/%s/` |\n" % [e["id"], String(e["text"]).replace("|", "/"), String(e["note"]), e["dir"]]
			sc += "\n"
	_w("VOICE_SCRIPT.md", sc)
	# --- HOW_TO_RECORD.md
	_w("HOW_TO_RECORD.md", _how_to(by_char))
	print("voice kit written: %d lines, %d folders" % [reg.size(), by_dir.size()])
	quit(0)


func _how_to(by_char: Dictionary) -> String:
	var h := """# HOW TO RECORD THE VOICES

You are the voice of EVERY character. This guide is for a total beginner. Short steps, no jargon.

Files you will use:
- `VOICE_CAST.md`: how each character should sound.
- `VOICE_SCRIPT.md`: every line to record.
- This file: step-by-step instructions, one recipe card per character, and a tick-box list.

---

## PART 1: Set up (10 minutes, once)

1. Go to https://www.audacityteam.org and download **Audacity**. It is free.
2. Install it. Open it.
3. Plug in your microphone (a headset mic or phone earbuds mic is fine).
4. In Audacity, look at the top bar. Pick your mic in the box that shows a microphone icon.
5. Set the channels box to **1 (Mono) Recording Channel**.
6. Click the big red **Record** button. Say "testing one two three". Click **Stop** (black square).
7. Click the **Play** button. If you can hear yourself clearly, you are ready.

Mic tips:
- Record in a quiet room. A closet full of clothes is a great free studio.
- Keep your mouth about a hand-width (10 cm) from the mic.
- Do not touch the mic while you talk. Turn off fans.
- If the green bar hits the right edge, you are too loud: move back.

## PART 2: Record one line (the loop)

Do this for every line.

1. Open `VOICE_SCRIPT.md` or the checklist below. Find the line.
2. Click **Record**. Count "one, two" in your head. Say the line with the acting direction.
3. Click **Stop**.
4. If it was bad, press **Ctrl+Z** and record again. Do not worry about perfect: the game is funny anyway.
5. Cut the silence: click and drag across the quiet part at the start, press **Delete**. Do the same at the end. Leave a tiny gap (a blink).
6. Click **File > Export > Export as OGG**.
7. In the export window: choose the folder `voice/<character>/` inside the game folder. Type the file name from the table, for example `greet_1`. Click **Save**. If it asks for metadata, click **OK**.
8. Click **File > New** and do the next line.

Export settings (if Audacity asks): **OGG Vorbis, quality 5, 44100 Hz, mono**.

TIP: record ten lines in a row in ONE long take with pauses, then **Analyze > Label Sounds**, then **File > Export > Export Multiple** to chop them. Only try this when the basic loop feels easy.

---

## PART 3: Making one person sound like many (super simple)

You have TWO ways. Pick one and stick with it.

### Way A (the easy way): record clean, let the game do the effect
1. Record every line in your normal voice, but ACT it (see the card: slow, gruff, fast, high...).
2. Do not use any effect in Audacity.
3. Drop the files in. The game gives every character a different pitch, EQ, grit and echo automatically (`scripts/voice_profiles.gd`).
4. In the game: **Settings > Audio > Voice Filters = On** (it is On by default).

This is the easier way because you never touch an effect and you can change a character's filter later without re-recording.

### Way B: bake the effect into the file with Audacity
1. Do the recording steps from Part 2.
2. Before you export, press **Ctrl+A** (select all).
3. Use the recipe card for the character (Part 5). Click the effect menus exactly as below:
   - **Effect > Pitch and Tempo > Change Pitch**: type the semitones in "Semitones (half-steps)". Click **Apply**.
   - **Effect > EQ and Filters > Bass and Treble**: set the Bass and Treble numbers (dB). **Apply**.
   - **Effect > Distortion and Modulation > Distortion**: set the percent from the card (use the "Hard Clipping" type). **Apply**.
   - **Effect > Delay and Reverb > Reverb**: set "Reverb" to the percent on the card, Room Size 40. **Apply**.
4. Export as OGG.
5. In the game: **Settings > Audio > Voice Filters = Off**, otherwise the effect is applied twice.

### Optional: hear the voice LIVE while you act
You can use a real-time voice changer so you hear the character while you perform. A good FREE one for Windows is **Clownfish Voice Changer** (https://clownfish-translator.com). It is free, needs no account and sits in the system tray: right-click it, choose **Set Voice Changer**, pick a voice (like Robot or Deep) and record in Audacity with the mic set to Clownfish's output. Its limit: it has only about a dozen basic presets. **Voicemod** (https://www.voicemod.net) also has a free tier, but its free version only offers a rotating selection of voices and locks the rest to Pro, so check what is free that day. You do NOT need either tool: the game's filters do the same job.

---

## PART 4: Test it in the game

1. Put the file in the right folder, for example `voice/vera/greet_1.ogg`.
2. Open the project in **Godot** (the editor). Wait for it to import the new files (a bar at the bottom).
3. Press **F5** to run the game.
4. Press **F3** at any time to open the **Voice Test** menu. Left/Right picks a character, Up/Down picks a line, **Enter** plays it. A `[x]` means the game found your file. `[ ]` means not found (check the name and folder).
5. To hear a line in a real scene: talk to the character in the Lobby, or start a run and reach the place named in the "where" column.
6. If you do not hear your file: check the spelling, check that it is `.ogg`, and press Enter again in the test menu.

---

## PART 5: Recipe cards (one per character)

Each card: the Audacity settings to bake in (Way B), and an acting tip. If you use Way A, ignore the numbers and just read the tip.

"""
	for cid in VP.ORDER:
		var p: Dictionary = VP.P[cid]
		h += "**%s** (`voice/%s/`)\n- Audacity: %s\n- Acting tip: %s\n- Sound like: %s\n\n" % [p["name"], cid, VP.recipe(cid), p["tip"], p["ref"]]
	h += "---\n\n## PART 6: Recording checklist (go down the list)\n\nRecord one character's whole list in one sitting: same voice, same energy. Tick the box when the file is exported. The filename is the Line ID plus `.ogg`.\n\n"
	for cid in VP.ORDER:
		var lines: Array = by_char.get(cid, [])
		if lines.is_empty():
			continue
		var p2: Dictionary = VP.P[cid]
		h += "### %s: %d lines\n\nFolder: `voice/%s/` (cutscene lines go in the folder shown). Voice: %s.\n\n| # | Done | File name | Say this | How |\n|---|---|---|---|---|\n" % [p2["name"], lines.size(), cid, p2["tip"]]
		var n := 1
		for e in lines:
			h += "| %d | [ ] | `%s/%s.ogg` | %s | %s |\n" % [n, e["dir"], e["id"], String(e["text"]).replace("|", "/"), String(e["note"])]
			n += 1
		h += "\n"
	return h
