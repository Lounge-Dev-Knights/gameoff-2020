extends Control


func _unhandled_input(event):
	if event.is_pressed():
		SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
