extends Node2D

var current_index = 1

var last_command = ""

var stars = 0

onready var level_selection = $CanvasLayer/VBoxContainer2/LevelSelection
onready var god_selection = $CanvasLayer/GodSelection
onready var star_label = $CanvasLayer/VBoxContainer2/Stars/HBoxContainer/Label


func _ready():
	$CanvasLayer/LastCommand.text = last_command
	
	MusicEngine.play_sound("Music")
	
	level_selection.current_index = current_index

	god_selection.current_index = 1
	

	stars = god_selection.stars
	star_label.text = str(stars)

	if OS.has_feature("HTML5"):
		$CanvasLayer/VBoxContainer2/CenterContainer/Building/Exit.hide()

var command_input = ""


func _unhandled_key_input(event):
	if event.is_pressed() and not event.is_echo():
		command_input += event.as_text()
		
		check_command()


func check_command():
	if command_input.ends_with("RESETPROGRESS"):
		var dir = Directory.new()
		dir.remove("user://progress.json")
		SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn", {"last_command": "All progress has been resetted."})
	elif command_input.ends_with("UNLOCKALL"):
		unlock_all()
		SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn", {"last_command": "All levels have been unlocked."})


func unlock_all():
	# TODO: Kinda hacky... Progress stuff could be moved in to a separate class?
	var progress = $CanvasLayer/VBoxContainer2/LevelSelection.load_progress()
	for path in $CanvasLayer/VBoxContainer2/LevelSelection.DEFAULT_LEVEL_LIST:
		if not  progress.has(path):
			progress[path] = {
				"state": 1 # UNLOCKED
			}
	
	var file = File.new()
	file.open("user://progress.json", File.WRITE)
	file.store_string(to_json(progress))
	file.close()


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
	
func _on_Settings_pressed():
	if $CanvasLayer/VBoxContainer2/CenterContainer/Building/VolumeSettings.visible == false:
		$CanvasLayer/VBoxContainer2/CenterContainer/Building/VolumeSettings.visible = true
	else:
		$CanvasLayer/VBoxContainer2/CenterContainer/Building/VolumeSettings.visible = false
	SoundEngine.play_sound("MenuButtonSound")

func _on_Settings_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")
	
func _on_Exit_pressed():
	get_tree().quit()
	SoundEngine.play_sound("MenuButtonSound")

func _on_Exit_mouse_entered():
	SoundEngine.play_sound("MenuButtonHoverSound")

func _viewport_size_changed():
	var size = get_viewport_rect()
	$CanvasLayer/Control/CPUParticles2D.emission_rect_extents = size.size / 2
