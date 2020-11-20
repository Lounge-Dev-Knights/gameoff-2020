extends RigidBody2D


signal started_moving
signal started_orbiting
signal moving
signal reset
signal exploded
signal stationary
signal wurmhole


const START_RADIUS = 100
const START_ANGULAR_SPEED = 1 * PI
const MIN_SHOOT_VELOCITY = 200
const MAX_SHOOT_VELOCITY = 2000

onready var moon_sprite = $planet

var start_angle: float


var orbit_center: Node2D
var orbit_radius: float = START_RADIUS
var orbit_speed: float = START_ANGULAR_SPEED

var orbit_target: Vector2
var orbit_current_radius: float

var orbiting = true
var enabled = true


var _start_charging: int
var _moon_disappearing = false
var _moon_stopped = false
var _moon_destroyed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	start_angle = randf() * 2 * PI
	get_tree().call_group("moon_gods", "hide")


func _process(delta: float) -> void:
	
	if not _moon_destroyed:
		if mode == RigidBody2D.MODE_KINEMATIC:
			
		
			get_tree().call_group("moon_gods", "show")
			start_angle += orbit_speed * delta
			rotation = start_angle + PI / 2

			orbit_current_radius = lerp(orbit_current_radius, orbit_radius, delta * 5)
			orbit_speed = lerp(orbit_speed, sign(orbit_speed) * START_ANGULAR_SPEED, delta)

			orbit_target = Vector2(orbit_current_radius, 0).rotated(start_angle)


			if orbit_center != null:
				orbit_target += orbit_center.position

			position = position.linear_interpolate(orbit_target, 0.5)

		if _start_charging != 0:
			modulate.g -= 20 * delta
			modulate.b -= 20 * delta

		# if moon is disappearing, scale moon down linearly
		if _moon_disappearing:
			moon_sprite.scale = moon_sprite.scale / 1.05


func _unhandled_input(event: InputEvent) -> void:
	var _duration_pressed = (OS.get_ticks_msec() - _start_charging) / 1000.0
	if enabled and Input.is_action_just_pressed("shoot") and mode == RigidBody2D.MODE_KINEMATIC:
		_start_charging = OS.get_ticks_msec()
		Engine.time_scale = 0.1

		emit_signal("started_moving")

	if enabled and _start_charging != 0 and Input.is_action_just_released("shoot") and mode == RigidBody2D.MODE_KINEMATIC and not _moon_stopped:

		# set moon to not be slow anymore after charge button is released
		Engine.time_scale = 1.0

		emit_signal("moving")
		
		orbiting = false

		var orbit_position = position
		if orbit_center != null:
			orbit_position -= orbit_center.position

		var direction = orbit_position.normalized().rotated(PI / 2)

		#var _duration_pressed = (OS.get_ticks_msec() - _start_charging) / 1000.0
		
		# velocity is multiplied by duration key is pressed, to "charge up" shot
		var charged_velocity = MIN_SHOOT_VELOCITY * (1 + 2*_duration_pressed)

		# velocity is clamped to not let moon fly too fast nor too slow
		charged_velocity = clamp(charged_velocity, MIN_SHOOT_VELOCITY, MAX_SHOOT_VELOCITY) * sign(orbit_speed)


		# multiply direction vector with charged velocity to get the ball flying
		linear_velocity = direction * charged_velocity

		set_deferred("mode", RigidBody2D.MODE_RIGID)

		# reset pressed duration
		_start_charging = 0
		
		modulate = Color.white
	
	var _duration_charging = (OS.get_ticks_msec()-_start_charging) / 1000.0

	if Input. is_action_pressed("shoot"):
		$MoonCharging.adjust(_duration_charging)
	else: 
		$MoonCharging.adjust(00)


func reset(start_planet: Node2D = null):
	
	_moon_destroyed = false
	_moon_stopped = false
	orbiting = true
	orbit_center = null
	position = start_planet.position if start_planet != null else Vector2()
	orbit(start_planet)
	orbit_speed = START_ANGULAR_SPEED
	
	$AnimationPlayer.play("spawn")
	
	SoundEngine.play_sound("Reset")
	emit_signal("reset")
	emit_signal("stationary")
	
	# workaround: wait a moment, until physics body is moved to not trigger black hole again
	yield(get_tree().create_timer(0.1), "timeout")
	$CollisionShape2D.set_deferred("disabled", false)
	enabled = true


func explode() -> void:
	get_tree().call_group("cameras", "add_trauma", 1.0)  #Screen shake
	$AnimationPlayer.play("explode")
	SoundEngine.play_sound("MoonImpact")
	emit_signal("exploded")
	emit_signal("stationary")
	
	set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
	_moon_destroyed = true
	$CollisionShape2D.set_deferred("disabled", true)
	enabled = false


func orbit(center: Node2D, radius: float = 220.0) -> void:
	if center != orbit_center: 
		
		set_deferred("mode", RigidBody2D.MODE_KINEMATIC)
		if center != null:
			start_angle = (position - center.position).angle()
			
			var distance = (position - center.position).normalized()
			var velocity_norm = linear_velocity / 100
			
			orbit_speed = (velocity_norm).dot(distance.rotated(PI / 2))
			print("start orbiting " + center.name + " at " + str(radius))
		
		orbit_center = center
		orbit_radius = radius
		
		orbiting = true
		emit_signal("started_orbiting", center)


func disappear(in_node: Node2D) -> void:
	print("disappear")
	_moon_stopped = true
	enabled = false
	orbit(in_node, 0)
	get_tree().call_group("moon_gods", "hide")
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("disappear")
	emit_signal("wurmhole")
	SoundEngine.play_sound("Wurmhole")

func _on_Moon_started_moving():
	$MoonCharging.play()


func _on_Moon_moving():
	$MoonCharging.stop()
	$MoonFlying.play()
	SoundEngine.play_sound("MoonThrowing")
	get_tree().call_group("moon_gods", "hide")


func _on_Moon_reset():
	yield(get_tree().create_timer(0.2), "timeout")
	$MoonFlying.stop()


func _on_Moon_exploded():
	yield(get_tree().create_timer(0.2), "timeout")
	$MoonFlying.stop()


func _on_Moon_wurmhole():
	yield(get_tree().create_timer(0.5), "timeout")
	$MoonFlying.stop()

