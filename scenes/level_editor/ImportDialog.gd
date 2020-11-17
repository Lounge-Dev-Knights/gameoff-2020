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


func import_base64(data: String) -> int:
	var err := OK
	var level_data_string = Marshalls.base64_to_utf8(data) 
	
	var level_data_json = parse_json(level_data_string)
	
	if level_data_json != null:
		var dir = Directory.new()
		var level_name = "Imported level "
		
		if level_data_json.has("level_name"):
			if not dir.file_exists(CUSTOM_LEVELS_PATH + level_data_json["level_name"] + ".json"):
				level_name =  level_data_json["level_name"]
			else:
				return ERR_ALREADY_EXISTS
		else:
			var i = 1
			while dir.file_exists(CUSTOM_LEVELS_PATH + "Imported level " + str(i) + ".json"):
				i += 1
			level_name = level_name + str(i)
		
		var file = File.new()
		err = file.open(CUSTOM_LEVELS_PATH + level_name + ".json", File.WRITE)
		
		if err == OK:
			file.store_string(level_data_string)
	else:
		err = ERR_INVALID_DATA
	
	return err

func _on_Close_pressed():
	hide()


func _on_FileDialog_file_selected(path):
	import_level(path)
	emit_signal("level_imported")
	hide()


func _on_TextEdit_text_changed():
	var err = import_base64($VBoxContainer/MarginContainer/VBoxContainer/TextEdit.text)
	if err == OK:
		emit_signal("level_imported")
		hide()


func _on_BrowseFiles_pressed():
	$CanvasLayer/FileDialog.popup_centered()


func _on_ImportDialog_about_to_show():
	$VBoxContainer/MarginContainer/VBoxContainer/TextEdit.text = ""
