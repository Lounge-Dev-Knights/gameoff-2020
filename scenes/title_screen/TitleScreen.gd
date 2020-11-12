extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().connect("size_changed", self, "_viewport_size_changed")

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
	print(sound_vol)
