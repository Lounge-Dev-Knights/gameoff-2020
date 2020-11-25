extends Node2D

var effect_active = false
var effects_left
var timer: SceneTreeTimer
var enabled: bool = false


func _ready():
	reset()
	

func reset():
	enabled = false
	effects_left = 1
	stop_effect()
	if timer != null:
		timer.disconnect("timeout", self, "_on_Timer_timeout")
		timer = null


func start_effect():
	pass

func stop_effect():
	pass


func disable():
	enabled = false
	
func enable():
	enabled = true

func _unhandled_input(event):
	pass
