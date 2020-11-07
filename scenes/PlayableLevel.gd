extends "res://scenes/BaseLevel.gd"


onready var tween = $Tween
onready var camera = $Camera2D



func load_level(level_data: Dictionary) -> void:
	.load_level(level_data)
	
	call_deferred("peek_level")


func peek_level():
	tween.interpolate_property(camera, "position", camera.position, $BlackHole.position, 3.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	tween.interpolate_property(camera, "position", $BlackHole.position, camera.position, 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 4.0)
	
	tween.start()

