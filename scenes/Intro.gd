extends Control


func _input(event):
	if event.is_pressed():
		SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")


func play_whoosh():
	SoundEngine.play_sound("Reset")
