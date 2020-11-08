extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize shader color
	$planet.material.set_shader_param("base_color", randf())
	
	# randomize shader texture
	$planet.material.set_shader_param("random_modifier", randf())


func _on_Planet_body_entered(body):
	body.explode()
