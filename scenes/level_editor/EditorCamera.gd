extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# handle input that wasn't catcher by ui etc.
func _unhandled_input(event):
	if Input.is_action_just_pressed("zoom_in"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(0.9, position)
	if Input.is_action_just_pressed("zoom_out"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(1.1, position)


# zoom in/out with the center at a certain point (e.g. mouse position)
func zoom_at_point(zoom_change, point):
		var c0 = global_position # camera position
		var v0 = get_viewport().size # vieport size
		var c1 # next camera position
		var z0 = zoom # current zoom value
		var z1 = z0 * zoom_change # next zoom value

		c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
		zoom = z1
		global_position = c1
