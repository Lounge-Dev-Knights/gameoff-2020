extends Node2D


onready var level = $PlayableLevel
onready var retry_panel = $CanvasLayer/RetryPanel
onready var success_panel = $CanvasLayer/SuccessPanel


var level_path: String = "res://scenes/levels/test_level.json"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_level()

func _unhandled_input(event):
	if Input.is_action_just_pressed("reset"):
		load_level(true)

func load_level(reload: bool = false):
	var file = File.new()
	file.open(level_path, File.READ)
	var level_data = parse_json(file.get_as_text())
	level.load_data(level_data, reload)
	


func _on_Back_pressed():
	if level_path.find("user://levels") == -1:
		SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
	else:
		SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
		
	SoundEngine.play_sound("MenuButtonSound")


func _on_Reset_pressed():
	retry_panel.hide()
	success_panel.hide()
	load_level(true)
	SoundEngine.play_sound("MenuButtonSound")


func _on_Titlescreen_pressed():
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
	SoundEngine.play_sound("MenuButtonSound")


func _on_PlayableLevel_failure():
	$CanvasLayer/RetryPanel.popup_centered()


func _on_PlayableLevel_success():
	$CanvasLayer/SuccessPanel.popup_centered()
	$CanvasLayer/Control/SuccessConfettiStars.emitting = true


func _on_Button_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
