extends RefCounted
## Per-type enemy gear drawn over the rig (hats, visors, headsets, props in hand) so every enemy
## type has its own silhouette, plus city jacket palettes (grimy alley -> white-tux Strip).
## Everything is in rig space (feet at the origin, facing +x, up is -y).

const K := Color(0.06, 0.03, 0.08)

## [jacket, jacket light, trim] per city 0..4, and the alley.
const CITY_PAL := [
	[Color(0.14, 0.3, 0.34), Color(0.25, 0.48, 0.52), Color(0.9, 0.7, 0.3)],      # Atlantic Shitty: faded teal
	[Color(0.55, 0.12, 0.16), Color(0.85, 0.3, 0.32), Color(0.95, 0.9, 0.7)],     # Reno: tent red
	[Color(0.18, 0.13, 0.1), Color(0.34, 0.24, 0.17), Color(0.95, 0.65, 0.3)],    # Biloxi: leather
	[Color(0.2, 0.16, 0.07), Color(0.6, 0.46, 0.14), Color(1.0, 0.85, 0.35)],     # Fremont: black and gold
	[Color(0.8, 0.8, 0.86), Color(1.0, 1.0, 1.0), Color(0.8, 0.15, 0.3)],         # Strip: white tux
]
const ALLEY_PAL := [Color(0.24, 0.22, 0.2), Color(0.38, 0.35, 0.3), Color(0.6, 0.5, 0.3)]


static func palette(floor_num: int) -> Array:
	var city := clampi((floor_num - 1) / 5, 0, 4)
	if city == 0 and floor_num <= 2:
		return ALLEY_PAL
	return CITY_PAL[city]


static func _poly(ci: CanvasItem, pts: Array, col: Color, ol := true) -> void:
	var p := PackedVector2Array(pts)
	ci.draw_colored_polygon(p, col)
	if ol:
		var l := p.duplicate()
		l.append(p[0])
		ci.draw_polyline(l, K, 0.5)


static func enemy(ci: CanvasItem, xf: Transform2D, rig, kind: int, t: float, trim: Color) -> void:
	if rig == null:
		return
	ci.draw_set_transform_matrix(xf)
	var hand: Vector2 = rig.pose["hand_f"]
	var hd: Vector2 = rig.head_point(Vector2(0.5, -3.5))     # head centre
	var nk: Vector2 = rig.neck()
	match kind:
		0:   # alley thug: red bandana + stubble
			_poly(ci, [hd + Vector2(-4.4, -1.6), hd + Vector2(4.4, -1.6), hd + Vector2(4.6, -0.4), hd + Vector2(-4.6, -0.4)], Color(0.75, 0.12, 0.14))
			ci.draw_line(hd + Vector2(-4.4, -1.0), hd + Vector2(-7.4, 0.6 + sin(t * 6.0)), Color(0.75, 0.12, 0.14), 1.2)
		4:   # junkie: ragged beanie, syringe, sunken glowing eyes
			_poly(ci, [hd + Vector2(-4.4, -1.2), hd + Vector2(-3.4, -5.4), hd + Vector2(3.6, -5.4), hd + Vector2(4.6, -1.2)], Color(0.45, 0.5, 0.3))
			ci.draw_line(hd + Vector2(-4.5, -1.3), hd + Vector2(4.6, -1.3), Color(0.3, 0.34, 0.2), 1.2)
			ci.draw_line(hand, hand + Vector2(5, -1.5), Color(0.85, 0.9, 0.95), 0.9)
			ci.draw_line(hand + Vector2(5, -1.5), hand + Vector2(7.5, -2.0), Color(0.7, 0.75, 0.8), 0.4)
			ci.draw_circle(hand + Vector2(1.5, -0.7), 0.7, Color(0.6, 1.0, 0.4, 0.9))
		6:   # bottle thrower: flat cap + paper-bag bottle
			_poly(ci, [hd + Vector2(-4.4, -1.4), hd + Vector2(-3.2, -4.8), hd + Vector2(3.4, -4.8), hd + Vector2(4.6, -1.4), hd + Vector2(7.0, -1.0), hd + Vector2(4.4, -0.2)], Color(0.4, 0.3, 0.18))
			_poly(ci, [hand + Vector2(-1.6, 1), hand + Vector2(1.8, 1), hand + Vector2(1.6, -4.5), hand + Vector2(0.8, -7.5), hand + Vector2(-0.4, -7.5), hand + Vector2(-1.2, -4.5)], Color(0.62, 0.5, 0.32))
			ci.draw_line(hand + Vector2(0.2, -7.5), hand + Vector2(0.2, -8.6), Color(0.2, 0.5, 0.2), 1.0)
		7:   # shark dealer: green eyeshade, sleeve garter, fanned cards
			_poly(ci, [hd + Vector2(-4.2, -1.6), hd + Vector2(-3.4, -4.0), hd + Vector2(3.4, -4.0), hd + Vector2(4.4, -1.6), hd + Vector2(7.2, -0.8), hd + Vector2(4.2, -0.6)], Color(0.1, 0.5, 0.35, 0.9))
			for k in 3:
				var a := -0.5 + k * 0.5
				ci.draw_line(hand, hand + Vector2.from_angle(a - PI * 0.5) * 5.5, Color(0.96, 0.95, 0.9), 2.2)
				ci.draw_circle(hand + Vector2.from_angle(a - PI * 0.5) * 4.0, 0.5, Color(0.8, 0.1, 0.15))
			ci.draw_line(nk + Vector2(2, 3), nk + Vector2(2, 5), Color(0.7, 0.1, 0.1), 1.2)
		8:   # pit boss: headset + clipboard + tie
			ci.draw_arc(hd + Vector2(0, -0.5), 4.6, PI * 1.05, PI * 1.95, 10, Color(0.1, 0.1, 0.12), 1.0)
			ci.draw_circle(hd + Vector2(4.6, 0.6), 1.2, Color(0.1, 0.1, 0.12))
			ci.draw_line(hd + Vector2(4.6, 0.8), hd + Vector2(5.6, 2.8), Color(0.1, 0.1, 0.12), 0.6)
			_poly(ci, [hand + Vector2(-2.4, -2.5), hand + Vector2(2.4, -2.5), hand + Vector2(2.4, 3.5), hand + Vector2(-2.4, 3.5)], Color(0.55, 0.4, 0.22))
			ci.draw_rect(Rect2(hand + Vector2(-1.6, -1.6), Vector2(3.2, 4.2)), Color(0.95, 0.95, 0.9))
			ci.draw_rect(Rect2(hand + Vector2(-1.0, -0.6), Vector2(2.0, 0.4)), Color(0.4, 0.4, 0.5))
		9:   # suited security: shades, earpiece wire, tie
			_poly(ci, [hd + Vector2(-3.8, -1.4), hd + Vector2(4.2, -1.4), hd + Vector2(4.0, 0.2), hd + Vector2(-3.6, 0.2)], Color(0.02, 0.02, 0.04))
			ci.draw_line(hd + Vector2(-3.0, -1.0), hd + Vector2(-1.8, -1.2), Color(1, 1, 1, 0.5), 0.4)
			ci.draw_line(hd + Vector2(-4.2, 0.4), nk + Vector2(-2.0, 2.0), Color(0.7, 0.6, 0.5), 0.4)
			_poly(ci, [nk + Vector2(0.4, 0.8), nk + Vector2(1.8, 0.8), nk + Vector2(2.0, 5.5), nk + Vector2(1.1, 6.4), nk + Vector2(0.2, 5.5)], trim, false)
		10:  # sniper: flat cap, long scoped rifle, glint
			_poly(ci, [hd + Vector2(-4.4, -1.2), hd + Vector2(-3.2, -4.6), hd + Vector2(3.4, -4.6), hd + Vector2(4.6, -1.2)], Color(0.1, 0.12, 0.16))
			ci.draw_line(hand + Vector2(-6, 1.5), hand + Vector2(10, -1.5), Color(0.08, 0.08, 0.1), 1.6)
			ci.draw_line(hand + Vector2(-2, 1.0), hand + Vector2(5, -0.8), Color(0.3, 0.32, 0.38), 0.9)
			ci.draw_circle(hand + Vector2(10.2, -1.5), 0.6, Color(1.0, 0.2, 0.2, 0.6 + 0.4 * sin(t * 8.0)))
		11:  # heir apparent: gold crown, monocle, cravat
			_poly(ci, [hd + Vector2(-3.4, -3.8), hd + Vector2(-3.4, -6.8), hd + Vector2(-1.7, -5.0), hd + Vector2(0, -7.4), hd + Vector2(1.7, -5.0), hd + Vector2(3.4, -6.8), hd + Vector2(3.4, -3.8)], Color(1.0, 0.82, 0.25))
			ci.draw_circle(hd + Vector2(0, -7.5), 0.6, Color(0.9, 0.1, 0.2))
			ci.draw_arc(hd + Vector2(2.2, -0.4), 1.3, 0, TAU, 10, Color(1.0, 0.85, 0.4), 0.4)
			_poly(ci, [nk + Vector2(-2.2, 1.0), nk + Vector2(2.2, 1.0), nk + Vector2(1.0, 4.0), nk + Vector2(-1.0, 4.0)], Color(0.95, 0.95, 0.92), false)
			ci.draw_circle(nk + Vector2(0, 2.4), 0.7, Color(0.8, 0.1, 0.25))
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)
