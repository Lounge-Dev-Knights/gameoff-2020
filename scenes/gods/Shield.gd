extends Node2D

func reset() -> void:
	$Swords.modulate = Color(1,1,1,1)
	$Swords.scale = Vector2(0,0)

func enable() -> void:
	reset()
	show()
	print("spawning shield")
	print("modulate: ", modulate)
	$AnimationPlayer.play("spawn")
	
func disable() -> void:
	$AnimationPlayer.play("disappear")
	yield(get_tree().create_timer(0.5), "timeout")
	hide()
	

	
