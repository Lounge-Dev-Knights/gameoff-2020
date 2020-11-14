extends Node2D

func _ready():
	MusicEngine.play_sound("Music")

func _on_Play_pressed():
	SceneLoader.goto_scene("res://scenes/Game.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_Play_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")

func _on_TestLevel_pressed():
	SceneLoader.goto_scene("res://scenes/TestLevel.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_TestLevel_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")

func _on_LevelEditor_pressed():
	SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
	SoundEngine.play_sound("MenuButtonSound")

func _on_LevelEditor_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
	
func _on_Settings_pressed():
	if $CanvasLayer/Volume.visible == false:
		$CanvasLayer/Volume.visible = true
	else:
		$CanvasLayer/Volume.visible = false
	SoundEngine.play_sound("MenuButtonSound")

func _on_Settings_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
	
func _on_Exit_pressed():
	get_tree().quit()
	SoundEngine.play_sound("MenuButtonSound")

func _on_Exit_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")

func _viewport_size_changed():
	var size = get_viewport_rect()
	$CanvasLayer/Control/CPUParticles2D.emission_rect_extents = size.size / 2




func _on_Sound_value_changed(value):
	var sound_vol = AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Vol"),value)

func _on_Sound_mouse_entered():
	$SoundVolCheck.play()

func _on_Sound_mouse_exited():
	$SoundVolCheck.stop()

func _on_Music_value_changed(value):
	var sound_vol = AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music Vol"),value)
