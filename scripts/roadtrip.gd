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


const BgArt := preload("res://scripts/bg_art.gd")

static func draw(ci: CanvasItem, f: Font, city: int, t: float) -> void:
	city = clampi(city, 0, LOOKS.size() - 1)
	var L: Dictionary = LOOKS[city]
	var sky: Array = L["sky"]
	Scenery.vgrad(ci, Rect2(0, 0, 1280, HORIZON + 10), [[0.0, sky[0]], [0.6, sky[1]], [1.0, sky[2]]])
	_stars_or_moon(ci, city, L, t)
	_fireworks(ci, city, t)
	_skyline(ci, f, city, L, t)
	ci.draw_rect(Rect2(0, HORIZON - 30, 1280, 60), Color(L["haze"], (L["haze"] as Color).a * 0.6))
	_roadside(ci, f, city, L, t)
	_road(ci, city, L, t)
	_wet_road(ci, city, t)
	_overhead_lights(ci, city, t)
	_traffic(ci, city, t)
	_car(ci, city, Vector2(HERO_X, HERO_Y), t)
	_rain(ci, city, t)
	_foreground(ci, city, t)
	_exit_sign(ci, f, city, L, t)
	_finish(ci, t)


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
	# Painted CraftPix skyline (assets/bg), tinted per city, scrolling past at layered speeds.
	var art_h := 460.0
	var rect := Rect2(0, HORIZON + 30.0 - art_h, 1280.0, art_h)
	var info := BgArt.city_info(city)
	Scenery.glow(ci, Vector2(640, HORIZON - 30), 520.0, 90.0, info["glow"])
	BgArt.skyline(ci, rect, city, t * 60.0, 0.0, 0.85, 0.0, [0.0, 0.2, 0.4, 0.7, 1.0, 1.5], 2)
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


## Lane layout (screen y). A divided highway seen from the side: the far side is
## the oncoming carriageway, then a double-yellow median, then our two lanes.
const FAR_EDGE := 408.0
const MEDIAN_Y := 452.0      # top of the median strip (10 px tall)
const LANE_DIV := 502.0      # white dashes between the next lane and Rico's lane
const NEAR_EDGE := 554.0     # solid white edge line, then the shoulder
const ONCOMING_Y := 446.0    # wheel line of oncoming cars
const NEXT_LANE_Y := 494.0   # wheel line of slower same-way cars
const HERO_Y := 546.0        # wheel line of Rico's car
const HERO_X := 500.0


static func _road(ci: CanvasItem, city: int, L: Dictionary, t: float) -> void:
	var rc: Color = L["road"]
	var spd := 900.0 + city * 60.0   # matches the overhead lights, so it all moves together
	# Asphalt: each band slightly darker toward the camera, like real depth.
	ci.draw_rect(Rect2(0, ROAD_TOP, 1280, FAR_EDGE - ROAD_TOP), rc.lightened(0.08))            # far shoulder
	ci.draw_rect(Rect2(0, FAR_EDGE, 1280, MEDIAN_Y - FAR_EDGE), rc.lightened(0.03))              # oncoming lane
	ci.draw_rect(Rect2(0, MEDIAN_Y, 1280, 10), rc.darkened(0.25))                                 # median
	ci.draw_rect(Rect2(0, MEDIAN_Y + 10, 1280, NEAR_EDGE - MEDIAN_Y - 10), rc)                    # our lanes
	ci.draw_rect(Rect2(0, NEAR_EDGE + 3, 1280, 40), rc.lightened(0.06))                           # near shoulder
	ci.draw_rect(Rect2(0, NEAR_EDGE + 43, 1280, 720 - NEAR_EDGE - 43), rc.darkened(0.45))          # verge
	# Worn tyre tracks down the middle of each lane.
	for ly in [430.0, 482.0, 530.0]:
		ci.draw_rect(Rect2(0, ly - 5, 1280, 3), Color(0, 0, 0, 0.12))
		ci.draw_rect(Rect2(0, ly + 6, 1280, 3), Color(0, 0, 0, 0.12))
	# Speed streaks in the asphalt grain.
	var goff := fmod(t * spd, 1280.0)
	for k in 40:
		var gy := ROAD_TOP + 10.0 + Scenery.rnd(k * 7) * (NEAR_EDGE - ROAD_TOP)
		var gx := fposmod(Scenery.rnd(k * 3) * 1280.0 - goff, 1280.0)
		ci.draw_rect(Rect2(gx, gy, 30 + Scenery.rnd(k) * 60.0, 1), Color(1, 1, 1, 0.025))
	# Far guard rail, with posts rushing by.
	ci.draw_rect(Rect2(0, ROAD_TOP - 6, 1280, 4), Color(0.45, 0.45, 0.5) if city > 0 else Color(0.4, 0.3, 0.2))
	var off := fmod(t * spd * 0.55, 90.0)
	for k in 16:
		ci.draw_rect(Rect2(k * 90.0 - off, ROAD_TOP - 8, 3, 10), Color(0.3, 0.3, 0.33))
	# ---- Markings. Faded and patchy downtown, crisp and bright on the Strip.
	var paint_a: float = [0.35, 0.6, 0.75, 0.85, 0.95][city]
	var white := Color(0.95, 0.95, 0.92, paint_a)
	var yellow := Color(1.0, 0.8, 0.25, paint_a)
	# Solid white edge lines.
	ci.draw_rect(Rect2(0, FAR_EDGE - 1, 1280, 2), Color(white, white.a * 0.7))
	ci.draw_rect(Rect2(0, NEAR_EDGE, 1280, 3), white)
	# Double yellow on the median: nobody crosses into oncoming traffic.
	ci.draw_rect(Rect2(0, MEDIAN_Y + 1, 1280, 2), yellow)
	ci.draw_rect(Rect2(0, MEDIAN_Y + 7, 1280, 2), yellow)
	# Dashed white lane divider: 60 px dash, 60 px gap, moving with the road.
	var doff := fmod(t * spd, 120.0)
	for k in 13:
		ci.draw_rect(Rect2(k * 120.0 - doff, LANE_DIV, 60, 3), white)
	# Cat's-eye reflectors on the median and the lane divider, glinting at night.
	var roff := fmod(t * spd, 240.0)
	for k in 7:
		var rx := k * 240.0 - roff
		var eye := Color(1.0, 0.85, 0.35, 0.9) if city > 0 else Color(0.8, 0.6, 0.3, 0.5)
		ci.draw_rect(Rect2(rx, MEDIAN_Y + 4, 4, 2), eye)
		Scenery.glow(ci, Vector2(rx + 2, MEDIAN_Y + 5), 8, 3, Color(eye, 0.3))
		ci.draw_rect(Rect2(rx + 120, LANE_DIV, 4, 3), Color(1, 1, 1, 0.9 if city > 0 else 0.45))
	# Rumble strip on the shoulder.
	var soff := fmod(t * spd, 14.0)
	for k in 93:
		ci.draw_rect(Rect2(k * 14.0 - soff, NEAR_EDGE + 8, 7, 4), Color(0, 0, 0, 0.18))
	# Road condition by city.
	match city:
		0:
			# Cracks, tar patches and potholes in Atlantic Shitty.
			var poff := fmod(t * spd, 420.0)
			for k in 5:
				var px := k * 420.0 - poff
				ci.draw_rect(Rect2(px + 40, 470, 90, 16), rc.darkened(0.35))              # tar patch
				ci.draw_line(Vector2(px, 518), Vector2(px + 36, 530), Color(0, 0, 0, 0.5), 1.5)
				ci.draw_line(Vector2(px + 36, 530), Vector2(px + 64, 524), Color(0, 0, 0, 0.5), 1.5)
				Scenery.glow(ci, Vector2(px + 250, 538), 18, 4, Color(0, 0, 0, 0.6))          # pothole
				ci.draw_rect(Rect2(px + 200, LANE_DIV - 1, 70, 5), rc)                       # missing paint
		1:
			var poff := fmod(t * spd, 700.0)
			for k in 3:
				ci.draw_rect(Rect2(k * 700.0 - poff + 100, 476, 120, 12), rc.darkened(0.2))
		_:
			# Fresh, glossy blacktop with a soft sheen.
			Scenery.hgrad(ci, Rect2(0, MEDIAN_Y + 12, 1280, 24), Color(1, 1, 1, 0.0), Color(1, 0.9, 0.95, 0.04 + 0.01 * city))
	ci.draw_rect(Rect2(0, 712, 1280, 8), rc.darkened(0.3))


# ---------------------------------------------------------------- the car

## City 0: scruffy 80s hatchback. 1: tidy sedan. 2: muscle car.
## 3: teal grand tourer. 4: gold-trimmed supercar.
## Drawn 1.5x so the car is the star of the scene.
static func _car(ci: CanvasItem, city: int, base: Vector2, t: float) -> void:
	_car_body(ci, city, base, t)
	ci.draw_set_transform(Vector2.ZERO)


## Car profiles, nicest last. x runs rear (0) to nose; y is up-negative with the
## wheel centres sitting r below y = 0 (the body's floor line). "top" is the
## silhouette from rear-bottom over the roof to front-bottom, smoothed into curves.
## "glass" is the side greenhouse, "pillars" window pillars, "doors" door seams.
const CARS := [
	{"len": 200.0, "r": 14.0, "wheels": [38.0, 162.0], "paint": Color(0.66, 0.47, 0.28), "trim": Color(0.62, 0.6, 0.56), "rim": Color(0.66, 0.66, 0.68),
		"top": [[2, -7], [0, -22], [4, -30], [14, -34], [34, -58], [120, -60], [146, -38], [186, -33], [198, -26], [200, -13], [198, -7]],
		"glass": [[38, -54], [117, -56], [138, -39], [28, -38]], "pillars": [80.0], "doors": [80.0, 140.0], "mirror": 140.0},
	{"len": 220.0, "r": 15.0, "wheels": [42.0, 178.0], "paint": Color(0.38, 0.47, 0.56), "trim": Color(0.8, 0.81, 0.85), "rim": Color(0.8, 0.8, 0.84),
		"top": [[2, -8], [0, -24], [6, -32], [46, -36], [70, -58], [140, -60], [166, -38], [208, -33], [219, -25], [220, -13], [217, -7]],
		"glass": [[74, -54], [138, -56], [160, -39], [58, -39]], "pillars": [106.0], "doors": [62.0, 106.0, 160.0], "mirror": 160.0},
	{"len": 240.0, "r": 17.0, "wheels": [46.0, 194.0], "paint": Color(0.75, 0.1, 0.12), "trim": Color(0.94, 0.94, 0.97), "rim": Color(0.9, 0.9, 0.94),
		"top": [[2, -8], [0, -26], [8, -32], [62, -34], [96, -54], [148, -55], [172, -35], [232, -31], [240, -22], [240, -12], [237, -7]],
		"glass": [[100, -50], [146, -51], [164, -37], [84, -37]], "pillars": [128.0], "doors": [128.0, 168.0], "mirror": 168.0},
	{"len": 245.0, "r": 17.0, "wheels": [47.0, 198.0], "paint": Color(0.07, 0.48, 0.52), "trim": Color(0.96, 0.96, 1.0), "rim": Color(0.94, 0.94, 0.98),
		"top": [[2, -10], [0, -24], [10, -31], [60, -34], [110, -54], [150, -55], [190, -36], [234, -30], [244, -20], [244, -12], [241, -7]],
		"glass": [[112, -50], [148, -51], [180, -37], [92, -37]], "pillars": [], "doors": [118.0, 184.0], "mirror": 184.0},
	{"len": 260.0, "r": 18.0, "wheels": [52.0, 212.0], "paint": Color(0.14, 0.18, 0.46), "trim": Color(1.0, 0.82, 0.35), "rim": Color(1.0, 0.84, 0.42),
		"top": [[2, -10], [0, -22], [14, -30], [80, -40], [112, -48], [150, -49], [196, -32], [246, -24], [260, -16], [258, -8], [254, -6]],
		"glass": [[116, -45], [148, -46], [184, -33], [100, -36]], "pillars": [], "doors": [110.0, 186.0], "mirror": 188.0},
]


static func _pts(arr: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in arr:
		out.append(Vector2(float(p[0]), float(p[1])))
	return out


## Catmull-Rom through the points, so the silhouette reads as curved sheet metal.
static func _smooth(pts: PackedVector2Array, steps := 6) -> PackedVector2Array:
	var out := PackedVector2Array()
	var n := pts.size()
	for i in n - 1:
		var p0 := pts[maxi(i - 1, 0)]
		var p1 := pts[i]
		var p2 := pts[i + 1]
		var p3 := pts[mini(i + 2, n - 1)]
		for s in steps:
			var u := float(s) / steps
			var u2 := u * u
			var u3 := u2 * u
			out.append(0.5 * ((2.0 * p1) + (-p0 + p2) * u + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * u2 + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * u3))
	out.append(pts[n - 1])
	return out


## How brightly the overhead highway lights are hitting screen x right now (0..1).
static func street_light(t: float, x: float, city: int) -> float:
	var gap := 560.0
	var off := fmod(t * (900.0 + city * 60.0), gap)
	var k := 0.0
	for i in 5:
		var lx := 1400.0 - i * gap + off - gap
		k = maxf(k, 1.0 - absf(lx - x) / 230.0)
	return clampf(k, 0.0, 1.0)


## `city` picks the car model. Traffic cars pass a smaller `sc`, a `dim` that
## pushes them back into the night, `flip` for oncoming cars, and their own paint.
static func _car_body(ci: CanvasItem, city: int, base: Vector2, t: float, sc := 1.5, dim := 0.0, flip := false, paint_over := Color(0, 0, 0, 0)) -> void:
	var C: Dictionary = CARS[clampi(city, 0, CARS.size() - 1)]
	var length: float = C["len"]
	var r: float = C["r"]
	var paint: Color = C["paint"] if paint_over.a == 0.0 else paint_over
	var trim: Color = C["trim"]
	var rim: Color = C["rim"]
	if dim > 0.0:
		paint = paint.darkened(dim)
		trim = trim.darkened(dim)
		rim = rim.darkened(dim)
	var wheels: Array = C["wheels"]
	var lit := street_light(t, base.x + length * 0.75, city) * (1.0 - dim)
	# Ride: the junker jitters on old springs, the supercar glides.
	var rattle: float = [1.6, 1.0, 0.7, 0.35, 0.15][city]
	var bob := sin(t * (17.0 if city == 0 else 10.0) + base.x * 0.01) * rattle + (sin(t * 41.0) * 0.6 if city == 0 else 0.0)
	var M := Transform2D(0.0, Vector2(-sc if flip else sc, sc), 0.0, base)
	ci.draw_set_transform_matrix(M)
	# Ground shadow, the supercar's underglow, and the tail-light streaks.
	Scenery.glow(ci, Vector2(length * 0.5, 1), length * 0.56, 7, Color(0, 0, 0, 0.6))
	if city == 4:
		Scenery.glow(ci, Vector2(length * 0.5, 0), length * 0.5, 7, Color(1.0, 0.78, 0.3, 0.35 + 0.1 * sin(t * 4.0)))
	var body_y := -r + 5.0 + bob  # body coords: y = 0 is the floor line, just below the axles
	for k in 5:
		ci.draw_line(Vector2(-4 - k * 26, body_y - 22), Vector2(-28 - k * 26, body_y - 22), Color(1.0, 0.15, 0.15, 0.22 * (1.0 - k / 5.0)), 2.0)
	# Exhaust: sooty puffs from the junker, a faint vapour trail from the mid cars.
	for k in 6:
		var age := fmod(t * 1.4 + k * 0.17, 1.0)
		var ep := Vector2(-4 - age * 110.0, body_y - 6 - age * 20.0)
		if city == 0:
			Scenery.glow(ci, ep, 7 + age * 22, 5 + age * 16, Color(0.2, 0.19, 0.18, 0.45 * (1.0 - age)))
		elif city <= 2:
			Scenery.glow(ci, ep, 4 + age * 10, 3 + age * 7, Color(0.75, 0.75, 0.8, 0.13 * (1.0 - age)))
	# Headlight beam reaching down the road ahead.
	var flick := 1.0 if city != 0 or sin(t * 6.0) > -0.7 else 0.35
	var beam_a := (0.12 if city > 0 else 0.08) * flick * (1.0 - dim * 0.6)
	for b in 4:
		var w := 10.0 + b * 9.0
		var hy := body_y - 22.0
		ci.draw_colored_polygon(PackedVector2Array([Vector2(length - 2, hy), Vector2(length + 150 + b * 20, hy - w * 0.4), Vector2(length + 150 + b * 20, hy + w)]), Color(1.0, 0.95, 0.75, beam_a * 0.5))
	ci.draw_set_transform_matrix(M * Transform2D(0.02 if city == 0 else 0.0, Vector2(0, body_y)))
	# ---- Body.
	var top: PackedVector2Array = _smooth(_pts(C["top"]))
	ci.draw_colored_polygon(top, paint)
	# Sheet-metal shading: lighter shoulders and roof, darker sills.
	var upper := PackedVector2Array()
	for p in top:
		upper.append(Vector2(p.x, minf(p.y, -26.0)))
	ci.draw_colored_polygon(upper, paint.lightened(0.12))
	var lower := PackedVector2Array()
	for p in top:
		lower.append(Vector2(p.x, maxf(p.y, -14.0)))
	ci.draw_colored_polygon(lower, paint.darkened(0.3))
	# Shoulder crease and a roof-line highlight.
	ci.draw_line(Vector2(8, -26), Vector2(length - 10, -25), paint.lightened(0.35), 1.2)
	var rim_line := PackedVector2Array()
	for i in range(2, top.size() - 3):
		rim_line.append(top[i] + Vector2(0, 1.2))
	ci.draw_polyline(rim_line, Color(paint.lightened(0.5), 0.7), 1.2)
	# A glint slides along the body when a street light passes overhead.
	if lit > 0.02:
		var rx := length * (1.0 - fmod(t * 0.9, 1.0))
		ci.draw_colored_polygon(PackedVector2Array([Vector2(rx - 12, -24), Vector2(rx + 4, -24), Vector2(rx - 8, -12), Vector2(rx - 24, -12)]), Color(1, 1, 1, 0.22 * lit))
	# Greenhouse: tinted glass, nobody visible inside.
	var glass := _pts(C["glass"])
	ci.draw_colored_polygon(glass, Color(0.04, 0.06, 0.11, 0.97))
	ci.draw_colored_polygon(PackedVector2Array([glass[0] + Vector2(6, 2), glass[0] + Vector2(16, 2), glass[3] + Vector2(10, -2), glass[3] + Vector2(2, -2)]), Color(0.6, 0.75, 1.0, 0.16 + 0.2 * lit))
	ci.draw_polyline(glass + PackedVector2Array([glass[0]]), trim.darkened(0.25), 1.0)
	for px in C["pillars"]:
		var gtop := minf(glass[0].y, glass[1].y) + 1.0
		ci.draw_rect(Rect2(float(px) - 2.5, gtop, 5, glass[3].y - gtop), paint.darkened(0.1))
	# Door seams, a handle and the side mirror.
	var doors: Array = C["doors"]
	for dx in doors:
		ci.draw_line(Vector2(float(dx), -37), Vector2(float(dx) - 1, -10), paint.darkened(0.45), 1.0)
	ci.draw_rect(Rect2(float(doors[0]) + 6, -31, 8, 2), trim)
	var mx: float = C["mirror"]
	ci.draw_colored_polygon(PackedVector2Array([Vector2(mx - 2, -40), Vector2(mx + 8, -42), Vector2(mx + 8, -36), Vector2(mx - 2, -36)]), paint.darkened(0.2))
	# Bumpers sit inside the silhouette, with a chrome lip.
	ci.draw_line(Vector2(2, -12), Vector2(14, -12), trim, 2.0)
	ci.draw_line(Vector2(length - 14, -12), Vector2(length - 1, -12), trim, 2.0)
	# Per-car character.
	match city:
		0:
			# Grey primer door and rust freckles. Rough, but it runs. Mostly.
			ci.draw_colored_polygon(PackedVector2Array([Vector2(81, -37), Vector2(139, -38), Vector2(139, -9), Vector2(81, -9)]), Color(0.56, 0.56, 0.53))
			for k in 7:
				ci.draw_circle(Vector2(12 + k * 27, -10 + (k % 2) * 2), 1.6 + (k % 3) * 0.6, Color(0.45, 0.22, 0.08, 0.8))
		2:
			# Twin racing stripes down the long body.
			ci.draw_line(Vector2(12, -29), Vector2(length - 16, -27), Color(0.97, 0.97, 0.97), 2.0)
			ci.draw_line(Vector2(12, -25), Vector2(length - 16, -23), Color(0.97, 0.97, 0.97), 2.0)
		3:
			ci.draw_line(Vector2(14, -19), Vector2(length - 8, -19), trim, 1.5)
		4:
			# Gold pinstripe and a ducktail spoiler.
			ci.draw_line(Vector2(6, -19), Vector2(length - 8, -19), trim, 1.6)
			ci.draw_colored_polygon(PackedVector2Array([Vector2(0, -30), Vector2(22, -31), Vector2(18, -27), Vector2(2, -26)]), paint.darkened(0.3))
	# Lights.
	ci.draw_colored_polygon(PackedVector2Array([Vector2(length - 9, -25), Vector2(length - 1, -24), Vector2(length - 1, -20), Vector2(length - 9, -21)]), Color(1.0, 0.97, 0.86, flick))
	Scenery.glow(ci, Vector2(length - 2, -22), 10, 6, Color(1.0, 0.95, 0.75, 0.5 * flick))
	ci.draw_rect(Rect2(1, -25, 5, 5), Color(1.0, 0.16, 0.16))
	Scenery.glow(ci, Vector2(2, -22), 9, 6, Color(1.0, 0.2, 0.2, 0.45))
	# Wheel arches cut into the body, then tyres and spinning rims.
	var spin := t * (13.0 + city * 3.0)
	for i in 2:
		var wc := Vector2(float(wheels[i]), -5.0)
		var arch := PackedVector2Array()
		for s in 13:
			arch.append(wc + Vector2.from_angle(PI + s * PI / 12.0) * (r + 3.0))
		ci.draw_colored_polygon(arch, Color(0.02, 0.02, 0.03))
		ci.draw_circle(wc, r, Color(0.06, 0.06, 0.07))
		ci.draw_arc(wc, r - 1.5, 0, TAU, 24, Color(0.16, 0.16, 0.17), 1.5)
		var rc := rim
		if city == 0 and i == 0:
			rc = Color(0.22, 0.22, 0.24)  # the mismatched spare
		ci.draw_circle(wc, r * 0.6, rc.darkened(0.25))
		var spokes := 5 if city >= 2 else 4
		for s in spokes:
			var a := spin + s * TAU / spokes
			ci.draw_line(wc + Vector2.from_angle(a) * r * 0.15, wc + Vector2.from_angle(a) * r * 0.56, rc, 2.4)
		# Motion-blur ring and a centre cap.
		ci.draw_arc(wc, r * 0.4, 0, TAU, 20, Color(rc, 0.35), r * 0.3)
		ci.draw_circle(wc, r * 0.14, rc.lightened(0.3))
		if city >= 3:
			ci.draw_arc(wc, r * 0.6, -2.4, -1.4, 6, Color(1, 1, 1, 0.5), 1.2)
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


# ---------------------------------------------------------------- cinematic layer

## Tall overhead highway lights rushing past in the foreground. Each throws a
## pool of light on the road; the car brightens as it drives through (street_light).
static func _overhead_lights(ci: CanvasItem, city: int, t: float) -> void:
	var gap := 560.0
	var off := fmod(t * (900.0 + city * 60.0), gap)
	var warm := Color(1.0, 0.78, 0.45) if city < 3 else Color(1.0, 0.92, 0.75)
	for i in 5:
		var lx := 1400.0 - i * gap + off - gap
		# Pool of light on the asphalt.
		Scenery.glow(ci, Vector2(lx, 505), 230, 60, Color(warm, 0.16 if city > 0 else 0.1))
		# Cone from the lamp head.
		ci.draw_colored_polygon(PackedVector2Array([Vector2(lx - 8, 60), Vector2(lx + 8, 60), Vector2(lx + 160, NEAR_EDGE), Vector2(lx - 160, NEAR_EDGE)]), Color(warm, 0.045))


## Foreground pole and rail blurs, closest to the camera and fastest.
static func _foreground(ci: CanvasItem, city: int, t: float) -> void:
	var gap := 560.0
	var off := fmod(t * (900.0 + city * 60.0), gap)
	for i in 5:
		var lx := 1400.0 - i * gap + off - gap
		# Motion-blurred pole: a smear rather than a crisp line.
		for k in 4:
			ci.draw_rect(Rect2(lx - 10 + k * 7, 40, 7, 690), Color(0.02, 0.02, 0.03, 0.22 - k * 0.04))
		ci.draw_rect(Rect2(lx - 40, 52, 80, 9), Color(0.03, 0.03, 0.04, 0.8))
		Scenery.glow(ci, Vector2(lx, 62), 40, 12, Color(1.0, 0.9, 0.7, 0.5))
	# Low concrete barrier streaking by along the bottom edge.
	ci.draw_rect(Rect2(0, 690, 1280, 30), Color(0.05, 0.05, 0.06, 0.9))
	var soff := fmod(t * 1400.0, 160.0)
	for k in 10:
		ci.draw_rect(Rect2(k * 160.0 - soff, 692, 90, 3), Color(1.0, 1.0, 1.0, 0.06))


## Wet asphalt in the grimy cities: lights smear into long reflections.
static func _wet_road(ci: CanvasItem, city: int, t: float) -> void:
	if city > 1:
		return
	var gap := 560.0
	var off := fmod(t * (900.0 + city * 60.0), gap)
	for i in 5:
		var lx := 1400.0 - i * gap + off - gap
		for k in 6:
			ci.draw_rect(Rect2(lx - 3 + sin(t * 9.0 + k) * 2.0, NEAR_EDGE + 6 + k * 18, 6, 14), Color(1.0, 0.8, 0.5, 0.08 - k * 0.012))
	# The car's own lights in the puddles.
	ci.draw_rect(Rect2(HERO_X + 200 * 1.5, NEAR_EDGE + 4, 8, 50), Color(1.0, 0.95, 0.75, 0.07))
	ci.draw_rect(Rect2(HERO_X + 2, NEAR_EDGE + 4, 6, 40), Color(1.0, 0.2, 0.2, 0.08))


## Rain in Atlantic Shitty, a light drizzle in Reno.
static func _rain(ci: CanvasItem, city: int, t: float) -> void:
	if city > 1:
		return
	var n := 160 if city == 0 else 60
	var a := 0.22 if city == 0 else 0.12
	for i in n:
		var x := fmod(Scenery.rnd(i * 5) * 1500.0 - t * 380.0, 1500.0)
		if x < 0.0:
			x += 1500.0
		var y := fmod(Scenery.rnd(i * 9 + 3) * 760.0 + t * 1100.0, 760.0) - 20.0
		ci.draw_line(Vector2(x, y), Vector2(x - 7, y + 22), Color(0.75, 0.8, 0.9, a), 1.0)


## Fireworks over the Strip.
static func _fireworks(ci: CanvasItem, city: int, t: float) -> void:
	if city < 4:
		return
	for b in 3:
		var period := 2.6 + b * 0.7
		var k := fmod(t + b * 1.1, period) / period
		if k > 0.6:
			continue
		var bx := 200.0 + Scenery.rnd(int((t + b * 1.1) / period) * 7 + b) * 880.0
		var by := 70.0 + b * 40.0
		var rad := ease(k / 0.6, 0.4) * 70.0
		var col := Color.from_hsv(Scenery.rnd(b * 13 + int(t / period)), 0.6, 1.0, 1.0 - k / 0.6)
		for s in 16:
			var d := Vector2.from_angle(s * TAU / 16.0)
			ci.draw_line(Vector2(bx, by) + d * rad * 0.6, Vector2(bx, by) + d * rad + Vector2(0, rad * 0.15), col, 2.0)
		Scenery.glow(ci, Vector2(bx, by), rad, rad, Color(col, col.a * 0.15))


## Cinematic finish: letterbox bar on top, vignette, film grain.
static func _finish(ci: CanvasItem, t: float) -> void:
	Scenery.hgrad(ci, Rect2(0, 0, 220, 720), Color(0, 0, 0, 0.55), Color(0, 0, 0, 0.0))
	Scenery.hgrad(ci, Rect2(1060, 0, 220, 720), Color(0, 0, 0, 0.0), Color(0, 0, 0, 0.55))
	Scenery.vgrad(ci, Rect2(0, 0, 1280, 160), [[0.0, Color(0, 0, 0, 0.6)], [1.0, Color(0, 0, 0, 0.0)]])
	ci.draw_rect(Rect2(0, 0, 1280, 26), Color(0, 0, 0, 1.0))
	var seed := int(t * 24.0)
	for i in 220:
		var gx := Scenery.rnd(seed * 977 + i * 3) * 1280.0
		var gy := Scenery.rnd(seed * 571 + i * 7) * 720.0
		ci.draw_rect(Rect2(gx, gy, 1, 1), Color(1, 1, 1, 0.07))


# ---------------------------------------------------------------- traffic

## Other drivers, kept in the background so Rico's car stays the hero:
## oncoming cars in the far lane (small, dark, fast) and slower same-way cars
## in the next lane that Rico overtakes (a little bigger, still dimmer).
## Models and paint follow the neighbourhood: beaters downtown, exotics on the Strip.
static func _traffic(ci: CanvasItem, city: int, t: float) -> void:
	# Oncoming lane: headlights first, cars flash past right to left.
	var span := 2300.0
	for i in 3:
		var x := fposmod(1500.0 - t * 820.0 + i * 790.0, span) - 400.0
		var lap := int(floor((t * 820.0 - i * 790.0) / span))
		var model := _traffic_model(city, i * 17 + lap)
		ci.draw_set_transform(Vector2.ZERO)
		_car_body(ci, model, Vector2(x, ONCOMING_Y), t, 0.72, 0.58, true, _traffic_paint(city, i * 7 + lap))
	# Same-direction lane: Rico gains on these slowly.
	span = 2000.0
	for i in 2:
		var x := fposmod(1300.0 - t * 260.0 + i * 1000.0, span) - 400.0
		var lap := int(floor((t * 260.0 - i * 1000.0) / span))
		var model := _traffic_model(city, i * 31 + lap + 5)
		ci.draw_set_transform(Vector2.ZERO)
		_car_body(ci, model, Vector2(x, NEXT_LANE_Y), t, 0.9, 0.48, false, _traffic_paint(city, i * 13 + lap + 3))
	ci.draw_set_transform(Vector2.ZERO)
	# A thin layer of road haze between the traffic and the hero car.
	ci.draw_rect(Rect2(0, ROAD_TOP, 1280, NEXT_LANE_Y - ROAD_TOP), Color(0.02, 0.02, 0.04, 0.16))
	# Soft spotlight on the hero car so it always pops.
	Scenery.glow(ci, Vector2(HERO_X + float(CARS[city]["len"]) * 0.75, HERO_Y - 50), 330, 90, Color(1.0, 0.9, 0.75, 0.07))


static func _traffic_model(city: int, n: int) -> int:
	var pick := int(Scenery.rnd(n * 3 + city * 11) * 3.0) - 1   # city-1 .. city+1
	return clampi(city + pick, 0, 4)


static func _traffic_paint(city: int, n: int) -> Color:
	var h := Scenery.rnd(n * 5 + 2)
	var s := 0.18 + 0.12 * city
	var v := 0.42 + 0.09 * city
	return Color.from_hsv(h, s, v)
