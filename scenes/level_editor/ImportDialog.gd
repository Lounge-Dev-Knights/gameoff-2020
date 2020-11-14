extends WindowDialog


signal level_imported


const CUSTOM_LEVELS_PATH = "user://levels/"



# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("HTML5"):
		$VBoxContainer/MarginContainer/VBoxContainer/SelectFile.hide()
		$VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2.hide()


func import_level(file_path: String) -> void:
	var dir = Directory.new()
	# var file_name = file_path.substr(file_path.find_last("/"))
	var file_name = file_path.get_file()
	
	var error = dir.copy(file_path, CUSTOM_LEVELS_PATH + file_name)
	print("export %s to %s. Error: %d" % [file_path, CUSTOM_LEVELS_PATH + file_name, error])


func _on_Close_pressed():
	hide()


func _on_FileDialog_file_selected(path):
	import_level(path)
	emit_signal("level_imported")
	hide()


func _on_TextEdit_text_changed():
	# TODO try to import level
	pass # Replace with function body.


func _on_BrowseFiles_pressed():
	$CanvasLayer/FileDialog.popup_centered()
