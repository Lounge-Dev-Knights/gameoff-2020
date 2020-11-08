extends Node2D


const USER_LEVELS_PATH = "user://levels/"



onready var camera = $Camera2D
onready var level = $EditableLevel



var level_path: String

# node that is beeing dragged
var drag_object: Node2D
var selected_objects: Array = []



# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = Directory.new()
	if dir.file_exists(level_path):
		load_level(level_path)
		
	level.get_node("BlackHole").add_to_group("draggable")


func _physics_process(delta):
	if drag_object != null:
		drag_object.position = get_global_mouse_position()
		
	if Input.is_action_just_pressed("drag"):
		_start_drag()


func _unhandled_input(event):
	if Input.is_action_just_released("drag"):
		_stop_drag()


# check if cursor points to a node and start dragging
func _start_drag():
	var state = get_world_2d().direct_space_state
	var intersections = state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
	for intersection in intersections:
		var collider: Node2D = intersection["collider"]
		if collider.is_in_group("draggable"):
			drag_object = collider


func _stop_drag():
	drag_object = null
	save()



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
		print("Saved " + level_path)
		file.store_string(to_json(data))
		
		var preview_path = level_path.substr(0, level_path.length() - ".json".length()) + ".png"
		var preview_image = level.get_viewport().get_texture().get_data()
		var size = min(preview_image.get_width(), preview_image.get_height())
		preview_image.crop(size, size)
		preview_image.resize(128, 128)
		print("save image")
		preview_image.save_png(preview_path)
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



func _on_BackToMenu_pressed():
	SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
