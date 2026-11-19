extends RefCounted
## The road-trip loading screen: Rico drives the highway to the next city.
## Both the car and the skyline climb with the city index, from a smoking rust
## bucket past a creepy skyline (city 0) up to a gold-trimmed supercar under the
## Strip's lights (city 4). Everything is drawn in code.

const Scenery := preload("res://scripts/scenery.gd")

## Per city: sky stops, horizon haze, building tint, lit-window colour and chance,
## skyline height, roadside style.
const LOOKS := [
	{"sky": [Color(0.06, 0.07, 0.04), Color(0.2, 0.19, 0.1), Color(0.33, 0.27, 0.14)], "haze": Color(0.45, 0.4, 0.2, 0.35),
		"bld": Color(0.07, 0.07, 0.06), "win": Color(0.9, 0.75, 0.3), "lit": 0.12, "h": [60.0, 150.0], "road": Color(0.13, 0.12, 0.11),
		"sign": "ATLANTIC SHITTY", "miles": "13", "moon": Color(0.85, 0.8, 0.5, 0.5)},
	{"sky": [Color(0.08, 0.04, 0.12), Color(0.35, 0.14, 0.24), Color(0.75, 0.38, 0.25)], "haze": Color(0.9, 0.5, 0.3, 0.25),
		"bld": Color(0.1, 0.06, 0.12), "win": Color(1.0, 0.8, 0.45), "lit": 0.3, "h": [70.0, 190.0], "road": Color(0.15, 0.13, 0.14),
		"sign": "RENO", "miles": "28", "moon": Color(1.0, 0.85, 0.6, 0.0)},
	{"sky": [Color(0.04, 0.07, 0.12), Color(0.12, 0.22, 0.3), Color(0.35, 0.45, 0.45)], "haze": Color(0.5, 0.65, 0.65, 0.25),
		"bld": Color(0.06, 0.09, 0.12), "win": Color(1.0, 0.9, 0.6), "lit": 0.45, "h": [80.0, 220.0], "road": Color(0.14, 0.15, 0.17),
		"sign": "BILOXI", "miles": "41", "moon": Color(0.9, 0.95, 1.0, 0.7)},
	{"sky": [Color(0.02, 0.01, 0.06), Color(0.1, 0.03, 0.18), Color(0.4, 0.1, 0.35)], "haze": Color(1.0, 0.3, 0.7, 0.25),
		"bld": Color(0.05, 0.03, 0.09), "win": Color(1.0, 0.85, 0.4), "lit": 0.65, "h": [100.0, 260.0], "road": Color(0.12, 0.11, 0.15),
		"sign": "FREMONT ST.", "miles": "7", "moon": Color(1.0, 0.9, 0.95, 0.6)},
	{"sky": [Color(0.01, 0.02, 0.08), Color(0.05, 0.08, 0.25), Color(0.25, 0.2, 0.5)], "haze": Color(1.0, 0.85, 0.5, 0.3),
		"bld": Color(0.04, 0.05, 0.1), "win": Color(1.0, 0.92, 0.7), "lit": 0.85, "h": [140.0, 330.0], "road": Color(0.1, 0.1, 0.13),
		"sign": "THE STRIP", "miles": "2", "moon": Color(1.0, 1.0, 1.0, 0.8)},
]

const HORIZON := 360.0
const ROAD_TOP := 400.0


static func draw(ci: CanvasItem, f: Font, city: int, t: float) -> void:
	city = clampi(city, 0, LOOKS.size() - 1)
	var L: Dictionary = LOOKS[city]
	var sky: Array = L["sky"]
	Scenery.vgrad(ci, Rect2(0, 0, 1280, HORIZON + 10), [[0.0, sky[0]], [0.6, sky[1]], [1.0, sky[2]]])
	_stars_or_moon(ci, city, L, t)
	_skyline(ci, f, city, L, t)
	ci.draw_rect(Rect2(0, HORIZON - 30, 1280, 60), Color(L["haze"], (L["haze"] as Color).a * 0.6))
	_roadside(ci, f, city, L, t)
	_road(ci, city, L, t)
	_car(ci, city, Vector2(450, 524), t)
	_exit_sign(ci, f, city, L, t)


# ---------------------------------------------------------------- sky + skyline

static func _stars_or_moon(ci: CanvasItem, city: int, L: Dictionary, t: float) -> void:
	var stars := 20 + city * 25
	for i in stars:
		var x := Scenery.rnd(i * 3 + city) * 1280.0
		var y := Scenery.rnd(i * 7 + 11) * (HORIZON - 160.0)
		var tw := 0.5 + 0.5 * sin(t * 2.0 + i)
		ci.draw_rect(Rect2(x, y, 2, 2), Color(1, 1, 0.9, (0.15 + 0.35 * tw) * (0.4 if city == 0 else 1.0)))
	var mc: Color = L["moon"]
	if mc.a > 0.0:
		var mp := Vector2(1040 - city * 60, 110)
		Scenery.glow(ci, mp, 70, 70, Color(mc, mc.a * 0.25))
		ci.draw_circle(mp, 30, mc)
		if city == 0:
			# A sickly moon half-eaten by smog.
			ci.draw_circle(mp + Vector2(12, -6), 26, Color((L["sky"] as Array)[1], 0.9))
	if city == 1:
		# Desert sunset over Reno.
		var sp := Vector2(900, HORIZON - 20)
		Scenery.glow(ci, sp, 220, 90, Color(1.0, 0.5, 0.2, 0.25))
		ci.draw_circle(sp, 46, Color(1.0, 0.62, 0.3, 0.9))


static func _skyline(ci: CanvasItem, f: Font, city: int, L: Dictionary, t: float) -> void:
	var h: Array = L["h"]
	var bld: Color = L["bld"]
	var win: Color = L["win"]
	var lit: float = L["lit"]
	# Two parallax layers that drift slowly, so the city feels far away.
	for layer in 2:
		var spd := 6.0 + layer * 10.0
		var scale := 0.7 + layer * 0.3
		var col := bld.lightened(0.08 * (1 - layer))
		var off := fmod(t * spd, 1400.0)
		var x := -off
		var i := 0
		while x < 1300.0:
			var seed := i * 13 + layer * 101 + city * 7
			var bw := (34.0 + Scenery.rnd(seed) * 60.0) * scale
			var bh := lerpf(h[0], h[1], Scenery.rnd(seed + 1)) * scale
			var bx := x
			var top := HORIZON - bh
			ci.draw_rect(Rect2(bx, top, bw - 4, bh + 20), col)
			_building_detail(ci, city, bx, top, bw - 4, bh, seed, t, win, lit, layer)
			x += bw
			i += 1
	# Signature landmarks per city.
	match city:
		0:
			# Smokestacks and a busted water tower.
			for s in 3:
				var sx := 140.0 + s * 380.0 - fmod(t * 6.0, 1400.0)
				if sx < -60.0:
					sx += 1400.0
				ci.draw_rect(Rect2(sx, HORIZON - 190, 18, 190), Color(0.09, 0.08, 0.07))
				for p in 5:
					var k := fmod(t * 0.4 + p * 0.2, 1.0)
					Scenery.glow(ci, Vector2(sx + 9 + k * 40.0, HORIZON - 200 - k * 90.0), 16 + k * 26.0, 12 + k * 20.0, Color(0.35, 0.33, 0.25, 0.3 * (1.0 - k)))
		3:
			# Fremont's neon canopy glow.
			Scenery.glow(ci, Vector2(640, HORIZON - 60), 380, 70, Color(1.0, 0.3, 0.8, 0.18 + 0.05 * sin(t * 3.0)))
		4:
			# Searchlights sweeping over the Strip, and a glittering tower.
			for s in 3:
				var ang := -PI * 0.5 + sin(t * 0.6 + s * 2.1) * 0.5
				Scenery.beam(ci, Vector2(300 + s * 340, HORIZON - 40), ang, 520, 46, Color(1.0, 0.95, 0.75, 0.07))
			var tx := 820.0
			ci.draw_rect(Rect2(tx, HORIZON - 360, 50, 360), Color(0.08, 0.08, 0.15))
			ci.draw_rect(Rect2(tx + 20, HORIZON - 420, 10, 60), Color(0.12, 0.12, 0.2))
			Scenery.glow(ci, Vector2(tx + 25, HORIZON - 420), 30, 30, Color(1.0, 0.85, 0.4, 0.4 + 0.2 * sin(t * 4.0)))
			for r in 18:
				ci.draw_rect(Rect2(tx + 6, HORIZON - 350 + r * 19, 38, 3), Color(1.0, 0.85, 0.5, 0.5))


static func _building_detail(ci: CanvasItem, city: int, bx: float, top: float, bw: float, bh: float, seed: int, t: float, win: Color, lit: float, layer: int) -> void:
	var cols := int(bw / 10.0)
	var rows := int(bh / 14.0)
	for r in rows:
		for c in cols:
			var s := seed * 31 + r * 7 + c
			if Scenery.rnd(s) > lit:
				continue
			var a := 0.75
			if city == 0 and Scenery.rnd(s + 3) < 0.3:
				# Flickering, failing lights in the bad part of town.
				a = 0.75 if sin(t * 13.0 + s) > 0.2 else 0.1
			ci.draw_rect(Rect2(bx + 3 + c * 10, top + 6 + r * 14, 4, 6), Color(win, a * (0.6 + 0.4 * layer)))
	if city == 0 and Scenery.rnd(seed + 9) < 0.4:
		# Boarded-up and broken: a missing chunk of roof.
		ci.draw_line(Vector2(bx + 2, top + 4), Vector2(bx + bw - 2, top + 16), Color(0.03, 0.03, 0.03), 2.0)
	if city >= 3 and Scenery.rnd(seed + 5) < 0.35:
		# Neon trim on the nicer towers.
		var nc := Color.from_hsv(Scenery.rnd(seed + 6), 0.7, 1.0, 0.7)
		ci.draw_rect(Rect2(bx, top, bw, 2), nc)
		ci.draw_rect(Rect2(bx, top, 2, bh), Color(nc, 0.4))


# ---------------------------------------------------------------- roadside + road

static func _roadside(ci: CanvasItem, f: Font, city: int, L: Dictionary, t: float) -> void:
	ci.draw_rect(Rect2(0, HORIZON, 1280, ROAD_TOP - HORIZON), (L["road"] as Color).darkened(0.35))
	var spd := 160.0 + city * 25.0
	# Poles / trees whizz past at medium speed.
	var gap := 210.0
	var off := fmod(t * spd, gap)
	var i := 0
	var x := -off
	while x < 1300.0:
		var n := int(floor((t * spd) / gap)) + i
		match city:
			0:
				# Dead trees and a sagging chain-link fence.
				ci.draw_line(Vector2(x, ROAD_TOP), Vector2(x + 4, ROAD_TOP - 70), Color(0.12, 0.1, 0.08), 4.0)
				ci.draw_line(Vector2(x + 3, ROAD_TOP - 50), Vector2(x - 18, ROAD_TOP - 72), Color(0.12, 0.1, 0.08), 2.0)
				ci.draw_line(Vector2(x + 4, ROAD_TOP - 60), Vector2(x + 24, ROAD_TOP - 84), Color(0.12, 0.1, 0.08), 2.0)
				for k in 10:
					ci.draw_line(Vector2(x + k * 20, ROAD_TOP - 4), Vector2(x + k * 20 + 20, ROAD_TOP - 26 + sin(k + n) * 3), Color(0.3, 0.3, 0.28, 0.35), 1.0)
			1, 2:
				# Telephone poles, then palms in Biloxi.
				if city == 1:
					ci.draw_rect(Rect2(x, ROAD_TOP - 110, 5, 110), Color(0.18, 0.12, 0.1))
					ci.draw_rect(Rect2(x - 14, ROAD_TOP - 104, 34, 3), Color(0.18, 0.12, 0.1))
					ci.draw_line(Vector2(x + 2, ROAD_TOP - 103), Vector2(x + gap + 2, ROAD_TOP - 96), Color(0.05, 0.05, 0.05, 0.6), 1.0)
				else:
					_palm(ci, Vector2(x, ROAD_TOP), 100.0, Color(0.06, 0.1, 0.1), t)
			_:
				# Lit palms and tall chrome street lights.
				_palm(ci, Vector2(x, ROAD_TOP), 120.0, Color(0.05, 0.08, 0.12), t)
				ci.draw_rect(Rect2(x + 100, ROAD_TOP - 150, 4, 150), Color(0.5, 0.5, 0.6))
				Scenery.glow(ci, Vector2(x + 102, ROAD_TOP - 150), 26, 18, Color(1.0, 0.9, 0.6, 0.4))
		# A billboard every few poles.
		if n % 4 == 0:
			_billboard(ci, f, city, Vector2(x + 60, ROAD_TOP - 130), n, t)
		x += gap
		i += 1


static func _palm(ci: CanvasItem, base: Vector2, hgt: float, col: Color, t: float) -> void:
	var top := base + Vector2(10, -hgt)
	ci.draw_line(base, top, col, 5.0)
	for k in 6:
		var a := -PI + k * PI / 5.0 + sin(t * 1.3 + k) * 0.05
		var tip := top + Vector2.from_angle(a) * 34.0 + Vector2(0, 10)
		ci.draw_line(top, tip, col, 3.0)


## Billboards per city: pawn shops and bail bonds at the bottom, luxury at the top.
const BILLBOARDS := [
	[["CA$H 4 GOLD", "PAWN  -  NO QUESTIONS"], ["BAIL BONDZ", "1-800-GET-OUT"], ["PAYDAY LOANS", "TODAY! (INTEREST: YES)"]],
	[["LOOSEST SLOTS*", "*NOT A PROMISE"], ["ALL-U-CAN-EAT", "PRIME RIB $6.99"], ["CIRRCUS CIRRCUS", "CLOWNS + CRAPS"]],
	[["SEAFOOD BUFFET", "SHRIMP $4.99"], ["HARD ROK", "GUITARS. SHARKS. SLOTS."], ["GULF VIEW SUITES", "ASK ABOUT HURRICANES"]],
	[["CHAPEL OF LUV", "WEDDINGS 24/7"], ["GOLDUN NUGGET", "SWIM WITH SHARKS"], ["NEON BONEYARD", "TOURS NIGHTLY"]],
	[["BELLAGIRO", "YOU CAN'T AFFORD THIS"], ["CHAMPAGNE BRUNCH", "$300 PER GLASS"], ["THE FOUNTAINS", "SHOWS EVERY 15 MIN"]],
]


static func _billboard(ci: CanvasItem, f: Font, city: int, p: Vector2, n: int, t: float) -> void:
	var w := 205.0
	var hgt := 64.0
	ci.draw_rect(Rect2(p.x + 20, p.y + hgt, 6, ROAD_TOP - p.y - hgt), Color(0.1, 0.1, 0.1))
	ci.draw_rect(Rect2(p.x + w - 26, p.y + hgt, 6, ROAD_TOP - p.y - hgt), Color(0.1, 0.1, 0.1))
	var bg := Color(0.25, 0.22, 0.15) if city == 0 else Color(0.08, 0.06, 0.12)
	ci.draw_rect(Rect2(p, Vector2(w, hgt)), bg)
	var pool: Array = BILLBOARDS[city]
	var b: Array = pool[posmod(n / 4, pool.size())]
	var tc := Color(0.6, 0.55, 0.4) if city == 0 else Color.from_hsv(fmod(0.12 * city + 0.05, 1.0), 0.6, 1.0)
	var flick := 1.0
	if city == 0 and sin(t * 9.0 + n) > 0.6:
		flick = 0.3
	ci.draw_string(f, p + Vector2(0, 28), b[0], HORIZONTAL_ALIGNMENT_CENTER, w, 20, Color(tc, flick))
	ci.draw_string(f, p + Vector2(0, 50), b[1], HORIZONTAL_ALIGNMENT_CENTER, w, 12, Color(tc, 0.7 * flick))
	if city == 0:
		# Torn corner and graffiti.
		ci.draw_colored_polygon(PackedVector2Array([p + Vector2(w - 40, 0), p + Vector2(w, 0), p + Vector2(w, 30)]), Color(0, 0, 0, 0.6))
	else:
		ci.draw_rect(Rect2(p, Vector2(w, 2)), Color(tc, 0.8))


static func _road(ci: CanvasItem, city: int, L: Dictionary, t: float) -> void:
	var rc: Color = L["road"]
	ci.draw_rect(Rect2(0, ROAD_TOP, 1280, 720 - ROAD_TOP), rc)
	# Guard rail.
	ci.draw_rect(Rect2(0, ROAD_TOP - 6, 1280, 4), Color(0.45, 0.45, 0.5) if city > 0 else Color(0.4, 0.3, 0.2))
	var spd := 520.0 + city * 60.0
	var off := fmod(t * spd, 90.0)
	for k in 16:
		var px := k * 90.0 - off
		ci.draw_rect(Rect2(px, ROAD_TOP - 8, 3, 10), Color(0.3, 0.3, 0.33))
	# Lane markings.
	var lane_y := 540.0
	var doff := fmod(t * spd, 120.0)
	for k in 13:
		ci.draw_rect(Rect2(k * 120.0 - doff, lane_y, 60, 5), Color(0.95, 0.85, 0.4, 0.75 if city > 0 else 0.4))
	# Cracks and potholes in the bad city; a smooth glossy sheen in the good ones.
	if city == 0:
		var poff := fmod(t * spd, 340.0)
		for k in 5:
			var px := k * 340.0 - poff
			ci.draw_line(Vector2(px, 575), Vector2(px + 40, 591), Color(0, 0, 0, 0.5), 2.0)
			ci.draw_line(Vector2(px + 40, 591), Vector2(px + 70, 583), Color(0, 0, 0, 0.5), 2.0)
	elif city >= 3:
		Scenery.hgrad(ci, Rect2(0, ROAD_TOP + 2, 1280, 30), Color(1, 1, 1, 0.0), Color(1, 0.8, 0.9, 0.06))
	ci.draw_rect(Rect2(0, 712, 1280, 8), rc.darkened(0.3))


# ---------------------------------------------------------------- the car

## City 0: scruffy hatchback. 1: tidy sedan. 2: muscle car.
## 3: teal grand tourer. 4: gold-trimmed supercar.
## Draw the car 1.5x size so it reads as the star of the scene.
static func _car(ci: CanvasItem, city: int, base: Vector2, t: float) -> void:
	_car_body(ci, city, base, t)
	ci.draw_set_transform(Vector2.ZERO)


## Car designs, nicest last. Profile points: x along the car (0 = rear), y up is
## negative, wheel centres sit on y = 0. Windows are tinted, so no driver shows.
const CARS := [
	{"name": "junker", "len": 200.0, "r": 15.0, "paint": Color(0.62, 0.44, 0.26), "trim": Color(0.55, 0.52, 0.48), "rim": Color(0.6, 0.6, 0.62),
		"body": [[0, -6], [1, -22], [6, -30], [40, -34], [62, -60], [140, -62], [170, -40], [194, -34], [200, -22], [198, -6]],
		"glass": [[68, -56], [104, -56], [104, -38], [54, -38]], "glass2": [[110, -56], [137, -56], [158, -40], [110, -38]]},
	{"name": "sedan", "len": 220.0, "r": 15.0, "paint": Color(0.36, 0.45, 0.52), "trim": Color(0.75, 0.76, 0.8), "rim": Color(0.78, 0.78, 0.82),
		"body": [[0, -8], [2, -26], [10, -32], [52, -36], [78, -62], [150, -62], [178, -38], [214, -34], [220, -24], [218, -8]],
		"glass": [[84, -58], [114, -58], [114, -40], [66, -40]], "glass2": [[120, -58], [146, -58], [168, -40], [120, -40]]},
	{"name": "muscle", "len": 240.0, "r": 17.0, "paint": Color(0.72, 0.1, 0.12), "trim": Color(0.92, 0.92, 0.95), "rim": Color(0.88, 0.88, 0.92),
		"body": [[0, -8], [2, -28], [12, -32], [80, -34], [104, -56], [160, -56], [186, -34], [232, -30], [240, -20], [238, -8]],
		"glass": [[108, -52], [136, -52], [136, -36], [92, -36]], "glass2": [[142, -52], [158, -52], [176, -36], [142, -36]]},
	{"name": "gt", "len": 245.0, "r": 17.0, "paint": Color(0.06, 0.45, 0.48), "trim": Color(0.95, 0.95, 1.0), "rim": Color(0.92, 0.92, 0.96),
		"body": [[0, -10], [4, -26], [20, -30], [84, -34], [112, -56], [152, -58], [196, -36], [236, -30], [245, -18], [242, -8]],
		"glass": [[100, -38], [116, -53], [150, -54], [186, -38]], "glass2": []},
	{"name": "super", "len": 260.0, "r": 18.0, "paint": Color(0.12, 0.16, 0.42), "trim": Color(1.0, 0.82, 0.35), "rim": Color(1.0, 0.84, 0.4),
		"body": [[0, -10], [4, -24], [30, -30], [96, -48], [150, -50], [206, -30], [252, -22], [260, -14], [256, -6]],
		"glass": [[104, -45], [148, -47], [190, -32], [96, -32]], "glass2": []},
]


static func _pts(arr: Array, dx := 0.0, dy := 0.0) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in arr:
		out.append(Vector2(float(p[0]) + dx, float(p[1]) + dy))
	return out


static func _car_body(ci: CanvasItem, city: int, base: Vector2, t: float) -> void:
	var C: Dictionary = CARS[clampi(city, 0, CARS.size() - 1)]
	var length: float = C["len"]
	var r: float = C["r"]
	var paint: Color = C["paint"]
	var trim: Color = C["trim"]
	var rim: Color = C["rim"]
	# Ride: the junker rattles and sags at the back, the supercar glides.
	var rattle: float = [2.2, 1.3, 0.8, 0.4, 0.2][city]
	var bob := sin(t * (19.0 if city == 0 else 11.0)) * rattle
	var tilt := 0.025 if city == 0 else 0.0
	var origin := Vector2(0, bob - r)
	var M := Transform2D(0.0, Vector2(1.5, 1.5), 0.0, base)
	ci.draw_set_transform_matrix(M)
	var body: Array = C["body"]
	var wx := [length * 0.2, length * 0.8]
	# Soft ground shadow.
	Scenery.glow(ci, Vector2(length * 0.5, 2), length * 0.58, 9, Color(0, 0, 0, 0.55))
	if city == 4:
		Scenery.glow(ci, Vector2(length * 0.5, 0), length * 0.55, 8, Color(1.0, 0.8, 0.35, 0.35 + 0.1 * sin(t * 4.0)))
	# Exhaust: sooty puffs from the junker, faint vapour from the mid cars.
	for k in 6:
		var age := fmod(t * 1.4 + k * 0.17, 1.0)
		var ep := origin + Vector2(-6 - age * 110.0, -8 - age * 22.0)
		if city == 0:
			Scenery.glow(ci, ep, 8 + age * 24, 6 + age * 18, Color(0.18, 0.17, 0.16, 0.5 * (1.0 - age)))
		elif city <= 2:
			Scenery.glow(ci, ep, 5 + age * 12, 3 + age * 8, Color(0.7, 0.7, 0.75, 0.16 * (1.0 - age)))
	ci.draw_set_transform_matrix(M * Transform2D(tilt, origin))
	var poly := _pts(body)
	# Body: base paint, a darker lower half, a bright shoulder line.
	ci.draw_colored_polygon(poly, paint)
	var lower := PackedVector2Array()
	for p in poly:
		lower.append(Vector2(p.x, maxf(p.y, -16.0)))
	ci.draw_colored_polygon(lower, paint.darkened(0.28))
	ci.draw_line(Vector2(6, -17), Vector2(length - 6, -17), paint.lightened(0.25), 1.5)
	var top := PackedVector2Array()
	for i in range(1, poly.size() - 1):
		top.append(poly[i] + Vector2(0, 1.5))
	ci.draw_polyline(top, Color(paint.lightened(0.45), 0.8), 1.5)
	# Bumpers.
	ci.draw_rect(Rect2(-3, -16, 8, 6), trim.darkened(0.15))
	ci.draw_rect(Rect2(length - 6, -16, 9, 6), trim.darkened(0.15))
	# Tinted glass with a light streak (nobody visible inside).
	for gk in ["glass", "glass2"]:
		var g: Array = C[gk]
		if g.is_empty():
			continue
		var gp := _pts(g)
		ci.draw_colored_polygon(gp, Color(0.05, 0.07, 0.12, 0.96))
		var b := gp[0]
		ci.draw_line(b + Vector2(10, 2), b + Vector2(2, 14), Color(1, 1, 1, 0.22), 3.0)
		ci.draw_polyline(gp + PackedVector2Array([gp[0]]), trim.darkened(0.2), 1.0)
	# Per-car character.
	match city:
		0:
			# Faded primer door, a few rust freckles. Scruffy, but still charming.
			ci.draw_colored_polygon(PackedVector2Array([Vector2(104, -36), Vector2(138, -36), Vector2(138, -8), Vector2(104, -8)]), Color(0.55, 0.55, 0.52))
			for k in 6:
				ci.draw_circle(Vector2(18 + k * 30, -10 + (k % 2) * 3), 2.0 + k % 2, Color(0.45, 0.22, 0.08, 0.75))
			ci.draw_line(Vector2(60, -30), Vector2(96, -30), Color(0.2, 0.15, 0.1, 0.4), 1.0)
		1:
			ci.draw_line(Vector2(66, -36), Vector2(66, -10), paint.darkened(0.4), 1.0)
			ci.draw_line(Vector2(118, -38), Vector2(118, -10), paint.darkened(0.4), 1.0)
		2:
			# Twin racing stripes and a hood scoop.
			ci.draw_rect(Rect2(0, -27, length, 3), Color(0.95, 0.95, 0.95))
			ci.draw_rect(Rect2(0, -22, length, 3), Color(0.95, 0.95, 0.95))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(196, -32), Vector2(200, -37), Vector2(218, -37), Vector2(220, -31)]), paint.darkened(0.35))
		3:
			ci.draw_line(Vector2(20, -28), Vector2(236, -26), trim, 1.5)
			ci.draw_rect(Rect2(110, -24, 18, 2), trim)
		4:
			ci.draw_line(Vector2(4, -20), Vector2(254, -18), trim, 2.0)
			ci.draw_line(Vector2(96, -48), Vector2(150, -50), trim, 1.5)
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-4, -28), Vector2(26, -28), Vector2(26, -24), Vector2(-4, -24)]), paint.darkened(0.3))  # spoiler
			ci.draw_colored_polygon(PackedVector2Array([Vector2(150, -24), Vector2(180, -24), Vector2(176, -14), Vector2(154, -14)]), Color(0.04, 0.05, 0.1))  # side intake
	# Lights: warm headlight beam at the front, red tail light at the back.
	var hy := -24.0
	var flick := 1.0 if city != 0 or sin(t * 6.0) > -0.7 else 0.35
	ci.draw_rect(Rect2(length - 7, hy, 6, 5), Color(1.0, 0.97, 0.85, flick))
	Scenery.glow(ci, Vector2(length + 40, hy + 4), 52, 10, Color(1.0, 0.95, 0.75, 0.16 * flick))
	ci.draw_rect(Rect2(1, hy, 5, 5), Color(1.0, 0.15, 0.15))
	Scenery.glow(ci, Vector2(0, hy + 2), 10, 6, Color(1.0, 0.2, 0.2, 0.35))
	# Wheels: dark arch, tyre, rim with turning spokes.
	var spin := t * (13.0 + city * 3.0)
	for i in 2:
		var wc := Vector2(wx[i], 0)
		ci.draw_circle(wc + Vector2(0, -2), r + 4.0, Color(0.03, 0.03, 0.04))
		ci.draw_circle(wc, r, Color(0.07, 0.07, 0.08))
		var rc := rim
		if city == 0 and i == 0:
			rc = Color(0.25, 0.25, 0.27)  # the mismatched spare
		ci.draw_circle(wc, r * 0.62, rc)
		var spokes := 5 if city >= 2 else 4
		for s in spokes:
			ci.draw_line(wc, wc + Vector2.from_angle(spin + s * TAU / spokes) * r * 0.6, rc.darkened(0.45), 2.0)
		ci.draw_circle(wc, r * 0.18, rc.lightened(0.3))
	ci.draw_set_transform_matrix(M)


static func _exit_sign(ci: CanvasItem, f: Font, city: int, L: Dictionary, t: float) -> void:
	# Green highway sign sliding in from the right once the trip has started.
	var k := clampf((t - 0.6) / 1.2, 0.0, 1.0)
	var x := 1300.0 - ease(k, 0.4) * 330.0
	var r := Rect2(x, 40, 290, 96)
	ci.draw_rect(Rect2(r.position.x + 130, r.end.y, 8, 70), Color(0.3, 0.3, 0.32))
	ci.draw_rect(r.grow(4), Color(0.9, 0.9, 0.9))
	ci.draw_rect(r, Color(0.05, 0.38, 0.2) if city > 0 else Color(0.12, 0.3, 0.16))
	ci.draw_string(f, r.position + Vector2(0, 30), "EXIT  " + str(city + 1), HORIZONTAL_ALIGNMENT_CENTER, r.size.x, 14, Color(1, 1, 1, 0.85))
	ci.draw_string(f, r.position + Vector2(0, 62), String(L["sign"]), HORIZONTAL_ALIGNMENT_CENTER, r.size.x, 26, Color.WHITE)
	ci.draw_string(f, r.position + Vector2(0, 86), String(L["miles"]) + " MI", HORIZONTAL_ALIGNMENT_CENTER, r.size.x, 15, Color(1, 1, 1, 0.85))
	if city == 0:
		# Bullet holes and graffiti on the sign.
		for b in 4:
			ci.draw_circle(r.position + Vector2(30 + b * 70, 20 + (b % 2) * 50), 3, Color(0, 0, 0, 0.8))
