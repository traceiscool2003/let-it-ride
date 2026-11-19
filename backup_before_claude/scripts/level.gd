extends Node2D
## A floor of The Pit.
## Normal floors: a 4x4 room grid with a guaranteed path (Spelunky-style).
## Boss floors: one big arena. Both get dynamic lights + shadow occluders,
## casino set dressing, breakable glass / cracked walls / crumbling platforms,
## props, casino games, and foliage data.

signal broke(cell: Vector2i, kind: int)
signal crumble_started(cell: Vector2i)


class TileLayer extends Node2D:
	var lvl
	func _draw() -> void:
		lvl.draw_tiles(self)


class Emissive extends Node2D:
	var lvl
	func _process(_d: float) -> void:
		queue_redraw()
	func _draw() -> void:
		lvl.draw_emissive(self)


const T := 16
const RW := 14
const RH := 10
const RX := 4
const RY := 4
const EMPTY := 0
const SOLID := 1
const SPIKE := 2
const GLASS := 3
const CRACK := 4
const CRUMBLE := 5

const NEON_WORDS := ["777", "BAR", "LUCK", "JACKPOT", "ALL IN", "$$$", "HOUSE", "CASH", "BET", "21", "WIN", "ODDS"]
const NEON_COLS := [Color(1, 0.3, 0.7), Color(0.3, 0.9, 1), Color(1, 0.85, 0.3), Color(0.4, 1, 0.5), Color(0.75, 0.45, 1)]

var w := RW * RX
var h := RH * RY
var grid := PackedByteArray()
var seen := PackedByteArray()
var reserved := {}
var no_spike := {}
var links := {}
var holes := {}
var doors: Array = []
var start_pos := Vector2.ZERO
var exit_pos := Vector2.ZERO
var exit_locked := false
var is_boss := false
var boss_spawn := Vector2.ZERO
var chip_spots: Array = []
var enemy_spots: Array = []
var prop_spots: Array = []   # [Vector2 bottom-center, kind]  0 crate 1 urn 2 glass case
var games: Array = []        # [Vector2 bottom-center, "slots"/"blackjack"/"roulette"]
var lamps: Array = []
var grass: Array = []        # [Vector2 base, length, shade]
var vine_spots: Array = []   # [Vector2 anchor, segments]
var shrooms: Array = []      # [Vector2 base, size, Color]
var bg_pillars: Array = []   # [x, top, bottom]
var slots: Array = []        # Vector2 bottom-center (decor cabinets, also playable)
var banners: Array = []      # Vector2 top-center
var neons: Array = []        # [Vector2 center, text, Color, size]
var cell_nodes := {}
var crumble_t := {}
var rules: Array = []
var rng: RandomNumberGenerator
var font: Font
var tile_layer: Node2D
var emissive: Node2D
var t := 0.0

static var _light_tex: GradientTexture2D


func idx(cx: int, cy: int) -> int:
	return cy * w + cx


func get_cell(cx: int, cy: int) -> int:
	if cx < 0 or cy < 0 or cx >= w or cy >= h:
		return SOLID
	return grid[idx(cx, cy)]


static func is_solid_v(v: int) -> bool:
	return v == SOLID or v >= GLASS


func solid(cx: int, cy: int) -> bool:
	return is_solid_v(get_cell(cx, cy))


func solid_at(p: Vector2) -> bool:
	return solid(floori(p.x / T), floori(p.y / T))


func spike_at(p: Vector2) -> bool:
	return get_cell(floori(p.x / T), floori(p.y / T)) == SPIKE and fposmod(p.y, T) > 8.0


func exit_rect() -> Rect2:
	return Rect2(exit_pos.x - 8.0, exit_pos.y - 32.0, 16.0, 32.0)


func reveal(p: Vector2, r: int = 6) -> void:
	var cx := floori(p.x / T)
	var cy := floori(p.y / T)
	for y in range(maxi(0, cy - r), mini(h, cy + r + 1)):
		for x in range(maxi(0, cx - r - 2), mini(w, cx + r + 3)):
			seen[idx(x, y)] = 1


func _put(cx: int, cy: int, v: int) -> void:
	if cx <= 0 or cy <= 0 or cx >= w - 1 or cy >= h - 1:
		return
	grid[idx(cx, cy)] = v


func _put_v(cx: int, cy: int, v: int) -> void:
	if not reserved.has(Vector2i(cx, cy)):
		_put(cx, cy, v)


func _room_of(cx: int, cy: int) -> Vector2i:
	return Vector2i(cx / RW, cy / RH)


func _setup_common(r: RandomNumberGenerator, rule_list: Array) -> void:
	rng = r
	rules = rule_list
	font = ThemeDB.fallback_font
	grid.resize(w * h)
	grid.fill(SOLID)
	seen.resize(w * h)
	seen.fill(0)
	z_index = -10
	tile_layer = TileLayer.new()
	tile_layer.lvl = self
	tile_layer.z_index = 5
	add_child(tile_layer)
	emissive = Emissive.new()
	emissive.lvl = self
	emissive.z_index = 2
	var mat := CanvasItemMaterial.new()
	mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	emissive.material = mat
	add_child(emissive)


# ---------------------------------------------------------------- normal floor

func generate(r: RandomNumberGenerator, floor_num: int, rule_list: Array) -> void:
	_setup_common(r, rule_list)

	for ry in RY:
		for rx in RX:
			for y in range(ry * RH + 1, ry * RH + RH - 1):
				for x in range(rx * RW + 1, rx * RW + RW - 1):
					grid[idx(x, y)] = EMPTY

	var path: Array[Vector2i] = []
	var on_path := {}
	var cx := rng.randi_range(0, RX - 1)
	var cy := 0
	path.append(Vector2i(cx, cy))
	on_path[Vector2i(cx, cy)] = true
	while true:
		var roll := rng.randi_range(1, 5)
		var down := roll == 5
		if not down:
			var nx := cx + (-1 if roll <= 2 else 1)
			if nx < 0 or nx >= RX or on_path.has(Vector2i(nx, cy)):
				down = true
			else:
				_link_h(mini(cx, nx), cy)
				cx = nx
		if down:
			if cy == RY - 1:
				break
			_link_v(cx, cy)
			cy += 1
		var rc := Vector2i(cx, cy)
		if not on_path.has(rc):
			path.append(rc)
			on_path[rc] = true

	for ry in RY:
		for rx in RX - 1:
			if not _linked(Vector2i(rx, ry), Vector2i(rx + 1, ry)) and rng.randf() < 0.5:
				_link_h(rx, ry)
	for _i in 64:
		var reach := _reachable(path[0])
		if reach.size() >= RX * RY:
			break
		var fixed := false
		for ry in RY:
			for rx in RX:
				if fixed:
					break
				var rc := Vector2i(rx, ry)
				if reach.has(rc):
					continue
				if rx > 0 and reach.has(Vector2i(rx - 1, ry)):
					_link_h(rx - 1, ry)
					fixed = true
				elif rx < RX - 1 and reach.has(Vector2i(rx + 1, ry)):
					_link_h(rx, ry)
					fixed = true
				elif ry > 0 and reach.has(Vector2i(rx, ry - 1)) and not holes.has(Vector2i(rx, ry - 1)):
					_link_v(rx, ry - 1)
					fixed = true
				elif ry < RY - 1 and reach.has(Vector2i(rx, ry + 1)) and not holes.has(rc):
					_link_v(rx, ry)
					fixed = true
		if not fixed:
			break

	var start_room: Vector2i = path[0]
	var exit_room: Vector2i = path[path.size() - 1]
	var sx := _pick_floor_col(start_room)
	var sfy := start_room.y * RH + RH - 2
	var ex := _pick_floor_col(exit_room)
	var efy := exit_room.y * RH + RH - 2
	for x in range(sx - 1, sx + 2):
		for y in range(sfy - 2, sfy + 1):
			reserved[Vector2i(x, y)] = true
	for x in range(ex - 1, ex + 2):
		for y in range(efy - 2, efy + 1):
			reserved[Vector2i(x, y)] = true

	for ry in RY:
		for rx in RX:
			_decorate_room(rx, ry)

	start_pos = Vector2(sx * T + 8, (sfy + 1) * T - 11)
	exit_pos = Vector2(ex * T + 8, (efy + 1) * T)
	_put(ex, efy + 1, SOLID)
	_put(sx, sfy + 1, SOLID)

	# Glass panes in doorways (smash through at speed).
	for d in doors:
		var dd: Vector2i = d
		if rng.randf() < 0.4:
			var gx := dd.x + rng.randi_range(0, 1)
			for y in range(dd.y - 2, dd.y + 1):
				grid[idx(gx, y)] = GLASS
	# Cracked secret walls between unconnected rooms.
	for ry in RY:
		for rx in RX - 1:
			if not _linked(Vector2i(rx, ry), Vector2i(rx + 1, ry)) and rng.randf() < 0.5:
				var wx := rx * RW + RW - 1
				var fy := ry * RH + RH - 2
				for y in [fy - 1, fy]:
					for x in [wx, wx + 1]:
						grid[idx(x, y)] = CRACK

	# Spikes.
	var sp := minf(0.05 + 0.012 * floor_num, 0.2) * (2.0 if rules.has("edge") else 1.0)
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			if grid[idx(x, y)] != EMPTY or get_cell(x, y + 1) != SOLID or solid(x, y - 1):
				continue
			var c := Vector2i(x, y)
			if reserved.has(c) or no_spike.has(c) or _room_of(x, y) == start_room:
				continue
			if rng.randf() < sp:
				grid[idx(x, y)] = SPIKE

	# Chips.
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			var v := grid[idx(x, y)]
			if v == EMPTY and solid(x, y + 1) and rng.randf() < 0.09:
				chip_spots.append([Vector2(x * T + 8, y * T + 8), _roll_value(floor_num)])
			elif v == SPIKE and get_cell(x, y - 1) == EMPTY and rng.randf() < 0.3:
				chip_spots.append([Vector2(x * T + 8, (y - 1) * T + 8), 25 if rng.randf() < 0.15 else 5])
	for ry in RY:
		for rx in RX:
			if rng.randf() < 0.45:
				var ly := rng.randi_range(ry * RH + 2, ry * RH + RH - 4)
				var ln := rng.randi_range(3, 5)
				var lx := rng.randi_range(rx * RW + 1, rx * RW + RW - 1 - ln)
				for x in range(lx, lx + ln):
					if grid[idx(x, ly)] == EMPTY:
						chip_spots.append([Vector2(x * T + 8, ly * T + 8), 1])

	# Floor/ceiling candidate cells.
	var floor_cells: Array = []
	var ceil_cells: Array = []
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			if grid[idx(x, y)] != EMPTY or _room_of(x, y) == start_room:
				continue
			if get_cell(x, y + 1) == SOLID and get_cell(x, y - 1) == EMPTY:
				floor_cells.append(Vector2(x * T + 8, (y + 1) * T))
			if get_cell(x, y - 1) == SOLID and get_cell(x, y + 1) == EMPTY and get_cell(x, y + 2) == EMPTY:
				ceil_cells.append(Vector2(x * T + 8, y * T))
	_shuffle(floor_cells)
	_shuffle(ceil_cells)

	# Casino tables (one or two per floor) and breakable props.
	var used: Array = []
	var tables := 1 + (1 if rng.randf() < 0.5 else 0)
	for c in floor_cells:
		if tables <= 0:
			break
		var p: Vector2 = c
		var cxx := floori(p.x / T)
		var cyy := floori(p.y / T) - 1
		if get_cell(cxx - 1, cyy) == EMPTY and get_cell(cxx + 1, cyy) == EMPTY and get_cell(cxx - 1, cyy + 1) == SOLID \
				and get_cell(cxx + 1, cyy + 1) == SOLID and p.distance_to(exit_pos) > 60.0 and _far(used, p, 64.0):
			games.append([p, ["blackjack", "roulette", "bar"][rng.randi_range(0, 2)]])
			used.append(p)
			tables -= 1
	for c in floor_cells:
		var p: Vector2 = c
		var cc := Vector2i(floori(p.x / T), floori(p.y / T) - 1)
		if reserved.has(cc) or not _far(used, p, 28.0) or rng.randf() > 0.12:
			continue
		var r2 := rng.randf()
		prop_spots.append([p, 0 if r2 < 0.5 else (1 if r2 < 0.85 else 2)])
		used.append(p)

	var mult := 2 if rules.has("security") else 1
	var guard_cells: Array = []
	for c in floor_cells:
		guard_cells.append((c as Vector2) + Vector2(0, -11))
	var bat_cells: Array = []
	for c in ceil_cells:
		bat_cells.append((c as Vector2) + Vector2(0, 5))
	_place(guard_cells, mini(2 + floor_num, 12) * mult, 0)
	_place(bat_cells, mini(1 + floor_num / 2, 8) * mult, 1)

	for c in ceil_cells:
		if lamps.size() >= 12:
			break
		if _far(lamps, c, 72.0) and rng.randf() < 0.25:
			lamps.append(c)

	_room_dressing()
	_foliage_data()
	_finish()


# ---------------------------------------------------------------- boss arena

func generate_boss(r: RandomNumberGenerator, tier: int, rule_list: Array) -> void:
	w = 44
	h = 20
	is_boss = true
	exit_locked = true
	_setup_common(r, rule_list)
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			grid[idx(x, y)] = EMPTY
	var fy := h - 2
	for x in range(7, 13):
		grid[idx(x, fy - 4)] = SOLID
	for x in range(w - 13, w - 7):
		grid[idx(x, fy - 4)] = SOLID
	for x in range(w / 2 - 4, w / 2 + 4):
		grid[idx(x, fy - 8)] = CRACK if tier >= 2 else SOLID
	for x in range(2, 5):
		grid[idx(x, fy - 9)] = SOLID
	for x in range(w - 5, w - 2):
		grid[idx(x, fy - 9)] = SOLID
	start_pos = Vector2(3 * T + 8, (fy + 1) * T - 11)
	exit_pos = Vector2((w - 4) * T + 8, (fy + 1) * T)
	boss_spawn = Vector2(w * T * 0.66, (fy + 1) * T)
	for x in range(4, w - 4, 7):
		lamps.append(Vector2(x * T + 8, T))
	for i in 5:
		slots.append(Vector2((14 + i * 4) * T + 8, (fy + 1) * T))
	bg_pillars.append([6 * T, T, (fy + 1) * T])
	bg_pillars.append([(w - 7) * T, T, (fy + 1) * T])
	banners.append(Vector2(10 * T, T))
	banners.append(Vector2((w - 10) * T, T))
	neons.append([Vector2(w * T * 0.5, 4 * T), "THE HOUSE ALWAYS WINS", NEON_COLS[tier % NEON_COLS.size()], 11])
	for i in 6:
		chip_spots.append([Vector2((8 + i * 5) * T + 8, (fy - 5) * T + 8), 5])
	for x in range(2, w - 2):
		if rng.randf() < 0.5:
			grass.append([Vector2(x * T + rng.randf_range(2, 14), (fy + 1) * T), rng.randf_range(3, 7), rng.randf()])
	_finish()


# ---------------------------------------------------------------- helpers

func _finish() -> void:
	_build_collision()
	_build_lights()
	queue_redraw()
	tile_layer.queue_redraw()


func _far(list: Array, p: Vector2, d: float) -> bool:
	for q in list:
		var qq: Vector2 = q[0] if q is Array else q
		if qq.distance_to(p) < d:
			return false
	return true


func _place(cells: Array, n: int, kind: int) -> void:
	var placed := 0
	for c in cells:
		if placed >= n:
			return
		var p: Vector2 = c
		if p.distance_to(start_pos) < 110.0:
			continue
		var ok := true
		for e in enemy_spots:
			if (e[0] as Vector2).distance_to(p) < 48.0:
				ok = false
				break
		if ok:
			enemy_spots.append([p, kind])
			placed += 1


func _shuffle(a: Array) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = a[i]
		a[i] = a[j]
		a[j] = tmp


func _roll_value(floor_num: int) -> int:
	var r := rng.randf()
	if r < 0.03 + floor_num * 0.005:
		return 25
	if r < 0.18:
		return 5
	return 1


func _pick_floor_col(room: Vector2i) -> int:
	var x0 := room.x * RW
	var fy := room.y * RH + RH - 2
	var cands: Array[int] = []
	for x in range(x0 + 2, x0 + RW - 2):
		if solid(x, fy + 1) and not reserved.has(Vector2i(x, fy)):
			cands.append(x)
	if cands.is_empty():
		return x0 + RW / 2
	return cands[rng.randi_range(0, cands.size() - 1)]


func _add_link(a: Vector2i, b: Vector2i) -> void:
	if not links.has(a):
		links[a] = []
	if not links.has(b):
		links[b] = []
	links[a].append(b)
	links[b].append(a)


func _linked(a: Vector2i, b: Vector2i) -> bool:
	return links.has(a) and (links[a] as Array).has(b)


func _reachable(from: Vector2i) -> Dictionary:
	var seen_r := {from: true}
	var stack: Array = [from]
	while not stack.is_empty():
		var cur: Vector2i = stack.pop_back()
		for n in links.get(cur, []):
			if not seen_r.has(n):
				seen_r[n] = true
				stack.append(n)
	return seen_r


func _link_h(rx: int, ry: int) -> void:
	_add_link(Vector2i(rx, ry), Vector2i(rx + 1, ry))
	var wx := rx * RW + RW - 1
	var fy := ry * RH + RH - 2
	doors.append(Vector2i(wx, fy))
	for y in range(fy - 2, fy + 1):
		for x in range(wx - 1, wx + 3):
			if x == wx or x == wx + 1:
				grid[idx(x, y)] = EMPTY
			reserved[Vector2i(x, y)] = true


func _link_v(rx: int, ry: int) -> void:
	_add_link(Vector2i(rx, ry), Vector2i(rx, ry + 1))
	if holes.has(Vector2i(rx, ry)):
		return
	var hx := rng.randi_range(rx * RW + 2, rx * RW + RW - 5)
	holes[Vector2i(rx, ry)] = hx
	var by := ry * RH + RH - 1
	for x in range(hx, hx + 3):
		grid[idx(x, by)] = EMPTY
		grid[idx(x, by + 1)] = EMPTY
		for y in range(by - 3, by + 4):
			reserved[Vector2i(x, y)] = true


func _decorate_room(rx: int, ry: int) -> void:
	var x0 := rx * RW
	var y0 := ry * RH
	var fy := y0 + RH - 2
	for _i in rng.randi_range(1, 3):
		var ln := rng.randi_range(3, 6)
		var px := rng.randi_range(x0 + 1, x0 + RW - 1 - ln)
		var py := rng.randi_range(y0 + 3, y0 + RH - 5)
		var r := rng.randf()
		var kind := CRUMBLE if r < 0.2 else (CRACK if r < 0.28 else SOLID)
		for x in range(px, px + ln):
			_put_v(x, py, kind)
	if rng.randf() < 0.55:
		var px := rng.randi_range(x0 + 3, x0 + RW - 4)
		if not reserved.has(Vector2i(px, fy)) and not reserved.has(Vector2i(px, fy - 1)) and solid(px, fy + 1):
			_put_v(px, fy, SOLID)
			no_spike[Vector2i(px, fy - 1)] = true
			no_spike[Vector2i(px - 1, fy)] = true
			no_spike[Vector2i(px + 1, fy)] = true
			if rng.randf() < 0.25:
				_put_v(px, fy - 1, SOLID)
				no_spike[Vector2i(px, fy - 2)] = true
	if rng.randf() < 0.35:
		var ox := rng.randi_range(x0 + 3, x0 + RW - 6)
		var ok := true
		for x in range(ox, ox + 3):
			if reserved.has(Vector2i(x, fy - 1)) or reserved.has(Vector2i(x, fy)) or not solid(x, fy + 1):
				ok = false
		if ok:
			for x in range(ox, ox + 3):
				_put_v(x, fy - 1, SOLID)
				grid[idx(x, fy)] = EMPTY
				no_spike[Vector2i(x, fy)] = true


func _room_dressing() -> void:
	for ry in RY:
		for rx in RX:
			var x0 := rx * RW
			var y0 := ry * RH
			var fy := y0 + RH - 2
			if rng.randf() < 0.4:
				var word: String = NEON_WORDS[rng.randi_range(0, NEON_WORDS.size() - 1)]
				var col: Color = NEON_COLS[rng.randi_range(0, NEON_COLS.size() - 1)]
				neons.append([Vector2((x0 + rng.randi_range(4, RW - 5)) * T, (y0 + 2) * T + 6), word, col, 8])
			if rng.randf() < 0.45:
				var sx := rng.randi_range(x0 + 2, x0 + RW - 5)
				for i in rng.randi_range(1, 3):
					var x := sx + i
					if get_cell(x, fy) == EMPTY and get_cell(x, fy + 1) == SOLID:
						slots.append(Vector2(x * T + 8, (fy + 1) * T))
			if rng.randf() < 0.3:
				bg_pillars.append([(x0 + rng.randi_range(2, RW - 3)) * T, (y0 + 1) * T, (fy + 1) * T])
			if rng.randf() < 0.3:
				banners.append(Vector2((x0 + rng.randi_range(2, RW - 3)) * T + 8, (y0 + 1) * T))
	# Every visible slot cabinet is playable.
	for s in slots:
		games.append([s, "slots"])


func _foliage_data() -> void:
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			if grid[idx(x, y)] != EMPTY:
				continue
			if solid(x, y + 1) and rng.randf() < 0.5:
				for _i in rng.randi_range(2, 4):
					grass.append([Vector2(x * T + rng.randf_range(1, 15), (y + 1) * T), rng.randf_range(3, 7.5), rng.randf()])
				if rng.randf() < 0.05 and shrooms.size() < 14:
					var cols := [Color(0.3, 1, 0.85), Color(1, 0.4, 0.9), Color(0.6, 0.8, 1)]
					shrooms.append([Vector2(x * T + rng.randf_range(4, 12), (y + 1) * T), rng.randf_range(2.0, 3.6), cols[rng.randi_range(0, 2)]])
			if get_cell(x, y - 1) == SOLID and rng.randf() < 0.06 and vine_spots.size() < 24:
				var free := 0
				while free < 6 and get_cell(x, y + free) == EMPTY:
					free += 1
				if free >= 2:
					vine_spots.append([Vector2(x * T + rng.randf_range(3, 13), y * T), rng.randi_range(3, mini(9, free * 4 - 2))])


# ---------------------------------------------------------------- physics + light

func _build_collision() -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	add_child(body)
	var used := PackedByteArray()
	used.resize(w * h)
	for y in h:
		for x in w:
			var i := idx(x, y)
			var v := grid[i]
			if v >= GLASS:
				_special_body(Vector2i(x, y), v)
				continue
			if v != SOLID or used[i] == 1:
				continue
			var x2 := x
			while x2 + 1 < w and grid[idx(x2 + 1, y)] == SOLID and used[idx(x2 + 1, y)] == 0:
				x2 += 1
			var y2 := y
			while y2 + 1 < h:
				var full := true
				for xx in range(x, x2 + 1):
					var j := idx(xx, y2 + 1)
					if grid[j] != SOLID or used[j] == 1:
						full = false
						break
				if not full:
					break
				y2 += 1
			for yy in range(y, y2 + 1):
				for xx in range(x, x2 + 1):
					used[idx(xx, yy)] = 1
			var rect := Rect2(x * T, y * T, (x2 - x + 1) * T, (y2 - y + 1) * T)
			var rs := RectangleShape2D.new()
			rs.size = rect.size
			var cs := CollisionShape2D.new()
			cs.shape = rs
			cs.position = rect.get_center()
			body.add_child(cs)
			_occluder(rect)


func _special_body(c: Vector2i, v: int) -> void:
	var b := StaticBody2D.new()
	b.collision_layer = 1
	b.collision_mask = 0
	var rs := RectangleShape2D.new()
	rs.size = Vector2(T, T)
	var cs := CollisionShape2D.new()
	cs.shape = rs
	b.add_child(cs)
	b.position = Vector2(c.x * T + T * 0.5, c.y * T + T * 0.5)
	add_child(b)
	var nodes: Array = [b]
	if v != GLASS:
		nodes.append(_occluder(Rect2(c.x * T, c.y * T, T, T)))
	cell_nodes[c] = nodes


func _occluder(rect: Rect2) -> LightOccluder2D:
	var r := rect.grow(-3.0)
	var op := OccluderPolygon2D.new()
	op.polygon = PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)])
	var lo := LightOccluder2D.new()
	lo.occluder = op
	add_child(lo)
	return lo


static func light_tex() -> GradientTexture2D:
	if _light_tex == null:
		var g := Gradient.new()
		g.set_color(0, Color(1, 1, 1, 1))
		g.set_color(1, Color(1, 1, 1, 0))
		g.add_point(0.35, Color(1, 1, 1, 0.5))
		_light_tex = GradientTexture2D.new()
		_light_tex.gradient = g
		_light_tex.fill = GradientTexture2D.FILL_RADIAL
		_light_tex.fill_from = Vector2(0.5, 0.5)
		_light_tex.fill_to = Vector2(1.0, 0.5)
		_light_tex.width = 256
		_light_tex.height = 256
	return _light_tex


func make_light(pos: Vector2, col: Color, energy: float, scale_: float, shadows: bool) -> PointLight2D:
	var l := PointLight2D.new()
	l.texture = light_tex()
	l.color = col
	l.energy = energy
	l.texture_scale = scale_
	l.position = pos
	l.shadow_enabled = shadows
	if shadows:
		l.shadow_filter = Light2D.SHADOW_FILTER_PCF5
		l.shadow_filter_smooth = 1.5
		l.shadow_color = Color(0, 0, 0, 0.85)
	add_child(l)
	return l


func _build_lights() -> void:
	var dim := rules.has("lights")
	for l in lamps:
		make_light((l as Vector2) + Vector2(0, 13), Color(1.0, 0.74, 0.45), 0.35 if dim else 1.25, 1.15, true)
	make_light(exit_pos + Vector2(0, -20), Color(1.0, 0.45, 0.3), 1.2, 0.75, true)
	if not dim:
		for n in neons:
			make_light(n[0], n[2], 0.75, 0.6 if n[3] < 10 else 1.3, false)
		var k := 0
		for s in shrooms:
			if k >= 8:
				break
			make_light((s[0] as Vector2) + Vector2(0, -3), s[2], 0.55, 0.3, false)
			k += 1


# ---------------------------------------------------------------- destruction

## Break a glass/cracked/crumble cell (and connected cells of the same kind).
func smash(cell: Vector2i) -> void:
	var v := get_cell(cell.x, cell.y)
	if v != GLASS and v != CRACK and v != CRUMBLE:
		return
	var todo: Array = [cell]
	var n := 0
	while todo.size() > 0 and n < 10:
		var c: Vector2i = todo.pop_back()
		if get_cell(c.x, c.y) != v:
			continue
		grid[idx(c.x, c.y)] = EMPTY
		crumble_t.erase(c)
		if cell_nodes.has(c):
			for nd in cell_nodes[c]:
				if nd is StaticBody2D:
					(nd as StaticBody2D).collision_layer = 0
				nd.queue_free()
			cell_nodes.erase(c)
		n += 1
		broke.emit(c, v)
		if v != CRUMBLE:
			for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				todo.append(c + d)
	tile_layer.queue_redraw()


func touch_crumble(c: Vector2i) -> void:
	if get_cell(c.x, c.y) == CRUMBLE and not crumble_t.has(c):
		crumble_t[c] = 0.45
		crumble_started.emit(c)


func _process(delta: float) -> void:
	t += delta
	if crumble_t.is_empty():
		return
	for c in crumble_t.keys():
		crumble_t[c] -= delta
		if crumble_t[c] <= 0.0:
			var cc: Vector2i = c
			for d in [Vector2i(1, 0), Vector2i(-1, 0)]:
				var nb: Vector2i = cc + d
				if get_cell(nb.x, nb.y) == CRUMBLE and not crumble_t.has(nb):
					crumble_t[nb] = 0.14
					crumble_started.emit(nb)
			smash(cc)
	tile_layer.queue_redraw()


# ---------------------------------------------------------------- drawing

func _draw() -> void:
	# Back wall.
	draw_rect(Rect2(0, 0, w * T, h * T), Color(0.10, 0.055, 0.13))
	var dc := Color(0.15, 0.08, 0.19)
	for y in range(0, h * T, 32):
		for x in range(0, w * T, 32):
			var o := Vector2(x + (16 if (y / 32) % 2 == 1 else 0), y)
			draw_colored_polygon(PackedVector2Array([o + Vector2(8, 3), o + Vector2(13, 8), o + Vector2(8, 13), o + Vector2(3, 8)]), dc)
	for y in range(0, h * T, 48):
		draw_rect(Rect2(0, y + 46, w * T, 2), Color(0.07, 0.035, 0.09))
	for p in bg_pillars:
		var x: float = p[0]
		var top: float = p[1]
		var bot: float = p[2]
		draw_rect(Rect2(x - 6, top, 12, bot - top), Color(0.17, 0.09, 0.2))
		draw_rect(Rect2(x - 6, top, 3, bot - top), Color(0.22, 0.12, 0.26))
		draw_rect(Rect2(x - 8, top, 16, 4), Color(0.55, 0.42, 0.2))
		draw_rect(Rect2(x - 8, bot - 5, 16, 5), Color(0.45, 0.33, 0.16))
	for b in banners:
		var p: Vector2 = b
		draw_colored_polygon(PackedVector2Array([p + Vector2(-5, 0), p + Vector2(5, 0), p + Vector2(5, 20), p + Vector2(0, 16), p + Vector2(-5, 20)]), Color(0.5, 0.06, 0.13))
		draw_rect(Rect2(p + Vector2(-5, 0), Vector2(10, 2)), Color(0.85, 0.65, 0.25))
		draw_colored_polygon(PackedVector2Array([p + Vector2(0, 5), p + Vector2(3, 8.5), p + Vector2(0, 12), p + Vector2(-3, 8.5)]), Color(0.85, 0.65, 0.25))
	for s in slots:
		var p: Vector2 = s
		var r := Rect2(p.x - 7, p.y - 25, 14, 25)
		draw_rect(r, Color(0.06, 0.02, 0.05))
		draw_rect(r.grow(-1), Color(0.32, 0.08, 0.14))
		draw_rect(Rect2(p.x - 6, p.y - 24, 2, 23), Color(0.55, 0.55, 0.62))
		draw_rect(Rect2(p.x - 6, p.y - 12, 12, 3), Color(0.2, 0.05, 0.08))
		draw_rect(Rect2(p.x - 6, p.y - 5, 12, 5), Color(0.15, 0.04, 0.07))
		draw_line(Vector2(p.x + 7, p.y - 18), Vector2(p.x + 9, p.y - 23), Color(0.6, 0.6, 0.65), 1.0)
		draw_circle(Vector2(p.x + 9, p.y - 24), 1.5, Color(0.9, 0.15, 0.2))


func draw_tiles(ci: CanvasItem) -> void:
	_draw_door(ci, start_pos + Vector2(0, 11), Color(0.45, 0.42, 0.5), false)
	_draw_door(ci, exit_pos, Color(1, 0.78, 0.25), true)
	for y in h:
		for x in w:
			var v := grid[idx(x, y)]
			match v:
				SOLID:
					_draw_tile(ci, x, y, Vector2.ZERO)
				SPIKE:
					_draw_spike(ci, x, y)
				GLASS:
					_draw_glass(ci, x, y)
				CRACK:
					_draw_tile(ci, x, y, Vector2.ZERO)
					_draw_cracks(ci, x, y)
				CRUMBLE:
					var off := Vector2.ZERO
					if crumble_t.has(Vector2i(x, y)):
						off = Vector2(randf_range(-1, 1), randf_range(-1, 1))
					_draw_crumble(ci, x, y, off)


func _draw_tile(ci: CanvasItem, x: int, y: int, off: Vector2) -> void:
	var r := Rect2(Vector2(x * T, y * T) + off, Vector2(T, T))
	var hsh := ((x * 73856093) ^ (y * 19349663)) & 255
	var base := Color(0.33, 0.1, 0.16).lerp(Color(0.26, 0.075, 0.13), float(hsh % 7) / 7.0)
	var up := not solid(x, y - 1)
	var dn := not solid(x, y + 1)
	var lf := not solid(x - 1, y)
	var rt := not solid(x + 1, y)
	if not (up or dn or lf or rt):
		base = base.darkened(0.45)
	ci.draw_rect(r, base)
	# Brick seams.
	if (y % 2 == 0 and x % 2 == 0) or (y % 2 == 1 and x % 2 == 1):
		ci.draw_rect(Rect2(r.position + Vector2(0, 7), Vector2(T, 1)), base.darkened(0.25))
	if hsh % 5 == 0:
		ci.draw_rect(Rect2(r.position + Vector2(3 + hsh % 8, 4 + hsh % 6), Vector2(2, 2)), base.lightened(0.18))
	if lf:
		ci.draw_rect(Rect2(r.position, Vector2(1, T)), base.lightened(0.25))
	if rt:
		ci.draw_rect(Rect2(r.position + Vector2(T - 1, 0), Vector2(1, T)), base.darkened(0.35))
	if dn:
		ci.draw_rect(Rect2(r.position + Vector2(0, T - 2), Vector2(T, 2)), base.darkened(0.4))
		if hsh % 3 == 0:
			for i in 1 + hsh % 3:
				var mx := 2 + (hsh * (i + 3)) % 12
				ci.draw_rect(Rect2(r.position + Vector2(mx, T), Vector2(1, 2 + (hsh + i) % 4)), Color(0.15, 0.4, 0.22))
	if up:
		ci.draw_rect(Rect2(r.position, Vector2(T, 4)), Color(0.09, 0.40, 0.25))
		ci.draw_rect(Rect2(r.position, Vector2(T, 1)), Color(0.95, 0.76, 0.32))


func _draw_cracks(ci: CanvasItem, x: int, y: int) -> void:
	var o := Vector2(x * T, y * T)
	var k := Color(0.05, 0.01, 0.03)
	ci.draw_polyline(PackedVector2Array([o + Vector2(2, 3), o + Vector2(6, 7), o + Vector2(5, 11), o + Vector2(9, 14)]), k, 1.0)
	ci.draw_polyline(PackedVector2Array([o + Vector2(6, 7), o + Vector2(11, 6), o + Vector2(14, 9)]), k, 1.0)
	ci.draw_rect(Rect2(o + Vector2(10, 11), Vector2(2, 2)), Color(0.5, 0.2, 0.25))


func _draw_crumble(ci: CanvasItem, x: int, y: int, off: Vector2) -> void:
	var r := Rect2(Vector2(x * T, y * T) + off, Vector2(T, T))
	ci.draw_rect(r, Color(0.45, 0.3, 0.22))
	ci.draw_rect(Rect2(r.position, Vector2(T, 3)), Color(0.6, 0.45, 0.3))
	ci.draw_rect(Rect2(r.position + Vector2(0, 8), Vector2(T, 1)), Color(0.3, 0.18, 0.13))
	ci.draw_rect(Rect2(r.position + Vector2(7, 0), Vector2(1, 8)), Color(0.3, 0.18, 0.13))
	ci.draw_rect(Rect2(r.position + Vector2(3, 9), Vector2(1, 7)), Color(0.3, 0.18, 0.13))
	ci.draw_rect(Rect2(r.position + Vector2(12, 9), Vector2(1, 7)), Color(0.3, 0.18, 0.13))


func _draw_glass(ci: CanvasItem, x: int, y: int) -> void:
	var r := Rect2(x * T, y * T, T, T)
	ci.draw_rect(r, Color(0.55, 0.85, 1.0, 0.18))
	ci.draw_rect(Rect2(r.position + Vector2(2, 0), Vector2(1, T)), Color(0.8, 0.95, 1, 0.5))
	ci.draw_line(r.position + Vector2(6, T - 2), r.position + Vector2(12, 2), Color(1, 1, 1, 0.35), 1.0)
	ci.draw_line(r.position + Vector2(9, T - 1), r.position + Vector2(14, 6), Color(1, 1, 1, 0.2), 1.0)
	if get_cell(x, y - 1) != GLASS:
		ci.draw_rect(Rect2(r.position, Vector2(T, 2)), Color(0.6, 0.6, 0.68))
	if get_cell(x, y + 1) != GLASS:
		ci.draw_rect(Rect2(r.position + Vector2(0, T - 2), Vector2(T, 2)), Color(0.6, 0.6, 0.68))


func _draw_spike(ci: CanvasItem, x: int, y: int) -> void:
	var o := Vector2(x * T, y * T + T)
	for i in 3:
		var bx := o.x + i * 5.33
		ci.draw_colored_polygon(PackedVector2Array([Vector2(bx, o.y), Vector2(bx + 2.66, o.y - 9), Vector2(bx + 5.33, o.y)]), Color(0.78, 0.8, 0.86))
		ci.draw_line(Vector2(bx + 2.66, o.y - 9), Vector2(bx + 2.66, o.y - 6), Color(0.85, 0.15, 0.2), 1.0)


func _draw_door(ci: CanvasItem, p: Vector2, frame: Color, is_exit: bool) -> void:
	ci.draw_rect(Rect2(p.x - 10, p.y - 31, 20, 31), frame)
	ci.draw_rect(Rect2(p.x - 7, p.y - 28, 14, 28), Color(0.03, 0.01, 0.04))
	if is_exit:
		ci.draw_rect(Rect2(p.x - 7, p.y - 28, 14, 28), Color(0.5, 0.1, 0.15, 0.4))
		if exit_locked:
			ci.draw_line(p + Vector2(-7, -28), p + Vector2(7, 0), Color(0.6, 0.6, 0.65), 2.0)
			ci.draw_line(p + Vector2(7, -28), p + Vector2(-7, 0), Color(0.6, 0.6, 0.65), 2.0)
			ci.draw_rect(Rect2(p + Vector2(-3, -17), Vector2(6, 6)), Color(0.85, 0.7, 0.3))


func draw_emissive(ci: CanvasItem) -> void:
	for n in neons:
		var p: Vector2 = n[0]
		var txt: String = n[1]
		var col: Color = n[2]
		var sz: int = n[3]
		var flick := 1.0
		var hs := int(p.x * 7.0) % 29
		if int(t * 9.0 + hs) % 37 == 0:
			flick = 0.25
		var tw := font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, sz).x
		var box := Rect2(p.x - tw * 0.5 - 4, p.y - sz - 2, tw + 8, sz + 7)
		ci.draw_rect(box, Color(col, 0.08 * flick))
		ci.draw_rect(box, Color(col, 0.7 * flick), false, 1.0)
		ci.draw_string_outline(font, Vector2(box.position.x + 4, p.y + 2), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, sz, 4, Color(col, 0.3 * flick))
		ci.draw_string(font, Vector2(box.position.x + 4, p.y + 2), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, sz, Color(col.lightened(0.55), flick))
	var syms := [Color(1, 0.3, 0.3), Color(1, 0.85, 0.3), Color(0.4, 0.9, 1), Color(0.5, 1, 0.5)]
	for i in slots.size():
		var p: Vector2 = slots[i]
		ci.draw_rect(Rect2(p.x - 5, p.y - 21, 10, 7), Color(0.95, 0.9, 0.75))
		for j in 3:
			var c: Color = syms[(i * 3 + j + int(t * 2.0) * (1 if j == 1 else 0)) % syms.size()]
			ci.draw_rect(Rect2(p.x - 4.5 + j * 3.2, p.y - 20, 2.6, 5), c)
		var blink := int(t * 3.0 + i) % 2 == 0
		ci.draw_rect(Rect2(p.x - 6, p.y - 25, 12, 2), Color(1, 0.3, 0.5) if blink else Color(1, 0.85, 0.3))
	for l in lamps:
		var lp: Vector2 = l
		ci.draw_line(lp, lp + Vector2(0, 10), Color(0.3, 0.25, 0.22), 1.0)
		ci.draw_rect(Rect2(lp + Vector2(-4, 9), Vector2(8, 2)), Color(0.4, 0.3, 0.2))
		ci.draw_circle(lp + Vector2(0, 12.5), 2.2, Color(1, 0.92, 0.65))
	var ep := exit_pos
	ci.draw_rect(Rect2(ep.x - 11, ep.y - 41, 22, 8), Color(0.9, 0.1, 0.18) if not exit_locked else Color(0.3, 0.3, 0.35))
	ci.draw_string(font, Vector2(ep.x - 11, ep.y - 34.6), "EXIT" if not exit_locked else "SHUT", HORIZONTAL_ALIGNMENT_CENTER, 22, 7, Color(1, 0.95, 0.8))
