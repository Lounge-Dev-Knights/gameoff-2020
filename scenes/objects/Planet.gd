extends Area2D

const type = "Planet"


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize shader color
	$texture.material.set_shader_param("base_color", randf())
	
	# randomize shader texture
	$texture.material.set_shader_param("random_modifier", randf())


func _on_Planet_body_entered(body):
	if body.has_method("explode"):
		body.explode()
