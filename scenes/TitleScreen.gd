extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass



func _on_TestLevel_pressed():
	get_tree().change_scene("res://scenes/TestLevel.tscn")


func _on_LevelEditor_pressed():
	get_tree().change_scene("res://scenes/level_editor/LevelEditor.tscn")


func _on_Quit_pressed():
	get_tree().quit()
