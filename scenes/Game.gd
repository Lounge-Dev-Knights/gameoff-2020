extends Node2D


onready var level = $PlayableLevel
onready var retry_panel = $CanvasLayer/RetryPanel
onready var success_panel = $CanvasLayer/SuccessPanel
onready var next_button = $CanvasLayer/SuccessPanel/VBoxContainer/Next


var level_path: String = "res://scenes/levels/test_level.json"
var next_levels: Array = Array()
var selection_index = 1
var god = "Fortuna"

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("load_level")
	
	if len(next_levels) == 0:
		next_button.hide()


func _unhandled_input(_event):
	if Input.is_action_just_pressed("reset"):
		level.save_progress()
		load_level(true)


func load_level(reload: bool = false):
	var file = File.new()
	file.open(level_path, File.READ)
	var level_data = parse_json(file.get_as_text())
	level.level_path = level_path
	
	# load god
	level.god = god
	level.load_god()

	if not next_levels.find(level_path) == len(next_levels)-1:
		level.next_level_path = next_levels[next_levels.find(level_path)+1]
	level.load_data(level_data, reload)
	


func _on_Back_pressed():
	if level_path.find("user://levels") == -1:
		SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn", {"current_index": selection_index})
	else:
		SceneLoader.goto_scene("res://scenes/level_editor/CustomLevelsManager.tscn")
		
	SoundEngine.play_sound("MenuButtonSound")


func _on_Reset_pressed():
	$CanvasLayer/Back.show()
	retry_panel.hide()
	success_panel.hide()
	load_level(true)
	SoundEngine.play_sound("MenuButtonSound")


func _on_Titlescreen_pressed():
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn", {"current_index": selection_index})
	SoundEngine.play_sound("MenuButtonSound")


func _on_PlayableLevel_failure():
	$CanvasLayer/Back.hide()
	$CanvasLayer/RetryPanel.popup_centered()


func _on_PlayableLevel_success():
	$CanvasLayer/SuccessPanel.popup_centered()
	$CanvasLayer/Back.hide()
	$CanvasLayer/Control/SuccessConfettiStars.emitting = true


func _on_Button_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")


func _on_Next_pressed():
	success_panel.hide()
	level_path = next_levels.pop_front()

	load_level(false)
	
	
	
func _on_ToolButton_pressed() -> void:
	if $CanvasLayer/VBoxContainer/VolumeSettings.visible:
		$CanvasLayer/VBoxContainer/VolumeSettings.hide()
	else:
		$CanvasLayer/VBoxContainer/VolumeSettings.show()
