extends RefCounted
## The climb: 5 cities, 5 floors each (floors 1-4 explore, floor 5 = boss). Each
## city has a (parody) casino and earns a loyalty status when its boss falls.
## zone = level.gd palette (0 slot hall, 1 back rooms, 2 vault, 3 gold, 4 alley, 5 strip).

const FLOORS_PER_CITY := 5
const CITIES := [
	{"name": "ATLANTIC SHITTY", "casino": "RESORTZ", "full": "Atlantic Shitty: Resortz", "zone": 0, "alley_floors": 2,
		"status": "BRONZE", "perk": "Chips are worth +5%", "col": Color(0.8, 0.5, 0.25),
		"sub": "Salt air, soggy boardwalk, and a casino that smells like regret."},
	{"name": "RENO", "casino": "CIRRCUS CIRRCUS", "full": "Reno: Cirrcus Cirrcus", "zone": 1, "alley_floors": 0,
		"status": "SILVER", "perk": "Chips +10%", "col": Color(0.75, 0.78, 0.85),
		"sub": "The biggest little city. The smallest little odds."},
	{"name": "BILOXI", "casino": "HARD ROK", "full": "Biloxi: Hard Rok", "zone": 2, "alley_floors": 0,
		"status": "GOLD", "perk": "Chips +15%, shop prices -10%", "col": Color(1.0, 0.82, 0.3),
		"sub": "Guitars on the wall. Sharks in the water."},
	{"name": "FREMONT", "casino": "GOLDUN NUGGET", "full": "Fremont, Las Vegas: Goldun Nugget", "zone": 3, "alley_floors": 0,
		"status": "PLATINUM", "perk": "Chips +20%, +1 max life", "col": Color(0.85, 0.95, 1.0),
		"sub": "Old Vegas. Neon, gold, and a tank full of sharks."},
	{"name": "THE STRIP", "casino": "BELLAGIRO", "full": "The Strip: Bellagiro", "zone": 5, "alley_floors": 0,
		"status": "BLACK CARD", "perk": "Chips +30%", "col": Color(0.1, 0.1, 0.12),
		"sub": "The nicest casino in Vegas. The fountain alone costs more than you."},
]
const STATUS_ORDER := ["NONE", "BRONZE", "SILVER", "GOLD", "PLATINUM", "BLACK CARD"]


static func city_of(floor_num: int) -> int:
	return clampi((floor_num - 1) / FLOORS_PER_CITY, 0, CITIES.size() - 1)


static func floor_in_city(floor_num: int) -> int:
	return (floor_num - 1) % FLOORS_PER_CITY   # 0..4; 4 = boss floor


static func is_alley(floor_num: int) -> bool:
	return city_of(floor_num) == 0 and floor_in_city(floor_num) < int(CITIES[0]["alley_floors"]) and floor_num <= 5


static func zone_of(floor_num: int) -> int:
	if is_alley(floor_num):
		return 4
	return int(CITIES[city_of(floor_num)]["zone"])


## Loyalty status tier earned after beating `bosses_beaten_floor`'s boss (0 = none).
static func status_for(highest_boss_floor: int) -> int:
	return clampi(highest_boss_floor / FLOORS_PER_CITY, 0, 5)


static func status_name(tier: int) -> String:
	return STATUS_ORDER[clampi(tier, 0, 5)]


static func chip_bonus(tier: int) -> float:
	return [0.0, 0.05, 0.10, 0.15, 0.20, 0.30][clampi(tier, 0, 5)]


static func info(floor_num: int) -> Dictionary:
	return CITIES[city_of(floor_num)]
