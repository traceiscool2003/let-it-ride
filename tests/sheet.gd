extends SceneTree
## Renders every character frame, scaled 8x, into user://sheet.png for review.

func _initialize() -> void:
	var S = load("res://scripts/sprites.gd")
	var texs: Array = []
	var r: Dictionary = S.runner()
	for k in ["idle0", "idle1", "run0", "run1", "run2", "jump", "fall", "hang", "slide"]:
		texs.append(r[k])
	texs.append_array(S.guard())
	texs.append_array(S.bat())
	var scale := 8
	var sheet := Image.create_empty(1400, 300, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.12, 0.07, 0.16))
	var x := 10
	for t in texs:
		var img: Image = (t as Texture2D).get_image()
		img.resize(img.get_width() * scale, img.get_height() * scale, Image.INTERPOLATE_NEAREST)
		sheet.blend_rect(img, Rect2i(Vector2i.ZERO, img.get_size()), Vector2i(x, 280 - img.get_height()))
		x += img.get_width() + 12
	sheet.save_png(OS.get_user_data_dir() + "/sheet.png")
	print("ok")
	quit()
