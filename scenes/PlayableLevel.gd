extends "res://scenes/BaseLevel.gd"


onready var tween = $Tween
onready var camera = $Camera2D


func _unhandled_input(event):
	if tween.is_active() and Input.is_action_just_pressed("shoot"):
		show_start()


func load_data(level_data: Dictionary, reload: bool = false) -> void:
	.load_data(level_data)
	
	if reload:
		show_start()
	else:
		peek_level()


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
	
	tween.interpolate_property(camera, "position", camera.position, $StartPlanet.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	
	$Moon.enabled = true
	tween.start()


func _on_Moon_started_moving() -> void:
	$Tween.stop_all()
	camera.target = $Moon


func _on_Moon_started_orbiting(center: Node2D) -> void:
	if $Moon.enabled:
		camera.target = center
