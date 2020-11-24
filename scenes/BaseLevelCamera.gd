extends Camera2D


var drag_offset = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var move_offset = drag_offset * delta * 10
	drag_offset -= move_offset
	position += move_offset


# handle input that wasn't catcher by ui etc.
func _input(event):
	if Input.is_action_just_pressed("zoom_in"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(0.9, position)
	
	if Input.is_action_just_pressed("zoom_out"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(1.1, position)

func _unhandled_input(event):
	if Input.is_action_pressed("camera_drag") and event is InputEventMouseMotion:
		var relative = (event as InputEventMouseMotion).relative
		drag_offset -= relative * zoom


# zoom in/out with the center at a certain point (e.g. mouse position)
func zoom_at_point(zoom_change, point):
	if (zoom.x >= 1 or zoom_change >= 1) and (zoom.x <= 100 or zoom_change <= 1):
		var c0 = global_position # camera position
		var v0 = get_viewport().size # vieport size
		var c1 # next camera position
		var z0 = zoom # current zoom value
		var z1 = z0 * zoom_change # next zoom value

		c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
		zoom = z1
		global_position = c1
