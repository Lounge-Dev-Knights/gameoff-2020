extends Area2D

var type: String = "Star"


func _on_Star_body_entered(body):
	queue_free()
	SoundEngine.play_sound("Star")
