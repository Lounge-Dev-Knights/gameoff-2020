extends RigidBody2D


signal started_moving
signal started_orbiting


const START_RADIUS = 100
const START_ANGULAR_SPEED = 1 * PI
const MIN_SHOOT_VELOCITY = 200
const MAX_SHOOT_VELOCITY = 10000


onready var moon_sprite = $planet

var start_angle: float


var orbit_center: Node2D
var orbit_radius: float = START_RADIUS
var orbit_speed: float = START_ANGULAR_SPEED

var enabled = true


var _start_charging: int
var _moon_disappearing = false
var _moon_stopped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start_angle = randf() * 2 * PI

func _process(delta: float) -> void:
	if mode == RigidBody2D.MODE_STATIC:
		start_angle += orbit_speed * delta
		
		position = Vector2(orbit_radius, 0).rotated(start_angle)
		
		if orbit_center != null:
			position += orbit_center.position
	
	if _start_charging != 0:
		modulate.g -= 20 * delta
		modulate.b -= 20 * delta
	
	# if moon is disappearing, scale moon down linearly
	if _moon_disappearing:
		moon_sprite.scale = moon_sprite.scale / 1.05


func _unhandled_input(event: InputEvent) -> void:
	if enabled and Input.is_action_just_pressed("shoot") and mode == RigidBody2D.MODE_STATIC:
		_start_charging = OS.get_ticks_msec()
		Engine.time_scale = 0.1
		
		emit_signal("started_moving")
		
	if enabled and _start_charging != 0 and Input.is_action_just_released("shoot") and mode == RigidBody2D.MODE_STATIC and not _moon_stopped:
		
		# set moon to not be slow anymore after charge button is released
		Engine.time_scale = 1.0
		
		var orbit_position = position
		if orbit_center != null:
			orbit_position -= orbit_center.position
		
		var direction = orbit_position.normalized().rotated(PI / 2)
		
		var _duration_pressed = (OS.get_ticks_msec() - _start_charging) / 1000.0
		# velocity is multiplied by duration key is pressed, to "charge up" shot
		var charged_velocity = MIN_SHOOT_VELOCITY * (_duration_pressed / 20)
		
		# velocity is clamped to not let moon fly too fast nor too slow
		charged_velocity = clamp(charged_velocity, MIN_SHOOT_VELOCITY, MAX_SHOOT_VELOCITY)
		
		# multiply direction vector with charged velocity to get the ball flying
		linear_velocity = direction * charged_velocity

		mode = RigidBody2D.MODE_RIGID
		
		# reset pressed duration
		_start_charging = 0


func explode() -> void:
	moon_sprite.hide()
	$ParticleTrail.hide()
	# change color to white to not influence explosion color
	modulate = Color(1,1,1,1)
	
	$Explosion.emitting = true
	linear_velocity = Vector2(0,0)
	angular_velocity = 0
	sleeping = true


func orbit(center: Node2D, radius: float = 100.0) -> void:
	mode = RigidBody2D.MODE_STATIC
	orbit_center = center
	orbit_radius = radius
	emit_signal("started_orbiting", center)
	
