extends Node2D

const START_RADIUS = 100
const START_ANGULAR_SPEED = 1 * PI
const MIN_SHOOT_VELOCITY = 200
const MAX_SHOOT_VELOCITY = 10000
var start_angle: float

onready var moon = $Moon
onready var camera = $Camera2D
onready var moon_sprite = $Moon/planet
onready var moon_particles = $Moon/ParticleTrail
onready var timer = $CameraFixedTimer
onready var black_hole = $BlackHole

var _duration_pressed = 0
var _moon_slowed = false
var _moon_disappearing = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	moon.scale = Vector2(1,1)
	start_angle = randf() * 2 * PI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera.offset.length() > 0.01:
		camera.offset = camera.offset.linear_interpolate(Vector2(), delta)
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
	
	# if moon is disappearing, scale moon down linearly
	if _moon_disappearing:
		moon_sprite.scale = moon_sprite.scale / 1.05
		
		
func _unhandled_input(event):
	
	if Input.is_action_just_released("shoot") and moon.mode == RigidBody2D.MODE_STATIC:
		print("shoot")
		

		# set moon to not be slow anymore after charge button is released
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
		# get_tree().reload_current_scene()
		var file = File.new()
		file.open("res://scenes/levels/test_level.json", File.READ)
		var level_data = parse_json(file.get_as_text())
		load_level(level_data)



func load_level(level_data: Dictionary) -> void:
	load_objects(level_data["objects"])
	# load_stars(level_data["stars"])
	
	var hole_data = level_data["black_hole"]
	black_hole.position.x = hole_data["pos_x"]
	black_hole.position.y = hole_data["pos_y"]


func load_objects(objects_data: Array) -> void:
	var objects = $objects
	
	# remove existing
	for o in objects.get_children():
		o.queue_free()
	
	for object in objects_data:
		match object["type"]:
			"Planet":
				var p = preload("res://scenes/objects/Planet.tscn").instance()
				p.position.x = object["pos_x"]
				p.position.y = object["pos_y"]
				objects.add_child(p)
	


func load_stars(stars_data: Array) -> void:
	var stars = $stars
	
	for s in stars.get_children():
		s.queue_free()
	
	for star in stars_data:
		# instance star
		# add to stars
		pass


func blackhole_hit(body):
	# play disappearing "animation"
	_moon_disappearing = true
	moon_particles.hide()
	
	# senter camera to black hole to prevent camera bounce
	camera.target = black_hole
	
	$HUD/Success.show()
