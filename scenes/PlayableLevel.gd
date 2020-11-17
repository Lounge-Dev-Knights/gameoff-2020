extends "res://scenes/BaseLevel.gd"


signal success
signal failure


onready var tween = $Tween
onready var camera = $Camera2D


var stars_collected = 0
var tries = 0

var finished = false
var level_name = 'Level 1'
var level_num = 1

enum LevelState {
	LOCKED,
	UNLOCKED,
	COMPLETED
}


func _unhandled_input(event):
	if tween.is_active() and Input.is_action_just_pressed("shoot"):
		show_start()


func save_progress():
	# load progress first
	var progress_path = "user://progress.json"
	var file = File.new()
	var err = file.open(progress_path, File.READ)
	var progress = parse_json(file.get_as_text())
	file.close()
	
	if not progress:
		progress = Dictionary()
	if not progress.has(str(level_num)):
		progress[str(level_num)] = Dictionary()
	
	var level_progress = progress[str(level_num)]
	
	level_progress["level_name"] = level_name
	
	# if finished, set stars and unlock next level
	if finished:
		level_progress["state"] = LevelState.COMPLETED
		if not progress.has(str(level_num + 1)):
			progress[str(level_num + 1)] = Dictionary()
		progress[str(level_num + 1)]["state"] = LevelState.UNLOCKED
		
		if level_progress.has("stars_collected"):
			if level_progress["stars_collected"] < stars_collected:
				level_progress["stars_collected"] = stars_collected
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
	star_count = 0
	stars_collected = 0
	.load_data(level_data)
	if level_data.has("level_name"):
		level_name = level_data["level_name"]
	moon.position = start_planet.position
	$Fortuna.reset()
	$StarCounter.num_stars = star_count
	
	$AnimationPlayer.play("setup")
	
	if reload:
		show_start()
	else:
		peek_level()
		
	yield(tween, "tween_all_completed")
	$Moon.reset(start_planet)


func add_star(pos: Vector2 = Vector2(0, 0)) -> Node2D:
	var star = .add_star(pos)
	star.connect("collected", $StarCounter, "collect_star", [star, star_count])
	star.connect("collected", self, "_on_star_collected")
	star_count += 1
	return star


func peek_level():
	tween.stop_all()
	tween.remove_all()
	
	tween.interpolate_property(camera, "position", $StartPlanet.position, $BlackHole.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	tween.interpolate_property(camera, "position", $BlackHole.position, $StartPlanet.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2.0)
	
	$Moon.enabled = false
	tween.start()
	yield($Tween, "tween_all_completed")
	$Moon.enabled = true


func show_start():
	tween.stop_all()
	tween.remove_all()
	
	tween.interpolate_property(camera, "position", camera.position, $StartPlanet.position, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	
	$Moon.enabled = true
	tween.start()
	

func success():
	$Fortuna.enabled = false
	$Fortuna.reset()
	emit_signal("success")


func _on_Moon_started_moving() -> void:
	$Tween.stop_all()
	camera.target = $Moon
	
	$Fortuna.enabled = true


func _on_Moon_started_orbiting(center: Node2D) -> void:
	if $Moon.enabled:
		camera.target = center
	
	$Fortuna.enabled = false



func _on_BlackHole_body_entered(body):
	if body == moon:
		success()


func _on_Moon_stationary():
	$Fortuna.enabled = false


func _on_BlackHole_body_exited(body):
	print("blackhole exit")


func _on_Moon_exploded():
	emit_signal("failure")


func _on_PlayableLevel_failure():

	save_progress()


func _on_PlayableLevel_success():
	finished = true
	save_progress()
	
func _on_star_collected():
	stars_collected += 1
