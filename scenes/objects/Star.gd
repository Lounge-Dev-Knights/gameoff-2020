extends Area2D

signal collected

var type: String = "Star"


func _on_Star_body_entered(body):
	#queue_free()
	SoundEngine.play_sound("Star")
	$CPUParticles2D.emitting = true
	emit_signal("collected")
