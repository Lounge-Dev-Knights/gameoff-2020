extends PopupPanel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ESCButtonToggle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_EXCMenu_about_to_show():
	get_tree().paused = true


func _on_EXCMenu_popup_hide():
	get_tree().paused = false

func _on_MainMenuButton_pressed():
	SceneLoader.goto_scene("res://scenes/TitleScreen.tscn")

func _on_ResumeButton_pressed():
	self.hide()

func _on_QuitButton2_pressed():
	get_tree().quit()




