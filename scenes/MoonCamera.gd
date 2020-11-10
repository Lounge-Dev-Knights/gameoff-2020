extends Camera2D


export var max_offset : float = 80.0
export var max_roll : float = 20.0
export var trauma_reduction : float = 2

var target: Node2D

var base_seed: int = 0
var trauma : float = 0.0

var peek_offset = Vector2()
var peek_active = false

func _ready():
	randomize()
	
	base_seed = randi()
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if peek_active:
			peek_offset = (get_viewport().get_mouse_position() - get_viewport_rect().size / 2)
		else:
			peek_offset = Vector2()
			

# TODO: Add in some sort of rotation reset.
func _process(delta):  
	# follow target
	if target != null:
		position = position.linear_interpolate(target.position, delta * 5)
		
	# apply screen shake
	_process_shake(global_transform.origin, 0.0, delta)
	
	offset = offset.linear_interpolate(peek_offset, 0.1)
	
	
	
func _process_shake(center, angle, delta) -> void:
	if trauma > 0:
		var shake = pow(trauma, 2)
		var rotation_offset = angle + (max_roll * shake *  _get_noise(base_seed, OS.get_ticks_msec()))
		
		
		var offset_x = (max_offset * shake * _get_noise(base_seed + 1, OS.get_ticks_msec()))
		var offset_y = (max_offset * shake * _get_noise(base_seed + 2, OS.get_ticks_msec()))
		
		rotation_degrees = rotation_offset
		offset = Vector2(offset_x, offset_y)
		
		trauma -= trauma_reduction * delta
		
		trauma = clamp(trauma, 0.0, 1.0)
	else:
		offset = Vector2()
		rotation = 0
	
	
func _get_noise(noise_seed, time) -> float:
	var n = OpenSimplexNoise.new()
	
	n.seed = noise_seed
	n.octaves = 2
	n.period = 20.0
	n.persistence = 0.8
	
	return n.get_noise_1d(time)
	
	
func add_trauma(amount : float) -> void:
	trauma += amount
	trauma = clamp(trauma, 0.0, 1.0)
