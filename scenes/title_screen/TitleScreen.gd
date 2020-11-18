extends Node2D

var current_index = 1

onready var level_selection = $CanvasLayer/VBoxContainer2/LevelSelection

func _ready():
	
	
	MusicEngine.play_sound("Music")
	
	level_selection.current_index = current_index
	
	if OS.has_feature("HTML5"):
		$CanvasLayer/VBoxContainer2/CenterContainer/Building/Exit.hide()

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
	if $CanvasLayer/VBoxContainer2/CenterContainer/Building/VolumeSettings.visible == false:
		$CanvasLayer/VBoxContainer2/CenterContainer/Building/VolumeSettings.visible = true
	else:
		$CanvasLayer/VBoxContainer2/CenterContainer/Building/VolumeSettings.visible = false
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
