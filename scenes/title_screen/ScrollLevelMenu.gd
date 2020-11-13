extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var levels = 6 #get amount of levels from level editor or from levels in game folder
var i = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _add_buttons():
	for i in levels:
		var newButton = Button.new()
		$HBoxContainer.add_child(newButton)
		newButton.emit_signal("pressed")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MenuItem1_Button_pressed():
	SceneLoader.goto_scene("res://scenes/Game.tscn")
	#load level	
	SoundEngine.play_sound("MenuButtonSound")

func _on_MenuItem1_Button_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")


func _on_MenuItem3_Button_pressed():
	SceneLoader.goto_scene("res://scenes/Game.tscn")
	#load level	
	SoundEngine.play_sound("MenuButtonSound")

func _on_MenuItem3_Button_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
