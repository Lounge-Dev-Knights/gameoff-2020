extends "res://scenes/BaseLevel.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# OVERRIDE from BaseLevel
func add_star(pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var star = .add_star(pos)
	star.add_to_group("draggable")
	star.monitoring = false
	return star

# OVERRIDE from BaseLevel
func add_object(type: String, pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var object = .add_object(type, pos)
	object.add_to_group("draggable")
	return object
