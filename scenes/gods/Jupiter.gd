extends "res://scenes/gods/God.gd"

onready var countdown = $CanvasLayer/CountdownContainer/Countdown
onready var countdown_container = $CanvasLayer/CountdownContainer


const EFFECT_TIME = 5.0
const SLOW_MOTION_SCALE = 1.0

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


var bolts_left: int = 3


func _ready():
	cursor = preload("res://scenes/gods/bolt.png")

func _process(delta):
	if timer != null and  timer.time_left > 0:
		countdown.value = timer.time_left

	$CPUParticles2D.position = get_global_mouse_position()


func _physics_process(delta):
	if drag_object != null:
		var drag_offset = get_global_mouse_position() - drag_origin
		drag_object.position = drag_origin + drag_offset.clamped(DRAG_DISTANCE)


func start_effect():
	.start_effect()
	if not enabled:
		return
	effect_active = true
	bolts_left = 3
	
	countdown_container.show()
	effects_left -= 1
	Engine.time_scale = SLOW_MOTION_SCALE
	timer = get_tree().create_timer(EFFECT_TIME * SLOW_MOTION_SCALE)
	timer.connect("timeout", self, "_on_Timer_timeout")
	countdown.max_value = timer.time_left


func stop_effect():
	.stop_effect()
	if effect_active:
		effect_active = false
		
		hovered_object = null
		drags_left = 1
		
		countdown_container.hide()
		Engine.time_scale = 1.0


func shoot_bolt(location: Vector2):
	get_tree().call_group("cameras", "add_trauma", 0.5)
	
	var particles = $CPUParticles2D.duplicate()
	particles.emitting = true
	add_child(particles)
	get_tree().call_group("moon", "suffer_explosion", get_global_mouse_position())
	
	bolts_left -= 1
	
	if bolts_left <= 0:
		stop_effect()


func _on_Timer_timeout():
	stop_effect()


func _on_Portrait_pressed():
	
	if effects_left > 0:
		start_effect()


func _unhandled_input(event):
	if event is InputEventMouseButton and effect_active:
		if event.is_pressed():
			shoot_bolt(get_global_mouse_position())


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
