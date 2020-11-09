extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ESCButtonToggle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused == false:
			get_tree().paused = true
		else:
			get_tree().paused = false
	pass
#	 Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
