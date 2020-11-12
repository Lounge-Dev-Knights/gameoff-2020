extends Area2D


const type = "Waypoint"


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize shader color
	#$texture.material.set_shader_param("base_color", randf())
	
	# randomize shader texture
	#$texture.material.set_shader_param("random_modifier", randf())
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MoonCatcher_body_entered(body):
	if body.has_method("orbit"):
		body.orbit(self, 200)
