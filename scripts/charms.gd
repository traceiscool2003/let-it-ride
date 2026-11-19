extends RefCounted
## Charms: run-long modifiers, the game's answer to Balatro's Jokers.
## You hold up to `max_slots`. They come from slot machines, Vera's table,
## Vault Doors and bosses.
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
	"rabbit": {"name": "RABBIT'S FOOT", "desc": "Once per floor, a lethal hit dumps your Pot instead", "rarity": "jackpot", "tags": ["LUCK", "RISK"]},
}

var max_slots := 5
var equipped: Array = []
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


func full() -> bool:
	return equipped.size() >= max_slots


func unlocked(id: String) -> bool:
	return not is_locked_tier(id) or licensed.has(id)


## Charms that can currently drop (not equipped, and licensed if needed).
func pool(rarity := "") -> Array:
	var out: Array = []
	for id in DEFS:
		if equipped.has(id) or not unlocked(id):
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
	seven_count = 0
	rabbit_used = false
	free_spin = false


func reset_floor() -> void:
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
	return int(round(gain * (1.2 if has("bankroll") else 1.0)))


func flow_drain_mult() -> float:
	return 0.5 if has("cool") else 1.0


func magnet_mult() -> float:
	return 2.5 if has("magnet") else 1.0


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
	if has("chalk"):
		c.wall_run_time *= 1.5
	if has("hang"):
		c.apex_gravity_mult *= 0.5
		c.apex_threshold *= 1.6
	if has("grease"):
		c.slide_friction *= 0.35
		c.slide_boost *= 1.4
	return c
