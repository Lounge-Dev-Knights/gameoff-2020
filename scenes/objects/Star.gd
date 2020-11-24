extends Area2D

signal collected(index)

var type: String = "Star"

func _ready() -> void:
	call_deferred("activate_label")
	

func activate_label():
	if get_tree().current_scene.name == "LevelEditor":
		set_index()
		$Index.show()
		get_tree().connect("tree_changed", self, "set_index")


func set_index():
	$Index.text = str(get_index())


func _on_Star_body_entered(body):
	#queue_free()
	SoundEngine.play_sound("Star")
	$CPUParticles2D.emitting = true
	emit_signal("collected")
