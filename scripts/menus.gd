extends RefCounted
## Generic modal menu used by the new systems: Vera's charm table, charm
## picks and swaps, the side-bet kiosk, Mags' loans, Vera's licenses, the
## Table Limits board and the Losing Tickets board.
##
## main.gd builds the item list and handles the chosen item; this script only
## does selection and drawing. Items are dictionaries:
##   {"id", "name", "desc", "tag" (small right-hand text), "col", "disabled"}

const GOLD := Color(1.0, 0.78, 0.25)
const DIM := Color(0.72, 0.68, 0.8)

var kind := ""
var title := ""
var sub := ""
var items: Array = []
var sel := 0
var layout := "cards"
var msg := ""
var msg_col := Color.WHITE
var hint := ""
var data := {}
var done := false
var t := 0.0


func open(k: String, ttl: String, subtitle: String, its: Array, lay := "cards", d := {}) -> void:
	kind = k
	title = ttl
	sub = subtitle
	items = its
	layout = lay
	data = d
	sel = 0
	msg = ""
	done = false
	t = 0.0
	hint = ("< > choose" if layout == "cards" else "UP / DOWN choose") + "     JUMP select     ESC back"


func set_msg(text: String, col := Color.WHITE) -> void:
	msg = text
	msg_col = col


## Returns {"choose": item} when the player picks something, {"back": true}
## when they leave, or {} otherwise.
func press(action: String) -> Dictionary:
	if items.is_empty() and action == "confirm":
		done = true
		return {"back": true}
	var prev_key := "left" if layout == "cards" else "up"
	var next_key := "right" if layout == "cards" else "down"
	if action == prev_key and items.size() > 0:
		sel = (sel + items.size() - 1) % items.size()
		Sfx.play("tick")
	elif action == next_key and items.size() > 0:
		sel = (sel + 1) % items.size()
		Sfx.play("tick")
	elif action == "back" or (layout == "cards" and action == "down"):
		done = true
		return {"back": true}
	elif action == "confirm":
		var it: Dictionary = items[sel]
		if it.get("disabled", false):
			Sfx.play("deny")
			return {}
		return {"choose": it}
	return {}


# ---------------------------------------------------------------- drawing

func _txt(ci: CanvasItem, f: Font, pos: Vector2, s: String, sz: int, col: Color, width := -1.0, align := HORIZONTAL_ALIGNMENT_CENTER) -> void:
	ci.draw_string_outline(f, pos, s, align, width, sz, maxi(4, sz / 5), Color(0, 0, 0, 0.85 * col.a))
	ci.draw_string(f, pos, s, align, width, sz, col)


func draw(ci: CanvasItem, f: Font, delta_t: float) -> void:
	t += delta_t
	ci.draw_rect(Rect2(0, 0, 1280, 720), Color(0.02, 0.0, 0.04, 0.82))
	var panel := Rect2(130, 70, 1020, 580)
	ci.draw_rect(panel.grow(5), Color(0.5, 0.36, 0.14))
	ci.draw_rect(panel, Color(0.06, 0.02, 0.09, 0.97))
	_txt(ci, f, Vector2(panel.position.x, 128), title, 42, GOLD, panel.size.x)
	if sub != "":
		ci.draw_multiline_string(f, Vector2(panel.position.x + 60, 162), sub, HORIZONTAL_ALIGNMENT_CENTER, panel.size.x - 120, 19, 3, DIM)
	if items.is_empty():
		_txt(ci, f, Vector2(panel.position.x, 360), "Nothing here yet.", 26, DIM, panel.size.x)
	elif layout == "cards":
		_draw_cards(ci, f)
	else:
		_draw_list(ci, f)
	if msg != "":
		_txt(ci, f, Vector2(panel.position.x, 596), msg, 22, msg_col, panel.size.x)
	_txt(ci, f, Vector2(panel.position.x, 632), hint, 17, DIM, panel.size.x)


func _draw_cards(ci: CanvasItem, f: Font) -> void:
	var n := items.size()
	var cw := minf(230.0, (920.0 - (n - 1) * 20.0) / n)
	var x0 := 640.0 - (n * cw + (n - 1) * 20.0) * 0.5
	for i in n:
		var it: Dictionary = items[i]
		var r := Rect2(x0 + i * (cw + 20.0), 210, cw, 330)
		var col: Color = it.get("col", Color.WHITE)
		var s := i == sel
		var dis: bool = it.get("disabled", false)
		ci.draw_rect(r, Color(col, 0.16) if s else Color(0, 0, 0, 0.45))
		ci.draw_rect(r, col if s else Color(col, 0.35), false, 4.0 if s else 2.0)
		if s:
			ci.draw_rect(r.grow(6.0 + 2.0 * sin(t * 6.0)), Color(col, 0.25), false, 2.0)
		# Emblem.
		var c := r.position + Vector2(cw * 0.5, 66)
		ci.draw_circle(c, 34.0, Color(0, 0, 0, 0.5))
		ci.draw_circle(c, 30.0, Color(col, 0.85 if not dis else 0.3))
		ci.draw_circle(c, 20.0, Color(col.darkened(0.45), 1.0))
		var ic: String = it.get("icon", String(it.get("name", "?")).left(1))
		_txt(ci, f, Vector2(c.x - 30, c.y + 11), ic, 30, Color.WHITE, 60)
		ci.draw_multiline_string(f, Vector2(r.position.x + 10, r.position.y + 136), it.get("name", ""), HORIZONTAL_ALIGNMENT_CENTER, cw - 20, 21, 2, Color.WHITE if not dis else Color(1, 1, 1, 0.4))
		ci.draw_multiline_string(f, Vector2(r.position.x + 12, r.position.y + 196), it.get("desc", ""), HORIZONTAL_ALIGNMENT_CENTER, cw - 24, 16, 5, DIM)
		if String(it.get("tag", "")) != "":
			_txt(ci, f, Vector2(r.position.x, r.end.y - 18), it["tag"], 20, it.get("tag_col", GOLD), cw)


func _draw_list(ci: CanvasItem, f: Font) -> void:
	var sel_it: Dictionary = items[sel]
	var long_text: String = sel_it.get("long", "")
	var rows := 5 if long_text != "" else 8
	var top := clampi(sel - rows / 2, 0, maxi(0, items.size() - rows))
	for k in mini(rows, items.size()):
		var i := top + k
		var it: Dictionary = items[i]
		var r := Rect2(190, 200 + k * 46, 900, 40)
		var s := i == sel
		var col: Color = it.get("col", Color.WHITE)
		ci.draw_rect(r, Color(col, 0.14) if s else Color(0, 0, 0, 0.35))
		ci.draw_rect(r, col if s else Color(1, 1, 1, 0.08), false, 2.0 if s else 1.0)
		ci.draw_rect(Rect2(r.position, Vector2(5, r.size.y)), col)
		var dis: bool = it.get("disabled", false)
		_txt(ci, f, Vector2(r.position.x + 18, r.position.y + 27), it.get("name", ""), 19, Color.WHITE if not dis else Color(1, 1, 1, 0.45), 270, HORIZONTAL_ALIGNMENT_LEFT)
		_txt(ci, f, Vector2(r.position.x + 290, r.position.y + 26), it.get("desc", ""), 15, DIM, 470, HORIZONTAL_ALIGNMENT_LEFT)
		if String(it.get("tag", "")) != "":
			_txt(ci, f, Vector2(r.position.x, r.position.y + 27), it["tag"], 18, it.get("tag_col", GOLD), r.size.x - 14, HORIZONTAL_ALIGNMENT_RIGHT)
	if items.size() > rows:
		_txt(ci, f, Vector2(190, 196), "%d / %d" % [sel + 1, items.size()], 15, DIM, 900, HORIZONTAL_ALIGNMENT_RIGHT)
	# Long-form text for the selected row (the Losing Tickets board).
	if long_text != "":
		var box := Rect2(190, 440, 900, 128)
		ci.draw_rect(box, Color(0.93, 0.9, 0.8))
		ci.draw_rect(box, Color(0.5, 0.35, 0.2), false, 3.0)
		ci.draw_multiline_string(f, box.position + Vector2(24, 40), long_text, HORIZONTAL_ALIGNMENT_LEFT, box.size.x - 48, 21, 4, Color(0.15, 0.08, 0.1))
