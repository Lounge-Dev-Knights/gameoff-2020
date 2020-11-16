extends Node2D


const USER_LEVELS_PATH = "user://levels/"



onready var camera = $Camera2D
onready var level = $EditableLevel



var level_path: String

# node that is beeing dragged
var drag_object: Node2D
var drag_origin: Vector2
var selected_objects: Array = []

var context_object: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = Directory.new()
	if dir.file_exists(level_path):
		load_level(level_path)
		
	level.get_node("BlackHole").add_to_group("draggable")
	

func _physics_process(delta):
	if drag_object != null:
		drag_object.position = get_global_mouse_position()
		
	


func _unhandled_input(event):
	if Input.is_action_just_pressed("drag"):
		_start_drag()
		
	if Input.is_action_just_released("drag"):
		_stop_drag()
		
	if Input.is_action_just_pressed("context"):
		_show_context()
	

# check if cursor points to a node and start dragging
func _show_context():	
	var state = get_world_2d().direct_space_state
	
	var intersections = state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
	for intersection in intersections:
		var collider: Node2D = intersection["collider"]
		# check if is draggable and not black hole
		if collider.is_in_group("draggable") and "type" in collider:
			context_object = collider
			$CanvasLayer/PopupMenu.popup_centered()
			$CanvasLayer/PopupMenu.rect_position = get_viewport().get_mouse_position()


# check if cursor points to a node and start dragging
func _start_drag():
	drag_origin = get_global_mouse_position()
	
	var state = get_world_2d().direct_space_state
	
	var intersections = state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
	for intersection in intersections:
		var collider: Node2D = intersection["collider"]
		if collider.is_in_group("draggable"):
			drag_object = collider


func _stop_drag():
	if (drag_origin.distance_to(get_global_mouse_position()) < 5.0):
		if drag_object != null:
			select([drag_object])
			print(drag_object)
		else:
			print("no select")
			select([])
	
	drag_object = null
	save()


func select(objects: Array):
	if objects.size() == 1 and selected_objects.size() == 1 and objects[0] == selected_objects[0]:
		objects = []
	
	for s in selected_objects:
		s.modulate = Color(1.0, 1.0, 1.0, 1.0)
	selected_objects = []
	
	for o in objects:
		selected_objects.append(o)
		o.modulate = Color(10.0, 10.0, 10.0, 10.0)


# saves the current level in the user directory as a json file
# Filename is user://levels/{level_name}.json
func save():
	var data = level.save_data()
	
	var dir = Directory.new()
	if not dir.dir_exists(USER_LEVELS_PATH):
		dir.make_dir_recursive(USER_LEVELS_PATH)
	
	var file = File.new()
	var err = file.open(level_path, File.WRITE)
	if err == OK:
			
		var preview_path = level_path.substr(0, level_path.length() - ".json".length()) + ".png"
		var preview_image = level.get_viewport().get_texture().get_data()
		var size = min(preview_image.get_width(), preview_image.get_height())
		var rect = Rect2((preview_image.get_width() - size) / 2, (preview_image.get_height() - size) / 2,
				size, size)
		preview_image.flip_y()
		preview_image.blit_rect(preview_image, rect, Vector2())
		preview_image.crop(size, size)
		preview_image.resize(128, 128)

		# save image to base64
		print("save image")
		# save as png before encoding to base64 to save bytes
		var buffer = preview_image.save_png_to_buffer()	
		data["preview_image"] = Marshalls.variant_to_base64(buffer, true)

		print("Saved " + level_path)
		file.store_string(to_json(data))
	else:
		print("Saving %s failed with code %d" % [level_path, err])
	file.close()


func load_level(path: String):
	var file = File.new()
	file.open(path, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	
	level.load_data(data)



func _on_AddStar_pressed():
	var star = level.add_star(camera.position)


func _on_AddPlanet_pressed():
	var planet = level.add_object("Planet", camera.position)


func _on_AddWaypoint_pressed():
	var planet = level.add_object("Waypoint", camera.position)


func _on_BackToMenu_pressed():
	SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")


func _on_PopupMenu_mouse_exited():
	$CanvasLayer/PopupMenu.hide()


func _on_PopupMenu_id_pressed(id):
	if id == 0:
		context_object.queue_free()
		context_object = null



func _on_AddAsteroidSpawnerUP_pressed():
	var add_prop ={
		"direction": 0
	}
	var asteroidSpawnerUp = level.add_object("AsteroidSpawner", camera.position, add_prop)
	

func _on_AddAsteroidSpawnerDOWN_pressed():
	var add_prop ={
		"direction": 1
	}
	var asteroidSpawnerUp = level.add_object("AsteroidSpawner", camera.position, add_prop)

func _on_AddAsteroidSpawnerLEFT_pressed():
	var add_prop ={
		"direction": 2
	}
	var asteroidSpawnerUp = level.add_object("AsteroidSpawner", camera.position, add_prop)

func _on_AddAsteroidSpawnerRIGHT_pressed():
	var add_prop ={
		"direction": 3
	}
	var asteroidSpawnerUp = level.add_object("AsteroidSpawner", camera.position, add_prop)



func _on_AddTinyPlanet_pressed():
	var planet = level.add_object("TinyPlanet", camera.position)


func _on_AddMediumPlanet_pressed():
	var planet = level.add_object("MediumPlanet", camera.position)


func _on_AddLargePlanet_pressed():
	var planet = level.add_object("LargePlanet", camera.position)


func _on_AddGiantPlanet_pressed():
	var planet = level.add_object("GiantPlanet", camera.position)


func _on_button_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")


func _on_button_pressed():
	SoundEngine.play_sound("MenuButtonSound")

