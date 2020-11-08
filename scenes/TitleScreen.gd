extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

func _on_Play_pressed():
	SceneLoader.goto_scene("res://scenes/Game.tscn")

func _on_TestLevel_pressed():
	SceneLoader.goto_scene("res://scenes/TestLevel.tscn")


func _on_LevelEditor_pressed():
	SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")


func _on_Quit_pressed():
	get_tree().quit()



