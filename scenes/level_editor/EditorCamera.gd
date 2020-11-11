extends Camera2D

var fixed_toggle_point:Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	 # This happens once 'camera_drag' is pressed
	if Input.is_action_just_pressed('camera_drag'):
		var ref = get_viewport().get_mouse_position()
		fixed_toggle_point = ref
	# This happens while 'camera_drag' is pressed
	if Input.is_action_pressed('camera_drag'):
		drag_camera()

# handle input that wasn't catcher by ui etc.
func _unhandled_input(event):
	if Input.is_action_just_pressed("zoom_in"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(0.9, position)
	if Input.is_action_just_pressed("zoom_out"):
		var position = (event as InputEventMouseButton).position
		zoom_at_point(1.1, position)

# drags the camera around
func drag_camera():
	var ref = get_viewport().get_mouse_position()
	global_position.x += (ref.x - fixed_toggle_point.x) / 20
	global_position.y += (ref.y - fixed_toggle_point.y) / 20

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
