extends Node2D

const START_RADIUS = 100
const START_ANGULAR_SPEED = 1 * PI
const MIN_SHOOT_VELOCITY = 200
const MAX_SHOOT_VELOCITY = 10000
var start_angle: float

onready var moon = $StartPlanet/Moon
onready var camera = $Camera2D

var _duration_pressed = 0
var _moon_slowed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	start_angle = randf() * 2 * PI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moon.mode == RigidBody2D.MODE_STATIC:
		var speed
		# slow mo effect before shooting
		if _moon_slowed:
			speed = START_ANGULAR_SPEED / 10
		else:
			speed = START_ANGULAR_SPEED
		
		start_angle += speed * delta
		
		moon.position = Vector2(START_RADIUS, 0).rotated(start_angle)

	if Input.is_action_pressed("shoot") and moon.mode == RigidBody2D.MODE_STATIC:
		_duration_pressed += 1
		
		moon.position = Vector2(START_RADIUS, 0).rotated(start_angle)
		
		# slow down moon in place while "loading up" shot.
		moon.modulate = Color(1, 1-0.01*_duration_pressed, 1-0.01*_duration_pressed, 1)
		_moon_slowed = true
		
		
func _unhandled_input(event):
	
	if Input.is_action_just_released("shoot") and moon.mode == RigidBody2D.MODE_STATIC:
		print("shoot")

		
		# set moon to not be slow anymore
		_moon_slowed = false
		
		var direction = moon.position.normalized().rotated(PI / 2)
		
		# velocity is multiplied by duration key is pressed, to "charge up" shot
		var charged_velocity = MIN_SHOOT_VELOCITY * (_duration_pressed / 20)
		# velocity is clamped to not let moon fly too fast nor too slow
		charged_velocity = clamp(charged_velocity, MIN_SHOOT_VELOCITY, MAX_SHOOT_VELOCITY)
		
		# multiply direction vector with charged velocity to get the ball flying
		moon.linear_velocity = direction * charged_velocity

	
		
		moon.mode = RigidBody2D.MODE_RIGID
		
				# reset pressed duration
		_duration_pressed = 0
		

		
		camera.target = moon
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
