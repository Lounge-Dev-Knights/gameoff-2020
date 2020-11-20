extends Node2D

const EFFECT_TIME = 5.0
const SLOW_MOTION_SCALE = 0.1

onready var countdown = $CanvasLayer/CountdownContainer/Countdown
onready var countdown_container = $CanvasLayer/CountdownContainer

var effect_active = false
var effects_left
var timer: SceneTreeTimer
var enabled: bool = false



# how far can an object be dragged
const DRAG_DISTANCE = 500
const MODULATE_COLOR = Color(0.503906, 0.503906, 0.503906)

# how many times can you drag
var drags_left: int = 1
# the currently hovered object
var hovered_object: Node2D = null
# the currently dragged object
var drag_object: Node2D = null
# origin of the currently dragged object
var drag_origin: Vector2


func _ready():
	reset()

func _process(delta):
	if timer != null and  timer.time_left > 0:
		countdown.value = timer.time_left

	$CPUParticles2D.position = get_global_mouse_position()


func _physics_process(delta):
	if drag_object != null:
		var drag_offset = get_global_mouse_position() - drag_origin
		drag_object.position = drag_origin + drag_offset.clamped(DRAG_DISTANCE)

func reset():
	enabled = false
	effects_left = 1
	stop_effect()
	if timer != null:
		timer.disconnect("timeout", self, "_on_Timer_timeout")
		timer = null


func start_effect():
	if not enabled:
		return
	effect_active = true
	
	for object in get_tree().get_nodes_in_group("objects"):
		object.connect("mouse_entered", self, "_on_object_mouse_entered", [object])
		object.connect("mouse_exited", self, "_on_object_mouse_exited", [object])
	
	countdown_container.show()
	effects_left -= 1
	Engine.time_scale = 0.1
	timer = get_tree().create_timer(EFFECT_TIME * SLOW_MOTION_SCALE)
	timer.connect("timeout", self, "_on_Timer_timeout")
	countdown.max_value = timer.time_left


func stop_effect():
	if effect_active:
		effect_active = false
		
		for object in get_tree().get_nodes_in_group("objects"):
			if object.is_connected("mouse_entered", self, "_on_object_mouse_entered"):
				object.disconnect("mouse_entered", self, "_on_object_mouse_entered")
				object.disconnect("mouse_exited", self, "_on_object_mouse_exited")
		
		hovered_object = null
		drags_left = 1
		
		countdown_container.hide()
		Engine.time_scale = 1.0


func disable():
	enabled = false
	
func enable():
	enabled = true


func _on_Timer_timeout():
	stop_effect()


func _on_Portrait_pressed():
	
	if effects_left > 0:
		start_effect()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and hovered_object != null and drags_left > 0:
			_start_drag(hovered_object)
		elif drag_object != null:
			_stop_drag()


func _start_drag(object):
	drags_left -= 1
	drag_object = object
	drag_origin = drag_object.position
	
func _stop_drag():
	
	drag_object = null
	
	$CPUParticles2D.emitting = true
	get_tree().call_group("cameras", "add_trauma", 0.3)
	stop_effect()


func _on_object_mouse_entered(object):
	print("entered")
	hovered_object = object


func _on_object_mouse_exited(object):
	hovered_object = null
