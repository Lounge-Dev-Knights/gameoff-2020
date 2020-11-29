extends Node2D

var effect_active = false
var effects_left
var timer: SceneTreeTimer
var enabled: bool = false
var cursor: StreamTexture = null


func _ready():
	reset()


func _exit_tree():
	stop_effect()


func reset():
	enabled = false
	effects_left = 1
	stop_effect()
	if timer != null:
		timer.disconnect("timeout", self, "_on_Timer_timeout")
		timer = null


func start_effect():
	if cursor != null:
		Input.set_custom_mouse_cursor(cursor, 0, cursor.get_size() / 2)


func stop_effect():
	Input.set_custom_mouse_cursor(null)


func disable():
	stop_effect()
	enabled = false
	
func enable():
	enabled = true

func _unhandled_input(event):
	pass
