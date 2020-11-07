extends Node2D


const USER_LEVELS_PATH = "user://levels/"



onready var camera = $Camera2D
onready var level = $EditableLevel

onready var level_name_input = $CanvasLayer/PanelContainer/VBoxContainer/VBoxContainer/LevelName


# node that is beeing dragged
var drag_object: Node2D
var selected_objects: Array = []

var level_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
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
	data["level_name"] = level_name
	
	var dir = Directory.new()
	if not dir.dir_exists(USER_LEVELS_PATH):
		dir.make_dir_recursive(USER_LEVELS_PATH)
	
	
	var file_name = USER_LEVELS_PATH + level_name + ".json"
	
	var file = File.new()
	var err = file.open(file_name, File.WRITE)
	if err == OK:
		print("Saved " + file_name)
		file.store_string(to_json(data))
	else:
		print("Saving %s failed with code %d" % [file_name, err])
	file.close()
	




func _on_AddStar_pressed():
	var star = level.add_star(camera.position)


func _on_AddPlanet_pressed():
	var planet = level.add_object("Planet", camera.position)


func _on_Export_pressed():
	pass



func _on_LevelName_text_changed(new_text):
	
	var dir = Directory.new()
	var from = USER_LEVELS_PATH + level_name + ".json"
	var to = USER_LEVELS_PATH + new_text + ".json"
	
	if dir.file_exists(to):
		print("File %s already exists" % to)
	elif dir.file_exists(from):
		var error = dir.rename(from, to)
		if error == OK:
			print("Renamed %s -> %s" % [from, to])
			level_name = new_text
		else:
			print("Error renaming the file: " + str(error))
	else:
		level_name = new_text
		save()
	
	


func _on_Save_pressed():
	pass # Replace with function body.


func _on_Open_pressed():
	$CanvasLayer/FileDialog.popup_centered()
	var path = yield($CanvasLayer/FileDialog, "file_selected")
	var file = File.new()
	file.open(path, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	
	level.load_data(data)
	level_name = data["level_name"]
	level_name_input.text = data["level_name"]


func _on_FileDialog_about_to_show():
	get_tree().paused = true


func _on_FileDialog_popup_hide():
	get_tree().paused = false
