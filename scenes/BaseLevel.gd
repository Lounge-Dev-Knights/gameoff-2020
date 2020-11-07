extends Node2D


onready var moon = $Moon
onready var black_hole = $BlackHole
onready var stars = $stars
onready var objects = $objects


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save_data() -> Dictionary:
	var data = {}
	data["black_hole"] = {
		"pos_x": black_hole.position.x,
		"pos_y": black_hole.position.y
	}
	data["objects"] = []
	for object in objects.get_children():
		data["objects"].append({
			"type": object.type,
			"pos_x": object.position.x,
			"pos_y": object.position.y,
		})
	
	data["stars"] = []
	for star in stars.get_children():
		data["stars"].append({
			"pos_x": star.position.x,
			"pos_y": star.position.y
		})
	
	
	return data


func load_data(level_data: Dictionary) -> void:
	load_objects(level_data["objects"])
	load_stars(level_data["stars"])
	
	var hole_data = level_data["black_hole"]
	black_hole.position = Vector2(hole_data["pos_x"], hole_data["pos_y"])


func add_object(type: String, pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var instance
	
	match type:
		"Planet", _:
			instance = preload("res://scenes/objects/Planet.tscn").instance()
	
	instance.position = pos
	
	objects.add_child(instance)
	
	return instance


func load_objects(objects_data: Array) -> void:
	var objects = $objects
	
	# remove existing
	for o in objects.get_children():
		o.queue_free()
	
	for object in objects_data:
		add_object(object["type"], Vector2(object["pos_x"], object["pos_y"]))


func add_star(pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var instance = preload("res://scenes/Star.tscn").instance()
	instance.position = pos
	stars.add_child(instance)
	return instance



func load_stars(stars_data: Array) -> void:
	var stars = $stars
	
	for s in stars.get_children():
		s.queue_free()
	
	for star in stars_data:
		add_star(Vector2(star["pos_x"], star["pos_y"]))
