extends Area2D

var type = "Planet"

const planet_images = [
	preload("res://scenes/objects/planet_images/planet_1.png"),
	preload("res://scenes/objects/planet_images/planet_2.png"),
	preload("res://scenes/objects/planet_images/planet_3.png"),
	preload("res://scenes/objects/planet_images/planet_4.png"),
	preload("res://scenes/objects/planet_images/planet_5.png"),
	preload("res://scenes/objects/planet_images/planet_6.png"),
	preload("res://scenes/objects/planet_images/planet_7.png"),
	preload("res://scenes/objects/planet_images/planet_8.png")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	$planet.texture = planet_images[randi() % planet_images.size()]
	$planet.scale *= $CollisionShape2D.shape.radius / 300


func _on_Planet_body_entered(body):
	if body.has_method("bounce") and body.shield.visible == true:
		body.bounce(position)
	elif body.has_method("explode"):
		body.explode()
