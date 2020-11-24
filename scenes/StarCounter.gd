extends CanvasLayer


onready var tween = $Tween
onready var stars = $stars


var num_stars: int = 0 setget _set_num_stars


# move the star from the level to the counter
func collect_star(star: Node2D, index: int = 0) -> void:
	
	# reparent the star to the counter and set the correct position
	var pos = star.get_global_transform_with_canvas().get_origin()
	star.get_parent().call_deferred("remove_child", star)
	star.position = pos
	call_deferred("add_child", star)
	
	# get target position and start animation
	var star_outline: TextureRect = stars.get_child(index)
	var destination = star_outline.get_global_transform_with_canvas().get_origin() + star_outline.rect_size / 2.0
	tween.interpolate_property(star, "position", pos, destination, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	while true:
		# wait for the correct interpolation to finish
		var object = yield(tween, "tween_completed")
		
		if object[0] == star:
			# change the texture of the star in the counter
			if star_outline != null:
				star_outline.texture = preload("res://scenes/objects/star.svg")
			
			# remove the star after animation
			star.queue_free()
			return


	# add the list of stars available to collect in this level
func render_stars():
	# remove old stars
	for child in stars.get_children():
		child.queue_free()
	
	for _i in range(num_stars):
		var star = TextureRect.new()
		star.texture = preload("res://scenes/objects/star_outline.svg")
		stars.add_child(star)


func _set_num_stars(new_value):
	num_stars = new_value
	render_stars()
	
