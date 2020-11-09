extends "res://scenes/BaseLevel.gd"


onready var tween = $Tween
onready var camera = $Camera2D



func load_data(level_data: Dictionary) -> void:
	.load_data(level_data)
	
	call_deferred("peek_level")


func peek_level():
	tween.stop_all()
	
	tween.interpolate_property(camera, "position", Vector2(), $BlackHole.position, 3.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	tween.interpolate_property(camera, "position", $BlackHole.position, Vector2(), 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 4.0)
	
	tween.start()



func _on_Moon_started_moving() -> void:
	print("started moving")
	camera.target = $Moon


func _on_Moon_started_orbiting(center: Node2D) -> void:
	camera.target = center
