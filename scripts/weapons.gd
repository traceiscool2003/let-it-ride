extends RefCounted
## Ranged weapons. One is equipped at a time (TAB cycles owned ones, G fires).
## cost: "pot" = dollars from the Pot per shot, "ammo" = rounds from that weapon's
## magazine (refilled by kills and vendors), "nerve" = Nerve meter points.
## shape drives how projectile.gd draws it.

const DEFS := {
	"chip_flick": {"name": "CHIP FLICK", "desc": "Flick a chip. Costs $1 of your Pot. Fast and cheap.", "cost": "pot", "amt": 1, "cd": 0.22,
		"dmg": 1, "speed": 330.0, "shots": 1, "spread": 0.0, "grav": 0.0, "life": 1.2, "shape": "chip", "col": Color(1.0, 0.35, 0.35), "price": 0, "ammo": 0},
	"card_throw": {"name": "CARD FAN", "desc": "Three razor cards in a fan. Pierces one target.", "cost": "ammo", "amt": 1, "cd": 0.4,
		"dmg": 1, "speed": 300.0, "shots": 3, "spread": 0.22, "grav": 0.0, "life": 0.9, "shape": "card", "col": Color(1, 1, 1), "pierce": 1, "price": 120, "ammo": 24},
	"dice_bomb": {"name": "DICE BOMB", "desc": "A lobbed die that explodes on impact. Snake eyes = bigger boom.", "cost": "ammo", "amt": 1, "cd": 0.7,
		"dmg": 3, "speed": 200.0, "shots": 1, "spread": 0.0, "grav": 520.0, "life": 2.0, "shape": "die", "col": Color(0.95, 0.95, 0.9), "explode": 30.0, "arc": -0.5, "price": 180, "ammo": 8},
	"bottle_toss": {"name": "BOTTLE TOSS", "desc": "Cheap hooch bottle. Shatters and staggers.", "cost": "ammo", "amt": 1, "cd": 0.55,
		"dmg": 2, "speed": 190.0, "shots": 1, "spread": 0.0, "grav": 480.0, "life": 2.0, "shape": "bottle", "col": Color(0.3, 0.7, 0.35), "explode": 18.0, "stun": 0.8, "arc": -0.4, "price": 90, "ammo": 12},
	"snub": {"name": "SNUB REVOLVER", "desc": "Six rounds, big recoil, hits hard.", "cost": "ammo", "amt": 1, "cd": 0.5,
		"dmg": 3, "speed": 520.0, "shots": 1, "spread": 0.0, "grav": 0.0, "life": 0.9, "shape": "bullet", "col": Color(1.0, 0.85, 0.4), "recoil": 120.0, "price": 260, "ammo": 12},
	"roulette": {"name": "ROULETTE CANNON", "desc": "A ball that bounces three times. Costs Nerve.", "cost": "nerve", "amt": 20, "cd": 0.8,
		"dmg": 2, "speed": 260.0, "shots": 1, "spread": 0.0, "grav": 420.0, "life": 3.2, "shape": "ball", "col": Color(0.85, 0.1, 0.15), "bounces": 3, "price": 300, "ammo": 0},
	"boomerang": {"name": "CASH-BAND BOOMERANG", "desc": "A rubber-banded stack of bills. Flies out, flies back, pierces. $5.", "cost": "pot", "amt": 5, "cd": 0.9,
		"dmg": 2, "speed": 260.0, "shots": 1, "spread": 0.0, "grav": 0.0, "life": 1.5, "shape": "cash", "col": Color(0.4, 0.8, 0.4), "boomerang": true, "pierce": 99, "price": 220, "ammo": 0},
	"shotgun": {"name": "COIN SHOTGUN", "desc": "Six silver dollars at close range.", "cost": "ammo", "amt": 1, "cd": 0.85,
		"dmg": 1, "speed": 340.0, "shots": 6, "spread": 0.5, "grav": 60.0, "life": 0.45, "shape": "coin", "col": Color(0.85, 0.85, 0.95), "recoil": 90.0, "price": 280, "ammo": 8},
}
const START := "chip_flick"


static func info(id: String) -> Dictionary:
	return DEFS.get(id, DEFS["chip_flick"])


static func ids() -> Array:
	return DEFS.keys()
