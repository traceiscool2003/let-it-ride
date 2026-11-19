extends RefCounted
## Charms: run-long modifiers, the game's answer to Balatro's Jokers.
## You hold up to `max_slots`. They come from slot machines, Vera's table,
## Safe Doors and bosses.
##
## Every number a charm can change goes through one of the functions below
## (chip_value, cash_out, flow_drain_mult, ...), so charms stack and multiply.
## To add a charm: add an entry to DEFS, then handle its id in the matching
## function here, or in the main.gd hook for the event it reacts to
## (search main.gd for `charms.has(`).

const RARITY_COL := {
	"common": Color(0.82, 0.84, 0.92),
	"uncommon": Color(0.4, 0.9, 1.0),
	"rare": Color(1.0, 0.78, 0.25),
	"jackpot": Color(1.0, 0.35, 0.9),
}
const RARITY_WEIGHT := {"common": 55.0, "uncommon": 30.0, "rare": 12.0, "jackpot": 3.0}
## Price at Vera's table on the floors (paid from the Pot, scaled by floor).
const PRICE := {"common": 60, "uncommon": 110, "rare": 200, "jackpot": 350}
## Rare and jackpot charms start locked. Vera sells licenses in the Lobby
## (paid from your wallet) that add them to the drop pool for good.
const LICENSE := {"rare": 900, "jackpot": 2200}

const DEFS := {
	"chalk": {"name": "CHALK BAG", "desc": "Wall runs last 50% longer", "rarity": "common", "tags": ["WALL"]},
	"wallst": {"name": "WALL STREET", "desc": "Every wall run pays $3 x your Flow", "rarity": "common", "tags": ["WALL", "GREED"]},
	"cool": {"name": "COOL HEAD", "desc": "Flow drains half as fast", "rarity": "common", "tags": ["FLOW"]},
	"grease": {"name": "GREASED LIGHTNING", "desc": "Slides barely slow down", "rarity": "common", "tags": ["FLOW"]},
	"sliderule": {"name": "SLIDE RULE", "desc": "Slide-kicked enemies drop +$10", "rarity": "common", "tags": ["COMBAT", "GREED"]},
	"pickpocket": {"name": "PICKPOCKET", "desc": "Stomped enemies drop +$10", "rarity": "common", "tags": ["COMBAT", "GREED"]},
	"compd": {"name": "COMP'D", "desc": "Vera and Lucky charge 25% less", "rarity": "common", "tags": ["GREED"]},
	"magnet": {"name": "JACKPOT MAGNET", "desc": "Pull chips from much farther away", "rarity": "common", "tags": ["GREED"]},
	"hang": {"name": "HANG TIME", "desc": "Float longer at the top of every jump", "rarity": "uncommon", "tags": ["AIR"]},
	"reels": {"name": "WEIGHTED REELS", "desc": "Your first slot spin each floor is free", "rarity": "uncommon", "tags": ["LUCK"]},
	"counter": {"name": "CARD COUNTER", "desc": "Side bets pay double", "rarity": "uncommon", "tags": ["LUCK"]},
	"bankroll": {"name": "BANKROLL", "desc": "Cashing out pays +20%", "rarity": "uncommon", "tags": ["GREED"]},
	"ricochet": {"name": "RICOCHET", "desc": "Reflected shots deal +2 damage and drop chips", "rarity": "uncommon", "tags": ["COMBAT"]},
	"interest": {"name": "INTEREST FREE", "desc": "Repay Mags without the interest", "rarity": "uncommon", "tags": ["DEBT"]},
	"badcredit": {"name": "BAD CREDIT", "desc": "Chips worth +50% while you owe Mags", "rarity": "uncommon", "tags": ["DEBT", "GREED"]},
	"snake": {"name": "SNAKE EYES", "desc": "Stomps have a 1 in 6 chance to roll a lucky die", "rarity": "uncommon", "tags": ["LUCK", "COMBAT"]},
	"seven": {"name": "LUCKY SEVEN", "desc": "Every 7th chip you grab is worth 7x", "rarity": "uncommon", "tags": ["LUCK", "GREED"]},
	"feather": {"name": "FEATHERWEIGHT", "desc": "+1 air dash", "rarity": "rare", "tags": ["AIR"]},
	"double": {"name": "DOUBLE DOWN", "desc": "Chips grabbed in midair get your Flow multiplier twice", "rarity": "rare", "tags": ["AIR", "GREED"]},
	"heater": {"name": "ON A HEATER", "desc": "+25% chip value for every Let It Ride in a row", "rarity": "rare", "tags": ["RISK", "GREED"]},
	"spender": {"name": "BIG SPENDER", "desc": "Chips worth +50%, but -1 max life", "rarity": "rare", "tags": ["GREED", "RISK"]},
	"fineprint": {"name": "FINE PRINT", "desc": "Keep 25% of your Pot when you bust", "rarity": "rare", "tags": ["RISK"]},
	"allin": {"name": "ALL IN", "desc": "Let It Ride triples instead of doubling, but costs a life", "rarity": "rare", "tags": ["RISK"]},
	"housemoney": {"name": "HOUSE MONEY", "desc": "Chips worth double while riding at x4 or higher", "rarity": "jackpot", "tags": ["RISK", "GREED"]},
	"snowball": {"name": "SNOWBALL", "desc": "Every kill this floor makes chips worth +5% more (stacks)", "rarity": "uncommon", "tags": ["COMBAT", "GREED"]},
	"overdraft": {"name": "OVERDRAFT", "desc": "Nerve fills 50% faster from every hit", "rarity": "common", "tags": ["COMBAT"]},
	# Bad buffs (ugly clothes). Only slots, shady upgrades and Doc Fizz hand these out.
	"lead_boots": {"name": "LEAD BOOTS", "desc": "Jumps are 10% lower", "rarity": "common", "tags": ["BAD"], "bad": true},
	"itchy_wool": {"name": "ITCHY WOOL SWEATER", "desc": "Flow drains 50% faster", "rarity": "common", "tags": ["BAD"], "bad": true},
	"cheap_shades": {"name": "CHEAP SHADES", "desc": "Chips are worth 15% less", "rarity": "common", "tags": ["BAD"], "bad": true},
	"tight_pants": {"name": "TIGHT PANTS", "desc": "Run speed down 8%", "rarity": "common", "tags": ["BAD"], "bad": true},
	"rabbit": {"name": "RABBIT'S FOOT", "desc": "Once per floor, a lethal hit dumps your Pot instead", "rarity": "jackpot", "tags": ["LUCK", "RISK"]},
}

## One-line personality for the item cards (Isaac / Gungeon style).
const FLAVOR := {
	"chalk": "Smells like a gym and bad ideas.", "magnet": "Chips find you. So do debt collectors.", "seven": "Seven is a lie we agreed to believe.",
	"cool": "Ice in your veins, vodka in your flask.", "spender": "Money's for spending. Lives are for losing.", "heater": "Don't look at the numbers. Just feel them.",
	"rabbit": "Unlucky for the rabbit.", "allin": "Your mother warned you about this one.", "bankroll": "Your accountant just fainted.",
	"snowball": "Small avalanche. Big feelings.", "overdraft": "The bank will call. The bank is always calling.",
	"lead_boots": "Style over substance. Mostly lead.", "itchy_wool": "Grandma meant well.", "cheap_shades": "They make everything look cheap. Including you.",
	"tight_pants": "You can run. Barely. And never sit.",
}
var max_slots := 5
var equipped: Array = []
## Risk of Rain stacking: picking up a charm you already hold adds a stack.
var stacks := {}
var kill_stack := 0
## Rare/jackpot charm ids the player has licensed from Vera (persistent).
var licensed := {}
var seven_count := 0
var seven_proc := false
var rabbit_used := false
var free_spin := false


# ---------------------------------------------------------------- lookup

static func info(id: String) -> Dictionary:
	return DEFS.get(id, {"name": "?", "desc": "", "rarity": "common", "tags": []})


static func color(id: String) -> Color:
	return RARITY_COL.get(info(id)["rarity"], Color.WHITE)


static func is_locked_tier(id: String) -> bool:
	var r: String = info(id)["rarity"]
	return r == "rare" or r == "jackpot"


func has(id: String) -> bool:
	return equipped.has(id)


func count(id: String) -> int:
	return (1 + int(stacks.get(id, 0))) if equipped.has(id) else 0


func add_stack(id: String) -> void:
	stacks[id] = int(stacks.get(id, 0)) + 1


static func is_bad(id: String) -> bool:
	return bool(DEFS.get(id, {}).get("bad", false))


## Charms that look good: swag points for the wardrobe (bad ones are ugly).
static func swag_of(id: String) -> int:
	if is_bad(id):
		return -4
	return {"common": 1, "uncommon": 2, "rare": 4, "jackpot": 6}.get(String(info(id)["rarity"]), 1)


func roll_bad(rng: RandomNumberGenerator) -> String:
	var bad: Array = []
	for id in DEFS:
		if is_bad(id) and not equipped.has(id):
			bad.append(id)
	if bad.is_empty():
		return ""
	return bad[rng.randi_range(0, bad.size() - 1)]


func full() -> bool:
	return equipped.size() >= max_slots


func unlocked(id: String) -> bool:
	return not is_locked_tier(id) or licensed.has(id)


## Charms that can currently drop (not equipped, and licensed if needed).
func pool(rarity := "") -> Array:
	var out: Array = []
	for id in DEFS:
		if equipped.has(id) or not unlocked(id) or is_bad(id):
			continue
		if rarity == "" or DEFS[id]["rarity"] == rarity:
			out.append(id)
	return out


## Roll `n` different charms. `rarity` forces a tier ("" = weighted roll).
## Falls back to lower tiers when a tier is empty or still locked.
func roll(rng: RandomNumberGenerator, n: int, rarity := "") -> Array:
	var out: Array = []
	for _i in n:
		var r := rarity if rarity != "" else _roll_rarity(rng)
		var order := ["jackpot", "rare", "uncommon", "common"]
		var start := order.find(r)
		var picked := ""
		for k in range(maxi(0, start), order.size()):
			var cands: Array = pool(order[k]).filter(func(x): return not out.has(x))
			if cands.size() > 0:
				picked = cands[rng.randi_range(0, cands.size() - 1)]
				break
		if picked == "":
			var any: Array = pool().filter(func(x): return not out.has(x))
			if any.is_empty():
				break
			picked = any[rng.randi_range(0, any.size() - 1)]
		# Risk of Rain: sometimes the drop is another copy of something you hold (stacks).
		if rarity == "" and not equipped.is_empty() and rng.randf() < 0.12:
			var held: Array = equipped.filter(func(x): return not is_bad(x))
			if not held.is_empty():
				picked = held[rng.randi_range(0, held.size() - 1)]
		out.append(picked)
	return out


func _roll_rarity(rng: RandomNumberGenerator) -> String:
	var total := 0.0
	for k in RARITY_WEIGHT:
		total += RARITY_WEIGHT[k]
	var r := rng.randf() * total
	for k in RARITY_WEIGHT:
		r -= RARITY_WEIGHT[k]
		if r <= 0.0:
			return k
	return "common"


# ---------------------------------------------------------------- lifecycle

func reset_run() -> void:
	equipped.clear()
	stacks.clear()
	kill_stack = 0
	seven_count = 0
	rabbit_used = false
	free_spin = false


func reset_floor() -> void:
	kill_stack = 0
	rabbit_used = false
	free_spin = has("reels")


# ---------------------------------------------------------------- modifiers

## The chip-value pipeline. `ctx` keys: flow_mult, airborne, pot_mult,
## ride_streak, in_debt, extra_mult.
func chip_value(base: int, ctx: Dictionary) -> int:
	var fm: float = ctx.get("flow_mult", 1)
	var v := float(base) * fm * float(ctx.get("extra_mult", 1.0))
	if has("double") and ctx.get("airborne", false):
		v *= fm
	if has("spender"):
		v *= 1.5
	if has("snowball"):
		v *= 1.0 + 0.05 * kill_stack * count("snowball")
	if has("cheap_shades"):
		v *= 0.85
	if has("housemoney") and int(ctx.get("pot_mult", 1)) >= 4:
		v *= 2.0
	if has("badcredit") and ctx.get("in_debt", false):
		v *= 1.5
	if has("heater") and int(ctx.get("ride_streak", 0)) > 0:
		v *= 1.0 + 0.25 * int(ctx["ride_streak"])
	seven_proc = false
	if has("seven"):
		seven_count += 1
		if seven_count % 7 == 0:
			v *= 7.0
			seven_proc = true
	return maxi(1, int(round(v)))


func cash_out(gain: int) -> int:
	return int(round(gain * pow(1.2, count("bankroll"))))


func flow_drain_mult() -> float:
	return (0.5 if has("cool") else 1.0) * (1.5 if has("itchy_wool") else 1.0)


func magnet_mult() -> float:
	return pow(2.0, count("magnet")) if has("magnet") else 1.0


func price_mult() -> float:
	return 0.75 if has("compd") else 1.0


func bet_pay_mult() -> float:
	return 2.0 if has("counter") else 1.0


func ride_factor() -> int:
	return 3 if has("allin") else 2


func max_hp_delta() -> int:
	return -1 if has("spender") else 0


func dash_bonus() -> int:
	return 1 if has("feather") else 0


func insurance() -> float:
	return 0.25 if has("fineprint") else 0.0


## Movement changes from charms, applied on top of the run's config.
func apply_cfg(base: MovementConfig) -> MovementConfig:
	var c: MovementConfig = base.duplicate()
	if has("lead_boots"):
		c.jump_velocity *= 0.9
	if has("tight_pants"):
		c.max_run_speed *= 0.92
	if has("chalk"):
		c.wall_run_time *= 1.5
	if has("hang"):
		c.apex_gravity_mult *= 0.5
		c.apex_threshold *= 1.6
	if has("grease"):
		c.slide_friction *= 0.35
		c.slide_boost *= 1.4
	return c
