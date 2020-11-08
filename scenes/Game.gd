extends Node2D

onready var level = $PlayableLevel

var level_path: String = "res://scenes/levels/test_level.json"


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open(level_path, File.READ)
	var level_data = parse_json(file.get_as_text())
	level.load_data(level_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event):
	if Input.is_action_just_pressed("reset"):
		load_level()
		

func load_level():
	var dialog = FileDialog.new()
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.resizable = true
	dialog.access = FileDialog.ACCESS_USERDATA
	dialog.current_dir = "user://levels"
	
	$CanvasLayer.add_child(dialog)
	dialog.popup_centered()
	
	var path = yield(dialog, "file_selected")
	var file = File.new()
	file.open(path, File.READ)
	var level_data = parse_json(file.get_as_text())
	dialog.queue_free()
	level.load_data(level_data)
	


func _on_Back_pressed():
	SceneLoader.goto_scene("res://scenes/TitleScreen.tscn")
