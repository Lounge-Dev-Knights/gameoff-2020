extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize shader color
	material.set_shader_param("base_color", randf())
	
	# randomize shader texture
	material.set_shader_param("random_modifier", randf())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
