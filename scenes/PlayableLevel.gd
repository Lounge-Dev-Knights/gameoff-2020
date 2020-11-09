extends "res://scenes/BaseLevel.gd"


onready var tween = $Tween
onready var camera = $Camera2D


func _unhandled_input(event):
	if tween.is_active() and Input.is_action_just_pressed("shoot"):
		tween.stop_all()
		tween.remove_all()
		tween.interpolate_property(camera, "position", camera.position, Vector2(), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()


func load_data(level_data: Dictionary) -> void:
	.load_data(level_data)
	
	call_deferred("peek_level")


func peek_level():
	tween.stop_all()
	
	tween.interpolate_property(camera, "position", Vector2(), $BlackHole.position, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	tween.interpolate_property(camera, "position", $BlackHole.position, Vector2(), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 2.0)
	
	$Moon.enabled = false
	tween.start()
	yield($Tween, "tween_all_completed")
	$Moon.enabled = true



func _on_Moon_started_moving() -> void:
	$Tween.stop_all()
	camera.target = $Moon


func _on_Moon_started_orbiting(center: Node2D) -> void:
	camera.target = center
