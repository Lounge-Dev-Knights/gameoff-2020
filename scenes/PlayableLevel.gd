extends "res://scenes/BaseLevel.gd"


signal success
signal failure


onready var tween = $Tween
onready var camera = $Camera2D


var stars_collected := Array()
var tries := 0

var finished = false
var level_name = 'Level 1'
var level_path: String = ''
var next_level_path: String = ''
var god = 'Fortuna'

enum LevelState {
	LOCKED,
	UNLOCKED,
	COMPLETED
}

func load_god():
	var portrait
	var moon_god
	var inst
	match god:
		'Fortuna':
			portrait = load("res://scenes/gods/Fortuna.tscn")
			moon_god = load("res://scenes/gods/FortunaMoon.tscn")
		'Mars':
			portrait = load("res://scenes/gods/Mars.tscn")
			moon_god = load("res://scenes/gods/MarsMoon.tscn")

	
	add_child(portrait.instance())
	$Moon.add_child(moon_god.instance())


func _ready():
	load_god()

func _physics_process(delta):
	check_velocity_unchanged(delta)


func _unhandled_input(event):
	if tween.is_active() and Input.is_action_just_pressed("shoot"):
		# stop black hole tween and show start planet
		
		tween.remove_all()
		tween.emit_signal("tween_all_completed")
		camera.target = start_planet


func save_progress():
	# load progress first
	var progress_path = "user://progress.json"
	var file = File.new()
	var err = file.open(progress_path, File.READ)
	var progress = parse_json(file.get_as_text())
	file.close()
	
	if not progress:
		progress = Dictionary()
	if not progress.has(level_path):
		progress[level_path] = Dictionary()
	
	var level_progress = progress[level_path]
	
	level_progress["level_name"] = level_name
	
	# if finished, set stars and unlock next level
	if finished:
		level_progress["state"] = LevelState.COMPLETED
		if not progress.has(next_level_path):
			progress[next_level_path] = Dictionary()
		progress[next_level_path]["state"] = LevelState.UNLOCKED
		
		if level_progress.has("stars_collected"):
			for star in stars_collected:
				if not star in level_progress["stars_collected"]:
					level_progress["stars_collected"].append(star)
			
		else:
			level_progress["stars_collected"] = stars_collected
	
	# advance tries. This is not yet displayed anywhere
	if level_progress.has("tries"):
		level_progress["tries"] += 1
	else:
		level_progress["tries"] = 1
	tries = level_progress["tries"]
	
	
	# save progress file
	var save_file = File.new()
	save_file.open(progress_path, File.WRITE)
	save_file.store_string(to_json(progress))
	save_file.close()
	print(progress)


var star_count = 0
func load_data(level_data: Dictionary, reload: bool = false) -> void:
	moon.enabled = false
	moon.linear_velocity = Vector2()
	
	star_count = 0
	stars_collected = Array()
	
	.load_data(level_data)
	
	moon.position = start_planet.position
	
	if level_data.has("level_name"):
		level_name = level_data["level_name"]
	get_tree().call_group("gods", "reset")
	$StarCounter.num_stars = star_count
	
	$AnimationPlayer.play("setup")
	
	if reload:
		# show start planet
		camera.target = start_planet
	else:
		# show blackhole, then show start_planet
		peek_level()
		yield(tween, "tween_all_completed")
	
	
	moon.reset(start_planet)


func add_star(pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var star = .add_star(pos)
	star.connect("collected", $StarCounter, "collect_star", [star, star_count])
	star.connect("collected", self, "_on_star_collected", [star_count])
	star_count += 1
	return star


func peek_level():
	tween.stop_all()
	tween.remove_all()
	
	tween.interpolate_property(camera, "position", $StartPlanet.position, $BlackHole.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	tween.interpolate_property(camera, "position", $BlackHole.position, $StartPlanet.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2.0)
	
	tween.start()
	yield($Tween, "tween_all_completed")



func success():
	get_tree().call_group("gods", "reset")
	emit_signal("success")


var last_velocity: Vector2
var velocity_unchanged_time: float = 0
const MAX_VELOCITY_UNCHANGED = 0.5

# check for how long the velocity of the moon hasn't changed
# this is an indicator of if the moon is outside the range of any planet
func check_velocity_unchanged(delta):
	if moon.enabled and not moon.orbiting and last_velocity == moon.linear_velocity:
		velocity_unchanged_time += delta
	else:
		velocity_unchanged_time = 0
	
	last_velocity = moon.linear_velocity
	
	if velocity_unchanged_time > MAX_VELOCITY_UNCHANGED:
		if is_moon_heading_for_gravity_area():
			velocity_unchanged_time = 0
		else:
			moon.explode()


func is_moon_heading_for_gravity_area():
	print("check moon out of bounds")
	if moon.linear_velocity.length() < 0.5:
		return false
	else:
		print(moon.linear_velocity.length())
		
		var collisions = get_world_2d().direct_space_state.intersect_ray(moon.position, moon.position + moon.linear_velocity.normalized() * 100000, [], 0x7fffffff, false, true)
		return collisions.size() > 0


func _on_Moon_started_moving() -> void:
	$Tween.stop_all()
	camera.target = $Moon
	
	get_tree().call_group("gods", "disable")


func _on_Moon_started_orbiting(center: Node2D) -> void:
	if $Moon.enabled:
		camera.target = center
	
	get_tree().call_group("gods", "disable")



func _on_BlackHole_body_entered(body):
	if body == moon:
		success()


func _on_Moon_stationary():
	 get_tree().call_group("gods", "disable")


func _on_Moon_exploded():
	camera.target = null
	emit_signal("failure")


func _on_PlayableLevel_failure():
	save_progress()

func _on_PlayableLevel_success():
	finished = true
	save_progress()
	
func _on_star_collected(index: int):
	stars_collected.append(index)

func _on_Camera2D_target_reached():
	if camera.target != moon:
		camera.target = null

func _on_Moon_moving():
	get_tree().call_group("gods", "enable")
