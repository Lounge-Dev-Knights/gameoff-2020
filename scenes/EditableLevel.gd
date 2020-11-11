extends "res://scenes/BaseLevel.gd"


# OVERRIDE from BaseLevel
func add_star(pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var star = .add_star(pos)
	star.add_to_group("draggable")
	star.monitoring = false
	return star

# OVERRIDE from BaseLevel
func add_object(type: String, pos: Vector2 = Vector2(0, 0), additional_properties: Dictionary = {}) -> Node2D:
	var object = .add_object(type, pos, additional_properties)
	object.add_to_group("draggable")
	return object

# OVERRIDE from BaseLevel
func _ready():
	self.start_planet.add_to_group("draggable")
	self.moon.queue_free()
