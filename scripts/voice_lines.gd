extends RefCounted
## The single source of truth for every voiced line. Both the dialogue code (to find
## the voice file for a line) and tools/gen_voice_kit.gd (to write VOICE_SCRIPT.md,
## HOW_TO_RECORD.md and the voice/ folders) read registry().
##
## An entry: {char, id, dir, text, speaker, note, where}
##   file = res://voice/<dir>/<id>.ogg   (dir is the character id, or
##   "_cutscenes/<scene>" for cutscene lines)

const Main := preload("res://scripts/voice_lines_main.gd")
const Misc := preload("res://scripts/voice_lines_misc.gd")
const VP := preload("res://scripts/voice_profiles.gd")
const Story := preload("res://scripts/story.gd")
const Dialogue := preload("res://scripts/dialogue.gd")
const BossDefs := preload("res://scripts/boss_defs.gd")

const CTX_NOTE := {
	"greet": "Greeting the player. In character.", "farewell": "Parting words as the player leaves.", "rich": "The player is carrying a lot of money.",
	"broke": "The player is nearly broke.", "ugly": "The player is wearing ugly clothes.", "sharp": "The player is dressed sharp.",
	"died": "The player just died.", "boss": "The player just beat a boss.", "idle": "Idle chatter. Random.", "buy": "The player just bought something.",
	"phase2": "Boss reaches phase 2. Furious, stronger.", "phase3": "Boss reaches the final phase. Desperate and angry.", "taunt": "Boss taunt during an attack.",
	"hurt": "Boss gets hit. Grunt-style.", "kill": "Boss kills the player. Gloating.",
}
const CROWD_TYPES := ["tourist", "junkie", "pitboss", "drunk", "bouncer", "hustler"]

static var _cache: Array = []
static var _index: Dictionary = {}


static func _add(out: Array, char_id: String, id: String, dir: String, text: String, speaker: String, note: String, where: String) -> void:
	out.append({"char": char_id, "id": id, "dir": dir, "text": text, "speaker": speaker, "note": note, "where": where})


static func registry() -> Array:
	if not _cache.is_empty():
		return _cache
	var out: Array = []
	# Main + minor NPC pools.
	for cid in Main.POOLS:
		var pools: Dictionary = Main.POOLS[cid]
		for ctx in pools:
			var arr: Array = pools[ctx]
			for i in arr.size():
				_add(out, cid, "%s_%d" % [ctx, i + 1], cid, arr[i], String(VP.P[cid]["name"]), CTX_NOTE.get(ctx, ""), "NPC talk (%s)" % ctx)
	for cid in Misc.MINOR:
		var pools2: Dictionary = Misc.MINOR[cid]
		for ctx in pools2:
			var arr2: Array = pools2[ctx]
			for i in arr2.size():
				_add(out, cid, "%s_%d" % [ctx, i + 1], cid, arr2[i], String(VP.P[cid]["name"]), CTX_NOTE.get(ctx, ""), "NPC talk (%s)" % ctx)
	# Bosses: intro/defeat from the boss defs, plus per-boss barks.
	var defs: Array = BossDefs.POOL.duplicate()
	defs.append_array(BossDefs.SECRET)
	defs.append(BossDefs.FINAL)
	for d in defs:
		var bid: String = d["id"] if d["id"] != "house" else "the_house"
		var bn: String = d["name"]
		_add(out, bid, "intro_1", bid, String(d["line_intro"]), bn, "Boss intro cutscene. Menacing. " + String(d["title"]) + " themed.", "Boss intro")
		_add(out, "rico", "boss_intro_" + bid, "rico", String(d.get("rico_intro", "Deal me in.")), "RICO", "Hero cockily answers the boss.", "Boss intro (hero reply)")
		_add(out, bid, "defeat_1", bid, String(d["line_defeat"]), bn, "Boss defeat. Falling apart.", "Boss defeat")
		_add(out, "rico", "boss_defeat_" + bid, "rico", String(d.get("rico_defeat", "Read 'em and weep, pal.")), "RICO", "Hero victory line. Smug.", "Boss defeat (hero reply)")
		var key: String = bid
		if Misc.BOSS.has(key):
			var arr3: Array = Misc.BOSS[key]
			var counts := {}
			for i in arr3.size():
				var c: String = Misc.BOSS_CTX[i]
				counts[c] = int(counts.get(c, 0)) + 1
				_add(out, bid, "%s_%d" % [c, counts[c]], bid, arr3[i], bn, CTX_NOTE.get(c, ""), "Boss fight (%s)" % c)
	# Crowd barks.
	for t in Misc.CROWD:
		var arr4: Array = Misc.CROWD[t]
		for i in arr4.size():
			_add(out, t, "bark_%d" % (i + 1), t, arr4[i], String(VP.P[t]["name"]), "Random crowd bark, any city.", "Crowd bark")
	for c in Misc.CITY_CROWD.size():
		var arr5: Array = Misc.CITY_CROWD[c]
		for i in arr5.size():
			var t2: String = CROWD_TYPES[i % CROWD_TYPES.size()]
			_add(out, t2, "city%d_%d" % [c + 1, i + 1], t2, arr5[i], String(VP.P[t2]["name"]), "Crowd bark flavored for city %d." % (c + 1), "Crowd bark (city %d)" % (c + 1))
	# New cutscenes.
	for sc in Misc.SCENES:
		var arr6: Array = Misc.SCENES[sc]
		for i in arr6.size():
			var sp: String = arr6[i][0]
			_add(out, VP.id_for(sp), "%s_%d" % [sc, i + 1], "_cutscenes/" + sc, String(arr6[i][1]), sp, "Cutscene: " + sc.replace("_", " "), "Cutscene " + sc)
	# Existing story cutscenes.
	_story_set(out, "intro", Story.INTRO, true)
	_story_set(out, "intro_cast", [Story.CAST["VERA"], Story.CAST["LUCKY"]], true)
	_story_set(out, "mags_chase", Story.MAGS_CHASE, true)
	_story_set(out, "ending", Story.ENDING, true)
	_story_set(out, "true_ending", Story.TRUE_ENDING, true)
	_story_set(out, "radio", Story.RADIO, false)
	_story_set(out, "first_exit", Story.FIRST_EXIT, false)
	# Hub conversations.
	for e in Dialogue.LINES:
		var lines: Array = e["lines"]
		for i in lines.size():
			var sp2: String = lines[i][0]
			_add(out, VP.id_for(sp2), "%s_%d" % [e["id"], i + 1], VP.id_for(sp2), String(lines[i][1]), sp2, "Conversation: " + String(e["id"]), "Lobby conversation")
	# House PA announcements.
	for ev in Dialogue.BARKS:
		var arr7: Array = Dialogue.BARKS[ev]
		for i in arr7.size():
			_add(out, "the_house", "pa_%s_%d" % [ev, i + 1], "the_house", String(arr7[i]), "THE HOUSE", "PA announcement. Polite, chilling.", "PA (%s)" % ev)
	for e in out:
		if e["char"] == "":
			e["char"] = "rico"
	_cache = out
	for e in out:
		_index[String(e["speaker"]).to_upper() + "|" + String(e["text"])] = e
		_index["*|" + String(e["text"])] = e
	return out


static func _story_set(out: Array, set_id: String, lines: Array, scene: bool) -> void:
	for i in lines.size():
		var sp: String = lines[i][0]
		var cid := VP.id_for(sp)
		if cid == "":
			cid = "rico"
		_add(out, cid, "%s_%d" % [set_id, i + 1], ("_cutscenes/" + set_id) if scene else cid, String(lines[i][1]), sp, ("Cutscene: " if scene else "Radio/lobby: ") + set_id.replace("_", " "), ("Cutscene " if scene else "") + set_id)


## Find the entry for a spoken dialogue line (null-ish empty dict if not scripted).
static func lookup(speaker: String, text: String) -> Dictionary:
	registry()
	var k := speaker.to_upper() + "|" + text
	if _index.has(k):
		return _index[k]
	return _index.get("*|" + text, {})


static func contexts_for(state: Dictionary) -> Array:
	var c: Array = []
	if state.get("died", false): c.append("died")
	if state.get("boss", false): c.append("boss")
	if state.get("ugly", false): c.append("ugly")
	if state.get("sharp", false): c.append("sharp")
	if state.get("rich", false): c.append("rich")
	if state.get("broke", false): c.append("broke")
	c.append("greet")
	c.append("idle")
	return c


## Pick a context-aware line for an NPC: reacts to winning/losing/clothes/etc.
## Returns {char, id, text, ctx} or {} when the NPC has no pool.
static func pick(char_id: String, state: Dictionary, rng: RandomNumberGenerator, ctx_override := "") -> Dictionary:
	var pool: Dictionary = {}
	if Main.POOLS.has(char_id):
		pool = Main.POOLS[char_id]
	elif Misc.MINOR.has(char_id):
		pool = Misc.MINOR[char_id]
	if pool.is_empty():
		return {}
	var ctxs := contexts_for(state) if ctx_override == "" else [ctx_override]
	ctxs = ctxs.filter(func(c): return pool.has(c))
	if ctxs.is_empty():
		return {}
	# Reactive contexts win ~70% of the time; otherwise greet/idle.
	var ctx: String = ctxs[0] if (ctxs.size() > 2 and rng.randf() < 0.7) else ctxs[rng.randi_range(0, ctxs.size() - 1)]
	var arr: Array = pool[ctx]
	var i := rng.randi_range(0, arr.size() - 1)
	return {"char": char_id, "id": "%s_%d" % [ctx, i + 1], "text": arr[i], "ctx": ctx}
