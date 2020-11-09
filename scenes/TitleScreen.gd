extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

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

func _on_Quit_pressed():
	get_tree().quit()
	SoundEngine.play_sound("MenuButtonSound")

func _on_Quit_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
