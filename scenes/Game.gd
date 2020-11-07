extends Node2D

onready var level = $PlayableLevel


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://scenes/levels/test_level.json", File.READ)
	var level_data = parse_json(file.get_as_text())
	level.load_level(level_data)


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
	
	$CanvasLayer.add_child(dialog)
	dialog.popup_centered()
	
	var path = yield(dialog, "file_selected")
	var file = File.new()
	file.open(path, File.READ)
	var level_data = parse_json(file.get_as_text())
	dialog.queue_free()
	level.load_level(level_data)
	
