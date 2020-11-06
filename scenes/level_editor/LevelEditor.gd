extends Node2D


onready var stars = $Level/stars
onready var objects = $Level/objects
onready var camera = $Level/Camera2D


# node that is beeing dragged
var drag_object: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if drag_object != null:
		drag_object.position = get_global_mouse_position()
		
	if Input.is_action_just_pressed("drag"):
		_start_drag()


func _unhandled_input(event):
	if Input.is_action_just_released("drag"):
		_stop_drag()
	if Input.is_action_just_pressed("zoom_in"):
		camera.zoom *= 0.9
	if Input.is_action_just_pressed("zoom_out"):
		camera.zoom *= 1.1


# check if cursor points to a node and start dragging
func _start_drag():
	var state = get_world_2d().direct_space_state
	var intersections = state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
	for intersection in intersections:
		drag_object = intersection["collider"]

func _stop_drag():
	drag_object = null


func _on_AddStar_pressed():
	var star = preload("res://scenes/Star.tscn").instance()
	add_child(star)
	
func _on_AddPlanet_pressed():
	var planet = preload("res://scenes/objects/Planet.tscn").instance()
	add_child(planet)
