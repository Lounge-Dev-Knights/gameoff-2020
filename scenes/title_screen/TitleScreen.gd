extends Node2D



func _on_Play_pressed():
	SceneLoader.goto_scene("res://scenes/Game.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_Play_mouse_entered():
	$MenuButtonHoverSound.play()

func _on_TestLevel_pressed():
	SceneLoader.goto_scene("res://scenes/TestLevel.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_TestLevel_mouse_entered():
	$MenuButtonHoverSound.play()

func _on_LevelEditor_pressed():
	SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_LevelEditor_mouse_entered():
	$MenuButtonHoverSound.play()
	
func _on_Settings_pressed():
	SoundEngine.play_sound("MenuButtonSound")
	pass # Replace with function body.

func _on_Settings_mouse_entered():
	$MenuButtonHoverSound.play()
	pass #
	
func _on_Exit_pressed():
	get_tree().quit()
	SoundEngine.play_sound("MenuButtonSound")

func _on_Exit_mouse_entered():
	$MenuButtonHoverSound.play()
