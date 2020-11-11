extends Node2D


onready var moon = $Moon
onready var black_hole = $BlackHole
onready var stars = $stars
onready var objects = $objects
onready var start_planet = $StartPlanet


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save_data() -> Dictionary:
	var data = {}
	data["black_hole"] = {
		"pos_x": black_hole.position.x,
		"pos_y": black_hole.position.y
	}
	data["start_planet"] = {
		"pos_x": start_planet.position.x,
		"pos_y": start_planet.position.y
	}
	
	data["objects"] = []
	
	for object in objects.get_children():
		
		var objectProperties = {
			"type": object.type,
			"pos_x": object.position.x,
			"pos_y": object.position.y,
		}
		if object.has_method("get_additional_properties"):
			objectProperties["additional_properties"] = object.get_additional_properties()

		data["objects"].append(objectProperties)

	data["stars"] = []
	for star in stars.get_children():
		data["stars"].append({
			"pos_x": star.position.x,
			"pos_y": star.position.y
		})


	return data


func load_data(level_data: Dictionary) -> void:
	# reset moon
	#moon.reset(start_planet)
	
	load_objects(level_data["objects"])
	load_stars(level_data["stars"])
	
	var hole_data = level_data["black_hole"]
	black_hole.position = Vector2(hole_data["pos_x"], hole_data["pos_y"])
	black_hole.get_node("AnimationPlayer").play("spawn")
	
	if level_data.has("start_planet"):
		var start_planet_data = level_data["start_planet"]
		start_planet.position = Vector2(start_planet_data["pos_x"], start_planet_data["pos_y"])
		start_planet.get_node("AnimationPlayer").play("spawn")
		# move moon to start planet
		#moon.orbit_center = start_planet.position

	


func add_object(type: String, pos: Vector2 = Vector2(0, 0), additional_properties: Dictionary = {}) -> Node2D:
	var instance

	match type:
		"Planet":
			instance = preload("res://scenes/objects/Planet.tscn").instance()
		"AsteroidSpawner":
			instance = preload("res://scenes/objects/AsteroidSpawner.tscn").instance()
		"Waypoint":
			instance = preload("res://scenes/objects/Waypoint.tscn").instance()
	for property in additional_properties.keys():
		instance[property] = additional_properties[property]
	instance.position = pos
	objects.add_child(instance)

	return instance
	
func add_asteroid_spawner(type: String,direction: int, pos: Vector2 = Vector2(0,0)) -> Node2D:
	var instance

	match type:
		"AsteroidSpawner":
			instance = preload("res://scenes/objects/AsteroidSpawner.tscn").instance()
	instance.direction = direction
	instance.position = pos
	objects.add_child(instance)
	return instance

func load_objects(objects_data: Array) -> void:
	var objects = $objects
	# remove existing
	for o in objects.get_children():
		o.queue_free()

	for object in objects_data:
		if object.has("additional_properties"):
			add_object(object["type"], Vector2(object["pos_x"], object["pos_y"]), object["additional_properties"])
		else:
			add_object(object["type"], Vector2(object["pos_x"], object["pos_y"]))

func add_star(pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var instance = preload("res://scenes/objects/Star.tscn").instance()
	instance.position = pos
	stars.add_child(instance)
	return instance



func load_stars(stars_data: Array) -> void:

	for s in stars.get_children():
		s.queue_free()

	for star in stars_data:
		add_star(Vector2(star["pos_x"], star["pos_y"]))
