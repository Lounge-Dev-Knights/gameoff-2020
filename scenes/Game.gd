extends Node2D

onready var level = $PlayableLevel

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
	SceneLoader.goto_scene("res://scenes/title_screen/TitleScreen.tscn")
	SoundEngine.play_sound("MenuButtonSound")

