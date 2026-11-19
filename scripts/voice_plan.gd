extends RefCounted
## Which lines go on the RECORDING LIST (the "medium" set, about 450 lines).
## Everything else still plays in the game as text with that character's voice
## blips. If you record an extra line anyway, it just starts playing; nothing
## else changes. The F6 studio and voice/ALL_LINES.md show this list by default.
##
## Recorded:
##   - every cutscene line and every story/quest conversation line
##   - main characters: 2 versions of each moment (greet, broke, died...)
##   - minor NPCs: 1 version of each moment
##   - bosses: intro, defeat, phase 2, phase 3 (hits use your grunts)
##   - crowd: 2 general barks per crowd type
##   - the cat: 3 meows
## Text-only (blips): the extra variations, boss taunts/hurt/kill barks, repeat
## filler chats, and the rest of the crowd chatter.

const GENERIC := ["greet", "farewell", "rich", "broke", "ugly", "sharp", "died", "boss", "idle", "buy"]
const MAIN_CHARS := ["rico", "marlow", "vera", "mags", "lucky", "jules", "tailor", "fizz", "gunny"]
const CROWD := ["tourist", "junkie", "pitboss", "drunk", "bouncer", "hustler"]
const BOSS_KEEP := ["intro", "defeat", "phase2", "phase3"]
const BOSS_SKIP := ["hurt", "kill", "taunt"]


## Split "greet_2" into ["greet", 2]; ids without a number get 0.
static func split_id(id: String) -> Array:
	var i := id.rfind("_")
	if i > 0 and id.substr(i + 1).is_valid_int():
		return [id.substr(0, i), int(id.substr(i + 1))]
	return [id, 0]


static func should_record(e: Dictionary) -> bool:
	if e.get("grunt", false):
		return true
	var dir := String(e.get("dir", ""))
	if dir.begins_with("_cutscenes"):
		return true
	var cid := String(e.get("char", ""))
	var parts := split_id(String(e.get("id", "")))
	var ctx: String = parts[0]
	var n: int = parts[1]
	if cid == "comp":
		return (ctx == "greet" and n == 1) or (ctx == "idle" and n <= 2)
	if CROWD.has(cid):
		if ctx == "bark":
			return n <= 2
		if ctx.begins_with("city"):
			return false
		return true
	if BOSS_KEEP.has(ctx):
		return true
	if BOSS_SKIP.has(ctx):
		return false
	if GENERIC.has(ctx):
		return n <= (2 if MAIN_CHARS.has(cid) else 1)
	# Repeatable filler conversations ("marlow_rep1" ...) stay text-only.
	if ctx.contains("_rep"):
		return false
	# Story, quest and one-off lines (Marlow's radio, Mags' loans, boss replies...).
	return true
