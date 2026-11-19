extends RefCounted
## Enemy roster. Enemies get more professional as you climb the 5 cities:
## 0 alley, 1 low-rent casino, 2 mid-tier, 3 high-end, 4 the Strip.
## kind numbers 0-3 are the original Guard / Bat / Dealer / Heavy (enemy.gd
## handles those); kinds 4+ are the ranged "pattern" enemies defined here.
## beh: needle (arc lob), rat (melee scurry), lob (bottle), burst (aimed volley),
## snipe (long telegraph, one fast shot), drone (flying shooter), fan (spread).

const T := {
	0: {"name": "ALLEY THUG", "cities": [0, 1], "w": 3.0},
	2: {"name": "CARD DEALER", "cities": [1, 2, 3], "w": 2.0},
	3: {"name": "BOUNCER", "cities": [1, 2, 3, 4], "w": 1.6},
	4: {"name": "JUNKIE", "cities": [0, 1], "w": 3.0, "beh": "needle", "hp": 2, "speed": 28.0, "proj": "needle", "pspeed": 130.0, "cd": [1.9, 2.8], "tele": 0.6, "col": Color(0.55, 0.62, 0.4)},
	5: {"name": "SEWER RAT", "cities": [0], "w": 2.5, "beh": "rat", "hp": 1, "speed": 78.0, "size": Vector2(10, 7), "col": Color(0.4, 0.34, 0.3)},
	6: {"name": "BOTTLE THROWER", "cities": [0, 1], "w": 2.5, "beh": "lob", "hp": 2, "speed": 24.0, "proj": "bottle", "pspeed": 170.0, "cd": [1.6, 2.4], "tele": 0.55, "col": Color(0.45, 0.35, 0.2)},
	7: {"name": "SHARK DEALER", "cities": [1, 2], "w": 2.0, "beh": "fan", "hp": 3, "speed": 30.0, "proj": "chip", "pspeed": 150.0, "cd": [2.0, 3.0], "tele": 0.6, "shots": 3, "col": Color(0.6, 0.1, 0.4)},
	8: {"name": "PIT BOSS", "cities": [2, 3], "w": 2.2, "beh": "burst", "hp": 4, "speed": 34.0, "proj": "bullet", "pspeed": 190.0, "cd": [1.8, 2.6], "tele": 0.5, "shots": 3, "col": Color(0.2, 0.3, 0.55)},
	9: {"name": "SUITED SECURITY", "cities": [3, 4], "w": 3.0, "beh": "burst", "hp": 5, "speed": 40.0, "proj": "bullet", "pspeed": 230.0, "cd": [1.4, 2.0], "tele": 0.4, "shots": 2, "col": Color(0.08, 0.08, 0.12)},
	10: {"name": "SNIPER", "cities": [3, 4], "w": 1.6, "beh": "snipe", "hp": 3, "speed": 0.0, "proj": "bullet", "pspeed": 380.0, "cd": [2.8, 3.6], "tele": 1.1, "col": Color(0.1, 0.12, 0.18)},
	11: {"name": "HEIR APPARENT", "cities": [4], "w": 1.5, "beh": "fan", "hp": 6, "speed": 32.0, "proj": "chip", "pspeed": 170.0, "cd": [1.8, 2.4], "tele": 0.5, "shots": 5, "col": Color(0.95, 0.8, 0.25)},
	12: {"name": "SECURITY DRONE", "cities": [3, 4], "w": 1.0, "beh": "drone", "hp": 2, "speed": 60.0, "proj": "bullet", "pspeed": 200.0, "cd": [1.3, 1.9], "tele": 0.35, "air": true, "col": Color(0.6, 0.65, 0.75)},
	13: {"name": "STREET BAT", "cities": [0, 1, 2], "w": 1.0, "air": true},
}


## Sprite sheet per enemy kind (assets/chars): [sheet, hue_shift per city 0..4, sat, val].
## Kinds without an entry (bats, rats, drones) keep the procedural rig.
const SHEETS := {
	0: ["city_men_2", [0.0, 0.08, 0.3, 0.5, 0.7], 1.0, 0.9],
	2: ["city_men_3", [0.0, 0.1, 0.3, 0.55, 0.75], 1.0, 0.95],
	3: ["gangsters_2", [0.0, 0.1, 0.3, 0.5, 0.7], 0.9, 0.85],
	4: ["city_men_2", [0.3, 0.35, 0.4, 0.45, 0.5], 0.5, 0.75],
	6: ["city_men_1", [0.35, 0.4, 0.55, 0.65, 0.8], 0.8, 0.85],
	7: ["city_men_3", [0.65, 0.7, 0.75, 0.8, 0.85], 1.0, 0.9],
	8: ["gangsters_3", [0.0, 0.0, 0.0, 0.1, 0.2], 1.0, 1.0],
	9: ["gangsters_3", [0.0, 0.0, 0.0, 0.0, 0.0], 0.35, 0.55],
	10: ["gangsters_1", [0.0, 0.0, 0.0, 0.0, 0.0], 0.6, 0.6],
	11: ["gangsters_3", [0.0, 0.0, 0.0, 0.12, 0.12], 1.2, 1.1],
}


## Later-city gunmen swap to the tommy-gun sheet.
static func sheet_for(kind: int, city: int) -> Array:
	var d: Array = SHEETS.get(kind, [])
	if d.is_empty():
		return d
	if (kind == 8 and city >= 3) or (kind == 9 and city >= 4):
		return ["gangsters_1", [0.0, 0.0, 0.0, 0.0, 0.0], 0.9, 0.9]
	return d


static func info(kind: int) -> Dictionary:
	return T.get(kind, {})


static func city_of(floor_num: int) -> int:
	return clampi((floor_num - 1) / 5, 0, 4)


## Pick a ground (air=false) or air kind for a floor.
static func pick(floor_num: int, air: bool, rng: RandomNumberGenerator) -> int:
	var city := city_of(floor_num)
	var opts: Array = []
	var total := 0.0
	for k in T:
		var d: Dictionary = T[k]
		if bool(d.get("air", false)) != air or not (d["cities"] as Array).has(city):
			continue
		opts.append(k)
		total += float(d["w"])
	if opts.is_empty():
		return 1 if air else 0
	var r := rng.randf() * total
	for k in opts:
		r -= float(T[k]["w"])
		if r <= 0.0:
			return 13 if k == 13 else k
	return opts[0]


static func name_of(kind: int) -> String:
	match kind:
		1, 13: return "BAT"
		_: return String(T.get(kind, {}).get("name", "SECURITY"))
