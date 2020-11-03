extends Node2D

const START_RADIUS = 100
const START_ANGULAR_SPEED = 0.5 * PI
const SHOOT_VELOCITY = 400
var start_angle: float

onready var moon = $StartPlanet/Moon


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	start_angle = randf() * 2 * PI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moon.mode == RigidBody2D.MODE_STATIC:
		start_angle += START_ANGULAR_SPEED * delta
		moon.position = Vector2(START_RADIUS, 0).rotated(start_angle)


func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot") and moon.mode == RigidBody2D.MODE_STATIC:
		print("shoot")
		var direction = moon.position.normalized().rotated(PI / 2)
		
		moon.linear_velocity = direction * SHOOT_VELOCITY
		moon.mode = RigidBody2D.MODE_RIGID
		
		moon.find_node("Camera2D").current = true
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
