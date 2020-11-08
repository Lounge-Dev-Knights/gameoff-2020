extends Node2D


onready var moon = $Moon
onready var camera = $Camera2D
onready var moon_sprite = $Moon/planet
onready var moon_particles = $Moon/ParticleTrail
onready var moon_explosion = $Moon/Explosion
onready var timer = $CameraFixedTimer
onready var black_hole = $BlackHole




# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera.offset.length() > 0.01:
		camera.offset = camera.offset.linear_interpolate(Vector2(), delta)
	
	
		
		
func _unhandled_input(event):
	
	
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func blackhole_hit(body):
	# play disappearing "animation"
	moon._moon_disappearing = true
	moon_particles.hide()
	
	# center camera to black hole to prevent camera bounce
	camera.target = black_hole
	
	$HUD/Success.show()


func planet_hit(body):
	moon.orbit($Planet)


func _on_Moon_started_moving() -> void:
	camera.target = $Moon


func _on_Moon_started_orbiting(center: Node2D) -> void:
	camera.target = center
