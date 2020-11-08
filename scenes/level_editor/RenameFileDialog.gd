extends ConfirmationDialog

onready var error = $HBoxContainer2/Label

var ok_button: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	ok_button = get_ok()
	ok_button.disabled = true


func _on_LineEdit_text_changed(new_text):
	var dir = Directory.new()
	var file_exists = dir.file_exists("user://levels/%s.json" % new_text)
	ok_button.disabled = file_exists
	error.text = "File already exists" if file_exists else ""
