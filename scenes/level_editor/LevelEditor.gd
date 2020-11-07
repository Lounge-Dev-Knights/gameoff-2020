extends Node2D


const USER_LEVELS_PATH = "user://levels/"



onready var camera = $Camera2D
onready var level = $BaseLevel

onready var level_name = $CanvasLayer/PanelContainer/VBoxContainer/VBoxContainer/LevelName


# node that is beeing dragged
var drag_object: Node2D
var selected_objects: Array = []


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
		
	if Input.is_action_just_pressed("zoom_in"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(0.9, position)
	if Input.is_action_just_pressed("zoom_out"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(1.1, position)


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


func zoom_at_point(zoom_change, point):
		var c0 = camera.global_position # camera position
		var v0 = camera.get_viewport().size # vieport size
		var c1 # next camera position
		var z0 = camera.zoom # current zoom value
		var z1 = z0 * zoom_change # next zoom value

		c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
		camera.zoom = z1
		camera.global_position = c1



func save():
	var data = level.save_data()
	data["level_name"] = level_name.text
	
	var dir = Directory.new()
	if not dir.dir_exists(USER_LEVELS_PATH):
		dir.make_dir_recursive(USER_LEVELS_PATH)
	
	var file = File.new()
	var err = file.open(USER_LEVELS_PATH + level_name.text + ".json", File.WRITE)
	print(err)
	file.store_string(to_json(data))
	file.close()



func _on_AddStar_pressed():
	var star = level.add_star(camera.position)
	star.monitoring = false
	star.add_to_group("draggable")


func _on_AddPlanet_pressed():
	var planet = level.add_object("Planet", camera.position)
	planet.add_to_group("draggable")



func _on_Export_pressed():
	pass


func _on_LevelName_text_changed(new_text):
	var old_name = level_name.text
	
	var dir = Directory.new()
	dir.rename(USER_LEVELS_PATH + old_name + ".json", USER_LEVELS_PATH + new_text + ".json")
	print("file renamed")


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
	level_name.text = data["level_name"]


func _on_FileDialog_about_to_show():
	get_tree().paused = true


func _on_FileDialog_popup_hide():
	get_tree().paused = false
