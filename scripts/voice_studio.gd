extends CanvasLayer
## Autoload "VoiceStudio". Press F6 anywhere in the game to open the recording
## studio: it walks through EVERY voice line (and Rico's grunts) one at a time.
##   R        start / stop recording from your microphone (saves automatically)
##   SPACE    play the current line (your take, through that character's filter)
##   ENTER    next line            UP / DOWN  previous / next line
##   N        jump to the next line you haven't recorded yet
##   LEFT/RIGHT  show only one character (or ALL)
##   U        toggle "only show unrecorded lines"
##   DELETE   delete the take for this line
##   F6 / ESC close
## Takes save as WAV into res://voice/all/ when you run the game from the Godot
## editor (so they become part of the project), or user://voice/all/ otherwise.
## The game finds them automatically; see Voice.file_for().

const VL := preload("res://scripts/voice_lines.gd")
const VP := preload("res://scripts/voice_profiles.gd")

## Grunt takes recorded in the studio (Rico, the shared enemy voice, every boss).
const GRUNT_SLOTS := {
	"rico": [["jump", "A short 'hup!' / 'hah!'"], ["attack", "Sharp 'hyah!' / 'hnn!'"], ["dash", "Quick exhale 'hff!'"],
		["effort", "Strained 'nngh!' (vaults, grabs, stomps)"], ["slide", "'Whoa!'"], ["land", "'Oof!' (hard landing)"],
		["hurt", "'Agh!' / 'Ugh!' - it hurt"], ["death", "Long groan: 'Nooo... my chips...'"], ["parry", "Cocky 'Ha!' / 'Nope!'"], ["heal", "Relieved sigh"]],
	"enemy": [["death", "'Ugh!' / 'Argh!' - vary the voice every take"]],
}
const GRUNT_TAKES := 3

var is_open := false
var done_count := 0
var entries: Array = []          # every recordable line (dialogue + grunts)
var view: Array = []             # indices into entries after filters
var cur := 0
var char_filter := -1            # -1 = ALL, else index into VP.ORDER
var only_missing := false
var msg := ""
var msg_t := 0.0
var recording := false
var rec_t := 0.0
var was_paused := false
var mic_player: AudioStreamPlayer
var rec_effect: AudioEffectRecord
var rec_bus := -1
var ui: Control
var font: Font


func _ready() -> void:
	layer = 120
	process_mode = Node.PROCESS_MODE_ALWAYS
	ui = Control.new()
	ui.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.visible = false
	ui.draw.connect(_draw_ui)
	add_child(ui)
	font = ThemeDB.fallback_font


# ---------------------------------------------------------------- opening

func open() -> void:
	if is_open:
		return
	is_open = true
	was_paused = get_tree().paused
	get_tree().paused = true
	_build_entries()
	_refilter()
	_ensure_mic()
	Voice.clear_cache()
	done_count = _recorded_count()
	ui.visible = true
	_flash("Welcome to the studio. Press R to record the line on screen.")


func close() -> void:
	if recording:
		_stop_recording()
	is_open = false
	ui.visible = false
	Voice.stop()
	get_tree().paused = was_paused


func _build_entries() -> void:
	entries.clear()
	for e in VL.registry():
		entries.append(e)
	for who in GRUNT_SLOTS:
		for slot in GRUNT_SLOTS[who]:
			for n in range(1, GRUNT_TAKES + 1):
				entries.append({"char": who if who != "enemy" else "rico", "who": who, "id": "grunt_%s_%d" % [slot[0], n], "dir": who,
					"text": "(GRUNT) %s  - take %d" % [String(slot[0]).to_upper(), n], "speaker": who.to_upper(), "note": slot[1], "where": "Combat sound", "grunt": true})
	# Same order as voice/ALL_LINES.md: character by character (Rico first).
	var rank := {}
	for i in VP.ORDER.size():
		rank[String(VP.ORDER[i])] = i
	var keyed: Array = []
	for i in entries.size():
		keyed.append([int(rank.get(String(entries[i].get("who", entries[i]["char"])), 999)), i, entries[i]])
	keyed.sort_custom(func(a, b): return a[0] < b[0] or (a[0] == b[0] and a[1] < b[1]))
	entries = keyed.map(func(k): return k[2])


func _refilter() -> void:
	view.clear()
	var want := "" if char_filter < 0 else String(VP.ORDER[char_filter])
	for i in entries.size():
		var e: Dictionary = entries[i]
		if want != "" and String(e.get("who", e["char"])) != want and String(e["char"]) != want:
			continue
		if only_missing and has_take(e):
			continue
		view.append(i)
	cur = clampi(cur, 0, maxi(0, view.size() - 1))


func _current() -> Dictionary:
	if view.is_empty():
		return {}
	return entries[view[cur]]


# ---------------------------------------------------------------- files

## Where a new take is saved. Running from the editor writes into the project.
static func take_path(e: Dictionary) -> String:
	var flat := String(e["dir"]).replace("/", "-")
	if e.get("grunt", false):
		var base := "res://voice/%s/%s.wav" % [e["dir"], e["id"]] if OS.has_feature("editor") else "user://voice/%s/%s.wav" % [e["dir"], e["id"]]
		return base
	if OS.has_feature("editor"):
		return "res://voice/all/%s__%s.wav" % [flat, e["id"]]
	return "user://voice/all/%s__%s.wav" % [flat, e["id"]]


func has_take(e: Dictionary) -> bool:
	if e.get("grunt", false):
		for ext in ["wav", "ogg", "mp3"]:
			for root in ["res://voice/", "user://voice/"]:
				if FileAccess.file_exists(ProjectSettings.globalize_path("%s%s/%s.%s" % [root, e["dir"], e["id"], ext])):
					return true
		return false
	return Voice.has_file(e)


func _recorded_count() -> int:
	var n := 0
	for e in entries:
		if has_take(e):
			n += 1
	return n


# ---------------------------------------------------------------- microphone

func _ensure_mic() -> void:
	if rec_effect != null:
		return
	rec_bus = AudioServer.get_bus_index("StudioRecord")
	if rec_bus < 0:
		AudioServer.add_bus()
		rec_bus = AudioServer.bus_count - 1
		AudioServer.set_bus_name(rec_bus, "StudioRecord")
		AudioServer.set_bus_mute(rec_bus, true)   # don't play your mic back through the speakers
		rec_effect = AudioEffectRecord.new()
		AudioServer.add_bus_effect(rec_bus, rec_effect)
	else:
		rec_effect = AudioServer.get_bus_effect(rec_bus, 0) as AudioEffectRecord
	mic_player = AudioStreamPlayer.new()
	mic_player.stream = AudioStreamMicrophone.new()
	mic_player.bus = "StudioRecord"
	add_child(mic_player)
	mic_player.play()


func _start_recording() -> void:
	var e := _current()
	if e.is_empty():
		return
	if AudioServer.get_input_device_list().is_empty():
		_flash("No microphone found. Plug one in, then reopen the studio (F6).")
		return
	Voice.stop()
	rec_effect.set_recording_active(true)
	recording = true
	rec_t = 0.0
	_flash("RECORDING...  press R again to stop.")


func _stop_recording() -> void:
	rec_effect.set_recording_active(false)
	recording = false
	var take: AudioStreamWAV = rec_effect.get_recording()
	var e := _current()
	if take == null or e.is_empty() or rec_t < 0.25:
		_flash("Too short. Press R to try again.")
		return
	var path := take_path(e)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path).get_base_dir())
	var err := take.save_to_wav(ProjectSettings.globalize_path(path))
	Voice.clear_cache()
	Sfx.clear_grunt_cache()
	if err != OK:
		_flash("Couldn't save the take (error %d)." % err)
		return
	done_count = _recorded_count()
	_flash("Saved! SPACE to hear it, R to redo, ENTER for the next line.")
	_play_current()


func _play_current() -> void:
	var e := _current()
	if e.is_empty():
		return
	if e.get("grunt", false):
		var p := take_path(e)
		var st := Voice.load_stream(p)
		if st:
			Voice.player.bus = "Voice_" + String(e["who"]) if AudioServer.get_bus_index("Voice_" + String(e["who"])) >= 0 else "Voice"
			Voice.player.stream = st
			Voice.player.play()
		else:
			_flash("Nothing recorded for this grunt yet.")
		return
	if Voice.play_entry(e, String(e["char"])) <= 0.0:
		_flash("Nothing recorded for this line yet. Press R.")


func _delete_current() -> void:
	var e := _current()
	if e.is_empty():
		return
	var p := ProjectSettings.globalize_path(take_path(e))
	if FileAccess.file_exists(p):
		DirAccess.remove_absolute(p)
		Voice.clear_cache()
		Sfx.clear_grunt_cache()
		done_count = _recorded_count()
		_flash("Take deleted.")
	else:
		_flash("No studio take to delete for this line.")


# ---------------------------------------------------------------- input + loop

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return
	var k: int = (event as InputEventKey).physical_keycode
	if k == KEY_F6:
		if is_open:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()
		return
	if not is_open:
		return
	get_viewport().set_input_as_handled()
	match k:
		KEY_ESCAPE:
			close()
		KEY_R:
			if recording:
				_stop_recording()
			else:
				_start_recording()
		KEY_SPACE:
			if not recording:
				_play_current()
		KEY_ENTER, KEY_KP_ENTER, KEY_DOWN:
			if not recording:
				cur = mini(cur + 1, maxi(0, view.size() - 1))
				Voice.stop()
		KEY_UP:
			if not recording:
				cur = maxi(0, cur - 1)
				Voice.stop()
		KEY_PAGEDOWN:
			cur = mini(cur + 10, maxi(0, view.size() - 1))
		KEY_PAGEUP:
			cur = maxi(0, cur - 10)
		KEY_N:
			for j in range(cur + 1, view.size()):
				if not has_take(entries[view[j]]):
					cur = j
					break
		KEY_LEFT, KEY_RIGHT:
			char_filter += -1 if k == KEY_LEFT else 1
			if char_filter < -1:
				char_filter = VP.ORDER.size() - 1
			elif char_filter >= VP.ORDER.size():
				char_filter = -1
			cur = 0
			_refilter()
		KEY_U:
			only_missing = not only_missing
			_refilter()
			_flash("Showing only lines you still need to record." if only_missing else "Showing every line.")
		KEY_DELETE, KEY_BACKSPACE:
			_delete_current()


func _process(delta: float) -> void:
	if not is_open:
		return
	if recording:
		rec_t += delta
	msg_t = maxf(0.0, msg_t - delta)
	ui.queue_redraw()


func _flash(s: String) -> void:
	msg = s
	msg_t = 4.0


# ---------------------------------------------------------------- drawing

const GOLD := Color(1.0, 0.78, 0.25)
const DIM := Color(0.7, 0.72, 0.8)
const RED := Color(1.0, 0.25, 0.3)
const GREEN := Color(0.4, 1.0, 0.55)


func _t(p: Vector2, s: String, size: int, col: Color, align := HORIZONTAL_ALIGNMENT_LEFT, w := -1.0) -> void:
	ui.draw_string_outline(font, p, s, align, w, size, 4, Color(0, 0, 0, 0.8))
	ui.draw_string(font, p, s, align, w, size, col)


func _draw_ui() -> void:
	ui.draw_rect(Rect2(0, 0, 1280, 720), Color(0.03, 0.02, 0.06, 1.0))
	ui.draw_rect(Rect2(0, 0, 1280, 64), Color(0.08, 0.04, 0.12))
	_t(Vector2(32, 42), "VOICE STUDIO", 30, GOLD)
	var done := done_count
	_t(Vector2(300, 42), "%d / %d recorded" % [done, entries.size()], 20, Color.WHITE)
	var pk := float(done) / maxf(1.0, float(entries.size()))
	ui.draw_rect(Rect2(520, 26, 300, 14), Color(1, 1, 1, 0.1))
	ui.draw_rect(Rect2(520, 26, 300 * pk, 14), GREEN)
	var filt := "ALL CHARACTERS" if char_filter < 0 else String(VP.P[VP.ORDER[char_filter]]["name"])
	_t(Vector2(1248, 30), "Showing: " + filt + ("  (unrecorded only)" if only_missing else ""), 15, DIM, HORIZONTAL_ALIGNMENT_RIGHT, 400)
	_t(Vector2(1248, 52), "%d lines in view" % view.size(), 14, DIM, HORIZONTAL_ALIGNMENT_RIGHT, 400)
	var e := _current()
	if e.is_empty():
		_t(Vector2(0, 360), "Nothing left to record here. Nice work!", 28, GREEN, HORIZONTAL_ALIGNMENT_CENTER, 1280)
		return
	var cid := String(e.get("who", e["char"]))
	var prof: Dictionary = VP.P.get(cid, VP.P.get(String(e["char"]), {}))
	# Character card.
	var card := Rect2(32, 84, 1216, 128)
	ui.draw_rect(card, Color(1, 1, 1, 0.05))
	ui.draw_rect(Rect2(card.position, Vector2(6, card.size.y)), GOLD)
	_t(Vector2(56, 120), String(prof.get("name", cid.to_upper())), 28, Color.WHITE)
	if prof.has("quote"):
		_t(Vector2(56, 148), "\"" + String(prof["quote"]) + "\"", 18, GOLD)
	if prof.has("pitch"):
		_t(Vector2(56, 174), "Pitch: %s   Speed: %s   Energy: %s   Accent: %s" % [prof["pitch"], prof["speed"], prof["energy"], prof["accent"]], 15, DIM)
		_t(Vector2(56, 198), "Attitude: %s    Tip: %s" % [prof["attitude"], prof.get("tip", "")], 15, DIM)
	# The line itself, big.
	_t(Vector2(56, 252), "LINE %d of %d    (%s)" % [cur + 1, view.size(), String(e["id"])], 16, DIM)
	var rec := has_take(e)
	_t(Vector2(1224, 252), "RECORDED" if rec else "NOT RECORDED YET", 18, GREEN if rec else Color(1, 0.6, 0.4), HORIZONTAL_ALIGNMENT_RIGHT, 300)
	ui.draw_multiline_string(font, Vector2(56, 300), String(e["text"]), HORIZONTAL_ALIGNMENT_LEFT, 1170, 32, 4, Color.WHITE)
	_t(Vector2(56, 460), "How to say it: " + String(e.get("note", "")), 18, Color(0.6, 0.9, 1.0))
	_t(Vector2(56, 488), "Where it plays: " + String(e.get("where", "")), 15, DIM)
	# Recording meter.
	if recording:
		var pulse := 0.6 + 0.4 * sin(rec_t * 8.0)
		ui.draw_circle(Vector2(70, 552), 14, Color(RED, pulse))
		_t(Vector2(96, 560), "RECORDING  %.1fs" % rec_t, 24, RED)
		var db := AudioServer.get_bus_peak_volume_left_db(rec_bus, 0) if rec_bus >= 0 else -80.0
		var lvl := clampf((db + 60.0) / 60.0, 0.0, 1.0)
		ui.draw_rect(Rect2(340, 540, 500, 20), Color(1, 1, 1, 0.1))
		ui.draw_rect(Rect2(340, 540, 500 * lvl, 20), GREEN if lvl < 0.85 else RED)
		_t(Vector2(860, 557), "too loud!" if lvl >= 0.85 else "", 16, RED)
	# Up-next list.
	for j in range(1, 4):
		if cur + j < view.size():
			var ne: Dictionary = entries[view[cur + j]]
			_t(Vector2(56, 560 + j * 22 + (24 if recording else 0)), "next: " + String(ne["text"]).left(110), 14, Color(DIM, 0.6))
	if msg_t > 0.0:
		_t(Vector2(0, 668), msg, 18, GOLD, HORIZONTAL_ALIGNMENT_CENTER, 1280)
	ui.draw_rect(Rect2(0, 684, 1280, 36), Color(0.08, 0.04, 0.12))
	_t(Vector2(0, 708), "R record/stop   SPACE play   ENTER next   UP/DOWN move   N next unrecorded   LEFT/RIGHT character   U unrecorded only   DEL delete   F6 close", 14, DIM, HORIZONTAL_ALIGNMENT_CENTER, 1280)
