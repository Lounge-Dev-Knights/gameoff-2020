extends CanvasLayer


onready var stars = $stars

var num_stars: int = 0 setget _set_num_stars

onready var tween = $Tween


func collect_star(star: Node2D, index: int = 0) -> void:
	var pos = star.get_global_transform_with_canvas().get_origin()
	star.get_parent().remove_child(star)
	
	star.position = pos
	add_child(star)
	var star_outline: TextureRect = stars.get_child(index)
	var destination = star_outline.get_global_transform_with_canvas().get_origin() + star_outline.rect_size / 2.0
	
	tween.interpolate_property(star, "position", pos, destination, 2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func render_stars():
	for child in stars.get_children():
		child.queue_free()
		
	for i in range(num_stars):
		var star = TextureRect.new()
		star.texture = preload("res://scenes/objects/star_outline.svg")
		stars.add_child(star)


func _set_num_stars(new_value):
	num_stars = new_value
	render_stars()
	
