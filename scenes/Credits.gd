extends Control


func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)


func _on_Button_pressed():
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
